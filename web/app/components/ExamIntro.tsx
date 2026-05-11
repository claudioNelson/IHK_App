"use client";

import { useState, useEffect } from "react";
import { Exam } from "@/data/exam-types";
import Link from "next/link";

interface ExamIntroProps {
    exam: Exam;
    onStart: () => void;
}

export default function ExamIntro({ exam, onStart }: ExamIntroProps) {
    // Prüfungs-Modus läuft IMMER im hellen Theme - bessere Lesbarkeit beim Lernen
    const isDark = false;
    const [mounted, setMounted] = useState(false);

    useEffect(() => {
        setMounted(true);
    }, []);

    const t = {
        bg: isDark ? "#08080C" : "#FAFAF9",
        bgMuted: isDark ? "#0E0E14" : "#F4F4F1",
        surface: isDark ? "#12121C" : "#FFFFFF",
        border: isDark ? "rgba(255,255,255,0.08)" : "rgba(10,10,15,0.08)",
        borderStrong: isDark ? "rgba(255,255,255,0.14)" : "rgba(10,10,15,0.12)",
        text: isDark ? "#F5F5F7" : "#0A0A0F",
        textMid: isDark ? "#A0A0B0" : "#55555F",
        textDim: isDark ? "#606070" : "#8A8A92",
        accent: "#7C6DFF",
        accentSoft: isDark ? "rgba(124,109,255,0.14)" : "rgba(124,109,255,0.08)",
        accent2: "#22D3EE",
        warn: isDark ? "#FBBF24" : "#D97706",
        warnSoft: isDark ? "rgba(251,191,36,0.10)" : "rgba(217,119,6,0.08)",
        grain: isDark
            ? "url(\"data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.35'/%3E%3C/svg%3E\")"
            : "url(\"data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.18'/%3E%3C/svg%3E\")",
    };

    if (!mounted) {
        return <div style={{ minHeight: "100vh", background: "#08080C" }} />;
    }

    // Dynamische Texte basierend auf Level/sectionsToChoose
    const sectionCountText = exam.sectionsToChoose
        ? `${exam.sectionsToChoose} (wähle ${exam.sectionsToChoose} von ${exam.sections.length})`
        : `${exam.sections.length} (alle bearbeiten)`;

    const fachLabel =
        exam.fachrichtung === "ae" ? "Anwendungsentwicklung" :
        exam.fachrichtung === "si" ? "Systemintegration" :
        exam.fachrichtung === "shared" ? "Alle Fachrichtungen" :
        exam.fachrichtung || "—";

    return (
        <div
            style={{
                background: t.bg,
                color: t.text,
                minHeight: "100vh",
                fontFamily: "'Inter Tight', system-ui, sans-serif",
                transition: "background 0.3s, color 0.3s",
            }}
        >
            <style>{`
                @import url('https://fonts.googleapis.com/css2?family=Inter+Tight:wght@400;500;600;700&family=Instrument+Serif:ital@0;1&family=JetBrains+Mono:wght@400;500;600&display=swap');
                * { box-sizing: border-box; margin: 0; padding: 0; }

                .grain::before {
                    content: '';
                    position: fixed; inset: 0;
                    background-image: ${t.grain};
                    pointer-events: none;
                    z-index: 1;
                    mix-blend-mode: ${isDark ? "overlay" : "multiply"};
                    opacity: 0.5;
                }

                .nav {
                    position: sticky; top: 0; z-index: 50;
                    backdrop-filter: blur(12px);
                    background: ${isDark ? "rgba(8,8,12,0.72)" : "rgba(250,250,249,0.72)"};
                    border-bottom: 1px solid ${t.border};
                }
                .nav-inner {
                    max-width: 1200px; margin: 0 auto;
                    padding: 16px 32px;
                    display: flex; align-items: center; justify-content: space-between;
                }
                .logo {
                    font-family: 'Instrument Serif', serif;
                    font-size: 26px; font-style: italic;
                    letter-spacing: -0.5px;
                    color: ${t.text};
                    text-decoration: none;
                    display: flex; align-items: center; gap: 2px;
                }
                .logo-dot {
                    width: 6px; height: 6px; border-radius: 50%;
                    background: ${t.accent};
                    margin-right: 4px;
                    box-shadow: 0 0 12px ${t.accent};
                }
                .nav-actions { display: flex; gap: 12px; align-items: center; }
                .theme-btn {
                    width: 36px; height: 36px;
                    border-radius: 8px;
                    border: 1px solid ${t.border};
                    background: transparent;
                    color: ${t.text};
                    cursor: pointer;
                    display: flex; align-items: center; justify-content: center;
                    transition: all 0.2s;
                    font-size: 14px;
                }
                .theme-btn:hover { border-color: ${t.borderStrong}; background: ${t.surface}; }
                .back-btn {
                    display: flex; align-items: center; gap: 8px;
                    color: ${t.textMid}; text-decoration: none; font-size: 14px;
                    font-weight: 500; transition: all 0.2s;
                    padding: 8px 16px; border-radius: 8px;
                    border: 1px solid ${t.border};
                }
                .back-btn:hover { color: ${t.text}; border-color: ${t.borderStrong}; transform: translateX(-3px); }

                .wrap {
                    max-width: 800px; margin: 0 auto;
                    padding: 60px 32px 80px;
                    position: relative;
                    z-index: 2;
                }
                .wrap::before {
                    content: '';
                    position: absolute;
                    top: 10%; left: 50%;
                    transform: translateX(-50%);
                    width: 600px; height: 400px;
                    background: radial-gradient(ellipse, ${t.accentSoft} 0%, transparent 60%);
                    pointer-events: none;
                    z-index: -1;
                }

                .eyebrow-row {
                    display: flex; align-items: center; justify-content: center;
                    gap: 8px; flex-wrap: wrap;
                    margin-bottom: 20px;
                }
                .eyebrow-pill {
                    display: inline-flex; align-items: center; gap: 8px;
                    padding: 5px 12px;
                    border: 1px solid ${t.border};
                    border-radius: 100px;
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 11px; font-weight: 500;
                    color: ${t.textMid};
                    background: ${t.surface};
                    letter-spacing: 0.5px;
                }
                .eyebrow-pill.accent {
                    background: ${t.accentSoft};
                    color: ${t.accent};
                    border-color: ${t.accent}40;
                }
                .eyebrow-pill.live::before {
                    content: '';
                    width: 6px; height: 6px; border-radius: 50%;
                    background: #10B981;
                    box-shadow: 0 0 8px #10B981;
                    animation: pulse 2s infinite;
                }
                @keyframes pulse {
                    0%, 100% { opacity: 1; }
                    50% { opacity: 0.4; }
                }

                .title {
                    font-size: clamp(28px, 4.5vw, 44px);
                    font-weight: 600;
                    line-height: 1.05;
                    letter-spacing: -1.5px;
                    text-align: center;
                    margin-bottom: 12px;
                    color: ${t.text};
                }
                .title em {
                    font-family: 'Instrument Serif', serif;
                    font-style: italic;
                    font-weight: 400;
                    color: ${t.accent};
                }
                .company {
                    font-family: 'JetBrains Mono', monospace;
                    color: ${t.textDim};
                    font-size: 12px;
                    letter-spacing: 1.5px;
                    text-align: center;
                    text-transform: uppercase;
                    margin-bottom: 48px;
                }

                .card {
                    background: ${t.surface};
                    border: 1px solid ${t.border};
                    border-radius: 14px;
                    padding: 24px;
                    margin-bottom: 16px;
                }
                .card-head {
                    display: flex; align-items: center; gap: 10px;
                    margin-bottom: 14px;
                }
                .card-icon {
                    width: 28px; height: 28px;
                    border-radius: 7px;
                    display: flex; align-items: center; justify-content: center;
                    font-size: 14px;
                    background: ${t.bgMuted};
                    border: 1px solid ${t.border};
                }
                .card-title {
                    font-size: 14px; font-weight: 600;
                    color: ${t.text};
                    letter-spacing: -0.2px;
                }

                .scenario-text {
                    font-size: 14px;
                    line-height: 1.7;
                    color: ${t.textMid};
                    white-space: pre-line;
                }

                .info-list {
                    list-style: none;
                    display: flex; flex-direction: column;
                    gap: 10px;
                }
                .info-row {
                    display: flex; align-items: center; gap: 10px;
                    font-size: 13px;
                    color: ${t.textMid};
                }
                .info-row-label {
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 11px;
                    color: ${t.textDim};
                    letter-spacing: 1px;
                    text-transform: uppercase;
                    min-width: 130px;
                }
                .info-row-value {
                    font-weight: 600;
                    color: ${t.text};
                }
                .info-row-value strong {
                    color: ${t.accent};
                }

                .hint-card {
                    background: ${t.warnSoft};
                    border-color: ${t.warn}40;
                }
                .hint-card .card-title { color: ${t.warn}; }
                .hint-list {
                    list-style: none;
                    display: flex; flex-direction: column;
                    gap: 12px;
                }
                .hint-list li {
                    font-size: 13px;
                    line-height: 1.6;
                    color: ${t.textMid};
                    padding-left: 18px;
                    position: relative;
                }
                .hint-list li::before {
                    content: '→';
                    position: absolute;
                    left: 0;
                    color: ${t.warn};
                    font-weight: 700;
                }
                .hint-list li strong { color: ${t.text}; font-weight: 600; }

                .tool-card {
                    background: ${t.accentSoft};
                    border-color: ${t.accent}40;
                }
                .tool-card .card-title { color: ${t.accent}; }
                .tool-card p {
                    font-size: 13px;
                    line-height: 1.6;
                    color: ${t.textMid};
                }

                .actions {
                    display: flex; gap: 12px;
                    margin-top: 32px;
                }
                .btn {
                    flex: 1;
                    padding: 14px;
                    border-radius: 10px;
                    font-size: 15px; font-weight: 600;
                    text-decoration: none; text-align: center;
                    transition: all 0.15s;
                    cursor: pointer;
                    border: none;
                    font-family: inherit;
                }
                .btn-secondary {
                    background: transparent;
                    color: ${t.text};
                    border: 1px solid ${t.borderStrong};
                }
                .btn-secondary:hover {
                    background: ${t.surface};
                }
                .btn-primary {
                    background: ${t.text};
                    color: ${t.bg};
                    border: 1px solid ${t.text};
                }
                .btn-primary:hover {
                    transform: translateY(-1px);
                    box-shadow: 0 10px 30px ${isDark ? "rgba(255,255,255,0.1)" : "rgba(0,0,0,0.15)"};
                }

                @media (max-width: 640px) {
                    .nav-inner, .wrap { padding-left: 20px; padding-right: 20px; }
                    .info-row { flex-direction: column; align-items: flex-start; gap: 2px; }
                    .info-row-label { min-width: auto; }
                    .actions { flex-direction: column; }
                }
            `}</style>

            <div className="grain" />

            {/* NAV */}
            <nav className="nav">
                <div className="nav-inner">
                    <Link href="/" className="logo">
                        <span className="logo-dot" />
                        Lernarena
                    </Link>
                    <div className="nav-actions">
                        <Link href="/pruefungen" className="back-btn">← Übersicht</Link>
                    </div>
                </div>
            </nav>

            <div className="wrap">

                {/* HEADER */}
                <div className="eyebrow-row">
                    <span className="eyebrow-pill accent">
                        {exam.level === "ap1" ? "AP1" : "AP2"} · {fachLabel}
                    </span>
                    <span className="eyebrow-pill">
                        {exam.season.toUpperCase()} {exam.year}
                    </span>
                    <span className="eyebrow-pill live">
                        Bereit
                    </span>
                </div>

                <h1 className="title">
                    {exam.title}
                </h1>
                <div className="company">{exam.company}</div>

                {/* AUSGANGSSITUATION */}
                {exam.scenario && (
                    <div className="card">
                        <div className="card-head">
                            <div className="card-icon">📖</div>
                            <div className="card-title">Ausgangssituation</div>
                        </div>
                        <div className="scenario-text">{exam.scenario}</div>
                    </div>
                )}

                {/* PRÜFUNGSINFOS */}
                <div className="card">
                    <div className="card-head">
                        <div className="card-icon">📋</div>
                        <div className="card-title">Prüfungsinfos</div>
                    </div>
                    <ul className="info-list">
                        <li className="info-row">
                            <span className="info-row-label">Bearbeitungszeit</span>
                            <span className="info-row-value"><strong>{exam.duration}</strong> Minuten</span>
                        </li>
                        <li className="info-row">
                            <span className="info-row-label">Punktzahl</span>
                            <span className="info-row-value"><strong>{exam.totalPoints}</strong> Punkte</span>
                        </li>
                        <li className="info-row">
                            <span className="info-row-label">Aufgaben</span>
                            <span className="info-row-value">{sectionCountText}</span>
                        </li>
                        {exam.difficulty && (
                            <li className="info-row">
                                <span className="info-row-label">Schwierigkeit</span>
                                <span className="info-row-value" style={{ textTransform: "capitalize" }}>{exam.difficulty}</span>
                            </li>
                        )}
                    </ul>
                </div>

                {/* HINWEISE */}
                <div className="card hint-card">
                    <div className="card-head">
                        <div className="card-icon">⚠️</div>
                        <div className="card-title">Wichtige Hinweise</div>
                    </div>
                    <ul className="hint-list">
                        <li>
                            <strong>Keine Hilfsmittel:</strong> Bearbeite die Prüfung ohne Google, ChatGPT oder andere Hilfen — nur so lernst du wirklich.
                        </li>
                        <li>
                            <strong>Echte Prüfungsbedingungen:</strong> Der Timer läuft. Versuche, die Zeit einzuhalten.
                        </li>
                        <li>
                            <strong>Zwischenspeicherung:</strong> Deine Antworten werden automatisch gespeichert.
                        </li>
                    </ul>
                </div>

                {/* DIAGRAMM-TOOL */}
                <div className="card tool-card">
                    <div className="card-head">
                        <div className="card-icon">🎨</div>
                        <div className="card-title">Diagramm-Tool</div>
                    </div>
                    <p>
                        Einige Aufgaben erfordern das Zeichnen von Diagrammen (UML, ER, Netzplan).
                        Mach dich vorher mit dem Tool vertraut — du kannst es jederzeit testen,
                        ohne dass etwas gespeichert wird.
                    </p>
                </div>

                {/* ACTIONS */}
                <div className="actions">
                    <Link href="/pruefungen" className="btn btn-secondary">
                        ← Zurück
                    </Link>
                    <button onClick={onStart} className="btn btn-primary">
                        Prüfung starten →
                    </button>
                </div>

            </div>
        </div>
    );
}