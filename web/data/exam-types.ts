// ============================================
// FACHRICHTUNGEN
// ============================================
// Welche IHK-Fachrichtung gehört zur Prüfung?
// "shared" = fachrichtungsübergreifend (z.B. AP1)
export type Fachrichtung =
    | "ae"      // Fachinformatiker Anwendungsentwicklung
    | "si"      // Fachinformatiker Systemintegration
    | "dpa"     // Daten- & Prozessanalyse
    | "dvs"     // Digitale Vernetzung
    | "shared"; // Alle Fachrichtungen (z.B. AP1, WiSo)

// ============================================
// PRÜFUNGS-LEVEL
// ============================================
// AP1 = Halbjahresprüfung (alle Azubis, einfacher)
// AP2 = Abschlussprüfung (fachrichtungsspezifisch, schwer)
export type ExamLevel = "ap1" | "ap2";

// ============================================
// SCHWIERIGKEIT
// ============================================
export type Difficulty = "leicht" | "mittel" | "schwer";

// ============================================
// PRÜFUNGS-SAISON (statt freier String)
// ============================================
export type Season = "Sommer" | "Winter" | "Herbst";

// ============================================
// FRAGE-TYPEN
// ============================================
export type QuestionType =
    | "info"              // Nur Anzeige (z.B. DB-Schema)
    | "freeText"          // Freitext-Antwort
    | "code"              // Code/SQL/Pseudocode SCHREIBEN
    | "codeCorrection"    // Fehler im Code finden & korrigieren
    | "diagram"           // Diagramm zeichnen
    | "multipleChoice"    // Single-/Multi-Choice
    | "fillBlanks"        // Lücken in Text/Code füllen
    | "tableInput"        // Tabellenzellen ausfüllen (z.B. Netzplan, Berechnungen)
    | "decisionMatrix"    // Matrix: Kreuze + optionale Begründung
    | "calculation";      // Rechenaufgabe mit Lösungsweg

// ============================================
// AUSWAHL-OPTIONEN (für multipleChoice)
// ============================================
export interface QuestionOption {
    id: string;
    text: string;
    correct: boolean;
}

// ============================================
// FRAGE
// ============================================
export interface Question {
    id: string;
    title: string;
    description: string;
    type: QuestionType;
    points: number;

    // Optionale Felder
    hint?: string;
    image?: string;
    options?: QuestionOption[];
    expectedAnswer?: string;
    tags?: string[];


    // Für type: "decisionMatrix"
    matrix?: DecisionMatrix;

    // Für type: "tableInput"
    table?: TableInputData;

    // Für type: "codeCorrection"
    codeCorrection?: CodeCorrectionData;
    
}
// ============================================
// CODE-KORREKTUR (für type: "codeCorrection")
// ============================================
export interface CodeCorrectionData {
    code: string;                // Der zu korrigierende Code (mehrzeilig)
    language?: string;           // z.B. "bash", "powershell" (für Syntax-Hervorhebung später)
    expectedErrorCount?: number; // Wie viele Fehler erwartet werden (z.B. 2)
    helpText?: string;           // Optional: Erläuterung (z.B. Manual-Auszug zu df)
}


// ============================================
// HANDLUNGSSCHRITT / ABSCHNITT
// ============================================
export interface ExamSection {
    id: string;
    title: string;
    totalPoints: number;
    questions: Question[];

    // Optionale Felder
    description?: string;            // Einleitungstext für den Section
    optional?: boolean;              // z.B. "4 von 5 wählen"
}

// ============================================
// PRÜFUNG
// ============================================
export interface Exam {
    // Pflichtfelder (bestehend)
    id: string;
    title: string;
    year: number;
    season: Season;
    duration: number;                // in Minuten
    totalPoints: number;
    company: string;
    scenario: string;
    sections: ExamSection[];

    // Neue optionale Felder (rückwärtskompatibel)
    level?: ExamLevel;               // "ap1" oder "ap2" — Default: ap2
    fachrichtung?: Fachrichtung;     // "ae", "si", "shared", ...
    difficulty?: Difficulty;         // "leicht" | "mittel" | "schwer"
    tags?: string[];                 // z.B. ["oop", "sql", "uml"]
    sectionsToChoose?: number;       // z.B. 4 (von 5 wählen)
    publishedAt?: string;            // ISO-Datum, falls relevant
}

// ============================================
// ENTSCHEIDUNGSMATRIX (für type: "decisionMatrix")
// ============================================
export interface MatrixRow {
    id: string;                  // eindeutige ID, z.B. "backup"
    label: string;               // Anzeige-Text: "Tägliches Backup der Patientendaten"
    example?: boolean;           // Zeile als Beispiel markieren (vorausgefüllt)
    exampleColumn?: string;      // welche Spalte ist beim Beispiel angekreuzt
    exampleReason?: string;      // Beispiel-Begründung
}

export interface DecisionMatrix {
    columns: string[];           // ["Vertraulichkeit", "Integrität", "Verfügbarkeit"]
    rows: MatrixRow[];
}

// ============================================
// TABELLEN-EINGABE (für type: "tableInput")
// ============================================
export interface TableColumn {
    key: string;
    label: string;
    placeholder?: string;
    width?: string;
    readonly?: boolean;
    align?: "left" | "center" | "right";
    belowRow?: boolean;          // Spalte als Textarea unter der Zeile anzeigen
}

export interface TableRow {
    id: string;                  // eindeutige ID, z.B. "vorgang-a"
    label: string;               // Anzeige-Text der Zeile, z.B. "A"
    sublabel?: string;           // optional: kleinere Zusatzinfo, z.B. "Ist-Analyse"
    example?: boolean;           // Beispiel-Zeile (vorausgefüllt, nicht editierbar)
    values?: Record<string, string>;  // bei example: vorausgefüllte Werte pro Spalte
}

export interface TableInputData {
    columns: TableColumn[];      // Spalten-Definition
    rows: TableRow[];            // Zeilen-Definition
    rowHeaderLabel?: string;     // Beschriftung der ersten Spalte, z.B. "Vorgang"
}

// ============================================
// HELPER-TYPES (für die UI / Listen)
// ============================================
// Kompakte Variante für Übersichtsseiten — ohne sections
export type ExamSummary = Omit<Exam, "sections" | "scenario"> & {
    sectionCount: number;
    questionCount: number;
};