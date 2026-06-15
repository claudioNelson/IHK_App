// supabase/functions/report-bug/index.ts
//
// Empfängt Bug-Reports aus der Flutter-App und leitet sie an Telegram weiter.
// Token + Chat-ID werden aus Supabase Secrets gelesen (NICHT in der App!).
//
// Aufruf von Flutter:
//   await Supabase.instance.client.functions.invoke('report-bug', body: {
//     'message': '<formatierter HTML-Text>',
//   });

import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

const TELEGRAM_BOT_TOKEN = Deno.env.get("TELEGRAM_BOT_TOKEN");
const TELEGRAM_ADMIN_CHAT_ID = Deno.env.get("TELEGRAM_ADMIN_CHAT_ID");

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

serve(async (req: Request) => {
  // CORS Preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // Config-Check
    if (!TELEGRAM_BOT_TOKEN || !TELEGRAM_ADMIN_CHAT_ID) {
      console.error("Telegram secrets not configured");
      return new Response(
        JSON.stringify({
          ok: false,
          error: "Server not configured",
        }),
        {
          status: 500,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        },
      );
    }

    // Body parsen
    const body = await req.json();
    const message = body?.message as string | undefined;

    if (!message || typeof message !== "string") {
      return new Response(
        JSON.stringify({ ok: false, error: "Missing 'message' in body" }),
        {
          status: 400,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        },
      );
    }

    // Limit: maximal 4000 Zeichen (Telegram-Limit ist 4096)
    const safeMessage =
      message.length > 4000 ? message.substring(0, 3997) + "..." : message;

    // An Telegram weiterleiten
    const telegramUrl = `https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage`;
    const telegramResponse = await fetch(telegramUrl, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        chat_id: TELEGRAM_ADMIN_CHAT_ID,
        text: safeMessage,
        parse_mode: "HTML",
      }),
    });

    if (!telegramResponse.ok) {
      const errorText = await telegramResponse.text();
      console.error("Telegram API error:", errorText);
      return new Response(
        JSON.stringify({
          ok: false,
          error: "Telegram API error",
          details: errorText,
        }),
        {
          status: 502,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        },
      );
    }

    return new Response(JSON.stringify({ ok: true }), {
      status: 200,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (error) {
    console.error("Unexpected error:", error);
    return new Response(
      JSON.stringify({
        ok: false,
        error: error instanceof Error ? error.message : String(error),
      }),
      {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      },
    );
  }
});