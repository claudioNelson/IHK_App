"use client";

// Ablauf einer Pruefung: Intro, laufende Pruefung, Ergebnis.
//
// Zustand in localStorage (siehe app/pruefungen/exam-state.ts):
//   exam-{id}-answers      Antworten als JSON
//   exam-{id}-startedAt    Startzeit in ms, Timer rechnet daraus die Restzeit
//   exam-{id}-mode         "uebung" = Uebungsmodus ohne Zeitlimit
//   exam-{id}-submitted    "true" nach der Abgabe
//   exam-{id}-submittedAt  Abgabezeit in ms
//   exam-{id}-ergebnis     Adas Korrektur (ExamResult)
//
// Waehrend der Pruefung ersetzt die Fokusleiste (.ex-bar) den SiteHeader,
// der Footer entfaellt. Intro und Ergebnis nutzen den normalen PageShell.

import { useCallback, useEffect, useMemo, useRef, useState, type CSSProperties, type ReactNode } from "react";
import Link from "next/link";
import type { Exam, Question } from "@/data/exam-types";
import DiagramTool from "@/app/components/DiagramTool/DiagramTool";
import FillBlanks from "@/app/components/FillBlanks";
import DecisionMatrix from "@/app/components/DecisionMatrix";
import TableInput from "@/app/components/TableInput";
import CodeCorrection from "@/app/components/CodeCorrection";
import ImageLightbox from "@/app/components/ImageLightbox";
import ExamIntro from "@/app/components/ExamIntro";
import ExamTimer from "@/app/components/ExamTimer";
import ExamResult from "@/app/components/ExamResult";
import SubmitExam, { SubmitDialog, TimeUpDialog, type OpenQuestion } from "@/app/components/SubmitExam";
import Icon from "@/app/components/ExamIcons";
import { QuestionText, TextBlocks } from "@/app/components/ExamText";
import {
  answerableQuestions,
  clearExamStore,
  hasAnswer,
  questionLabels,
  readJson,
  readNumber,
  readStore,
  removeStore,
  writeStore,
  type StoredErgebnis,
} from "@/app/pruefungen/exam-state";

interface ExamContentProps { exam: Exam; }

type View = "loading" | "intro" | "exam" | "result";

// Wie lange nach der letzten Eingabe "Gespeichert" ausgeblendet bleibt.
// Gespeichert wird sofort, die Anzeige soll nur beim Tippen nicht flackern.
const SAVED_DELAY_MS = 450;

export default function ExamContent({ exam }: ExamContentProps) {
  const [view, setView] = useState<View>("loading");
  const [answers, setAnswers] = useState<Record<string, string>>({});
  const [startedAt, setStartedAt] = useState<number | null>(null);
  const [submittedAt, setSubmittedAt] = useState<number | null>(null);
  const [practice, setPractice] = useState(false);
  const [ergebnis, setErgebnis] = useState<StoredErgebnis | null>(null);
  const [timeUp, setTimeUp] = useState(false);
  const [submitOpen, setSubmitOpen] = useState(false);
  const [typing, setTyping] = useState<Record<string, boolean>>({});
  const [lightbox, setLightbox] = useState<{ src: string; alt: string } | null>(null);

  const answersRef = useRef<Record<string, string>>({});
  const typingTimers = useRef<Record<string, number>>({});
  const focusAfterStart = useRef(false);

  // ---------- Laden ----------
  // localStorage gibt es erst im Browser. Der erste Render (Server und
  // Hydration) zeigt deshalb "loading", danach wird einmal umgeschaltet.
  /* eslint-disable react-hooks/set-state-in-effect */
  useEffect(() => {
    const raw = readJson<Record<string, unknown>>(exam.id, "answers");
    const loaded: Record<string, string> = {};
    if (raw && typeof raw === "object") {
      for (const [k, v] of Object.entries(raw)) if (typeof v === "string") loaded[k] = v;
    }
    const started = readNumber(exam.id, "startedAt");
    const submitted = readStore(exam.id, "submitted") === "true";

    answersRef.current = loaded;
    setAnswers(loaded);
    setStartedAt(started);
    setSubmittedAt(readNumber(exam.id, "submittedAt"));
    setPractice(readStore(exam.id, "mode") === "uebung");
    setErgebnis(readJson<StoredErgebnis>(exam.id, "ergebnis"));
    setTimeUp(false);
    // Alter Stand ohne startedAt: zurueck ins Intro, die Antworten bleiben.
    setView(submitted ? "result" : started ? "exam" : "intro");
  }, [exam.id]);
  /* eslint-enable react-hooks/set-state-in-effect */

  useEffect(() => {
    const timers = typingTimers.current;
    return () => {
      for (const h of Object.values(timers)) window.clearTimeout(h);
    };
  }, []);

  // Nach "Pruefung starten": nach oben und ins erste Antwortfeld
  useEffect(() => {
    if (view !== "exam" || !focusAfterStart.current) return;
    focusAfterStart.current = false;
    window.scrollTo(0, 0);
    document.querySelector<HTMLElement>(".ex-body textarea, .ex-body input, .ex-body select")?.focus({ preventScroll: true });
  }, [view]);

  // ---------- Ableitungen ----------
  const labels = useMemo(() => questionLabels(exam), [exam]);
  const parts = useMemo(() => answerableQuestions(exam), [exam]);
  const answered = useMemo(() => {
    const set = new Set<string>();
    for (const q of parts) if (hasAnswer(answers[q.id])) set.add(q.id);
    return set;
  }, [parts, answers]);
  const openQuestions: OpenQuestion[] = useMemo(
    () => parts.filter((q) => !answered.has(q.id)).map((q) => ({ id: q.id, label: labels[q.id] ?? "", title: q.title })),
    [parts, answered, labels]
  );

  // ---------- Handler ----------
  const updateAnswer = useCallback(
    (qid: string, val: string) => {
      const next = { ...answersRef.current, [qid]: val };
      answersRef.current = next;
      setAnswers(next);
      writeStore(exam.id, "answers", JSON.stringify(next));

      setTyping((t) => (t[qid] ? t : { ...t, [qid]: true }));
      window.clearTimeout(typingTimers.current[qid]);
      typingTimers.current[qid] = window.setTimeout(() => {
        setTyping((t) => {
          const rest = { ...t };
          delete rest[qid];
          return rest;
        });
      }, SAVED_DELAY_MS);
    },
    [exam.id]
  );

  const handleStart = (practiceMode: boolean) => {
    const now = Date.now();
    writeStore(exam.id, "startedAt", String(now));
    if (practiceMode) writeStore(exam.id, "mode", "uebung");
    else removeStore(exam.id, "mode");
    setStartedAt(now);
    setPractice(practiceMode);
    focusAfterStart.current = true;
    setView("exam");
  };

  const submit = useCallback(
    (auto: boolean) => {
      const now = Date.now();
      writeStore(exam.id, "submitted", "true");
      writeStore(exam.id, "submittedAt", String(now));
      setSubmittedAt(now);
      setSubmitOpen(false);
      if (auto) {
        setTimeUp(true);
      } else {
        setView("result");
        window.scrollTo(0, 0);
      }
    },
    [exam.id]
  );

  const handleTimeUp = useCallback(() => submit(true), [submit]);

  const goToResult = () => {
    setTimeUp(false);
    setView("result");
    window.scrollTo(0, 0);
  };

  const handleReset = () => {
    clearExamStore(exam.id);
    answersRef.current = {};
    setAnswers({});
    setStartedAt(null);
    setSubmittedAt(null);
    setPractice(false);
    setErgebnis(null);
    setTimeUp(false);
    setView("intro");
    window.scrollTo(0, 0);
  };

  // ---------- Ansichten ----------
  if (view === "loading") return <div className="site ex" aria-busy="true" />;

  if (view === "intro") return <ExamIntro exam={exam} onStart={handleStart} />;

  if (view === "result") {
    return (
      <ExamResult
        exam={exam}
        answers={answers}
        startedAt={startedAt}
        submittedAt={submittedAt}
        practice={practice}
        initialErgebnis={ergebnis}
        onErgebnis={setErgebnis}
        onReset={handleReset}
      />
    );
  }

  const locked = timeUp;

  return (
    <div className="site ex ex-focus-mode">
      <FocusBar
        exam={exam}
        parts={parts}
        answered={answered}
        startedAt={startedAt}
        practice={practice}
        locked={locked}
        onTimeUp={handleTimeUp}
        onOpenSubmit={() => setSubmitOpen(true)}
      />

      <main>
        <div className="ex-body">
          {exam.scenario && (
            <details className="ex-panel ex-context">
              <summary>
                Ausgangssituation
                <Icon name="chev" className={null} />
              </summary>
              <TextBlocks text={exam.scenario} />
            </details>
          )}

          {exam.sections.map((section, sIdx) => (
            <section key={section.id} className="ex-section" id={`sec-${section.id}`} aria-labelledby={`h-sec-${section.id}`}>
              <div className="ex-section-head">
                <h2 id={`h-sec-${section.id}`}>
                  Aufgabe {sIdx + 1} <span>{section.title}</span>
                </h2>
                <span className="ex-pts">{section.totalPoints} Punkte</span>
              </div>
              {section.description && <p className="ex-section-desc">{section.description}</p>}

              {section.questions.map((q) => (
                <QuestionBlock
                  key={q.id}
                  q={q}
                  label={labels[q.id] ?? ""}
                  value={answers[q.id] ?? ""}
                  saved={answered.has(q.id) && !typing[q.id]}
                  locked={locked}
                  onChange={updateAnswer}
                  onZoom={(src, alt) => setLightbox({ src, alt })}
                />
              ))}
            </section>
          ))}

          {!locked && <SubmitExam open={openQuestions} onOpenDialog={() => setSubmitOpen(true)} />}
        </div>
      </main>

      <SubmitDialog
        isOpen={submitOpen && !locked}
        open={openQuestions}
        total={parts.length}
        onCancel={() => setSubmitOpen(false)}
        onConfirm={() => submit(false)}
      />
      <TimeUpDialog isOpen={timeUp} answered={answered.size} total={parts.length} onContinue={goToResult} />

      {lightbox && <ImageLightbox src={lightbox.src} alt={lightbox.alt} onClose={() => setLightbox(null)} />}
    </div>
  );
}

// ==================================================================
// Fokusleiste: Uebersicht, Titel, Sprungmarken, Zaehler, Timer, Abgeben,
// Theme, mobil ein Menue mit Sprungmarken und Abgabe.
// ==================================================================
function FocusBar({
  exam,
  parts,
  answered,
  startedAt,
  practice,
  locked,
  onTimeUp,
  onOpenSubmit,
}: {
  exam: Exam;
  parts: Question[];
  answered: Set<string>;
  startedAt: number | null;
  practice: boolean;
  locked: boolean;
  onTimeUp: () => void;
  onOpenSubmit: () => void;
}) {
  const [current, setCurrent] = useState<string | null>(null);
  const [menuOpen, setMenuOpen] = useState(false);
  const menuRef = useRef<HTMLDivElement>(null);
  const menuBtnRef = useRef<HTMLButtonElement>(null);

  // Stand je Aufgabe: beantwortete von beantwortbaren Teilaufgaben
  const sectionState = exam.sections.map((s, i) => {
    const qs = s.questions.filter((q) => q.type !== "info");
    const done = qs.filter((q) => answered.has(q.id)).length;
    const cls = qs.length > 0 && done === qs.length ? "is-done" : done > 0 ? "is-part" : "";
    const label = qs.length > 0 && done === qs.length ? "beantwortet" : done > 0 ? `${done} von ${qs.length} beantwortet` : "offen";
    return { id: s.id, n: i + 1, title: s.title, done, total: qs.length, cls, label };
  });

  // Aktuelle Aufgabe in der Sprungleiste markieren
  useEffect(() => {
    if (typeof IntersectionObserver === "undefined") return;
    const io = new IntersectionObserver(
      (entries) => {
        for (const e of entries) {
          if (e.isIntersecting) setCurrent(e.target.id.replace(/^sec-/, ""));
        }
      },
      { rootMargin: "-45% 0px -50% 0px" }
    );
    for (const s of exam.sections) {
      const el = document.getElementById(`sec-${s.id}`);
      if (el) io.observe(el);
    }
    return () => io.disconnect();
  }, [exam.sections]);

  // Menue: Escape und Klick daneben schliessen, Fokus hinein und zurueck
  useEffect(() => {
    if (!menuOpen) return;
    menuRef.current?.querySelector<HTMLElement>("a, button")?.focus();
    const onKey = (e: KeyboardEvent) => {
      if (e.key === "Escape") {
        setMenuOpen(false);
        menuBtnRef.current?.focus();
      }
    };
    const onDown = (e: PointerEvent) => {
      const t = e.target as Node;
      if (menuRef.current?.contains(t) || menuBtnRef.current?.contains(t)) return;
      setMenuOpen(false);
    };
    document.addEventListener("keydown", onKey);
    document.addEventListener("pointerdown", onDown);
    return () => {
      document.removeEventListener("keydown", onKey);
      document.removeEventListener("pointerdown", onDown);
    };
  }, [menuOpen]);

  const ratio = parts.length > 0 ? answered.size / parts.length : 0;
  const progressStyle = { "--p": String(ratio) } as CSSProperties;

  return (
    <>
      <header className="ex-bar">
        <div className="wrap ex-bar-inner">
          <Link
            className="ex-leave"
            href="/pruefungen"
            title={practice ? "Zur Übersicht. Deine Antworten bleiben gespeichert." : "Zur Übersicht. Die Zeit läuft weiter, deine Antworten bleiben gespeichert."}
          >
            <Icon name="arrow-l" className={null} />
            <span className="ex-leave-text">Übersicht</span>
            {!practice && <span className="ex-sr"> (die Zeit läuft weiter)</span>}
          </Link>
          <span className="ex-bar-title">{exam.title}</span>
          <span className="ex-bar-spacer" />

          <nav className="ex-jump" aria-label="Zu Aufgabe springen">
            <span className="ex-jump-label" aria-hidden="true">Aufgabe</span>
            {sectionState.map((s) => (
              <a key={s.id} href={`#sec-${s.id}`} className={s.cls || undefined} aria-current={current === s.id ? "true" : undefined}>
                <span className="ex-jump-dot" aria-hidden="true" />
                {s.n}
                <span className="ex-sr"> {s.title}, {s.label}</span>
              </a>
            ))}
          </nav>

          <span className="ex-count">
            <b>{answered.size}</b> von {parts.length} <span className="ex-count-long">beantwortet</span>
          </span>

          {startedAt !== null && (
            <ExamTimer startedAt={startedAt} durationMinutes={exam.duration} practice={practice} onTimeUp={onTimeUp} />
          )}

          {!locked && (
            <button className="btn btn-primary btn-sm ex-bar-submit" type="button" onClick={onOpenSubmit}>
              Abgeben
            </button>
          )}
          <ThemeButton />
          <button
            ref={menuBtnRef}
            className="ex-menu-btn"
            type="button"
            aria-label="Aufgaben und Abgabe"
            aria-expanded={menuOpen}
            aria-controls="ex-menu"
            onClick={() => setMenuOpen((o) => !o)}
          >
            <Icon name="list" className={null} />
          </button>
        </div>
        <div className="ex-progress" aria-hidden="true">
          <span style={progressStyle} />
        </div>
      </header>

      {menuOpen && (
        <div className="ex-menu is-open" id="ex-menu" ref={menuRef}>
          <nav aria-label="Aufgaben">
            {sectionState.map((s) => (
              <a key={s.id} href={`#sec-${s.id}`} className={s.cls || undefined} onClick={() => setMenuOpen(false)}>
                <span className="ex-jump-dot" aria-hidden="true" />
                Aufgabe {s.n} {s.title}
                <small>
                  {s.done}/{s.total}
                  <span className="ex-sr"> beantwortet</span>
                </small>
              </a>
            ))}
          </nav>
          {!locked && (
            <>
              <hr />
              <button
                className="btn btn-primary"
                type="button"
                onClick={() => {
                  setMenuOpen(false);
                  onOpenSubmit();
                }}
              >
                Prüfung abgeben
              </button>
            </>
          )}
        </div>
      )}
    </>
  );
}

// Gleiche Logik wie im SiteHeader: localStorage "lernarena-modus" und
// data-theme="light" am <html>. Dunkel ist Standard.
function ThemeButton() {
  const [isDark, setIsDark] = useState(true);

  useEffect(() => {
    let dark = document.documentElement.getAttribute("data-theme") !== "light";
    try {
      if (localStorage.getItem("lernarena-modus") === "hell") dark = false;
    } catch {}
    // eslint-disable-next-line react-hooks/set-state-in-effect -- Farbschema steht erst nach dem Mount fest
    setIsDark(dark);
  }, []);

  const toggle = () => {
    const nextDark = !isDark;
    setIsDark(nextDark);
    try {
      localStorage.setItem("lernarena-modus", nextDark ? "dunkel" : "hell");
    } catch {}
    if (nextDark) document.documentElement.removeAttribute("data-theme");
    else document.documentElement.setAttribute("data-theme", "light");
  };

  return (
    <button className="theme-btn" type="button" onClick={toggle} aria-label={isDark ? "Hellen Modus einschalten" : "Dunklen Modus einschalten"}>
      <Icon name={isDark ? "sun" : "moon"} className={null} />
    </button>
  );
}

// ==================================================================
// Eine Teilaufgabe mit Text, Abbildung, Hinweis und Antwortfeld
// ==================================================================
function QuestionBlock({
  q,
  label,
  value,
  saved,
  locked,
  onChange,
  onZoom,
}: {
  q: Question;
  label: string;
  value: string;
  saved: boolean;
  locked: boolean;
  onChange: (qid: string, val: string) => void;
  onZoom: (src: string, alt: string) => void;
}) {
  const isInfo = q.type === "info";
  const set = (val: string) => {
    if (!locked) onChange(q.id, val);
  };
  const figAlt = `Abbildung zu ${label ? label + " " : ""}${q.title}`;

  let special: ReactNode = null;
  if (q.type === "diagram" && q.diagram) {
    special = <DiagramTool data={q.diagram} value={value} onChange={set} />;
  } else if (q.type === "fillBlanks" && q.fillBlanks) {
    special = <FillBlanks data={q.fillBlanks} value={value} onChange={set} />;
  } else if (q.type === "decisionMatrix" && q.matrix) {
    special = <DecisionMatrix questionId={q.id} matrix={q.matrix} value={value} onChange={set} />;
  } else if (q.type === "tableInput" && q.table) {
    special = <TableInput questionId={q.id} table={q.table} value={value} onChange={set} />;
  } else if (q.type === "codeCorrection" && q.codeCorrection) {
    special = <CodeCorrection questionId={q.id} data={q.codeCorrection} value={value} onChange={set} />;
  }

  const chars = value.trim().length;
  const savedMark = (
    <span className={`ex-saved${saved ? " is-on" : ""}`}>
      <Icon name="check" />
      Gespeichert
    </span>
  );

  return (
    <article className="ex-q" id={`q-${q.id}`} aria-labelledby={`h-q-${q.id}`}>
      <div className="ex-q-head">
        <span className="ex-q-id">{label}</span>
        <h3 id={`h-q-${q.id}`}>{q.title}</h3>
        {!isInfo && <span className="ex-pts">{q.points} Punkte</span>}
      </div>

      <div className="ex-q-text" id={`t-${q.id}`}>
        {q.description && <QuestionText text={q.description} />}
        {q.image && (
          <figure className="ex-figure">
            <button className="ex-figure-frame" type="button" onClick={() => onZoom(q.image!, figAlt)} aria-label={`${figAlt} vergrößern`}>
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img src={q.image} alt={figAlt} loading="lazy" />
              <span className="ex-figure-zoom" aria-hidden="true">
                <Icon name="zoom" style={{ width: 14, height: 14, verticalAlign: 0 }} />
                Vergrößern
              </span>
            </button>
          </figure>
        )}
        {q.hint && (
          <div className="ex-note is-accent">
            <Icon name="bulb" />
            <span><b>Hinweis:</b> {q.hint}</span>
          </div>
        )}
      </div>

      {!isInfo &&
        (special ? (
          <div className="ex-answer">
            <span className="ex-answer-label" id={`l-${q.id}`}>Deine Antwort</span>
            <div className="ex-scroll" role="group" aria-labelledby={`l-${q.id}`} aria-describedby={`t-${q.id}`}>
              {special}
            </div>
            <div className="ex-answer-foot">{savedMark}</div>
          </div>
        ) : (
          <div className="ex-answer">
            <label htmlFor={`a-${q.id}`}>Deine Antwort</label>
            <textarea
              className={`ex-textarea${q.type === "code" ? " is-code" : ""}`}
              id={`a-${q.id}`}
              aria-describedby={`t-${q.id}`}
              value={value}
              readOnly={locked}
              spellCheck={q.type === "code" ? false : undefined}
              onChange={(e) => set(e.target.value)}
            />
            <div className="ex-answer-foot">
              {savedMark}
              <span>{chars > 0 ? `${chars} Zeichen` : ""}</span>
            </div>
          </div>
        ))}
    </article>
  );
}
