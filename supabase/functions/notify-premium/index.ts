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
}

function esc(value: unknown): string {
  return String(value ?? "")
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;");
}

const TIER_NAMEN: Record<string, string> = {
  monthly: "Monatlich (11,99 EUR)",
  "half-year": "Halbjahr (47,99 EUR)",
  annual: "Jahr (84,99 EUR)",
};

function buildMessage(p: Payload): string {
  const plan = TIER_NAMEN[p.tier ?? ""] ?? esc(p.tier ?? "unbekannt");

  const bis = p.premium_until
    ? new Date(p.premium_until).toLocaleString("de-DE", {
        timeZone: "Europe/Berlin",
        day: "2-digit",
        month: "2-digit",
        year: "numeric",
      })
    : "?";

  return [
    "💰 <b>Neuer Premium-Kauf!</b>",
    "",
    `<b>${esc(p.email ?? "unbekannt")}</b>`,
    `Plan: <b>${plan}</b>`,
    `Laeuft bis: ${esc(bis)}`,
    "",
    `Premium-Nutzer gesamt: <b>${p.premium_count ?? "?"}</b>`,
  ].join("\n");
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
