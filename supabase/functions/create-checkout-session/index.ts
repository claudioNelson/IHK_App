// supabase/functions/create-checkout-session/index.ts
//
// Erzeugt eine Stripe Checkout Session für den eingeloggten User.
// Aufruf vom Flutter-Client mit { tier: 'monthly' | 'halfyear' | 'yearly' }
// und dem Supabase-Auth-Token im Authorization-Header.

import Stripe from "https://esm.sh/stripe@16.12.0?target=deno";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.0";

const stripe = new Stripe(Deno.env.get("STRIPE_SECRET_KEY")!, {
  apiVersion: "2024-06-20",
  httpClient: Stripe.createFetchHttpClient(),
});

// Alle drei Tarife sind Abos (recurring) -> mode: "subscription"
// Price-IDs aus den Supabase-Secrets (im Stripe-Dashboard kopiert)
const PRICES: Record<string, string> = {
  monthly: Deno.env.get("STRIPE_PRICE_MONTHLY")!,
  halfyear: Deno.env.get("STRIPE_PRICE_HALFYEAR")!,
  yearly: Deno.env.get("STRIPE_PRICE_YEARLY")!,
};

// URL deiner Web-App, wohin Stripe nach der Zahlung zurückleitet
const APP_URL = Deno.env.get("APP_URL")!;

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

Deno.serve(async (req) => {
  // CORS-Preflight (vom Browser bei Cross-Origin-Requests gesendet)
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // 1) Eingeloggten User aus dem Supabase-Token ermitteln
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return json({ error: "Kein Auth-Token" }, 401);
    }

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_ANON_KEY")!,
      { global: { headers: { Authorization: authHeader } } },
    );

    const {
      data: { user },
      error: userError,
    } = await supabase.auth.getUser();

    if (userError || !user) {
      return json({ error: "User nicht gefunden" }, 401);
    }

    // 2) Tier prüfen
    const { tier } = await req.json();
    const priceId = PRICES[tier];
    if (!priceId) {
      return json({ error: `Ungültiges Tier: ${tier}` }, 400);
    }

    // 3) Stripe Checkout Session erstellen (alle Tarife = Abo)
    const session = await stripe.checkout.sessions.create({
      mode: "subscription",
      line_items: [{ price: priceId, quantity: 1 }],
      customer_email: user.email,
      // client_reference_id + metadata: damit der Webhook weiß, wen er
      // auf Premium setzen muss
      client_reference_id: user.id,
      metadata: { user_id: user.id, tier },
      subscription_data: { metadata: { user_id: user.id, tier } },
      success_url: `${APP_URL}/#/payment-success?session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: `${APP_URL}/#/payment-cancelled`,
      allow_promotion_codes: true,
    });

    return json({ url: session.url });
  } catch (e) {
    console.error("Checkout-Fehler:", e);
    return json({ error: String(e?.message ?? e) }, 500);
  }
});

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}