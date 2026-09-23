import type { Metadata } from "next";
import { notFound, redirect } from "next/navigation";
import { exams } from "@/data/exams";
import { createClient } from "@/lib/supabase/server";
import ExamContent from "./ExamContent";

type Props = { params: Promise<{ id: string }> };

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { id } = await params;
  const exam = exams[id];
  return {
    title: exam ? exam.title : "Prüfung nicht gefunden",
    robots: { index: false },
  };
}

export default async function Pruefung({ params }: Props) {
  const { id } = await params;
  const exam = exams[id];

  if (!exam) notFound();

  // Zugriff: angemeldet und Premium, sonst Login bzw. Upgrade mit Rueckweg
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  if (!user) {
    redirect(`/login?next=/pruefung/${id}`);
  }

  const { data: profile } = await supabase
    .from("profiles")
    .select("is_premium, premium_tier, premium_until")
    .eq("id", user.id)
    .maybeSingle();

  let isPremium = profile?.is_premium === true;

  // Abgelaufenes Abo erkennen und in der Datenbank nachziehen
  if (
    isPremium &&
    profile?.premium_tier !== "lifetime" &&
    profile?.premium_until
  ) {
    const until = new Date(profile.premium_until);
    if (!isNaN(until.getTime()) && until < new Date()) {
      isPremium = false;
      await supabase
        .from("profiles")
        .update({ is_premium: false })
        .eq("id", user.id);
    }
  }

  if (!isPremium) {
    redirect(`/upgrade?next=/pruefung/${id}`);
  }

  return <ExamContent exam={exam} />;
}
