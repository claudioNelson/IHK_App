"use client";

// Startseite lernarena.app (Neuaufbau 23.09.2026, Vorlage lernarena-landing-v2).
//
// Kopf, Fuss, Tokens und Buttons kommen aus dem gemeinsamen Rahmen
// (components/shell, globals.css). Hier stehen nur die Abschnitte der
// Startseite und ihre Styles. Anker #product / #ablauf / #ada / #pricing /
// #laden bleiben erhalten (Nav und Footer verlinken darauf).
//
// Screenshots liegen unter /public/screenshots/ (hub.png, pruefung.png,
// ada.png; 1290x2796). Fehlt eine Datei, bleibt die Flaeche leer.

import { useState, useEffect, type ReactNode } from "react";
import Link from "next/link";
import PageShell from "./components/shell/PageShell";
import { PLAY_URL, APPSTORE_URL } from "./components/shell/SiteFooter";

const NAV_LINKS = [
  { href: "#product", label: "Funktionen" },
  { href: "#ablauf", label: "So läuft es" },
  { href: "#pricing", label: "Preise" },
  { href: "/lernen", label: "Lernseiten" },
  { href: "/pruefungen", label: "Prüfungen" },
];

function Check() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <path d="M5 12l4 4L19 6" />
    </svg>
  );
}

function Shot({ src, alt, eager = false }: { src: string; alt: string; eager?: boolean }) {
  const [broken, setBroken] = useState(false);
  return (
    <div className="shot">
      {!broken && (
        // eslint-disable-next-line @next/next/no-img-element
        <img
          src={src}
          alt={alt}
          loading={eager ? "eager" : "lazy"}
          fetchPriority={eager ? "high" : "auto"}
          onError={() => setBroken(true)}
        />
      )}
    </div>
  );
}

function Faq({ q, children }: { q: string; children: ReactNode }) {
  return (
    <details>
      <summary>
        {q}
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" aria-hidden="true">
          <path d="M12 5v14M5 12h14" />
        </svg>
      </summary>
      <p>{children}</p>
    </details>
  );
}

export default function LandingPage() {
  // Einblenden beim Scrollen (IntersectionObserver, kein Scroll-Listener).
  useEffect(() => {
    if (typeof window === "undefined") return;
    const reduce = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
    const els = Array.from(document.querySelectorAll<HTMLElement>(".reveal"));
    if (reduce) {
      els.forEach((el) => el.classList.add("in"));
      return;
    }
    const io = new IntersectionObserver(
      (entries) => {
        for (const e of entries) {
          if (e.isIntersecting) {
            e.target.classList.add("in");
            io.unobserve(e.target);
          }
        }
      },
      { threshold: 0.15 },
    );
    els.forEach((el, i) => {
      el.style.transitionDelay = `${(i % 4) * 60}ms`;
      io.observe(el);
    });
    return () => io.disconnect();
  }, []);

  return (
    <PageShell className="lp" links={NAV_LINKS} cta={{ href: "#laden", label: "App laden" }}>
      <style>{`
        .lp a { color: inherit; text-decoration: none; }
        .lp h1, .lp h2, .lp h3, .lp p, .lp ul, .lp figure { margin: 0; }
        .lp ul { padding: 0; list-style: none; }
        .lp img, .lp svg { display: block; max-width: 100%; }
        .lp section { padding-block: clamp(64px, 8vw, 112px); }
        .lp section + section { border-top: 1px solid var(--line); }

        .lp h1 { font-size: clamp(38px, 5vw, 64px); line-height: 1.04; letter-spacing: -.035em; font-weight: 600; }
        .lp h2 { overflow-wrap: anywhere; font-size: clamp(30px, 3.4vw, 44px); line-height: 1.08; letter-spacing: -.03em; font-weight: 600; max-width: 22ch; }
        .lp h3 { font-size: 19px; line-height: 1.3; letter-spacing: -.01em; font-weight: 600; }
        .lead { font-size: clamp(16px, 1.4vw, 19px); color: var(--text-2); max-width: 56ch; }
        .body { font-size: 15.5px; color: var(--text-2); max-width: 60ch; }
        .eyebrow { font-family: var(--font-geist-mono), ui-monospace, monospace; font-size: 11.5px; font-weight: 600; letter-spacing: .16em; text-transform: uppercase; color: var(--accent); margin-bottom: 14px; }
        .num { font-family: var(--font-geist-mono), ui-monospace, monospace; font-variant-numeric: tabular-nums; }

        /* Screenshots in natuerlicher Hoehe (kein Beschneiden); nur ein leerer
           Slot bekommt eine feste Proportion, damit die Flaeche nicht kollabiert. */
        .shot { border-radius: var(--r-shot); border: 1px solid var(--line-2); background: var(--surface); overflow: hidden; }
        .shot:empty { aspect-ratio: 9 / 16; }
        .shot img { width: 100%; height: auto; }

        /* Hero */
        .lp .hero { position: relative; overflow: hidden; padding-top: clamp(40px, 6vw, 72px); padding-bottom: clamp(48px, 6vw, 80px); }
        /* Hintergrund: zwei weiche Farbflecken und ein feines Punktraster, das nach unten ausblendet */
        .lp .hero::before { content: ""; position: absolute; inset: 0; pointer-events: none;
          background: radial-gradient(640px 400px at 78% 42%, var(--accent-soft), transparent 70%),
                      radial-gradient(460px 320px at 10% 18%, color-mix(in srgb, var(--accent) 7%, transparent), transparent 70%); }
        .lp .hero::after { content: ""; position: absolute; inset: 0; pointer-events: none;
          background-image: radial-gradient(color-mix(in srgb, var(--text) 10%, transparent) 1px, transparent 1px);
          background-size: 22px 22px;
          -webkit-mask-image: linear-gradient(180deg, rgba(0,0,0,.85), transparent 90%); mask-image: linear-gradient(180deg, rgba(0,0,0,.85), transparent 90%); }
        .hero-grid { position: relative; z-index: 1; }
        .hero-note { display: flex; flex-wrap: wrap; gap: 8px 20px; margin-top: -6px; font-size: 13.5px; color: var(--text-3); }
        .hero-note li { display: flex; align-items: center; gap: 7px; }
        .hero-note svg { width: 15px; height: 15px; color: var(--ok); flex: 0 0 auto; }
        .hero-shot .shot { box-shadow: 0 40px 80px -30px color-mix(in srgb, var(--accent) 45%, transparent), var(--shadow); }
        .hero-grid { display: grid; grid-template-columns: minmax(0, 1.25fr) minmax(0, .9fr); gap: clamp(32px, 6vw, 88px); align-items: center; }
        .hero-copy { display: flex; flex-direction: column; gap: 26px; }
        .hero-actions { display: flex; gap: 12px; flex-wrap: wrap; }
        .hero-shot { justify-self: end; width: min(320px, 100%); }

        /* Zahlen */
        .stats { display: grid; grid-template-columns: repeat(4, 1fr); }
        .stat { padding: 8px 28px 8px 0; border-right: 1px solid var(--line); }
        .stat + .stat { padding-left: 28px; }
        .stat:last-child { border-right: 0; }
        .stat b { display: block; font-size: clamp(28px, 3vw, 40px); font-weight: 600; letter-spacing: -.03em; line-height: 1; margin-bottom: 8px; }
        .stat span { font-size: 14px; color: var(--text-2); }

        /* Funktionen: Bento, 5 Zellen */
        .bento { display: grid; grid-template-columns: repeat(6, 1fr); grid-auto-rows: minmax(200px, auto); gap: 14px; margin-top: 40px; }
        .cell { position: relative; border: 1px solid var(--line); border-radius: var(--r); background: var(--surface); box-shadow: var(--shadow); padding: 26px; display: flex; flex-direction: column; justify-content: flex-end; gap: 8px; overflow: hidden; }
        .cell p { color: var(--text-2); font-size: 14.5px; max-width: 40ch; }
        .cell-a { grid-column: span 4; grid-row: span 2; display: grid; grid-template-columns: minmax(0, 1fr) 260px; grid-template-rows: auto 1fr; gap: 20px 28px; align-items: end; }
        .cell-a .ico { grid-column: 1; grid-row: 1; align-self: start; margin-bottom: 0; }
        .cell-a .cell-text { grid-column: 1; grid-row: 2; max-width: none; }
        .cell-a .shot { grid-column: 2; grid-row: 1 / span 2; width: 100%; }
        .cell-b { grid-column: span 2; background: linear-gradient(160deg, color-mix(in srgb, var(--accent) 22%, transparent), color-mix(in srgb, var(--accent) 4%, transparent) 60%), var(--surface); }
        .cell-c { grid-column: span 2; }
        .cell-d { grid-column: span 3; background: var(--bg-2); }
        .cell-e { grid-column: span 3; background: linear-gradient(200deg, rgba(16,185,129,.16), rgba(16,185,129,.02) 55%), var(--surface); }
        .ico { width: 34px; height: 34px; border-radius: 9px; background: var(--accent-soft); display: grid; place-items: center; color: var(--accent); margin-bottom: auto; }
        .ico svg { width: 18px; height: 18px; }
        .cell-e .ico { background: rgba(16,185,129,.14); color: var(--ok); }

        /* Ablauf */
        .steps { display: grid; grid-template-columns: minmax(0, 1fr) minmax(0, 1.1fr); gap: clamp(32px, 6vw, 96px); align-items: start; }
        .steps-list { display: flex; flex-direction: column; margin: 0; padding: 0; }
        .step { display: grid; grid-template-columns: 64px 1fr; gap: 20px; padding: 26px 0; border-top: 1px solid var(--line); }
        .step:last-child { border-bottom: 1px solid var(--line); }
        .step b { font-family: var(--font-geist-mono), monospace; font-size: 30px; font-weight: 500; color: var(--accent); line-height: 1; }
        .step p { color: var(--text-2); font-size: 15px; margin-top: 6px; max-width: 44ch; }
        .sticky { position: sticky; top: 96px; }

        /* Ada */
        .split { display: grid; grid-template-columns: minmax(0, .9fr) minmax(0, 1.1fr); gap: clamp(32px, 6vw, 88px); align-items: center; }
        .split .shot { width: min(340px, 100%); justify-self: center; }
        .checks { display: flex; flex-direction: column; gap: 12px; margin-top: 24px; }
        .checks li { display: flex; gap: 12px; align-items: flex-start; font-size: 15.5px; color: var(--text-2); }
        .checks svg { flex: 0 0 auto; width: 20px; height: 20px; color: var(--ok); margin-top: 1px; }

        /* Preise */
        .plans { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; margin-top: 40px; }
        .plan { border: 1px solid var(--line); border-radius: var(--r); background: var(--surface); box-shadow: var(--shadow); padding: 30px; display: flex; flex-direction: column; gap: 22px; }
        .plan.pro { border-color: var(--accent); background: linear-gradient(180deg, var(--accent-soft), transparent 45%), var(--surface); }
        .price { font-size: 40px; font-weight: 600; letter-spacing: -.03em; line-height: 1; }
        .price small { font-size: 15px; color: var(--text-2); font-weight: 500; letter-spacing: 0; margin-left: 6px; }
        .plan ul { display: flex; flex-direction: column; gap: 10px; }
        .plan li { display: flex; gap: 10px; font-size: 15px; color: var(--text-2); }
        .plan li svg { flex: 0 0 auto; width: 18px; height: 18px; margin-top: 2px; color: var(--ok); }
        .plan li.off { color: var(--text-3); }
        .plan li.off svg { color: var(--text-3); }
        .plan .btn { margin-top: auto; }
        .plan-note { margin-top: 14px; font-size: 13.5px; color: var(--text-3); }

        /* FAQ */
        .faq { max-width: 760px; margin-top: 32px; }
        .faq details { border-top: 1px solid var(--line); }
        .faq details:last-child { border-bottom: 1px solid var(--line); }
        .faq summary { list-style: none; cursor: pointer; display: flex; justify-content: space-between; align-items: center; gap: 20px; padding: 20px 0; font-weight: 600; font-size: 17px; }
        .faq summary::-webkit-details-marker { display: none; }
        .faq summary svg { flex: 0 0 auto; width: 18px; height: 18px; color: var(--text-3); transition: transform .2s ease; }
        .faq details[open] summary svg { transform: rotate(45deg); }
        .faq p { padding: 0 0 22px; color: var(--text-2); font-size: 15.5px; max-width: 62ch; }

        /* Schluss */
        .cta-box { border: 1px solid var(--line-2); border-radius: var(--r); background: var(--surface); box-shadow: var(--shadow); padding: clamp(32px, 5vw, 56px); display: grid; grid-template-columns: minmax(0, 1.4fr) minmax(0, auto); gap: 32px; align-items: center; }
        .stores { display: flex; gap: 12px; flex-wrap: wrap; min-width: 0; }
        .stores a { display: block; }
        .stores img { height: 52px; width: auto; }


        /* Motion */
        .reveal { opacity: 0; transform: translateY(18px); transition: opacity .6s cubic-bezier(.16,1,.3,1), transform .6s cubic-bezier(.16,1,.3,1); }
        .reveal.in { opacity: 1; transform: none; }
        @media (prefers-reduced-motion: reduce) {
          .reveal { opacity: 1; transform: none; transition: none; }
          .faq summary svg { transition: none; }
        }

        /* Mobil */
        @media (max-width: 767px) {
          .hero-grid, .steps, .split, .plans, .cta-box { grid-template-columns: minmax(0, 1fr); }
          .hero-shot { justify-self: center; width: min(260px, 78%); }
          .stats { grid-template-columns: 1fr 1fr; row-gap: 28px; column-gap: 20px; }
          .stat { border-right: 0; padding: 0; }
          .stat + .stat { padding-left: 0; }
          .bento { grid-template-columns: 1fr; grid-auto-rows: auto; }
          .cell { grid-column: auto !important; grid-row: auto !important; min-height: 180px; }
          .cell-a { display: flex; }
          .cell-a .shot { display: none; }
          .sticky { position: static; }
          .split .shot { order: -1; }
        }
      `}</style>


        {/* HERO */}
        <section className="hero" aria-labelledby="h-hero">
          <div className="wrap hero-grid">
            <div className="hero-copy reveal">
              <h1 id="h-hero">Lernen, wie die IHK fragt.</h1>
              <p className="lead">Über 2.000 Aufgaben im Stil der Abschlussprüfung, ein Tagesplan bis zu deinem Termin und Übungsprüfungen mit Korrektur. Für AP1 und AP2.</p>
              <div className="hero-actions">
                <a className="btn btn-primary" href="#laden">Kostenlos laden</a>
                <a className="btn btn-ghost" href="#product">Funktionen ansehen</a>
              </div>
              <ul className="hero-note" aria-label="Kurz und knapp">
                <li><Check />Ohne Konto ausprobieren</li>
                <li><Check />Android und iPhone</li>
                <li><Check />Ada erklärt dir jede Antwort</li>
              </ul>
            </div>
            <figure className="hero-shot reveal">
              <Shot src="/screenshots/hub.png" alt="Lernarena Startbildschirm: Countdown zur AP1 mit Tagesplan" eager />
            </figure>
          </div>
        </section>

        {/* ZAHLEN */}
        <section aria-label="Kennzahlen">
          <div className="wrap stats reveal">
            <div className="stat"><b className="num">2.000+</b><span>Fragen im IHK-Stil, laufend erweitert</span></div>
            <div className="stat"><b className="num">70</b><span>Themen von Netzwerken bis WiSo</span></div>
            <div className="stat"><b>AP1 + AP2</b><span>Anwendungsentwicklung und Systemintegration</span></div>
            <div className="stat"><b>Android + iOS</b><span>ein Konto, alle Geräte</span></div>
          </div>
        </section>

        {/* FUNKTIONEN */}
        <section id="product" aria-labelledby="h-funk">
          <div className="wrap">
            <div className="reveal">
              <p className="eyebrow">Funktionen</p>
              <h2 id="h-funk">Alles, was bis zur Prüfung zählt. Nichts, was ablenkt.</h2>
            </div>
            <div className="bento">
              <article className="cell cell-a reveal">
                <div className="ico" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M9 11l3 3L22 4" /><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11" /></svg></div>
                <div className="cell-text">
                  <h3>Übungsprüfungen wie am Prüfungstag</h3>
                  <p>Timer, Punkteverteilung und offene Aufgaben mit Korrektur. Danach siehst du pro Thema, wo es noch hakt.</p>
                </div>
                <Shot src="/screenshots/pruefung.png" alt="Übungsprüfung mit Timer und Ergebnis nach Themen" />
              </article>
              <article className="cell cell-b reveal">
                <div className="ico" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="12" r="9" /><path d="M12 7v5l3 2" /></svg></div>
                <h3>Tagesplan bis zum Termin</h3>
                <p>Du gibst dein Prüfungsdatum an, die App verteilt die offenen Themen auf die restlichen Tage.</p>
              </article>
              <article className="cell cell-c reveal">
                <div className="ico" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M21 12a9 9 0 1 1-3-6.7" /><path d="M21 3v6h-6" /></svg></div>
                <h3>Wiederholen im richtigen Moment</h3>
                <p>Falsch beantwortete Fragen kommen wieder, kurz bevor du sie vergisst.</p>
              </article>
              <article className="cell cell-d reveal">
                <div className="ico" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M4 19h16M6 19V9m6 10V5m6 14v-7" /></svg></div>
                <h3>Module mit Lernpfad</h3>
                <p>Netzwerke, Datenbanken, Programmierung, IT-Sicherheit, WiSo: jedes Thema von leicht nach schwer, mit Bestehensgrenze wie in der Prüfung.</p>
              </article>
              <article className="cell cell-e reveal">
                <div className="ico" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M17 11a5 5 0 1 0-10 0" /><path d="M3 21a7 7 0 0 1 18 0" /></svg></div>
                <h3>Arena: gegen andere Azubis</h3>
                <p>Zehn Fragen, ein Gegner, eine Rangliste. Für die Tage, an denen Karteikarten nicht reichen.</p>
              </article>
            </div>
          </div>
        </section>

        {/* ABLAUF */}
        <section id="ablauf" aria-labelledby="h-ablauf">
          <div className="wrap steps">
            <div className="sticky reveal">
              <h2 id="h-ablauf">Vom ersten Öffnen bis zum Prüfungstag.</h2>
              <p className="lead" style={{ marginTop: 16 }}>Kein Kurs, den man durcharbeitet. Ein Plan, der jeden Tag sagt, was dran ist.</p>
            </div>
            <ol className="steps-list">
              <li className="step reveal"><b>1</b><div><h3>Prüfung und Termin wählen</h3><p>AP1 oder AP2, Anwendungsentwicklung oder Systemintegration. Der Countdown läuft ab sofort.</p></div></li>
              <li className="step reveal"><b>2</b><div><h3>Jeden Tag den Plan abarbeiten</h3><p>Ein schwaches Thema, die fälligen Wiederholungen, alle sieben Tage eine Übungsprüfung. Meist 15 bis 25 Minuten.</p></div></li>
              <li className="step reveal"><b>3</b><div><h3>Schwächen gezielt schließen</h3><p>Die Auswertung zeigt pro Thema die Trefferquote. In der letzten Woche nur noch Wiederholen und Simulation.</p></div></li>
            </ol>
          </div>
        </section>

        {/* ADA */}
        <section id="ada" aria-labelledby="h-ada">
          <div className="wrap split">
            <figure className="reveal"><Shot src="/screenshots/ada.png" alt="Ada erklärt eine Subnetz-Berechnung Schritt für Schritt" /></figure>
            <div className="reveal">
              <h2 id="h-ada">Ada erklärt, warum die Antwort falsch war.</h2>
              <p className="lead" style={{ marginTop: 16 }}>Die KI-Tutorin kennt die Aufgabe, die du gerade bearbeitest, und antwortet auf Deutsch auf Prüfungsniveau.</p>
              <ul className="checks">
                <li><Check />Korrigiert offene Aufgaben nach IHK-Punkteschema</li>
                <li><Check />Rechnet Subnetze, RAID und Kalkulationen vor</li>
                <li><Check />Gibt keine Lösung vor, sondern den nächsten Schritt</li>
              </ul>
            </div>
          </div>
        </section>

        {/* PREISE */}
        <section id="pricing" aria-labelledby="h-preise">
          <div className="wrap">
            <div className="reveal">
              <p className="eyebrow">Preise</p>
              <h2 id="h-preise">Kostenlos anfangen. Premium, wenn es ernst wird.</h2>
            </div>
            <div className="plans">
              <article className="plan reveal">
                <div><h3>Kostenlos</h3><p className="body" style={{ marginTop: 6 }}>Zum Reinkommen und für die ersten Wochen.</p></div>
                <div className="price">0 €</div>
                <ul>
                  <li><Check />Basis-Levels aller Lernpfade</li>
                  <li><Check />Tagesplan, Karteikarten und Wiederholungen</li>
                  <li><Check />3 Arena-Duelle pro Tag</li>
                  <li><Check />Ada-Erklärungen bei Fehlern</li>
                  <li className="off"><Check />Praxis- und Prüfungs-Levels</li>
                  <li className="off"><Check />Übungsprüfungen mit Korrektur</li>
                </ul>
                <Link className="btn btn-ghost" href="/signup">Kostenlos starten</Link>
              </article>
              <article className="plan pro reveal">
                <div><h3>Premium</h3><p className="body" style={{ marginTop: 6 }}>Alle Module, alle Übungsprüfungen, Ada ohne Limit.</p></div>
                <div className="price">11,99 €<small>pro Monat</small></div>
                <ul>
                  <li><Check />Alle Levels und Themen ohne Kontingent</li>
                  <li><Check />Übungsprüfungen mit Korrektur und Auswertung</li>
                  <li><Check />KI-Tutorin Ada und Arena unbegrenzt</li>
                  <li><Check />Cloud-Zertifikate (AWS, Azure, GCP, SAP)</li>
                  <li><Check />6 Monate 47,99 € oder 12 Monate 84,99 €</li>
                </ul>
                <Link className="btn btn-primary" href="/upgrade">Premium starten</Link>
              </article>
            </div>
            <p className="plan-note">In der App über Google Play oder den App Store, im Web per Karte. Jederzeit kündbar. Alle Preise sind Endpreise.</p>
          </div>
        </section>

        {/* FAQ */}
        <section aria-labelledby="h-faq">
          <div className="wrap">
            <h2 id="h-faq" className="reveal">Häufige Fragen</h2>
            <div className="faq reveal">
              <Faq q="Sind das echte IHK-Prüfungsfragen?">Nein. Die IHK veröffentlicht ihre Prüfungen nicht. Unsere Aufgaben sind eigene Fragen nach dem Prüfungskatalog, in Aufbau, Schwierigkeit und Punkteschema an den Abschlussprüfungen orientiert.</Faq>
              <Faq q="Für welche Fachrichtungen ist die App?">Fachinformatiker Anwendungsentwicklung und Systemintegration, jeweils AP1 und AP2. Der Tagesplan blendet Module aus, die für deine Prüfung nicht relevant sind.</Faq>
              <Faq q="Funktioniert das auch bei einer Umschulung?">Ja. Die Prüfung ist dieselbe. Viele Nutzer sind Umschüler, die neben dem Unterricht in kurzen Einheiten lernen.</Faq>
              <Faq q="Kann ich ohne Konto ausprobieren?">Ja, als Gast in der App. Der Fortschritt bleibt erhalten, wenn du später ein Konto anlegst.</Faq>
            </div>
          </div>
        </section>

        {/* SCHLUSS */}
        <section id="laden" aria-labelledby="h-cta">
          <div className="wrap">
            <div className="cta-box reveal">
              <div>
                <h2 id="h-cta">Heute anfangen kostet nichts. Die Nachprüfung schon.</h2>
                <p className="lead" style={{ marginTop: 14 }}>Kostenlos für Android und iOS. Kein Konto nötig, um loszulegen.</p>
              </div>
              <div className="stores">
                <a href={PLAY_URL} target="_blank" rel="noopener noreferrer" aria-label="Lernarena bei Google Play laden">
                  {/* eslint-disable-next-line @next/next/no-img-element */}
                  <img src="/badges/google-play-de.png" alt="Jetzt bei Google Play" width={811} height={241} />
                </a>
                <a href={APPSTORE_URL} target="_blank" rel="noopener noreferrer" aria-label="Lernarena im App Store laden">
                  {/* eslint-disable-next-line @next/next/no-img-element */}
                  <img src="https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/de-de?size=250x83" alt="Laden im App Store" width={250} height={83} />
                </a>
              </div>
            </div>
          </div>
        </section>
    </PageShell>
  );
}
