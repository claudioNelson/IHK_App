import type { Metadata } from "next";
import { examList } from "@/data/exams";
import { Exam, ExamSummary } from "@/data/exam-types";
import PruefungenClient from "./PruefungenClient";

export const metadata: Metadata = {
  title: "Übungsprüfungen AP1 und AP2",
  description:
    "Prüfungssimulationen im IHK-Stil für Fachinformatiker: AP1, AP2 Anwendungsentwicklung und Systemintegration, mit Timer und KI-Korrektur.",
  alternates: { canonical: "https://lernarena.app/pruefungen" },
};

// Server-Komponente: Die vollen Pruefungen (Aufgaben, Loesungsdaten) werden
// hier auf Metadaten reduziert. Nur diese Zusammenfassung geht an den
// Client. Die Aufgaben selbst liefert erst /pruefung/[id] nach Login- und
// Premium-Pruefung.
function zusammenfassen(exam: Exam): ExamSummary {
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  const { sections, scenario, ...rest } = exam;
  return {
    ...rest,
    sectionCount: sections.length,
    questionCount: sections.reduce((n, s) => n + s.questions.length, 0),
  };
}

export default function PruefungenPage() {
  return <PruefungenClient examList={examList.map(zusammenfassen)} />;
}
