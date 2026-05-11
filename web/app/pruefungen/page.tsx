"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { examList } from "@/data/exams";
import { Exam } from "@/data/exam-types";

export default function PruefungenPage() {
  const [isDark, setIsDark] = useState(true);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
    const saved = typeof window !== "undefined" ? localStorage.getItem("lernarena-theme") : null;
    if (saved === "light") setIsDark(false);
  }, []);

  useEffect(() => {
    if (mounted && typeof window !== "undefined") {
      localStorage.setItem("lernarena-theme", isDark ? "dark" : "light");
    }
  }, [isDark, mounted]);

  // Gruppierung über die neuen Type-Felder
  const ap1Exams = examList.filter((e) => e.level === "ap1");
  const ap2AeExams = examList.filter((e) => e.level === "ap2" && e.fachrichtung === "ae");
  const ap2SiExams = examList.filter((e) => e.level === "ap2" && e.fachrichtung === "si");

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
    grain: isDark
      ? "url(\"data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.35'/%3E%3C/svg%3E\")"
      : "url(\"data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.18'/%3E%3C/svg%3E\")",
  };

  if (!mounted) {
    return <div style={{ minHeight: "100vh", background: "#08080C" }} />;
  }

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
        html { scroll-behavior: smooth; }

        .grain::before {
          content: '';
          position: fixed; inset: 0;
          background-image: ${t.grain};
          pointer-events: none;
          z-index: 1;
          mix-blend-mode: ${isDark ? "overlay" : "multiply"};
          opacity: 0.5;
        }

        /* NAV */
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

        /* HERO */
        .hero {
          max-width: 1200px; margin: 0 auto;
          padding: 80px 32px 40px;
          text-align: center;
          position: relative;
        }
        .hero::before {
          content: '';
          position: absolute;
          top: 20%; left: 50%;
          transform: translateX(-50%);
          width: 600px; height: 300px;
          background: radial-gradient(ellipse, ${t.accentSoft} 0%, transparent 60%);
          pointer-events: none;
          z-index: 0;
        }
        .hero-inner { position: relative; z-index: 1; }
        .eyebrow {
          display: inline-flex; align-items: center; gap: 8px;
          padding: 6px 12px;
          border: 1px solid ${t.border};
          border-radius: 100px;
          font-family: 'JetBrains Mono', monospace;
          font-size: 11px; font-weight: 500;
          color: ${t.textMid};
          margin-bottom: 28px;
          background: ${t.surface};
        }
        .eyebrow-dot {
          width: 6px; height: 6px; border-radius: 50%;
          background: #10B981;
          box-shadow: 0 0 8px #10B981;
          animation: pulse 2s infinite;
        }
        @keyframes pulse {
          0%, 100% { opacity: 1; }
          50% { opacity: 0.4; }
        }
        .hero-title {
          font-size: clamp(36px, 5.5vw, 60px);
          font-weight: 600;
          line-height: 1;
          letter-spacing: -2px;
          margin-bottom: 18px;
          color: ${t.text};
        }
        .hero-title em {
          font-family: 'Instrument Serif', serif;
          font-style: italic;
          font-weight: 400;
          color: ${t.accent};
          letter-spacing: -1px;
        }
        .hero-sub {
          font-size: 16px;
          line-height: 1.6;
          color: ${t.textMid};
          max-width: 540px;
          margin: 0 auto;
        }

        /* CONTENT */
        .content-wrap {
          max-width: 1100px; margin: 0 auto;
          padding: 24px 32px 100px;
          position: relative;
          z-index: 2;
        }

        /* LEVEL HEADER (AP1 / AP2) */
        .level-header {
          display: flex; align-items: center; gap: 14px;
          margin-top: 56px; margin-bottom: 24px;
          padding-bottom: 18px;
          border-bottom: 1px solid ${t.border};
        }
        .level-header:first-of-type { margin-top: 24px; }
        .level-pill {
          font-family: 'JetBrains Mono', monospace;
          font-size: 11px; font-weight: 600;
          padding: 6px 12px; border-radius: 6px;
          letter-spacing: 1.5px;
          border: 1px solid ${t.border};
        }
        .level-pill.ap1 {
          background: ${t.accentSoft};
          color: ${t.accent};
          border-color: ${t.accent}40;
        }
        .level-pill.ap2 {
          background: ${isDark ? "rgba(34,211,238,0.10)" : "rgba(34,211,238,0.08)"};
          color: ${t.accent2};
          border-color: ${t.accent2}40;
        }
        .level-title {
          font-family: 'Instrument Serif', serif;
          font-style: italic;
          font-size: 32px;
          color: ${t.text};
          letter-spacing: -1px;
          line-height: 1;
        }
        .level-sub {
          font-family: 'JetBrains Mono', monospace;
          color: ${t.textDim};
          font-size: 11px;
          letter-spacing: 1.5px;
          margin-left: auto;
          text-transform: uppercase;
        }

        /* SECTION (AE / SI / shared) */
        .section-header {
          display: flex; align-items: center; gap: 14px;
          margin-bottom: 18px; margin-top: 32px;
        }
        .section-header:first-child { margin-top: 0; }
        .section-icon {
          width: 42px; height: 42px; border-radius: 10px;
          display: flex; align-items: center; justify-content: center;
          font-size: 18px; flex-shrink: 0;
          border: 1px solid ${t.border};
          background: ${t.surface};
        }
        .section-title-text {
          font-size: 17px; font-weight: 600;
          color: ${t.text};
          letter-spacing: -0.3px;
          margin-bottom: 2px;
        }
        .section-count {
          font-family: 'JetBrains Mono', monospace;
          color: ${t.textDim};
          font-size: 11px;
          letter-spacing: 1px;
        }

        /* EXAM GRID */
        .exams-grid {
          display: grid;
          grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
          gap: 14px;
        }
        .exam-card {
          background: ${t.surface};
          border: 1px solid ${t.border};
          border-radius: 14px; padding: 22px;
          text-decoration: none; color: inherit;
          transition: all 0.25s ease;
          display: block; position: relative; overflow: hidden;
        }
        .exam-card::before {
          content: ''; position: absolute;
          top: 0; left: 0; right: 0; height: 2px;
          background: linear-gradient(90deg, ${t.accent}, ${t.accent2});
          opacity: 0; transition: opacity 0.25s;
        }
        .exam-card:hover {
          border-color: ${t.borderStrong};
          transform: translateY(-3px);
          box-shadow: 0 10px 30px ${isDark ? "rgba(0,0,0,0.4)" : "rgba(10,10,15,0.08)"};
        }
        .exam-card:hover::before { opacity: 1; }

        .exam-badges-row {
          display: flex; gap: 6px; margin-bottom: 14px; flex-wrap: wrap;
        }
        .exam-badge {
          display: inline-flex;
          padding: 4px 10px;
          border-radius: 6px;
          font-family: 'JetBrains Mono', monospace;
          font-size: 10px; font-weight: 600;
          letter-spacing: 1px;
          border: 1px solid ${t.border};
        }
        .exam-badge.season {
          background: ${t.bgMuted};
          color: ${t.textMid};
        }
        .exam-badge.level {
          background: ${t.accentSoft};
          color: ${t.accent};
          border-color: ${t.accent}40;
        }
        .exam-badge.fach.ae {
          background: ${isDark ? "rgba(59,130,246,0.10)" : "rgba(59,130,246,0.08)"};
          color: #60A5FA;
          border-color: rgba(59,130,246,0.3);
        }
        .exam-badge.fach.si {
          background: ${isDark ? "rgba(16,185,129,0.10)" : "rgba(16,185,129,0.08)"};
          color: #34D399;
          border-color: rgba(16,185,129,0.3);
        }
        .exam-badge.fach.shared {
          background: ${t.accentSoft};
          color: ${t.accent};
          border-color: ${t.accent}40;
        }

        .exam-title {
          font-size: 16px; font-weight: 600;
          color: ${t.text};
          line-height: 1.3;
          letter-spacing: -0.3px;
          margin-bottom: 4px;
        }
        .exam-company {
          font-family: 'JetBrains Mono', monospace;
          color: ${t.textDim};
          font-size: 11px;
          letter-spacing: 1px;
          margin-bottom: 18px;
          text-transform: uppercase;
        }
        .exam-meta {
          display: flex; align-items: center; justify-content: space-between;
          padding-top: 14px; border-top: 1px solid ${t.border};
        }
        .exam-chips { display: flex; gap: 8px; }
        .exam-chip {
          display: flex; align-items: center; gap: 4px;
          font-family: 'JetBrains Mono', monospace;
          color: ${t.textMid};
          font-size: 11px;
          padding: 3px 8px;
          border-radius: 5px;
          border: 1px solid ${t.border};
          background: ${t.bgMuted};
        }
        .exam-arrow {
          font-size: 13px; font-weight: 600;
          color: ${t.accent};
          transition: transform 0.2s;
        }
        .exam-card:hover .exam-arrow { transform: translateX(4px); }

        /* FOOTER */
        .footer-strip {
          border-top: 1px solid ${t.border};
          padding: 24px 32px;
          text-align: center;
          color: ${t.textDim};
          font-family: 'JetBrains Mono', monospace;
          font-size: 11px;
          display: flex; justify-content: center; gap: 28px; flex-wrap: wrap;
          background: ${t.bg};
          letter-spacing: 1px;
        }
        .footer-strip span { display: flex; align-items: center; gap: 6px; }
        .footer-check { color: ${t.accent}; }

        @media (max-width: 768px) {
          .nav-inner, .hero, .content-wrap, .footer-strip { padding-left: 20px; padding-right: 20px; }
          .exams-grid { grid-template-columns: 1fr; }
          .level-sub { display: none; }
          .level-title { font-size: 26px; }
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
            <button
              className="theme-btn"
              onClick={() => setIsDark(!isDark)}
              aria-label="Theme wechseln"
            >
              {isDark ? "☀" : "☾"}
            </button>
            <Link href="/" className="back-btn">← Startseite</Link>
          </div>
        </div>
      </nav>

      {/* HERO */}
      <section className="hero">
        <div className="hero-inner">
          <div className="eyebrow">
            <span className="eyebrow-dot" />
            {examList.length} Prüfungen · AP1 &amp; AP2 · Live
          </div>
          <h1 className="hero-title">
            Wähle deine <em>Prüfung.</em>
          </h1>
          <p className="hero-sub">
            Realistische Simulationen mit Timer, verschiedenen Aufgabentypen
            und KI-Feedback. AP1 fachrichtungsübergreifend, AP2 nach Spezialisierung.
          </p>
        </div>
      </section>

      {/* CONTENT */}
      <div className="content-wrap">

        {/* ============================================ */}
        {/* AP1 — HALBJAHRESPRÜFUNG */}
        {/* ============================================ */}
        {ap1Exams.length > 0 && (
          <>
            <div className="level-header">
              <span className="level-pill ap1">AP1</span>
              <span className="level-title">Halbjahresprüfung</span>
              <span className="level-sub">Fachrichtungsübergreifend</span>
            </div>

            <div className="section-header">
              <div className="section-icon">📚</div>
              <div>
                <div className="section-title-text">Alle Fachrichtungen</div>
                <div className="section-count">
                  {ap1Exams.length} {ap1Exams.length === 1 ? "PRÜFUNG" : "PRÜFUNGEN"} VERFÜGBAR
                </div>
              </div>
            </div>
            <div className="exams-grid">
              {ap1Exams.map((exam) => (
                <ExamCard key={exam.id} exam={exam} theme={t} />
              ))}
            </div>
          </>
        )}

        {/* ============================================ */}
        {/* AP2 — ABSCHLUSSPRÜFUNG */}
        {/* ============================================ */}
        {(ap2AeExams.length > 0 || ap2SiExams.length > 0) && (
          <>
            <div className="level-header">
              <span className="level-pill ap2">AP2</span>
              <span className="level-title">Abschlussprüfung</span>
              <span className="level-sub">Fachrichtungsspezifisch</span>
            </div>

            {ap2AeExams.length > 0 && (
              <>
                <div className="section-header">
                  <div className="section-icon">💻</div>
                  <div>
                    <div className="section-title-text">Anwendungsentwicklung</div>
                    <div className="section-count">{ap2AeExams.length} PRÜFUNGEN VERFÜGBAR</div>
                  </div>
                </div>
                <div className="exams-grid">
                  {ap2AeExams.map((exam) => (
                    <ExamCard key={exam.id} exam={exam} theme={t} />
                  ))}
                </div>
              </>
            )}

            {ap2SiExams.length > 0 && (
              <>
                <div className="section-header">
                  <div className="section-icon">🖧</div>
                  <div>
                    <div className="section-title-text">Systemintegration</div>
                    <div className="section-count">{ap2SiExams.length} PRÜFUNGEN VERFÜGBAR</div>
                  </div>
                </div>
                <div className="exams-grid">
                  {ap2SiExams.map((exam) => (
                    <ExamCard key={exam.id} exam={exam} theme={t} />
                  ))}
                </div>
              </>
            )}
          </>
        )}

      </div>

      {/* FOOTER STRIP */}
      <div className="footer-strip">
        <span><span className="footer-check">✓</span> ECHTE PRÜFUNGSBEDINGUNGEN</span>
        <span><span className="footer-check">✓</span> 90 MINUTEN TIMER</span>
        <span><span className="footer-check">✓</span> KI-TUTOR FEEDBACK</span>
        <span><span className="footer-check">✓</span> SOFORTIGES ERGEBNIS</span>
      </div>
    </div>
  );
}

// ============================================
// EXAM CARD KOMPONENTE
// ============================================
function ExamCard({ exam, theme }: { exam: Exam; theme: { textMid: string } }) {
  const fach = exam.fachrichtung || "shared";
  return (
    <Link href={`/pruefung/${exam.id}`} className="exam-card">
      <div className="exam-badges-row">
        <span className={`exam-badge fach ${fach}`}>
          {fach === "ae" ? "AE" : fach === "si" ? "SI" : "ALLE"}
        </span>
        <span className="exam-badge level">
          {exam.level === "ap1" ? "AP1" : "AP2"}
        </span>
        <span className="exam-badge season">
          {exam.season.toUpperCase()} {exam.year}
        </span>
      </div>
      <div className="exam-title">{exam.title}</div>
      <div className="exam-company">{exam.company}</div>
      <div className="exam-meta">
        <div className="exam-chips">
          <span className="exam-chip">⏱ {exam.duration} MIN</span>
          <span className="exam-chip">📊 {exam.totalPoints} PKT</span>
        </div>
        <span className="exam-arrow">→</span>
      </div>
    </Link>
  );
}