"use client";

import { useState, useEffect } from "react";
import Link from "next/link";

export default function LandingPage() {
  const [isDark, setIsDark] = useState(true);
  const [mounted, setMounted] = useState(false);
  const [activeDemo, setActiveDemo] = useState(0);
  const [adaInput, setAdaInput] = useState("");
  const [adaMessages, setAdaMessages] = useState([
    {
      role: "user",
      text: "Was ist der Unterschied zwischen RAID 5 und RAID 6?",
    },
    {
      role: "ada",
      text: "Gute Frage. Beide nutzen Parity, aber RAID 5 verteilt **eine** Paritätsinformation über alle Platten (n-1 nutzbar), während RAID 6 **zwei** unabhängige Paritäten nutzt (n-2 nutzbar). Heißt: RAID 6 überlebt 2 gleichzeitige Plattenausfälle, RAID 5 nur einen.",
    },
    {
      role: "user",
      text: "Wann nehme ich welches?",
    },
    {
      role: "ada",
      text: "Faustregel: Bei **8+ Platten oder großen Kapazitäten (>2TB)** → RAID 6. Rebuild-Zeiten bei großen Platten sind so lang, dass während eines Rebuilds eine zweite Platte ausfallen kann. Das killt dein RAID 5 komplett.",
    },
  ]);

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

  // Auto-rotate demo tabs
  useEffect(() => {
    const interval = setInterval(() => {
      setActiveDemo((prev) => (prev + 1) % 3);
    }, 5000);
    return () => clearInterval(interval);
  }, []);

  const handleAdaSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!adaInput.trim()) return;
    setAdaMessages((prev) => [
      ...prev,
      { role: "user", text: adaInput },
      {
        role: "ada",
        text: "Das ist eine Demo-Chat-Vorschau. In der App antworte ich dir natürlich echt — mit Beispielen, Eselsbrücken und Prüfungsfragen zum Üben.",
      },
    ]);
    setAdaInput("");
  };

  const t = {
    bg: isDark ? "#08080C" : "#FAFAF9",
    bgMuted: isDark ? "#0E0E14" : "#F4F4F1",
    surface: isDark ? "#12121C" : "#FFFFFF",
    surfaceElev: isDark ? "#1A1A28" : "#FFFFFF",
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
        body { font-feature-settings: "ss01", "cv11"; }

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
        .nav-links {
          display: flex; gap: 32px;
          font-size: 14px; font-weight: 500;
        }
        .nav-links a {
          color: ${t.textMid};
          text-decoration: none;
          transition: color 0.2s;
        }
        .nav-links a:hover { color: ${t.text}; }
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
        .nav-cta {
          padding: 8px 16px;
          background: ${t.text};
          color: ${t.bg};
          border-radius: 8px;
          font-size: 14px; font-weight: 600;
          text-decoration: none;
          transition: opacity 0.2s;
        }
        .nav-cta:hover { opacity: 0.85; }

        /* HERO */
        .hero {
          max-width: 1200px; margin: 0 auto;
          padding: 80px 32px 60px;
          display: grid; grid-template-columns: 1.1fr 1fr;
          gap: 60px; align-items: center;
          position: relative;
        }
        @media (max-width: 900px) {
          .hero { grid-template-columns: 1fr; padding: 60px 24px 40px; gap: 40px; }
        }

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
          font-size: clamp(40px, 6vw, 68px);
          font-weight: 600;
          line-height: 0.98;
          letter-spacing: -2px;
          margin-bottom: 24px;
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
          font-size: 17px;
          line-height: 1.6;
          color: ${t.textMid};
          max-width: 520px;
          margin-bottom: 36px;
        }

        .hero-actions {
          display: flex; gap: 12px; flex-wrap: wrap;
          margin-bottom: 32px;
        }
        .btn-primary {
          display: inline-flex; align-items: center; gap: 8px;
          padding: 13px 22px;
          background: ${t.text};
          color: ${t.bg};
          border-radius: 10px;
          font-size: 15px; font-weight: 600;
          text-decoration: none;
          transition: transform 0.15s, box-shadow 0.15s;
          border: 1px solid ${t.text};
        }
        .btn-primary:hover {
          transform: translateY(-1px);
          box-shadow: 0 10px 30px ${isDark ? "rgba(255,255,255,0.1)" : "rgba(0,0,0,0.15)"};
        }
        .btn-secondary {
          display: inline-flex; align-items: center; gap: 8px;
          padding: 13px 22px;
          background: transparent;
          color: ${t.text};
          border: 1px solid ${t.borderStrong};
          border-radius: 10px;
          font-size: 15px; font-weight: 500;
          text-decoration: none;
          transition: all 0.15s;
        }
        .btn-secondary:hover { background: ${t.surface}; }

        .hero-meta {
          display: flex; gap: 24px; flex-wrap: wrap;
          font-family: 'JetBrains Mono', monospace;
          font-size: 12px;
          color: ${t.textDim};
        }
        .hero-meta span { display: flex; align-items: center; gap: 6px; }
        .hero-meta .check { color: ${t.accent2}; }

        /* HERO MOCKUP */
        .mockup {
          position: relative;
          border-radius: 16px;
          overflow: hidden;
          background: ${t.surface};
          border: 1px solid ${t.border};
          box-shadow: 0 30px 80px ${isDark ? "rgba(0,0,0,0.5)" : "rgba(10,10,15,0.1)"},
                      0 0 0 1px ${t.border};
        }
        .mockup::before {
          content: '';
          position: absolute;
          top: -40%; left: -20%;
          width: 140%; height: 80%;
          background: radial-gradient(circle, ${t.accentSoft} 0%, transparent 60%);
          pointer-events: none;
        }
        .mockup-bar {
          height: 36px;
          border-bottom: 1px solid ${t.border};
          padding: 0 14px;
          display: flex; align-items: center; gap: 8px;
          background: ${t.bgMuted};
        }
        .mockup-dot {
          width: 10px; height: 10px; border-radius: 50%;
          background: ${t.border};
        }
        .mockup-url {
          margin-left: 12px;
          font-family: 'JetBrains Mono', monospace;
          font-size: 11px;
          color: ${t.textDim};
        }
        .mockup-body { padding: 28px; }
        .mockup-q {
          font-family: 'JetBrains Mono', monospace;
          font-size: 10px;
          color: ${t.textDim};
          margin-bottom: 10px;
          letter-spacing: 1px;
        }
        .mockup-question {
          font-size: 17px; font-weight: 500;
          line-height: 1.5;
          margin-bottom: 20px;
          color: ${t.text};
        }
        .mockup-options { display: flex; flex-direction: column; gap: 8px; }
        .mockup-option {
          padding: 12px 16px;
          border: 1px solid ${t.border};
          border-radius: 10px;
          font-size: 14px;
          color: ${t.textMid};
          display: flex; align-items: center; gap: 12px;
          cursor: pointer;
          transition: all 0.15s;
          background: ${t.surface};
        }
        .mockup-option:hover { border-color: ${t.borderStrong}; color: ${t.text}; }
        .mockup-option.correct {
          border-color: #10B981;
          background: rgba(16,185,129,0.08);
          color: ${t.text};
        }
        .mockup-option .letter {
          font-family: 'JetBrains Mono', monospace;
          font-size: 11px;
          color: ${t.textDim};
          min-width: 16px;
        }
        .mockup-option.correct .letter { color: #10B981; }
        .mockup-progress {
          margin-top: 20px;
          padding-top: 20px;
          border-top: 1px solid ${t.border};
          display: flex; align-items: center; justify-content: space-between;
          font-family: 'JetBrains Mono', monospace;
          font-size: 11px;
          color: ${t.textDim};
        }
        .progress-bar {
          flex: 1;
          height: 4px;
          background: ${t.border};
          border-radius: 2px;
          margin: 0 16px;
          position: relative;
          overflow: hidden;
        }
        .progress-fill {
          position: absolute; inset: 0;
          background: linear-gradient(90deg, ${t.accent}, ${t.accent2});
          width: 67%;
          border-radius: 2px;
        }

        /* DIVIDER */
        .divider {
          max-width: 1200px;
          margin: 60px auto;
          padding: 0 32px;
        }
        .divider-inner {
          border-top: 1px solid ${t.border};
        }

        /* LOGOS STRIP */
        .logos-strip {
          max-width: 1200px; margin: 0 auto;
          padding: 20px 32px 60px;
          text-align: center;
        }
        .logos-label {
          font-family: 'JetBrains Mono', monospace;
          font-size: 11px;
          color: ${t.textDim};
          letter-spacing: 2px;
          margin-bottom: 28px;
          text-transform: uppercase;
        }
        .logos-row {
          display: flex; justify-content: center; align-items: center;
          gap: 48px; flex-wrap: wrap;
          font-size: 15px; font-weight: 600;
          color: ${t.textMid};
          letter-spacing: -0.5px;
          opacity: 0.8;
        }
        .logos-row span { transition: color 0.2s; cursor: default; }
        .logos-row span:hover { color: ${t.text}; }

        /* SECTION */
        .section {
          max-width: 1200px; margin: 0 auto;
          padding: 100px 32px;
        }
        .section-head {
          max-width: 700px;
          margin-bottom: 60px;
        }
        .section-label {
          font-family: 'JetBrains Mono', monospace;
          font-size: 11px;
          color: ${t.accent};
          letter-spacing: 2px;
          margin-bottom: 16px;
          text-transform: uppercase;
          display: flex; align-items: center; gap: 8px;
        }
        .section-label::before {
          content: ''; width: 16px; height: 1px;
          background: ${t.accent};
        }
        .section-title {
          font-size: clamp(32px, 4.5vw, 48px);
          font-weight: 600;
          letter-spacing: -1.5px;
          line-height: 1.05;
          margin-bottom: 20px;
          color: ${t.text};
        }
        .section-title em {
          font-family: 'Instrument Serif', serif;
          font-style: italic;
          font-weight: 400;
          color: ${t.accent};
        }
        .section-desc {
          font-size: 17px;
          line-height: 1.6;
          color: ${t.textMid};
          max-width: 600px;
        }

        /* FEATURE SHOWCASE */
        .showcase {
          display: grid;
          grid-template-columns: 340px 1fr;
          gap: 40px;
          border-top: 1px solid ${t.border};
          padding-top: 48px;
        }
        @media (max-width: 900px) {
          .showcase { grid-template-columns: 1fr; }
        }
        .showcase-tabs {
          display: flex; flex-direction: column;
          gap: 4px;
        }
        .showcase-tab {
          text-align: left;
          padding: 20px;
          border-radius: 12px;
          background: transparent;
          border: 1px solid transparent;
          cursor: pointer;
          transition: all 0.2s;
          position: relative;
        }
        .showcase-tab.active {
          background: ${t.surface};
          border-color: ${t.border};
        }
        .showcase-tab-num {
          font-family: 'JetBrains Mono', monospace;
          font-size: 10px;
          color: ${t.textDim};
          letter-spacing: 1px;
          margin-bottom: 6px;
        }
        .showcase-tab.active .showcase-tab-num { color: ${t.accent}; }
        .showcase-tab-title {
          font-size: 17px; font-weight: 600;
          color: ${t.textMid};
          margin-bottom: 6px;
          letter-spacing: -0.3px;
        }
        .showcase-tab.active .showcase-tab-title { color: ${t.text}; }
        .showcase-tab-desc {
          font-size: 13px;
          color: ${t.textDim};
          line-height: 1.5;
          display: none;
        }
        .showcase-tab.active .showcase-tab-desc { display: block; color: ${t.textMid}; }
        .showcase-panel {
          border-radius: 16px;
          border: 1px solid ${t.border};
          background: ${t.surface};
          overflow: hidden;
          min-height: 480px;
          position: relative;
        }
        .showcase-panel::before {
          content: '';
          position: absolute;
          top: -20%; right: -10%;
          width: 50%; height: 60%;
          background: radial-gradient(circle, ${t.accentSoft} 0%, transparent 70%);
          pointer-events: none;
        }

        /* Panel contents */
        .panel-header {
          padding: 16px 24px;
          border-bottom: 1px solid ${t.border};
          display: flex; justify-content: space-between; align-items: center;
          font-family: 'JetBrains Mono', monospace;
          font-size: 11px;
          color: ${t.textDim};
          background: ${t.bgMuted};
        }
        .panel-body { padding: 32px; }

        /* LERNPFAD-PANEL */
        .pfad-list { display: flex; flex-direction: column; gap: 8px; }
        .pfad-row {
          display: flex; align-items: center; gap: 14px;
          padding: 12px 14px;
          border: 1px solid ${t.border};
          border-radius: 10px;
          background: ${t.bg};
        }
        .pfad-num {
          width: 36px; height: 36px;
          flex-shrink: 0;
          border-radius: 8px;
          background: ${t.accentSoft};
          color: ${t.accent};
          font-family: 'JetBrains Mono', monospace;
          font-size: 12px; font-weight: 700;
          display: flex; align-items: center; justify-content: center;
        }
        .pfad-num.done { background: #10B98120; color: #10B981; }
        .pfad-num.locked { background: ${t.border}; color: ${t.textDim}; }
        .pfad-info { flex: 1; min-width: 0; }
        .pfad-title {
          font-size: 14px; font-weight: 600;
          color: ${t.text};
          margin-bottom: 2px;
          letter-spacing: -0.2px;
        }
        .pfad-meta {
          font-family: 'JetBrains Mono', monospace;
          font-size: 10px;
          color: ${t.textDim};
          letter-spacing: 1px;
        }
        .pfad-stars {
          display: flex; gap: 2px;
          font-size: 12px;
          color: ${t.textDim};
        }
        .pfad-stars .filled { color: #F59E0B; }

        /* Exam simulation panel */
        .exam-timer {
          display: flex; justify-content: space-between; align-items: center;
          margin-bottom: 24px;
          padding-bottom: 20px;
          border-bottom: 1px solid ${t.border};
        }
        .timer-main {
          font-family: 'JetBrains Mono', monospace;
          font-size: 28px; font-weight: 600;
          color: ${t.text};
          letter-spacing: -1px;
        }
        .timer-label {
          font-family: 'JetBrains Mono', monospace;
          font-size: 10px;
          color: ${t.textDim};
          letter-spacing: 1.5px;
          margin-bottom: 4px;
        }
        .q-nav {
          display: grid;
          grid-template-columns: repeat(10, 1fr);
          gap: 6px;
          margin-top: 24px;
        }
        .q-dot {
          aspect-ratio: 1;
          border-radius: 6px;
          border: 1px solid ${t.border};
          display: flex; align-items: center; justify-content: center;
          font-family: 'JetBrains Mono', monospace;
          font-size: 11px;
          font-weight: 500;
          color: ${t.textDim};
        }
        .q-dot.done {
          background: ${t.accent};
          border-color: ${t.accent};
          color: white;
        }
        .q-dot.current {
          background: ${t.surface};
          border-color: ${t.accent};
          color: ${t.accent};
        }
        .q-dot.flagged {
          border-color: #F59E0B;
          color: #F59E0B;
        }

        /* Stats panel */
        .stats-grid {
          display: grid;
          grid-template-columns: repeat(3, 1fr);
          gap: 16px;
          margin-bottom: 32px;
        }
        .stat-card {
          padding: 20px;
          border: 1px solid ${t.border};
          border-radius: 12px;
          background: ${t.bg};
        }
        .stat-value {
          font-family: 'Instrument Serif', serif;
          font-size: 38px;
          color: ${t.text};
          letter-spacing: -1px;
          line-height: 1;
          margin-bottom: 6px;
        }
        .stat-value em { color: ${t.accent}; font-style: italic; }
        .stat-label {
          font-family: 'JetBrains Mono', monospace;
          font-size: 10px;
          color: ${t.textDim};
          letter-spacing: 1.5px;
          text-transform: uppercase;
        }
        .chart-row {
          display: flex; align-items: flex-end;
          gap: 6px; height: 120px;
          padding: 20px;
          border: 1px solid ${t.border};
          border-radius: 12px;
          background: ${t.bg};
        }
        .chart-bar {
          flex: 1;
          background: linear-gradient(180deg, ${t.accent} 0%, ${t.accent2} 100%);
          border-radius: 4px 4px 0 0;
          opacity: 0.85;
          transition: opacity 0.2s;
        }
        .chart-bar:hover { opacity: 1; }

        /* ADA SECTION */
        .ada-section {
          background: ${t.bgMuted};
          border-top: 1px solid ${t.border};
          border-bottom: 1px solid ${t.border};
          padding: 100px 0;
        }
        .ada-inner {
          max-width: 1200px; margin: 0 auto;
          padding: 0 32px;
          display: grid;
          grid-template-columns: 1fr 1.1fr;
          gap: 60px;
          align-items: center;
        }
        @media (max-width: 900px) {
          .ada-inner { grid-template-columns: 1fr; }
        }
        .ada-quote {
          font-family: 'Instrument Serif', serif;
          font-style: italic;
          font-size: 22px;
          line-height: 1.5;
          color: ${t.textMid};
          padding: 24px;
          border-left: 2px solid ${t.accent};
          margin-top: 32px;
        }
        .ada-quote-by {
          font-family: 'JetBrains Mono', monospace;
          font-style: normal;
          font-size: 11px;
          color: ${t.textDim};
          letter-spacing: 1.5px;
          margin-top: 12px;
          text-transform: uppercase;
        }

        /* Chat widget */
        .ada-chat {
          background: ${t.surface};
          border: 1px solid ${t.border};
          border-radius: 16px;
          overflow: hidden;
          box-shadow: 0 20px 60px ${isDark ? "rgba(0,0,0,0.4)" : "rgba(10,10,15,0.08)"};
        }
        .ada-chat-head {
          padding: 16px 20px;
          border-bottom: 1px solid ${t.border};
          display: flex; align-items: center; gap: 12px;
          background: ${t.bgMuted};
        }
        .ada-avatar {
          width: 36px; height: 36px;
          border-radius: 10px;
          background: linear-gradient(135deg, ${t.accent} 0%, ${t.accent2} 100%);
          display: flex; align-items: center; justify-content: center;
          font-family: 'Instrument Serif', serif;
          font-style: italic;
          color: white;
          font-size: 18px;
          font-weight: 600;
        }
        .ada-head-info { flex: 1; }
        .ada-head-name {
          font-size: 14px; font-weight: 600;
          color: ${t.text};
        }
        .ada-head-status {
          font-family: 'JetBrains Mono', monospace;
          font-size: 10px;
          color: #10B981;
          display: flex; align-items: center; gap: 5px;
        }
        .ada-head-status::before {
          content: ''; width: 5px; height: 5px;
          border-radius: 50%;
          background: #10B981;
        }
        .ada-messages {
          padding: 20px;
          max-height: 420px;
          overflow-y: auto;
          display: flex; flex-direction: column;
          gap: 14px;
        }
        .ada-msg {
          display: flex; gap: 10px;
          max-width: 88%;
        }
        .ada-msg.user {
          align-self: flex-end;
          flex-direction: row-reverse;
        }
        .ada-msg-avatar {
          width: 28px; height: 28px;
          border-radius: 8px;
          flex-shrink: 0;
          font-family: 'JetBrains Mono', monospace;
          font-size: 11px;
          font-weight: 600;
          display: flex; align-items: center; justify-content: center;
        }
        .ada-msg.ada .ada-msg-avatar {
          background: linear-gradient(135deg, ${t.accent} 0%, ${t.accent2} 100%);
          color: white;
        }
        .ada-msg.user .ada-msg-avatar {
          background: ${t.border};
          color: ${t.textMid};
        }
        .ada-msg-bubble {
          padding: 10px 14px;
          border-radius: 12px;
          font-size: 14px;
          line-height: 1.5;
        }
        .ada-msg.ada .ada-msg-bubble {
          background: ${t.bgMuted};
          color: ${t.text};
          border: 1px solid ${t.border};
        }
        .ada-msg.user .ada-msg-bubble {
          background: ${t.accent};
          color: white;
        }
        .ada-msg-bubble strong { font-weight: 600; color: ${t.accent}; }
        .ada-msg.user .ada-msg-bubble strong { color: white; }

        .ada-input-row {
          padding: 14px;
          border-top: 1px solid ${t.border};
          display: flex; gap: 8px;
          background: ${t.bg};
        }
        .ada-input {
          flex: 1;
          padding: 10px 14px;
          border: 1px solid ${t.border};
          border-radius: 10px;
          background: ${t.surface};
          color: ${t.text};
          font-size: 14px;
          font-family: inherit;
          outline: none;
          transition: border-color 0.2s;
        }
        .ada-input:focus { border-color: ${t.accent}; }
        .ada-send {
          padding: 10px 16px;
          background: ${t.accent};
          color: white;
          border: none;
          border-radius: 10px;
          font-size: 14px; font-weight: 600;
          cursor: pointer;
          transition: opacity 0.2s;
        }
        .ada-send:hover { opacity: 0.9; }

        /* CERTS */
        .certs-grid {
          display: grid;
          grid-template-columns: repeat(4, 1fr);
          gap: 14px;
          margin-top: 48px;
        }
        @media (max-width: 900px) { .certs-grid { grid-template-columns: repeat(2, 1fr); } }
        @media (max-width: 500px) { .certs-grid { grid-template-columns: 1fr; } }
        .cert {
          padding: 22px;
          border: 1px solid ${t.border};
          border-radius: 12px;
          background: ${t.surface};
          transition: all 0.2s;
        }
        .cert:hover {
          border-color: ${t.borderStrong};
          transform: translateY(-2px);
        }
        .cert-tag {
          font-family: 'JetBrains Mono', monospace;
          font-size: 10px;
          color: ${t.textDim};
          letter-spacing: 1.5px;
          margin-bottom: 12px;
          font-weight: 600;
        }
        .cert-name {
          font-size: 16px; font-weight: 600;
          color: ${t.text};
          letter-spacing: -0.3px;
          margin-bottom: 6px;
        }
        .cert-meta {
          font-size: 13px;
          color: ${t.textMid};
          line-height: 1.5;
        }

        /* MODES */
        .modes-wrap {
          margin-top: 80px;
          padding-top: 60px;
          border-top: 1px solid ${t.border};
        }
        .modes-head { margin-bottom: 32px; }
        .modes-title {
          font-size: clamp(24px, 3.5vw, 36px);
          font-weight: 600;
          letter-spacing: -1px;
          line-height: 1.1;
          color: ${t.text};
        }
        .modes-title em {
          font-family: 'Instrument Serif', serif;
          font-style: italic;
          font-weight: 400;
          color: ${t.accent};
        }
        .modes-grid {
          display: grid;
          grid-template-columns: 1fr 1fr;
          gap: 16px;
          margin-bottom: 24px;
        }
        @media (max-width: 700px) { .modes-grid { grid-template-columns: 1fr; } }
        .mode-card {
          padding: 28px;
          border: 1px solid ${t.border};
          border-radius: 14px;
          background: ${t.surface};
          transition: all 0.2s;
        }
        .mode-card.featured {
          background: linear-gradient(180deg, ${t.accentSoft} 0%, ${t.surface} 40%);
          border-color: ${t.accent}40;
        }
        .mode-head {
          display: flex; align-items: center; gap: 14px;
          margin-bottom: 20px;
          padding-bottom: 20px;
          border-bottom: 1px solid ${t.border};
        }
        .mode-icon {
          width: 44px; height: 44px;
          border-radius: 10px;
          display: flex; align-items: center; justify-content: center;
          font-size: 18px;
          flex-shrink: 0;
        }
        .mode-name {
          font-size: 17px; font-weight: 600;
          color: ${t.text};
          letter-spacing: -0.3px;
          margin-bottom: 2px;
        }
        .mode-sub {
          font-family: 'JetBrains Mono', monospace;
          font-size: 11px;
          color: ${t.textDim};
          letter-spacing: 1px;
        }
        .mode-list {
          list-style: none;
          display: flex; flex-direction: column;
          gap: 10px;
        }
        .mode-list li {
          font-size: 14px;
          color: ${t.textMid};
          display: flex; align-items: flex-start; gap: 10px;
          line-height: 1.5;
        }
        .mode-list li::before {
          content: '→';
          color: ${t.accent};
          font-weight: 600;
          flex-shrink: 0;
        }
        .mode-tip {
          padding: 16px 20px;
          border: 1px solid ${t.border};
          border-radius: 10px;
          background: ${t.bgMuted};
          display: flex; align-items: center; gap: 16px;
          flex-wrap: wrap;
        }
        .mode-tip-label {
          font-family: 'JetBrains Mono', monospace;
          font-size: 10px;
          color: ${t.accent};
          letter-spacing: 1.5px;
          text-transform: uppercase;
          padding: 4px 10px;
          border: 1px solid ${t.accent}40;
          border-radius: 4px;
          background: ${t.accentSoft};
          flex-shrink: 0;
        }
        .mode-tip-text {
          font-size: 14px;
          color: ${t.textMid};
          line-height: 1.5;
        }

        /* PRICING */
        .pricing-grid {
          display: grid;
          grid-template-columns: 1fr 1fr 1fr;
          gap: 20px;
          max-width: 1100px;
          margin: 60px auto 0;
        }
        @media (max-width: 900px) { .pricing-grid { grid-template-columns: 1fr; } }
        .plan {
          padding: 36px;
          border: 1px solid ${t.border};
          border-radius: 18px;
          background: ${t.surface};
          position: relative;
        }
        .plan.pro {
          border-color: ${t.accent};
          background: linear-gradient(180deg, ${t.accentSoft} 0%, ${t.surface} 30%);
        }
        .plan.lifetime {
          border-color: ${t.accent2};
        }
        .plan-badge {
          position: absolute;
          top: -11px; left: 36px;
          font-family: 'JetBrains Mono', monospace;
          font-size: 10px;
          letter-spacing: 1.5px;
          padding: 4px 10px;
          background: ${t.accent};
          color: white;
          border-radius: 100px;
          text-transform: uppercase;
        }
        .plan.lifetime .plan-badge {
          background: ${t.accent2};
          color: ${t.bg};
        }
        .plan-name {
          font-family: 'Instrument Serif', serif;
          font-style: italic;
          font-size: 28px;
          color: ${t.text};
          margin-bottom: 4px;
        }
        .plan-tag {
          font-family: 'JetBrains Mono', monospace;
          font-size: 11px;
          color: ${t.textDim};
          letter-spacing: 1.5px;
          margin-bottom: 24px;
          text-transform: uppercase;
        }
        .plan-price {
          display: flex; align-items: baseline; gap: 6px;
          margin-bottom: 4px;
        }
        .plan-amount {
          font-size: 46px; font-weight: 600;
          color: ${t.text};
          letter-spacing: -2px;
          line-height: 1;
        }
        .plan-period {
          font-size: 14px;
          color: ${t.textMid};
        }
        .plan-note {
          font-size: 12px;
          color: ${t.textDim};
          margin-bottom: 28px;
        }
        .plan-cta {
          display: block; text-align: center;
          padding: 12px;
          border-radius: 10px;
          font-size: 14px; font-weight: 600;
          text-decoration: none;
          margin-bottom: 28px;
          transition: all 0.2s;
        }
        .plan-cta.primary {
          background: ${t.text};
          color: ${t.bg};
        }
        .plan-cta.primary:hover { opacity: 0.85; }
        .plan-cta.outline {
          border: 1px solid ${t.borderStrong};
          color: ${t.text};
        }
        .plan-cta.outline:hover { background: ${t.bgMuted}; }
        .plan-features {
          list-style: none;
          display: flex; flex-direction: column;
          gap: 10px;
          padding-top: 24px;
          border-top: 1px solid ${t.border};
        }
        .plan-feature {
          font-size: 14px;
          color: ${t.textMid};
          display: flex; align-items: flex-start; gap: 10px;
          line-height: 1.5;
        }
        .plan-feature::before {
          content: '✓';
          color: ${t.accent};
          font-weight: 700;
          flex-shrink: 0;
        }
        .plan-feature.off { color: ${t.textDim}; }
        .plan-feature.off::before { content: '×'; color: ${t.textDim}; }

        /* FINAL CTA */
        .final-cta {
          max-width: 900px;
          margin: 0 auto;
          padding: 80px 32px 100px;
          text-align: center;
          position: relative;
        }
        .final-cta-glow {
          position: absolute;
          top: 20%; left: 50%;
          transform: translateX(-50%);
          width: 600px; height: 300px;
          background: radial-gradient(ellipse, ${t.accentSoft} 0%, transparent 60%);
          pointer-events: none;
          z-index: 0;
        }
        .final-cta-inner { position: relative; z-index: 1; }
        .final-cta-title {
          font-size: clamp(36px, 5vw, 56px);
          font-weight: 600;
          letter-spacing: -2px;
          line-height: 1.05;
          margin-bottom: 20px;
        }
        .final-cta-title em {
          font-family: 'Instrument Serif', serif;
          font-style: italic;
          font-weight: 400;
          color: ${t.accent};
        }
        .final-cta-sub {
          font-size: 17px;
          color: ${t.textMid};
          max-width: 540px;
          margin: 0 auto 32px;
          line-height: 1.6;
        }

        /* FOOTER */
        .footer {
          border-top: 1px solid ${t.border};
          background: ${t.bg};
          padding: 60px 0 40px;
        }
        .footer-inner {
          max-width: 1200px;
          margin: 0 auto;
          padding: 0 32px;
          display: grid;
          grid-template-columns: 1.5fr 1fr 1fr 1fr;
          gap: 40px;
          margin-bottom: 48px;
        }
        @media (max-width: 700px) { .footer-inner { grid-template-columns: 1fr 1fr; } }
        .footer-brand .logo { margin-bottom: 14px; }
        .footer-tagline {
          font-size: 13px;
          color: ${t.textMid};
          line-height: 1.6;
          max-width: 240px;
        }
        .footer-col h4 {
          font-family: 'JetBrains Mono', monospace;
          font-size: 10px;
          color: ${t.textDim};
          letter-spacing: 1.5px;
          margin-bottom: 16px;
          text-transform: uppercase;
          font-weight: 500;
        }
        .footer-col ul { list-style: none; display: flex; flex-direction: column; gap: 10px; }
        .footer-col a {
          font-size: 13px;
          color: ${t.textMid};
          text-decoration: none;
          transition: color 0.2s;
        }
        .footer-col a:hover { color: ${t.text}; }
        .footer-bottom {
          max-width: 1200px;
          margin: 0 auto;
          padding: 24px 32px 0;
          border-top: 1px solid ${t.border};
          display: flex;
          justify-content: space-between;
          align-items: center;
          flex-wrap: wrap;
          gap: 12px;
        }
        .footer-copy {
          font-family: 'JetBrains Mono', monospace;
          font-size: 11px;
          color: ${t.textDim};
        }
        .footer-mini {
          display: flex; gap: 20px;
          font-family: 'JetBrains Mono', monospace;
          font-size: 11px;
          color: ${t.textDim};
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
          <div className="nav-links" style={{ display: "flex" }}>
            <a href="#product">Produkt</a>
            <a href="#ada">Ada</a>
            <a href="#pricing">Preise</a>
            <Link href="/pruefungen">Prüfungen</Link>
          </div>
          <div className="nav-actions">
            <button
              className="theme-btn"
              onClick={() => setIsDark(!isDark)}
              aria-label="Theme wechseln"
            >
              {isDark ? "☀" : "☾"}
            </button>
            <Link href="/login" style={{ color: t.textMid, fontSize: 14, textDecoration: "none", fontWeight: 500 }}>
              Login
            </Link>
            <Link href="/register" className="nav-cta">
              Starten
            </Link>
          </div>
        </div>
      </nav>

      {/* HERO */}
      <section className="hero">
        <div>
          <div className="eyebrow">
            <span className="eyebrow-dot" />
            Live · AP1 & AP2 · 937 Fragen · 3 Lernpfade
          </div>
          <h1 className="hero-title">
            Prüfungsangst war<br />
            gestern — heute <em>übst du smart.</em>
          </h1>
          <p className="hero-sub">
            Lernarena ist die Prüfungsvorbereitung für Fachinformatiker. Strukturierte
            Lernpfade Schritt für Schritt, echte IHK-Simulation, und ein KI-Tutor
            der erklärt statt vorbetet.
          </p>
          <div className="hero-actions">
            <Link href="/register" className="btn-primary">
              Kostenlos starten →
            </Link>
            <a href="#product" className="btn-secondary">
              Produkt ansehen
            </a>
          </div>
          <div className="hero-meta">
            <span><span className="check">✓</span> Keine Kreditkarte</span>
            <span><span className="check">✓</span> Free-Tier dauerhaft</span>
            <span><span className="check">✓</span> Web & Mobile</span>
          </div>
        </div>

        {/* Mockup */}
        <div className="mockup">
          <div className="mockup-bar">
            <div className="mockup-dot" />
            <div className="mockup-dot" />
            <div className="mockup-dot" />
            <div className="mockup-url">lernarena.app/exam/ap2-ae</div>
          </div>
          <div className="mockup-body">
            <div className="mockup-q">FRAGE 14 / 21 · IT-SICHERHEIT</div>
            <div className="mockup-question">
              Welches Verfahren verhindert eine Wiedereinspielung
              abgefangener Datenpakete (Replay-Attacke)?
            </div>
            <div className="mockup-options">
              <div className="mockup-option">
                <span className="letter">A</span>
                Symmetrische Verschlüsselung mit AES
              </div>
              <div className="mockup-option correct">
                <span className="letter">B</span>
                Verwendung von Nonces oder Zeitstempeln
              </div>
              <div className="mockup-option">
                <span className="letter">C</span>
                Längere Schlüssel (&gt; 2048 Bit)
              </div>
              <div className="mockup-option">
                <span className="letter">D</span>
                Doppelte Signaturprüfung
              </div>
            </div>
            <div className="mockup-progress">
              <span>14/21</span>
              <div className="progress-bar">
                <div className="progress-fill" />
              </div>
              <span>58:24</span>
            </div>
          </div>
        </div>
      </section>

      {/* LOGOS */}
      <div className="logos-strip">
        <div className="logos-label">gebaut für reale Prüfungen</div>
        <div className="logos-row">
          <span>Fachinformatiker AE</span>
          <span>·</span>
          <span>Fachinformatiker SI</span>
          <span>·</span>
          <span>AWS</span>
          <span>·</span>
          <span>Azure</span>
          <span>·</span>
          <span>GCP</span>
          <span>·</span>
          <span>SAP</span>
        </div>
      </div>

      {/* PRODUCT SHOWCASE */}
      <section className="section" id="product">
        <div className="section-head">
          <div className="section-label">Produkt</div>
          <h2 className="section-title">
            Drei Werkzeuge. <em>Eine Prüfung.</em>
          </h2>
          <p className="section-desc">
            Keine aufgeblähte Feature-Liste — nur die drei Dinge, die in der
            Prüfung wirklich den Unterschied machen.
          </p>
        </div>

        <div className="showcase">
          <div className="showcase-tabs">
            {[
              {
                num: "01",
                title: "Strukturierte Lernpfade",
                desc: "Mimo-Style. Konzept-für-Konzept aufbauend. Kein Frage-Brainstorming.",
              },
              {
                num: "02",
                title: "Echte Prüfungssimulation",
                desc: "Timer, Fragenübersicht, Flagging — so wie am Prüfungstag.",
              },
              {
                num: "03",
                title: "Fortschritts-Tracking",
                desc: "Modul-Quoten, Schwachstellen, ELO-Rang. Datengetrieben.",
              },
            ].map((tab, i) => (
              <button
                key={i}
                className={`showcase-tab ${activeDemo === i ? "active" : ""}`}
                onClick={() => setActiveDemo(i)}
              >
                <div className="showcase-tab-num">{tab.num}</div>
                <div className="showcase-tab-title">{tab.title}</div>
                <div className="showcase-tab-desc">{tab.desc}</div>
              </button>
            ))}
          </div>

          <div className="showcase-panel">
            {activeDemo === 0 && (
              <>
                <div className="panel-header">
                  <span>NETZWERKE & SUBNETTING · 11 LEVELS</span>
                  <span>BASICS</span>
                </div>
                <div className="panel-body">
                  <div className="pfad-list">
                    <div className="pfad-row">
                      <div className="pfad-num done">01</div>
                      <div className="pfad-info">
                        <div className="pfad-title">Was ist ein Netzwerk?</div>
                        <div className="pfad-meta">5 FRAGEN · BASICS</div>
                      </div>
                      <div className="pfad-stars">
                        <span className="filled">★</span>
                        <span className="filled">★</span>
                        <span className="filled">★</span>
                      </div>
                    </div>
                    <div className="pfad-row">
                      <div className="pfad-num done">02</div>
                      <div className="pfad-info">
                        <div className="pfad-title">IP-Adressen</div>
                        <div className="pfad-meta">5 FRAGEN · BASICS</div>
                      </div>
                      <div className="pfad-stars">
                        <span className="filled">★</span>
                        <span className="filled">★</span>
                        <span className="filled">★</span>
                      </div>
                    </div>
                    <div className="pfad-row">
                      <div className="pfad-num done">03</div>
                      <div className="pfad-info">
                        <div className="pfad-title">Subnetzmaske &amp; CIDR</div>
                        <div className="pfad-meta">5 FRAGEN · BASICS</div>
                      </div>
                      <div className="pfad-stars">
                        <span className="filled">★</span>
                        <span className="filled">★</span>
                        <span>★</span>
                      </div>
                    </div>
                    <div className="pfad-row" style={{ background: t.accentSoft, borderColor: `${t.accent}50` }}>
                      <div className="pfad-num">04</div>
                      <div className="pfad-info">
                        <div className="pfad-title">Private vs. öffentliche IPs</div>
                        <div className="pfad-meta">4 FRAGEN · BASICS · AKTUELL</div>
                      </div>
                      <div className="pfad-stars">
                        <span>★</span>
                        <span>★</span>
                        <span>★</span>
                      </div>
                    </div>
                    <div className="pfad-row">
                      <div className="pfad-num locked">🔒</div>
                      <div className="pfad-info">
                        <div className="pfad-title">Subnetting Teil 1</div>
                        <div className="pfad-meta">8 FRAGEN · PRAXIS · PREMIUM</div>
                      </div>
                    </div>
                    <div className="pfad-row">
                      <div className="pfad-num locked">🔒</div>
                      <div className="pfad-info">
                        <div className="pfad-title">Subnetting Teil 2</div>
                        <div className="pfad-meta">7 FRAGEN · PRAXIS · PREMIUM</div>
                      </div>
                    </div>
                  </div>
                </div>
              </>
            )}
            {activeDemo === 1 && (
              <>
                <div className="panel-header">
                  <span>AP2 · ANWENDUNGSENTWICKLUNG · FRÜHJAHR 2024</span>
                  <span>LIVE</span>
                </div>
                <div className="panel-body">
                  <div className="exam-timer">
                    <div>
                      <div className="timer-label">VERBLEIBEND</div>
                      <div className="timer-main">01:42:18</div>
                    </div>
                    <div style={{ textAlign: "right" }}>
                      <div className="timer-label">BEANTWORTET</div>
                      <div className="timer-main">34/50</div>
                    </div>
                  </div>
                  <div style={{ fontSize: 13, color: t.textDim, fontFamily: "'JetBrains Mono', monospace", marginBottom: 8 }}>
                    FRAGENÜBERSICHT
                  </div>
                  <div className="q-nav">
                    {Array.from({ length: 50 }).map((_, i) => {
                      const state = i < 34 ? "done" : i === 34 ? "current" : i === 38 || i === 42 ? "flagged" : "";
                      return (
                        <div key={i} className={`q-dot ${state}`}>
                          {i + 1}
                        </div>
                      );
                    })}
                  </div>
                </div>
              </>
            )}
            {activeDemo === 2 && (
              <>
                <div className="panel-header">
                  <span>STATISTIK · LETZTE 30 TAGE</span>
                  <span>↑ 12%</span>
                </div>
                <div className="panel-body">
                  <div className="stats-grid">
                    <div className="stat-card">
                      <div className="stat-value">
                        <em>84</em>%
                      </div>
                      <div className="stat-label">Trefferquote</div>
                    </div>
                    <div className="stat-card">
                      <div className="stat-value">412</div>
                      <div className="stat-label">Fragen gelöst</div>
                    </div>
                    <div className="stat-card">
                      <div className="stat-value">
                        <em>18</em>
                      </div>
                      <div className="stat-label">Tage Streak</div>
                    </div>
                  </div>
                  <div className="chart-row">
                    {[40, 55, 48, 62, 70, 58, 75, 68, 80, 72, 85, 78, 88, 84].map((h, i) => (
                      <div key={i} className="chart-bar" style={{ height: `${h}%` }} />
                    ))}
                  </div>
                  <div style={{ display: "flex", justifyContent: "space-between", marginTop: 12, fontSize: 11, color: t.textDim, fontFamily: "'JetBrains Mono', monospace" }}>
                    <span>VOR 30 T.</span>
                    <span>HEUTE</span>
                  </div>
                </div>
              </>
            )}
          </div>
        </div>
      </section>

      {/* ADA SECTION */}
      <section className="ada-section" id="ada">
        <div className="ada-inner">
          <div>
            <div className="section-label">Der KI-Tutor</div>
            <h2 className="section-title">
              Ada versteht, <em>was du nicht verstehst.</em>
            </h2>
            <p className="section-desc">
              Benannt nach Ada Lovelace. Ein Sprachmodell mit Prüfungswissen,
              das auf deinem Level antwortet — und nachfragt, wenn du eine
              falsche Annahme triffst. Direkt verfügbar in jedem Level, jeder
              Frage und jedem Match.
            </p>
            <div className="ada-quote">
              &ldquo;The more I study, the more insatiable do I feel my
              genius for it to be.&rdquo;
              <div className="ada-quote-by">— Ada Lovelace, 1843</div>
            </div>
          </div>

          <div className="ada-chat">
            <div className="ada-chat-head">
              <div className="ada-avatar">A</div>
              <div className="ada-head-info">
                <div className="ada-head-name">Ada</div>
                <div className="ada-head-status">online · antwortet sofort</div>
              </div>
            </div>
            <div className="ada-messages">
              {adaMessages.map((m, i) => (
                <div key={i} className={`ada-msg ${m.role}`}>
                  <div className="ada-msg-avatar">
                    {m.role === "ada" ? "A" : "Du"}
                  </div>
                  <div
                    className="ada-msg-bubble"
                    dangerouslySetInnerHTML={{
                      __html: m.text.replace(
                        /\*\*(.*?)\*\*/g,
                        "<strong>$1</strong>"
                      ),
                    }}
                  />
                </div>
              ))}
            </div>
            <form className="ada-input-row" onSubmit={handleAdaSubmit}>
              <input
                type="text"
                className="ada-input"
                placeholder="Frag Ada etwas…"
                value={adaInput}
                onChange={(e) => setAdaInput(e.target.value)}
              />
              <button type="submit" className="ada-send">
                Senden
              </button>
            </form>
          </div>
        </div>
      </section>

      {/* CERTIFICATES */}
      <section className="section">
        <div className="section-head">
          <div className="section-label">Zertifikate</div>
          <h2 className="section-title">
            IHK geschafft. <em>Was kommt danach?</em>
          </h2>
          <p className="section-desc">
            Vier Cloud-Zertifizierungen — in zwei Modi: erst in Ruhe verstehen,
            dann unter Prüfungsbedingungen testen.
          </p>
        </div>

        <div className="certs-grid">
          {[
            {
              tag: "AWS",
              name: "Cloud Practitioner",
              meta: "Grundlagen der Amazon Web Services Cloud",
              color: "#FF9900",
            },
            {
              tag: "AZURE",
              name: "Fundamentals",
              meta: "AZ-900 · Cloud-Konzepte und Azure-Services",
              color: "#0078D4",
            },
            {
              tag: "GCP",
              name: "Digital Leader",
              meta: "Grundlegendes Verständnis von Google Cloud",
              color: "#4285F4",
            },
            {
              tag: "SAP",
              name: "Certified Associate",
              meta: "SAP-Grundlagen und Geschäftsprozesse",
              color: "#0070F2",
            },
          ].map((c, i) => (
            <div key={i} className="cert" style={{ borderTop: `2px solid ${c.color}` }}>
              <div
                className="cert-tag"
                style={{ color: c.color, letterSpacing: 1.5 }}
              >
                {c.tag}
              </div>
              <div className="cert-name">{c.name}</div>
              <div className="cert-meta">{c.meta}</div>
            </div>
          ))}
        </div>

        {/* LERNMODI */}
        <div className="modes-wrap">
          <div className="modes-head">
            <div className="section-label" style={{ marginBottom: 10 }}>
              Lernformate
            </div>
            <h3 className="modes-title">
              Vier Wege, <em>ein Ziel.</em>
            </h3>
          </div>
          <div className="modes-grid">
            <div className="mode-card featured">
              <div className="mode-head">
                <div className="mode-icon" style={{ background: t.accent, color: "white" }}>
                  ↗
                </div>
                <div>
                  <div className="mode-name">Lernpfade</div>
                  <div className="mode-sub">Schritt für Schritt</div>
                </div>
              </div>
              <ul className="mode-list">
                <li>3 Pfade: SQL · Netzwerke · IT-Sicherheit</li>
                <li>33 Levels mit Lehr-Karten und Beispielen</li>
                <li>Ideal um Themen aufbauend zu lernen</li>
              </ul>
            </div>

            <div className="mode-card">
              <div className="mode-head">
                <div className="mode-icon" style={{ background: t.accentSoft, color: t.accent }}>
                  ✎
                </div>
                <div>
                  <div className="mode-name">Klassische Module</div>
                  <div className="mode-sub">Frei nach Thema</div>
                </div>
              </div>
              <ul className="mode-list">
                <li>17 Module · alle Prüfungsbereiche</li>
                <li>Erklärungen zu jeder Antwort</li>
                <li>Kein Zeitdruck — Gold zum Lernen</li>
              </ul>
            </div>

            <div className="mode-card">
              <div className="mode-head">
                <div className="mode-icon" style={{ background: t.accentSoft, color: t.accent }}>
                  ⏱
                </div>
                <div>
                  <div className="mode-name">Prüfungssimulation</div>
                  <div className="mode-sub">Echte Bedingungen</div>
                </div>
              </div>
              <ul className="mode-list">
                <li>Timer wie in der echten Prüfung</li>
                <li>Original IHK-Aufgaben (AE & SI)</li>
                <li>Scored & bewertet</li>
              </ul>
            </div>

            <div className="mode-card">
              <div className="mode-head">
                <div className="mode-icon" style={{ background: t.accentSoft, color: t.accent }}>
                  ⚔
                </div>
                <div>
                  <div className="mode-name">Async-Match</div>
                  <div className="mode-sub">1v1 Multiplayer</div>
                </div>
              </div>
              <ul className="mode-list">
                <li>Duelliere dich mit anderen Lernern</li>
                <li>ELO-Rangliste &amp; Badges</li>
                <li>Üben mit Spaß-Faktor</li>
              </ul>
            </div>
          </div>

          <div className="mode-tip">
            <span className="mode-tip-label">Tipp</span>
            <span className="mode-tip-text">
              Starte mit den Lernpfaden um die Konzepte zu verstehen, festige im
              Match-Modus und teste dich am Ende mit der Prüfungssimulation.
            </span>
          </div>
        </div>
      </section>

      {/* PRICING */}
      <section className="section" id="pricing">
        <div className="section-head">
          <div className="section-label">Preise</div>
          <h2 className="section-title">
            Fair. Transparent. <em>Kein Kleingedrucktes.</em>
          </h2>
          <p className="section-desc">
            Kostenlos anfangen. Upgraden, wenn&apos;s ernst wird. Lifetime
            kaufen, wenn du dich nicht festlegen willst.
          </p>
        </div>

        <div className="pricing-grid">
          <div className="plan">
            <div className="plan-name">Free</div>
            <div className="plan-tag">Für Einsteiger</div>
            <div className="plan-price">
              <span className="plan-amount">0€</span>
              <span className="plan-period">/ für immer</span>
            </div>
            <div className="plan-note">Keine Kreditkarte erforderlich</div>
            <Link href="/register" className="plan-cta outline">
              Kostenlos starten
            </Link>
            <ul className="plan-features">
              <li className="plan-feature">Basics-Levels aller Lernpfade</li>
              <li className="plan-feature">3 Async-Matches pro Tag</li>
              <li className="plan-feature">Ada-Erklärungen bei Fehlern</li>
              <li className="plan-feature off">Praxis &amp; Prüfungs-Levels</li>
              <li className="plan-feature off">Prüfungssimulation</li>
              <li className="plan-feature off">Cloud-Zertifikate</li>
            </ul>
          </div>

          <div className="plan pro">
            <div className="plan-badge">Empfohlen</div>
            <div className="plan-name">Premium</div>
            <div className="plan-tag">Für Prüflinge</div>
            <div className="plan-price">
              <span className="plan-amount">9,99€</span>
              <span className="plan-period">/ Monat</span>
            </div>
            <div className="plan-note">Oder 59€/Jahr · 50% sparen</div>
            <Link href="/register?plan=premium" className="plan-cta primary">
              Premium starten
            </Link>
            <ul className="plan-features">
              <li className="plan-feature">Alle 937 Prüfungsfragen</li>
              <li className="plan-feature">Alle 33 Levels (Basics, Praxis, Prüfung)</li>
              <li className="plan-feature">Echte IHK-Prüfungssimulation</li>
              <li className="plan-feature">Alle 4 Cloud-Zertifikate</li>
              <li className="plan-feature">Unbegrenzt Ada &amp; Matches</li>
              <li className="plan-feature">Jederzeit kündbar</li>
            </ul>
          </div>

          <div className="plan lifetime">
            <div className="plan-badge">Best Value</div>
            <div className="plan-name">Lifetime</div>
            <div className="plan-tag">Für Sammler</div>
            <div className="plan-price">
              <span className="plan-amount">99€</span>
              <span className="plan-period">/ einmalig</span>
            </div>
            <div className="plan-note">Einmal zahlen, für immer nutzen</div>
            <Link href="/register?plan=lifetime" className="plan-cta outline">
              Lifetime kaufen
            </Link>
            <ul className="plan-features">
              <li className="plan-feature">Alles aus Premium</li>
              <li className="plan-feature">Auch alle zukünftigen Lernpfade</li>
              <li className="plan-feature">Alle zukünftigen Features</li>
              <li className="plan-feature">Keine Verlängerungen</li>
              <li className="plan-feature">Bezahlt nach 10 Monaten</li>
              <li className="plan-feature">Beste Wahl ab AP1+AP2</li>
            </ul>
          </div>
        </div>
      </section>

      {/* FINAL CTA */}
      <section className="final-cta">
        <div className="final-cta-glow" />
        <div className="final-cta-inner">
          <div className="section-label" style={{ justifyContent: "center", display: "inline-flex" }}>
            Los geht&apos;s
          </div>
          <h2 className="final-cta-title">
            Bestehen ist<br />
            kein <em>Zufall.</em>
          </h2>
          <p className="final-cta-sub">
            Sondern das Ergebnis von gezielter Vorbereitung. 937 Fragen, drei
            Lernpfade, ein Tutor der erklärt, ein System das dich nicht vergessen lässt.
          </p>
          <div className="hero-actions" style={{ justifyContent: "center", marginBottom: 0 }}>
            <Link href="/register" className="btn-primary">
              Kostenlos registrieren →
            </Link>
            <a href="#pricing" className="btn-secondary">
              Preise ansehen
            </a>
          </div>
        </div>
      </section>

      {/* FOOTER */}
      <footer className="footer">
        <div className="footer-inner">
          <div className="footer-brand">
            <Link href="/" className="logo">
              <span className="logo-dot" />
              Lernarena
            </Link>
            <p className="footer-tagline">
              Die intelligente Prüfungsvorbereitung für Fachinformatiker und
              IT-Professionals.
            </p>
          </div>
          <div className="footer-col">
            <h4>Produkt</h4>
            <ul>
              <li><a href="#product">Features</a></li>
              <li><a href="#pricing">Preise</a></li>
              <li><Link href="/pruefungen">Prüfungen</Link></li>
              <li><a href="#ada">Ada KI-Tutor</a></li>
            </ul>
          </div>
          <div className="footer-col">
            <h4>Ressourcen</h4>
            <ul>
              <li><Link href="/login">Login</Link></li>
              <li><Link href="/register">Registrieren</Link></li>
              <li><a href="mailto:hallo@lernarena.app">Kontakt</a></li>
            </ul>
          </div>
          <div className="footer-col">
            <h4>Legal</h4>
            <ul>
              <li><Link href="/impressum">Impressum</Link></li>
              <li><Link href="/datenschutz">Datenschutz</Link></li>
              <li><Link href="/agb">AGB</Link></li>
            </ul>
          </div>
        </div>
        <div className="footer-bottom">
          <div className="footer-copy">
            © {new Date().getFullYear()} LERNARENA · ALLE RECHTE VORBEHALTEN
          </div>
          <div className="footer-mini">
            <span>v0.8.2</span>
            <span>·</span>
            <span>STATUS: OPERATIONAL</span>
          </div>
        </div>
      </footer>
    </div>
  );
}