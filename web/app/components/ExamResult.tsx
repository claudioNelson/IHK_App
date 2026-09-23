"use client";

// Ergebnisseite nach der Abgabe.
// Reihenfolge: Note gross, Punkte mit Bestanden-Status und Notenskala,
// Adas Kommentar, Staerken, Verbesserungen, Lernempfehlungen, dann die
// Aufgaben im Detail. Vor der Korrektur: Karte mit "Korrektur anfordern"
// und die Abgabe ohne Punkte; waehrend der Korrektur gesperrt mit Skelett;
// im Fehlerfall ein Hinweis mit "Erneut anfordern".
//
// Note, Prozent und Bestanden kommen fertig aus /api/ki-korrektur
// (normalizeResult). Hier wird nur noch auf gueltige Werte begrenzt.
// Das Ergebnis liegt in exam-{id}-ergebnis und uebersteht einen Reload,
// damit ein Neuladen keine neue Korrektur und keinen neuen Versuch ausloest.

import { useEffect, useMemo, useRef, useState, type RefObject } from "react";
import Link from "next/link";
import type { Exam } from "@/data/exam-types";
import { createClient } from "@/lib/supabase/client";
import PageShell from "@/app/components/shell/PageShell";
import Icon from "./ExamIcons";
import ExamDialog from "./ExamDialog";
import { TextBlocks } from "./ExamText";
import {
  answerableQuestions,
  groupLabel,
  hasAnswer,
  passPoints,
  questionLabels,
  writeStore,
  type KiAufgabe,
  type KiEmpfehlung,
  type KiResult,
  type KiTeilaufgabe,
  type ProfileSave,
  type StoredErgebnis,
} from "@/app/pruefungen/exam-state";

interface ExamResultProps {
  exam: Exam;
  answers: Record<string, string>;
  startedAt: number | null;
  submittedAt: number | null;
  practice: boolean;
  initialErgebnis: StoredErgebnis | null;
  onErgebnis: (e: StoredErgebnis) => void;
  onReset: () => void;
}

// ------------------------------------------------------------------
// Begrenzen statt neu berechnen
// ------------------------------------------------------------------
const num = (v: unknown, fallback = 0) => {
  const n = Number(v);
  return Number.isFinite(n) ? n : fallback;
};
const clamp = (n: number, lo: number, hi: number) => Math.min(hi, Math.max(lo, n));
const text = (v: unknown): string | undefined => {
  if (typeof v === "string") return v.trim() || undefined;
  if (Array.isArray(v)) return v.filter((x) => typeof x === "string").join("\n\n").trim() || undefined;
  return undefined;
};
const textList = (v: unknown): string[] =>
  Array.isArray(v) ? v.filter((x): x is string => typeof x === "string" && x.trim() !== "") : [];

function cleanTeil(raw: unknown): KiTeilaufgabe {
  const t = (raw ?? {}) as Record<string, unknown>;
  const maxPunkte = Math.max(0, num(t.maxPunkte));
  return {
    titel: text(t.titel),
    maxPunkte,
    punkte: clamp(num(t.punkte), 0, maxPunkte),
    beantwortet: typeof t.beantwortet === "boolean" ? t.beantwortet : undefined,
    kommentar: text(t.kommentar),
  };
}

function cleanAufgabe(raw: unknown): KiAufgabe {
  const a = (raw ?? {}) as Record<string, unknown>;
  const maxPunkte = Math.max(0, num(a.maxPunkte));
  return {
    titel: text(a.titel),
    maxPunkte,
    punkte: clamp(num(a.punkte), 0, maxPunkte),
    teilaufgaben: Array.isArray(a.teilaufgaben) ? a.teilaufgaben.map(cleanTeil) : [],
  };
}

function cleanEmpfehlung(raw: unknown): KiEmpfehlung | null {
  if (typeof raw === "string") return raw.trim() ? raw : null;
  if (raw && typeof raw === "object") {
    const r = raw as Record<string, unknown>;
    const titel = text(r.titel);
    return titel ? { titel, wo: text(r.wo) } : null;
  }
  return null;
}

function cleanResult(raw: unknown): KiResult | null {
  if (!raw || typeof raw !== "object") return null;
  const r = raw as Record<string, unknown>;
  const g = r.gesamt as Record<string, unknown> | undefined;
  if (!g || typeof g !== "object") return null;
  const note = num(g.note, NaN);
  if (!Number.isFinite(note)) return null;
  const maxPunkte = Math.max(0, num(g.maxPunkte));
  return {
    gesamt: {
      punkte: clamp(num(g.punkte), 0, maxPunkte),
      maxPunkte,
      prozent: clamp(Math.round(num(g.prozent)), 0, 100),
      note: clamp(Math.round(note), 1, 6),
      noteText: text(g.noteText) ?? "",
      bestanden: g.bestanden === true,
      kommentar: text(g.kommentar),
    },
    aufgaben: Array.isArray(r.aufgaben) ? r.aufgaben.map(cleanAufgabe) : [],
    staerken: textList(r.staerken),
    verbesserungen: textList(r.verbesserungen),
    lernempfehlungen: Array.isArray(r.lernempfehlungen)
      ? r.lernempfehlungen.map(cleanEmpfehlung).filter((x): x is KiEmpfehlung => x !== null)
      : [],
  };
}

// IHK-Notenschluessel in Prozent: ab 92 / 81 / 67 / 50 / 30
const SCALE = [
  { n: 6, from: 0, to: 30 },
  { n: 5, from: 30, to: 50 },
  { n: 4, from: 50, to: 67 },
  { n: 3, from: 67, to: 81 },
  { n: 2, from: 81, to: 92 },
  { n: 1, from: 92, to: 100 },
];

const pad = (n: number) => String(n).padStart(2, "0");
function formatDate(ms: number): string {
  const d = new Date(ms);
  return `${pad(d.getDate())}.${pad(d.getMonth() + 1)}.${d.getFullYear()} um ${pad(d.getHours())}:${pad(d.getMinutes())}`;
}
const punkteWort = (n: number) => (n === 1 ? "Punkt" : "Punkte");

export default function ExamResult({
  exam,
  answers,
  startedAt,
  submittedAt,
  practice,
  initialErgebnis,
  onErgebnis,
  onReset,
}: ExamResultProps) {
  const [ergebnis, setErgebnis] = useState<StoredErgebnis | null>(initialErgebnis);
  const [kiLoading, setKiLoading] = useState(false);
  const [kiError, setKiError] = useState<string | null>(null);
  const [step, setStep] = useState(1);
  const [resetOpen, setResetOpen] = useState(false);
  const inFlight = useRef(false);
  const alive = useRef(true);
  const gradeHeading = useRef<HTMLHeadingElement>(null);
  const focusGrade = useRef(false);

  const labels = useMemo(() => questionLabels(exam), [exam]);
  const parts = useMemo(() => answerableQuestions(exam), [exam]);
  const answeredCount = parts.filter((q) => hasAnswer(answers[q.id])).length;
  const result = useMemo(() => (ergebnis?.result ? cleanResult(ergebnis.result) : null), [ergebnis]);
  const feedback = !result && ergebnis?.feedback ? ergebnis.feedback : null;
  const minutes = startedAt && submittedAt && submittedAt > startedAt ? Math.max(1, Math.round((submittedAt - startedAt) / 60000)) : null;

  // Schrittzaehler waehrend der Korrektur ("Aufgabe 2 von 4")
  useEffect(() => {
    if (!kiLoading) return;
    const h = window.setInterval(() => {
      setStep((s) => Math.min(s + 1, Math.max(1, exam.sections.length)));
    }, 4000);
    return () => window.clearInterval(h);
  }, [kiLoading, exam.sections.length]);

  useEffect(() => {
    alive.current = true;
    return () => {
      alive.current = false;
    };
  }, []);

  // Beim Drucken alle Aufgaben aufklappen
  useEffect(() => {
    const open = () => document.querySelectorAll<HTMLDetailsElement>(".ex-task").forEach((d) => (d.open = true));
    window.addEventListener("beforeprint", open);
    return () => window.removeEventListener("beforeprint", open);
  }, []);

  // Nach einer frischen Korrektur den Fokus auf das Ergebnis setzen
  useEffect(() => {
    if (result && focusGrade.current) {
      focusGrade.current = false;
      gradeHeading.current?.focus();
    }
  }, [result]);

  const persist = (next: StoredErgebnis) => {
    // Nach "Neu beginnen" (Unmount) nichts mehr zurueckschreiben
    if (!alive.current) return;
    setErgebnis(next);
    onErgebnis(next);
    writeStore(exam.id, "ergebnis", JSON.stringify(next));
  };

  // Ergebnis in user_exam_attempts schreiben (Profil in Web und App).
  const saveAttempt = async (res: KiResult, stored: StoredErgebnis) => {
    let status: ProfileSave = "error";
    try {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) {
        status = "guest";
      } else {
        const { data: examRow, error: examError } = await supabase
          .from("exams")
          .select("id")
          .eq("slug", exam.id)
          .maybeSingle();
        if (examError || !examRow) {
          console.warn("Kein exams-Eintrag fuer Slug", exam.id, examError?.message);
        } else {
          const jetzt = new Date();
          const { error } = await supabase.from("user_exam_attempts").insert({
            user_id: user.id,
            exam_id: examRow.id,
            started_at: new Date(startedAt ?? submittedAt ?? jetzt.getTime()).toISOString(),
            submitted_at: jetzt.toISOString(),
            total_points: res.gesamt.maxPunkte,
            achieved_points: res.gesamt.punkte,
            percentage: res.gesamt.prozent,
            passed: res.gesamt.bestanden,
            status: "graded",
          });
          if (error) console.warn("Ergebnis speichern fehlgeschlagen:", error.message);
          else status = "saved";
        }
      }
    } catch (e) {
      console.warn("Ergebnis speichern fehlgeschlagen:", e);
    }
    persist({ ...stored, profile: status });
  };

  const requestKorrektur = async () => {
    if (inFlight.current) return; // kein Doppelklick, keine doppelten Versuche
    inFlight.current = true;
    setKiLoading(true);
    setKiError(null);
    setStep(1);
    try {
      // "completed" erwartet die Route weiterhin, abgeleitet aus den Antworten
      const completed: Record<string, boolean> = {};
      for (const q of parts) completed[q.id] = hasAnswer(answers[q.id]);

      const response = await fetch("/api/ki-korrektur", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ examId: exam.id, answers, completed }),
      });
      let data: { error?: string; result?: unknown; feedback?: string } = {};
      try {
        data = await response.json();
      } catch {
        // z. B. HTML-Fehlerseite statt JSON
      }
      if (!response.ok) throw new Error(data.error || `Fehler ${response.status}.`);

      if (data.result) {
        const res = cleanResult(data.result);
        if (!res) throw new Error("Adas Antwort war unvollständig.");
        const stored: StoredErgebnis = { result: res, feedback: null, at: Date.now() };
        focusGrade.current = true;
        persist(stored);
        void saveAttempt(res, stored);
      } else if (data.feedback) {
        persist({ result: null, feedback: data.feedback, at: Date.now() });
      } else {
        throw new Error("Keine Antwort erhalten.");
      }
    } catch (error) {
      const msg = error instanceof Error ? error.message.trim() : "";
      // "" = fehlgeschlagen ohne eigenen Text
      setKiError(msg ? (/[.!?]$/.test(msg) ? msg : `${msg}.`) : "");
    } finally {
      inFlight.current = false;
      setKiLoading(false);
    }
  };

  const failed = kiError !== null;

  return (
    <PageShell className="ex">
      <div className="ex-result">
        <header className="page-head">
          <nav className="crumbs" aria-label="Brotkrumen">
            <Link href="/pruefungen">Prüfungen</Link>
            <span aria-hidden="true">/</span>
            <span>Ergebnis</span>
          </nav>
          <h1>{exam.title}</h1>
          <p className="ex-meta">
            <span>{groupLabel(exam.level, exam.fachrichtung)}, {exam.season} {exam.year}</span>
            {submittedAt !== null && <span>Abgegeben am {formatDate(submittedAt)}</span>}
            {minutes !== null && <span>Bearbeitungszeit {minutes} Min{practice ? ", Übungsmodus" : ""}</span>}
          </p>
        </header>

        {result ? (
          <>
            <GradeBlock result={result} headingRef={gradeHeading} profile={ergebnis?.profile} />
            <AdaBlock result={result} labels={labels} />
            <DetailsBlock exam={exam} result={result} answers={answers} labels={labels} />
          </>
        ) : feedback && !kiLoading ? (
          <>
            <section className="ex-ada ex-reveal" aria-labelledby="ex-h-ada">
              <span className="ex-avatar" aria-hidden="true">A</span>
              <div>
                <h2 className="ex-ada-name" id="ex-h-ada">Ada <span>KI-Tutorin</span></h2>
                <TextBlocks text={feedback} className="ex-ada-text ex-feedback-text" />
                {failed && (
                  <div className="ex-note is-err" role="alert" style={{ marginTop: 16 }}>
                    <Icon name="alert" />
                    <span><b>Die Korrektur hat nicht geklappt.</b> {kiError ? `${kiError} ` : ""}Versuch es in einem Moment noch einmal.</span>
                  </div>
                )}
              </div>
            </section>
            <SubmissionBlock exam={exam} answers={answers} labels={labels} />
          </>
        ) : (
          <>
            <section className="ex-panel ex-pending" aria-labelledby="ex-h-pending" aria-busy={kiLoading || undefined}>
              <span className="ex-avatar" aria-hidden="true">A</span>
              <div>
                <h2 id="ex-h-pending">{kiLoading ? "Ada korrigiert deine Abgabe" : "Bereit für die Korrektur"}</h2>
                <p>
                  {kiLoading
                    ? "Jede Teilaufgabe wird nach Punkteschema bewertet und kommentiert. Bitte lass die Seite geöffnet, bis das Ergebnis da ist."
                    : "Ada bewertet jede Teilaufgabe nach dem Punkteschema und erklärt, wo Punkte fehlen. Das dauert meist unter einer Minute."}
                </p>
                <p className="ex-facts-row">
                  <span>Beantwortet <b>{answeredCount} von {parts.length}</b> Teilaufgaben</span>
                  {minutes !== null && <span>Bearbeitungszeit <b>{minutes} Min</b></span>}
                </p>
              </div>
              {failed && !kiLoading && (
                <div className="ex-note is-err" role="alert">
                  <Icon name="alert" />
                  <span>
                    <b>Die Korrektur hat nicht geklappt.</b> {kiError ? `${kiError} ` : ""}Deine Abgabe ist gespeichert, es entstehen keine doppelten Versuche. Versuch es in einem Moment noch einmal.
                  </span>
                </div>
              )}
              <div className="ex-pending-actions">
                {kiLoading ? (
                  <>
                    <button className="btn btn-primary" type="button" disabled aria-busy="true">Ada korrigiert</button>
                    <span className="ex-progress-line" aria-live="polite">
                      <span className="ex-dots" aria-hidden="true"><i /><i /><i /></span>
                      <span>Aufgabe {step} von {exam.sections.length}</span>
                    </span>
                  </>
                ) : (
                  <button className="btn btn-primary" type="button" onClick={requestKorrektur}>
                    {failed ? "Erneut anfordern" : "Korrektur anfordern"}
                  </button>
                )}
              </div>
            </section>
            {kiLoading ? <Skeleton /> : <SubmissionBlock exam={exam} answers={answers} labels={labels} />}
          </>
        )}

        {!kiLoading && (
          <nav className="ex-actions" aria-label="Weiter">
            <Link className="btn btn-ghost" href="/pruefungen">
              <Icon name="arrow-l" className={null} />
              Zur Übersicht
            </Link>
            {result && (
              <button className="btn btn-ghost" type="button" onClick={() => window.print()}>
                <Icon name="print" className={null} />
                Drucken
              </button>
            )}
            {feedback && (
              <button className="btn btn-ghost" type="button" onClick={requestKorrektur}>
                <Icon name="refresh" className={null} />
                Nochmal korrigieren
              </button>
            )}
            <button className={result ? "btn btn-primary" : "btn btn-ghost"} type="button" onClick={() => setResetOpen(true)}>
              <Icon name="refresh" className={null} />
              Nochmal versuchen
            </button>
          </nav>
        )}
      </div>

      <ExamDialog open={resetOpen} onClose={() => setResetOpen(false)} labelledBy="ex-dlg-reset-h" describedBy="ex-dlg-reset-text">
        <div className="ex-dialog-body">
          <h2 id="ex-dlg-reset-h">Prüfung neu beginnen?</h2>
          <p id="ex-dlg-reset-text">
            Deine Antworten und Adas Korrektur auf diesem Gerät werden gelöscht. Ergebnisse, die schon im Profil gespeichert sind, bleiben erhalten.
          </p>
        </div>
        <div className="ex-dialog-actions">
          <button className="btn btn-ghost" type="button" onClick={() => setResetOpen(false)} data-autofocus>
            Abbrechen
          </button>
          <button
            className="btn btn-primary"
            type="button"
            onClick={() => {
              setResetOpen(false);
              onReset();
            }}
          >
            Neu beginnen
          </button>
        </div>
      </ExamDialog>
    </PageShell>
  );
}

// ------------------------------------------------------------------
// Note, Punkte, Notenskala
// ------------------------------------------------------------------
function GradeBlock({
  result,
  headingRef,
  profile,
}: {
  result: KiResult;
  headingRef: RefObject<HTMLHeadingElement | null>;
  profile?: ProfileSave;
}) {
  const g = result.gesamt;
  const next = SCALE.find((s) => s.n === g.note - 1);
  const toNext = next ? Math.max(0, Math.ceil((next.from * g.maxPunkte) / 100) - g.punkte) : 0;

  return (
    <>
      <section className="ex-panel ex-grade ex-reveal" aria-labelledby="ex-h-grade">
        <h2 className="ex-sr" id="ex-h-grade" ref={headingRef} tabIndex={-1}>Gesamtergebnis</h2>
        <p className="ex-grade-num">
          <span className="ex-grade-label">Note</span>
          <b>{g.note}</b>
          {g.noteText && <span>{g.noteText}</span>}
        </p>
        <div className="ex-grade-side">
          <div className="ex-score">
            <b>
              {g.punkte} <small>von {g.maxPunkte} Punkten</small>
            </b>
            <span className="ex-score-pct">{g.prozent} %</span>
            {g.bestanden ? (
              <span className="ex-status is-ok"><Icon name="check-c" />Bestanden</span>
            ) : (
              <span className="ex-status is-err"><Icon name="x-c" />Nicht bestanden</span>
            )}
          </div>
          <div className="ex-scale" role="img" aria-label={`Notenskala: ${g.prozent} Prozent liegen im Bereich der Note ${g.note}.`}>
            <div className="ex-scale-track">
              {SCALE.map((s) => (
                <i key={s.n} style={{ flex: s.to - s.from }} className={s.n === g.note ? "is-here" : undefined} />
              ))}
            </div>
            <span className="ex-scale-mark" style={{ left: `${g.prozent}%` }} />
            <div className="ex-scale-labels" aria-hidden="true">
              {SCALE.map((s) => (
                <span key={s.n} style={{ flex: s.to - s.from }} className={s.n === g.note ? "is-here" : undefined}>
                  {s.n}
                </span>
              ))}
            </div>
          </div>
          <p className="ex-scale-note">
            {next && toNext > 0 && (
              <>
                Noch <b>{toNext} {punkteWort(toNext)}</b> bis Note {next.n}.{" "}
              </>
            )}
            Bestanden ab {passPoints(g.maxPunkte)} Punkten.
          </p>
        </div>
      </section>
      {profile === "saved" && (
        <p className="ex-saveline ex-reveal">
          <Icon name="check" />
          Im Profil gespeichert. <Link href="/profil">Verlauf ansehen</Link>
        </p>
      )}
      {profile === "guest" && (
        <p className="ex-saveline ex-reveal">
          <Icon name="alert" style={{ color: "var(--warn)" }} />
          Nicht im Profil gespeichert, du bist nicht angemeldet. <Link href="/login?next=/profil">Anmelden</Link>
        </p>
      )}
      {profile === "error" && (
        <p className="ex-saveline ex-reveal">
          <Icon name="alert" style={{ color: "var(--warn)" }} />
          Das Ergebnis konnte nicht im Profil gespeichert werden. Auf diesem Gerät bleibt es erhalten.
        </p>
      )}
    </>
  );
}

// ------------------------------------------------------------------
// Adas Kommentar, Staerken, Verbesserungen, Lernempfehlungen
// ------------------------------------------------------------------
function AdaBlock({ result, labels }: { result: KiResult; labels: Record<string, string> }) {
  const known = new Set(Object.values(labels));
  const hasLists = result.staerken.length > 0 || result.verbesserungen.length > 0 || result.lernempfehlungen.length > 0;

  return (
    <>
      {result.gesamt.kommentar && (
        <section className="ex-ada ex-reveal" aria-labelledby="ex-h-ada">
          <span className="ex-avatar" aria-hidden="true">A</span>
          <div>
            <h2 className="ex-ada-name" id="ex-h-ada">Ada <span>KI-Tutorin</span></h2>
            <TextBlocks text={result.gesamt.kommentar} className="ex-ada-text" />
          </div>
        </section>
      )}
      {hasLists && (
        <div className="ex-lists ex-reveal">
          {result.staerken.length > 0 && (
            <section className="ex-panel is-ok" aria-labelledby="ex-h-good">
              <h3 id="ex-h-good"><Icon name="check-c" />Das lief gut</h3>
              <ul>
                {result.staerken.map((s, i) => <li key={i}>{s}</li>)}
              </ul>
            </section>
          )}
          {result.verbesserungen.length > 0 && (
            <section className="ex-panel is-warn" aria-labelledby="ex-h-more">
              <h3 id="ex-h-more"><Icon name="trend" />Hier holst du Punkte</h3>
              <ul>
                {result.verbesserungen.map((s, i) => <li key={i}>{s}</li>)}
              </ul>
            </section>
          )}
          {result.lernempfehlungen.length > 0 && (
            <section className="ex-panel is-accent is-wide" aria-labelledby="ex-h-learn">
              <h3 id="ex-h-learn"><Icon name="book" />Lernempfehlungen</h3>
              <ul className="ex-recs">
                {result.lernempfehlungen.map((l, i) => {
                  const titel = typeof l === "string" ? l : l.titel;
                  const wo = typeof l === "string" ? undefined : l.wo;
                  return (
                    <li key={i}>
                      <b>{titel}</b>
                      {wo && known.has(wo) && <a href={`#sub-${wo}`}>Zu {wo}</a>}
                    </li>
                  );
                })}
              </ul>
            </section>
          )}
        </div>
      )}
    </>
  );
}

// ------------------------------------------------------------------
// Aufgaben im Detail
// ------------------------------------------------------------------
// Die KI liefert keine IDs. Zuordnung deshalb ueber die Reihenfolge
// (Aufgabe i, Teilaufgabe j ohne Info-Bloecke, wie im Prompt). Fehlt ein
// Eintrag, steht dort "keine Bewertung".
function DetailsBlock({
  exam,
  result,
  answers,
  labels,
}: {
  exam: Exam;
  result: KiResult;
  answers: Record<string, string>;
  labels: Record<string, string>;
}) {
  return (
    <section className="ex-details ex-reveal" aria-labelledby="ex-h-details">
      <h2 id="ex-h-details">Aufgaben im Detail</h2>
      <div className="ex-panel">
        {exam.sections.map((section, i) => {
          const ki = result.aufgaben[i];
          const qs = section.questions.filter((q) => q.type !== "info");
          const max = ki ? ki.maxPunkte || section.totalPoints : section.totalPoints;
          const pct = ki && max > 0 ? clamp(Math.round((ki.punkte / max) * 100), 0, 100) : 0;
          return (
            <details className="ex-task" open key={section.id}>
              <summary>
                <h3><span>{i + 1}</span>{section.title}</h3>
                {ki ? (
                  <>
                    <span className="ex-task-bar" aria-hidden="true"><span style={{ width: `${pct}%` }} /></span>
                    <span className="ex-task-pts">
                      {ki.punkte} <small>/ {max}</small>
                    </span>
                  </>
                ) : (
                  <>
                    <span className="ex-task-state">keine Bewertung</span>
                    <span className="ex-task-pts"><small>max. </small>{section.totalPoints}</span>
                  </>
                )}
                <Icon name="chev" className={null} />
              </summary>
              <div className="ex-subs">
                {qs.map((q, j) => {
                  const t = ki?.teilaufgaben[j];
                  const label = labels[q.id] ?? "";
                  if (!t) {
                    return (
                      <div className="ex-sub is-open" id={label ? `sub-${label}` : undefined} key={q.id}>
                        <Icon name="alert" />
                        <span className="ex-sub-id">{label}</span>
                        <span className="ex-sub-title">{q.title}</span>
                        <span className="ex-pts">keine Bewertung</span>
                      </div>
                    );
                  }
                  const empty = t.beantwortet === false || !hasAnswer(answers[q.id]);
                  const st = t.maxPunkte > 0 && t.punkte >= t.maxPunkte ? "full" : t.punkte > 0 ? "part" : "none";
                  const icon = st === "full" ? "check-c" : st === "part" ? "part" : "x-c";
                  const sr = st === "full" ? "volle Punktzahl" : st === "part" ? "teilweise" : empty ? "nicht beantwortet" : "keine Punkte";
                  const note = st === "none" && empty ? "Nicht beantwortet." : t.kommentar;
                  return (
                    <div className={`ex-sub is-${st}`} id={label ? `sub-${label}` : undefined} key={q.id}>
                      <Icon name={icon} />
                      <span className="ex-sub-id">{label}</span>
                      <span className="ex-sub-title">
                        {q.title}
                        <span className="ex-sr">, {sr}</span>
                      </span>
                      <span className="ex-pts">{t.punkte} / {t.maxPunkte}</span>
                      {note && <p className="ex-sub-note">{note}</p>}
                    </div>
                  );
                })}
              </div>
            </details>
          );
        })}
      </div>
    </section>
  );
}

// ------------------------------------------------------------------
// Abgabe ohne Punkte (vor der Korrektur)
// ------------------------------------------------------------------
function SubmissionBlock({
  exam,
  answers,
  labels,
}: {
  exam: Exam;
  answers: Record<string, string>;
  labels: Record<string, string>;
}) {
  return (
    <section className="ex-details" aria-labelledby="ex-h-sub">
      <h2 id="ex-h-sub">Deine Abgabe</h2>
      <div className="ex-panel">
        {exam.sections.map((section, i) => {
          const qs = section.questions.filter((q) => q.type !== "info");
          const done = qs.filter((q) => hasAnswer(answers[q.id])).length;
          return (
            <details className="ex-task" key={section.id}>
              <summary>
                <h3><span>{i + 1}</span>{section.title}</h3>
                <span className="ex-task-state">{done} von {qs.length} beantwortet</span>
                <span className="ex-task-pts"><small>max. </small>{section.totalPoints}</span>
                <Icon name="chev" className={null} />
              </summary>
              <div className="ex-subs">
                {qs.map((q) => {
                  const ok = hasAnswer(answers[q.id]);
                  return (
                    <div className={ok ? "ex-sub" : "ex-sub is-part"} key={q.id}>
                      <Icon name={ok ? "check" : "alert"} />
                      <span className="ex-sub-id">{labels[q.id] ?? ""}</span>
                      <span className="ex-sub-title">{q.title}</span>
                      <span className="ex-pts">{ok ? "beantwortet" : "leer"}</span>
                    </div>
                  );
                })}
              </div>
            </details>
          );
        })}
      </div>
    </section>
  );
}

// ------------------------------------------------------------------
// Skelett in Form der Note waehrend der Korrektur
// ------------------------------------------------------------------
function Skeleton() {
  return (
    <>
      <div className="ex-panel ex-grade is-loading" aria-hidden="true">
        <div>
          <span className="ex-skel" style={{ width: 40, height: 14 }} />
          <span className="ex-skel" style={{ width: 84, height: 104, marginTop: 12 }} />
        </div>
        <div className="ex-grade-side">
          <span className="ex-skel" style={{ width: "60%", height: 28 }} />
          <span className="ex-skel" style={{ width: "100%", height: 10 }} />
          <span className="ex-skel" style={{ width: "46%", height: 14 }} />
        </div>
      </div>
      <div className="ex-ada" aria-hidden="true">
        <span className="ex-skel" style={{ width: 44, height: 44, borderRadius: "50%" }} />
        <div>
          <span className="ex-skel" style={{ width: "30%", height: 14 }} />
          <span className="ex-skel" style={{ width: "92%", height: 14, marginTop: 14 }} />
          <span className="ex-skel" style={{ width: "84%", height: 14, marginTop: 10 }} />
          <span className="ex-skel" style={{ width: "60%", height: 14, marginTop: 10 }} />
        </div>
      </div>
    </>
  );
}
