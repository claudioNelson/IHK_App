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

  const getTimerColor = () => {
    if (timeLeft <= 300) return "text-red-600 bg-red-50 border-red-200";
    if (timeLeft <= 600) return "text-orange-600 bg-orange-50 border-orange-200";
    return "text-green-700 bg-green-50 border-green-200";
  };

  return (
    <div className={`flex items-center justify-between px-4 py-2 rounded-lg border ${getTimerColor()}`}>
      <div className="flex items-center gap-3">
        <span className="font-mono text-xl font-bold">
          ⏱️ {formatTime(timeLeft)}
        </span>
        {timeLeft === 0 && (
          <span className="text-red-600 font-medium text-sm">Zeit abgelaufen!</span>
        )}
      </div>

      <div className="flex gap-2">
        {!hasStarted ? (
          <button
            onClick={() => { setIsRunning(true); setHasStarted(true); }}
            className="px-3 py-1 bg-green-600 text-white rounded text-sm hover:bg-green-700 transition"
          >
            ▶️ Start
          </button>
        ) : (
          <>
            <button
              onClick={() => setIsRunning(!isRunning)}
              className="px-3 py-1 bg-gray-200 text-gray-700 rounded text-sm hover:bg-gray-300 transition"
            >
              {isRunning ? "⏸️" : "▶️"}
            </button>
            <button
              onClick={() => { setTimeLeft(durationMinutes * 60); setIsRunning(false); setHasStarted(false); }}
              className="px-3 py-1 bg-gray-200 text-gray-700 rounded text-sm hover:bg-gray-300 transition"
            >
              🔄
            </button>
          </>
        )}
      </div>
    </div>
  );
}