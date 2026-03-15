import { exams } from "@/data/exams";
import ExamContent from "./ExamContent";

export default async function Pruefung({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const exam = exams[id];

  if (!exam) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <p className="text-red-600">Prüfung nicht gefunden</p>
      </div>
    );
  }

  return <ExamContent exam={exam} />;
}