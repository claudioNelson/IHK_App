import type { Metadata } from "next";
import Link from "next/link";
import QuizFrage from "../_components/QuizFrage";
import SubnetzRechner from "../_components/SubnetzRechner";

export const metadata: Metadata = {
  title: "Subnetting üben — Rechner, Aufgaben & Lösungen (IHK)",
  description:
    "Subnetting einfach erklärt — mit kostenlosem Subnetz-Rechner inklusive Binär-Rechenweg, Schritt-für-Schritt-Beispiel und interaktiven Übungsaufgaben für die IHK-Prüfung als Fachinformatiker.",
  alternates: {
    canonical: "https://lernarena.app/lernen/subnetting",
  },
  openGraph: {
    type: "article",
    locale: "de_DE",
    url: "https://lernarena.app/lernen/subnetting",
    siteName: "Lernarena",
    title: "Subnetting üben — Rechner, Aufgaben & Lösungen (IHK)",
    description:
      "Subnetting Schritt für Schritt: Subnetzmaske, CIDR, Netz- und Broadcast-Adresse. Mit interaktiven Übungsaufgaben für die Fachinformatiker-Prüfung.",
  },
};

const cidrTable: { cidr: string; mask: string; addr: string; hosts: string }[] = [
  { cidr: "/24", mask: "255.255.255.0", addr: "256", hosts: "254" },
  { cidr: "/25", mask: "255.255.255.128", addr: "128", hosts: "126" },
  { cidr: "/26", mask: "255.255.255.192", addr: "64", hosts: "62" },
  { cidr: "/27", mask: "255.255.255.224", addr: "32", hosts: "30" },
  { cidr: "/28", mask: "255.255.255.240", addr: "16", hosts: "14" },
  { cidr: "/29", mask: "255.255.255.248", addr: "8", hosts: "6" },
  { cidr: "/30", mask: "255.255.255.252", addr: "4", hosts: "2" },
];

const faq: { q: string; a: string }[] = [
  {
    q: "Was ist Subnetting?",
    a: "Subnetting ist das Aufteilen eines IP-Netzes in mehrere kleinere Teilnetze (Subnetze). Dazu werden Bits aus dem Host-Teil der IP-Adresse für den Netz-Teil verwendet. So lassen sich IP-Adressen effizient nutzen und Netze logisch trennen.",
  },
  {
    q: "Wie berechne ich die Anzahl der nutzbaren Hosts?",
    a: "Die Anzahl nutzbarer Hosts ergibt sich aus 2 hoch (32 minus Präfixlänge) minus 2. Die zwei abgezogenen Adressen sind die Netzadresse und die Broadcast-Adresse. Beispiel: /26 ergibt 2^6 − 2 = 62 nutzbare Hosts.",
  },
  {
    q: "Was bedeutet die CIDR-Schreibweise, z. B. /26?",
    a: "Die Zahl nach dem Schrägstrich (das Präfix) gibt an, wie viele Bits der IP-Adresse zum Netz-Teil gehören. /26 bedeutet, dass die ersten 26 Bit das Netz beschreiben und die restlichen 6 Bit für Hosts zur Verfügung stehen.",
  },
  {
    q: "Kommt Subnetting in der IHK-Prüfung vor?",
    a: "Ja. Subnetting ist ein klassisches Thema in der Abschlussprüfung Teil 1 (AP1) und in der AP2 für Fachinformatiker Systemintegration. Typische Aufgaben sind das Berechnen von Subnetzmaske, Netz- und Broadcast-Adresse sowie der Anzahl der Hosts.",
  },
];

export default function SubnettingPage() {
  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    mainEntity: faq.map((f) => ({
      "@type": "Question",
      name: f.q,
      acceptedAnswer: { "@type": "Answer", text: f.a },
    })),
  };

  return (
    <main className="sn-wrap">
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
      />

      <style>{`
        .sn-wrap {
          --bg: #08080C; --bg-muted: #0E0E14; --surface: #12121C; --surface-2: #151521;
          --border: rgba(255,255,255,0.08); --border-strong: rgba(255,255,255,0.14);
          --text: #F5F5F7; --text-body: #C8C8D2; --text-dim: #A0A0B0;
          --accent: #7C6DFF; --accent-soft: rgba(124,109,255,0.14); --accent-text: #C4BBFF;
          --chip-bg: rgba(255,255,255,0.05); --chip-border: rgba(255,255,255,0.1);
          --input-bg: rgba(255,255,255,0.05); --input-border: rgba(255,255,255,0.15);
          --pre-bg: rgba(0,0,0,0.35);
          --ok: #5FD98A; --ok-bg: rgba(52,199,89,0.16); --ok-border: rgba(52,199,89,0.6); --ok-text: #B8F0C4;
          --err: #FF6B63; --err-bg: rgba(255,69,58,0.16); --err-border: rgba(255,69,58,0.6); --err-text: #A32620;
          font-family: var(--font-geist-sans), system-ui, sans-serif;
          background: var(--bg);
          color: var(--text);
          min-height: 100vh;
          line-height: 1.65;
        }
        html[data-theme="light"] .sn-wrap {
          --bg: #FAFAF9; --bg-muted: #F4F4F1; --surface: #FFFFFF; --surface-2: #FFFFFF;
          --border: rgba(10,10,15,0.10); --border-strong: rgba(10,10,15,0.18);
          --text: #0A0A0F; --text-body: #3A3A44; --text-dim: #6A6A74;
          --accent: #6A5AE8; --accent-soft: rgba(106,90,232,0.10); --accent-text: #5B4BE0;
          --chip-bg: rgba(10,10,15,0.04); --chip-border: rgba(10,10,15,0.12);
          --input-bg: #FFFFFF; --input-border: rgba(10,10,15,0.18);
          --pre-bg: rgba(10,10,15,0.05);
          --ok: #1E9E50; --ok-bg: rgba(30,158,80,0.10); --ok-border: rgba(30,158,80,0.45); --ok-text: #14713A;
          --err: #D93B33; --err-bg: rgba(217,59,51,0.08); --err-border: rgba(217,59,51,0.45); --err-text: #A32620;
        }
        .sn-container { max-width: 780px; margin: 0 auto; padding: 72px 24px 96px; }
        .sn-crumb { font-size: 14px; color: var(--accent); margin-bottom: 24px; }
        .sn-crumb a { color: var(--accent); text-decoration: none; }
        .sn-crumb a:hover { text-decoration: underline; }
        .sn-wrap h1 {
          font-size: clamp(32px, 5vw, 46px);
          line-height: 1.1; letter-spacing: -0.02em;
          margin: 0 0 16px; font-weight: 700;
        }
        .sn-lead { font-size: 19px; color: var(--text-dim); margin: 0 0 32px; }
        .sn-wrap h2 { font-size: 26px; letter-spacing: -0.01em; margin: 48px 0 16px; font-weight: 650; }
        .sn-wrap h3 { font-size: 19px; margin: 28px 0 8px; font-weight: 600; }
        .sn-wrap p { color: var(--text-body); margin: 0 0 16px; }
        .sn-wrap strong { color: var(--text); }
        .sn-cta-row { display: flex; gap: 12px; flex-wrap: wrap; margin: 8px 0; }
        .sn-btn {
          display: inline-block; padding: 13px 26px; border-radius: 12px;
          font-weight: 600; font-size: 16px; text-decoration: none; transition: transform .12s ease;
        }
        .sn-btn-primary { background: #7C6DFF; color: #fff; box-shadow: 0 10px 30px rgba(124,109,255,0.35); }
        .sn-btn-primary:hover { transform: translateY(-2px); }
        .sn-btn-ghost { background: var(--chip-bg); color: var(--text); border: 1px solid var(--chip-border); }
        .sn-btn-ghost:hover { background: var(--accent-soft); }
        .sn-table { width: 100%; border-collapse: collapse; margin: 16px 0 8px; font-size: 15px; }
        .sn-table th, .sn-table td { text-align: left; padding: 11px 14px; border-bottom: 1px solid var(--border); }
        .sn-table th { color: var(--text-dim); font-weight: 600; font-size: 13px; text-transform: uppercase; letter-spacing: 0.04em; }
        .sn-table td { color: var(--text-body); }
        .sn-table td:first-child { font-weight: 600; color: var(--accent-text); white-space: nowrap; }
        .sn-card { background: var(--surface); border: 1px solid var(--border); border-radius: 16px; padding: 24px 26px; margin: 20px 0; }
        .sn-mono {
          font-family: var(--font-geist-mono), ui-monospace, monospace;
          background: var(--accent-soft); color: var(--accent-text);
          padding: 2px 7px; border-radius: 6px; font-size: 0.92em;
        }
        .sn-related { display: flex; gap: 12px; flex-wrap: wrap; margin-top: 12px; }
        .sn-chip {
          display: inline-block; padding: 10px 16px; border-radius: 10px;
          background: var(--chip-bg); border: 1px solid var(--chip-border);
          color: var(--text-body); text-decoration: none; font-size: 15px;
        }
        .sn-chip:hover { background: var(--accent-soft); border-color: var(--accent); }
        .sn-final {
          text-align: center; background: linear-gradient(180deg, var(--surface), var(--bg-muted));
          border: 1px solid rgba(124,109,255,0.25); border-radius: 20px;
          padding: 40px 28px; margin: 56px 0 0;
        }
        .sn-final h2 { margin-top: 0; }
`}</style>

      <div className="sn-container">
        <nav className="sn-crumb">
          <Link href="/">Lernarena</Link> · Subnetting üben
        </nav>

        <h1>Subnetting üben — einfach erklärt, mit Aufgaben und Lösungen</h1>
        <p className="sn-lead">
          Subnetting gehört zu den Klassikern der IHK-Prüfung für Fachinformatiker.
          Hier lernst du Schritt für Schritt, wie du Subnetzmaske, Netz- und
          Broadcast-Adresse sowie die Anzahl der Hosts berechnest — und übst es
          danach interaktiv in der Lernarena.
        </p>

        <div className="sn-cta-row">
          <Link href="/signup" className="sn-btn sn-btn-primary">Kostenlos üben</Link>
          <Link href="/pruefungen" className="sn-btn sn-btn-ghost">Zu den Prüfungen</Link>
        </div>

        <h2>Was ist Subnetting?</h2>
        <p>
          Beim <strong>Subnetting</strong> teilst du ein großes IP-Netz in mehrere
          kleinere Teilnetze auf. Dazu „leihst" du dir Bits aus dem Host-Teil der
          IP-Adresse und schlägst sie dem Netz-Teil zu. So nutzt du Adressbereiche
          effizienter und trennst Netze logisch — etwa Abteilungen in einer Firma.
        </p>
        <p>
          Eine IPv4-Adresse besteht aus 32 Bit. Die <strong>Subnetzmaske</strong>{" "}
          legt fest, welcher Teil davon das Netz beschreibt und welcher die Hosts.
          In der CIDR-Schreibweise steht das als Präfix hinter der Adresse, z. B.{" "}
          <span className="sn-mono">192.168.10.0/26</span> — die ersten 26 Bit sind
          der Netz-Teil.
        </p>

        <h2>Die wichtigsten Werte auf einen Blick</h2>
        <p>
          Diese Tabelle solltest du für die Prüfung im Kopf haben. Die nutzbaren
          Hosts berechnen sich immer als <span className="sn-mono">2^(32−Präfix) − 2</span>{" "}
          (Netz- und Broadcast-Adresse zählen nicht als Host).
        </p>
        <table className="sn-table">
          <thead>
            <tr>
              <th>CIDR</th>
              <th>Subnetzmaske</th>
              <th>Adressen</th>
              <th>Nutzbare Hosts</th>
            </tr>
          </thead>
          <tbody>
            {cidrTable.map((r) => (
              <tr key={r.cidr}>
                <td>{r.cidr}</td>
                <td>{r.mask}</td>
                <td>{r.addr}</td>
                <td>{r.hosts}</td>
              </tr>
            ))}
          </tbody>
        </table>

        <h2>Beispiel Schritt für Schritt</h2>
        <div className="sn-card">
          <p>
            <strong>Aufgabe:</strong> Gegeben ist das Netz{" "}
            <span className="sn-mono">192.168.10.0/26</span>. Wie lauten Subnetzmaske,
            Blockgröße, Netz- und Broadcast-Adresse des ersten Subnetzes und wie viele
            Hosts sind nutzbar?
          </p>
          <h3>1. Subnetzmaske bestimmen</h3>
          <p>
            /26 bedeutet 26 Einsen. Das letzte Oktett hat also 2 Netz-Bits:{" "}
            <span className="sn-mono">11000000</span> = 192. Die Maske ist{" "}
            <span className="sn-mono">255.255.255.192</span>.
          </p>
          <h3>2. Blockgröße berechnen</h3>
          <p>
            Blockgröße = 256 − 192 = <strong>64</strong>. Die Subnetze beginnen also
            bei .0, .64, .128 und .192.
          </p>
          <h3>3. Netz- und Broadcast-Adresse</h3>
          <p>
            Erstes Subnetz: Netzadresse{" "}
            <span className="sn-mono">192.168.10.0</span>, Broadcast{" "}
            <span className="sn-mono">192.168.10.63</span>. Nutzbar sind{" "}
            <span className="sn-mono">.1</span> bis <span className="sn-mono">.62</span>.
          </p>
          <h3>4. Anzahl Hosts</h3>
          <p>
            2^(32−26) − 2 = 2^6 − 2 = <strong>62 nutzbare Hosts</strong> pro Subnetz.
          </p>
        </div>

        <h2>Subnetz-Rechner — mit Rechenweg</h2>
        <p>
          Gib eine IP-Adresse und ein Präfix ein — der Rechner liefert Subnetzmaske,
          Netz- und Broadcast-Adresse samt Host-Bereich. Und das Besondere: Er zeigt
          dir auf Wunsch den <strong>kompletten Rechenweg in Binärdarstellung</strong>,
          damit du das Verfahren für die Prüfung wirklich verstehst.
        </p>
        <SubnetzRechner />

        <h2>Jetzt selbst testen</h2>
        <p>Beantworte die Fragen und bekomme sofort Feedback — so viele Versuche du willst.</p>

        <QuizFrage
          frage="Welche Subnetzmaske gehört zur CIDR-Notation /27?"
          optionen={[
            { text: "255.255.255.192", richtig: false },
            { text: "255.255.255.224", richtig: true },
            { text: "255.255.255.240", richtig: false },
            { text: "255.255.255.248", richtig: false },
          ]}
          erklaerung="/27 bedeutet 3 gesetzte Bits im letzten Oktett: 11100000 = 224. Die Maske ist also 255.255.255.224."
        />

        <QuizFrage
          frage="Wie viele nutzbare Hosts hat ein /28-Netz?"
          optionen={[
            { text: "16", richtig: false },
            { text: "30", richtig: false },
            { text: "14", richtig: true },
            { text: "8", richtig: false },
          ]}
          erklaerung="2^(32−28) − 2 = 2^4 − 2 = 14. Netz- und Broadcast-Adresse zählen nicht als nutzbare Hosts."
        />

        <QuizFrage
          frage="In welchem Subnetz liegt die Adresse 172.16.5.200 bei einem /26-Präfix?"
          optionen={[
            { text: "Netz 172.16.5.128, Broadcast 172.16.5.191", richtig: false },
            { text: "Netz 172.16.5.192, Broadcast 172.16.5.255", richtig: true },
            { text: "Netz 172.16.5.200, Broadcast 172.16.5.255", richtig: false },
            { text: "Netz 172.16.5.64, Broadcast 172.16.5.127", richtig: false },
          ]}
          erklaerung="Blockgröße bei /26 ist 64 → Subnetze .0, .64, .128, .192. Die .200 liegt im Block .192: Netzadresse 172.16.5.192, Broadcast 172.16.5.255, nutzbar .193–.254."
        />

        <h2>Verwandte Themen</h2>
        <div className="sn-related">
          <Link href="/lernen" className="sn-chip">Alle Lernthemen →</Link>
          <Link href="/lernen/raid" className="sn-chip">RAID Level erklärt →</Link>
          <Link href="/pruefungen" className="sn-chip">Alle IHK-Prüfungen →</Link>
        </div>

        <section className="sn-final">
          <h2>Subnetting interaktiv trainieren</h2>
          <p>
            In der Lernarena rechnest du Subnetting-Aufgaben mit sofortigem Feedback,
            echten IHK-Prüfungsfragen und einem KI-Tutor, der dir jeden Rechenschritt
            erklärt. Kostenlos starten, direkt üben.
          </p>
          <div className="sn-cta-row" style={{ justifyContent: "center" }}>
            <Link href="/signup" className="sn-btn sn-btn-primary">Jetzt kostenlos starten</Link>
            <Link href="/pruefungen" className="sn-btn sn-btn-ghost">Alle Prüfungen ansehen</Link>
          </div>
        </section>
      </div>
    </main>
  );
}