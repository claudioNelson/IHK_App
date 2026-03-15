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

      if (!response.ok) {
        throw new Error(data.error || "Unbekannter Fehler");
      }

      setKiFeedback(data.feedback);
    } catch (error) {
      setKiError(error instanceof Error ? error.message : "Fehler bei der KI-Korrektur");
    } finally {
      setKiLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gray-100 py-8 px-4">
      <div className="max-w-2xl mx-auto">

        {/* Header */}
        <div className="bg-white rounded-lg shadow-md p-8 mb-6 text-center">
          <div className="text-6xl mb-4">🎉</div>
          <h1 className="text-2xl font-bold text-gray-800 mb-2">
            Prüfung abgegeben!
          </h1>
          <p className="text-gray-600">
            {exam.title} - {exam.company}
          </p>
        </div>

        {/* Zusammenfassung */}
        <div className="bg-white rounded-lg shadow-md p-6 mb-6">
          <h2 className="text-xl font-semibold text-gray-800 mb-4">
            Zusammenfassung
          </h2>

          <div className="space-y-4">
            <div className="flex justify-between items-center p-4 bg-blue-50 rounded-lg">
              <span className="text-blue-800">Bearbeitete Aufgaben</span>
              <span className="text-blue-800 font-bold text-xl">
                {completedCount} / {allQuestions.length}
              </span>
            </div>

            <div className="flex justify-between items-center p-4 bg-green-50 rounded-lg">
              <span className="text-green-800">Bearbeitete Punkte</span>
              <span className="text-green-800 font-bold text-xl">
                {completedPoints} / {exam.totalPoints}
              </span>
            </div>
          </div>
        </div>

        {/* KI-Tutor Button */}
        <div className="bg-white rounded-lg shadow-md p-6 mb-6">
          <button
            onClick={requestKiKorrektur}
            disabled={kiLoading}
            className="w-full py-4 bg-purple-600 text-white rounded-lg font-bold text-lg hover:bg-purple-700 transition disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2"
          >
            {kiLoading ? (
              <>
                <svg className="animate-spin h-5 w-5" viewBox="0 0 24 24">
                  <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" fill="none" />
                  <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" />
                </svg>
                KI analysiert...
              </>
            ) : (
              <>🤖 KI-Tutor Korrektur anfordern</>
            )}
          </button>

          {kiError && (
            <div className="mt-4 p-4 bg-red-50 border border-red-200 rounded-lg text-red-700">
              ❌ {kiError}
            </div>
          )}
        </div>

        {/* KI-Feedback */}
        {kiFeedback && (
          <div className="bg-gradient-to-br from-purple-50 to-blue-50 rounded-lg shadow-md p-6 mb-6 border border-purple-200">
            <div className="flex items-center gap-3 mb-4">
              <div className="bg-purple-100 p-2 rounded-lg">
                <span className="text-2xl">🤖</span>
              </div>
              <h2 className="text-xl font-semibold text-gray-800">
                KI-Tutor Feedback
              </h2>
            </div>
            <hr className="mb-4" />
            <div className="prose prose-sm max-w-none">
              <pre className="whitespace-pre-wrap font-sans text-gray-700 leading-relaxed">
                {kiFeedback}
              </pre>
            </div>
          </div>
        )}

        {/* Details pro Section */}
        <div className="bg-white rounded-lg shadow-md p-6 mb-6">
          <h2 className="text-xl font-semibold text-gray-800 mb-4">
            Details
          </h2>

          <div className="space-y-3">
            {exam.sections.map((section, index) => {
              const sectionCompleted = section.questions.filter((q) => completed[q.id]).length;
              const sectionTotal = section.questions.length;
              const sectionPoints = section.questions
                .filter((q) => completed[q.id])
                .reduce((sum, q) => sum + q.points, 0);
              const sectionTotalPoints = section.questions.reduce((sum, q) => sum + q.points, 0);

              return (
                <div key={section.id} className="p-4 bg-gray-50 rounded-lg">
                  <div className="flex justify-between items-start">
                    <div>
                      <span className="font-medium text-gray-800">
                        HS{index + 1}
                      </span>
                      <p className="text-sm text-gray-500 mt-1">
                        {sectionCompleted} von {sectionTotal} Aufgaben
                      </p>
                    </div>
                    <div className="text-right">
                      <span className={`font-bold ${sectionCompleted === sectionTotal ? "text-green-600" : "text-amber-600"}`}>
                        {sectionPoints} / {sectionTotalPoints} Punkte
                      </span>
                      {sectionCompleted === sectionTotal && (
                        <p className="text-sm text-green-600">✓ Vollständig</p>
                      )}
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        </div>

        {/* Aktionen */}
        <div className="flex flex-col gap-3">
          <div className="flex gap-4">
            <Link
              href="/pruefungen"
              className="flex-1 py-3 bg-gray-100 text-gray-700 rounded-lg font-medium hover:bg-gray-200 transition text-center"
            >
              ← Zur Übersicht
            </Link>
            <button
              onClick={() => window.print()}
              className="flex-1 py-3 bg-blue-600 text-white rounded-lg font-medium hover:bg-blue-700 transition"
            >
              🖨️ Drucken
            </button>
          </div>
          <button
            onClick={onReset}
            className="w-full py-3 bg-red-100 text-red-700 rounded-lg font-medium hover:bg-red-200 transition"
          >
            🔄 Prüfung zurücksetzen
          </button>
        </div>
      </div>
    </div>
  );
}