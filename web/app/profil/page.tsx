"use client";

// /profil: Dein Profil im Web.
//
// Zeigt denselben Lernstand wie die App, gelesen aus denselben Supabase-
// Tabellen (RLS: jeder sieht nur seine eigenen Zeilen):
//   Pruefungsbereitschaft  = Durchschnitt aus 4 Bereichen
//     Lernmodule  -> thema_scores vs. themen (gemeistert ab required_score)
//     Levels      -> level_progress vs. levels (geschafft ab schwelle)
//     SQL/Python  -> kurs_fortschritt (geloeste Aufgaben-IDs "sql-*" / "py-*")
//   Pruefungen (alle bewerteten Versuche mit IHK-Note) -> user_exam_attempts + exams
//   Zertifikate            -> zertifikate + user_certificates
//   Badges                 -> badges + user_badges
//   Arena                  -> player_stats
// Darunter wie bisher Konto, Mitgliedschaft (Stripe-Portal) und Abmelden.

import { useEffect, useMemo, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import { useSubscription } from "@/lib/hooks/useSubscription";
import { openCustomerPortal } from "@/lib/portal";

// Gesamtzahl der Kursaufgaben. Die Kursinhalte leben in der App
// (lib/data/kurse/*.dart), das Web kennt nur die geloesten IDs.
// Bei neuen Lektionen hier nachziehen.
const KURS_AUFGABEN: Record<string, { name: string; prefix: string; gesamt: number }> = {
    sql: { name: "SQL-Kurs", prefix: "sql-", gesamt: 81 },
    python: { name: "Python-Kurs", prefix: "py-", gesamt: 95 },
};

type Bereich = { key: string; name: string; geschafft: number; gesamt: number };
type Pruefung = { id: string; name: string; typ: string | null; prozent: number; datum: string | null; bestanden: boolean; note: number };

// IHK-Notenschluessel (Prozent -> Note)
function ihkNote(p: number) {
    if (p >= 92) return 1;
    if (p >= 81) return 2;
    if (p >= 67) return 3;
    if (p >= 50) return 4;
    if (p >= 30) return 5;
    return 6;
}
type Zertifikat = { id: number; name: string; anbieter: string | null; mindest: number | null; best: number | null; passed: boolean; passedAt: string | null; attempts: number };
type Badge = { id: string; name: string; description: string | null; icon: string | null; earnedAt: string };
type Arena = { elo: number; wins: number; losses: number; draws: number; matches: number; peak: number } | null;

function prozent(geschafft: number, gesamt: number) {
    return gesamt > 0 ? Math.round((geschafft / gesamt) * 100) : 0;
}

function datum(iso: string | null) {
    if (!iso) return "";
    return new Date(iso).toLocaleDateString("de-DE", { day: "2-digit", month: "2-digit", year: "numeric" });
}

export default function ProfilPage() {
    const router = useRouter();
    const supabase = useMemo(() => createClient(), []);
    const sub = useSubscription();

    const [email, setEmail] = useState<string | null>(null);
    const [username, setUsername] = useState<string | null>(null);
    const [authLoaded, setAuthLoaded] = useState(false);

    const [bereiche, setBereiche] = useState<Bereich[] | null>(null);
    const [pruefungen, setPruefungen] = useState<Pruefung[]>([]);
    const [versucheGesamt, setVersucheGesamt] = useState(0);
    const [zertifikate, setZertifikate] = useState<Zertifikat[]>([]);
    const [badges, setBadges] = useState<Badge[]>([]);
    const [arena, setArena] = useState<Arena>(null);
    const [statsLoaded, setStatsLoaded] = useState(false);
    const [statsError, setStatsError] = useState<string | null>(null);

    const [portalLoading, setPortalLoading] = useState(false);
    const [portalError, setPortalError] = useState<string | null>(null);

    useEffect(() => {
        const load = async () => {
            const { data: { user } } = await supabase.auth.getUser();
            if (!user) {
                router.replace("/login?next=/profil");
                return;
            }
            setEmail(user.email ?? null);
            setUsername((user.user_metadata?.username as string) ?? null);
            setAuthLoaded(true);
            await ladeLernstand(user.id);
        };
        load();
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, [supabase, router]);

    async function ladeLernstand(userId: string) {
        try {
            const [
                moduleRes, themenRes, scoresRes,
                levelsRes, levelProgRes,
                kursRes,
                attemptsRes, examsRes,
                zertRes, userZertRes,
                badgesRes, userBadgesRes,
                statsRes,
            ] = await Promise.all([
                supabase.from("module").select("id").neq("kategorie", "kernthema"),
                supabase.from("themen").select("id, module_id, required_score"),
                supabase.from("thema_scores").select("modul_id, thema_id, best_score").eq("user_id", userId),
                supabase.from("levels").select("id, schwelle"),
                supabase.from("level_progress").select("level_id, best_score").eq("user_id", userId),
                supabase.from("kurs_fortschritt").select("aufgabe_id").eq("user_id", userId),
                supabase.from("user_exam_attempts")
                    .select("id, exam_id, submitted_at, percentage, passed, status")
                    .eq("user_id", userId)
                    .order("submitted_at", { ascending: false }),
                supabase.from("exams").select("id, name, typ, beschreibung"),
                supabase.from("zertifikate").select("id, name, anbieter, mindest_punktzahl").order("id"),
                supabase.from("user_certificates")
                    .select("zertifikat_id, best_score, passed, passed_at, attempts")
                    .eq("user_id", userId),
                supabase.from("badges").select("id, name, description, icon, sort_order").order("sort_order"),
                supabase.from("user_badges").select("badge_id, earned_at").eq("user_id", userId),
                supabase.from("player_stats")
                    .select("elo_rating, wins, losses, draws, matches_played, highest_elo")
                    .eq("user_id", userId)
                    .maybeSingle(),
            ]);

            // Fehler einzelner Abfragen (z. B. fehlende Leserechte) nicht
            // stumm als "0 %" anzeigen, sondern sichtbar machen.
            const fehler = [
                moduleRes, themenRes, scoresRes, levelsRes, levelProgRes, kursRes,
                attemptsRes, examsRes, zertRes, userZertRes, badgesRes, userBadgesRes, statsRes,
            ].map((r) => r.error?.message).filter(Boolean);
            if (fehler.length > 0) setStatsError(fehler[0] as string);

            // Lernmodule: gemeisterte Themen
            const modulIds = new Set((moduleRes.data ?? []).map((m) => Number(m.id)));
            const scoreMap = new Map<string, number>();
            for (const s of scoresRes.data ?? []) {
                scoreMap.set(`${s.modul_id}_${s.thema_id}`, Number(s.best_score));
            }
            let themenGesamt = 0;
            let themenGemeistert = 0;
            for (const t of themenRes.data ?? []) {
                if (!modulIds.has(Number(t.module_id))) continue;
                themenGesamt++;
                const noetig = Number(t.required_score ?? 80);
                if ((scoreMap.get(`${t.module_id}_${t.id}`) ?? 0) >= noetig) themenGemeistert++;
            }

            // Levels
            const bestLevel = new Map<number, number>();
            for (const p of levelProgRes.data ?? []) bestLevel.set(Number(p.level_id), Number(p.best_score ?? 0));
            const levelsAlle = levelsRes.data ?? [];
            const levelsGeschafft = levelsAlle.filter(
                (l) => (bestLevel.get(Number(l.id)) ?? 0) >= Number(l.schwelle ?? 80),
            ).length;

            // Kurse
            const geloest = (kursRes.data ?? []).map((k) => String(k.aufgabe_id));
            const kursBereiche: Bereich[] = Object.entries(KURS_AUFGABEN).map(([key, k]) => ({
                key,
                name: k.name,
                geschafft: Math.min(k.gesamt, geloest.filter((id) => id.startsWith(k.prefix)).length),
                gesamt: k.gesamt,
            }));

            setBereiche([
                { key: "module", name: "Lernmodule", geschafft: themenGemeistert, gesamt: themenGesamt },
                { key: "levels", name: "Levels", geschafft: levelsGeschafft, gesamt: levelsAlle.length },
                ...kursBereiche,
            ]);

            // Pruefungen: NUR die echten IHK-Simulationen (typ 'ihk').
            // Die Zertifikats-Uebungen (typ 'uebung') gehoeren zum Block
            // Zertifikate und sollen hier nicht doppelt auftauchen.
            const ihkExams = new Map<number, { name: string; info: string | null }>();
            for (const e of examsRes.data ?? []) {
                if (e.typ === "ihk") ihkExams.set(Number(e.id), { name: e.name, info: e.beschreibung });
            }
            const attempts = (attemptsRes.data ?? []).filter((a) => ihkExams.has(Number(a.exam_id)));
            setVersucheGesamt(attempts.length);
            // Alle BEWERTETEN Versuche zeigen (auch nicht bestandene), damit
            // niemand denkt, sein Ergebnis sei verloren. Bestanden ab 50 %.
            setPruefungen(
                attempts
                    .filter((a) => a.status === "graded" && a.percentage !== null)
                    .map((a) => {
                        const prozent = Math.round(Number(a.percentage ?? 0));
                        return {
                            id: String(a.id),
                            name: ihkExams.get(Number(a.exam_id))?.name ?? `Prüfung ${a.exam_id}`,
                            typ: ihkExams.get(Number(a.exam_id))?.info ?? null,
                            prozent,
                            datum: a.submitted_at,
                            bestanden: a.passed === true,
                            note: ihkNote(prozent),
                        };
                    }),
            );

            // Zertifikate
            const meine = new Map<number, { best: number | null; passed: boolean; passedAt: string | null; attempts: number }>();
            for (const z of userZertRes.data ?? []) {
                meine.set(Number(z.zertifikat_id), {
                    best: z.best_score,
                    passed: z.passed === true,
                    passedAt: z.passed_at,
                    attempts: Number(z.attempts ?? 0),
                });
            }
            setZertifikate(
                (zertRes.data ?? []).map((z) => {
                    const m = meine.get(Number(z.id));
                    return {
                        id: Number(z.id),
                        name: z.name,
                        anbieter: z.anbieter,
                        mindest: z.mindest_punktzahl,
                        best: m?.best ?? null,
                        passed: m?.passed ?? false,
                        passedAt: m?.passedAt ?? null,
                        attempts: m?.attempts ?? 0,
                    };
                }),
            );

            // Badges
            const earned = new Map<string, string>();
            for (const b of userBadgesRes.data ?? []) earned.set(String(b.badge_id), b.earned_at);
            setBadges(
                (badgesRes.data ?? [])
                    .filter((b) => earned.has(String(b.id)))
                    .map((b) => ({
                        id: String(b.id),
                        name: b.name,
                        description: b.description,
                        icon: b.icon,
                        earnedAt: earned.get(String(b.id))!,
                    })),
            );

            // Arena
            const s = statsRes.data;
            setArena(
                s && Number(s.matches_played ?? 0) > 0
                    ? {
                        elo: Number(s.elo_rating ?? 1000),
                        wins: Number(s.wins ?? 0),
                        losses: Number(s.losses ?? 0),
                        draws: Number(s.draws ?? 0),
                        matches: Number(s.matches_played ?? 0),
                        peak: Number(s.highest_elo ?? 0),
                    }
                    : null,
            );
        } catch (e) {
            setStatsError(e instanceof Error ? e.message : String(e));
        } finally {
            setStatsLoaded(true);
        }
    }

    const handleLogout = async () => {
        await supabase.auth.signOut();
        router.push("/");
    };

    const handlePortal = async () => {
        setPortalLoading(true);
        setPortalError(null);
        const err = await openCustomerPortal();
        if (err) {
            setPortalError(err);
            setPortalLoading(false);
        }
    };

    if (!authLoaded) {
        // Platzhalter mit Theme-Farben, damit es vor dem Login-Check
        // nicht kurz weiss aufblitzt.
        return (
            <div className="pf-wrap" style={{ minHeight: "100vh" }}>
                <style>{pfCss}</style>
            </div>
        );
    }

    const isPremium = sub.loaded && sub.isPremium;
    const bereitschaft = bereiche && bereiche.length > 0
        ? Math.round((bereiche.reduce((s, b) => s + (b.gesamt > 0 ? b.geschafft / b.gesamt : 0), 0) / bereiche.length) * 100)
        : 0;

    // Ring-Geometrie
    const R = 44;
    const UMFANG = 2 * Math.PI * R;
    const ringOffset = UMFANG * (1 - bereitschaft / 100);

    return (
        <div className="pf-wrap">
            <style>{pfCss}</style>

            <div className="pf-inner">
                <Link href="/" className="pf-back">← Zur Startseite</Link>

                <div className="pf-head">
                    <div className="pf-avatar">{(username ?? email ?? "?").charAt(0).toUpperCase()}</div>
                    <div>
                        <h1 className="pf-title">{username ?? "Dein Profil"}</h1>
                        <div className="pf-chips">
                            <span className={`pf-chip ${isPremium ? "premium" : ""}`}>{isPremium ? "Premium" : "Free"}</span>
                            {arena && <span className="pf-chip">Elo {arena.elo}</span>}
                            {badges.length > 0 && <span className="pf-chip">{badges.length} Badges</span>}
                        </div>
                    </div>
                </div>

                {/* ── PRÜFUNGSBEREITSCHAFT ── */}
                <div className="pf-section">Dein Fortschritt</div>
                <div className="pf-card">
                    <div className="pf-ready">
                        <svg className="pf-ring" viewBox="0 0 100 100" aria-hidden="true">
                            <circle cx="50" cy="50" r={R} className="pf-ring-bg" />
                            <circle
                                cx="50" cy="50" r={R}
                                className={`pf-ring-fg ${bereitschaft >= 100 ? "done" : ""}`}
                                strokeDasharray={UMFANG}
                                strokeDashoffset={statsLoaded ? ringOffset : UMFANG}
                            />
                        </svg>
                        <div className="pf-ready-text">
                            <div className="pf-label">Prüfungsbereit</div>
                            <div className="pf-ready-value">{statsLoaded ? bereitschaft : "–"}<span>%</span></div>
                            <div className="pf-muted">Durchschnitt aus Lernmodulen, Levels, SQL- und Python-Kurs</div>
                        </div>
                    </div>

                    <div className="pf-bereiche">
                        {(bereiche ?? []).map((b) => {
                            const p = prozent(b.geschafft, b.gesamt);
                            return (
                                <div className="pf-bereich" key={b.key}>
                                    <div className="pf-bereich-row">
                                        <span className={`pf-dot ${b.key}`} />
                                        <span className="pf-bereich-name">{b.name}</span>
                                        <span className="pf-mono">{b.geschafft}/{b.gesamt}</span>
                                        <span className="pf-bereich-pct">{p}%</span>
                                    </div>
                                    <div className="pf-bar"><div className={`pf-bar-fill ${b.key}`} style={{ width: `${p}%` }} /></div>
                                </div>
                            );
                        })}
                        {!statsLoaded && <div className="pf-muted">Lernstand wird geladen …</div>}
                        {statsError && <div className="pf-error">Lernstand konnte nicht geladen werden: {statsError}</div>}
                    </div>
                </div>

                {/* ── PRÜFUNGEN ── */}
                <div className="pf-section">
                    Prüfungen{pruefungen.length > 0 ? ` · ${pruefungen.filter((p) => p.bestanden).length}/${pruefungen.length} bestanden` : ""}
                </div>
                <div className="pf-card">
                    {pruefungen.length === 0 ? (
                        <div className="pf-muted">
                            {versucheGesamt > 0
                                ? `${versucheGesamt} ${versucheGesamt === 1 ? "Versuch abgegeben" : "Versuche abgegeben"}, aber noch ohne KI-Korrektur. Starte die Korrektur in der App, dann erscheint das Ergebnis hier.`
                                : "Noch keine Prüfungssimulation abgeschlossen. Starte in der App unter Prüfen."}
                        </div>
                    ) : (
                        <ul className="pf-list">
                            {pruefungen.map((p) => (
                                <li key={p.id} className="pf-item">
                                    <span className={p.bestanden ? "pf-ok" : "pf-open"}>{p.bestanden ? "✓" : "○"}</span>
                                    <div className="pf-item-main">
                                        <div className="pf-item-title">{p.name}</div>
                                        <div className="pf-muted">{p.typ ? `${p.typ} · ` : ""}{datum(p.datum)}</div>
                                    </div>
                                    <span className="pf-note" title={p.bestanden ? "Bestanden" : "Nicht bestanden"}>Note {p.note}</span>
                                    <span className={`pf-score ${p.bestanden ? "ok" : ""}`}>{p.prozent}%</span>
                                </li>
                            ))}
                        </ul>
                    )}
                    {versucheGesamt > pruefungen.length && (
                        <div className="pf-foot">
                            {versucheGesamt - pruefungen.length} {versucheGesamt - pruefungen.length === 1 ? "Versuch" : "Versuche"} abgegeben, noch ohne Bewertung
                        </div>
                    )}
                </div>

                {/* ── ZERTIFIKATE ── */}
                <div className="pf-section">
                    Zertifikate{zertifikate.length > 0 ? ` · ${zertifikate.filter((z) => z.passed).length}/${zertifikate.length}` : ""}
                </div>
                <div className="pf-card">
                    {zertifikate.length === 0 ? (
                        <div className="pf-muted">{statsLoaded ? "Keine Zertifikate verfügbar." : "Wird geladen …"}</div>
                    ) : (
                        <ul className="pf-list">
                            {zertifikate.map((z) => (
                                <li key={z.id} className="pf-item">
                                    <span className={z.passed ? "pf-ok" : "pf-open"}>{z.passed ? "✓" : "○"}</span>
                                    <div className="pf-item-main">
                                        <div className="pf-item-title">{z.name}</div>
                                        <div className="pf-muted">
                                            {z.anbieter ? `${z.anbieter} · ` : ""}
                                            {z.passed
                                                ? `Bestanden am ${datum(z.passedAt)}`
                                                : z.attempts > 0
                                                    ? `${z.attempts} ${z.attempts === 1 ? "Versuch" : "Versuche"}, bester Wert ${z.best ?? 0}%`
                                                    : "Noch nicht versucht"}
                                        </div>
                                    </div>
                                    {z.best !== null && (
                                        <span className={`pf-score ${z.passed ? "ok" : ""}`}>{z.best}%</span>
                                    )}
                                </li>
                            ))}
                        </ul>
                    )}
                </div>

                {/* ── BADGES ── */}
                <div className="pf-section">Badges{badges.length > 0 ? ` · ${badges.length}` : ""}</div>
                <div className="pf-card">
                    {badges.length === 0 ? (
                        <div className="pf-muted">Noch keine Badges. Die ersten gibt es für Kurs-Starts, gemeisterte Themen und Arena-Siege.</div>
                    ) : (
                        <div className="pf-badges">
                            {badges.map((b) => (
                                <div key={b.id} className="pf-badge" title={`${b.description ?? ""}\nVerdient am ${datum(b.earnedAt)}`}>
                                    <div className="pf-badge-icon">{b.icon || "🏅"}</div>
                                    <div className="pf-badge-name">{b.name}</div>
                                </div>
                            ))}
                        </div>
                    )}
                </div>

                {/* ── ARENA ── */}
                {arena && (
                    <>
                        <div className="pf-section">Arena</div>
                        <div className="pf-card">
                            <div className="pf-stats">
                                <div className="pf-stat"><div className="pf-stat-v">{arena.elo}</div><div className="pf-label">Elo</div></div>
                                <div className="pf-stat"><div className="pf-stat-v ok">{arena.wins}</div><div className="pf-label">Siege</div></div>
                                <div className="pf-stat"><div className="pf-stat-v err">{arena.losses}</div><div className="pf-label">Niederlagen</div></div>
                                <div className="pf-stat"><div className="pf-stat-v">{arena.draws}</div><div className="pf-label">Remis</div></div>
                                <div className="pf-stat"><div className="pf-stat-v">{arena.peak}</div><div className="pf-label">Peak Elo</div></div>
                            </div>
                            <div className="pf-foot">
                                {arena.matches} Matches · Siegquote {prozent(arena.wins, arena.matches)}%
                            </div>
                        </div>
                    </>
                )}

                {/* ── KONTO ── */}
                <div className="pf-section">Konto</div>
                <div className="pf-card">
                    {username && (
                        <>
                            <div className="pf-label">Benutzername</div>
                            <div className="pf-value">{username}</div>
                        </>
                    )}
                    <div className="pf-label">E-Mail</div>
                    <div className="pf-value">{email}</div>
                </div>

                {/* ── MITGLIEDSCHAFT ── */}
                <div className="pf-card">
                    <div className="pf-label">Mitgliedschaft</div>
                    <div className="pf-value" style={{ marginBottom: 0 }}>
                        <span className={`pf-chip big ${isPremium ? "premium" : ""}`}>{isPremium ? "Premium" : "Free"}</span>
                    </div>
                    {isPremium && <div className="pf-muted" style={{ marginTop: 10 }}>{sub.expiryLabel}</div>}
                    <div className="pf-btn-row">
                        {isPremium ? (
                            <button
                                className="pf-btn outline"
                                onClick={handlePortal}
                                disabled={portalLoading}
                                style={{ cursor: portalLoading ? "wait" : "pointer", opacity: portalLoading ? 0.6 : 1 }}
                            >
                                {portalLoading ? "Wird geladen …" : "Abo verwalten / kündigen"}
                            </button>
                        ) : (
                            <Link href="/upgrade" className="pf-btn primary">Premium freischalten</Link>
                        )}
                        {portalError && <p className="pf-error">{portalError}</p>}
                    </div>
                </div>

                <div className="pf-card">
                    <button className="pf-btn outline" onClick={handleLogout}>Abmelden</button>
                </div>
            </div>
        </div>
    );
}

const pfCss = `
  .pf-wrap {
    --bg: #08080C; --surface: #12121C; --surface-2: #171724;
    --border: rgba(255,255,255,0.08); --border-strong: rgba(255,255,255,0.16);
    --text: #F5F5F7; --text-body: #C8C8D2; --text-dim: #8E8EA0;
    --accent: #7C6DFF; --accent-soft: rgba(124,109,255,0.16); --accent-text: #C4BBFF;
    --cyan: #22D3EE; --ok: #34C759; --warn: #F59E0B; --err: #FF6B63; --info: #3B82F6;
    --chip-bg: rgba(255,255,255,0.05); --chip-border: rgba(255,255,255,0.10);
    font-family: var(--font-geist-sans), system-ui, sans-serif;
    background: var(--bg); color: var(--text);
    min-height: 100vh; padding: 56px 20px 100px; line-height: 1.5;
  }
  html[data-theme="light"] .pf-wrap {
    --bg: #FAFAF9; --surface: #FFFFFF; --surface-2: #F4F4F1;
    --border: rgba(10,10,15,0.10); --border-strong: rgba(10,10,15,0.18);
    --text: #0A0A0F; --text-body: #3A3A44; --text-dim: #6A6A74;
    --accent: #6A5AE8; --accent-soft: rgba(106,90,232,0.10); --accent-text: #5B4BE0;
    --ok: #1E9E50; --err: #D93B33;
    --chip-bg: rgba(10,10,15,0.04); --chip-border: rgba(10,10,15,0.12);
  }
  .pf-inner { max-width: 680px; margin: 0 auto; }
  .pf-back {
    display: inline-flex; align-items: center; gap: 8px;
    color: var(--text-dim); text-decoration: none; font-size: 13px; font-weight: 500;
    margin-bottom: 28px; padding: 8px 14px; border-radius: 8px;
    border: 1px solid var(--border); background: var(--surface); transition: all .2s;
  }
  .pf-back:hover { border-color: var(--border-strong); transform: translateX(-3px); }

  .pf-head { display: flex; align-items: center; gap: 18px; margin-bottom: 36px; }
  .pf-avatar {
    width: 64px; height: 64px; border-radius: 50%; flex-shrink: 0;
    display: flex; align-items: center; justify-content: center;
    font-size: 28px; font-weight: 600; color: var(--accent-text);
    background: var(--accent-soft); border: 1px solid var(--border-strong);
  }
  .pf-title { font-size: clamp(28px, 5vw, 38px); letter-spacing: -0.02em; margin: 0 0 8px; font-weight: 700; }
  .pf-chips { display: flex; gap: 8px; flex-wrap: wrap; }
  .pf-chip {
    display: inline-flex; align-items: center; padding: 4px 11px; border-radius: 100px;
    font-family: var(--font-geist-mono), ui-monospace, monospace;
    font-size: 11px; letter-spacing: .08em; text-transform: uppercase;
    background: var(--chip-bg); border: 1px solid var(--chip-border); color: var(--text-dim);
  }
  .pf-chip.premium { background: linear-gradient(135deg, #7C6DFF, #22D3EE); color: #fff; border-color: transparent; }
  .pf-chip.big { font-size: 13px; padding: 6px 14px; }

  .pf-section {
    font-family: var(--font-geist-mono), ui-monospace, monospace;
    font-size: 11px; letter-spacing: .12em; text-transform: uppercase; color: var(--accent-text);
    margin: 30px 0 10px; display: flex; align-items: center; gap: 10px;
  }
  .pf-section::before { content: ""; width: 16px; height: 1px; background: var(--accent); }
  .pf-card { background: var(--surface); border: 1px solid var(--border); border-radius: 16px; padding: 22px 24px; margin-bottom: 12px; }
  .pf-label {
    font-family: var(--font-geist-mono), ui-monospace, monospace;
    font-size: 11px; letter-spacing: .08em; color: var(--text-dim); text-transform: uppercase; margin-bottom: 6px;
  }
  .pf-value { font-size: 16px; font-weight: 500; margin-bottom: 18px; }
  .pf-value:last-child { margin-bottom: 0; }
  .pf-muted { font-size: 13.5px; color: var(--text-dim); }
  .pf-mono { font-family: var(--font-geist-mono), ui-monospace, monospace; font-size: 12px; color: var(--text-dim); }
  .pf-foot { margin-top: 14px; padding-top: 12px; border-top: 1px solid var(--border); font-size: 13px; color: var(--text-dim); }
  .pf-error { color: var(--err); font-size: 13px; margin-top: 12px; }

  /* Bereitschaft */
  .pf-ready { display: flex; flex-wrap: wrap; align-items: center; gap: 22px; padding-bottom: 20px; border-bottom: 1px solid var(--border); margin-bottom: 18px; }
  .pf-ring { width: 112px; height: 112px; flex-shrink: 0; transform: rotate(-90deg); }
  .pf-ring-bg { fill: none; stroke: var(--border-strong); stroke-width: 8; }
  .pf-ring-fg { fill: none; stroke: var(--accent); stroke-width: 8; stroke-linecap: round; transition: stroke-dashoffset 1s ease; }
  .pf-ring-fg.done { stroke: var(--ok); }
  .pf-ready-value { font-size: 44px; font-weight: 700; letter-spacing: -0.03em; line-height: 1.05; margin: 4px 0 6px; }
  .pf-ready-value span { font-size: 20px; color: var(--text-dim); font-weight: 500; margin-left: 2px; }
  .pf-bereiche { display: grid; gap: 14px; }
  .pf-bereich-row { display: flex; align-items: center; gap: 10px; margin-bottom: 6px; font-size: 14.5px; }
  .pf-bereich-name { flex: 1; font-weight: 500; }
  .pf-bereich-pct { font-weight: 600; min-width: 42px; text-align: right; }
  .pf-dot { width: 10px; height: 10px; border-radius: 3px; background: var(--accent); }
  .pf-dot.levels, .pf-bar-fill.levels { background: var(--warn); }
  .pf-dot.sql, .pf-bar-fill.sql { background: var(--info); }
  .pf-dot.python, .pf-bar-fill.python { background: var(--ok); }
  .pf-bar { height: 8px; border-radius: 99px; background: var(--chip-bg); border: 1px solid var(--border); overflow: hidden; }
  .pf-bar-fill { height: 100%; border-radius: 99px; background: var(--accent); transition: width .8s ease; }

  /* Listen */
  .pf-list { list-style: none; margin: 0; padding: 0; display: grid; gap: 4px; }
  .pf-item { display: flex; align-items: center; gap: 14px; padding: 10px 0; border-bottom: 1px solid var(--border); }
  .pf-item:last-child { border-bottom: none; }
  .pf-item-main { flex: 1; min-width: 0; }
  .pf-item-title { font-weight: 500; font-size: 15px; }
  .pf-ok, .pf-open {
    width: 28px; height: 28px; border-radius: 50%; flex-shrink: 0;
    display: flex; align-items: center; justify-content: center; font-size: 14px; font-weight: 700;
  }
  .pf-ok { background: rgba(52,199,89,0.16); color: var(--ok); }
  .pf-open { background: var(--chip-bg); color: var(--text-dim); border: 1px solid var(--chip-border); }
  .pf-score { font-family: var(--font-geist-mono), ui-monospace, monospace; font-size: 14px; font-weight: 600; color: var(--text-dim); }
  .pf-score.ok { color: var(--ok); }
  .pf-note {
    font-family: var(--font-geist-mono), ui-monospace, monospace; font-size: 11px; letter-spacing: .06em;
    padding: 3px 8px; border-radius: 99px; background: var(--chip-bg); border: 1px solid var(--chip-border); color: var(--text-dim);
    white-space: nowrap;
  }

  /* Badges */
  .pf-badges { display: grid; grid-template-columns: repeat(auto-fill, minmax(96px, 1fr)); gap: 10px; }
  .pf-badge {
    display: flex; flex-direction: column; align-items: center; gap: 6px; text-align: center;
    padding: 14px 8px; border-radius: 12px; background: var(--surface-2); border: 1px solid var(--border);
  }
  .pf-badge-icon { font-size: 28px; line-height: 1; }
  .pf-badge-name { font-size: 12px; color: var(--text-body); line-height: 1.25; }

  /* Arena */
  .pf-stats { display: grid; grid-template-columns: repeat(5, 1fr); gap: 8px; }
  @media (max-width: 560px) { .pf-stats { grid-template-columns: repeat(3, 1fr); } }
  .pf-stat { text-align: center; padding: 10px 4px; border-radius: 10px; background: var(--surface-2); border: 1px solid var(--border); }
  .pf-stat .pf-label { margin-bottom: 0; margin-top: 4px; font-size: 10px; }
  .pf-stat-v { font-size: 24px; font-weight: 700; letter-spacing: -0.02em; }
  .pf-stat-v.ok { color: var(--ok); }
  .pf-stat-v.err { color: var(--err); }

  /* Buttons */
  .pf-btn {
    display: block; width: 100%; text-align: center; padding: 13px; border-radius: 10px;
    font-size: 14px; font-weight: 600; cursor: pointer; border: none; text-decoration: none; transition: all .15s;
    font-family: inherit;
  }
  .pf-btn.primary { background: var(--accent); color: #fff; }
  .pf-btn.primary:hover { opacity: .88; }
  .pf-btn.outline { background: var(--surface); color: var(--text); border: 1px solid var(--border-strong); }
  .pf-btn.outline:hover { background: var(--surface-2); }
  .pf-btn-row { display: flex; flex-direction: column; gap: 12px; margin-top: 14px; }
`;
