"use client";

import { useState } from "react";

interface SubmitExamProps {
  sections: {
    id: string;
    title: string;
    questions: { id: string; title: string; points: number }[];
  }[];
  completed: Record<string, boolean>;
  onSubmit: () => void;
}

export default function SubmitExam({ sections, completed, onSubmit }: SubmitExamProps) {
  const [showModal, setShowModal] = useState(false);

  const allQuestions = sections.flatMap((s) => s.questions);
  const completedCount = allQuestions.filter((q) => completed[q.id]).length;
  const totalCount = allQuestions.length;
  const completedPoints = allQuestions
    .filter((q) => completed[q.id])
    .reduce((sum, q) => sum + q.points, 0);
  const totalPoints = allQuestions.reduce((sum, q) => sum + q.points, 0);

  const incompleteQuestions = allQuestions.filter((q) => !completed[q.id]);
  const isComplete = completedCount === totalCount;

  return (
    <>
      <style>{`
        /* SUBMIT CARD */
        .submit-card {
          background: #FFFFFF;
          border: 1px solid rgba(10,10,15,0.08);
          border-radius: 14px;
          padding: 26px;
          margin-bottom: 14px;
          font-family: 'Inter Tight', system-ui, sans-serif;
          position: relative;
          overflow: hidden;
        }
        .submit-card::before {
          content: '';
          position: absolute;
          top: 0; left: 0; right: 0;
          height: 2px;
          background: linear-gradient(90deg, #7C6DFF, #22D3EE);
        }
        .submit-title {
          font-size: 16px;
          font-weight: 600;
          color: #0A0A0F;
          letter-spacing: -0.3px;
          margin-bottom: 18px;
          padding-bottom: 14px;
          border-bottom: 1px solid rgba(10,10,15,0.08);
          display: flex; align-items: center; gap: 10px;
        }
        .submit-title-pill {
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

        /* STATS GRID */
        .submit-stats {
          display: grid;
          grid-template-columns: 1fr 1fr;
          gap: 10px;
          margin-bottom: 18px;
        }
        .stat-tile {
          background: #FAFAF9;
          border: 1px solid rgba(10,10,15,0.08);
          border-radius: 10px;
          padding: 14px 16px;
        }
        .stat-tile-label {
          font-family: 'JetBrains Mono', monospace;
          font-size: 10px;
          font-weight: 600;
          color: #8A8A92;
          letter-spacing: 1px;
          text-transform: uppercase;
          margin-bottom: 6px;
        }
        .stat-tile-value {
          font-family: 'JetBrains Mono', monospace;
          font-size: 22px;
          font-weight: 600;
          color: #0A0A0F;
          letter-spacing: -0.5px;
        }
        .stat-tile-value .total {
          color: #8A8A92;
          font-weight: 400;
        }
        .stat-tile.success .stat-tile-value { color: #10B981; }
        .stat-tile.warn .stat-tile-value { color: #D97706; }

        /* WARNING BOX */
        .submit-warn {
          background: rgba(217,119,6,0.06);
          border: 1px solid rgba(217,119,6,0.25);
          border-radius: 10px;
          padding: 14px 16px;
          margin-bottom: 18px;
        }
        .submit-warn-title {
          font-family: 'JetBrains Mono', monospace;
          font-size: 11px;
          font-weight: 700;
          color: #D97706;
          letter-spacing: 1px;
          text-transform: uppercase;
          margin-bottom: 8px;
          display: flex; align-items: center; gap: 8px;
        }
        .submit-warn-list {
          list-style: none;
          margin: 0; padding: 0;
          font-size: 13px;
          color: #0A0A0F;
          line-height: 1.6;
        }
        .submit-warn-list li {
          padding: 2px 0;
          display: flex; gap: 8px;
        }
        .submit-warn-list li::before {
          content: '·';
          color: #D97706;
          flex-shrink: 0;
        }
        .submit-warn-more {
          font-family: 'JetBrains Mono', monospace;
          font-size: 11px;
          color: #8A8A92;
          font-style: italic;
          padding-top: 4px;
        }

        /* SUBMIT BUTTON */
        .submit-btn {
          width: 100%;
          padding: 14px;
          background: #0A0A0F;
          color: #FAFAF9;
          border: 1px solid #0A0A0F;
          border-radius: 10px;
          font-family: 'Inter Tight', system-ui, sans-serif;
          font-size: 15px;
          font-weight: 600;
          cursor: pointer;
          transition: all 0.15s;
          display: inline-flex;
          align-items: center;
          justify-content: center;
          gap: 8px;
        }
        .submit-btn:hover {
          transform: translateY(-1px);
          box-shadow: 0 8px 20px rgba(10,10,15,0.15);
        }

        /* MODAL */
        .submit-overlay {
          position: fixed;
          inset: 0;
          background: rgba(10,10,15,0.6);
          backdrop-filter: blur(6px);
          display: flex;
          align-items: center;
          justify-content: center;
          padding: 20px;
          z-index: 100;
          font-family: 'Inter Tight', system-ui, sans-serif;
        }
        .submit-modal {
          background: #FFFFFF;
          border: 1px solid rgba(10,10,15,0.08);
          border-radius: 16px;
          max-width: 460px;
          width: 100%;
          padding: 32px;
          box-shadow: 0 30px 80px rgba(10,10,15,0.4);
          position: relative;
          overflow: hidden;
        }
        .submit-modal::before {
          content: '';
          position: absolute;
          top: 0; left: 0; right: 0;
          height: 2px;
          background: linear-gradient(90deg, #7C6DFF, #22D3EE);
        }
        .submit-modal-eyebrow {
          font-family: 'JetBrains Mono', monospace;
          font-size: 10px;
          font-weight: 700;
          color: #7C6DFF;
          letter-spacing: 1.5px;
          text-transform: uppercase;
          margin-bottom: 10px;
        }
        .submit-modal-title {
          font-size: 22px;
          font-weight: 600;
          color: #0A0A0F;
          letter-spacing: -0.5px;
          line-height: 1.2;
          margin-bottom: 20px;
        }
        .submit-modal-title em {
          font-family: 'Instrument Serif', serif;
          font-style: italic;
          font-weight: 400;
          color: #7C6DFF;
        }

        .submit-status {
          padding: 14px 16px;
          border-radius: 10px;
          margin-bottom: 14px;
          font-size: 13px;
          line-height: 1.5;
        }
        .submit-status.success {
          background: rgba(16,185,129,0.08);
          border: 1px solid rgba(16,185,129,0.30);
          color: #047857;
        }
        .submit-status.warn {
          background: rgba(217,119,6,0.08);
          border: 1px solid rgba(217,119,6,0.30);
          color: #92400E;
        }
        .submit-status-label {
          font-family: 'JetBrains Mono', monospace;
          font-size: 10px;
          font-weight: 700;
          letter-spacing: 1px;
          text-transform: uppercase;
          margin-bottom: 4px;
          display: block;
          opacity: 0.7;
        }

        .submit-modal-note {
          font-size: 13px;
          color: #55555F;
          line-height: 1.6;
          margin-bottom: 24px;
        }

        .submit-modal-actions {
          display: flex;
          gap: 10px;
        }
        .modal-btn {
          flex: 1;
          padding: 12px;
          border-radius: 10px;
          font-family: 'Inter Tight', system-ui, sans-serif;
          font-size: 14px;
          font-weight: 600;
          cursor: pointer;
          transition: all 0.15s;
          border: 1px solid;
        }
        .modal-btn.cancel {
          background: #FFFFFF;
          color: #55555F;
          border-color: rgba(10,10,15,0.16);
        }
        .modal-btn.cancel:hover {
          background: #FAFAF9;
          color: #0A0A0F;
        }
        .modal-btn.confirm {
          background: #0A0A0F;
          color: #FAFAF9;
          border-color: #0A0A0F;
        }
        .modal-btn.confirm:hover {
          transform: translateY(-1px);
          box-shadow: 0 8px 20px rgba(10,10,15,0.15);
        }

        @media (max-width: 600px) {
          .submit-card { padding: 20px; }
          .submit-stats { grid-template-columns: 1fr; }
          .submit-modal { padding: 24px; }
        }
      `}</style>

      {/* Submit Card */}
      <div className="submit-card">
        <div className="submit-title">
          <span className="submit-title-pill">Abgabe</span>
          Prüfung abschließen
        </div>

        <div className="submit-stats">
          <div className={`stat-tile ${isComplete ? "success" : "warn"}`}>
            <div className="stat-tile-label">Bearbeitet</div>
            <div className="stat-tile-value">
              {completedCount}<span className="total"> / {totalCount}</span>
            </div>
          </div>
          <div className="stat-tile">
            <div className="stat-tile-label">Punkte</div>
            <div className="stat-tile-value">
              {completedPoints}<span className="total"> / {totalPoints}</span>
            </div>
          </div>
        </div>

        {incompleteQuestions.length > 0 && (
          <div className="submit-warn">
            <div className="submit-warn-title">
              <span>⚠</span>
              Noch offen
            </div>
            <ul className="submit-warn-list">
              {incompleteQuestions.slice(0, 5).map((q) => (
                <li key={q.id}>{q.title}</li>
              ))}
              {incompleteQuestions.length > 5 && (
                <li className="submit-warn-more">
                  … und {incompleteQuestions.length - 5} weitere
                </li>
              )}
            </ul>
          </div>
        )}

        <button onClick={() => setShowModal(true)} className="submit-btn">
          Prüfung abgeben →
        </button>
      </div>

      {/* Modal */}
      {showModal && (
        <div className="submit-overlay" onClick={() => setShowModal(false)}>
          <div className="submit-modal" onClick={(e) => e.stopPropagation()}>
            <div className="submit-modal-eyebrow">Bestätigung</div>
            <h3 className="submit-modal-title">
              Prüfung wirklich <em>abgeben?</em>
            </h3>

            <div className={`submit-status ${isComplete ? "success" : "warn"}`}>
              <span className="submit-status-label">Status</span>
              {isComplete
                ? "Alle Aufgaben sind als erledigt markiert."
                : `${totalCount - completedCount} Aufgaben sind noch nicht als erledigt markiert.`}
            </div>

            <p className="submit-modal-note">
              Nach der Abgabe kannst du deine Antworten noch ansehen, aber nicht mehr bearbeiten.
            </p>

            <div className="submit-modal-actions">
              <button onClick={() => setShowModal(false)} className="modal-btn cancel">
                Abbrechen
              </button>
              <button
                onClick={() => {
                  setShowModal(false);
                  onSubmit();
                }}
                className="modal-btn confirm"
              >
                Jetzt abgeben →
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
}