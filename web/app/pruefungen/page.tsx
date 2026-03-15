"use client";

import Link from "next/link";
import { examList } from "@/data/exams";

export default function PruefungenPage() {
  const aeExams = examList.filter((exam) => exam.id.startsWith("ae-"));
  const siExams = examList.filter((exam) => exam.id.startsWith("si-"));

  return (
    <div style={{ fontFamily: "'Plus Jakarta Sans', sans-serif", background: "#FFFFFF", color: "#0F0F0F", minHeight: "100vh" }}>
      <style>{`
        @import url('https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800;900&family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap');
        * { box-sizing: border-box; margin: 0; padding: 0; }

        .pruef-nav {
          position: sticky; top: 0; z-index: 50;
          padding: 16px 40px;
          display: flex; align-items: center; justify-content: space-between;
          background: rgba(255,255,255,0.95);
          backdrop-filter: blur(20px);
          border-bottom: 1px solid rgba(79,70,229,0.15);
        }
        .nav-logo {
          font-family: 'Nunito', sans-serif; font-size: 18px; font-weight: 800;
          background: linear-gradient(135deg, #3730A3 0%, #6366F1 100%);
          -webkit-background-clip: text; -webkit-text-fill-color: transparent;
          text-decoration: none;
        }
        .back-btn {
          display: flex; align-items: center; gap: 8px;
          color: #6B7280; text-decoration: none; font-size: 14px;
          font-weight: 500; transition: all 0.2s;
          padding: 8px 16px; border-radius: 8px;
          border: 1px solid #E5E7EB;
          background: #FFFFFF;
        }
        .back-btn:hover { color: #4F46E5; border-color: rgba(79,70,229,0.3); transform: translateX(-3px); }

        .hero-section { padding: 56px 40px 36px; text-align: center; background: linear-gradient(135deg, #FAFAFF 0%, #F5F3FF 100%); }
        .hero-badge {
          display: inline-flex; align-items: center; gap: 8px;
          background: rgba(79,70,229,0.08); border: 1px solid rgba(79,70,229,0.2);
          padding: 7px 16px; border-radius: 100px;
          font-size: 12px; font-weight: 700; color: #4F46E5;
          letter-spacing: 1px; text-transform: uppercase; margin-bottom: 20px;
        }
        .hero-title {
          font-family: 'Nunito', sans-serif;
          font-size: clamp(32px, 5vw, 52px);
          font-weight: 800; letter-spacing: -2px;
          line-height: 1.05; margin-bottom: 14px; color: #111;
        }
        .hero-title span {
          background: linear-gradient(135deg, #4F46E5 0%, #6366F1 100%);
          -webkit-background-clip: text; -webkit-text-fill-color: transparent;
        }
        .hero-sub { color: #6B7280; font-size: 16px; max-width: 480px; margin: 0 auto; line-height: 1.6; }

        .content-wrap { max-width: 1100px; margin: 0 auto; padding: 32px 40px 100px; }

        .section-header { display: flex; align-items: center; gap: 14px; margin-bottom: 20px; margin-top: 44px; }
        .section-icon {
          width: 48px; height: 48px; border-radius: 12px;
          display: flex; align-items: center; justify-content: center;
          font-size: 20px; flex-shrink: 0;
        }
        .section-icon.ae { background: linear-gradient(135deg, #3B82F6, #1D4ED8); }
        .section-icon.si { background: linear-gradient(135deg, #10B981, #059669); }
        .section-title-text {
          font-family: 'Nunito', sans-serif;
          font-size: 22px; font-weight: 800; letter-spacing: -0.5px; color: #111;
        }
        .section-count { color: #9CA3AF; font-size: 13px; margin-top: 2px; }

        .exams-grid {
          display: grid;
          grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
          gap: 14px;
        }
        .exam-card {
          background: #FFFFFF;
          border: 1px solid #E5E7EB;
          border-radius: 16px; padding: 22px;
          text-decoration: none; color: inherit;
          transition: all 0.25s ease;
          display: block; position: relative; overflow: hidden;
        }
        .exam-card::before {
          content: ''; position: absolute;
          top: 0; left: 0; right: 0; height: 3px;
          opacity: 0; transition: opacity 0.25s;
        }
        .exam-card.ae::before { background: linear-gradient(90deg, #3B82F6, #6366F1); }
        .exam-card.si::before { background: linear-gradient(90deg, #10B981, #059669); }
        .exam-card:hover {
          border-color: rgba(79,70,229,0.2);
          box-shadow: 0 8px 24px rgba(79,70,229,0.15);
          transform: translateY(-3px);
        }
        .exam-card:hover::before { opacity: 1; }

        .exam-badge {
          display: inline-flex; padding: 4px 12px;
          border-radius: 100px; font-size: 11px; font-weight: 700;
          letter-spacing: 0.5px; margin-bottom: 12px;
        }
        .exam-badge.ae { background: rgba(59,130,246,0.08); color: #2563EB; border: 1px solid rgba(59,130,246,0.2); }
        .exam-badge.si { background: rgba(16,185,129,0.08); color: #059669; border: 1px solid rgba(16,185,129,0.2); }

        .exam-title { font-size: 15px; font-weight: 700; margin-bottom: 5px; color: #111; line-height: 1.3; }
        .exam-company { color: #9CA3AF; font-size: 13px; margin-bottom: 16px; }
        .exam-meta {
          display: flex; align-items: center; justify-content: space-between;
          padding-top: 14px; border-top: 1px solid #F3F4F6;
        }
        .exam-chips { display: flex; gap: 8px; }
        .exam-chip {
          display: flex; align-items: center; gap: 4px;
          color: #6B7280; font-size: 12px;
          background: #F9FAFB; padding: 4px 10px;
          border-radius: 6px; border: 1px solid #E5E7EB;
        }
        .exam-arrow { font-size: 13px; font-weight: 700; transition: transform 0.2s; }
        .exam-card.ae .exam-arrow { color: #2563EB; }
        .exam-card.si .exam-arrow { color: #059669; }
        .exam-card:hover .exam-arrow { transform: translateX(4px); }

        .footer-strip {
          border-top: 1px solid #E5E7EB;
          padding: 20px 40px; text-align: center;
          color: #9CA3AF; font-size: 13px;
          display: flex; justify-content: center; gap: 28px; flex-wrap: wrap;
          background: #FFFFFF;
        }
        .footer-strip span { display: flex; align-items: center; gap: 6px; }
        .footer-check { color: #4F46E5; }

        @media (max-width: 768px) {
          .pruef-nav, .hero-section, .content-wrap, .footer-strip { padding-left: 20px; padding-right: 20px; }
          .exams-grid { grid-template-columns: 1fr; }
        }
      `}</style>

      {/* Nav */}
      <nav className="pruef-nav">
        <Link href="/" className="nav-logo">Lernarena</Link>
        <Link href="/" className="back-btn">← Startseite</Link>
      </nav>

      {/* Hero */}
      <section className="hero-section">
        <div className="hero-badge">Prüfungssimulation</div>
        <h1 className="hero-title">Wähle deine <span>Prüfung</span></h1>
        <p className="hero-sub">Realistische Simulationen mit Timer, verschiedenen Aufgabentypen und KI-Feedback.</p>
      </section>

      {/* Content */}
      <div className="content-wrap">

        {/* AE */}
        <div className="section-header">
          <div className="section-icon ae">💻</div>
          <div>
            <div className="section-title-text">Anwendungsentwicklung</div>
            <div className="section-count">{aeExams.length} Prüfungen verfügbar</div>
          </div>
        </div>
        <div className="exams-grid">
          {aeExams.map((exam) => (
            <Link key={exam.id} href={`/pruefung/${exam.id}`} className="exam-card ae">
              <div className="exam-badge ae">{exam.season} {exam.year}</div>
              <div className="exam-title">{exam.title}</div>
              <div className="exam-company">{exam.company}</div>
              <div className="exam-meta">
                <div className="exam-chips">
                  <span className="exam-chip">⏱ {exam.duration} Min</span>
                  <span className="exam-chip">📊 {exam.totalPoints} Pkt</span>
                </div>
                <span className="exam-arrow">Starten →</span>
              </div>
            </Link>
          ))}
        </div>

        {/* SI */}
        <div className="section-header">
          <div className="section-icon si">🖧</div>
          <div>
            <div className="section-title-text">Systemintegration</div>
            <div className="section-count">{siExams.length} Prüfungen verfügbar</div>
          </div>
        </div>
        <div className="exams-grid">
          {siExams.map((exam) => (
            <Link key={exam.id} href={`/pruefung/${exam.id}`} className="exam-card si">
              <div className="exam-badge si">{exam.season} {exam.year}</div>
              <div className="exam-title">{exam.title}</div>
              <div className="exam-company">{exam.company}</div>
              <div className="exam-meta">
                <div className="exam-chips">
                  <span className="exam-chip">⏱ {exam.duration} Min</span>
                  <span className="exam-chip">📊 {exam.totalPoints} Pkt</span>
                </div>
                <span className="exam-arrow">Starten →</span>
              </div>
            </Link>
          ))}
        </div>
      </div>

      {/* Footer Strip */}
      <div className="footer-strip">
        <span><span className="footer-check">✓</span> Echte Prüfungsbedingungen</span>
        <span><span className="footer-check">✓</span> 90 Minuten Timer</span>
        <span><span className="footer-check">✓</span> KI-Tutor Feedback</span>
        <span><span className="footer-check">✓</span> Sofortiges Ergebnis</span>
      </div>
    </div>
  );
}