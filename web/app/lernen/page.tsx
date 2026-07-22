import type { Metadata } from "next";
import Link from "next/link";

export const metadata: Metadata = {
  title: "Lernthemen — IT-Grundlagen für die IHK-Prüfung üben",
  description:
    "Alle Lernthemen für die Fachinformatiker-Prüfung: Subnetting, RAID, OSI-Modell, SQL, Normalisierung, Sortieralgorithmen und mehr — kostenlos erklärt mit interaktiven Übungsaufgaben.",
  alternates: {
    canonical: "https://lernarena.app/lernen",
  },
  openGraph: {
    type: "website",
    locale: "de_DE",
    url: "https://lernarena.app/lernen",
    siteName: "Lernarena",
    title: "Lernthemen — IT-Grundlagen für die IHK-Prüfung üben",
    description:
      "Subnetting, RAID, OSI-Modell, SQL und mehr — kostenlos erklärt mit interaktiven Übungsaufgaben für Fachinformatiker.",
  },
};

const themen: { href: string; titel: string; desc: string; tag: string }[] = [
  {
    href: "/lernen/subnetting",
    titel: "Subnetting üben",
    desc: "Subnetzmaske, CIDR, Netz- und Broadcast-Adresse Schritt für Schritt berechnen.",
    tag: "Netzwerk",
  },
  {
    href: "/lernen/ip-adressen",
    titel: "IP-Adressen & IPv6",
    desc: "Private Bereiche, APIPA und die IPv6-Kürzungsregeln sicher beherrschen.",
    tag: "Netzwerk",
  },
  {
    href: "/lernen/osi-modell",
    titel: "OSI-Modell",
    desc: "Die 7 Schichten mit Protokollen, Geräten und Merksatz.",
    tag: "Netzwerk",
  },
  {
    href: "/lernen/raid",
    titel: "RAID Level",
    desc: "RAID 0, 1, 5, 6 und 10 im Vergleich — mit Kapazitätsberechnung.",
    tag: "Systemintegration",
  },
  {
    href: "/lernen/zahlensysteme",
    titel: "Zahlensysteme",
    desc: "Binär, dezimal und hexadezimal umrechnen — die Grundlage für AP1 und Subnetting.",
    tag: "Grundlagen",
  },
  {
    href: "/lernen/sql",
    titel: "SQL üben",
    desc: "SELECT, JOIN, GROUP BY und HAVING mit typischen Prüfungsbeispielen.",
    tag: "Datenbanken",
  },
  {
    href: "/lernen/er-diagramm",
    titel: "ER-Diagramm",
    desc: "Entitäten, Kardinalitäten und die n:m-Auflösung über Zwischentabellen.",
    tag: "Datenbanken",
  },
  {
    href: "/lernen/normalisierung",
    titel: "Normalisierung",
    desc: "1. bis 3. Normalform mit Beispielen, Anomalien und Merksätzen.",
    tag: "Datenbanken",
  },
  {
    href: "/lernen/sortieralgorithmen",
    titel: "Sortieralgorithmen",
    desc: "Bubblesort, Quicksort und Mergesort — Laufzeiten, Stabilität, Durchläufe.",
    tag: "Anwendungsentwicklung",
  },
  {
    href: "/lernen/nutzwertanalyse",
    titel: "Nutzwertanalyse",
    desc: "Kriterien gewichten, Punkte vergeben, Nutzwert berechnen — der AP1-Klassiker.",
    tag: "WiSo / AP1",
  },
];

export default function LernenUebersicht() {
  return (
    <main className="lv-wrap">
      <style>{`
        .lv-wrap {
          font-family: var(--font-geist-sans), system-ui, sans-serif;
          background: #08080C;
          color: #F5F5F7;
          min-height: 100vh;
          line-height: 1.65;
        }
        .lv-container { max-width: 900px; margin: 0 auto; padding: 72px 24px 96px; }
        .lv-crumb { font-size: 14px; color: #7C6DFF; margin-bottom: 24px; }
        .lv-crumb a { color: #7C6DFF; text-decoration: none; }
        .lv-crumb a:hover { text-decoration: underline; }
        .lv-wrap h1 {
          font-size: clamp(32px, 5vw, 46px);
          line-height: 1.1; letter-spacing: -0.02em;
          margin: 0 0 16px; font-weight: 700;
        }
        .lv-lead { font-size: 19px; color: #A0A0B0; margin: 0 0 40px; max-width: 640px; }
        .lv-grid {
          display: grid;
          grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
          gap: 16px;
        }
        .lv-card {
          display: block;
          background: #12121C;
          border: 1px solid rgba(255,255,255,0.08);
          border-radius: 16px;
          padding: 22px 24px;
          text-decoration: none;
          transition: transform .12s ease, border-color .12s ease, background .12s ease;
        }
        .lv-card:hover {
          transform: translateY(-3px);
          border-color: rgba(124,109,255,0.5);
          background: #151521;
        }
        .lv-tag {
          display: inline-block;
          font-size: 12px;
          font-weight: 600;
          letter-spacing: 0.05em;
          text-transform: uppercase;
          color: #C4BBFF;
          background: rgba(124,109,255,0.14);
          border-radius: 6px;
          padding: 3px 8px;
          margin-bottom: 12px;
        }
        .lv-card h2 { color: #F5F5F7; font-size: 19px; margin: 0 0 8px; font-weight: 650; }
        .lv-card p { color: #A0A0B0; font-size: 14.5px; margin: 0; }
        .lv-final {
          text-align: center; background: linear-gradient(180deg, #12121C, #0E0E14);
          border: 1px solid rgba(124,109,255,0.25); border-radius: 20px;
          padding: 40px 28px; margin: 56px 0 0;
        }
        .lv-final h2 { margin: 0 0 12px; font-size: 26px; }
        .lv-final p { color: #C8C8D2; max-width: 520px; margin: 0 auto 20px; }
        .lv-cta-row { display: flex; gap: 12px; flex-wrap: wrap; justify-content: center; }
        .lv-btn {
          display: inline-block; padding: 13px 26px; border-radius: 12px;
          font-weight: 600; font-size: 16px; text-decoration: none; transition: transform .12s ease;
        }
        .lv-btn-primary { background: #7C6DFF; color: #fff; box-shadow: 0 10px 30px rgba(124,109,255,0.35); }
        .lv-btn-primary:hover { transform: translateY(-2px); }
        .lv-btn-ghost { background: rgba(255,255,255,0.06); color: #F5F5F7; border: 1px solid rgba(255,255,255,0.12); }
        .lv-btn-ghost:hover { background: rgba(255,255,255,0.1); }
      `}</style>

      <div className="lv-container">
        <nav className="lv-crumb">
          <Link href="/">Lernarena</Link> · Lernen
        </nav>

        <h1>Lernthemen für die IHK-Prüfung</h1>
        <p className="lv-lead">
          Die wichtigsten Themen der Fachinformatiker-Prüfung — kostenlos erklärt,
          mit Tabellen, Rechenwegen und interaktiven Übungsaufgaben. Wähle ein Thema
          und leg los.
        </p>

        <div className="lv-grid">
          {themen.map((t) => (
            <Link key={t.href} href={t.href} className="lv-card">
              <span className="lv-tag">{t.tag}</span>
              <h2>{t.titel}</h2>
              <p>{t.desc}</p>
            </Link>
          ))}
        </div>

        <section className="lv-final">
          <h2>Mehr als nur Theorie</h2>
          <p>
            In der Lernarena übst du alle Themen mit echten IHK-Prüfungsfragen,
            sofortigem Feedback und einem KI-Tutor, der dir jeden Schritt erklärt.
          </p>
          <div className="lv-cta-row">
            <Link href="/signup" className="lv-btn lv-btn-primary">Jetzt kostenlos starten</Link>
            <Link href="/pruefungen" className="lv-btn lv-btn-ghost">Alle Prüfungen ansehen</Link>
          </div>
        </section>
      </div>
    </main>
  );
}
