// /profil: Dein Profil im Web (Server-Komponente).
//
// Laedt alles serverseitig (RLS: jeder sieht nur seine eigenen Zeilen) und
// gibt fertige Werte an ProfilClient:
//   Kopf        -> user_metadata.username, profiles (email, created_at)
//   Abo         -> profiles (is_premium, premium_tier, premium_until,
//                  stripe_customer_id) plus Kaufquelle aus store_transaktionen
//   Lernstand   -> user_progress (Anzahl, davon richtig), profiles.streak_days,
//                  player_stats (Elo), user_exam_attempts + exams (typ 'ihk')
//   Verlauf     -> bewertete IHK-Versuche, neueste zuerst
// Bereitschaft, Lernbereiche, Zertifikate und Abzeichen zeigt das Web
// bewusst nicht mehr (siehe Design-Notizen Auth und Konto).

import type { Metadata } from "next";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import ProfilClient, { type AboDaten, type Lernstand, type Versuch } from "./ProfilClient";

export const metadata: Metadata = {
  title: "Dein Profil",
  robots: { index: false, follow: false },
};

// IHK-Notenschluessel (Prozent -> Note)
function ihkNote(p: number) {
  if (p >= 92) return 1;
  if (p >= 81) return 2;
  if (p >= 67) return 3;
  if (p >= 50) return 4;
  if (p >= 30) return 5;
  return 6;
}

const TZ = "Europe/Berlin";

function datum(iso: string | null | undefined) {
  if (!iso) return null;
  const d = new Date(iso);
  if (isNaN(d.getTime())) return null;
  return d.toLocaleDateString("de-DE", { day: "2-digit", month: "2-digit", year: "numeric", timeZone: TZ });
}

function monatJahr(iso: string | null | undefined) {
  if (!iso) return null;
  const d = new Date(iso);
  if (isNaN(d.getTime())) return null;
  return d.toLocaleDateString("de-DE", { month: "long", year: "numeric", timeZone: TZ });
}

function schnitt(noten: number[]) {
  if (noten.length === 0) return null;
  const s = noten.reduce((a, b) => a + b, 0) / noten.length;
  return s.toFixed(1).replace(".", ",");
}

export default async function ProfilPage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/login?next=/profil");

  const [profilRes, storeRes, fragenRes, richtigRes, arenaRes, versucheRes, examsRes] = await Promise.all([
    supabase
      .from("profiles")
      .select("username, email, created_at, is_premium, premium_until, premium_tier, stripe_customer_id, streak_days, last_login_date")
      .eq("id", user.id)
      .maybeSingle(),
    // Kaufquelle: juengster Store-Kauf. RLS unklar, Fehler fuehren zu null.
    supabase
      .from("store_transaktionen")
      .select("store, last_seen")
      .eq("user_id", user.id)
      .order("last_seen", { ascending: false })
      .limit(1)
      .maybeSingle(),
    supabase.from("user_progress").select("user_id", { count: "exact", head: true }).eq("user_id", user.id),
    supabase
      .from("user_progress")
      .select("user_id", { count: "exact", head: true })
      .eq("user_id", user.id)
      .eq("is_correct", true),
    supabase
      .from("player_stats")
      .select("elo_rating, highest_elo, matches_played")
      .eq("user_id", user.id)
      .maybeSingle(),
    supabase
      .from("user_exam_attempts")
      .select("id, exam_id, submitted_at, percentage, passed, status")
      .eq("user_id", user.id)
      .order("submitted_at", { ascending: false }),
    supabase.from("exams").select("id, name, typ, beschreibung"),
  ]);

  const p = profilRes.data;

  // ---- Abo ---------------------------------------------------------------
  const tier = (p?.premium_tier ?? null) as AboDaten["tier"];
  const bis = p?.premium_until ? new Date(p.premium_until) : null;
  const abgelaufen = tier !== "lifetime" && bis !== null && !isNaN(bis.getTime()) && bis < new Date();
  const premium = p?.is_premium === true && !abgelaufen;

  let abo: AboDaten;
  if (!premium) {
    abo = { art: "free", tier: null, bis: null };
  } else if (tier === "lifetime") {
    abo = { art: "lifetime", tier, bis: null };
  } else {
    const store = storeRes.error ? null : (storeRes.data?.store as string | undefined);
    const art: AboDaten["art"] =
      store === "google" ? "google" : store === "apple" ? "apple" : p?.stripe_customer_id ? "web" : "unbekannt";
    abo = { art, tier, bis: datum(p?.premium_until) };
  }

  // ---- Lernstand ---------------------------------------------------------
  const fragen = fragenRes.error ? null : (fragenRes.count ?? 0);
  const richtig = richtigRes.error ? null : (richtigRes.count ?? 0);

  const ihk = new Map<number, { name: string; info: string | null }>();
  for (const e of examsRes.data ?? []) {
    if (e.typ === "ihk") ihk.set(Number(e.id), { name: e.name, info: e.beschreibung ?? null });
  }
  const ihkVersuche = (versucheRes.data ?? []).filter((a) => ihk.has(Number(a.exam_id)));
  const bewertet = ihkVersuche.filter((a) => a.status === "graded" && a.percentage !== null);
  const offen = ihkVersuche.filter((a) => a.submitted_at && !(a.status === "graded" && a.percentage !== null)).length;

  const verlauf: Versuch[] = bewertet.map((a) => {
    const prozent = Math.round(Number(a.percentage ?? 0));
    const exam = ihk.get(Number(a.exam_id));
    return {
      id: String(a.id),
      iso: a.submitted_at ? String(a.submitted_at).slice(0, 10) : "",
      datum: datum(a.submitted_at) ?? "",
      name: exam?.name ?? `Prüfung ${a.exam_id}`,
      sub: exam?.info ?? null,
      prozent,
      note: ihkNote(prozent),
      bestanden: a.passed === true,
    };
  });

  const arena = arenaRes.data;
  const hatArena = !!arena && Number(arena.matches_played ?? 0) > 0;

  const lernstand: Lernstand = {
    fragen,
    richtigProzent: fragen && richtig !== null ? Math.round((richtig / fragen) * 100) : null,
    serie: p ? Number(p.streak_days ?? 0) : null,
    zuletzt: datum(p?.last_login_date),
    elo: hatArena ? Number(arena!.elo_rating ?? 0) : null,
    eloMax: hatArena && arena!.highest_elo != null ? Number(arena!.highest_elo) : null,
    pruefungen: verlauf.length,
    bestanden: verlauf.filter((v) => v.bestanden).length,
    schnitt: schnitt(verlauf.map((v) => v.note)),
    schnittLetzte3: verlauf.length > 3 ? schnitt(verlauf.slice(0, 3).map((v) => v.note)) : null,
  };

  // ---- Kopf --------------------------------------------------------------
  const email = user.email ?? p?.email ?? "";
  const name = (user.user_metadata?.username as string | undefined) ?? p?.username ?? email;
  const anbieter = (user.app_metadata?.providers as string[] | undefined) ?? [];
  const mitPasswort =
    anbieter.includes("email") || (user.identities ?? []).some((i) => i.provider === "email") || anbieter.length === 0;

  return (
    <ProfilClient
      name={name}
      email={email}
      mitgliedSeit={monatJahr(p?.created_at ?? user.created_at)}
      mitPasswort={mitPasswort}
      abo={abo}
      lernstand={lernstand}
      verlauf={verlauf}
      offen={offen}
    />
  );
}
