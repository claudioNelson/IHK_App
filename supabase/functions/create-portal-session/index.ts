// supabase/functions/create-portal-session/index.ts
//
// Erzeugt einen Stripe-Customer-Portal-Link für den eingeloggten User,
// damit er sein Abo selbst verwalten/kündigen kann.
// Aufruf vom Web-Client mit dem Supabase-Auth-Token im Authorization-Header.

import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.0";

const STRIPE_SECRET_KEY = Deno.env.get("STRIPE_SECRET_KEY")!;
const APP_URL = Deno.env.get("APP_URL")!;

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // 1) Eingeloggten User ermitteln
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) return json({ error: "Kein Auth-Token" }, 401);

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_ANON_KEY")!,
      { global: { headers: { Authorization: authHeader } } },
    );

    const {
      data: { user },
      error: userError,
    } = await supabase.auth.getUser();

    if (userError || !user) return json({ error: "User nicht gefunden" }, 401);

    // 2) stripe_customer_id aus profiles holen
    const { data: profile, error: profErr } = await supabase
      .from("profiles")
      .select("stripe_customer_id")
      .eq("id", user.id)
      .maybeSingle();

    if (profErr) {
      console.error("❌ Profil-Lesefehler:", profErr);
      return json({ error: "Profil konnte nicht geladen werden" }, 500);
    }

    const customerId = profile?.stripe_customer_id;
    if (!customerId) {
      return json({ error: "Kein aktives Abo gefunden." }, 400);
    }

    // 3) Stripe-Portal-Session erstellen (per REST, ohne SDK)
    const params = new URLSearchParams({
      customer: customerId,
      return_url: `${APP_URL}/profil`,
    });

    const res = await fetch("https://api.stripe.com/v1/billing_portal/sessions", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${STRIPE_SECRET_KEY}`,
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: params.toString(),
    });

    const data = await res.json();

    if (!res.ok) {
      console.error("❌ Stripe-Portal-Fehler:", data);
      return json({ error: data.error?.message ?? "Portal-Fehler" }, 500);
    }

    return json({ url: data.url });
  } catch (e) {
    console.error("❌ Fehler:", e);
    return json({ error: String((e as any)?.message ?? e) }, 500);
  }
});

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}