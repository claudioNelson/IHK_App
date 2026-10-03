// Zugriff auf das unveraenderliche Dateisystem: suchen (mit Rechtepruefung
// auf dem Weg), anlegen, ersetzen, entfernen.

import { gruppenVon, homeVon } from "./benutzer";
import { elternpfad, normalisiere, teile } from "./pfade";
import { darf } from "./rechte";
import type { Datei, Knoten, Ordner, Zustand } from "./typen";

export type Grund = "fehlt" | "keinOrdner" | "verweigert" | "zuLang";

export type Fund = { ok: true; knoten: Knoten; pfad: string } | { ok: false; grund: Grund };

/**
 * Sucht einen absoluten Pfad. Auf jedem Ordner auf dem Weg braucht der
 * Benutzer das x-Recht (wie unter Linux). Ein "/" am Ende verlangt einen Ordner.
 */
export function finde(z: Zustand, pfad: string): Fund {
  if (pfad === "") return { ok: false, grund: "fehlt" };
  if (zuLang(pfad)) return { ok: false, grund: "zuLang" };
  const norm = normalisiere(pfad);
  let knoten: Knoten = z.wurzel;
  for (const name of teile(norm)) {
    if (knoten.art !== "ordner") return { ok: false, grund: "keinOrdner" };
    if (!darf(knoten, z.benutzer, "x")) return { ok: false, grund: "verweigert" };
    const kind: Knoten | undefined = knoten.kinder[name];
    if (!kind) return { ok: false, grund: "fehlt" };
    knoten = kind;
  }
  if (pfad.length > 1 && pfad.endsWith("/") && knoten.art !== "ordner") {
    return { ok: false, grund: "keinOrdner" };
  }
  return { ok: true, knoten, pfad: norm };
}

/** Grenzen wie unter Linux: Name hoechstens 255, Pfad hoechstens 4095 Zeichen (ENAMETOOLONG). */
export function zuLang(pfad: string): boolean {
  return pfad.length > 4095 || teile(pfad).some((t) => t.length > 255);
}

/** Sucht ohne Rechtepruefung (fuer Aufgabenpruefung und Tests). */
export function knotenBei(wurzel: Ordner, pfad: string): Knoten | undefined {
  let knoten: Knoten = wurzel;
  for (const name of teile(normalisiere(pfad))) {
    if (knoten.art !== "ordner") return undefined;
    const kind: Knoten | undefined = knoten.kinder[name];
    if (!kind) return undefined;
    knoten = kind;
  }
  return knoten;
}

/**
 * Prueft, ob unter pfad etwas angelegt (oder dort entfernt) werden darf:
 * Elternordner muss existieren, Ordner sein und w+x erlauben.
 */
export function pruefeEltern(z: Zustand, pfad: string): { ok: true; eltern: Ordner } | { ok: false; grund: Grund } {
  if (pfad === "") return { ok: false, grund: "fehlt" };
  if (zuLang(pfad)) return { ok: false, grund: "zuLang" };
  const fund = finde(z, elternpfad(pfad));
  if (!fund.ok) return fund;
  if (fund.knoten.art !== "ordner") return { ok: false, grund: "keinOrdner" };
  if (!darf(fund.knoten, z.benutzer, "w") || !darf(fund.knoten, z.benutzer, "x")) {
    return { ok: false, grund: "verweigert" };
  }
  return { ok: true, eltern: fund.knoten };
}

/**
 * Ersetzt den Knoten unter pfad (oder legt ihn an). Elternordner muss existieren.
 * elternStempeln=false: Zeit des Elternordners bleibt (Inhalt oder Rechte einer
 * vorhandenen Datei aendern, wie unter Linux).
 */
export function setze(wurzel: Ordner, pfad: string, neu: Knoten, jetzt: Date, elternStempeln = true): Ordner {
  const namen = teile(normalisiere(pfad));
  if (namen.length === 0) {
    if (neu.art !== "ordner") throw new Error("Wurzel muss ein Ordner sein");
    return neu;
  }
  const rekursiv = (ordner: Ordner, i: number): Ordner => {
    const name = namen[i];
    if (i === namen.length - 1) {
      return { ...ordner, geaendert: elternStempeln ? jetzt : ordner.geaendert, kinder: { ...ordner.kinder, [name]: neu } };
    }
    const kind = ordner.kinder[name];
    if (!kind || kind.art !== "ordner") throw new Error(`Ordner fehlt: ${name}`);
    return { ...ordner, kinder: { ...ordner.kinder, [name]: rekursiv(kind, i + 1) } };
  };
  return rekursiv(wurzel, 0);
}

/** Entfernt den Knoten unter pfad (samt Inhalt). */
export function entferne(wurzel: Ordner, pfad: string, jetzt: Date): Ordner {
  const namen = teile(normalisiere(pfad));
  if (namen.length === 0) throw new Error("Wurzel kann nicht entfernt werden");
  const rekursiv = (ordner: Ordner, i: number): Ordner => {
    const name = namen[i];
    if (i === namen.length - 1) {
      const kinder = { ...ordner.kinder };
      delete kinder[name];
      return { ...ordner, geaendert: jetzt, kinder };
    }
    const kind = ordner.kinder[name];
    if (!kind || kind.art !== "ordner") throw new Error(`Ordner fehlt: ${name}`);
    return { ...ordner, kinder: { ...ordner.kinder, [name]: rekursiv(kind, i + 1) } };
  };
  return rekursiv(wurzel, 0);
}

/** Hauptgruppe eines Benutzers (unter Ubuntu gleichnamig). */
function hauptgruppe(benutzer: string): string {
  const gruppen = gruppenVon(benutzer);
  return gruppen.includes(benutzer) ? benutzer : gruppen[0];
}

/**
 * Neue Datei des aktuellen Benutzers. Rechte wie unter Ubuntu (umask 002 fuer
 * normale Benutzer, 022 fuer root): 664 bzw. 644.
 */
export function neueDatei(z: Zustand, inhalt: string, jetzt: Date): Datei {
  return {
    art: "datei",
    inhalt,
    besitzer: z.benutzer,
    gruppe: hauptgruppe(z.benutzer),
    rechte: z.benutzer === "root" ? 0o644 : 0o664,
    geaendert: jetzt,
  };
}

/** Neuer leerer Ordner des aktuellen Benutzers: 775 bzw. 755 (root). */
export function neuerOrdner(z: Zustand, jetzt: Date): Ordner {
  return {
    art: "ordner",
    kinder: {},
    besitzer: z.benutzer,
    gruppe: hauptgruppe(z.benutzer),
    rechte: z.benutzer === "root" ? 0o755 : 0o775,
    geaendert: jetzt,
  };
}

/** Tiefe Kopie fuer cp: neuer Besitzer und neue Zeit, Rechte bleiben. */
export function kopie(knoten: Knoten, z: Zustand, jetzt: Date): Knoten {
  const meta = { besitzer: z.benutzer, gruppe: hauptgruppe(z.benutzer), rechte: knoten.rechte & 0o777, geaendert: jetzt };
  if (knoten.art === "datei") return { ...knoten, ...meta };
  const kinder: Record<string, Knoten> = {};
  for (const [name, kind] of Object.entries(knoten.kinder)) kinder[name] = kopie(kind, z, jetzt);
  return { art: "ordner", kinder, ...meta };
}

/** Kindnamen eines Ordners, sortiert wie ls unter Ubuntu (Gross/klein egal, Punkt am Anfang zaehlt nicht). */
export function sortiereNamen(namen: string[]): string[] {
  const schluessel = (n: string) => n.replace(/^\.+/, "").toLowerCase();
  return [...namen].sort((a, b) => {
    const ka = schluessel(a);
    const kb = schluessel(b);
    if (ka < kb) return -1;
    if (ka > kb) return 1;
    return a < b ? -1 : a > b ? 1 : 0;
  });
}

/** Home-Ordner des aktuellen Benutzers. */
export function home(z: Zustand): string {
  return homeVon(z.benutzer);
}
