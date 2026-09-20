// supabase/functions/notify-premium/index.ts
//
// Meldet Premium-Kaeufe per Telegram.
//
// Aufgerufen aus Postgres: Trigger `on_profile_premium_notify` auf
// public.profiles -> pg_net -> diese Function. Kein User-JWT, deshalb
// Deploy mit --no-verify-jwt; Schutz ueber den Shared-Secret-Header
// `x-signup-secret` (bewusst DERSELBE Wert wie beim Signup-Bot, damit
// keine neuen Secrets gepflegt werden muessen).
//
// Benoetigte Supabase Secrets (existieren alle bereits):
//   TELEGRAM_BOT_TOKEN
//   TELEGRAM_ADMIN_CHAT_ID
//   NOTIFY_SIGNUP_SECRET

import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

const TELEGRAM_BOT_TOKEN = Deno.env.get("TELEGRAM_BOT_TOKEN");
const TELEGRAM_ADMIN_CHAT_ID = Deno.env.get("TELEGRAM_ADMIN_CHAT_ID");
const NOTIFY_SIGNUP_SECRET = Deno.env.get("NOTIFY_SIGNUP_SECRET");

interface Payload {
  email?: string | null;
  tier?: string | null;
  premium_until?: string | null;
  premium_count?: number;
  // seit 20.09.2026 aus store_transaktionen (fehlt bei Stripe/Web):
  store?: string | null; // 'apple' | 'google'
  environment?: string | null; // Apple: Sandbox/Production, Google: Test/Production
  product_id?: string | null;
  preis?: number | string | null;
  waehrung?: string | null;
  angebot?: string | null; // Google offerId, Apple intro/promo:<id>/code:<id>
}

function esc(value: unknown): string {
  return String(value ?? "")
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;");
}

const TIER_NAMEN: Record<string, string> = {
  monthly: "Monatlich",
  "half-year": "Halbjahr",
  yearly: "Jahr",
  annual: "Jahr",
  lifetime: "Lifetime",
};

// Listenpreise (DE, inkl. MwSt.) - nur als Anhaltspunkt, wenn der Store
// keinen gezahlten Betrag mitliefert (Google).
const LISTENPREIS: Record<string, string> = {
  monthly: "11,99 EUR",
  "half-year": "47,99 EUR",
  yearly: "84,99 EUR",
  annual: "84,99 EUR",
};

const STORE_NAMEN: Record<string, string> = {
  apple: "App Store",
  google: "Google Play",
};

function istTestkauf(p: Payload): boolean {
  const env = (p.environment ?? "").toLowerCase();
  return env === "sandbox" || env === "test";
}

function preisText(p: Payload): string {
  const betrag = p.preis == null ? null : Number(p.preis);
  if (betrag != null && !Number.isNaN(betrag)) {
    const w = (p.waehrung ?? "").toUpperCase() || "?";
    return `${betrag.toFixed(2).replace(".", ",")} ${w}`;
  }
  const liste = LISTENPREIS[p.tier ?? ""];
  if (!liste) return "unbekannt";
  // Google nennt keinen Betrag: mit Angebot ist der Listenpreis falsch.
  return p.angebot ? `Angebotspreis (Liste ${liste})` : `${liste} (Liste)`;
}

function angebotText(p: Payload): string | null {
  const a = p.angebot;
  if (!a) return null;
  if (a === "intro") return "Einführungsangebot";
  if (a.startsWith("promo:")) return `Werbeangebot ${a.slice(6)}`;
  if (a.startsWith("code:")) return `Angebotscode ${a.slice(5)}`;
  return a; // Google offerId, z. B. endspurt-2026
}

function buildMessage(p: Payload): string {
  const plan = TIER_NAMEN[p.tier ?? ""] ?? esc(p.tier ?? "unbekannt");
  const test = istTestkauf(p);
  const store = p.store
    ? (STORE_NAMEN[p.store] ?? esc(p.store))
    : "Web (Stripe)";
  const angebot = angebotText(p);

  const bis = p.premium_until
    ? new Date(p.premium_until).toLocaleString("de-DE", {
        timeZone: "Europe/Berlin",
        day: "2-digit",
        month: "2-digit",
        year: "numeric",
      })
    : "?";

  const zeilen = [
    test
      ? `🧪 <b>Testkauf (${esc(p.environment)}) – kein echter Umsatz</b>`
      : "💰 <b>Neuer Premium-Kauf!</b>",
    "",
    `<b>${esc(p.email ?? "unbekannt")}</b>`,
    `Plan: <b>${plan}</b> · ${esc(store)}`,
    `Preis: <b>${esc(preisText(p))}</b>${angebot ? ` · ${esc(angebot)}` : ""}`,
    `Läuft bis: ${esc(bis)}`,
    "",
    `Premium-Nutzer gesamt: <b>${p.premium_count ?? "?"}</b>`,
  ];
  return zeilen.join("\n");
}

serve(async (req: Request) => {
  if (req.method !== "POST") {
    return new Response("Method not allowed", { status: 405 });
  }

  if (!TELEGRAM_BOT_TOKEN || !TELEGRAM_ADMIN_CHAT_ID || !NOTIFY_SIGNUP_SECRET) {
    console.error("notify-premium: secrets not configured");
    return new Response(
      JSON.stringify({ ok: false, error: "Server not configured" }),
      { status: 500, headers: { "Content-Type": "application/json" } },
    );
  }

  if (req.headers.get("x-signup-secret") !== NOTIFY_SIGNUP_SECRET) {
    console.warn("notify-premium: bad or missing secret");
    return new Response(JSON.stringify({ ok: false, error: "Forbidden" }), {
      status: 403,
      headers: { "Content-Type": "application/json" },
    });
  }

  try {
    const payload = (await req.json()) as Payload;
    const text = buildMessage(payload);

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
      console.error("notify-premium: telegram error", details);
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
    console.error("notify-premium: unexpected error", error);
    return new Response(
      JSON.stringify({
        ok: false,
        error: error instanceof Error ? error.message : String(error),
      }),
      { status: 500, headers: { "Content-Type": "application/json" } },
    );
  }
});
