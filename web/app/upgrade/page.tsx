// /upgrade: Premium-Seite. Oeffentlich lesbar; wer ohne Anmeldung auf
// "Weiter zur Zahlung" tippt, landet ueber lib/checkout.ts bei /login und
// kommt mit gewaehlter Laufzeit hierher zurueck. Wer schon Premium hat,
// sieht statt des Kaufkastens einen Hinweis mit Link zum Profil.

import type { Metadata } from "next";
import { createClient } from "@/lib/supabase/server";
import { sichererPfad } from "@/app/components/konto/fehler";
import UpgradeClient, { type Laufzeit } from "./UpgradeClient";

export const metadata: Metadata = {
  title: "Premium",
  description:
    "Lernarena Premium: alle Levels, Übungsprüfungen mit Korrektur und die KI-Tutorin Ada ohne Limit. Monatlich, halbjährlich oder jährlich, jederzeit kündbar.",
  robots: { index: false, follow: true },
};

const LAUFZEITEN: Laufzeit[] = ["monthly", "halfyear", "yearly"];

export default async function UpgradePage({
  searchParams,
}: {
  searchParams: Promise<{ next?: string; plan?: string }>;
}) {
  const params = await searchParams;
  // Ziel nach dem Kauf (z. B. eine gesperrte Pruefung); ohne Angabe keins
  const next = params.next ? sichererPfad(params.next, "") || null : null;
  const plan: Laufzeit = LAUFZEITEN.includes(params.plan as Laufzeit) ? (params.plan as Laufzeit) : "yearly";

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  let schonPremium = false;
  if (user) {
    const { data: profile } = await supabase
      .from("profiles")
      .select("is_premium, premium_tier, premium_until")
      .eq("id", user.id)
      .maybeSingle();
    if (profile?.is_premium === true) {
      const until = profile.premium_until ? new Date(profile.premium_until) : null;
      const abgelaufen = profile.premium_tier !== "lifetime" && until !== null && until < new Date();
      schonPremium = !abgelaufen;
    }
  }

  return <UpgradeClient angemeldet={!!user} schonPremium={schonPremium} next={next} startPlan={plan} />;
}
