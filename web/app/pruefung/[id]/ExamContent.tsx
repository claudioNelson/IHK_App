"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import DiagramTool from "@/app/components/DiagramTool";
import FillBlanksSQL from "@/app/components/FillBlanksSQL";
import ExamTimer from "@/app/components/ExamTimer";
import { Exam } from "@/data/exam-types";
import SubmitExam from "@/app/components/SubmitExam";
import ExamResult from "@/app/components/ExamResult";
import ExamIntro from "@/app/components/ExamIntro";

interface ExamContentProps { exam: Exam; }

export default function ExamContent({ exam }: ExamContentProps) {
  const [answers, setAnswers] = useState<Record<string, string>>({});
  const [completed, setCompleted] = useState<Record<string, boolean>>({});
  const [loaded, setLoaded] = useState(false);
  const [submitted, setSubmitted] = useState(false);
  const [started, setStarted] = useState(false);

  useEffect(() => {
    const s = (k: string) => localStorage.getItem(`exam-${exam.id}-${k}`);
    if (s('started')) setStarted(JSON.parse(s('started')!));
    if (s('answers')) setAnswers(JSON.parse(s('answers')!));
    if (s('completed')) setCompleted(JSON.parse(s('completed')!));
    if (s('submitted')) setSubmitted(JSON.parse(s('submitted')!));
    setLoaded(true);
  }, [exam.id]);

  useEffect(() => {
    if (!loaded) return;
    localStorage.setItem(`exam-${exam.id}-answers`, JSON.stringify(answers));
    localStorage.setItem(`exam-${exam.id}-completed`, JSON.stringify(completed));
  }, [answers, completed, exam.id, loaded]);

  const updateAnswer = (id: string, val: string) => setAnswers(p => ({ ...p, [id]: val }));
  const toggleCompleted = (id: string) => setCompleted(p => ({ ...p, [id]: !p[id] }));
  const handleStart = () => { setStarted(true); localStorage.setItem(`exam-${exam.id}-started`, 'true'); };
  const clearAll = () => {
    if (!confirm("Alle Antworten löschen?")) return;
    setAnswers({}); setCompleted({});
    ['answers', 'completed'].forEach(k => localStorage.removeItem(`exam-${exam.id}-${k}`));
  };
  const handleSubmit = () => { setSubmitted(true); localStorage.setItem(`exam-${exam.id}-submitted`, 'true'); };
  const handleReset = () => {
    if (!confirm("Prüfung zurücksetzen?")) return;
    setAnswers({}); setCompleted({}); setSubmitted(false);
    ['answers', 'completed', 'submitted'].forEach(k => localStorage.removeItem(`exam-${exam.id}-${k}`));
  };

  const allQ = exam.sections.flatMap(s => s.questions);
  const doneCount = allQ.filter(q => completed[q.id]).length;
  const totalQ = allQ.length;
  const pct = totalQ > 0 ? (doneCount / totalQ) * 100 : 0;

  // Light-Theme-Farben (immer hell für Fokus)
  const t = {
    bg: "#FAFAF9",
    bgMuted: "#F4F4F1",
    surface: "#FFFFFF",
    surfaceElev: "#FFFFFF",
    border: "rgba(10,10,15,0.08)",
    borderStrong: "rgba(10,10,15,0.12)",
    text: "#0A0A0F",
    textMid: "#55555F",
    textDim: "#8A8A92",
    accent: "#7C6DFF",
    accentSoft: "rgba(124,109,255,0.08)",
    accent2: "#22D3EE",
    success: "#10B981",
    successSoft: "rgba(16,185,129,0.08)",
    warn: "#D97706",
    warnSoft: "rgba(217,119,6,0.08)",
    danger: "#EF4444",
    dangerSoft: "rgba(239,68,68,0.08)",
  };

  if (!loaded) {
    return (
      <div style={{ minHeight: "100vh", display: "flex", alignItems: "center", justifyContent: "center", fontFamily: "'Inter Tight', sans-serif", background: t.bg, color: t.textMid }}>
        Lädt…
      </div>
    );
  }
  if (!started) return <ExamIntro exam={exam} onStart={handleStart} />;
  if (submitted) return <ExamResult exam={exam} completed={completed} answers={answers} onReset={handleReset} />;

  return (
    <div style={{ fontFamily: "'Inter Tight', system-ui, sans-serif", background: t.bg, color: t.text, minHeight: "100vh" }}>
      <style>{`
        @import url('https://fonts.googleapis.com/css2?family=Inter+Tight:wght@400;500;600;700&family=Instrument+Serif:ital@0;1&family=JetBrains+Mono:wght@400;500;600&display=swap');
        * { box-sizing: border-box; margin: 0; padding: 0; }

        /* NAV */
        .nav {
          position: sticky; top: 0; z-index: 50;
          backdrop-filter: blur(12px);
          background: rgba(250,250,249,0.85);
          border-bottom: 1px solid ${t.border};
        }
        .nav-inner {
          max-width: 1200px; margin: 0 auto;
          padding: 14px 32px;
          display: flex; align-items: center; gap: 12px;
        }
        .logo {
          font-family: 'Instrument Serif', serif;
          font-size: 24px; font-style: italic;
          letter-spacing: -0.5px;
          color: ${t.text};
          text-decoration: none;
          display: flex; align-items: center; gap: 2px;
          margin-right: auto;
        }
        .logo-dot {
          width: 6px; height: 6px; border-radius: 50%;
          background: ${t.accent};
          margin-right: 4px;
          box-shadow: 0 0 12px ${t.accent};
        }
        .nav-btn {
          display: flex; align-items: center; gap: 8px;
          color: ${t.textMid}; text-decoration: none;
          font-size: 13px; font-weight: 500;
          padding: 7px 14px; border-radius: 8px;
          border: 1px solid ${t.border};
          background: ${t.surface};
          cursor: pointer;
          font-family: inherit;
          transition: all 0.2s;
        }
        .nav-btn:hover { color: ${t.text}; border-color: ${t.borderStrong}; }
        .nav-btn.danger { color: ${t.danger}; }
        .nav-btn.danger:hover { background: ${t.dangerSoft}; border-color: ${t.danger}40; }

        /* BODY */
        .body { max-width: 820px; margin: 0 auto; padding: 24px 20px 120px; }

        /* HEADER CARD */
        .header-card {
          background: ${t.surface};
          border: 1px solid ${t.border};
          border-radius: 14px;
          padding: 22px 24px;
          margin-bottom: 14px;
          position: relative;
          overflow: hidden;
        }
        .header-card::before {
          content: '';
          position: absolute;
          top: 0; left: 0; right: 0;
          height: 2px;
          background: linear-gradient(90deg, ${t.accent}, ${t.accent2});
        }
        .header-eyebrows {
          display: flex; gap: 6px; flex-wrap: wrap;
          margin-bottom: 10px;
        }
        .header-pill {
          font-family: 'JetBrains Mono', monospace;
          font-size: 10px; font-weight: 600;
          padding: 4px 10px;
          border-radius: 6px;
          letter-spacing: 1px;
          border: 1px solid ${t.border};
          background: ${t.bgMuted};
          color: ${t.textMid};
        }
        .header-pill.accent {
          background: ${t.accentSoft};
          color: ${t.accent};
          border-color: ${t.accent}40;
        }
        .header-title {
          font-size: 19px; font-weight: 600;
          color: ${t.text};
          letter-spacing: -0.5px;
          line-height: 1.2;
          margin-bottom: 4px;
        }
        .header-company {
          font-family: 'JetBrains Mono', monospace;
          color: ${t.textDim};
          font-size: 11px;
          letter-spacing: 1px;
          text-transform: uppercase;
        }

        /* SCENARIO */
        .scenario {
          background: ${t.surface};
          border: 1px solid ${t.border};
          border-radius: 12px;
          padding: 16px 20px;
          margin-bottom: 14px;
        }
        .scenario summary {
          font-family: 'JetBrains Mono', monospace;
          font-size: 11px; font-weight: 600;
          color: ${t.textMid};
          cursor: pointer;
          display: flex; align-items: center; gap: 8px;
          letter-spacing: 1px;
          text-transform: uppercase;
          list-style: none;
        }
        .scenario summary::-webkit-details-marker { display: none; }
        .scenario summary::before {
          content: '+';
          font-family: 'Inter Tight', sans-serif;
          width: 18px; height: 18px;
          display: inline-flex; align-items: center; justify-content: center;
          border: 1px solid ${t.border};
          border-radius: 4px;
          font-size: 13px;
          color: ${t.accent};
        }
        .scenario[open] summary::before { content: '−'; }
        .scenario-text {
          color: ${t.textMid};
          font-size: 14px;
          line-height: 1.7;
          white-space: pre-line;
          margin-top: 14px;
          padding-top: 14px;
          border-top: 1px solid ${t.border};
        }

        /* STICKY BAR */
        .sticky {
          position: sticky; top: 56px; z-index: 40;
          margin: 0 -20px 22px;
          padding: 12px 20px 14px;
          background: ${t.bg};
          display: flex; flex-direction: column;
          gap: 8px;
          border-bottom: 1px solid ${t.border};
        }
          
        .sticky-card {
          background: ${t.surface};
          border: 1px solid ${t.border};
          border-radius: 12px;
          overflow: hidden;
          backdrop-filter: blur(8px);
        }
        .navbar-inner {
          padding: 10px 16px;
          display: flex; align-items: center; gap: 8px;
          overflow-x: auto;
        }
        .navbar-label {
          font-family: 'JetBrains Mono', monospace;
          font-size: 10px; font-weight: 600;
          color: ${t.textDim};
          letter-spacing: 1px;
          text-transform: uppercase;
          white-space: nowrap;
        }
        .navchip {
          padding: 5px 12px;
          border-radius: 6px;
          font-family: 'JetBrains Mono', monospace;
          font-size: 11px; font-weight: 600;
          letter-spacing: 0.5px;
          text-decoration: none;
          white-space: nowrap;
          transition: all 0.2s;
          border: 1px solid ${t.border};
        }
        .navchip.done {
          background: ${t.successSoft};
          color: ${t.success};
          border-color: ${t.success}40;
        }
        .navchip.partial {
          background: ${t.warnSoft};
          color: ${t.warn};
          border-color: ${t.warn}40;
        }
        .navchip.none {
          background: ${t.bgMuted};
          color: ${t.textMid};
        }
        .navchip:hover { color: ${t.accent}; border-color: ${t.accent}40; }

        .progress-inner {
          padding: 12px 18px;
          display: flex; align-items: center; gap: 14px;
        }
        .prog-label {
          font-family: 'JetBrains Mono', monospace;
          font-size: 11px; font-weight: 600;
          color: ${t.textMid};
          letter-spacing: 0.5px;
          white-space: nowrap;
        }
        .prog-track {
          flex: 1; height: 6px;
          background: ${t.bgMuted};
          border-radius: 3px;
          overflow: hidden;
        }
        .prog-fill {
          height: 100%; border-radius: 3px;
          background: linear-gradient(90deg, ${t.accent}, ${t.accent2});
          transition: width 0.4s;
        }
        .prog-done {
          font-family: 'JetBrains Mono', monospace;
          font-size: 10px; font-weight: 700;
          color: ${t.success};
          letter-spacing: 1px;
          white-space: nowrap;
          text-transform: uppercase;
        }

        /* SECTION CARD */
        .section-card {
          background: ${t.surface};
          border: 1px solid ${t.border};
          border-radius: 14px;
          padding: 26px;
          margin-bottom: 14px;
          scroll-margin-top: 200px;
        }
        .section-title {
          font-size: 16px; font-weight: 600;
          color: ${t.text};
          letter-spacing: -0.3px;
          margin-bottom: 22px;
          padding-bottom: 14px;
          border-bottom: 1px solid ${t.border};
          display: flex; align-items: center; gap: 10px;
        }
        .section-num {
          font-family: 'JetBrains Mono', monospace;
          font-size: 11px; font-weight: 700;
          color: ${t.accent};
          background: ${t.accentSoft};
          border: 1px solid ${t.accent}40;
          padding: 3px 8px;
          border-radius: 5px;
          letter-spacing: 0.5px;
        }

        /* QUESTION */
        .q {
          padding: 22px 0;
          border-top: 1px solid ${t.border};
        }
        .q:first-of-type {
          border-top: none;
          padding-top: 0;
        }
        .q.done {
          background: ${t.successSoft};
          border: 1px solid ${t.success}40;
          border-radius: 10px;
          padding: 18px;
          margin: 6px -12px;
        }
        .q.done + .q { border-top: 1px solid ${t.border}; }

        .q-header {
          display: flex; align-items: flex-start; justify-content: space-between;
          gap: 12px; margin-bottom: 12px;
        }
        .q-title {
          font-size: 14px; font-weight: 600;
          color: ${t.text};
          line-height: 1.4;
          display: flex; align-items: center; gap: 8px;
        }
        .q-done-mark {
          color: ${t.success};
          font-size: 13px;
          flex-shrink: 0;
        }
        .q-pts {
          font-family: 'JetBrains Mono', monospace;
          background: ${t.accent};
          color: #fff;
          font-size: 10px; font-weight: 700;
          padding: 4px 10px;
          border-radius: 6px;
          white-space: nowrap;
          flex-shrink: 0;
          letter-spacing: 0.5px;
        }

        .q-desc {
          background: ${t.bgMuted};
          border: 1px solid ${t.border};
          border-radius: 10px;
          padding: 16px;
          font-size: 13px;
          color: ${t.text};
          line-height: 1.75;
          white-space: pre;
          overflow-x: auto;
          margin-bottom: 14px;
          font-family: 'JetBrains Mono', monospace;
        }

        .q-image {
          margin-bottom: 14px;
          border-radius: 10px;
          max-width: 100%;
          border: 1px solid ${t.border};
        }

        .hint {
          background: ${t.warnSoft};
          border: 1px solid ${t.warn}40;
          border-radius: 8px;
          padding: 10px 14px;
          font-size: 13px;
          color: ${t.warn};
          margin-bottom: 14px;
          display: flex; gap: 8px; align-items: flex-start;
        }
        .hint-icon { flex-shrink: 0; }
        .hint-text { color: ${t.text}; line-height: 1.5; }

        .answer-label {
          font-family: 'JetBrains Mono', monospace;
          font-size: 10px; font-weight: 700;
          color: ${t.accent};
          letter-spacing: 1.5px;
          text-transform: uppercase;
          margin-bottom: 8px;
        }
        .answer-ta {
          width: 100%; min-height: 180px;
          padding: 14px 16px;
          background: ${t.surface};
          border: 1px solid ${t.border};
          border-radius: 10px;
          color: ${t.text};
          font-size: 14px;
          line-height: 1.6;
          font-family: 'Inter Tight', sans-serif;
          resize: vertical;
          outline: none;
          transition: border-color 0.2s, box-shadow 0.2s;
        }
        .answer-ta::placeholder { color: ${t.textDim}; }
        .answer-ta:focus {
          border-color: ${t.accent};
          box-shadow: 0 0 0 3px ${t.accentSoft};
        }

        .done-row {
          margin-top: 12px;
          display: flex; justify-content: flex-end;
        }
        .done-btn {
          padding: 8px 16px;
          border-radius: 8px;
          font-family: 'Inter Tight', sans-serif;
          font-size: 13px; font-weight: 600;
          cursor: pointer;
          transition: all 0.2s;
          border: 1px solid;
        }
        .done-btn.yes {
          background: ${t.successSoft};
          color: ${t.success};
          border-color: ${t.success}40;
        }
        .done-btn.yes:hover {
          background: ${t.success}20;
        }
        .done-btn.no {
          background: ${t.surface};
          color: ${t.textMid};
          border-color: ${t.border};
        }
        .done-btn.no:hover {
          color: ${t.accent};
          border-color: ${t.accent}40;
          background: ${t.accentSoft};
        }

        @media (max-width: 768px) {
          .nav-inner { padding: 12px 16px; }
          .body { padding: 16px 14px 80px; }
          .section-card { padding: 20px; }
          .sticky { top: 56px; }
        }
      `}</style>

      {/* NAV */}
      <nav className="nav">
        <div className="nav-inner">
          <Link href="/" className="logo">
            <span className="logo-dot" />
            Lernarena
          </Link>
          <Link href="/pruefungen" className="nav-btn">← Prüfungen</Link>
          <button className="nav-btn danger" onClick={clearAll}>🗑 Löschen</button>
        </div>
      </nav>

      <div className="body">
        {/* Header */}
        <div className="header-card">
          <div className="header-eyebrows">
            <span className="header-pill accent">{exam.level === "ap1" ? "AP1" : "AP2"}</span>
            <span className="header-pill">{exam.season.toUpperCase()} {exam.year}</span>
            <span className="header-pill">⏱ {exam.duration} MIN</span>
            <span className="header-pill">📊 {exam.totalPoints} PKT</span>
          </div>
          <div className="header-title">{exam.title}</div>
          <div className="header-company">{exam.company}</div>
        </div>

        {/* Szenario (einklappbar) */}
        {exam.scenario && (
          <details className="scenario">
            <summary>Ausgangssituation anzeigen</summary>
            <div className="scenario-text">{exam.scenario}</div>
          </details>
        )}

        {/* Sticky Bar */}
        <div className="sticky">
          <div className="sticky-card">
            <ExamTimer durationMinutes={exam.duration} onTimeUp={() => alert("Zeit abgelaufen!")} />
          </div>
          <div className="sticky-card">
            <div className="navbar-inner">
              <span className="navbar-label">Springen:</span>
              {exam.sections.map((s, i) => {
                const done = s.questions.every(q => completed[q.id]);
                const partial = s.questions.some(q => completed[q.id]);
                return (
                  <a key={s.id} href={`#${s.id}`} className={`navchip ${done ? "done" : partial ? "partial" : "none"}`}>
                    {done && "✓ "}AUFG {i + 1}
                  </a>
                );
              })}
            </div>
          </div>
          <div className="sticky-card">
            <div className="progress-inner">
              <span className="prog-label">{doneCount} / {totalQ} ERLEDIGT</span>
              <div className="prog-track">
                <div className="prog-fill" style={{ width: `${pct}%` }} />
              </div>
              {doneCount === totalQ && totalQ > 0 && <span className="prog-done">✓ KOMPLETT</span>}
            </div>
          </div>
        </div>

        {/* Sections */}
        {exam.sections.map((section, sIdx) => (
          <div key={section.id} id={section.id} className="section-card">
            <h2 className="section-title">
              <span className="section-num">AUFG {sIdx + 1}</span>
              {section.title}
            </h2>

            {section.questions.map(q => (
              <div key={q.id} className={`q ${completed[q.id] ? "done" : ""}`}>
                <div className="q-header">
                  <div className="q-title">
                    {completed[q.id] && <span className="q-done-mark">✓</span>}
                    {q.title}
                  </div>
                  {q.type !== "info" && <span className="q-pts">{q.points} PKT</span>}
                </div>

                <pre className="q-desc">{q.description}</pre>

                {q.image && <img src={q.image} alt="Grafik" className="q-image" />}
                {q.hint && (
                  <div className="hint">
                    <span className="hint-icon">💡</span>
                    <span className="hint-text">{q.hint}</span>
                  </div>
                )}

                {q.type !== "info" && (
                  <>
                    <div className="answer-label">Deine Antwort</div>
                    {q.type === "diagram" ? (
                      <DiagramTool onSave={data => updateAnswer(q.id, data)} />
                    ) : q.type === "fillBlanks" ? (
                      <FillBlanksSQL questionId={q.id} />
                    ) : (
                      <textarea
                        className="answer-ta"
                        placeholder="Antwort hier eingeben…"
                        value={answers[q.id] || ""}
                        onChange={e => updateAnswer(q.id, e.target.value)}
                      />
                    )}
                    <div className="done-row">
                      <button
                        onClick={() => toggleCompleted(q.id)}
                        className={`done-btn ${completed[q.id] ? "yes" : "no"}`}
                      >
                        {completed[q.id] ? "✓ Erledigt" : "Als erledigt markieren"}
                      </button>
                    </div>
                  </>
                )}
              </div>
            ))}
          </div>
        ))}

        <SubmitExam sections={exam.sections} completed={completed} onSubmit={handleSubmit} />
      </div>
    </div>
  );
}