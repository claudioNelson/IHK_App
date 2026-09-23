"use client";

// Startseite lernarena.app (Neuaufbau 23.09.2026, Vorlage lernarena-landing-v2).
//
// Bewusst erhalten aus der alten Seite: Client-Komponente mit Auth-Nav
// (Name, Premium-Badge, Logout), Theme-Umschalter mit localStorage-Key
// "lernarena-theme" (gilt fuer alle Seiten, siehe layout.tsx), die Anker
// #product / #ada / #pricing und alle Routen. Schrift ist Geist aus
// layout.tsx (next/font), Farben laufen ueber CSS-Variablen, damit der
// Hellmodus ohne React-State funktioniert (data-theme am <html>).
//
// Screenshots liegen unter /public/screenshots/ (hub.png, pruefung.png,
// ada.png; 1290x2796). Fehlt eine Datei, bleibt die Flaeche leer.

import { useState, useEffect, type ReactNode } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import { useSubscription } from "@/lib/hooks/useSubscription";

const PLAY_URL = "https://play.google.com/store/apps/details?id=app.lernarena";
const APPSTORE_URL = "https://apps.apple.com/de/app/id6802045311";

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
  const [isDark, setIsDark] = useState(true);
  const [mounted, setMounted] = useState(false);
  const [username, setUsername] = useState<string | null>(null);
  const [authLoaded, setAuthLoaded] = useState(false);
  const [menuOpen, setMenuOpen] = useState(false);
  const router = useRouter();
  const supabase = createClient();
  const subscription = useSubscription();

  // Auth-State laden + auf Aenderungen reagieren (Login/Logout in anderem Tab)
  useEffect(() => {
    let alive = true;
    const loadUser = async () => {
      const { data: { user } } = await supabase.auth.getUser();
      if (!alive) return;
      setUsername(user ? ((user.user_metadata?.username as string) ?? user.email ?? "User") : null);
      setAuthLoaded(true);
    };
    loadUser();
    const { data: { subscription: sub } } = supabase.auth.onAuthStateChange((_event, session) => {
      if (!alive) return;
      const u = session?.user;
      setUsername(u ? ((u.user_metadata?.username as string) ?? u.email ?? "User") : null);
    });
    return () => {
      alive = false;
      sub.unsubscribe();
    };
  }, [supabase]);

  // Theme: layout.tsx setzt data-theme vor dem ersten Paint; hier nur State
  // dazu synchronisieren und den Umschalter bedienen.
  useEffect(() => {
    setMounted(true);
    try {
      if (localStorage.getItem("lernarena-theme") === "light") setIsDark(false);
    } catch {}
  }, []);

  useEffect(() => {
    if (!mounted) return;
    try {
      localStorage.setItem("lernarena-theme", isDark ? "dark" : "light");
    } catch {}
    if (isDark) document.documentElement.removeAttribute("data-theme");
    else document.documentElement.setAttribute("data-theme", "light");
  }, [isDark, mounted]);

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

  const handleLogout = async () => {
    await supabase.auth.signOut();
    router.refresh();
  };

  const isPremium = subscription.loaded && subscription.isPremium;

  return (
    <div className="lp">
      <style>{`
        .lp {
          --bg: #0B0B10; --bg-2: #101018; --surface: #14141D; --surface-2: #1B1B27;
          --line: rgba(255,255,255,.08); --line-2: rgba(255,255,255,.14);
          --text: #F2F2F6; --text-2: #A9A9B8; --text-3: #7C7C8C;
          --accent: #7C6DFF; --accent-2: #6B5DF0; --accent-soft: rgba(124,109,255,.14);
          --ok: #10B981;
          --r: 14px; --r-btn: 10px; --r-shot: 22px; --wrap: 1200px;
          background: var(--bg); color: var(--text); min-height: 100vh;
          font-family: var(--font-geist-sans), system-ui, sans-serif;
          line-height: 1.5; -webkit-font-smoothing: antialiased;
        }
        :root[data-theme="light"] .lp {
          --bg: #F3F4F9; --bg-2: #ECEDF4; --surface: #FFFFFF; --surface-2: #FFFFFF;
          --line: rgba(20,26,46,.10); --line-2: rgba(20,26,46,.18);
          --text: #0F1222; --text-2: #4E5364; --text-3: #7A7F90;
          --accent: #5B4BE0; --accent-2: #4C3ED0; --accent-soft: rgba(91,75,224,.12);
        }
        .lp a { color: inherit; text-decoration: none; }
        .lp h1, .lp h2, .lp h3, .lp p, .lp ul, .lp figure { margin: 0; }
        .lp ul { padding: 0; list-style: none; }
        .lp img, .lp svg { display: block; max-width: 100%; }
        .lp button { font: inherit; }
        .wrap { width: 100%; max-width: var(--wrap); margin: 0 auto; padding-inline: 20px; }
        .lp section { padding-block: clamp(64px, 8vw, 112px); }
        .lp section + section { border-top: 1px solid var(--line); }

        .lp h1 { font-size: clamp(38px, 5vw, 64px); line-height: 1.04; letter-spacing: -.035em; font-weight: 600; }
        .lp h2 { overflow-wrap: anywhere; font-size: clamp(30px, 3.4vw, 44px); line-height: 1.08; letter-spacing: -.03em; font-weight: 600; max-width: 22ch; }
        .lp h3 { font-size: 19px; line-height: 1.3; letter-spacing: -.01em; font-weight: 600; }
        .lead { font-size: clamp(16px, 1.4vw, 19px); color: var(--text-2); max-width: 56ch; }
        .body { font-size: 15.5px; color: var(--text-2); max-width: 60ch; }
        .eyebrow { font-family: var(--font-geist-mono), ui-monospace, monospace; font-size: 11.5px; font-weight: 600; letter-spacing: .16em; text-transform: uppercase; color: var(--accent); margin-bottom: 14px; }
        .num { font-family: var(--font-geist-mono), ui-monospace, monospace; font-variant-numeric: tabular-nums; }

        .btn { display: inline-flex; align-items: center; justify-content: center; gap: 10px; min-height: 50px; padding: 0 22px; border-radius: var(--r-btn); font-weight: 600; font-size: 15px; white-space: nowrap; border: 1px solid transparent; transition: transform .15s ease, background .2s ease, border-color .2s ease; cursor: pointer; }
        .btn:active { transform: translateY(1px) scale(.985); }
        .btn-primary { background: var(--accent); color: #fff; }
        .btn-primary:hover { background: var(--accent-2); }
        .btn-ghost { background: transparent; color: var(--text); border-color: var(--line-2); }
        .btn-ghost:hover { border-color: var(--accent); }

        /* Screenshots in natuerlicher Hoehe (kein Beschneiden); nur ein leerer
           Slot bekommt eine feste Proportion, damit die Flaeche nicht kollabiert. */
        .shot { border-radius: var(--r-shot); border: 1px solid var(--line-2); background: var(--surface); overflow: hidden; }
        .shot:empty { aspect-ratio: 9 / 16; }
        .shot img { width: 100%; height: auto; }

        /* Nav */
        .lp header { position: sticky; top: 0; z-index: 20; background: color-mix(in srgb, var(--bg) 84%, transparent); backdrop-filter: blur(14px); -webkit-backdrop-filter: blur(14px); border-bottom: 1px solid var(--line); }
        .nav { height: 68px; display: flex; align-items: center; justify-content: space-between; gap: 24px; }
        .logo { display: flex; align-items: center; gap: 10px; font-weight: 700; font-size: 19px; letter-spacing: -.02em; }
        .logo-mark { width: 26px; height: 26px; border-radius: 8px; background: var(--accent); display: grid; place-items: center; }
        .logo-mark svg { width: 14px; height: 14px; }
        .nav-links { display: flex; gap: 30px; }
        .nav-links a { font-size: 14.5px; font-weight: 500; color: var(--text-2); }
        .nav-links a:hover { color: var(--text); }
        .nav-actions { display: flex; align-items: center; gap: 10px; }
        .nav-actions .btn { min-height: 42px; padding: 0 16px; font-size: 14px; }
        .theme-btn { width: 40px; height: 40px; border-radius: var(--r-btn); border: 1px solid var(--line-2); background: transparent; color: var(--text-2); display: grid; place-items: center; cursor: pointer; }
        .theme-btn:hover { color: var(--text); border-color: var(--accent); }
        .theme-btn svg { width: 17px; height: 17px; }
        .nav-user { display: inline-flex; align-items: center; gap: 8px; font-size: 14px; font-weight: 500; color: var(--text-2); }
        .nav-user:hover { color: var(--text); }
        .nav-avatar { width: 28px; height: 28px; border-radius: 50%; background: var(--accent-soft); color: var(--accent); display: grid; place-items: center; font-size: 12px; font-weight: 700; }
        .nav-premium { font-family: var(--font-geist-mono), monospace; font-size: 10.5px; font-weight: 700; letter-spacing: .08em; text-transform: uppercase; color: var(--accent); background: var(--accent-soft); padding: 4px 7px; border-radius: 6px; }
        .burger { display: none; width: 42px; height: 42px; border-radius: var(--r-btn); background: transparent; border: 1px solid var(--line-2); color: var(--text); place-items: center; cursor: pointer; }
        .burger svg { width: 20px; height: 20px; }
        .nav-mobile { display: none; flex-direction: column; padding: 6px 0 14px; border-top: 1px solid var(--line); }
        .nav-mobile a, .nav-mobile button { padding: 12px 4px; font-size: 16px; font-weight: 500; color: var(--text-2); background: none; border: 0; text-align: left; cursor: pointer; }
        .nav-mobile.open { display: flex; }

        /* Hero */
        .lp .hero { padding-top: clamp(40px, 6vw, 72px); padding-bottom: clamp(48px, 6vw, 80px); }
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
        .cell { position: relative; border: 1px solid var(--line); border-radius: var(--r); background: var(--surface); padding: 26px; display: flex; flex-direction: column; justify-content: flex-end; gap: 8px; overflow: hidden; }
        .cell p { color: var(--text-2); font-size: 14.5px; max-width: 40ch; }
        .cell-a { grid-column: span 4; grid-row: span 2; display: grid; grid-template-columns: minmax(0, 1fr) 260px; grid-template-rows: auto 1fr; gap: 20px 28px; align-items: end; }
        .cell-a .ico { grid-column: 1; grid-row: 1; align-self: start; margin-bottom: 0; }
        .cell-a .cell-text { grid-column: 1; grid-row: 2; max-width: none; }
        .cell-a .shot { grid-column: 2; grid-row: 1 / span 2; width: 100%; }
        .cell-b { grid-column: span 2; background: linear-gradient(160deg, rgba(124,109,255,.22), rgba(124,109,255,.04) 60%), var(--surface); }
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
        .plan { border: 1px solid var(--line); border-radius: var(--r); background: var(--surface); padding: 30px; display: flex; flex-direction: column; gap: 22px; }
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
        .cta-box { border: 1px solid var(--line-2); border-radius: var(--r); background: var(--surface); padding: clamp(32px, 5vw, 56px); display: grid; grid-template-columns: minmax(0, 1.4fr) minmax(0, auto); gap: 32px; align-items: center; }
        .stores { display: flex; gap: 12px; flex-wrap: wrap; min-width: 0; }
        .stores a { display: block; }
        .stores img { height: 52px; width: auto; }

        .lp footer { border-top: 1px solid var(--line); padding: 40px 0 32px; }
        .foot { display: grid; grid-template-columns: 1.4fr 1fr 1fr 1fr; gap: 28px; font-size: 14px; }
        .foot h4 { margin: 0 0 12px; font-size: 13px; font-weight: 600; color: var(--text); }
        .foot li { margin: 0 0 8px; }
        .foot a { color: var(--text-3); }
        .foot a:hover { color: var(--text); }
        .foot-tag { color: var(--text-3); margin-top: 10px; max-width: 32ch; }
        .foot-bottom { margin-top: 28px; padding-top: 18px; border-top: 1px solid var(--line); font-size: 13px; color: var(--text-3); }

        /* Motion */
        .reveal { opacity: 0; transform: translateY(18px); transition: opacity .6s cubic-bezier(.16,1,.3,1), transform .6s cubic-bezier(.16,1,.3,1); }
        .reveal.in { opacity: 1; transform: none; }
        @media (prefers-reduced-motion: reduce) {
          .reveal { opacity: 1; transform: none; transition: none; }
          .btn, .faq summary svg { transition: none; }
        }

        /* Mobil */
        @media (max-width: 1023px) {
          .nav-links, .nav-actions .btn-ghost, .nav-user span.name { display: none; }
        }
        @media (max-width: 767px) {
          .nav-actions .btn, .nav-user, .nav-premium { display: none; }
          .burger { display: grid; }
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
          .foot { grid-template-columns: 1fr 1fr; }
        }
      `}</style>

      <header>
        <div className="wrap nav">
          <Link className="logo" href="/">
            <span className="logo-mark" aria-hidden="true">
              <svg viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><path d="M5 12l4 4L19 6" /></svg>
            </span>
            Lernarena
          </Link>
          <nav className="nav-links" aria-label="Hauptnavigation">
            <a href="#product">Funktionen</a>
            <a href="#ablauf">So läuft es</a>
            <a href="#pricing">Preise</a>
            <Link href="/lernen">Lernseiten</Link>
            <Link href="/pruefungen">Prüfungen</Link>
          </nav>
          <div className="nav-actions">
            <button className="theme-btn" onClick={() => setIsDark(!isDark)} aria-label={isDark ? "Hellen Modus einschalten" : "Dunklen Modus einschalten"}>
              {isDark ? (
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round"><circle cx="12" cy="12" r="4" /><path d="M12 2v2M12 20v2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M2 12h2M20 12h2M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4" /></svg>
              ) : (
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M21 12.8A9 9 0 1 1 11.2 3a7 7 0 0 0 9.8 9.8z" /></svg>
              )}
            </button>
            {authLoaded && (username ? (
              <>
                <Link href="/profil" className="nav-user" title="Dein Profil">
                  <span className="nav-avatar">{username.charAt(0).toUpperCase()}</span>
                  <span className="name">{username}</span>
                </Link>
                {isPremium && <span className="nav-premium" title={subscription.expiryLabel}>Premium</span>}
                <button className="btn btn-ghost" onClick={handleLogout}>Logout</button>
              </>
            ) : (
              <>
                <Link className="btn btn-ghost" href="/login">Anmelden</Link>
                <Link className="btn btn-primary" href="#laden">App laden</Link>
              </>
            ))}
            <button className="burger" aria-label={menuOpen ? "Menü schließen" : "Menü öffnen"} aria-expanded={menuOpen} onClick={() => setMenuOpen(!menuOpen)}>
              {menuOpen ? (
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round"><path d="M6 6l12 12M18 6L6 18" /></svg>
              ) : (
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round"><path d="M4 7h16M4 12h16M4 17h16" /></svg>
              )}
            </button>
          </div>
        </div>
        <div className="wrap">
          <nav className={`nav-mobile${menuOpen ? " open" : ""}`} aria-label="Mobile Navigation" onClick={() => setMenuOpen(false)}>
            <a href="#product">Funktionen</a>
            <a href="#ablauf">So läuft es</a>
            <a href="#pricing">Preise</a>
            <Link href="/lernen">Lernseiten</Link>
            <Link href="/pruefungen">Prüfungen</Link>
            {username ? (
              <>
                <Link href="/profil">Profil{isPremium ? " · Premium" : ""}</Link>
                <button onClick={handleLogout}>Logout</button>
              </>
            ) : (
              <>
                <Link href="/login">Anmelden</Link>
                <a href="#laden">App laden</a>
              </>
            )}
          </nav>
        </div>
      </header>

      <main>
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
      </main>

      <footer>
        <div className="wrap">
          <div className="foot">
            <div>
              <Link className="logo" href="/">
                <span className="logo-mark" aria-hidden="true">
                  <svg viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><path d="M5 12l4 4L19 6" /></svg>
                </span>
                Lernarena
              </Link>
              <p className="foot-tag">Prüfungsvorbereitung für Fachinformatiker. Kein Angebot der IHK.</p>
            </div>
            <div>
              <h4>Produkt</h4>
              <ul>
                <li><a href="#product">Funktionen</a></li>
                <li><a href="#pricing">Preise</a></li>
                <li><a href="#ada">Ada</a></li>
                <li><Link href="/pruefungen">Prüfungen</Link></li>
                <li><Link href="/fachinformatiker-pruefung">Prüfungs-Guide</Link></li>
              </ul>
            </div>
            <div>
              <h4>Konto</h4>
              <ul>
                <li><Link href="/lernen">Lernseiten</Link></li>
                <li><a href={PLAY_URL} target="_blank" rel="noopener noreferrer">Android-App</a></li>
                <li><a href={APPSTORE_URL} target="_blank" rel="noopener noreferrer">iPhone-App</a></li>
                <li><Link href="/login">Anmelden</Link></li>
                <li><Link href="/signup">Registrieren</Link></li>
                <li><a href="mailto:info@lernarena.app">Kontakt</a></li>
              </ul>
            </div>
            <div>
              <h4>Rechtliches</h4>
              <ul>
                <li><Link href="/impressum">Impressum</Link></li>
                <li><Link href="/datenschutz">Datenschutz</Link></li>
                <li><Link href="/agb">AGB</Link></li>
                <li><Link href="/account-loeschung">Konto löschen</Link></li>
              </ul>
            </div>
          </div>
          <div className="foot-bottom">© {new Date().getFullYear()} Lernarena</div>
        </div>
      </footer>
    </div>
  );
}
