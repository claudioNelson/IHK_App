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

  return (
    <>
      {/* Abgabe Button */}
      <div className="bg-white rounded-lg shadow-md p-6 mb-6">
        <h2 className="text-xl font-semibold text-gray-800 mb-4">
          Prüfung abschließen
        </h2>
        
        <div className="mb-4 p-4 bg-gray-50 rounded-lg">
          <div className="flex justify-between mb-2">
            <span className="text-gray-600">Bearbeitete Aufgaben:</span>
            <span className="font-medium">{completedCount} von {totalCount}</span>
          </div>
          <div className="flex justify-between">
            <span className="text-gray-600">Mögliche Punkte bearbeitet:</span>
            <span className="font-medium">{completedPoints} von {totalPoints}</span>
          </div>
        </div>

        {incompleteQuestions.length > 0 && (
          <div className="mb-4 p-4 bg-amber-50 border border-amber-200 rounded-lg">
            <p className="text-amber-800 font-medium mb-2">
              ⚠️ Noch nicht als erledigt markiert:
            </p>
            <ul className="text-amber-700 text-sm space-y-1">
              {incompleteQuestions.slice(0, 5).map((q) => (
                <li key={q.id}>• {q.title}</li>
              ))}
              {incompleteQuestions.length > 5 && (
                <li>... und {incompleteQuestions.length - 5} weitere</li>
              )}
            </ul>
          </div>
        )}

        <button
          onClick={() => setShowModal(true)}
          className="w-full py-3 bg-blue-600 text-white rounded-lg font-medium hover:bg-blue-700 transition"
        >
          📤 Prüfung abgeben
        </button>
      </div>

      {/* Modal */}
      {showModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-lg shadow-xl max-w-md w-full p-6">
            <h3 className="text-xl font-bold text-gray-800 mb-4">
              Prüfung wirklich abgeben?
            </h3>
            
            <div className="mb-6 space-y-3">
              <div className={`p-3 rounded-lg ${completedCount === totalCount ? "bg-green-50" : "bg-amber-50"}`}>
                <p className={completedCount === totalCount ? "text-green-800" : "text-amber-800"}>
                  {completedCount === totalCount 
                    ? "✅ Alle Aufgaben als erledigt markiert!" 
                    : `⚠️ ${totalCount - completedCount} Aufgaben noch nicht als erledigt markiert.`
                  }
                </p>
              </div>
              
              <p className="text-gray-600 text-sm">
                Nach der Abgabe kannst du deine Antworten noch ansehen, aber nicht mehr bearbeiten.
              </p>
            </div>

            <div className="flex gap-3">
              <button
                onClick={() => setShowModal(false)}
                className="flex-1 py-2 bg-gray-100 text-gray-700 rounded-lg font-medium hover:bg-gray-200 transition"
              >
                Abbrechen
              </button>
              <button
                onClick={() => {
                  setShowModal(false);
                  onSubmit();
                }}
                className="flex-1 py-2 bg-blue-600 text-white rounded-lg font-medium hover:bg-blue-700 transition"
              >
                Jetzt abgeben
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
}