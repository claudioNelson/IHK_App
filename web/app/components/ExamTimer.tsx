"use client";

import { useState, useEffect } from "react";

interface ExamTimerProps {
  durationMinutes: number;
  onTimeUp?: () => void;
}

export default function ExamTimer({ durationMinutes, onTimeUp }: ExamTimerProps) {
  const [timeLeft, setTimeLeft] = useState(durationMinutes * 60);
  const [isRunning, setIsRunning] = useState(false);
  const [hasStarted, setHasStarted] = useState(false);

  // Reset timeLeft wenn durationMinutes sich ändert (z.B. andere Prüfung)
  // Nur wenn Timer noch nicht gestartet wurde, sonst würde laufender Timer überschrieben
  useEffect(() => {
    if (!hasStarted) {
      setTimeLeft(durationMinutes * 60);
    }
  }, [durationMinutes, hasStarted]);

  useEffect(() => {
    if (!isRunning || timeLeft <= 0) return;

    const timer = setInterval(() => {
      setTimeLeft((prev) => {
        if (prev <= 1) {
          setIsRunning(false);
          onTimeUp?.();
          return 0;
        }
        return prev - 1;
      });
    }, 1000);

    return () => clearInterval(timer);
  }, [isRunning, timeLeft, onTimeUp]);

  const formatTime = (seconds: number) => {
    const hours = Math.floor(seconds / 3600);
    const mins = Math.floor((seconds % 3600) / 60);
    const secs = seconds % 60;

    if (hours > 0) {
      return `${hours}:${mins.toString().padStart(2, "0")}:${secs.toString().padStart(2, "0")}`;
    }
    return `${mins.toString().padStart(2, "0")}:${secs.toString().padStart(2, "0")}`;
  };

  // Farbe je nach Restzeit
  const getStatus = () => {
    if (timeLeft <= 0) return "expired";        // Rot, abgelaufen
    if (timeLeft <= 300) return "critical";     // Rot, < 5 Min
    if (timeLeft <= 600) return "warning";      // Orange, < 10 Min
    return "normal";                            // Lila/normal
  };

  const status = getStatus();

  return (
    <div className={`timer-bar timer-${status}`}>
      <style>{`
        .timer-bar {
          display: flex;
          align-items: center;
          justify-content: space-between;
          padding: 12px 18px;
          font-family: 'Inter Tight', system-ui, sans-serif;
          gap: 14px;
        }

        .timer-left {
          display: flex;
          align-items: center;
          gap: 12px;
          flex: 1;
          min-width: 0;
        }

        .timer-label {
          font-family: 'JetBrains Mono', monospace;
          font-size: 10px;
          font-weight: 600;
          letter-spacing: 1.5px;
          text-transform: uppercase;
          color: #8A8A92;
          white-space: nowrap;
        }

        .timer-value {
          font-family: 'JetBrains Mono', monospace;
          font-size: 22px;
          font-weight: 600;
          letter-spacing: -0.5px;
          color: #0A0A0F;
          line-height: 1;
        }

        .timer-warning-text {
          font-family: 'JetBrains Mono', monospace;
          font-size: 10px;
          font-weight: 700;
          letter-spacing: 1px;
          text-transform: uppercase;
          padding: 3px 8px;
          border-radius: 5px;
          background: rgba(124,109,255,0.10);
          color: #7C6DFF;
          border: 1px solid rgba(124,109,255,0.30);
        }

        /* Status-Varianten */
        .timer-warning .timer-value { color: #D97706; }
        .timer-warning .timer-warning-text {
          background: rgba(217,119,6,0.10);
          color: #D97706;
          border-color: rgba(217,119,6,0.30);
        }

        .timer-critical .timer-value { color: #DC2626; }
        .timer-critical .timer-warning-text {
          background: rgba(220,38,38,0.10);
          color: #DC2626;
          border-color: rgba(220,38,38,0.30);
          animation: pulse-critical 1s ease-in-out infinite;
        }

        .timer-expired .timer-value { color: #DC2626; }

        @keyframes pulse-critical {
          0%, 100% { opacity: 1; }
          50% { opacity: 0.5; }
        }

        /* Buttons */
        .timer-actions {
          display: flex;
          gap: 6px;
          flex-shrink: 0;
        }

        .timer-btn {
          font-family: 'Inter Tight', system-ui, sans-serif;
          font-size: 12px;
          font-weight: 600;
          padding: 7px 12px;
          border-radius: 7px;
          border: 1px solid rgba(10,10,15,0.08);
          background: #FFFFFF;
          color: #55555F;
          cursor: pointer;
          transition: all 0.15s;
          display: inline-flex;
          align-items: center;
          gap: 5px;
        }
        .timer-btn:hover {
          color: #0A0A0F;
          border-color: rgba(10,10,15,0.16);
          background: #F4F4F1;
        }

        .timer-btn.primary {
          background: #7C6DFF;
          border-color: #7C6DFF;
          color: #FFFFFF;
        }
        .timer-btn.primary:hover {
          background: #6856E6;
          border-color: #6856E6;
          color: #FFFFFF;
        }

        .timer-btn.icon {
          padding: 7px 10px;
        }

        @media (max-width: 600px) {
          .timer-bar { padding: 10px 14px; gap: 10px; }
          .timer-value { font-size: 18px; }
          .timer-label { display: none; }
        }
      `}</style>

      <div className="timer-left">
        <span className="timer-label">Verbleibend</span>
        <span className="timer-value">{formatTime(timeLeft)}</span>
        {status === "expired" && (
          <span className="timer-warning-text">Zeit abgelaufen</span>
        )}
        {status === "critical" && timeLeft > 0 && (
          <span className="timer-warning-text">Kritisch</span>
        )}
        {status === "warning" && (
          <span className="timer-warning-text">Bald vorbei</span>
        )}
      </div>

      <div className="timer-actions">
        {!hasStarted ? (
          <button
            onClick={() => { setIsRunning(true); setHasStarted(true); }}
            className="timer-btn primary"
            aria-label="Timer starten"
          >
            ▶ Start
          </button>
        ) : (
          <>
            <button
              onClick={() => setIsRunning(!isRunning)}
              className="timer-btn icon"
              aria-label={isRunning ? "Pause" : "Fortsetzen"}
              title={isRunning ? "Pause" : "Fortsetzen"}
            >
              {isRunning ? "⏸" : "▶"}
            </button>
            <button
              onClick={() => { setTimeLeft(durationMinutes * 60); setIsRunning(false); setHasStarted(false); }}
              className="timer-btn icon"
              aria-label="Timer zurücksetzen"
              title="Zurücksetzen"
            >
              ↻
            </button>
          </>
        )}
      </div>
    </div>
  );
}