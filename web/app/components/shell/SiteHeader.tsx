"use client";

// Gemeinsamer Seitenkopf fuer lernarena.app (aus der Startseite herausgeloest,
// 23.09.2026). Logo, Navigation, Theme-Umschalter, Login-Status mit Name und
// Premium-Badge, Burger-Menue auf dem Handy. Styles liegen in globals.css
// (.site-header, .nav, ...), Tokens am :root.
//
// Theme: layout.tsx setzt data-theme="light" vor dem ersten Paint aus dem
// localStorage-Key "lernarena-theme". Hier wird nur der Umschalter bedient.

import { useEffect, useState } from "react";
import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import { useSubscription } from "@/lib/hooks/useSubscription";

export type NavLink = { href: string; label: string };

export const DEFAULT_LINKS: NavLink[] = [
  { href: "/lernen", label: "Lernseiten" },
  { href: "/pruefungen", label: "Prüfungen" },
  { href: "/python-kurs", label: "Python-Kurs" },
  { href: "/fachinformatiker-pruefung", label: "Prüfungs-Guide" },
  { href: "/#pricing", label: "Preise" },
];

export function LogoMark() {
  return (
    <span className="logo-mark" aria-hidden="true">
      <svg viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
        <path d="M5 12l4 4L19 6" />
      </svg>
    </span>
  );
}

function useThemeToggle() {
  const [isDark, setIsDark] = useState(true);
  const [mounted, setMounted] = useState(false);

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

  return { isDark, toggle: () => setIsDark((d) => !d) };
}

export default function SiteHeader({
  links = DEFAULT_LINKS,
  cta = { href: "/#laden", label: "App laden" },
}: {
  links?: NavLink[];
  cta?: NavLink | null;
}) {
  const [username, setUsername] = useState<string | null>(null);
  const [authLoaded, setAuthLoaded] = useState(false);
  const [menuOpen, setMenuOpen] = useState(false);
  const pathname = usePathname();
  const router = useRouter();
  const supabase = createClient();
  const subscription = useSubscription();
  const { isDark, toggle } = useThemeToggle();

  useEffect(() => {
    let alive = true;
    const name = (u: { user_metadata?: Record<string, unknown>; email?: string } | null | undefined) =>
      u ? ((u.user_metadata?.username as string | undefined) ?? u.email ?? "Konto") : null;
    supabase.auth.getUser().then(({ data: { user } }) => {
      if (!alive) return;
      setUsername(name(user));
      setAuthLoaded(true);
    });
    const { data: { subscription: sub } } = supabase.auth.onAuthStateChange((_event, session) => {
      if (alive) setUsername(name(session?.user));
    });
    return () => {
      alive = false;
      sub.unsubscribe();
    };
  }, [supabase]);

  // Menue bei Seitenwechsel schliessen
  useEffect(() => setMenuOpen(false), [pathname]);

  const handleLogout = async () => {
    await supabase.auth.signOut();
    router.refresh();
  };

  const isPremium = subscription.loaded && subscription.isPremium;
  const isCurrent = (href: string) => !href.includes("#") && (pathname === href || pathname.startsWith(href + "/"));

  return (
    <header className="site-header">
      <div className="wrap nav">
        <Link className="logo" href="/">
          <LogoMark />
          Lernarena
        </Link>
        <nav className="nav-links" aria-label="Hauptnavigation">
          {links.map((l) => (
            <Link key={l.href} href={l.href} aria-current={isCurrent(l.href) ? "page" : undefined}>
              {l.label}
            </Link>
          ))}
        </nav>
        <div className="nav-actions">
          <button className="theme-btn" onClick={toggle} aria-label={isDark ? "Hellen Modus einschalten" : "Dunklen Modus einschalten"}>
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
              <button className="btn btn-ghost btn-sm" onClick={handleLogout}>Abmelden</button>
            </>
          ) : (
            <>
              <Link className="btn btn-ghost btn-sm" href="/login">Anmelden</Link>
              {cta && <Link className="btn btn-primary btn-sm" href={cta.href}>{cta.label}</Link>}
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
          {links.map((l) => (
            <Link key={l.href} href={l.href}>{l.label}</Link>
          ))}
          {username ? (
            <>
              <Link href="/profil">Profil{isPremium ? " · Premium" : ""}</Link>
              <button onClick={handleLogout}>Abmelden</button>
            </>
          ) : (
            <>
              <Link href="/login">Anmelden</Link>
              {cta && <Link href={cta.href}>{cta.label}</Link>}
            </>
          )}
        </nav>
      </div>
    </header>
  );
}
