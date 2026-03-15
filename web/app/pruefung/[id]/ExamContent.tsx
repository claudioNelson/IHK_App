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
    ['answers','completed'].forEach(k => localStorage.removeItem(`exam-${exam.id}-${k}`));
  };
  const handleSubmit = () => { setSubmitted(true); localStorage.setItem(`exam-${exam.id}-submitted`, 'true'); };
  const handleReset = () => {
    if (!confirm("Prüfung zurücksetzen?")) return;
    setAnswers({}); setCompleted({}); setSubmitted(false);
    ['answers','completed','submitted'].forEach(k => localStorage.removeItem(`exam-${exam.id}-${k}`));
  };

  const allQ = exam.sections.flatMap(s => s.questions);
  const doneCount = allQ.filter(q => completed[q.id]).length;
  const totalQ = allQ.length;
  const pct = totalQ > 0 ? (doneCount / totalQ) * 100 : 0;

  if (!loaded) return <div style={{minHeight:"100vh",display:"flex",alignItems:"center",justifyContent:"center",fontFamily:"'Plus Jakarta Sans',sans-serif",background:"#F4F4F8",color:"#374151"}}>Lädt...</div>;
  if (!started) return <ExamIntro exam={exam} onStart={handleStart} />;
  if (submitted) return <ExamResult exam={exam} completed={completed} answers={answers} onReset={handleReset} />;

  return (
    <div style={{fontFamily:"'Plus Jakarta Sans',sans-serif",background:"#F4F4F8",color:"#111827",minHeight:"100vh"}}>
      <style>{`
        @import url('https://fonts.googleapis.com/css2?family=Nunito:wght@600;700;800;900&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap');
        * { box-sizing: border-box; }

        /* NAV */
        .xnav {
          position: sticky; top: 0; z-index: 50;
          background: #4F46E5;
          padding: 0 32px; height: 56px;
          display: flex; align-items: center; gap: 12px;
        }
        .xnav-logo {
          font-family: 'Nunito', sans-serif; font-size: 18px; font-weight: 900;
          color: #fff; text-decoration: none; margin-right: auto; letter-spacing: -0.5px;
        }
        .xnav-back {
          display: flex; align-items: center; gap: 6px;
          color: rgba(255,255,255,0.85); text-decoration: none;
          font-size: 13px; font-weight: 600;
          padding: 7px 14px; border-radius: 8px;
          background: rgba(255,255,255,0.15);
          transition: background 0.2s;
        }
        .xnav-back:hover { background: rgba(255,255,255,0.25); color: #fff; }
        .xnav-clear {
          color: #FCA5A5; font-size: 13px; font-weight: 600;
          background: rgba(239,68,68,0.2); border: none;
          padding: 7px 14px; border-radius: 8px;
          cursor: pointer; transition: background 0.2s;
        }
        .xnav-clear:hover { background: rgba(239,68,68,0.35); }

        /* BODY */
        .xbody { max-width: 820px; margin: 0 auto; padding: 24px 20px 120px; }

        /* HEADER CARD */
        .xheader {
          background: #fff; border-radius: 16px; padding: 22px 24px;
          margin-bottom: 14px;
          border-left: 4px solid #4F46E5;
          box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }
        .xheader-title {
          font-family: 'Nunito', sans-serif; font-size: 19px; font-weight: 900;
          color: #111827; margin-bottom: 10px; letter-spacing: -0.3px;
        }
        .xmeta { display: flex; gap: 8px; flex-wrap: wrap; }
        .xchip {
          background: #EEF2FF; color: #4338CA;
          font-size: 12px; font-weight: 700;
          padding: 4px 12px; border-radius: 20px;
        }

        /* SCENARIO */
        .xscenario {
          background: #FFFBEB; border: 1px solid #FDE68A;
          border-radius: 12px; padding: 16px; margin-bottom: 14px;
        }
        .xscenario summary {
          font-size: 13px; font-weight: 700; color: #92400E;
          cursor: pointer; display: flex; align-items: center; gap: 6px;
        }
        .xscenario-text {
          color: #78350F; font-size: 13px; line-height: 1.7;
          white-space: pre-line; margin-top: 12px; padding-top: 12px;
          border-top: 1px solid #FDE68A;
        }

        /* STICKY BAR */
        .xsticky { position: sticky; top: 56px; z-index: 40; margin-bottom: 20px; display: flex; flex-direction: column; gap: 8px; }
        .xtimer-wrap { background: #fff; border-radius: 12px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.06); }
        .xnavbar {
          background: #fff; border-radius: 12px; padding: 10px 16px;
          display: flex; align-items: center; gap: 8px; overflow-x: auto;
          box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }
        .xnavlabel { font-size: 12px; font-weight: 600; color: #9CA3AF; white-space: nowrap; }
        .xnavchip {
          padding: 5px 14px; border-radius: 20px; font-size: 12px; font-weight: 700;
          text-decoration: none; white-space: nowrap; transition: all 0.2s;
        }
        .xnavchip.done { background: #DCFCE7; color: #15803D; }
        .xnavchip.partial { background: #FEF3C7; color: #B45309; }
        .xnavchip.none { background: #F3F4F6; color: #6B7280; }
        .xnavchip:hover { background: #EEF2FF; color: #4F46E5; }

        .xprogress {
          background: #fff; border-radius: 12px; padding: 12px 18px;
          display: flex; align-items: center; gap: 14px;
          box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }
        .xprog-label { font-size: 13px; font-weight: 600; color: #6B7280; white-space: nowrap; }
        .xprog-track { flex: 1; height: 8px; background: #E5E7EB; border-radius: 4px; overflow: hidden; }
        .xprog-fill { height: 100%; border-radius: 4px; background: linear-gradient(90deg, #4F46E5, #818CF8); transition: width 0.4s; }
        .xprog-done { font-size: 12px; font-weight: 700; color: #15803D; white-space: nowrap; }

        /* SECTION CARD */
        .xsection {
          background: #fff; border-radius: 16px; padding: 24px;
          margin-bottom: 14px; scroll-margin-top: 160px;
          box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }
        .xsection-title {
          font-family: 'Nunito', sans-serif; font-size: 16px; font-weight: 900;
          color: #111827; margin-bottom: 20px; padding-bottom: 14px;
          border-bottom: 2px solid #EEF2FF;
          display: flex; align-items: center; gap: 10px;
        }
        .xsection-icon {
          width: 28px; height: 28px; background: #4F46E5;
          border-radius: 7px; display: flex; align-items: center;
          justify-content: center; font-size: 12px; flex-shrink: 0;
        }

        /* QUESTION */
        .xq { padding: 18px 0; border-top: 1px solid #F3F4F6; }
        .xq:first-of-type { border-top: none; padding-top: 0; }
        .xq.done { background: #F0FDF4; border-radius: 12px; padding: 16px; margin: 4px -12px; border-top: none; }

        .xq-header { display: flex; align-items: flex-start; justify-content: space-between; gap: 12px; margin-bottom: 12px; }
        .xq-title { font-size: 14px; font-weight: 700; color: #111827; display: flex; align-items: center; gap: 8px; }
        .xq-done-mark { color: #16A34A; }
        .xq-pts { background: #4F46E5; color: #fff; font-size: 11px; font-weight: 700; padding: 3px 10px; border-radius: 20px; white-space: nowrap; flex-shrink: 0; }

        .xq-desc {
          background: #F8FAFC; border: 1px solid #E2E8F0;
          border-radius: 10px; padding: 16px;
          font-size: 13px; color: #1E293B; line-height: 1.75;
          white-space: pre; overflow-x: auto; margin-bottom: 14px;
          font-family: 'Courier New', Courier, monospace;
        }

        .xhint {
          background: #FFFBEB; border: 1px solid #FDE68A;
          border-radius: 8px; padding: 10px 14px;
          font-size: 13px; color: #92400E; margin-bottom: 12px; font-weight: 500;
        }

        .xanswer-label { font-size: 11px; font-weight: 800; color: #4F46E5; letter-spacing: 1px; text-transform: uppercase; margin-bottom: 8px; }
        .xanswer-ta {
          width: 100%; height: 200px; padding: 14px 16px;
          background: #fff; border: 2px solid #E5E7EB;
          border-radius: 10px; color: #111827; font-size: 14px; line-height: 1.6;
          font-family: 'Plus Jakarta Sans', sans-serif;
          resize: vertical; outline: none; transition: border-color 0.2s;
        }
        .xanswer-ta::placeholder { color: #CBD5E1; }
        .xanswer-ta:focus { border-color: #4F46E5; box-shadow: 0 0 0 3px rgba(79,70,229,0.1); }

        .xdone-row { margin-top: 10px; display: flex; justify-content: flex-end; }
        .xdone-btn {
          padding: 8px 18px; border-radius: 20px; font-size: 13px; font-weight: 700;
          cursor: pointer; transition: all 0.2s; border: 2px solid;
          font-family: 'Plus Jakarta Sans', sans-serif;
        }
        .xdone-btn.yes { background: #DCFCE7; color: #15803D; border-color: #86EFAC; }
        .xdone-btn.yes:hover { background: #BBF7D0; }
        .xdone-btn.no { background: #F8FAFC; color: #64748B; border-color: #E2E8F0; }
        .xdone-btn.no:hover { background: #EEF2FF; color: #4F46E5; border-color: #C7D2FE; }

        @media (max-width: 768px) {
          .xnav { padding: 0 16px; }
          .xbody { padding: 16px 14px 80px; }
        }
      `}</style>

      {/* NAV */}
      <nav className="xnav">
        <Link href="/" className="xnav-logo">Lernarena</Link>
        <Link href="/pruefungen" className="xnav-back">← Prüfungen</Link>
        <button className="xnav-clear" onClick={clearAll}>🗑️ Löschen</button>
      </nav>

      <div className="xbody">
        {/* Header */}
        <div className="xheader">
          <div className="xheader-title">{exam.title}</div>
          <div className="xmeta">
            <span className="xchip">🏢 {exam.company}</span>
            <span className="xchip">⏱ {exam.duration} Min</span>
            <span className="xchip">📊 {exam.totalPoints} Punkte</span>
          </div>
        </div>

        {/* Szenario */}
        {exam.scenario && (
          <div className="xscenario">
            <details>
              <summary>📖 Ausgangssituation anzeigen</summary>
              <p className="xscenario-text">{exam.scenario}</p>
            </details>
          </div>
        )}

        {/* Sticky Bar */}
        <div className="xsticky">
          <div className="xtimer-wrap">
            <ExamTimer durationMinutes={exam.duration} onTimeUp={() => alert("Zeit abgelaufen!")} />
          </div>
          <div className="xnavbar">
            <span className="xnavlabel">Gehe zu:</span>
            {exam.sections.map((s, i) => {
              const done = s.questions.every(q => completed[q.id]);
              const partial = s.questions.some(q => completed[q.id]);
              return (
                <a key={s.id} href={`#${s.id}`} className={`xnavchip ${done ? "done" : partial ? "partial" : "none"}`}>
                  {done && "✓ "}HS{i + 1}
                </a>
              );
            })}
          </div>
          <div className="xprogress">
            <span className="xprog-label">📝 {doneCount} / {totalQ} erledigt</span>
            <div className="xprog-track">
              <div className="xprog-fill" style={{ width: `${pct}%` }} />
            </div>
            {doneCount === totalQ && totalQ > 0 && <span className="xprog-done">✓ Vollständig</span>}
          </div>
        </div>

        {/* Sections */}
        {exam.sections.map(section => (
          <div key={section.id} id={section.id} className="xsection">
            <h2 className="xsection-title">
              <span className="xsection-icon">📋</span>
              {section.title}
            </h2>

            {section.questions.map(q => (
              <div key={q.id} className={`xq ${completed[q.id] ? "done" : ""}`}>
                <div className="xq-header">
                  <div className="xq-title">
                    {completed[q.id] && <span className="xq-done-mark">✓</span>}
                    {q.title}
                  </div>
                  {q.type !== "info" && <span className="xq-pts">{q.points} Pkt</span>}
                </div>

                <pre className="xq-desc">{q.description}</pre>

                {q.image && <img src={q.image} alt="Grafik" style={{ marginBottom: 14, borderRadius: 10, maxWidth: "100%" }} />}
                {q.hint && <div className="xhint">💡 {q.hint}</div>}

                {q.type !== "info" && (
                  <>
                    <div className="xanswer-label">Deine Antwort</div>
                    {q.type === "diagram" ? (
                      <DiagramTool onSave={data => updateAnswer(q.id, data)} />
                    ) : q.type === "fillBlanks" ? (
                      <FillBlanksSQL questionId={q.id} />
                    ) : (
                      <textarea
                        className="xanswer-ta"
                        placeholder="Antwort hier eingeben..."
                        value={answers[q.id] || ""}
                        onChange={e => updateAnswer(q.id, e.target.value)}
                      />
                    )}
                    <div className="xdone-row">
                      <button onClick={() => toggleCompleted(q.id)} className={`xdone-btn ${completed[q.id] ? "yes" : "no"}`}>
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