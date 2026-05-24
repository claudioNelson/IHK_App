import { redirect } from "next/navigation";
import { exams } from "@/data/exams";
import { createClient } from "@/lib/supabase/server";
import ExamContent from "./ExamContent";

export default async function Pruefung({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const exam = exams[id];

  if (!exam) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <p className="text-red-600">Prüfung nicht gefunden</p>
      </div>
    );
  }

  // ─── ACCESS GUARD ──────────────────────────────────────────
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  // Nicht eingeloggt → Login mit Redirect zurück
  if (!user) {
    redirect(`/login?next=/pruefung/${id}`);
  }

  // Premium-Status prüfen
  const { data: profile } = await supabase
    .from("profiles")
    .select("is_premium, premium_tier, premium_until")
    .eq("id", user.id)
    .maybeSingle();

  let isPremium = profile?.is_premium === true;

  // Auto-Expire: abgelaufenes Abo erkennen
  if (
    isPremium &&
    profile?.premium_tier !== "lifetime" &&
    profile?.premium_until
  ) {
    const until = new Date(profile.premium_until);
    if (!isNaN(until.getTime()) && until < new Date()) {
      isPremium = false;
      // DB updaten — Abo ist abgelaufen
      await supabase
        .from("profiles")
        .update({ is_premium: false })
        .eq("id", user.id);
    }
  }

  // Eingeloggt aber kein Premium → Paywall
  if (!isPremium) {
    redirect(`/upgrade?next=/pruefung/${id}`);
  }

  // Premium ✓ → Prüfung anzeigen
  return <ExamContent exam={exam} />;
}