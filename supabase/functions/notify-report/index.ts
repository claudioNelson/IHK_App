// supabase/functions/notify-report/index.ts
//
// Meldet neue Problem-Meldungen aus der App ("Problem melden"-Dialog,
// Tabelle question_reports) per Telegram in einen EIGENEN Kanal.
//
// Aufgerufen aus Postgres: Trigger `on_question_report_notify` ->
// pg_net -> diese Function. Deploy mit --no-verify-jwt, Schutz ueber
// den Shared-Secret-Header `x-signup-secret` (gleicher Wert wie beim
// Signup-Bot).
//
// Benoetigte Supabase Secrets:
//   TELEGRAM_BOT_TOKEN         (existiert)
//   NOTIFY_SIGNUP_SECRET       (existiert)
//   TELEGRAM_REPORTS_CHAT_ID   (NEU: Chat-ID des Meldungen-Kanals;
//                               fehlt sie, geht die Nachricht als
//                               Fallback an TELEGRAM_ADMIN_CHAT_ID)

import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

const TELEGRAM_BOT_TOKEN = Deno.env.get("TELEGRAM_BOT_TOKEN");
const TELEGRAM_ADMIN_CHAT_ID = Deno.env.get("TELEGRAM_ADMIN_CHAT_ID");
const TELEGRAM_REPORTS_CHAT_ID = Deno.env.get("TELEGRAM_REPORTS_CHAT_ID");
const NOTIFY_SIGNUP_SECRET = Deno.env.get("NOTIFY_SIGNUP_SECRET");

interface Payload {
  report_type?: string | null;
  description?: string | null;
  screen_type?: string | null;
  frage_id?: number | null;
  frage?: string | null;
  email?: string | null;
}

function esc(value: unknown): string {
  return String(value ?? "")
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;");
}

const TYP_NAMEN: Record<string, string> = {
  wrong_answer: "❌ Falsche Antwort markiert",
  typo: "✏️ Rechtschreib-/Grammatikfehler",
  unclear: "❓ Unklare Fragestellung",
  bug: "🐛 Technischer Fehler",
  other: "💬 Sonstiges",
};

function buildMessage(p: Payload): string {
  const typ = TYP_NAMEN[p.report_type ?? ""] ?? esc(p.report_type ?? "unbekannt");
  const frage = p.frage
    ? `„${esc(p.frage.length > 200 ? p.frage.substring(0, 197) + "..." : p.frage)}"`
    : `Frage-ID ${esc(p.frage_id ?? "?")}`;

  return [
    "🚩 <b>Neue Problem-Meldung</b>",
    "",
    typ,
    `Frage: ${frage}`,
    `Von: ${esc(p.email ?? "unbekannt")} · Screen: ${esc(p.screen_type ?? "?")}`,
    "",
    `<i>${esc(p.description ?? "(keine Beschreibung)")}</i>`,
  ].join("\n");
}

serve(async (req: Request) => {
  if (req.method !== "POST") {
    return new Response("Method not allowed", { status: 405 });
  }

  const chatId = TELEGRAM_REPORTS_CHAT_ID ?? TELEGRAM_ADMIN_CHAT_ID;

  if (!TELEGRAM_BOT_TOKEN || !chatId || !NOTIFY_SIGNUP_SECRET) {
    console.error("notify-report: secrets not configured");
    return new Response(
      JSON.stringify({ ok: false, error: "Server not configured" }),
      { status: 500, headers: { "Content-Type": "application/json" } },
    );
  }

  if (req.headers.get("x-signup-secret") !== NOTIFY_SIGNUP_SECRET) {
    console.warn("notify-report: bad or missing secret");
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
          chat_id: chatId,
          text: text.length > 4000 ? text.substring(0, 3997) + "..." : text,
          parse_mode: "HTML",
          disable_web_page_preview: true,
        }),
      },
    );

    if (!res.ok) {
      const details = await res.text();
      console.error("notify-report: telegram error", details);
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
    console.error("notify-report: unexpected error", error);
    return new Response(
      JSON.stringify({
        ok: false,
        error: error instanceof Error ? error.message : String(error),
      }),
      { status: 500, headers: { "Content-Type": "application/json" } },
    );
  }
});
