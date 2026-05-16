import { Fachrichtung, ExamLevel, Difficulty, Season, QuestionType } from "./exam-types";

// ============================================
// FACHRICHTUNG → Anzeige-Text
// ============================================
export const fachrichtungLabels: Record<Fachrichtung, string> = {
    ae: "Anwendungsentwicklung",
    si: "Systemintegration",
    dpa: "Daten- und Prozessanalyse",
    dvs: "Digitale Vernetzung",
    shared: "Fachrichtungsübergreifend",
};

// Kurzform (für Badges, schmale Spalten)
export const fachrichtungShortLabels: Record<Fachrichtung, string> = {
    ae: "AE",
    si: "SI",
    dpa: "DPA",
    dvs: "DVS",
    shared: "Alle",
};

// ============================================
// PRÜFUNGS-LEVEL → Anzeige-Text
// ============================================
export const examLevelLabels: Record<ExamLevel, string> = {
    ap1: "Abschlussprüfung Teil 1 (Halbjahresprüfung)",
    ap2: "Abschlussprüfung Teil 2",
};

// Kurzform
export const examLevelShortLabels: Record<ExamLevel, string> = {
    ap1: "AP1",
    ap2: "AP2",
};

// ============================================
// SCHWIERIGKEIT → Anzeige-Text + Farbe
// ============================================
export const difficultyLabels: Record<Difficulty, string> = {
    leicht: "Leicht",
    mittel: "Mittel",
    schwer: "Schwer",
};

// Tailwind-Klassen für Badges
export const difficultyColors: Record<Difficulty, string> = {
    leicht: "bg-green-100 text-green-800",
    mittel: "bg-yellow-100 text-yellow-800",
    schwer: "bg-red-100 text-red-800",
};

// ============================================
// SAISON → Anzeige-Text
// ============================================
export const seasonLabels: Record<Season, string> = {
    Frühjahr: "Frühjahr",
    Sommer: "Sommer",
    Herbst: "Herbst",
    Winter: "Winter",
};

// ============================================
// FRAGE-TYP → Anzeige-Text (für UI / Filter)
// ============================================
export const questionTypeLabels: Record<QuestionType, string> = {
    info: "Information",
    freeText: "Freitext",
    code: "Code schreiben",
    codeCorrection: "Code korrigieren",
    diagram: "Diagramm",
    multipleChoice: "Multiple Choice",
    fillBlanks: "Lücken füllen",
    tableInput: "Tabelle ausfüllen",
    decisionMatrix: "Entscheidungsmatrix",
    calculation: "Berechnung",
};