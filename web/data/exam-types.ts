export type QuestionType =
    | "info"
    | "freeText"
    | "code"
    | "diagram"
    | "multipleChoice"
    | "fillBlanks";

export interface Question {
    id: string;
    title: string;
    description: string;
    type: QuestionType;
    points: number;
    hint?: string;
    image?: string;
}

export interface ExamSection {
    id: string;
    title: string;
    totalPoints: number;
    questions: Question[];
}

export interface Exam {
    id: string;
    title: string;
    year: number;
    season: string;
    duration: number;
    totalPoints: number;
    company: string;
    scenario: string;
    sections: ExamSection[];
}