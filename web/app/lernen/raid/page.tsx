import type { Metadata } from "next";
import Link from "next/link";

export const metadata: Metadata = {
  title: "RAID Level erklärt — RAID 0, 1, 5, 6 & 10 im Vergleich (IHK)",
  description:
    "RAID einfach erklärt: RAID 0, 1, 5, 6 und 10 im Vergleich — Nutzkapazität, Ausfallsicherheit und Rechenbeispiele für die IHK-Prüfung als Fachinformatiker Systemintegration.",
  alternates: {
    canonical: "https://lernarena.app/lernen/raid",
  },
  openGraph: {
    type: "article",
    locale: "de_DE",
    url: "https://lernarena.app/lernen/raid",
    siteName: "Lernarena",
    title: "RAID Level erklärt — RAID 0, 1, 5, 6 & 10 im Vergleich (IHK)",
    description:
      "RAID-Level im Vergleich: Nutzkapazität, Ausfallsicherheit und Rechenbeispiele für die Fachinformatiker-Prüfung.",
  },
};

const raidTable: {
  level: string;
  min: string;
  cap: string;
  tol: string;
  note: string;
}[] = [
  { level: "RAID 0", min: "2", cap: "100 % (n)", tol: "keine", note: "Striping — maximale Geschwindigkeit, kein Schutz" },
  { level: "RAID 1", min: "2", cap: "50 %", tol: "1 Platte", note: "Spiegelung (Mirroring)" },
  { level: "RAID 5", min: "3", cap: "(n − 1) Platten", tol: "1 Platte", note: "Striping + Parität, guter Kompromiss" },
  { level: "RAID 6", min: "4", cap: "(n − 2) Platten", tol: "2 Platten", note: "Doppelte Parität" },
  { level: "RAID 10", min: "4", cap: "50 %", tol: "1 pro Spiegel", note: "Gespiegelt + gestriped: Speed & Redundanz" },
];

const faq: { q: string; a: string }[] = [
  {
    q: "Was ist ein RAID?",
    a: "RAID (Redundant Array of Independent Disks) fasst mehrere Festplatten zu einem logischen Verbund zusammen. Je nach RAID-Level erhöht das die Ausfallsicherheit, die Geschwindigkeit oder beides. Wichtig: Ein RAID ersetzt kein Backup.",
  },
  {
    q: "Welches RAID-Level ist das beste?",
    a: "Es gibt kein pauschal bestes Level — es kommt auf das Ziel an. RAID 1 für einfache Ausfallsicherheit, RAID 5 als Kompromiss aus Kapazität und Sicherheit, RAID 6 für höhere Sicherheit bei vielen Platten, RAID 10 wenn Geschwindigkeit und Redundanz zusammen zählen.",
  },
  {
    q: "Wie berechne ich die Nutzkapazität bei RAID 5?",
    a: "Bei RAID 5 geht der Speicherplatz einer Platte für die Parität verloren. Die Nutzkapazität ist also (Anzahl Platten − 1) × Plattengröße. Beispiel: 4 × 2 TB ergeben (4 − 1) × 2 TB = 6 TB nutzbar.",
  },
  {
    q: "Wie viele Festplatten dürfen bei RAID 5 ausfallen?",
    a: "Bei RAID 5 darf genau eine Festplatte ausfallen, ohne dass Daten verloren gehen. Fällt eine zweite Platte aus, bevor die erste ersetzt und wiederhergestellt ist, sind die Daten verloren. RAID 6 verkraftet dagegen zwei gleichzeitige Ausfälle.",
  },
];

export default function RaidPage() {
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
    <main className="lp-wrap">
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
      />

      <style>{`
        .lp-wrap {
          font-family: var(--font-geist-sans), system-ui, sans-serif;
          background: #08080C;
          color: #F5F5F7;
          min-height: 100vh;
          line-height: 1.65;
        }
        .lp-container { max-width: 780px; margin: 0 auto; padding: 72px 24px 96px; }
        .lp-crumb { font-size: 14px; color: #7C6DFF; margin-bottom: 24px; }
        .lp-crumb a { color: #7C6DFF; text-decoration: none; }
        .lp-crumb a:hover { text-decoration: underline; }
        .lp-wrap h1 {
          font-size: clamp(32px, 5vw, 46px);
          line-height: 1.1; letter-spacing: -0.02em;
          margin: 0 0 16px; font-weight: 700;
        }
        .lp-lead { font-size: 19px; color: #A0A0B0; margin: 0 0 32px; }
        .lp-wrap h2 { font-size: 26px; letter-spacing: -0.01em; margin: 48px 0 16px; font-weight: 650; }
        .lp-wrap h3 { font-size: 19px; margin: 28px 0 8px; font-weight: 600; }
        .lp-wrap p { color: #C8C8D2; margin: 0 0 16px; }
        .lp-wrap strong { color: #F5F5F7; }
        .lp-cta-row { display: flex; gap: 12px; flex-wrap: wrap; margin: 8px 0; }
        .lp-btn {
          display: inline-block; padding: 13px 26px; border-radius: 12px;
          font-weight: 600; font-size: 16px; text-decoration: none;
          transition: transform .12s ease;
        }
        .lp-btn-primary { background: #7C6DFF; color: #fff; box-shadow: 0 10px 30px rgba(124,109,255,0.35); }
        .lp-btn-primary:hover { transform: translateY(-2px); }
        .lp-btn-ghost { background: rgba(255,255,255,0.06); color: #F5F5F7; border: 1px solid rgba(255,255,255,0.12); }
        .lp-btn-ghost:hover { background: rgba(255,255,255,0.1); }
        .lp-table { width: 100%; border-collapse: collapse; margin: 16px 0 8px; font-size: 15px; }
        .lp-table th, .lp-table td { text-align: left; padding: 11px 14px; border-bottom: 1px solid rgba(255,255,255,0.08); }
        .lp-table th { color: #A0A0B0; font-weight: 600; font-size: 13px; text-transform: uppercase; letter-spacing: 0.04em; }
        .lp-table td { color: #E0E0E8; }
        .lp-table td:first-child { font-weight: 600; color: #C4BBFF; white-space: nowrap; }
        .lp-card { background: #12121C; border: 1px solid rgba(255,255,255,0.08); border-radius: 16px; padding: 24px 26px; margin: 20px 0; }
        .lp-mono {
          font-family: var(--font-geist-mono), ui-monospace, monospace;
          background: rgba(124,109,255,0.14); color: #C4BBFF;
          padding: 2px 7px; border-radius: 6px; font-size: 0.92em;
        }
        .lp-task { border-top: 1px solid rgba(255,255,255,0.08); padding: 18px 0; }
        .lp-task:first-of-type { border-top: none; }
        .lp-task > summary { cursor: pointer; color: #7C6DFF; font-weight: 600; margin-top: 8px; list-style: none; }
        .lp-task > summary::-webkit-details-marker { display: none; }
        .lp-related { display: flex; gap: 12px; flex-wrap: wrap; margin-top: 12px; }
        .lp-chip {
          display: inline-block; padding: 10px 16px; border-radius: 10px;
          background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1);
          color: #E0E0E8; text-decoration: none; font-size: 15px;
        }
        .lp-chip:hover { background: rgba(124,109,255,0.14); border-color: rgba(124,109,255,0.4); }
        .lp-final {
          text-align: center; background: linear-gradient(180deg, #12121C, #0E0E14);
          border: 1px solid rgba(124,109,255,0.25); border-radius: 20px;
          padding: 40px 28px; margin: 56px 0 0;
        }
        .lp-final h2 { margin-top: 0; }
      `}</style>

      <div className="lp-container">
        <nav className="lp-crumb">
          <Link href="/">Lernarena</Link> · RAID Level erklärt
        </nav>

        <h1>RAID Level erklärt — RAID 0, 1, 5, 6 und 10 im Vergleich</h1>
        <p className="lp-lead">
          RAID gehört zu den sicheren Punktelieferanten in der IHK-Prüfung für
          Fachinformatiker Systemintegration. Hier lernst du die wichtigsten
          RAID-Level, wie du Nutzkapazität und Ausfallsicherheit berechnest — mit
          Beispielen und Übungsaufgaben.
        </p>

        <div className="lp-cta-row">
          <Link href="/signup" className="lp-btn lp-btn-primary">Kostenlos üben</Link>
          <Link href="/pruefungen" className="lp-btn lp-btn-ghost">Zu den Prüfungen</Link>
        </div>

        <h2>Was ist ein RAID?</h2>
        <p>
          <strong>RAID</strong> steht für <em>Redundant Array of Independent Disks</em>{" "}
          und fasst mehrere Festplatten zu einem logischen Verbund zusammen. Je nach
          gewähltem Level bekommst du mehr <strong>Ausfallsicherheit</strong>, mehr{" "}
          <strong>Geschwindigkeit</strong> oder eine Mischung aus beidem. Ein wichtiger
          Merksatz für die Prüfung: <strong>Ein RAID ersetzt kein Backup</strong> — es
          schützt vor Hardware-Ausfall, nicht vor versehentlichem Löschen oder
          Verschlüsselung durch Ransomware.
        </p>

        <h2>Die RAID-Level im Vergleich</h2>
        <p>Diese Tabelle solltest du für die Prüfung sicher beherrschen:</p>
        <table className="lp-table">
          <thead>
            <tr>
              <th>Level</th>
              <th>Min. Platten</th>
              <th>Nutzkapazität</th>
              <th>Ausfalltoleranz</th>
              <th>Merkmal</th>
            </tr>
          </thead>
          <tbody>
            {raidTable.map((r) => (
              <tr key={r.level}>
                <td>{r.level}</td>
                <td>{r.min}</td>
                <td>{r.cap}</td>
                <td>{r.tol}</td>
                <td>{r.note}</td>
              </tr>
            ))}
          </tbody>
        </table>
        <p>
          <em>n</em> steht dabei für die Anzahl der Festplatten. Bei RAID 5 verlierst du
          die Kapazität <strong>einer</strong> Platte an die Parität, bei RAID 6 die von{" "}
          <strong>zwei</strong> Platten.
        </p>

        <h2>Rechenbeispiel Nutzkapazität</h2>
        <div className="lp-card">
          <p>
            <strong>Aufgabe:</strong> Ein Server hat{" "}
            <span className="lp-mono">4 Festplatten à 2 TB</span> im Verbund{" "}
            <span className="lp-mono">RAID 5</span>. Wie viel Speicher steht nutzbar zur
            Verfügung?
          </p>
          <h3>Lösung</h3>
          <p>
            Bei RAID 5 gilt: Nutzkapazität = (n − 1) × Plattengröße. Also{" "}
            <span className="lp-mono">(4 − 1) × 2 TB = 6 TB</span>. Die Kapazität einer
            Platte (2 TB) geht für die verteilte Parität verloren — dafür darf eine
            beliebige Platte ausfallen, ohne dass Daten verloren gehen.
          </p>
        </div>

        <h2>Übungsaufgaben</h2>
        <p>Probier es selbst — die Lösung klappt jeweils per Klick auf.</p>

        <details className="lp-task">
          <summary>Aufgabe 1 anzeigen</summary>
          <p style={{ marginTop: 12 }}>Wie viele Festplatten braucht RAID 5 mindestens?</p>
          <details>
            <summary style={{ color: "#7C6DFF", cursor: "pointer" }}>Lösung</summary>
            <p style={{ marginTop: 8 }}>
              <strong>3 Festplatten</strong> — zwei für die Daten (Striping) und der
              Paritätsanteil verteilt über alle drei.
            </p>
          </details>
        </details>

        <details className="lp-task">
          <summary>Aufgabe 2 anzeigen</summary>
          <p style={{ marginTop: 12 }}>
            Wie groß ist die Nutzkapazität von{" "}
            <span className="lp-mono">5 × 4 TB</span> im RAID 5?
          </p>
          <details>
            <summary style={{ color: "#7C6DFF", cursor: "pointer" }}>Lösung</summary>
            <p style={{ marginTop: 8 }}>
              (5 − 1) × 4 TB = <strong>16 TB</strong> nutzbar.
            </p>
          </details>
        </details>

        <details className="lp-task">
          <summary>Aufgabe 3 anzeigen</summary>
          <p style={{ marginTop: 12 }}>
            Welches der Level bietet <strong>keine</strong> Ausfallsicherheit — und warum?
          </p>
          <details>
            <summary style={{ color: "#7C6DFF", cursor: "pointer" }}>Lösung</summary>
            <p style={{ marginTop: 8 }}>
              <strong>RAID 0</strong>. Es verteilt die Daten nur über die Platten
              (Striping), speichert aber keine Redundanz. Fällt eine Platte aus, ist der
              gesamte Verbund verloren.
            </p>
          </details>
        </details>

        <h2>Verwandte Themen</h2>
        <div className="lp-related">
          <Link href="/lernen/subnetting" className="lp-chip">Subnetting üben →</Link>
          <Link href="/pruefungen" className="lp-chip">Alle IHK-Prüfungen →</Link>
        </div>

        <section className="lp-final">
          <h2>RAID interaktiv trainieren</h2>
          <p>
            In der Lernarena rechnest du RAID- und Netzwerkaufgaben mit sofortigem
            Feedback, echten IHK-Prüfungsfragen und einem KI-Tutor, der dir jeden
            Schritt erklärt. Kostenlos starten, direkt üben.
          </p>
          <div className="lp-cta-row" style={{ justifyContent: "center" }}>
            <Link href="/signup" className="lp-btn lp-btn-primary">Jetzt kostenlos starten</Link>
            <Link href="/pruefungen" className="lp-btn lp-btn-ghost">Alle Prüfungen ansehen</Link>
          </div>
        </section>
      </div>
    </main>
  );
}