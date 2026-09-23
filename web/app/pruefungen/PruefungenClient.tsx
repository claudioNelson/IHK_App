"use client";

// Uebersicht der Uebungspruefungen als Liste, gruppiert nach AP1, AP2 AE
// und AP2 SI. Bekommt nur die Metadaten (ohne Aufgaben), siehe page.tsx.
//
// Status je Zeile aus localStorage: laeuft (mit Restzeit), abgegeben oder
// Ergebnis mit Note und Prozent. Ohne Premium steht oben einmal ein
// Hinweis, jede Zeile fuehrt mit Schloss zu /upgrade (nicht angemeldet:
// /login). Solange Login und Abo laden, zeigt die Liste einen neutralen
// Zustand mit Skeletten statt erst gesperrt und dann offen.

import { useEffect, useState } from "react";
import Link from "next/link";
import type { ExamSummary } from "@/data/exam-types";
import { createClient } from "@/lib/supabase/client";
import { useSubscription } from "@/lib/hooks/useSubscription";
import PageShell from "@/app/components/shell/PageShell";
import Icon from "@/app/components/ExamIcons";
import { readJson, readNumber, readStore, type StoredErgebnis } from "./exam-state";

type Access = "loading" | "premium" | "free" | "guest";

type RowState =
  | { kind: "running"; leftMin: number | null } // null = Uebungsmodus
  | { kind: "submitted" }
  | { kind: "graded"; note: number; prozent: number };

interface Group {
  key: string;
  title: string;
  sub: string;
  exams: ExamSummary[];
}

function groupExams(list: ExamSummary[]): Group[] {
  const level = (e: ExamSummary) => e.level ?? "ap2";
  const ap1 = list.filter((e) => level(e) === "ap1");
  const ae = list.filter((e) => level(e) === "ap2" && e.fachrichtung === "ae");
  const si = list.filter((e) => level(e) === "ap2" && e.fachrichtung === "si");
  const rest = list.filter((e) => !ap1.includes(e) && !ae.includes(e) && !si.includes(e));
  const groups: Group[] = [
    { key: "ap1", title: "AP1", sub: "Abschlussprüfung Teil 1, für alle Fachrichtungen", exams: ap1 },
    { key: "ae", title: "AP2 Anwendungsentwicklung", sub: "Abschlussprüfung Teil 2", exams: ae },
    { key: "si", title: "AP2 Systemintegration", sub: "Abschlussprüfung Teil 2", exams: si },
    { key: "weitere", title: "Weitere Prüfungen", sub: "Abschlussprüfung Teil 2", exams: rest },
  ];
  return groups.filter((g) => g.exams.length > 0);
}

function readRowState(e: ExamSummary, now: number): RowState | null {
  const erg = readJson<StoredErgebnis>(e.id, "ergebnis");
  const g = erg?.result?.gesamt;
  if (g && Number.isFinite(Number(g.note)) && Number.isFinite(Number(g.prozent))) {
    return { kind: "graded", note: Number(g.note), prozent: Number(g.prozent) };
  }
  if (readStore(e.id, "submitted") === "true") return { kind: "submitted" };
  const startedAt = readNumber(e.id, "startedAt");
  if (startedAt) {
    if (readStore(e.id, "mode") === "uebung") return { kind: "running", leftMin: null };
    const leftS = e.duration * 60 - (now - startedAt) / 1000;
    return { kind: "running", leftMin: Math.max(0, Math.ceil(leftS / 60)) };
  }
  return null;
}

function StateBadge({ state }: { state: RowState | null | undefined }) {
  if (!state) return null;
  if (state.kind === "graded") {
    return (
      <span className="ex-status">
        <Icon name="check-c" />
        Note {state.note}, {state.prozent} %
      </span>
    );
  }
  if (state.kind === "submitted") {
    return (
      <span className="ex-status">
        <Icon name="check" />
        Abgegeben
      </span>
    );
  }
  let label: string;
  if (state.leftMin === null) label = "Läuft, Übungsmodus";
  else if (state.leftMin <= 0) label = "Zeit abgelaufen";
  else label = `Läuft, noch ${state.leftMin} Min`;
  return (
    <span className="ex-status is-accent">
      <Icon name="play" />
      {label}
    </span>
  );
}

export default function PruefungenClient({ examList }: { examList: ExamSummary[] }) {
  const subscription = useSubscription();
  const [authLoaded, setAuthLoaded] = useState(false);
  const [loggedIn, setLoggedIn] = useState(false);
  const [states, setStates] = useState<Record<string, RowState | null>>({});

  useEffect(() => {
    const supabase = createClient();
    let alive = true;
    supabase.auth.getUser().then(({ data: { user } }) => {
      if (!alive) return;
      setLoggedIn(!!user);
      setAuthLoaded(true);
    });
    const { data: { subscription: authSub } } = supabase.auth.onAuthStateChange((_event, session) => {
      if (alive) setLoggedIn(!!session?.user);
    });
    return () => {
      alive = false;
      authSub.unsubscribe();
    };
  }, []);

  // Versuchsstatus aus localStorage, Restzeit alle 30 Sekunden neu
  useEffect(() => {
    const read = () => {
      const now = Date.now();
      const next: Record<string, RowState | null> = {};
      for (const e of examList) next[e.id] = readRowState(e, now);
      setStates(next);
    };
    read();
    const h = window.setInterval(read, 30_000);
    return () => window.clearInterval(h);
  }, [examList]);

  const access: Access =
    !authLoaded || !subscription.loaded ? "loading" : !loggedIn ? "guest" : subscription.isPremium ? "premium" : "free";

  const groups = groupExams(examList);

  return (
    <PageShell className="ex">
      <div className="ex-overview">
        <div className="wrap">
          <header className="page-head">
            <h1>Übungsprüfungen</h1>
            <p className="lead">
              Eigene Aufgaben im Stil der IHK-Abschlussprüfung, mit festem Zeitlimit und Korrektur durch Ada nach Punkteschema.
            </p>
          </header>

          {(access === "free" || access === "guest") && (
            <section className="ex-panel ex-upsell" aria-labelledby="ex-h-upsell">
              <div>
                <h2 id="ex-h-upsell">Übungsprüfungen gehören zu Premium</h2>
                <p>
                  Du siehst alle Prüfungen. Bearbeiten, abgeben und von Ada korrigieren lassen kannst du sie mit Premium, ab 11,99 € im Monat, jederzeit kündbar.
                </p>
              </div>
              <div className="ex-upsell-actions">
                <Link className="btn btn-primary" href="/upgrade?next=/pruefungen">Premium ansehen</Link>
              </div>
            </section>
          )}

          {groups.map((g) => (
            <section className="ex-group" aria-labelledby={`ex-h-${g.key}`} key={g.key}>
              <div className="ex-group-head">
                <h2 id={`ex-h-${g.key}`}>{g.title}</h2>
                <p>{g.sub}</p>
              </div>
              <ul className="ex-panel ex-list">
                {g.exams.map((e) => (
                  <li key={e.id}>
                    <ExamRow exam={e} access={access} state={states[e.id]} />
                  </li>
                ))}
              </ul>
            </section>
          ))}
        </div>
      </div>
    </PageShell>
  );
}

function ExamRow({ exam, access, state }: { exam: ExamSummary; access: Access; state: RowState | null | undefined }) {
  const locked = access === "free" || access === "guest";
  const target = `/pruefung/${exam.id}`;
  // Waehrend des Ladens fuehrt die Zeile direkt zur Pruefung, der
  // Server-Guard leitet bei Bedarf zu Login oder Upgrade weiter.
  const href =
    access === "guest" ? `/login?next=${target}` : access === "free" ? `/upgrade?next=${target}` : target;
  const choose = exam.sectionsToChoose && exam.sectionsToChoose < exam.sectionCount ? exam.sectionsToChoose : null;
  const facts = `${exam.duration} Min · ${choose ? `${choose} von ${exam.sectionCount}` : exam.sectionCount} Aufgaben`;

  return (
    <Link className={locked ? "ex-row is-locked" : "ex-row"} href={href} aria-busy={access === "loading" || undefined}>
      <span className="ex-row-when">
        <b>{exam.year}</b>
        {exam.season}
      </span>
      <span className="ex-row-main">
        <span className="ex-row-title">
          {exam.title}
          {locked && <span className="ex-sr">, {access === "guest" ? "anmelden und " : ""}mit Premium freischalten</span>}
        </span>
        <span className="ex-row-sub" style={{ display: "block" }}>{exam.company}</span>
      </span>
      <span className="ex-row-facts">{facts}</span>
      <span className="ex-row-state">
        {access === "loading" ? (
          <span className="ex-skel" style={{ width: 112, height: 26 }} />
        ) : access === "premium" ? (
          <StateBadge state={state} />
        ) : null}
      </span>
      <span className="ex-row-go">
        {access === "loading" ? null : locked ? <Icon name="lock" className={null} /> : <Icon name="arrow-r" className={null} />}
      </span>
    </Link>
  );
}
