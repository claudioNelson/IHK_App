// supabase/functions/telegram-bot/index.ts
//
// Telegram-Webhook: du schreibst dem Bot einen Befehl, er antwortet.
// Kein Account noetig, jederzeit abrufbar.
//
//   /stats   aktuelle Nutzerzahlen
//   /start   Begruessung + Befehlsliste
//   /help    dasselbe
//
// Telegram ruft diese Function auf, es gibt also keinen User-JWT.
// Deploy mit --no-verify-jwt. Abgesichert doppelt:
//   1. Telegram schickt den Header x-telegram-bot-api-secret-token
//      (bei setWebhook als secret_token hinterlegt)
//   2. es wird nur auf Nachrichten aus TELEGRAM_ADMIN_CHAT_ID geantwortet
//
// Benoetigte Supabase Secrets:
//   TELEGRAM_BOT_TOKEN        (existiert bereits)
//   TELEGRAM_ADMIN_CHAT_ID    (existiert bereits)
//   TELEGRAM_WEBHOOK_SECRET   (neu — derselbe Wert wie bei setWebhook)
// SUPABASE_URL und SUPABASE_SERVICE_ROLE_KEY stellt Supabase automatisch bereit.

import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { ladePlayDebug, ladePlayStats, type PlayStats } from "./play.ts";

const TELEGRAM_BOT_TOKEN = Deno.env.get("TELEGRAM_BOT_TOKEN");
const TELEGRAM_ADMIN_CHAT_ID = Deno.env.get("TELEGRAM_ADMIN_CHAT_ID");
const TELEGRAM_WEBHOOK_SECRET = Deno.env.get("TELEGRAM_WEBHOOK_SECRET");
const SUPABASE_URL = Deno.env.get("SUPABASE_URL");
const SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

interface Stats {
  total: number; // echte Nutzer (bestaetigt, ohne Test-/Bot-Accounts)
  total_raw: number; // alle nicht-anonymen Accounts
  excluded: number; // Differenz: unbestaetigt + ausgeschlossen
  today: number;
  week: number;
  active7: number;
  active30: number;
  premium: number;
  guests: number;
  guests_google?: number; // davon Google-Testgeraete (is_google_test)
  guests_echt?: number; // davon echte Menschen
  last_signup: string | null;
}

function esc(value: unknown): string {
  return String(value ?? "")
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;");
}

function num(value: number | null | undefined): string {
  return typeof value === "number" ? value.toLocaleString("de-DE") : "?";
}

/** "vor 2 Std", "vor 3 Tagen", ... */
function seit(iso: string | null): string {
  if (!iso) return "noch keine";
  const min = Math.floor((Date.now() - new Date(iso).getTime()) / 60000);
  if (min < 1) return "gerade eben";
  if (min < 60) return `vor ${min} Min`;
  const std = Math.floor(min / 60);
  if (std < 24) return `vor ${std} Std`;
  const tage = Math.floor(std / 24);
  return tage === 1 ? "vor 1 Tag" : `vor ${tage} Tagen`;
}

async function ladeStats(): Promise<Stats> {
  const res = await fetch(`${SUPABASE_URL}/rest/v1/rpc/admin_user_stats`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      apikey: SERVICE_ROLE_KEY!,
      Authorization: `Bearer ${SERVICE_ROLE_KEY}`,
    },
    body: "{}",
  });

  if (!res.ok) {
    throw new Error(`RPC admin_user_stats: ${res.status} ${await res.text()}`);
  }
  return (await res.json()) as Stats;
}

function formatStats(s: Stats): string {
  const jetzt = new Date().toLocaleString("de-DE", {
    timeZone: "Europe/Berlin",
    day: "2-digit",
    month: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
  });

  return [
    `📊 <b>Lernarena</b> · ${esc(jetzt)} Uhr`,
    "",
    `Echte Nutzer: <b>${num(s.total)}</b>`,
    `Heute neu: <b>${num(s.today)}</b>`,
    `Letzte 7 Tage neu: <b>${num(s.week)}</b>`,
    "",
    `Aktiv (7 Tage): <b>${num(s.active7)}</b>`,
    `Aktiv (30 Tage): <b>${num(s.active30)}</b>`,
    `Premium: <b>${num(s.premium)}</b>`,
    "",
    typeof s.guests_google === "number"
      ? `Gäste gerade: ${num(s.guests_echt)} echte · ${num(s.guests_google)} Google-Tests`
      : `Gäste gerade: ${num(s.guests)}`,
    `Roh in der DB: ${num(s.total_raw)} · ${num(s.excluded)} gefiltert`,
    `Letzte Registrierung: ${esc(seit(s.last_signup))}`,
  ].join("\n");
}

function formatPlay(p: PlayStats): string {
  const netto = p.installs7 - p.uninstalls7;
  const vorzeichen = netto > 0 ? "+" : "";
  const laender = p.top.length
    ? p.top.map((t) => `${esc(t.land)} ${num(t.aktiv)}`).join(" · ")
    : "—";

  return [
    `▶️ <b>Play Store</b> · Stand ${esc(p.stand)}`,
    "",
    `Installiert: <b>${num(p.aktiv)}</b> Geräte`,
    `7 Tage: +${num(p.installs7)} / −${num(p.uninstalls7)} · netto <b>${vorzeichen}${num(netto)}</b>`,
    `Top: ${laender}`,
    "",
    "<i>Play-Reports hinken ~2 Tage hinterher.</i>",
  ].join("\n");
}

// Dauerhafte Tastatur unter dem Eingabefeld. Ein Tipp auf einen Button
// schickt genau diesen Text als Nachricht — deshalb werden die Beschriftungen
// unten im Handler wieder auf die Befehle abgebildet.
const TASTATUR = {
  keyboard: [[{ text: "📊 Nutzer" }, { text: "▶️ Play Store" }]],
  resize_keyboard: true, // niedrige Buttons statt halber Bildschirm
  is_persistent: true, // bleibt sichtbar, klappt nicht weg
  input_field_placeholder: "/stats oder /play",
};

async function sende(text: string): Promise<void> {
  await fetch(`https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      chat_id: TELEGRAM_ADMIN_CHAT_ID,
      text: text.length > 4000 ? text.substring(0, 3997) + "..." : text,
      parse_mode: "HTML",
      disable_web_page_preview: true,
      reply_markup: TASTATUR,
    }),
  });
}

// Telegram bekommt IMMER 200 — sonst stellt es die Zustellung irgendwann ein
// und wiederholt jeden Fehlschlag stur.
const OK = () =>
  new Response(JSON.stringify({ ok: true }), {
    status: 200,
    headers: { "Content-Type": "application/json" },
  });

serve(async (req: Request) => {
  if (req.method !== "POST") return new Response("Method not allowed", { status: 405 });

  if (!TELEGRAM_BOT_TOKEN || !TELEGRAM_ADMIN_CHAT_ID || !TELEGRAM_WEBHOOK_SECRET) {
    console.error("telegram-bot: secrets not configured");
    return OK();
  }

  // 1. Kommt der Aufruf wirklich von Telegram?
  if (req.headers.get("x-telegram-bot-api-secret-token") !== TELEGRAM_WEBHOOK_SECRET) {
    console.warn("telegram-bot: bad webhook secret");
    return new Response("Forbidden", { status: 403 });
  }

  try {
    const update = await req.json();
    const msg = update?.message ?? update?.edited_message;
    const chatId = msg?.chat?.id;
    const text: string = (msg?.text ?? "").trim();

    if (!chatId || !text) return OK();

    // 2. Nur der Admin-Chat darf etwas ausloesen.
    if (String(chatId) !== String(TELEGRAM_ADMIN_CHAT_ID)) {
      console.warn("telegram-bot: message from foreign chat", chatId);
      return OK();
    }

    // "/stats@LernarenaBot" -> "/stats"
    let befehl = text.split(/\s+/)[0].split("@")[0].toLowerCase();

    // Buttons schicken ihre Beschriftung, keinen Befehl — hier zurueckuebersetzen.
    if (text.includes("Nutzer")) befehl = "/stats";
    else if (text.includes("Play")) befehl = "/play";

    switch (befehl) {
      case "/stats":
      case "/nutzer": {
        // Beides parallel holen. Wenn Play klemmt, kommen trotzdem die
        // Datenbankzahlen — die sind wichtiger und immer verfuegbar.
        const [dbErg, playErg] = await Promise.allSettled([
          ladeStats(),
          ladePlayStats(),
        ]);

        if (dbErg.status === "rejected") throw dbErg.reason;

        let text = formatStats(dbErg.value);

        if (playErg.status === "fulfilled" && playErg.value) {
          text += "\n\n" + formatPlay(playErg.value);
        } else if (playErg.status === "rejected") {
          console.error("play stats failed", playErg.reason);
          text += "\n\n▶️ <i>Play-Zahlen gerade nicht abrufbar.</i>";
        }

        await sende(text);
        break;
      }

      case "/play": {
        // "/play debug" zeigt, welche Report-Dateien im Bucket liegen und
        // wann Google sie zuletzt geschrieben hat.
        if (text.toLowerCase().includes("debug")) {
          const dateien = await ladePlayDebug();
          if (!dateien || dateien.length === 0) {
            await sende("Keine Report-Dateien im Bucket gefunden.");
            break;
          }
          const zeilen = dateien.slice(-6).map((d) => {
            const kurz = d.name.split("/").pop() ?? d.name;
            const wann = new Date(d.updated).toLocaleString("de-DE", {
              timeZone: "Europe/Berlin",
              day: "2-digit",
              month: "2-digit",
              hour: "2-digit",
              minute: "2-digit",
            });
            return `${esc(kurz)}\n  geschrieben ${esc(wann)} · ${num(d.size)} B`;
          });
          await sende(
            `🗂 <b>Reports im Bucket</b> (${dateien.length})\n\n` +
              zeilen.join("\n"),
          );
          break;
        }

        const p = await ladePlayStats();
        await sende(
          p
            ? formatPlay(p)
            : "▶️ Play-Zahlen sind nicht eingerichtet.\nEs fehlt das Secret <code>PLAY_REPORT_BUCKET</code>.",
        );
        break;
      }

      case "/start":
      case "/help":
        await sende(
          [
            "👋 <b>Lernarena Bot</b>",
            "",
            "Unten sind jetzt zwei Buttons — einfach antippen:",
            "📊 Nutzer · ▶️ Play Store",
            "",
            "Getippt geht natürlich weiter: /stats, /play, /play debug",
            "",
            "Neue Registrierungen melde ich automatisch.",
          ].join("\n"),
        );
        break;

      default:
        await sende("Kenn ich nicht. Probier /stats");
    }
  } catch (error) {
    console.error("telegram-bot: error", error);
    try {
      await sende(
        `⚠️ Fehler beim Abrufen:\n<code>${esc(
          error instanceof Error ? error.message : String(error),
        )}</code>`,
      );
    } catch (_) {
      // wenn selbst das Senden scheitert, hilft nur noch das Log
    }
  }

  return OK();
});
