"use client";

// Timer der laufenden Pruefung (in der Fokusleiste).
// Startet mit "Pruefung starten": die Startzeit liegt in localStorage
// (exam-{id}-startedAt), die Restzeit wird daraus berechnet und uebersteht
// so einen Reload. Kein Pause- und kein Reset-Knopf.
// Unter 10 Minuten --warn, unter 2 Minuten --err, beide Schwellen werden
// per aria-live angesagt. Bei 0 ruft er einmal onTimeUp auf.
// Im Uebungsmodus zaehlt er nur hoch.

import { useEffect, useRef, useState } from "react";
import Icon from "./ExamIcons";

interface ExamTimerProps {
  startedAt: number;
  durationMinutes: number;
  practice: boolean;
  onTimeUp: () => void;
}

const WARN_S = 10 * 60;
const CRIT_S = 2 * 60;

function fmt(seconds: number): string {
  const s = Math.max(0, Math.floor(seconds));
  const m = Math.floor(s / 60);
  const r = s % 60;
  return `${String(m).padStart(2, "0")}:${String(r).padStart(2, "0")}`;
}

export default function ExamTimer({ startedAt, durationMinutes, practice, onTimeUp }: ExamTimerProps) {
  const [now, setNow] = useState(() => Date.now());
  const [announce, setAnnounce] = useState("");
  const announced = useRef({ warn: false, crit: false });
  const fired = useRef(false);
  const onTimeUpRef = useRef(onTimeUp);

  useEffect(() => {
    onTimeUpRef.current = onTimeUp;
  }, [onTimeUp]);

  useEffect(() => {
    const h = window.setInterval(() => setNow(Date.now()), 1000);
    return () => window.clearInterval(h);
  }, []);

  const elapsed = Math.max(0, (now - startedAt) / 1000);
  const left = durationMinutes * 60 - elapsed;
  const crit = !practice && left <= CRIT_S;
  const warn = !practice && !crit && left <= WARN_S;

  useEffect(() => {
    if (practice) return;
    if (left <= CRIT_S && !announced.current.crit) {
      announced.current.crit = true;
      announced.current.warn = true;
      setAnnounce("Noch 2 Minuten. Danach wird automatisch abgegeben.");
    } else if (left <= WARN_S && !announced.current.warn) {
      announced.current.warn = true;
      setAnnounce("Noch 10 Minuten.");
    }
    if (left <= 0 && !fired.current) {
      fired.current = true;
      onTimeUpRef.current();
    }
  }, [left, practice]);

  const cls = `ex-timer${crit ? " is-crit" : warn ? " is-warn" : ""}`;

  return (
    <>
      <div className={cls} role="timer" aria-labelledby="ex-timer-label">
        <Icon name="clock" />
        <span className="ex-timer-label" id="ex-timer-label">{practice ? "Übungsmodus" : "Restzeit"}</span>
        <span className="ex-timer-value">{practice ? fmt(elapsed) : fmt(left)}</span>
      </div>
      <p className="ex-sr" aria-live="polite">{announce}</p>
    </>
  );
}
