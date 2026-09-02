// supabase/functions/notify-signup/index.ts
//
// Meldet neue Registrierungen per Telegram — inkl. aktueller Nutzerzahlen.
//
// Aufgerufen wird die Function NICHT aus der App, sondern aus Postgres:
// Trigger `on_auth_user_created_notify` auf auth.users -> pg_net -> diese Function.
// Deshalb gibt es keinen User-JWT. Deploy mit --no-verify-jwt, Schutz laeuft
// ueber den Shared-Secret-Header `x-signup-secret`.
//
// Google-Testgeraete-Erkennung (26.08.2026): Nach jedem Play-Store-Upload
// startet Google die App automatisch auf Testgeraeten (Pre-Launch-Report /
// Review). Jedes Geraet erzeugt einen neuen Gast -> Fehlalarm-Welle.
// Die Function holt darum die Session-IP (RPC get_signup_ip, Migration
// 20260826120000) und markiert Signups aus Google-IP-Bereichen als
// "Google-Testgeraet" statt "Neuer Gast".
//
// Benoetigte Supabase Secrets:
//   TELEGRAM_BOT_TOKEN      (existiert bereits, siehe report-bug)
//   TELEGRAM_ADMIN_CHAT_ID  (existiert bereits, siehe report-bug)
//   NOTIFY_SIGNUP_SECRET    (derselbe Wert steht in der Migration)
// SUPABASE_URL + SUPABASE_SERVICE_ROLE_KEY werden automatisch injiziert.

import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

const TELEGRAM_BOT_TOKEN = Deno.env.get("TELEGRAM_BOT_TOKEN");
const TELEGRAM_ADMIN_CHAT_ID = Deno.env.get("TELEGRAM_ADMIN_CHAT_ID");
const NOTIFY_SIGNUP_SECRET = Deno.env.get("NOTIFY_SIGNUP_SECRET");
const SUPABASE_URL = Deno.env.get("SUPABASE_URL");
const SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

interface Stats {
  total?: number;
  today?: number;
  premium?: number;
  active7?: number;
}

interface Payload {
  user_id?: string;
  email?: string | null;
  provider?: string | null;
  is_anonymous?: boolean;
  created_at?: string | null;
  stats?: Stats;
}

// Google-eigene IPv4-Bereiche (Crawler/Testgeraete-Infrastruktur).
// Bewusst OHNE Google-Cloud-Bereiche, damit echte Nutzer hinter
// GCP-VPNs nicht faelschlich markiert werden.
const GOOGLE_CIDRS: Array<[string, number]> = [
  ["64.233.160.0", 19],
  ["66.102.0.0", 20],
  ["66.249.64.0", 19],
  ["72.14.192.0", 18],
  ["74.125.0.0", 16],
  ["108.177.0.0", 17],
  ["142.250.0.0", 15],
  ["172.217.0.0", 16],
  ["173.194.0.0", 16],
  ["209.85.128.0", 17],
  ["216.58.192.0", 19],
  ["216.239.32.0", 19],
];

// Google-eigene IPv6-Praefixe.
const GOOGLE_IPV6_PREFIXES = [
  "2001:4860:",
  "2404:6800:",
  "2607:f8b0:",
  "2800:3f0:",
  "2a00:1450:",
  "2c0f:fb50:",
];

function ipv4ToInt(ip: string): number | null {
  const parts = ip.split(".");
  if (parts.length !== 4) return null;
  let out = 0;
  for (const p of parts) {
    const n = Number(p);
    if (!Number.isInteger(n) || n < 0 || n > 255) return null;
    out = out * 256 + n;
  }
  return out;
}

function istGoogleIp(ip: string | null): boolean {
  if (!ip) return false;
  // auth.sessions.ip kommt teils mit Netzmaske ("108.177.24.190/32").
  // Ohne dieses Abschneiden lief Number("190/32") auf NaN und die
  // Erkennung meldete faelschlich "kein Google".
  const sauber = ip.trim().toLowerCase().split("/")[0];
  if (sauber.includes(":")) {
    return GOOGLE_IPV6_PREFIXES.some((p) => sauber.startsWith(p));
  }
  const wert = ipv4ToInt(sauber);
  if (wert === null) return false;
  return GOOGLE_CIDRS.some(([netz, bits]) => {
    const netzWert = ipv4ToInt(netz);
    if (netzWert === null) return false;
    const maske = bits === 0 ? 0 : (~0 << (32 - bits)) >>> 0;
    return ((wert & maske) >>> 0) === ((netzWert & maske) >>> 0);
  });
}

/** Session-IP des neuen Nutzers holen (RPC, nur service_role). */
async function holeSignupIp(userId: string): Promise<string | null> {
  if (!SUPABASE_URL || !SERVICE_ROLE_KEY) return null;
  for (let versuch = 0; versuch < 2; versuch++) {
    try {
      const res = await fetch(`${SUPABASE_URL}/rest/v1/rpc/get_signup_ip`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          apikey: SERVICE_ROLE_KEY,
          Authorization: `Bearer ${SERVICE_ROLE_KEY}`,
        },
        body: JSON.stringify({ p_user_id: userId }),
      });
      if (res.ok) {
        const ip = (await res.json()) as string | null;
        if (ip) return ip;
      }
    } catch (e) {
      console.warn("notify-signup: get_signup_ip fehlgeschlagen", e);
    }
    // Session kann Sekundenbruchteile nach dem User entstehen -> kurz warten
    if (versuch === 0) await new Promise((r) => setTimeout(r, 1500));
  }
  return null;
}

/** HTML-Sonderzeichen fuer Telegram parse_mode=HTML entschaerfen. */
function esc(value: unknown): string {
  return String(value ?? "")
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;");
}

/** 1234 -> "1.234" */
function num(value: number | undefined): string {
  return typeof value === "number" ? value.toLocaleString("de-DE") : "?";
}

function buildMessage(p: Payload, ip: string | null, google: boolean): string {
  const s = p.stats ?? {};
  const isGuest = p.is_anonymous === true;

  const zeit = new Date(p.created_at ?? Date.now()).toLocaleString("de-DE", {
    timeZone: "Europe/Berlin",
    day: "2-digit",
    month: "2-digit",
    year: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });

  const kopf = google
    ? "🤖 <b>Google-Testgerät</b> (automatischer App-Test nach Upload)"
    : isGuest
      ? "🧪 <b>Neuer Gast</b> (anonym ausprobiert)"
      : "🎉 <b>Neue Registrierung</b>";

  const wer = isGuest
    ? `<code>${esc(p.user_id)}</code>`
    : `<b>${esc(p.email ?? "ohne E-Mail")}</b>`;

  const zeilen = [
    kopf,
    "",
    wer,
    `Weg: ${esc(p.provider ?? "email")} · ${esc(zeit)} Uhr`,
  ];
  if (ip) zeilen.push(`IP: <code>${esc(ip.split("/")[0])}</code>`);

  zeilen.push(
    "",
    "<b>Nutzer aktuell</b>",
    `Registriert gesamt: <b>${num(s.total)}</b>`,
    `Heute neu: <b>${num(s.today)}</b>`,
    `Premium: <b>${num(s.premium)}</b>`,
    `Aktiv (7 Tage): <b>${num(s.active7)}</b>`,
  );
  return zeilen.join("\n");
}

serve(async (req: Request) => {
  if (req.method !== "POST") {
    return new Response("Method not allowed", { status: 405 });
  }

  // Config-Check
  if (!TELEGRAM_BOT_TOKEN || !TELEGRAM_ADMIN_CHAT_ID || !NOTIFY_SIGNUP_SECRET) {
    console.error("notify-signup: secrets not configured");
    return new Response(
      JSON.stringify({ ok: false, error: "Server not configured" }),
      { status: 500, headers: { "Content-Type": "application/json" } },
    );
  }

  // Shared-Secret pruefen (die Function laeuft ohne JWT-Verifikation)
  if (req.headers.get("x-signup-secret") !== NOTIFY_SIGNUP_SECRET) {
    console.warn("notify-signup: bad or missing secret");
    return new Response(JSON.stringify({ ok: false, error: "Forbidden" }), {
      status: 403,
      headers: { "Content-Type": "application/json" },
    });
  }

  try {
    const payload = (await req.json()) as Payload;

    // IP der frischen Session holen und gegen Google-Bereiche pruefen.
    // Schlaegt das fehl, geht die Meldung ganz normal raus (ohne IP-Zeile).
    const ip = payload.user_id ? await holeSignupIp(payload.user_id) : null;
    const google = istGoogleIp(ip);

    // Erkennung dauerhaft am Profil speichern (Spalte is_google_test,
    // Migration 20260902090000). Der /stats-Bot trennt damit echte
    // Gaeste von Googles Testgeraeten, auch wenn die Session laengst
    // geloescht ist. Fehler hier verhindern die Meldung nicht.
    if (google && payload.user_id && SUPABASE_URL && SERVICE_ROLE_KEY) {
      try {
        await fetch(
          `${SUPABASE_URL}/rest/v1/profiles?id=eq.${payload.user_id}`,
          {
            method: "PATCH",
            headers: {
              "Content-Type": "application/json",
              apikey: SERVICE_ROLE_KEY,
              Authorization: `Bearer ${SERVICE_ROLE_KEY}`,
              Prefer: "return=minimal",
            },
            body: JSON.stringify({ is_google_test: true }),
          },
        );
      } catch (e) {
        console.warn("notify-signup: is_google_test setzen fehlgeschlagen", e);
      }
    }

    const text = buildMessage(payload, ip, google);

    const res = await fetch(
      `https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          chat_id: TELEGRAM_ADMIN_CHAT_ID,
          text: text.length > 4000 ? text.substring(0, 3997) + "..." : text,
          parse_mode: "HTML",
          disable_web_page_preview: true,
        }),
      },
    );

    if (!res.ok) {
      const details = await res.text();
      console.error("notify-signup: telegram error", details);
      return new Response(
        JSON.stringify({ ok: false, error: "Telegram API error", details }),
        { status: 502, headers: { "Content-Type": "application/json" } },
      );
    }

    return new Response(JSON.stringify({ ok: true }), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (error) {
    console.error("notify-signup: unexpected error", error);
    return new Response(
      JSON.stringify({
        ok: false,
        error: error instanceof Error ? error.message : String(error),
      }),
      { status: 500, headers: { "Content-Type": "application/json" } },
    );
  }
});
