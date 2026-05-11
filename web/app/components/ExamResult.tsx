"use client";

import { useState } from "react";
import Link from "next/link";

interface ExamResultProps {
  onReset: () => void;
  exam: {
    id: string;
    title: string;
    company: string;
    scenario?: string;
    totalPoints: number;
    sections: {
      id: string;
      title: string;
      questions: { id: string; title: string; description: string; points: number; type?: string }[];
    }[];
  };
  completed: Record<string, boolean>;
  answers: Record<string, string>;
}

export default function ExamResult({ exam, completed, answers, onReset }: ExamResultProps) {
  const [kiLoading, setKiLoading] = useState(false);
  const [kiFeedback, setKiFeedback] = useState<string | null>(null);
  const [kiError, setKiError] = useState<string | null>(null);

  const allQuestions = exam.sections.flatMap((s) => s.questions);
  const completedCount = allQuestions.filter((q) => completed[q.id]).length;
  const completedPoints = allQuestions
    .filter((q) => completed[q.id])
    .reduce((sum, q) => sum + q.points, 0);

  const requestKiKorrektur = async () => {
    setKiLoading(true);
    setKiError(null);
    try {
      const response = await fetch("/api/ki-korrektur", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ exam, answers, completed }),
      });
      const data = await response.json();
      if (!response.ok) throw new Error(data.error || "Unbekannter Fehler");
      setKiFeedback(data.feedback);
    } catch (error) {
      setKiError(error instanceof Error ? error.message : "Fehler bei der KI-Korrektur");
    } finally {
      setKiLoading(false);
    }
  };

  const pointsPercent = exam.totalPoints > 0 ? Math.round((completedPoints / exam.totalPoints) * 100) : 0;

  return (
    <div className="result-page">
      <style>{`
        @import url('https://fonts.googleapis.com/css2?family=Inter+Tight:wght@400;500;600;700&family=Instrument+Serif:ital@0;1&family=JetBrains+Mono:wght@400;500;600&display=swap');
        * { box-sizing: border-box; margin: 0; padding: 0; }

        .result-page {
          font-family: 'Inter Tight', system-ui, sans-serif;
          background: #FAFAF9;
          color: #0A0A0F;
          min-height: 100vh;
        }

        /* NAV */
        .result-nav {
          position: sticky; top: 0; z-index: 50;
          backdrop-filter: blur(12px);
          background: rgba(250,250,249,0.85);
          border-bottom: 1px solid rgba(10,10,15,0.08);
        }
        .result-nav-inner {
          max-width: 1000px; margin: 0 auto;
          padding: 14px 32px;
          display: flex; align-items: center; gap: 12px;
        }
        .result-logo {
          font-family: 'Instrument Serif', serif;
          font-size: 24px; font-style: italic;
          letter-spacing: -0.5px;
          color: #0A0A0F;
          text-decoration: none;
          display: flex; align-items: center;
          margin-right: auto;
        }
        .result-logo-dot {
          width: 6px; height: 6px; border-radius: 50%;
          background: #7C6DFF;
          margin-right: 6px;
          box-shadow: 0 0 12px #7C6DFF;
        }
        .result-back {
          color: #55555F; text-decoration: none;
          font-size: 13px; font-weight: 500;
          padding: 7px 14px; border-radius: 8px;
          border: 1px solid rgba(10,10,15,0.08);
          background: #FFFFFF;
          transition: all 0.2s;
        }
        .result-back:hover {
          color: #0A0A0F;
          border-color: rgba(10,10,15,0.16);
        }

        .result-wrap {
          max-width: 1000px; margin: 0 auto;
          padding: 48px 32px 100px;
        }

        /* HERO */
        .result-hero {
          background: #FFFFFF;
          border: 1px solid rgba(10,10,15,0.08);
          border-radius: 16px;
          padding: 48px 32px;
          margin-bottom: 16px;
          text-align: center;
          position: relative;
          overflow: hidden;
        }
        .result-hero::before {
          content: '';
          position: absolute;
          top: 0; left: 0; right: 0;
          height: 3px;
          background: linear-gradient(90deg, #7C6DFF, #22D3EE);
        }
        .result-hero-eyebrow {
          font-family: 'JetBrains Mono', monospace;
          font-size: 11px; font-weight: 700;
          color: #7C6DFF;
          letter-spacing: 2px;
          text-transform: uppercase;
          margin-bottom: 16px;
        }
        .result-hero-title {
          font-size: clamp(32px, 5vw, 44px);
          font-weight: 600;
          color: #0A0A0F;
          letter-spacing: -1.5px;
          line-height: 1.05;
          margin-bottom: 14px;
        }
        .result-hero-title em {
          font-family: 'Instrument Serif', serif;
          font-style: italic;
          font-weight: 400;
          color: #7C6DFF;
        }
        .result-hero-sub {
          font-family: 'JetBrains Mono', monospace;
          font-size: 12px;
          color: #8A8A92;
          letter-spacing: 1.5px;
          text-transform: uppercase;
        }

        /* KEY NUMBERS */
        .result-stats {
          display: grid;
          grid-template-columns: 1fr 1fr 1fr;
          gap: 12px;
          margin-bottom: 16px;
        }
        .stat-card {
          background: #FFFFFF;
          border: 1px solid rgba(10,10,15,0.08);
          border-radius: 14px;
          padding: 22px;
        }
        .stat-card-label {
          font-family: 'JetBrains Mono', monospace;
          font-size: 10px; font-weight: 700;
          color: #8A8A92;
          letter-spacing: 1.5px;
          text-transform: uppercase;
          margin-bottom: 8px;
        }
        .stat-card-value {
          font-family: 'Instrument Serif', serif;
          font-size: 42px;
          color: #0A0A0F;
          letter-spacing: -1px;
          line-height: 1;
        }
        .stat-card-value em {
          font-style: italic;
          color: #7C6DFF;
        }
        .stat-card-sub {
          font-family: 'JetBrains Mono', monospace;
          font-size: 11px;
          color: #8A8A92;
          margin-top: 6px;
          letter-spacing: 0.5px;
        }

        /* KI BUTTON CARD */
        .ki-card {
          background: linear-gradient(135deg, rgba(124,109,255,0.06), rgba(34,211,238,0.04));
          border: 1px solid rgba(124,109,255,0.20);
          border-radius: 14px;
          padding: 24px;
          margin-bottom: 16px;
        }
        .ki-card-head {
          display: flex; align-items: center; gap: 12px;
          margin-bottom: 16px;
        }
        .ki-card-avatar {
          width: 36px; height: 36px;
          border-radius: 10px;
          background: linear-gradient(135deg, #7C6DFF, #22D3EE);
          color: #FFFFFF;
          font-family: 'Instrument Serif', serif;
          font-style: italic;
          font-size: 18px;
          font-weight: 600;
          display: flex; align-items: center; justify-content: center;
        }
        .ki-card-meta-name {
          font-size: 14px;
          font-weight: 600;
          color: #0A0A0F;
        }
        .ki-card-meta-sub {
          font-family: 'JetBrains Mono', monospace;
          font-size: 10px;
          color: #8A8A92;
          letter-spacing: 1px;
          text-transform: uppercase;
        }
        .ki-btn {
          width: 100%;
          padding: 14px;
          background: #7C6DFF;
          color: #FFFFFF;
          border: 1px solid #7C6DFF;
          border-radius: 10px;
          font-family: 'Inter Tight', system-ui, sans-serif;
          font-size: 14px;
          font-weight: 600;
          cursor: pointer;
          transition: all 0.15s;
          display: inline-flex;
          align-items: center;
          justify-content: center;
          gap: 8px;
        }
        .ki-btn:hover:not(:disabled) {
          background: #6856E6;
          border-color: #6856E6;
          transform: translateY(-1px);
          box-shadow: 0 8px 20px rgba(124,109,255,0.25);
        }
        .ki-btn:disabled {
          opacity: 0.55;
          cursor: not-allowed;
        }
        .ki-spinner {
          width: 14px; height: 14px;
          border: 2px solid rgba(255,255,255,0.3);
          border-top-color: #FFFFFF;
          border-radius: 50%;
          animation: spin 0.8s linear infinite;
        }
        @keyframes spin { to { transform: rotate(360deg); } }

        .ki-error {
          margin-top: 14px;
          padding: 12px 14px;
          background: rgba(220,38,38,0.06);
          border: 1px solid rgba(220,38,38,0.30);
          border-radius: 10px;
          font-size: 13px;
          color: #B91C1C;
          font-family: 'JetBrains Mono', monospace;
          line-height: 1.5;
          word-break: break-word;
        }

        /* KI FEEDBACK */
        .ki-feedback {
          background: #FFFFFF;
          border: 1px solid rgba(124,109,255,0.20);
          border-radius: 14px;
          padding: 24px;
          margin-bottom: 16px;
          position: relative;
          overflow: hidden;
        }
        .ki-feedback::before {
          content: '';
          position: absolute;
          top: 0; left: 0; right: 0;
          height: 2px;
          background: linear-gradient(90deg, #7C6DFF, #22D3EE);
        }
        .ki-feedback-head {
          display: flex; align-items: center; gap: 12px;
          margin-bottom: 18px;
          padding-bottom: 16px;
          border-bottom: 1px solid rgba(10,10,15,0.08);
        }
        .ki-feedback-title {
          font-size: 15px;
          font-weight: 600;
          color: #0A0A0F;
        }
        .ki-feedback-body {
          font-size: 14px;
          line-height: 1.7;
          color: #1F1F2A;
          white-space: pre-wrap;
          font-family: 'Inter Tight', system-ui, sans-serif;
        }

        /* DETAILS PER SECTION */
        .details-card {
          background: #FFFFFF;
          border: 1px solid rgba(10,10,15,0.08);
          border-radius: 14px;
          padding: 26px;
          margin-bottom: 16px;
        }
        .details-title {
          font-size: 16px;
          font-weight: 600;
          color: #0A0A0F;
          letter-spacing: -0.3px;
          margin-bottom: 18px;
          padding-bottom: 14px;
          border-bottom: 1px solid rgba(10,10,15,0.08);
          display: flex; align-items: center; gap: 10px;
        }
        .details-title-pill {
          font-family: 'JetBrains Mono', monospace;
          font-size: 11px;
          font-weight: 700;
          color: #7C6DFF;
          background: rgba(124,109,255,0.08);
          border: 1px solid rgba(124,109,255,0.30);
          padding: 3px 8px;
          border-radius: 5px;
          letter-spacing: 0.5px;
        }
        .section-row {
          display: flex; align-items: center; justify-content: space-between;
          padding: 14px 16px;
          border: 1px solid rgba(10,10,15,0.08);
          border-radius: 10px;
          margin-bottom: 8px;
          background: #FAFAF9;
        }
        .section-row:last-child { margin-bottom: 0; }
        .section-row.complete {
          background: rgba(16,185,129,0.04);
          border-color: rgba(16,185,129,0.20);
        }
        .section-info-name {
          font-size: 14px;
          font-weight: 600;
          color: #0A0A0F;
          margin-bottom: 3px;
        }
        .section-info-meta {
          font-family: 'JetBrains Mono', monospace;
          font-size: 10px;
          color: #8A8A92;
          letter-spacing: 1px;
          text-transform: uppercase;
        }
        .section-pts {
          text-align: right;
        }
        .section-pts-value {
          font-family: 'JetBrains Mono', monospace;
          font-size: 15px;
          font-weight: 700;
          letter-spacing: -0.3px;
          color: #D97706;
        }
        .section-row.complete .section-pts-value { color: #047857; }
        .section-pts-status {
          font-family: 'JetBrains Mono', monospace;
          font-size: 10px;
          color: #10B981;
          letter-spacing: 1px;
          text-transform: uppercase;
          margin-top: 3px;
        }

        /* ACTIONS */
        .actions-row {
          display: flex;
          gap: 10px;
          margin-top: 24px;
        }
        .action-btn {
          flex: 1;
          padding: 13px;
          border-radius: 10px;
          font-family: 'Inter Tight', system-ui, sans-serif;
          font-size: 14px;
          font-weight: 600;
          text-decoration: none;
          text-align: center;
          cursor: pointer;
          transition: all 0.15s;
          border: 1px solid;
          display: inline-flex;
          align-items: center;
          justify-content: center;
          gap: 6px;
        }
        .action-btn.outline {
          background: #FFFFFF;
          color: #55555F;
          border-color: rgba(10,10,15,0.16);
        }
        .action-btn.outline:hover {
          color: #0A0A0F;
          background: #FAFAF9;
        }
        .action-btn.primary {
          background: #0A0A0F;
          color: #FAFAF9;
          border-color: #0A0A0F;
        }
        .action-btn.primary:hover {
          transform: translateY(-1px);
          box-shadow: 0 8px 20px rgba(10,10,15,0.15);
        }
        .action-btn.danger {
          background: #FFFFFF;
          color: #B91C1C;
          border-color: rgba(220,38,38,0.30);
        }
        .action-btn.danger:hover {
          background: rgba(220,38,38,0.06);
        }

        @media (max-width: 700px) {
          .result-wrap { padding: 32px 20px 80px; }
          .result-hero { padding: 36px 20px; }
          .result-stats { grid-template-columns: 1fr; }
          .actions-row { flex-direction: column; }
        }
      `}</style>

      {/* NAV */}
      <nav className="result-nav">
        <div className="result-nav-inner">
          <Link href="/" className="result-logo">
            <span className="result-logo-dot" />
            Lernarena
          </Link>
          <Link href="/pruefungen" className="result-back">← Übersicht</Link>
        </div>
      </nav>

      <div className="result-wrap">

        {/* HERO */}
        <div className="result-hero">
          <div className="result-hero-eyebrow">Abgegeben</div>
          <h1 className="result-hero-title">
            Prüfung <em>abgeschlossen.</em>
          </h1>
          <div className="result-hero-sub">
            {exam.title} · {exam.company}
          </div>
        </div>

        {/* STATS */}
        <div className="result-stats">
          <div className="stat-card">
            <div className="stat-card-label">Bearbeitet</div>
            <div className="stat-card-value">
              <em>{completedCount}</em><span style={{ fontSize: 22, color: "#8A8A92" }}> / {allQuestions.length}</span>
            </div>
            <div className="stat-card-sub">Aufgaben gelöst</div>
          </div>
          <div className="stat-card">
            <div className="stat-card-label">Punkte</div>
            <div className="stat-card-value">
              <em>{completedPoints}</em><span style={{ fontSize: 22, color: "#8A8A92" }}> / {exam.totalPoints}</span>
            </div>
            <div className="stat-card-sub">{pointsPercent}% bearbeitet</div>
          </div>
          <div className="stat-card">
            <div className="stat-card-label">Modus</div>
            <div className="stat-card-value">
              <em>AP1</em>
            </div>
            <div className="stat-card-sub">Übungsmodus</div>
          </div>
        </div>

        {/* KI-Tutor Button */}
        <div className="ki-card">
          <div className="ki-card-head">
            <div className="ki-card-avatar">A</div>
            <div>
              <div className="ki-card-meta-name">Ada · KI-Tutor</div>
              <div className="ki-card-meta-sub">Lass deine Antworten bewerten</div>
            </div>
          </div>
          <button
            onClick={requestKiKorrektur}
            disabled={kiLoading}
            className="ki-btn"
          >
            {kiLoading ? (
              <>
                <span className="ki-spinner" />
                Ada analysiert…
              </>
            ) : (
              <>Korrektur anfordern →</>
            )}
          </button>
          {kiError && (
            <div className="ki-error">
              {kiError}
            </div>
          )}
        </div>

        {/* KI Feedback */}
        {kiFeedback && (
          <div className="ki-feedback">
            <div className="ki-feedback-head">
              <div className="ki-card-avatar">A</div>
              <div>
                <div className="ki-feedback-title">Adas Rückmeldung</div>
                <div className="ki-card-meta-sub">Persönliche Korrektur</div>
              </div>
            </div>
            <div className="ki-feedback-body">{kiFeedback}</div>
          </div>
        )}

        {/* DETAILS */}
        <div className="details-card">
          <div className="details-title">
            <span className="details-title-pill">Aufgaben</span>
            Details pro Handlungsschritt
          </div>
          {exam.sections.map((section, index) => {
            const sectionCompleted = section.questions.filter((q) => completed[q.id]).length;
            const sectionTotal = section.questions.length;
            const sectionPoints = section.questions
              .filter((q) => completed[q.id])
              .reduce((sum, q) => sum + q.points, 0);
            const sectionTotalPoints = section.questions.reduce((sum, q) => sum + q.points, 0);
            const isComplete = sectionCompleted === sectionTotal;

            return (
              <div key={section.id} className={`section-row ${isComplete ? "complete" : ""}`}>
                <div>
                  <div className="section-info-name">Aufgabe {index + 1}</div>
                  <div className="section-info-meta">
                    {sectionCompleted} / {sectionTotal} Unteraufgaben
                  </div>
                </div>
                <div className="section-pts">
                  <div className="section-pts-value">
                    {sectionPoints} / {sectionTotalPoints} Pkt
                  </div>
                  {isComplete && <div className="section-pts-status">✓ Vollständig</div>}
                </div>
              </div>
            );
          })}
        </div>

        {/* ACTIONS */}
        <div className="actions-row">
          <Link href="/pruefungen" className="action-btn outline">
            ← Zur Übersicht
          </Link>
          <button onClick={() => window.print()} className="action-btn primary">
            Drucken
          </button>
          <button onClick={onReset} className="action-btn danger">
            Zurücksetzen
          </button>
        </div>
      </div>
    </div>
  );
}