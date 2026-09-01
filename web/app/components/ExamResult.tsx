"use client";

import { useState } from "react";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";

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

// Strukturiertes Bewertungs-Ergebnis von der KI (Adas Korrektur)
interface KiTeilaufgabe {
  titel: string;
  punkte: number;
  maxPunkte: number;
  beantwortet?: boolean;
  kommentar?: string;
}
interface KiAufgabe {
  titel: string;
  punkte: number;
  maxPunkte: number;
  teilaufgaben: KiTeilaufgabe[];
}
interface KiResult {
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
  staerken?: string[];
  verbesserungen?: string[];
  lernempfehlungen?: string[];
}

// Sicherheitsnetz: Die KI bewertet die Aufgaben einzeln meist korrekt,
// verrechnet sich aber gelegentlich im Gesamt-Block (oder behauptet
// "nichts beantwortet", obwohl Teilaufgaben Punkte bekommen haben).
// Deshalb rechnen wir das Gesamtergebnis selbst aus den Einzelbewertungen
// zusammen und leiten Prozent, Note und Bestanden daraus ab.
function reconcileKiResult(result: KiResult): KiResult {
  if (!Array.isArray(result.aufgaben) || result.aufgaben.length === 0) {
    return result;
  }

  const punkte = result.aufgaben.reduce(
    (sum, a) => sum + (Number(a.punkte) || 0),
    0
  );
  const maxPunkte =
    result.aufgaben.reduce((sum, a) => sum + (Number(a.maxPunkte) || 0), 0) ||
    result.gesamt?.maxPunkte ||
    100;

  const prozent = Math.round((punkte / maxPunkte) * 100);

  let note = 6;
  let noteText = "ungenügend";
  if (prozent >= 92) { note = 1; noteText = "sehr gut"; }
  else if (prozent >= 81) { note = 2; noteText = "gut"; }
  else if (prozent >= 67) { note = 3; noteText = "befriedigend"; }
  else if (prozent >= 50) { note = 4; noteText = "ausreichend"; }
  else if (prozent >= 30) { note = 5; noteText = "mangelhaft"; }

  const bestanden = prozent >= 50;

  // Kommentar nur übernehmen, wenn er nicht offensichtlich widerspricht
  const kommentar =
    punkte > 0 &&
    result.gesamt?.kommentar &&
    /keine aufgaben|nicht beantwortet|nichts beantwortet/i.test(
      result.gesamt.kommentar
    )
      ? undefined
      : result.gesamt?.kommentar;

  return {
    ...result,
    gesamt: { punkte, maxPunkte, prozent, note, noteText, bestanden, kommentar },
  };
}

export default function ExamResult({ exam, completed, answers, onReset }: ExamResultProps) {
  const [kiLoading, setKiLoading] = useState(false);
  const [kiFeedback, setKiFeedback] = useState<string | null>(null);
  const [kiResult, setKiResult] = useState<KiResult | null>(null);
  const [kiError, setKiError] = useState<string | null>(null);
  // Speichern des Ergebnisses in user_exam_attempts (fuers Profil)
  const [saveStatus, setSaveStatus] = useState<"idle" | "saved" | "guest" | "error">("idle");

  const allQuestions = exam.sections.flatMap((s) => s.questions);

  // "Beantwortet" heisst: es steht wirklich etwas in der Antwort. Die
  // Haekchen ("als bearbeitet markiert") waren dafuer unzuverlaessig, weil
  // kaum jemand sie setzt, und dann stand ueberall 0/25 obwohl Ada laengst
  // Punkte vergeben hatte. Tabellen/Matrix speichern JSON, "{}" zaehlt nicht.
  const istBeantwortet = (id: string) => {
    const v = (answers[id] ?? "").trim();
    const hatText = v !== "" && v !== "{}" && v !== "[]";
    // Haekchen zaehlt weiterhin mit (z. B. Diagramm auf Papier gezeichnet).
    return hatText || completed[id] === true;
  };
  const answeredCount = allQuestions.filter((q) => istBeantwortet(q.id)).length;

  // Bewertetes Ergebnis in die Datenbank schreiben, damit es im Profil
  // (Web und App) unter "Pruefungen" erscheint. Gleiche Tabelle wie die
  // App: user_exam_attempts, Pruefung ueber exams.slug (z. B. "ap1-1").
  const ergebnisSpeichern = async (result: KiResult) => {
    try {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) {
        setSaveStatus("guest");
        return;
      }
      const { data: examRow, error: examError } = await supabase
        .from("exams")
        .select("id")
        .eq("slug", exam.id)
        .maybeSingle();
      if (examError || !examRow) {
        console.warn("Kein exams-Eintrag fuer Slug", exam.id, examError?.message);
        setSaveStatus("error");
        return;
      }
      const jetzt = new Date();
      const { error } = await supabase.from("user_exam_attempts").insert({
        user_id: user.id,
        exam_id: examRow.id,
        started_at: jetzt.toISOString(),
        submitted_at: jetzt.toISOString(),
        total_points: result.gesamt.maxPunkte,
        achieved_points: result.gesamt.punkte,
        percentage: result.gesamt.prozent,
        passed: result.gesamt.bestanden,
        status: "graded",
      });
      if (error) {
        console.warn("Ergebnis speichern fehlgeschlagen:", error.message);
        setSaveStatus("error");
        return;
      }
      setSaveStatus("saved");
    } catch (e) {
      console.warn("Ergebnis speichern fehlgeschlagen:", e);
      setSaveStatus("error");
    }
  };

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
      if (!response.ok) throw new Error(data.error || "Unbekannter Fehler");
      if (data.result) {
        const result = reconcileKiResult(data.result as KiResult);
        setKiResult(result);
        setKiFeedback(null);
        void ergebnisSpeichern(result);
      } else {
        setKiFeedback(data.feedback ?? "Keine Antwort erhalten");
        setKiResult(null);
      }
    } catch (error) {
      setKiError(error instanceof Error ? error.message : "Fehler bei der KI-Korrektur");
    } finally {
      setKiLoading(false);
    }
  };

  const answeredPercent = allQuestions.length > 0 ? Math.round((answeredCount / allQuestions.length) * 100) : 0;

  // Farbe/Status einer Teilaufgabe für den Punkt links
  const subStatus = (t: KiTeilaufgabe): "full" | "part" | "zero" | "skip" => {
    if (t.beantwortet === false) return "skip";
    if (t.maxPunkte > 0 && t.punkte >= t.maxPunkte) return "full";
    if (t.punkte > 0) return "part";
    return "zero";
  };

  return (
    <div className="result-page">
      <style>{`
        @import url('https://fonts.googleapis.com/css2?family=Inter+Tight:wght@400;500;600;700&family=Instrument+Serif:ital@0;1&family=JetBrains+Mono:wght@400;500;600&display=swap');
        * { box-sizing: border-box; margin: 0; padding: 0; }

        .result-page {
          font-family: 'Inter Tight', system-ui, sans-serif;
          background: #FAFAF9;
          color: #0A0A0F;
          min-height: 100vh;
        }

        /* NAV */
        .result-nav {
          position: sticky; top: 0; z-index: 50;
          backdrop-filter: blur(12px);
          background: rgba(250,250,249,0.85);
          border-bottom: 1px solid rgba(10,10,15,0.08);
        }
        .result-nav-inner {
          max-width: 1000px; margin: 0 auto;
          padding: 14px 32px;
          display: flex; align-items: center; gap: 12px;
        }
        .result-logo {
          font-family: 'Instrument Serif', serif;
          font-size: 24px; font-style: italic;
          letter-spacing: -0.5px;
          color: #0A0A0F;
          text-decoration: none;
          display: flex; align-items: center;
          margin-right: auto;
        }
        .result-logo-dot {
          width: 6px; height: 6px; border-radius: 50%;
          background: #7C6DFF;
          margin-right: 6px;
          box-shadow: 0 0 12px #7C6DFF;
        }
        .result-back {
          color: #55555F; text-decoration: none;
          font-size: 13px; font-weight: 500;
          padding: 7px 14px; border-radius: 8px;
          border: 1px solid rgba(10,10,15,0.08);
          background: #FFFFFF;
          transition: all 0.2s;
        }
        .result-back:hover {
          color: #0A0A0F;
          border-color: rgba(10,10,15,0.16);
        }

        .result-wrap {
          max-width: 1000px; margin: 0 auto;
          padding: 48px 32px 100px;
        }

        /* HERO */
        .result-hero {
          background: #FFFFFF;
          border: 1px solid rgba(10,10,15,0.08);
          border-radius: 16px;
          padding: 48px 32px;
          margin-bottom: 16px;
          text-align: center;
          position: relative;
          overflow: hidden;
        }
        .result-hero::before {
          content: '';
          position: absolute;
          top: 0; left: 0; right: 0;
          height: 3px;
          background: linear-gradient(90deg, #7C6DFF, #22D3EE);
        }
        .result-hero-eyebrow {
          font-family: 'JetBrains Mono', monospace;
          font-size: 11px; font-weight: 700;
          color: #7C6DFF;
          letter-spacing: 2px;
          text-transform: uppercase;
          margin-bottom: 16px;
        }
        .result-hero-title {
          font-size: clamp(32px, 5vw, 44px);
          font-weight: 600;
          color: #0A0A0F;
          letter-spacing: -1.5px;
          line-height: 1.05;
          margin-bottom: 14px;
        }
        .result-hero-title em {
          font-family: 'Instrument Serif', serif;
          font-style: italic;
          font-weight: 400;
          color: #7C6DFF;
        }
        .result-hero-sub {
          font-family: 'JetBrains Mono', monospace;
          font-size: 12px;
          color: #8A8A92;
          letter-spacing: 1.5px;
          text-transform: uppercase;
        }

        /* KEY NUMBERS */
        .result-stats {
          display: grid;
          grid-template-columns: 1fr 1fr 1fr;
          gap: 12px;
          margin-bottom: 16px;
        }
        .stat-card {
          background: #FFFFFF;
          border: 1px solid rgba(10,10,15,0.08);
          border-radius: 14px;
          padding: 22px;
        }
        .stat-card-label {
          font-family: 'JetBrains Mono', monospace;
          font-size: 10px; font-weight: 700;
          color: #8A8A92;
          letter-spacing: 1.5px;
          text-transform: uppercase;
          margin-bottom: 8px;
        }
        .stat-card-value {
          font-family: 'Instrument Serif', serif;
          font-size: 42px;
          color: #0A0A0F;
          letter-spacing: -1px;
          line-height: 1;
        }
        .stat-card-value em {
          font-style: italic;
          color: #7C6DFF;
        }
        .stat-card-sub {
          font-family: 'JetBrains Mono', monospace;
          font-size: 11px;
          color: #8A8A92;
          margin-top: 6px;
          letter-spacing: 0.5px;
        }

        /* KI BUTTON CARD */
        .ki-card {
          background: linear-gradient(135deg, rgba(124,109,255,0.06), rgba(34,211,238,0.04));
          border: 1px solid rgba(124,109,255,0.20);
          border-radius: 14px;
          padding: 24px;
          margin-bottom: 16px;
        }
        .ki-card-head {
          display: flex; align-items: center; gap: 12px;
          margin-bottom: 16px;
        }
        .ki-card-avatar {
          width: 36px; height: 36px;
          border-radius: 10px;
          background: linear-gradient(135deg, #7C6DFF, #22D3EE);
          color: #FFFFFF;
          font-family: 'Instrument Serif', serif;
          font-style: italic;
          font-size: 18px;
          font-weight: 600;
          display: flex; align-items: center; justify-content: center;
          flex-shrink: 0;
        }
        .ki-card-meta-name {
          font-size: 14px;
          font-weight: 600;
          color: #0A0A0F;
        }
        .ki-card-meta-sub {
          font-family: 'JetBrains Mono', monospace;
          font-size: 10px;
          color: #8A8A92;
          letter-spacing: 1px;
          text-transform: uppercase;
        }
        .ki-btn {
          width: 100%;
          padding: 14px;
          background: #7C6DFF;
          color: #FFFFFF;
          border: 1px solid #7C6DFF;
          border-radius: 10px;
          font-family: 'Inter Tight', system-ui, sans-serif;
          font-size: 14px;
          font-weight: 600;
          cursor: pointer;
          transition: all 0.15s;
          display: inline-flex;
          align-items: center;
          justify-content: center;
          gap: 8px;
        }
        .ki-btn:hover:not(:disabled) {
          background: #6856E6;
          border-color: #6856E6;
          transform: translateY(-1px);
          box-shadow: 0 8px 20px rgba(124,109,255,0.25);
        }
        .ki-btn:disabled {
          opacity: 0.55;
          cursor: not-allowed;
        }
        .ki-spinner {
          width: 14px; height: 14px;
          border: 2px solid rgba(255,255,255,0.3);
          border-top-color: #FFFFFF;
          border-radius: 50%;
          animation: spin 0.8s linear infinite;
        }
        @keyframes spin { to { transform: rotate(360deg); } }

        .ki-error {
          margin-top: 14px;
          padding: 12px 14px;
          background: rgba(220,38,38,0.06);
          border: 1px solid rgba(220,38,38,0.30);
          border-radius: 10px;
          font-size: 13px;
          color: #B91C1C;
          font-family: 'JetBrains Mono', monospace;
          line-height: 1.5;
          word-break: break-word;
        }

        /* KI FEEDBACK (Fallback: roher Text) */
        .ki-feedback {
          background: #FFFFFF;
          border: 1px solid rgba(124,109,255,0.20);
          border-radius: 14px;
          padding: 24px;
          margin-bottom: 16px;
          position: relative;
          overflow: hidden;
        }
        .ki-feedback::before {
          content: '';
          position: absolute;
          top: 0; left: 0; right: 0;
          height: 2px;
          background: linear-gradient(90deg, #7C6DFF, #22D3EE);
        }
        .ki-feedback-head {
          display: flex; align-items: center; gap: 12px;
          margin-bottom: 18px;
          padding-bottom: 16px;
          border-bottom: 1px solid rgba(10,10,15,0.08);
        }
        .ki-feedback-title {
          font-size: 15px;
          font-weight: 600;
          color: #0A0A0F;
        }
        .ki-feedback-body {
          font-size: 14px;
          line-height: 1.7;
          color: #1F1F2A;
          white-space: pre-wrap;
          font-family: 'Inter Tight', system-ui, sans-serif;
        }

        /* ─── STRUKTURIERTES KI-ERGEBNIS ─── */
        .kir-summary {
          display: flex;
          align-items: center;
          gap: 24px;
          flex-wrap: wrap;
          padding: 4px 0 18px;
        }
        .kir-score-big {
          font-family: 'Instrument Serif', serif;
          font-size: 52px;
          letter-spacing: -1.5px;
          line-height: 1;
          color: #0A0A0F;
        }
        .kir-score-big em {
          font-style: italic;
          color: #7C6DFF;
        }
        .kir-score-max {
          font-size: 24px;
          color: #8A8A92;
        }
        .kir-score-sub {
          font-family: 'JetBrains Mono', monospace;
          font-size: 11px;
          color: #8A8A92;
          letter-spacing: 1px;
          text-transform: uppercase;
          margin-top: 6px;
        }
        .kir-save {
          font-size: 12px;
          color: #8A8A92;
          margin-top: 8px;
        }
        .kir-save.ok { color: #1E9E50; }
        .kir-save a { color: inherit; text-decoration: underline; }
        .kir-badges {
          display: flex;
          flex-direction: column;
          gap: 8px;
          margin-left: auto;
          align-items: flex-end;
        }
        .kir-badge {
          font-family: 'JetBrains Mono', monospace;
          font-size: 11px;
          font-weight: 700;
          letter-spacing: 1px;
          text-transform: uppercase;
          padding: 6px 12px;
          border-radius: 7px;
          border: 1px solid;
          white-space: nowrap;
        }
        .kir-badge.pass {
          color: #047857;
          background: rgba(16,185,129,0.08);
          border-color: rgba(16,185,129,0.35);
        }
        .kir-badge.fail {
          color: #B91C1C;
          background: rgba(220,38,38,0.06);
          border-color: rgba(220,38,38,0.30);
        }
        .kir-note-card {
          display: flex;
          flex-direction: column;
          align-items: center;
          padding: 10px 26px 12px;
          border-radius: 14px;
          border: 1.5px solid;
          min-width: 110px;
        }
        .kir-note-label {
          font-family: 'JetBrains Mono', monospace;
          font-size: 10px;
          font-weight: 700;
          letter-spacing: 1.5px;
          text-transform: uppercase;
          opacity: 0.75;
        }
        .kir-note-num {
          font-size: 44px;
          font-weight: 800;
          line-height: 1.1;
          letter-spacing: -1px;
        }
        .kir-note-text {
          font-size: 13px;
          font-weight: 600;
          text-transform: capitalize;
        }
        .kir-note-card.n12 {
          color: #047857;
          background: rgba(16,185,129,0.08);
          border-color: rgba(16,185,129,0.4);
        }
        .kir-note-card.n34 {
          color: #B45309;
          background: rgba(245,158,11,0.08);
          border-color: rgba(245,158,11,0.4);
        }
        .kir-note-card.n56 {
          color: #B91C1C;
          background: rgba(220,38,38,0.07);
          border-color: rgba(220,38,38,0.35);
        }
        .kir-progress {
          height: 8px;
          border-radius: 4px;
          background: rgba(10,10,15,0.06);
          overflow: hidden;
          margin-bottom: 14px;
        }
        .kir-progress-fill {
          height: 100%;
          border-radius: 4px;
          background: linear-gradient(90deg, #7C6DFF, #22D3EE);
          transition: width 0.6s ease;
        }
        .kir-comment {
          font-size: 14px;
          line-height: 1.65;
          color: #55555F;
          background: #FAFAF9;
          border: 1px solid rgba(10,10,15,0.06);
          border-radius: 10px;
          padding: 14px 16px;
          margin-bottom: 4px;
        }

        .kir-task {
          border: 1px solid rgba(10,10,15,0.08);
          border-radius: 12px;
          background: #FAFAF9;
          padding: 16px 18px;
          margin-top: 12px;
        }
        .kir-task-head {
          display: flex;
          align-items: baseline;
          justify-content: space-between;
          gap: 12px;
          margin-bottom: 10px;
        }
        .kir-task-title {
          font-size: 14px;
          font-weight: 600;
          color: #0A0A0F;
        }
        .kir-task-pts {
          font-family: 'JetBrains Mono', monospace;
          font-size: 13px;
          font-weight: 700;
          color: #0A0A0F;
          white-space: nowrap;
        }
        .kir-task-bar {
          height: 5px;
          border-radius: 3px;
          background: rgba(10,10,15,0.07);
          overflow: hidden;
          margin-bottom: 12px;
        }
        .kir-task-bar-fill {
          height: 100%;
          border-radius: 3px;
          background: #7C6DFF;
        }
        .kir-sub {
          display: flex;
          align-items: flex-start;
          gap: 10px;
          padding: 7px 0;
          border-top: 1px solid rgba(10,10,15,0.05);
        }
        .kir-sub:first-of-type { border-top: none; }
        .kir-sub-dot {
          width: 8px; height: 8px;
          border-radius: 50%;
          margin-top: 5px;
          flex-shrink: 0;
        }
        .kir-sub-dot.full { background: #10B981; }
        .kir-sub-dot.part { background: #F59E0B; }
        .kir-sub-dot.zero { background: #EF4444; }
        .kir-sub-dot.skip { background: #C9C9CF; }
        .kir-sub-main { flex: 1; min-width: 0; }
        .kir-sub-title {
          font-size: 13px;
          font-weight: 500;
          color: #1F1F2A;
        }
        .kir-sub-note {
          display: block;
          font-size: 12px;
          color: #8A8A92;
          line-height: 1.5;
          margin-top: 1px;
        }
        .kir-sub-pts {
          font-family: 'JetBrains Mono', monospace;
          font-size: 12px;
          font-weight: 600;
          color: #55555F;
          white-space: nowrap;
        }
        .kir-sub.skip .kir-sub-title,
        .kir-sub.skip .kir-sub-pts { color: #B0B0B6; }

        .kir-tips {
          display: grid;
          grid-template-columns: 1fr 1fr;
          gap: 12px;
          margin-top: 14px;
        }
        .kir-tip-box {
          border-radius: 12px;
          border: 1px solid rgba(10,10,15,0.08);
          background: #FAFAF9;
          padding: 16px 18px;
        }
        .kir-tip-box.wide { grid-column: 1 / -1; }
        .kir-tip-title {
          font-family: 'JetBrains Mono', monospace;
          font-size: 10px;
          font-weight: 700;
          letter-spacing: 1.5px;
          text-transform: uppercase;
          margin-bottom: 10px;
        }
        .kir-tip-title.good { color: #047857; }
        .kir-tip-title.warn { color: #B45309; }
        .kir-tip-title.learn { color: #7C6DFF; }
        .kir-tip-item {
          display: flex;
          gap: 8px;
          font-size: 13px;
          line-height: 1.55;
          color: #1F1F2A;
          padding: 3px 0;
        }
        .kir-tip-item span:first-child { flex-shrink: 0; }

        /* DETAILS PER SECTION */
        .details-card {
          background: #FFFFFF;
          border: 1px solid rgba(10,10,15,0.08);
          border-radius: 14px;
          padding: 26px;
          margin-bottom: 16px;
        }
        .details-title {
          font-size: 16px;
          font-weight: 600;
          color: #0A0A0F;
          letter-spacing: -0.3px;
          margin-bottom: 18px;
          padding-bottom: 14px;
          border-bottom: 1px solid rgba(10,10,15,0.08);
          display: flex; align-items: center; gap: 10px;
        }
        .details-title-pill {
          font-family: 'JetBrains Mono', monospace;
          font-size: 11px;
          font-weight: 700;
          color: #7C6DFF;
          background: rgba(124,109,255,0.08);
          border: 1px solid rgba(124,109,255,0.30);
          padding: 3px 8px;
          border-radius: 5px;
          letter-spacing: 0.5px;
        }
        .section-row {
          display: flex; align-items: center; justify-content: space-between;
          padding: 14px 16px;
          border: 1px solid rgba(10,10,15,0.08);
          border-radius: 10px;
          margin-bottom: 8px;
          background: #FAFAF9;
        }
        .section-row:last-child { margin-bottom: 0; }
        .section-row.complete {
          background: rgba(16,185,129,0.04);
          border-color: rgba(16,185,129,0.20);
        }
        .section-info-name {
          font-size: 14px;
          font-weight: 600;
          color: #0A0A0F;
          margin-bottom: 3px;
        }
        .section-info-meta {
          font-family: 'JetBrains Mono', monospace;
          font-size: 10px;
          color: #8A8A92;
          letter-spacing: 1px;
          text-transform: uppercase;
        }
        .section-pts {
          text-align: right;
        }
        .section-pts-value {
          font-family: 'JetBrains Mono', monospace;
          font-size: 15px;
          font-weight: 700;
          letter-spacing: -0.3px;
          color: #D97706;
        }
        .section-row.complete .section-pts-value { color: #047857; }
        .section-pts-status {
          font-family: 'JetBrains Mono', monospace;
          font-size: 10px;
          color: #10B981;
          letter-spacing: 1px;
          text-transform: uppercase;
          margin-top: 3px;
        }

        /* ACTIONS */
        .actions-row {
          display: flex;
          gap: 10px;
          margin-top: 24px;
        }
        .action-btn {
          flex: 1;
          padding: 13px;
          border-radius: 10px;
          font-family: 'Inter Tight', system-ui, sans-serif;
          font-size: 14px;
          font-weight: 600;
          text-decoration: none;
          text-align: center;
          cursor: pointer;
          transition: all 0.15s;
          border: 1px solid;
          display: inline-flex;
          align-items: center;
          justify-content: center;
          gap: 6px;
        }
        .action-btn.outline {
          background: #FFFFFF;
          color: #55555F;
          border-color: rgba(10,10,15,0.16);
        }
        .action-btn.outline:hover {
          color: #0A0A0F;
          background: #FAFAF9;
        }
        .action-btn.primary {
          background: #0A0A0F;
          color: #FAFAF9;
          border-color: #0A0A0F;
        }
        .action-btn.primary:hover {
          transform: translateY(-1px);
          box-shadow: 0 8px 20px rgba(10,10,15,0.15);
        }
        .action-btn.danger {
          background: #FFFFFF;
          color: #B91C1C;
          border-color: rgba(220,38,38,0.30);
        }
        .action-btn.danger:hover {
          background: rgba(220,38,38,0.06);
        }

        @media (max-width: 700px) {
          .result-wrap { padding: 32px 20px 80px; }
          .result-hero { padding: 36px 20px; }
          .result-stats { grid-template-columns: 1fr; }
          .actions-row { flex-direction: column; }
          .kir-badges { margin-left: 0; align-items: flex-start; }
          .kir-tips { grid-template-columns: 1fr; }
        }
      `}</style>

      {/* NAV */}
      <nav className="result-nav">
        <div className="result-nav-inner">
          <Link href="/" className="result-logo">
            <span className="result-logo-dot" />
            Lernarena
          </Link>
          <Link href="/pruefungen" className="result-back">← Übersicht</Link>
        </div>
      </nav>

      <div className="result-wrap">

        {/* HERO */}
        <div className="result-hero">
          <div className="result-hero-eyebrow">Abgegeben</div>
          <h1 className="result-hero-title">
            Prüfung <em>abgeschlossen.</em>
          </h1>
          <div className="result-hero-sub">
            {exam.title} · {exam.company}
          </div>
        </div>

        {/* STATS */}
        <div className="result-stats">
          <div className="stat-card">
            <div className="stat-card-label">Beantwortet</div>
            <div className="stat-card-value">
              <em>{answeredCount}</em><span style={{ fontSize: 22, color: "#8A8A92" }}> / {allQuestions.length}</span>
            </div>
            <div className="stat-card-sub">{answeredPercent}% der Aufgaben</div>
          </div>
          <div className="stat-card">
            <div className="stat-card-label">Punkte</div>
            <div className="stat-card-value">
              <em>{kiResult ? kiResult.gesamt.punkte : "–"}</em><span style={{ fontSize: 22, color: "#8A8A92" }}> / {kiResult ? kiResult.gesamt.maxPunkte : exam.totalPoints}</span>
            </div>
            <div className="stat-card-sub">{kiResult ? `${kiResult.gesamt.prozent}% erreicht` : "nach Adas Korrektur"}</div>
          </div>
          <div className="stat-card">
            <div className="stat-card-label">Modus</div>
            <div className="stat-card-value">
              <em>AP1</em>
            </div>
            <div className="stat-card-sub">Übungsmodus</div>
          </div>
        </div>

        {/* KI-Tutor Button */}
        <div className="ki-card">
          <div className="ki-card-head">
            <div className="ki-card-avatar">A</div>
            <div>
              <div className="ki-card-meta-name">Ada · KI-Tutor</div>
              <div className="ki-card-meta-sub">Lass deine Antworten bewerten</div>
            </div>
          </div>
          <button
            onClick={requestKiKorrektur}
            disabled={kiLoading}
            className="ki-btn"
          >
            {kiLoading ? (
              <>
                <span className="ki-spinner" />
                Ada analysiert…
              </>
            ) : (
              <>Korrektur anfordern →</>
            )}
          </button>
          {kiError && (
            <div className="ki-error">
              {kiError}
            </div>
          )}
        </div>

        {/* KI Feedback: strukturiert */}
        {kiResult && (
          <div className="ki-feedback">
            <div className="ki-feedback-head">
              <div className="ki-card-avatar">A</div>
              <div>
                <div className="ki-feedback-title">Adas Rückmeldung</div>
                <div className="ki-card-meta-sub">Persönliche Korrektur</div>
              </div>
            </div>

            {/* Gesamtergebnis */}
            <div className="kir-summary">
              <div>
                <div className="kir-score-big">
                  <em>{kiResult.gesamt.punkte}</em>
                  <span className="kir-score-max"> / {kiResult.gesamt.maxPunkte}</span>
                </div>
                <div className="kir-score-sub">{kiResult.gesamt.prozent}% erreicht</div>
                {saveStatus === "saved" && (
                  <div className="kir-save ok">✓ Im Profil gespeichert · <Link href="/profil">ansehen</Link></div>
                )}
                {saveStatus === "guest" && (
                  <div className="kir-save"><Link href="/login?next=/profil">Einloggen</Link>, damit Ergebnisse im Profil gespeichert werden</div>
                )}
                {saveStatus === "error" && (
                  <div className="kir-save">Ergebnis konnte nicht im Profil gespeichert werden</div>
                )}
              </div>
              <div className="kir-badges">
                <span className={`kir-badge ${kiResult.gesamt.bestanden ? "pass" : "fail"}`}>
                  {kiResult.gesamt.bestanden ? "✓ Bestanden" : "✗ Nicht bestanden"}
                </span>
                <div
                  className={`kir-note-card ${
                    kiResult.gesamt.note <= 2
                      ? "n12"
                      : kiResult.gesamt.note <= 4
                        ? "n34"
                        : "n56"
                  }`}
                >
                  <span className="kir-note-label">Note</span>
                  <span className="kir-note-num">{kiResult.gesamt.note}</span>
                  <span className="kir-note-text">{kiResult.gesamt.noteText}</span>
                </div>
              </div>
            </div>
            <div className="kir-progress">
              <div
                className="kir-progress-fill"
                style={{ width: `${Math.min(100, Math.max(0, kiResult.gesamt.prozent))}%` }}
              />
            </div>
            {kiResult.gesamt.kommentar && (
              <p className="kir-comment">{kiResult.gesamt.kommentar}</p>
            )}

            {/* Aufgaben im Detail */}
            {kiResult.aufgaben.map((a, i) => {
              const pct = a.maxPunkte > 0 ? Math.round((a.punkte / a.maxPunkte) * 100) : 0;
              return (
                <div key={i} className="kir-task">
                  <div className="kir-task-head">
                    <span className="kir-task-title">{a.titel}</span>
                    <span className="kir-task-pts">{a.punkte} / {a.maxPunkte} Pkt</span>
                  </div>
                  <div className="kir-task-bar">
                    <div className="kir-task-bar-fill" style={{ width: `${pct}%` }} />
                  </div>
                  {a.teilaufgaben?.map((t, j) => {
                    const st = subStatus(t);
                    return (
                      <div key={j} className={`kir-sub ${st}`}>
                        <span className={`kir-sub-dot ${st}`} />
                        <div className="kir-sub-main">
                          <span className="kir-sub-title">{t.titel}</span>
                          {t.kommentar && st !== "skip" && (
                            <span className="kir-sub-note">{t.kommentar}</span>
                          )}
                          {st === "skip" && (
                            <span className="kir-sub-note">Nicht beantwortet</span>
                          )}
                        </div>
                        <span className="kir-sub-pts">{t.punkte}/{t.maxPunkte}</span>
                      </div>
                    );
                  })}
                </div>
              );
            })}

            {/* Tipps */}
            {(kiResult.staerken?.length || kiResult.verbesserungen?.length || kiResult.lernempfehlungen?.length) ? (
              <div className="kir-tips">
                {kiResult.staerken && kiResult.staerken.length > 0 && (
                  <div className="kir-tip-box">
                    <div className="kir-tip-title good">Das war gut</div>
                    {kiResult.staerken.map((s, i) => (
                      <div key={i} className="kir-tip-item"><span>✓</span><span>{s}</span></div>
                    ))}
                  </div>
                )}
                {kiResult.verbesserungen && kiResult.verbesserungen.length > 0 && (
                  <div className="kir-tip-box">
                    <div className="kir-tip-title warn">Hier geht mehr</div>
                    {kiResult.verbesserungen.map((s, i) => (
                      <div key={i} className="kir-tip-item"><span>→</span><span>{s}</span></div>
                    ))}
                  </div>
                )}
                {kiResult.lernempfehlungen && kiResult.lernempfehlungen.length > 0 && (
                  <div className="kir-tip-box wide">
                    <div className="kir-tip-title learn">Lernempfehlungen</div>
                    {kiResult.lernempfehlungen.map((s, i) => (
                      <div key={i} className="kir-tip-item"><span>📚</span><span>{s}</span></div>
                    ))}
                  </div>
                )}
              </div>
            ) : null}
          </div>
        )}

        {/* KI Feedback: Fallback als Text */}
        {!kiResult && kiFeedback && (
          <div className="ki-feedback">
            <div className="ki-feedback-head">
              <div className="ki-card-avatar">A</div>
              <div>
                <div className="ki-feedback-title">Adas Rückmeldung</div>
                <div className="ki-card-meta-sub">Persönliche Korrektur</div>
              </div>
            </div>
            <div className="ki-feedback-body">{kiFeedback}</div>
          </div>
        )}

        {/* DETAILS */}
        <div className="details-card">
          <div className="details-title">
            <span className="details-title-pill">Aufgaben</span>
            Details pro Handlungsschritt
          </div>
          {exam.sections.map((section, index) => {
            const sectionAnswered = section.questions.filter((q) => istBeantwortet(q.id)).length;
            const sectionTotal = section.questions.length;
            const sectionTotalPoints = section.questions.reduce((sum, q) => sum + q.points, 0);
            const isComplete = sectionAnswered === sectionTotal;

            // Punkte kommen NUR aus Adas Bewertung (gleiche Reihenfolge wie
            // die Handlungsschritte im Prompt). Vorher: Strich statt 0.
            const kiAufgabe = kiResult?.aufgaben?.[index];
            const punkteText = kiAufgabe
              ? `${kiAufgabe.punkte} / ${kiAufgabe.maxPunkte || sectionTotalPoints} Pkt`
              : `– / ${sectionTotalPoints} Pkt`;
            const status = kiAufgabe
              ? kiAufgabe.punkte >= (kiAufgabe.maxPunkte || sectionTotalPoints) * 0.5
                ? "✓ Bestanden"
                : ""
              : isComplete
                ? "✓ Vollständig beantwortet"
                : "noch nicht bewertet";

            return (
              <div key={section.id} className={`section-row ${isComplete ? "complete" : ""}`}>
                <div>
                  <div className="section-info-name">Aufgabe {index + 1}</div>
                  <div className="section-info-meta">
                    {sectionAnswered} / {sectionTotal} Unteraufgaben beantwortet
                  </div>
                </div>
                <div className="section-pts">
                  <div className="section-pts-value">{punkteText}</div>
                  {status && <div className="section-pts-status">{status}</div>}
                </div>
              </div>
            );
          })}
        </div>

        {/* ACTIONS */}
        <div className="actions-row">
          <Link href="/pruefungen" className="action-btn outline">
            ← Zur Übersicht
          </Link>
          <button onClick={() => window.print()} className="action-btn primary">
            Drucken
          </button>
          <button onClick={onReset} className="action-btn danger">
            Zurücksetzen
          </button>
        </div>
      </div>
    </div>
  );
}
