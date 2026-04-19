"use client";

import { useState, useEffect, useRef } from "react";
import Link from "next/link";

export default function LandingPage() {
  const [email, setEmail] = useState("");
  const [isDark, setIsDark] = useState(false);
  const [scrollY, setScrollY] = useState(0);
  const [visibleSections, setVisibleSections] = useState<Set<string>>(new Set());

  useEffect(() => {
    const handleScroll = () => setScrollY(window.scrollY);
    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  useEffect(() => {
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            setVisibleSections((prev) => new Set([...prev, entry.target.id]));
          }
        });
      },
      { threshold: 0.1 }
    );
    document.querySelectorAll("[data-animate]").forEach((el) => observer.observe(el));
    return () => observer.disconnect();
  }, []);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    alert(`Danke! Wir melden uns bei ${email}`);
  };

  const theme = {
    bg: isDark ? "#050510" : "#FFFFFF",
    color: isDark ? "#fff" : "#0F0F0F",
    surface: isDark ? "#0D0D1A" : "#FFFFFF",
    surface2: isDark ? "#12122A" : "#4F46E5",
    border: isDark ? "rgba(255,255,255,0.08)" : "rgba(79,70,229,0.15)",
    textDim: isDark ? "rgba(255,255,255,0.45)" : "#9CA3AF",
    textMid: isDark ? "rgba(255,255,255,0.7)" : "#6B7280",
    navBg: isDark ? "rgba(5,5,16,0.85)" : "rgba(255,255,255,0.95)",
    heroBg: isDark ? "#050510" : "#FFFFFF",
    statsBg: isDark ? "#0D0D1A" : "#4F46E5",
    certsBg: isDark ? "#0D0D1A" : "#4F46E5",
    pricingBg: isDark ? "#050510" : "#FFFFFF",
    ctaBg: isDark ? "#0D0D1A" : "#4F46E5",
    footerBg: isDark ? "#050510" : "#0F0F1A",
  };

  return (
    <div style={{ fontFamily: "'Plus Jakarta Sans', sans-serif", background: theme.bg, color: theme.color, overflowX: "hidden", transition: "background 0.3s, color 0.3s" }}>
      <style>{`
        @import url('https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800;900&family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap');

        * { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
          --indigo: #4F46E5;
          --indigo-dark: #3730A3;
          --indigo-light: #6366F1;
          --indigo-glow: rgba(79,70,229,0.4);
          --surface: ${theme.surface};
          --surface-2: ${theme.surface2};
          --border: ${theme.border};
          --text-dim: ${theme.textDim};
          --text-mid: ${theme.textMid};
        }

        html { scroll-behavior: smooth; }

        /* NAV */
        nav {
          position: fixed; top: 0; left: 0; right: 0; z-index: 100;
          padding: 20px 40px;
          display: flex; align-items: center; justify-content: space-between;
          transition: all 0.4s ease;
        }
        nav.scrolled {
          background: ${theme.navBg};
          backdrop-filter: blur(20px);
          border-bottom: 1px solid var(--border);
          padding: 14px 40px;
        }
        .nav-logo {
          font-family: 'Nunito', sans-serif;
          font-size: 20px; font-weight: 800;
          background: linear-gradient(135deg, ${isDark ? "#fff" : "#3730A3"} 0%, var(--indigo-light) 100%);
          -webkit-background-clip: text; -webkit-text-fill-color: transparent;
          letter-spacing: -0.5px;
        }
        .nav-links { display: flex; gap: 32px; align-items: center; }
        .nav-links a {
          color: var(--text-mid); text-decoration: none; font-size: 14px;
          font-weight: 500; transition: color 0.2s;
        }
        .nav-links a:hover { color: #fff; }
        .nav-cta {
          background: var(--indigo); color: #fff !important;
          padding: 10px 22px; border-radius: 8px;
          font-weight: 600 !important;
          transition: all 0.2s !important;
        }
        .nav-cta:hover { background: var(--indigo-light) !important; transform: translateY(-1px); }

        /* HERO */
        .hero {
          min-height: 100vh;
          display: flex; align-items: center; justify-content: center;
          position: relative; overflow: hidden;
          padding: 120px 40px 80px;
          background: ${isDark ? "transparent" : "transparent"};
        }
        .hero-grid {
          position: absolute; inset: 0;
          background-image:
            linear-gradient(rgba(79,70,229,0.04) 1px, transparent 1px),
            linear-gradient(90deg, rgba(79,70,229,0.04) 1px, transparent 1px);
          background-size: 60px 60px;
          mask-image: radial-gradient(ellipse 80% 60% at 50% 50%, black, transparent);
        }
        .hero-glow-1 {
          position: absolute; width: 700px; height: 700px;
          border-radius: 50%;
          background: radial-gradient(circle, ${isDark ? "rgba(79,70,229,0.18)" : "rgba(79,70,229,0.06)"} 0%, transparent 70%);
          top: -200px; left: -200px; filter: blur(40px);
          animation: drift1 12s ease-in-out infinite;
        }
        .hero-glow-2 {
          position: absolute; width: 500px; height: 500px;
          border-radius: 50%;
          background: radial-gradient(circle, ${isDark ? "rgba(99,102,241,0.12)" : "rgba(99,102,241,0.04)"} 0%, transparent 70%);
          bottom: -100px; right: -100px; filter: blur(40px);
          animation: drift2 10s ease-in-out infinite;
        }
        @keyframes drift1 {
          0%,100% { transform: translate(0,0); }
          50% { transform: translate(60px,-40px); }
        }
        @keyframes drift2 {
          0%,100% { transform: translate(0,0); }
          50% { transform: translate(-40px,30px); }
        }
        .hero-content { position: relative; z-index: 2; text-align: center; max-width: 860px; margin: 0 auto; }
        .hero-badge {
          display: inline-flex; align-items: center; gap: 8px;
          background: rgba(79,70,229,0.15); border: 1px solid rgba(79,70,229,0.4);
          padding: 8px 18px; border-radius: 100px;
          font-size: 13px; font-weight: 500; color: #a5b4fc;
          margin-bottom: 32px;
          animation: fadeUp 0.6s ease-out both;
        }
        .badge-dot {
          width: 6px; height: 6px; border-radius: 50%;
          background: #4ade80;
          box-shadow: 0 0 8px #4ade80;
          animation: pulse-dot 2s ease-in-out infinite;
        }
        @keyframes pulse-dot {
          0%,100% { opacity: 1; transform: scale(1); }
          50% { opacity: 0.6; transform: scale(1.3); }
        }
        .hero-title {
          font-family: 'Nunito', sans-serif;
          font-size: clamp(40px, 6vw, 72px);
          font-weight: 800; line-height: 1.0;
          letter-spacing: -1.5px; margin-bottom: 24px;
          animation: fadeUp 0.6s 0.1s ease-out both;
        }
        .title-line-2 {
          background: linear-gradient(135deg, var(--indigo-light) 0%, #a78bfa 50%, #818cf8 100%);
          -webkit-background-clip: text; -webkit-text-fill-color: transparent;
          display: block;
        }
        .hero-sub {
          font-size: clamp(16px, 2.5vw, 20px);
          color: var(--text-mid); line-height: 1.6;
          max-width: 580px; margin: 0 auto 40px;
          font-weight: 400;
          animation: fadeUp 0.6s 0.2s ease-out both;
        }
        .hero-actions {
          display: flex; gap: 14px; justify-content: center; flex-wrap: wrap;
          margin-bottom: 56px;
          animation: fadeUp 0.6s 0.3s ease-out both;
        }
        .btn-main {
          display: inline-flex; align-items: center; gap: 8px;
          background: linear-gradient(135deg, var(--indigo) 0%, var(--indigo-light) 100%);
          color: #fff; padding: 16px 32px; border-radius: 12px;
          font-size: 16px; font-weight: 600; text-decoration: none;
          border: none; cursor: pointer;
          box-shadow: 0 0 40px rgba(79,70,229,0.35);
          transition: all 0.3s ease;
        }
        .btn-main:hover { transform: translateY(-3px); box-shadow: 0 0 60px rgba(79,70,229,0.5); }
        .btn-ghost {
          display: inline-flex; align-items: center; gap: 8px;
          background: transparent; color: var(--text-mid);
          padding: 16px 32px; border-radius: 12px;
          font-size: 16px; font-weight: 500;
          border: 1px solid var(--border);
          cursor: pointer; text-decoration: none;
          transition: all 0.3s ease;
        }
        .btn-ghost:hover { border-color: rgba(255,255,255,0.2); color: #fff; background: rgba(255,255,255,0.04); }
        .hero-trust {
          display: flex; align-items: center; justify-content: center;
          gap: 24px; flex-wrap: wrap;
          animation: fadeUp 0.6s 0.4s ease-out both;
        }
        .trust-item {
          display: flex; align-items: center; gap: 6px;
          color: var(--text-dim); font-size: 13px;
        }
        .trust-check { color: #4ade80; font-size: 14px; }

        /* STATS STRIP */
        .stats-strip {
          background: var(--surface);
          border-top: 1px solid var(--border);
          border-bottom: 1px solid var(--border);
          padding: 40px;
          display: grid; grid-template-columns: repeat(3, 1fr);
          gap: 2px;
        }
        .stat-item {
          text-align: center; padding: 20px;
          border-right: 1px solid var(--border);
        }
        .stat-item:last-child { border-right: none; }
        .stat-number {
          font-family: 'Nunito', sans-serif;
          font-size: 42px; font-weight: 800;
          background: linear-gradient(135deg, ${isDark ? "#fff" : "#fff"} 0%, ${isDark ? "var(--indigo-light)" : "rgba(255,255,255,0.85)"} 100%);
          -webkit-background-clip: text; -webkit-text-fill-color: transparent;
          display: block; line-height: 1;
        }
        .stat-label { color: var(--text-mid); font-size: 14px; margin-top: 6px; }

        /* FEATURES */
        .section { padding: 100px 40px; }
        .section-label {
          font-size: 12px; font-weight: 700; letter-spacing: 3px;
          color: var(--indigo-light); text-transform: uppercase;
          margin-bottom: 16px; display: block;
        }
        .section-title {
          font-family: 'Nunito', sans-serif;
          font-size: clamp(28px, 3.5vw, 42px);
          font-weight: 800; letter-spacing: -2px;
          line-height: 1.1; margin-bottom: 16px;
          color: ${theme.color};
        }
        .section-sub { color: var(--text-mid); font-size: 18px; max-width: 520px; line-height: 1.6; }
        .features-grid {
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
          gap: 2px; margin-top: 60px;
          background: var(--border);
          border: 1px solid var(--border);
          border-radius: 20px; overflow: hidden;
        }
        .feature-card {
          background: var(--surface);
          padding: 40px 36px;
          transition: all 0.3s ease;
          position: relative; overflow: hidden;
          box-shadow: ${isDark ? "none" : "0 2px 12px rgba(79,70,229,0.06)"};
        }
        .feature-card::before {
          content: '';
          position: absolute; top: 0; left: 0; right: 0; height: 1px;
          background: linear-gradient(90deg, transparent, var(--indigo-light), transparent);
          opacity: 0; transition: opacity 0.3s;
        }
        .feature-card:hover { background: ${isDark ? "var(--surface-2)" : "#EEF2FF"}; }
        .feature-card:hover::before { opacity: 1; }
        .feature-icon {
          width: 52px; height: 52px; border-radius: 14px;
          background: rgba(79,70,229,0.15);
          border: 1px solid rgba(79,70,229,0.3);
          display: flex; align-items: center; justify-content: center;
          font-size: 24px; margin-bottom: 24px;
        }
        .feature-title { font-size: 18px; font-weight: 700; margin-bottom: 10px; color: ${theme.color}; }
        .feature-desc { color: var(--text-mid); font-size: 15px; line-height: 1.6; }

        /* CERTS */
        .certs-section { padding: 100px 40px; background: var(--surface); }
        .certs-scroll {
          display: flex; gap: 12px; flex-wrap: wrap;
          margin-top: 48px;
        }
        .cert-pill {
          padding: 10px 20px; border-radius: 100px;
          border: 1px solid var(--border);
          font-size: 14px; font-weight: 500; color: var(--text-mid);
          background: rgba(79,70,229,0.03);
          transition: all 0.25s ease; cursor: default;
        }
        .cert-pill:hover {
          border-color: var(--indigo-light);
          color: var(--indigo); background: rgba(79,70,229,0.08);
        }

        /* PRICING */
        .pricing-section { padding: 100px 40px; }
        .pricing-grid {
          display: grid; grid-template-columns: 1fr 1fr;
          gap: 20px; max-width: 880px; margin: 60px auto 0;
        }
        .plan-card {
          border-radius: 20px; padding: 40px;
          border: 1px solid var(--border);
          background: var(--surface);
          transition: all 0.3s;
          position: relative;
          box-shadow: ${isDark ? "none" : "0 4px 20px rgba(79,70,229,0.08)"};
        }
        .plan-card:hover {
          border-color: rgba(79,70,229,0.4);
          box-shadow: ${isDark ? "none" : "0 8px 32px rgba(79,70,229,0.14)"};
          transform: translateY(-2px);
        }
        .plan-card.featured {
          background: ${isDark
          ? "linear-gradient(145deg, rgba(79,70,229,0.2) 0%, rgba(99,102,241,0.1) 100%)"
          : "linear-gradient(145deg, #EEF2FF 0%, #E0E7FF 100%)"};
          border-color: rgba(79,70,229,0.4);
          box-shadow: ${isDark ? "none" : "0 8px 32px rgba(79,70,229,0.18)"};
        }
        .plan-card.featured::before {
          content: '⭐ Empfohlen';
          position: absolute; top: -1px; right: 28px;
          background: var(--indigo);
          color: #fff; font-size: 11px; font-weight: 700;
          padding: 6px 14px; border-radius: 0 0 10px 10px;
          letter-spacing: 0.5px;
        }
        .plan-name { font-size: 13px; font-weight: 700; letter-spacing: 2px; text-transform: uppercase; color: var(--text-dim); margin-bottom: 12px; }
        .plan-price {
          font-family: 'Nunito', sans-serif;
          font-size: 56px; font-weight: 800;
          letter-spacing: -2px; line-height: 1;
          margin-bottom: 4px;
        }
        .plan-period { color: var(--text-dim); font-size: 14px; margin-bottom: 8px; }
        .plan-annual {
          display: inline-flex; align-items: center; gap: 8px;
          background: rgba(79,70,229,0.1); border: 1px solid rgba(79,70,229,0.25);
          padding: 6px 12px; border-radius: 8px;
          font-size: 13px; color: ${isDark ? "#a5b4fc" : "#4F46E5"}; margin-bottom: 32px;
        }
        .save-badge {
          background: var(--indigo); color: #fff;
          font-size: 10px; font-weight: 700;
          padding: 2px 7px; border-radius: 4px;
        }
        .plan-divider { border: none; border-top: 1px solid ${isDark ? "var(--border)" : "rgba(79,70,229,0.15)"}; margin: 28px 0; }
        .plan-features { list-style: none; display: flex; flex-direction: column; gap: 14px; margin-bottom: 36px; }
        .plan-feature {
          display: flex; align-items: flex-start; gap: 12px;
          font-size: 14px; color: ${isDark ? "var(--text-mid)" : "#374151"};
        }
        .plan-feature.disabled { opacity: 0.4; }
        .check-icon {
          width: 20px; height: 20px; border-radius: 50%; flex-shrink: 0;
          display: flex; align-items: center; justify-content: center;
          font-size: 11px; margin-top: 1px;
        }
        .check-icon.on { background: rgba(79,70,229,0.15); color: #4F46E5; border: 1px solid rgba(79,70,229,0.3); }
        .check-icon.off { background: ${isDark ? "rgba(255,255,255,0.04)" : "rgba(0,0,0,0.04)"}; color: var(--text-dim); border: 1px solid var(--border); }
        .plan-name { font-size: 12px; font-weight: 700; letter-spacing: 2px; text-transform: uppercase; color: ${isDark ? "var(--text-dim)" : "#6B7280"}; margin-bottom: 12px; }
        .plan-price {
          font-family: 'Nunito', sans-serif;
          font-size: 52px; font-weight: 900;
          letter-spacing: -2px; line-height: 1;
          margin-bottom: 4px; color: ${isDark ? "#fff" : "#0F0F0F"};
        }
        .plan-btn {
          display: block; width: 100%; padding: 15px;
          border-radius: 12px; font-size: 15px; font-weight: 700;
          text-align: center; cursor: pointer; border: none;
          transition: all 0.25s ease; text-decoration: none;
          font-family: 'Plus Jakarta Sans', sans-serif;
        }
        .plan-btn.secondary {
          background: #fff;
          border: 1.5px solid rgba(79,70,229,0.3);
          color: #4F46E5;
        }
        .plan-btn.secondary:hover { background: #EEF2FF; border-color: #4F46E5; }
        .plan-btn.primary {
          background: linear-gradient(135deg, var(--indigo) 0%, var(--indigo-light) 100%);
          color: #fff;
          box-shadow: 0 4px 20px rgba(79,70,229,0.35);
        }
        .plan-btn.primary:hover { box-shadow: 0 8px 30px rgba(79,70,229,0.5); transform: translateY(-2px); }

        /* CTA */
        .cta-section {
          padding: 100px 40px;
          background: var(--surface);
          text-align: center;
        }
        .cta-inner {
          max-width: 600px; margin: 0 auto;
          padding: 64px; border-radius: 28px;
          background: linear-gradient(135deg, rgba(79,70,229,0.15) 0%, rgba(99,102,241,0.08) 100%);
          border: 1px solid rgba(79,70,229,0.3);
          position: relative; overflow: hidden;
        }
        .cta-inner::before {
          content: '';
          position: absolute; top: -100px; left: 50%; transform: translateX(-50%);
          width: 400px; height: 400px; border-radius: 50%;
          background: radial-gradient(circle, rgba(79,70,229,0.2), transparent 70%);
          filter: blur(40px); pointer-events: none;
        }
        .cta-title {
          font-family: 'Nunito', sans-serif;
          font-size: clamp(26px, 3vw, 38px);
          font-weight: 800; letter-spacing: -2px;
          margin-bottom: 16px; position: relative;
        }
        .cta-sub { color: var(--text-mid); margin-bottom: 36px; font-size: 16px; line-height: 1.6; position: relative; }
        .email-form {
          display: flex; gap: 10px; max-width: 460px; margin: 0 auto 16px;
          position: relative;
        }
        .email-input {
          flex: 1; background: rgba(255,255,255,0.06);
          border: 1px solid var(--border); border-radius: 10px;
          padding: 14px 20px; color: #fff; font-size: 15px;
          outline: none; transition: border-color 0.2s;
          font-family: 'Plus Jakarta Sans', sans-serif;
        }
        .email-input::placeholder { color: var(--text-dim); }
        .email-input:focus { border-color: var(--indigo-light); }
        .email-submit {
          background: linear-gradient(135deg, var(--indigo), var(--indigo-light));
          color: #fff; border: none; padding: 14px 24px;
          border-radius: 10px; font-size: 15px; font-weight: 600;
          cursor: pointer; white-space: nowrap;
          font-family: 'Plus Jakarta Sans', sans-serif;
          transition: all 0.2s;
        }
        .email-submit:hover { transform: translateY(-1px); box-shadow: 0 8px 24px rgba(79,70,229,0.4); }
        .cta-fine { color: var(--text-dim); font-size: 12px; position: relative; }

        /* FOOTER */
        footer {
          background: ${theme.ctaBg}; padding: 60px 40px 40px;
          border-top: 1px solid var(--border);
        }
        .footer-grid {
          display: grid; grid-template-columns: 2fr 1fr 1fr 1fr;
          gap: 40px; margin-bottom: 48px;
        }
        .footer-brand p { color: var(--text-dim); font-size: 14px; line-height: 1.6; margin-top: 12px; max-width: 240px; }
        .footer-col h4 { font-size: 13px; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; color: var(--text-dim); margin-bottom: 16px; }
        .footer-col ul { list-style: none; display: flex; flex-direction: column; gap: 10px; }
        .footer-col a { color: var(--text-dim); text-decoration: none; font-size: 14px; transition: color 0.2s; }
        .footer-col a:hover { color: #fff; }
        .footer-bottom {
          border-top: 1px solid var(--border); padding-top: 28px;
          display: flex; justify-content: space-between; align-items: center;
        }
        .footer-bottom p { color: var(--text-dim); font-size: 13px; }
        .app-badges { display: flex; gap: 12px; }
        .app-badge {
          display: flex; align-items: center; gap: 8px;
          background: rgba(255,255,255,0.06); border: 1px solid var(--border);
          padding: 8px 16px; border-radius: 8px;
          font-size: 12px; color: var(--text-mid);
          transition: all 0.2s; cursor: pointer; text-decoration: none;
        }
        .app-badge:hover { border-color: rgba(79,70,229,0.5); color: #fff; }
        .app-badge span { font-size: 18px; }

        @keyframes fadeUp {
          from { opacity: 0; transform: translateY(24px); }
          to { opacity: 1; transform: translateY(0); }
        }

        [data-animate] { opacity: 0; transform: translateY(32px); transition: all 0.7s cubic-bezier(0.16, 1, 0.3, 1); }
        [data-animate].visible { opacity: 1; transform: translateY(0); }

        @media (max-width: 768px) {
          nav { padding: 16px 20px; }
          .nav-links { display: none; }
          .section, .certs-section, .pricing-section, .cta-section { padding: 70px 20px; }
          .stats-strip { grid-template-columns: 1fr; gap: 0; padding: 20px; }
          .stat-item { border-right: none; border-bottom: 1px solid var(--border); }
          .pricing-grid { grid-template-columns: 1fr; }
          .footer-grid { grid-template-columns: 1fr 1fr; }
          .footer-bottom { flex-direction: column; gap: 20px; text-align: center; }
          .email-form { flex-direction: column; }
          .cta-inner { padding: 40px 24px; }
          .hero { padding: 100px 20px 60px; }
        }
      `}</style>

      {/* NAV */}
      <nav className={scrollY > 60 ? "scrolled" : ""}>
        <div className="nav-logo">Lernarena</div>
        <div className="nav-links">
          <a href="#features">Features</a>
          <a href="#preise">Preise</a> 
          
          {/* <Link href="/pruefungen">Prüfungen</Link>  */}

          <button onClick={() => setIsDark(!isDark)} style={{ background: "rgba(255,255,255,0.08)", border: "1px solid rgba(255,255,255,0.12)", color: "#fff", padding: "8px 14px", borderRadius: "8px", cursor: "pointer", fontSize: "16px", marginRight: "4px" }}>{isDark ? "☀️" : "🌙"}</button>
          <Link href="/register" className="nav-cta">Kostenlos starten</Link>
        </div>
      </nav>

      {/* Coming Soon Banner */}
      <div style={{
        background: "#4F46E5",
        color: "#fff",
        textAlign: "center",
        padding: "10px 20px",
        fontSize: "14px",
        fontWeight: 600,
      }}>
        🚧 Diese Seite befindet sich im Aufbau — bald sind wir für dich da!
      </div>

      {/* HERO */}
      <section className="hero">
        <div className="hero-grid" />
        <div className="hero-glow-1" />
        <div className="hero-glow-2" />
        <div className="hero-content">
          <div className="hero-badge">
            <span className="badge-dot" />
            Jetzt verfügbar — Flutter App & Web
          </div>
          <h1 className="hero-title">
            IHK-Prüfung
            <span className="title-line-2">bestanden.</span>
          </h1>
          <p className="hero-sub">
            Die intelligente Prüfungsvorbereitung für Fachinformatiker. 600+ Fragen, KI-Tutor Ada und echte Prüfungssimulation — alles in einer App.
          </p>
          <div className="hero-actions">
            <Link href="/pruefungen" className="btn-main">
              Kostenlos starten →
            </Link>
            <a href="#features" className="btn-ghost">
              Mehr erfahren
            </a>
          </div>
          <div className="hero-trust">
            <span className="trust-item"><span className="trust-check">✓</span> Keine Kreditkarte</span>
            <span className="trust-item"><span className="trust-check">✓</span> 600+ Übungsfragen</span>
            <span className="trust-item"><span className="trust-check">✓</span> KI-Tutor inklusive</span>
            <span className="trust-item"><span className="trust-check">✓</span> Mobile & Web</span>
          </div>
        </div>
      </section>

      {/* STATS */}
      <div className="stats-strip" style={{ background: theme.statsBg }}>
        <div className="stat-item">
          <span className="stat-number">600+</span>
          <div className="stat-label" style={{ color: isDark ? undefined : "rgba(255,255,255,0.75)" }}>Prüfungsfragen</div>
        </div>
        <div className="stat-item">
          <span className="stat-number">17</span>
          <div className="stat-label" style={{ color: isDark ? undefined : "rgba(255,255,255,0.75)" }}>Lernmodule</div>
        </div>
        <div className="stat-item">
          <span className="stat-number">7</span>
          <div className="stat-label" style={{ color: isDark ? undefined : "rgba(255,255,255,0.75)" }}>Zertifizierungen</div>
        </div>
      </div>

      {/* FEATURES */}
      <section className="section" id="features">
        <div style={{ maxWidth: 1100, margin: "0 auto" }}>
          <div id="features-head" data-animate className={visibleSections.has("features-head") ? "visible" : ""}>
            <span className="section-label">Features</span>
            <h2 className="section-title">Alles was du brauchst,<br />nichts was du nicht brauchst.</h2>
            <p className="section-sub">Entwickelt von Fachinformatiker-Azubis für Fachinformatiker-Azubis.</p>
          </div>
          <div id="features-grid" data-animate style={{ transitionDelay: "0.1s" }}
            className={`features-grid ${visibleSections.has("features-grid") ? "visible" : ""}`}>
            {[
              { icon: "🎯", title: "Echte Prüfungssimulation", desc: "Timer, Fragenübersicht und Prüfungsbedingungen — genau wie beim IHK-Test." },
              { icon: "🤖", title: "KI-Tutor Ada", desc: "Benannt nach Ada Lovelace. Erklärt, bewertet und hilft gezielt bei Schwächen." },
              { icon: "⚔️", title: "AsyncMatch Multiplayer", desc: "Trete gegen andere Azubis an. Rangliste, ELO-Rating, Wettbewerb." },
              { icon: "🔁", title: "Spaced Repetition", desc: "Wissenschaftlich bewiesene Lernmethode — die App merkt sich was du vergisst." },
              { icon: "📱", title: "Mobile & Web", desc: "Flutter App für unterwegs, Web-App am Desktop für die echte Prüfung." },
              { icon: "📊", title: "Fortschritts-Tracking", desc: "Modul-Fortschritt, Trefferquoten und persönliche Statistiken." },
              { icon: "🏆", title: "Zertifikate üben", desc: "AWS, Azure, GCP, SAP — ohne Timer und mit Erklärungen." },
              { icon: "⚡", title: "Kernthemen-Modus", desc: "RAID, Subnetting, OSI, IT-Sicherheit — kommt in jeder IHK-Prüfung vor." },
            ].map((f, i) => (
              <div key={i} className="feature-card">
                <div className="feature-icon">{f.icon}</div>
                <div className="feature-title">{f.title}</div>
                <p className="feature-desc">{f.desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* CERTS */}
      <section className="certs-section" style={{ background: theme.certsBg }}>
        <div style={{ maxWidth: 1100, margin: "0 auto" }}>
          <div id="certs" data-animate className={visibleSections.has("certs") ? "visible" : ""}>
            <span className="section-label" style={{ color: isDark ? undefined : "rgba(255,255,255,0.7)" }}>Prüfungssimulationen</span>
            <h2 className="section-title" style={{ color: isDark ? undefined : "#fff" }}>Für welche Prüfung<br />bereitest du dich vor?</h2>
            <p className="section-sub" style={{ color: isDark ? undefined : "rgba(255,255,255,0.8)" }}>Authentische Simulationen für IHK-Abschlüsse und Cloud-Zertifizierungen.</p>
            <div className="certs-scroll">
              {["Fachinformatiker AE", "Fachinformatiker SI", "AWS Cloud Practitioner", "Microsoft Azure Fundamentals", "Google Cloud Digital Leader", "SAP Application Associate", "AP1 Halbjahresprüfung", "AP2 Abschlussprüfung"].map((c, i) => (
                <span key={i} className="cert-pill" style={{
                  background: isDark ? undefined : "rgba(255,255,255,0.15)",
                  color: isDark ? undefined : "#fff",
                  borderColor: isDark ? undefined : "rgba(255,255,255,0.3)"
                }}>{c}</span>
              ))}
            </div>
          </div>
        </div>
      </section>

      {/* PRICING */}
      <section className="pricing-section" id="preise">
        <div style={{ maxWidth: 1100, margin: "0 auto", textAlign: "center" }}>
          <div id="pricing-head" data-animate className={visibleSections.has("pricing-head") ? "visible" : ""}>
            <span className="section-label">Preise</span>
            <h2 className="section-title">Transparent. Fair. Keine Tricks.</h2>
            <p className="section-sub" style={{ margin: "0 auto" }}>Starte kostenlos — upgrade wenn du bereit bist.</p>
          </div>
          <div id="pricing-grid" data-animate
            className={`pricing-grid ${visibleSections.has("pricing-grid") ? "visible" : ""}`}
            style={{ transitionDelay: "0.15s" }}>
            {/* FREE */}
            <div className="plan-card">
              <div className="plan-name">Free</div>
              <div className="plan-price">0€</div>
              <div className="plan-period">/ Monat · Für immer kostenlos</div>
              <hr className="plan-divider" />
              <ul className="plan-features">
                {[
                  { on: true, text: "Alle 17 Lernmodule", sub: "20 Fragen pro Modul" },
                  { on: true, text: "3 Matches pro Tag", sub: "Match Arena Zugang" },
                  { on: true, text: "KI-Erklärungen", sub: "Bei falschen Antworten" },
                  { on: false, text: "Alle 600+ Fragen", sub: "Nur Premium" },
                  { on: false, text: "Prüfungssimulation", sub: "Nur Premium" },
                  { on: false, text: "Cloud-Zertifikate", sub: "Nur Premium" },
                ].map((f, i) => (
                  <li key={i} className={`plan-feature ${f.on ? "" : "disabled"}`}>
                    <span className={`check-icon ${f.on ? "on" : "off"}`}>{f.on ? "✓" : "✗"}</span>
                    <div style={{ textAlign: "left" }}>
                      <div style={{ color: f.on ? (isDark ? "#fff" : "#0F0F0F") : undefined, fontWeight: 500 }}>{f.text}</div>
                      <div style={{ fontSize: 12, opacity: 0.6, marginTop: 2 }}>{f.sub}</div>
                    </div>
                  </li>
                ))}
              </ul>
              <Link href="/register" className="plan-btn secondary" style={{ border: "1px solid rgba(79,70,229,0.4)", color: "var(--indigo-light)" }}>Kostenlos starten</Link>
            </div>

            {/* PREMIUM */}
            <div className="plan-card featured">
              <div className="plan-name" style={{ color: isDark ? "#a5b4fc" : "#4F46E5" }}>Premium</div>
              <div className="plan-price">9,99€</div>
              <div className="plan-period">/ Monat · oder 89€/Jahr</div>
              <div className="plan-annual">
                Jahresabo — spare 25% <span className="save-badge">-25%</span>
              </div>
              <ul className="plan-features">
                {[
                  { text: "Alle 600+ Fragen", sub: "Komplette Datenbank" },
                  { text: "Unbegrenzte Matches", sub: "Match Arena ohne Limit" },
                  { text: "Prüfungssimulation", sub: "Echte Prüfungsbedingungen" },
                  { text: "KI-Tutor Ada", sub: "Unbegrenzte Chats & Feedback" },
                  { text: "Cloud-Zertifikate", sub: "AWS, Azure, GCP, SAP" },
                  { text: "Sync auf allen Geräten", sub: "Mobile & Web" },
                ].map((f, i) => (
                  <li key={i} className="plan-feature">
                    <span className="check-icon on">✓</span>
                    <div style={{ textAlign: "left" }}>
                      <div style={{ color: isDark ? "#fff" : "#0F0F0F", fontWeight: 600 }}>{f.text}</div>
                      <div style={{ fontSize: 12, color: isDark ? "rgba(255,255,255,0.5)" : "#6B7280", marginTop: 2 }}>{f.sub}</div>
                    </div>
                  </li>
                ))}
              </ul>
              <button className="plan-btn primary">Premium holen</button>
              <p style={{ fontSize: 12, color: isDark ? "var(--text-dim)" : "#9CA3AF", marginTop: 12 }}>
                Jederzeit kündbar · 14 Tage Geld-zurück
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* CTA */}
      <section className="cta-section">
        <div id="cta" data-animate className={`cta-inner ${visibleSections.has("cta") ? "visible" : ""}`}>
          <h2 className="cta-title">Bereit für deine Prüfung?</h2>
          <p className="cta-sub">Registriere dich jetzt und starte sofort mit über 600 Übungsfragen — kostenlos.</p>
          <form onSubmit={handleSubmit} className="email-form">
            <input
              type="email" placeholder="deine@email.de"
              value={email} onChange={(e) => setEmail(e.target.value)}
              className="email-input" required
            />
            <button type="submit" className="email-submit">Starten →</button>
          </form>
          <p className="cta-fine">Kein Spam · Jederzeit abmeldbar · DSGVO-konform</p>
        </div>
      </section>

{/* Footer */}
<footer className="bg-gray-900 text-white py-12">
    <div className="container mx-auto px-6">
        <div className="grid md:grid-cols-4 gap-8">
            <div>
                <h3 className="display-font text-2xl font-bold mb-4">Lernarena</h3>
                <p className="text-gray-400">
                    Deine intelligente Prüfungsvorbereitung
                </p>
            </div>
            <div>
                <h4 className="font-semibold mb-4">Produkt</h4>
                <ul className="space-y-2 text-gray-400">
                    <li><a href="#" className="hover:text-white transition">Features</a></li>
                    <li><a href="#" className="hover:text-white transition">Preise</a></li>
                    <li><Link href="/pruefungen" className="hover:text-white transition">Prüfungen</Link></li>
                </ul>
            </div>
            <div>
                <h4 className="font-semibold mb-4">Ressourcen</h4>
                <ul className="space-y-2 text-gray-400">
                    <li><a href="#" className="hover:text-white transition">Blog</a></li>
                    <li><a href="#" className="hover:text-white transition">Hilfe</a></li>
                    <li><a href="#" className="hover:text-white transition">FAQ</a></li>
                </ul>
            </div>
            <div>
                <h4 className="font-semibold mb-4">Legal</h4>
                <ul className="space-y-2 text-gray-400">
                    <li><Link href="/impressum" className="hover:text-white transition">Impressum</Link></li>
                    <li><Link href="/datenschutz" className="hover:text-white transition">Datenschutz</Link></li>
                    <li><Link href="/agb" className="hover:text-white transition">AGB</Link></li>
                </ul>
            </div>
        </div>
        <div className="border-t border-gray-800 mt-12 pt-8 text-center text-gray-400">
            <p>© {new Date().getFullYear()} Lernarena. Alle Rechte vorbehalten.</p>
        </div>
    </div>
</footer>