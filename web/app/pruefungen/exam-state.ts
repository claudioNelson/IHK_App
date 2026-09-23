// Gemeinsame Helfer fuer Uebersicht, laufende Pruefung und Ergebnis:
// localStorage-Schluessel, "beantwortet"-Regel, Kennungen der Teilaufgaben,
// Gruppennamen und das Format von Adas Ergebnis.
//
// localStorage nur in Effekten und Handlern aufrufen (nie beim Rendern),
// alle Zugriffe sind in try/catch gekapselt (privater Modus, volle Quote).

import type { Exam, ExamLevel, Fachrichtung } from "@/data/exam-types";

// ------------------------------------------------------------------
// Speicher
// ------------------------------------------------------------------
export type ExamStoreKey =
  | "answers"      // Record<questionId, string> als JSON
  | "startedAt"    // Startzeit in ms
  | "submitted"    // "true"
  | "submittedAt"  // Abgabezeit in ms (fuer Bearbeitungszeit und Anzeige)
  | "mode"         // "uebung" = Uebungsmodus ohne Zeitlimit
  | "ergebnis";    // StoredErgebnis als JSON

// Alte Schluessel aus der Version vor dem Redesign. Werden beim Laden
// ignoriert und beim Zuruecksetzen mit entfernt.
const LEGACY_KEYS = ["started", "completed"] as const;

const ALL_KEYS: readonly string[] = ["answers", "startedAt", "submitted", "submittedAt", "mode", "ergebnis", ...LEGACY_KEYS];

export const storeKey = (examId: string, k: string) => `exam-${examId}-${k}`;

export function readStore(examId: string, k: ExamStoreKey | (typeof LEGACY_KEYS)[number]): string | null {
  try {
    return window.localStorage.getItem(storeKey(examId, k));
  } catch {
    return null;
  }
}

export function writeStore(examId: string, k: ExamStoreKey, value: string): void {
  try {
    window.localStorage.setItem(storeKey(examId, k), value);
  } catch {
    // Speicher voll oder gesperrt: die Sitzung laeuft ohne Sicherung weiter
  }
}

export function removeStore(examId: string, k: ExamStoreKey): void {
  try {
    window.localStorage.removeItem(storeKey(examId, k));
  } catch {}
}

/** Loescht alle Schluessel einer Pruefung, auch die alten. */
export function clearExamStore(examId: string): void {
  for (const k of ALL_KEYS) {
    try {
      window.localStorage.removeItem(storeKey(examId, k));
    } catch {}
  }
}

export function readJson<T>(examId: string, k: ExamStoreKey): T | null {
  const raw = readStore(examId, k);
  if (!raw) return null;
  try {
    return JSON.parse(raw) as T;
  } catch {
    return null;
  }
}

export function readNumber(examId: string, k: ExamStoreKey): number | null {
  const raw = readStore(examId, k);
  if (!raw) return null;
  const n = Number(raw);
  return Number.isFinite(n) && n > 0 ? n : null;
}

// ------------------------------------------------------------------
// "Beantwortet"
// ------------------------------------------------------------------
// Freitext: nicht leer. Spezialtypen speichern JSON; dort zaehlt es erst,
// wenn irgendwo ein nicht leerer Text, ein Haken oder eine Zahl steht.
// "{}", "[]" oder {"selections":{},"reasons":{}} zaehlen also nicht.
function hasContent(v: unknown): boolean {
  if (v === null || v === undefined) return false;
  if (typeof v === "string") return v.trim() !== "";
  if (typeof v === "number") return Number.isFinite(v);
  if (typeof v === "boolean") return v;
  if (Array.isArray(v)) return v.some(hasContent);
  if (typeof v === "object") return Object.values(v as Record<string, unknown>).some(hasContent);
  return false;
}

export function hasAnswer(value: string | undefined | null): boolean {
  const v = (value ?? "").trim();
  if (v === "" || v === "{}" || v === "[]") return false;
  if (v.startsWith("{") || v.startsWith("[")) {
    try {
      return hasContent(JSON.parse(v));
    } catch {
      return true; // Freitext, der zufaellig mit einer Klammer beginnt
    }
  }
  return true;
}

// ------------------------------------------------------------------
// Kennungen der Teilaufgaben: 1a, 1b, 2a, ...
// ------------------------------------------------------------------
// Reine Info-Bloecke (type "info") bekommen keine Kennung und zaehlen nicht
// als Teilaufgabe. Die Reihenfolge entspricht dem Prompt der KI-Korrektur,
// die Info-Bloecke ebenfalls ueberspringt.
export type ExamLike = Pick<Exam, "sections">;

export function questionLabels(exam: ExamLike): Record<string, string> {
  const labels: Record<string, string> = {};
  exam.sections.forEach((s, si) => {
    let n = 0;
    for (const q of s.questions) {
      if (q.type === "info") continue;
      labels[q.id] = `${si + 1}${letter(n)}`;
      n++;
    }
  });
  return labels;
}

function letter(n: number): string {
  // a bis z, danach aa, ab, ... (kommt praktisch nicht vor)
  const a = "abcdefghijklmnopqrstuvwxyz";
  return n < 26 ? a[n] : a[Math.floor(n / 26) - 1] + a[n % 26];
}

export function answerableQuestions(exam: ExamLike) {
  return exam.sections.flatMap((s) => s.questions.filter((q) => q.type !== "info"));
}

// ------------------------------------------------------------------
// Gruppen und Bezeichnungen
// ------------------------------------------------------------------
export function groupLabel(level?: ExamLevel, fach?: Fachrichtung): string {
  if (level === "ap1") return "AP1";
  switch (fach) {
    case "ae": return "AP2 Anwendungsentwicklung";
    case "si": return "AP2 Systemintegration";
    case "dpa": return "AP2 Daten- und Prozessanalyse";
    case "dvs": return "AP2 Digitale Vernetzung";
    default: return "AP2";
  }
}

/** Punkte, ab denen bestanden ist (50 Prozent, aufgerundet). */
export const passPoints = (total: number) => Math.ceil(total * 0.5);

// ------------------------------------------------------------------
// Adas Ergebnis (Antwort von /api/ki-korrektur, dort normalisiert)
// ------------------------------------------------------------------
export interface KiTeilaufgabe {
  titel?: string;
  punkte: number;
  maxPunkte: number;
  beantwortet?: boolean;
  kommentar?: string;
}
export interface KiAufgabe {
  titel?: string;
  punkte: number;
  maxPunkte: number;
  teilaufgaben: KiTeilaufgabe[];
}
export type KiEmpfehlung = string | { titel: string; wo?: string };
export interface KiResult {
  gesamt: {
    punkte: number;
    maxPunkte: number;
    prozent: number;
    note: number;
    noteText: string;
    bestanden: boolean;
    kommentar?: string;
  };
  aufgaben: KiAufgabe[];
  staerken: string[];
  verbesserungen: string[];
  lernempfehlungen: KiEmpfehlung[];
}

export type ProfileSave = "saved" | "guest" | "error";

/** Inhalt von exam-{id}-ergebnis */
export interface StoredErgebnis {
  result: KiResult | null;
  feedback: string | null;   // Freitext, wenn die KI kein JSON geliefert hat
  profile?: ProfileSave;     // Stand der Speicherung in user_exam_attempts
  at: number;
}
