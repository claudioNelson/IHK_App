// supabase/functions/notify-signup/index.ts
//
// Meldet neue Registrierungen per Telegram — inkl. aktueller Nutzerzahlen.
//
// Aufgerufen wird die Function NICHT aus der App, sondern aus Postgres:
// Trigger `on_auth_user_created_notify` auf auth.users -> pg_net -> diese Function.
// Deshalb gibt es keinen User-JWT. Deploy mit --no-verify-jwt, Schutz laeuft
// ueber den Shared-Secret-Header `x-signup-secret`.
//
// Benoetigte Supabase Secrets:
//   TELEGRAM_BOT_TOKEN      (existiert bereits, siehe report-bug)
//   TELEGRAM_ADMIN_CHAT_ID  (existiert bereits, siehe report-bug)
//   NOTIFY_SIGNUP_SECRET    (neu — derselbe Wert steht in der Migration)

import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

const TELEGRAM_BOT_TOKEN = Deno.env.get("TELEGRAM_BOT_TOKEN");
const TELEGRAM_ADMIN_CHAT_ID = Deno.env.get("TELEGRAM_ADMIN_CHAT_ID");
const NOTIFY_SIGNUP_SECRET = Deno.env.get("NOTIFY_SIGNUP_SECRET");

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

function buildMessage(p: Payload): string {
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

  const kopf = isGuest
    ? "🧪 <b>Neuer Gast</b> (anonym ausprobiert)"
    : "🎉 <b>Neue Registrierung</b>";

  const wer = isGuest
    ? `<code>${esc(p.user_id)}</code>`
    : `<b>${esc(p.email ?? "ohne E-Mail")}</b>`;

  return [
    kopf,
    "",
    wer,
    `Weg: ${esc(p.provider ?? "email")} · ${esc(zeit)} Uhr`,
    "",
    "<b>Nutzer aktuell</b>",
    `Registriert gesamt: <b>${num(s.total)}</b>`,
    `Heute neu: <b>${num(s.today)}</b>`,
    `Premium: <b>${num(s.premium)}</b>`,
    `Aktiv (7 Tage): <b>${num(s.active7)}</b>`,
  ].join("\n");
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
