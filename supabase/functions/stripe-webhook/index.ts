// supabase/functions/stripe-webhook/index.ts
//
// Webhook ohne Stripe-SDK (Web-Crypto-Signatur) und mit RPC-Aufrufen,
// die per SECURITY DEFINER die profiles-Tabelle schreiben -> umgeht
// "permission denied for schema public".

import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.0";

const webhookSecret = Deno.env.get("STRIPE_WEBHOOK_SECRET")!;

const supabase = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SERVICE_ROLE_KEY") ?? Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
);

function monthsForTier(tier: string): number {
  switch (tier) {
    case "monthly": return 1;
    case "halfyear": return 6;
    case "yearly": return 12;
    default: return 1;
  }
}

async function verifyStripeSignature(
  payload: string,
  sigHeader: string,
  secret: string,
): Promise<boolean> {
  const parts = Object.fromEntries(
    sigHeader.split(",").map((p) => p.split("=")),
  );
  const timestamp = parts["t"];
  const expectedSig = parts["v1"];
  if (!timestamp || !expectedSig) return false;

  const signedPayload = `${timestamp}.${payload}`;
  const key = await crypto.subtle.importKey(
    "raw",
    new TextEncoder().encode(secret),
    { name: "HMAC", hash: "SHA-256" },
    false,
    ["sign"],
  );
  const sigBuffer = await crypto.subtle.sign(
    "HMAC",
    key,
    new TextEncoder().encode(signedPayload),
  );
  const computedSig = Array.from(new Uint8Array(sigBuffer))
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
  return computedSig === expectedSig;
}

Deno.serve(async (req) => {
  const sigHeader = req.headers.get("stripe-signature");
  if (!sigHeader) return new Response("Keine Signatur", { status: 400 });

  const body = await req.text();

  const valid = await verifyStripeSignature(body, sigHeader, webhookSecret);
  if (!valid) {
    console.error("❌ Ungültige Signatur");
    return new Response("Ungültige Signatur", { status: 400 });
  }

  let event: any;
  try {
    event = JSON.parse(body);
  } catch {
    return new Response("Ungültiger Body", { status: 400 });
  }

  try {
    const obj = event.data?.object ?? {};

    switch (event.type) {
      case "checkout.session.completed": {
        const userId = obj.metadata?.user_id ?? obj.client_reference_id;
        const tier = obj.metadata?.tier ?? "monthly";
        const customerId = obj.customer ?? null;

        if (!userId) {
          console.error("❌ Keine user_id in der Session");
          break;
        }

        const until = new Date();
        until.setMonth(until.getMonth() + monthsForTier(tier));

        const { error } = await supabase.rpc("set_premium", {
          p_user_id: userId,
          p_tier: tier,
          p_until: until.toISOString(),
          p_customer: customerId,
        });

        if (error) console.error("❌ RPC set_premium:", error);
        else console.log(`✅ Premium aktiviert: ${userId} (${tier})`);
        break;
      }

      case "customer.subscription.updated": {
        const tier = obj.metadata?.tier ?? "monthly";
        const active = obj.status === "active" || obj.status === "trialing";
        const customerId = obj.customer;

        let periodEnd: number | undefined =
          obj.current_period_end ?? obj.items?.data?.[0]?.current_period_end;

        let until: Date;
        if (periodEnd && Number.isFinite(periodEnd)) {
          until = new Date(periodEnd * 1000);
        } else {
          until = new Date();
          until.setMonth(until.getMonth() + monthsForTier(tier));
        }

        const { error } = await supabase.rpc("update_premium_by_customer", {
          p_customer: customerId,
          p_active: active,
          p_tier: tier,
          p_until: until.toISOString(),
        });

        if (error) console.error("❌ RPC update (sub.updated):", error);
        else console.log(`✅ Abo aktualisiert (${tier}, aktiv=${active})`);
        break;
      }

      case "customer.subscription.deleted": {
        const customerId = obj.customer;
        const { error } = await supabase.rpc("update_premium_by_customer", {
          p_customer: customerId,
          p_active: false,
          p_tier: obj.metadata?.tier ?? "monthly",
          p_until: new Date().toISOString(),
        });

        if (error) console.error("❌ RPC update (sub.deleted):", error);
        else console.log("✅ Premium entzogen");
        break;
      }

      default:
        console.log(`ℹ️ Ignoriertes Event: ${event.type}`);
    }

    return new Response(JSON.stringify({ received: true }), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (e) {
    console.error("❌ Verarbeitungsfehler:", e);
    return new Response("Interner Fehler", { status: 500 });
  }
});