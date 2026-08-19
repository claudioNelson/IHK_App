// supabase/functions/telegram-bot/play.ts
//
// Holt die Play-Store-Installationszahlen.
//
// WICHTIG: Installationszahlen gibt es NICHT ueber die Play Developer API
// (die kann nur Kaeufe/Abos, das nutzt verify-purchase). Play legt sie als
// CSV-Report in einem Google-Cloud-Storage-Bucket ab, den man auslesen muss.
//
// Voraussetzungen:
//   Secret GOOGLE_PLAY_SERVICE_ACCOUNT  (existiert bereits, JSON des Dienstkontos)
//   Secret PLAY_REPORT_BUCKET           (neu, z.B. pubsite_prod_1234567890)
//   Das Dienstkonto braucht in der Play Console zusaetzlich das Recht
//   "View app information and download bulk reports".
//
// Die Reports haengen rund zwei Tage hinterher — das ist bei Google so,
// daran laesst sich nichts drehen. Deshalb wird das Datum mit ausgegeben.

const PACKAGE_NAME = "app.lernarena";

export interface PlayStats {
  stand: string; // Datum der juengsten Zeile im Report
  aktiv: number; // Active Device Installs (= "Installed audience")
  installs7: number; // Neuinstallationen letzte 7 Reporttage
  uninstalls7: number; // Deinstallationen letzte 7 Reporttage
  top: Array<{ land: string; aktiv: number }>;
}

// ─── base64url ───────────────────────────────────────────────────────────────
function b64url(input: string | Uint8Array): string {
  const str = typeof input === "string"
    ? btoa(input)
    : btoa(String.fromCharCode(...input));
  return str.replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
}

// ─── Zugriffstoken fuer Cloud Storage (Lesen) ────────────────────────────────
async function getAccessToken(
  sa: { client_email: string; private_key: string },
): Promise<string> {
  const now = Math.floor(Date.now() / 1000);
  const header = b64url(JSON.stringify({ alg: "RS256", typ: "JWT" }));
  const claims = b64url(JSON.stringify({
    iss: sa.client_email,
    scope: "https://www.googleapis.com/auth/devstorage.read_only",
    aud: "https://oauth2.googleapis.com/token",
    iat: now,
    exp: now + 3600,
  }));
  const unsigned = `${header}.${claims}`;

  const pem = sa.private_key
    .replace("-----BEGIN PRIVATE KEY-----", "")
    .replace("-----END PRIVATE KEY-----", "")
    .replace(/\s/g, "");
  const keyBytes = Uint8Array.from(atob(pem), (c) => c.charCodeAt(0));
  const key = await crypto.subtle.importKey(
    "pkcs8",
    keyBytes,
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["sign"],
  );
  const sig = new Uint8Array(
    await crypto.subtle.sign(
      "RSASSA-PKCS1-v1_5",
      key,
      new TextEncoder().encode(unsigned),
    ),
  );

  const res = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: `${unsigned}.${b64url(sig)}`,
    }),
  });
  if (!res.ok) {
    throw new Error(`Google OAuth ${res.status}: ${await res.text()}`);
  }
  return (await res.json()).access_token;
}

// ─── CSV-Zeile zerlegen (mit Anfuehrungszeichen) ─────────────────────────────
function splitCsvLine(line: string): string[] {
  const felder: string[] = [];
  let aktuell = "";
  let inQuotes = false;

  for (let i = 0; i < line.length; i++) {
    const c = line[i];
    if (c === '"') {
      if (inQuotes && line[i + 1] === '"') {
        aktuell += '"';
        i++;
      } else {
        inQuotes = !inQuotes;
      }
    } else if (c === "," && !inQuotes) {
      felder.push(aktuell);
      aktuell = "";
    } else {
      aktuell += c;
    }
  }
  felder.push(aktuell);
  return felder.map((f) => f.trim());
}

// ─── Auflisten, welche Report-Dateien wirklich im Bucket liegen ──────────────
export interface ReportDatei {
  name: string;
  updated: string;
  size: number;
}

async function listeReports(
  bucket: string,
  token: string,
): Promise<ReportDatei[]> {
  const prefix = `stats/installs/installs_${PACKAGE_NAME}_`;
  const url = `https://storage.googleapis.com/storage/v1/b/${
    encodeURIComponent(bucket)
  }/o?prefix=${encodeURIComponent(prefix)}&maxResults=200`;

  const res = await fetch(url, { headers: { Authorization: `Bearer ${token}` } });
  if (!res.ok) {
    throw new Error(`Storage list ${res.status}: ${(await res.text()).slice(0, 200)}`);
  }

  const daten = await res.json();
  return (daten.items ?? [])
    .map((o: { name: string; updated: string; size: string }) => ({
      name: o.name,
      updated: o.updated,
      size: Number(o.size ?? 0),
    }))
    .sort((a: ReportDatei, b: ReportDatei) => a.name.localeCompare(b.name));
}

/** Was liegt im Bucket? Fuer /play debug. */
export async function ladePlayDebug(): Promise<ReportDatei[] | null> {
  const bucket = Deno.env.get("PLAY_REPORT_BUCKET");
  const saRaw = Deno.env.get("GOOGLE_PLAY_SERVICE_ACCOUNT");
  if (!bucket || !saRaw) return null;

  const token = await getAccessToken(JSON.parse(saRaw));
  return await listeReports(bucket, token);
}

// ─── Eine Report-Datei aus dem Bucket holen ──────────────────────────────────
async function ladeObjekt(
  bucket: string,
  token: string,
  objekt: string,
): Promise<string[][] | null> {
  const url = `https://storage.googleapis.com/storage/v1/b/${
    encodeURIComponent(bucket)
  }/o/${encodeURIComponent(objekt)}?alt=media`;

  const res = await fetch(url, {
    headers: { Authorization: `Bearer ${token}` },
  });

  if (res.status === 404) return null; // Monat existiert (noch) nicht
  if (!res.ok) {
    throw new Error(`Storage ${res.status}: ${(await res.text()).slice(0, 200)}`);
  }

  // Play liefert diese CSVs als UTF-16LE mit BOM — nicht als UTF-8.
  const text = new TextDecoder("utf-16le").decode(await res.arrayBuffer());

  return text
    .split(/\r?\n/)
    .filter((z) => z.trim().length > 0)
    .map(splitCsvLine);
}

/** Spaltenindex ueber einen Teil des Spaltennamens finden. */
function spalte(kopf: string[], suche: string): number {
  const s = suche.toLowerCase();
  return kopf.findIndex((k) => k.toLowerCase().replace(/^﻿/, "").includes(s));
}

function zahl(wert: string | undefined): number {
  const n = Number((wert ?? "").replace(/[^\d-]/g, ""));
  return Number.isFinite(n) ? n : 0;
}

// ─── Hauptfunktion ───────────────────────────────────────────────────────────
export async function ladePlayStats(): Promise<PlayStats | null> {
  const bucket = Deno.env.get("PLAY_REPORT_BUCKET");
  const saRaw = Deno.env.get("GOOGLE_PLAY_SERVICE_ACCOUNT");
  if (!bucket || !saRaw) return null; // nicht konfiguriert -> still ueberspringen

  const sa = JSON.parse(saRaw);
  const token = await getAccessToken(sa);

  // NICHT nach Kalender raten, welcher Monat aktuell ist — sondern nehmen,
  // was tatsaechlich im Bucket liegt. Die letzten beiden Monatsdateien
  // reichen, damit ein 7-Tage-Fenster ueber den Monatswechsel funktioniert.
  const dateien = (await listeReports(bucket, token))
    .filter((d) => d.name.endsWith("_country.csv") && d.size > 0)
    .slice(-2);

  if (dateien.length === 0) return null;

  const teile = await Promise.all(
    dateien.map((d) => ladeObjekt(bucket, token, d.name)),
  );

  let kopf: string[] | null = null;
  const zeilen: string[][] = [];
  for (const teil of teile) {
    if (!teil || teil.length < 2) continue;
    if (!kopf) kopf = teil[0];
    zeilen.push(...teil.slice(1));
  }
  if (!kopf || zeilen.length === 0) return null;

  const iDatum = spalte(kopf, "date");
  const iLand = spalte(kopf, "country");
  const iAktiv = spalte(kopf, "active device installs");
  const iInst = spalte(kopf, "daily device installs");
  const iUninst = spalte(kopf, "daily device uninstalls");

  if (iDatum < 0 || iAktiv < 0) {
    throw new Error(`Unerwartete Spalten im Report: ${kopf.join(" | ")}`);
  }

  // Juengstes Datum im Report
  const stand = zeilen
    .map((z) => z[iDatum])
    .filter(Boolean)
    .sort()
    .at(-1)!;

  // Bestand am juengsten Tag, ueber alle Laender summiert
  const letzteZeilen = zeilen.filter((z) => z[iDatum] === stand);
  const aktiv = letzteZeilen.reduce((s, z) => s + zahl(z[iAktiv]), 0);

  // 7-Tage-Fenster ab dem juengsten Datum
  const grenze = new Date(stand);
  grenze.setUTCDate(grenze.getUTCDate() - 6);
  const grenzeStr = grenze.toISOString().slice(0, 10);

  const fenster = zeilen.filter((z) => z[iDatum] >= grenzeStr && z[iDatum] <= stand);
  const installs7 = iInst >= 0 ? fenster.reduce((s, z) => s + zahl(z[iInst]), 0) : 0;
  const uninstalls7 = iUninst >= 0
    ? fenster.reduce((s, z) => s + zahl(z[iUninst]), 0)
    : 0;

  // Top-Laender am juengsten Tag
  const top = iLand >= 0
    ? letzteZeilen
      .map((z) => ({ land: z[iLand] || "?", aktiv: zahl(z[iAktiv]) }))
      .filter((e) => e.aktiv > 0)
      .sort((a, b) => b.aktiv - a.aktiv)
      .slice(0, 3)
    : [];

  return { stand, aktiv, installs7, uninstalls7, top };
}
