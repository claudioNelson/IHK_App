import type { Metadata } from "next";
import Link from "next/link";
import QuizFrage from "../_components/QuizFrage";

export const metadata: Metadata = {
  title: "RAID Level erklärt — RAID 0, 1, 5, 6 & 10 im Vergleich (IHK)",
  description: "RAID einfach erklärt: RAID 0, 1, 5, 6 und 10 im Vergleich — Nutzkapazität, Ausfallsicherheit und Rechenbeispiele für die IHK-Prüfung als Fachinformatiker Systemintegration.",
  alternates: {
    canonical: "https://lernarena.app/lernen/raid",
  },
  openGraph: {
    type: "article",
    locale: "de_DE",
    url: "https://lernarena.app/lernen/raid",
    siteName: "Lernarena",
    title: "RAID Level erklärt — RAID 0, 1, 5, 6 & 10 im Vergleich (IHK)",
    description: "RAID-Level im Vergleich: Nutzkapazität, Ausfallsicherheit und Rechenbeispiele für die Fachinformatiker-Prüfung.",
  },
};

const faq: { q: string; a: string }[] = [
  {
    "q": "Was ist ein RAID?",
    "a": "RAID (Redundant Array of Independent Disks) fasst mehrere Festplatten zu einem logischen Verbund zusammen. Je nach RAID-Level erhöht das die Ausfallsicherheit, die Geschwindigkeit oder beides. Wichtig: Ein RAID ersetzt kein Backup."
  },
  {
    "q": "Welches RAID-Level ist das beste?",
    "a": "Es gibt kein pauschal bestes Level — es kommt auf das Ziel an. RAID 1 für einfache Ausfallsicherheit, RAID 5 als Kompromiss aus Kapazität und Sicherheit, RAID 6 für höhere Sicherheit bei vielen Platten, RAID 10 wenn Geschwindigkeit und Redundanz zusammen zählen."
  },
  {
    "q": "Wie berechne ich die Nutzkapazität bei RAID 5?",
    "a": "Bei RAID 5 geht der Speicherplatz einer Platte für die Parität verloren. Die Nutzkapazität ist also (Anzahl Platten − 1) × Plattengröße. Beispiel: 4 × 2 TB ergeben (4 − 1) × 2 TB = 6 TB nutzbar."
  },
  {
    "q": "Wie viele Festplatten dürfen bei RAID 5 ausfallen?",
    "a": "Bei RAID 5 darf genau eine Festplatte ausfallen, ohne dass Daten verloren gehen. Fällt eine zweite Platte aus, bevor die erste ersetzt und wiederhergestellt ist, sind die Daten verloren. RAID 6 verkraftet dagegen zwei gleichzeitige Ausfälle."
  }
];

export default function LernSeite() {
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
        html[data-theme="light"] .lp-wrap {
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
        .lp-container { max-width: 780px; margin: 0 auto; padding: 72px 24px 96px; }
        .lp-crumb { font-size: 14px; color: var(--accent); margin-bottom: 24px; }
        .lp-crumb a { color: var(--accent); text-decoration: none; }
        .lp-crumb a:hover { text-decoration: underline; }
        .lp-wrap h1 {
          font-size: clamp(32px, 5vw, 46px);
          line-height: 1.1; letter-spacing: -0.02em;
          margin: 0 0 16px; font-weight: 700;
        }
        .lp-lead { font-size: 19px; color: var(--text-dim); margin: 0 0 32px; }
        .lp-wrap h2 { font-size: 26px; letter-spacing: -0.01em; margin: 48px 0 16px; font-weight: 650; }
        .lp-wrap h3 { font-size: 19px; margin: 28px 0 8px; font-weight: 600; }
        .lp-wrap p { color: var(--text-body); margin: 0 0 16px; }
        .lp-wrap strong { color: var(--text); }
        .lp-cta-row { display: flex; gap: 12px; flex-wrap: wrap; margin: 8px 0; }
        .lp-btn {
          display: inline-block; padding: 13px 26px; border-radius: 12px;
          font-weight: 600; font-size: 16px; text-decoration: none; transition: transform .12s ease;
        }
        .lp-btn-primary { background: #7C6DFF; color: #fff; box-shadow: 0 10px 30px rgba(124,109,255,0.35); }
        .lp-btn-primary:hover { transform: translateY(-2px); }
        .lp-btn-ghost { background: var(--chip-bg); color: var(--text); border: 1px solid var(--chip-border); }
        .lp-btn-ghost:hover { background: var(--accent-soft); }
        .lp-table { width: 100%; border-collapse: collapse; margin: 16px 0 8px; font-size: 15px; }
        .lp-table th, .lp-table td { text-align: left; padding: 11px 14px; border-bottom: 1px solid var(--border); }
        .lp-table th { color: var(--text-dim); font-weight: 600; font-size: 13px; text-transform: uppercase; letter-spacing: 0.04em; }
        .lp-table td { color: var(--text-body); }
        .lp-table td:first-child { font-weight: 600; color: var(--accent-text); white-space: nowrap; }
        .lp-card { background: var(--surface); border: 1px solid var(--border); border-radius: 16px; padding: 24px 26px; margin: 20px 0; }
        .lp-mono {
          font-family: var(--font-geist-mono), ui-monospace, monospace;
          background: var(--accent-soft); color: var(--accent-text);
          padding: 2px 7px; border-radius: 6px; font-size: 0.92em;
        }
        .lp-related { display: flex; gap: 12px; flex-wrap: wrap; margin-top: 12px; }
        .lp-chip {
          display: inline-block; padding: 10px 16px; border-radius: 10px;
          background: var(--chip-bg); border: 1px solid var(--chip-border);
          color: var(--text-body); text-decoration: none; font-size: 15px;
        }
        .lp-chip:hover { background: var(--accent-soft); border-color: var(--accent); }
        .lp-final {
          text-align: center; background: linear-gradient(180deg, var(--surface), var(--bg-muted));
          border: 1px solid rgba(124,109,255,0.25); border-radius: 20px;
          padding: 40px 28px; margin: 56px 0 0;
        }
        .lp-final h2 { margin-top: 0; }
`}</style>

      <div className="lp-container">
        <nav className="lp-crumb">
          <Link href="/">Lernarena</Link> · <Link href="/lernen">Lernen</Link> · RAID Level
        </nav>

        <h1>RAID Level erklärt — RAID 0, 1, 5, 6 und 10 im Vergleich</h1>
        <p className="lp-lead">
          RAID gehört zu den sicheren Punktelieferanten in der IHK-Prüfung für
          Fachinformatiker Systemintegration. Hier lernst du die wichtigsten
          RAID-Level, wie du Nutzkapazität und Ausfallsicherheit berechnest — mit
          Beispielen und interaktiven Übungsaufgaben.
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
            <tr><td>RAID 0</td><td>2</td><td>100 % (n)</td><td>keine</td><td>Striping — maximale Geschwindigkeit, kein Schutz</td></tr>
            <tr><td>RAID 1</td><td>2</td><td>50 %</td><td>1 Platte</td><td>Spiegelung (Mirroring)</td></tr>
            <tr><td>RAID 5</td><td>3</td><td>(n − 1) Platten</td><td>1 Platte</td><td>Striping + Parität, guter Kompromiss</td></tr>
            <tr><td>RAID 6</td><td>4</td><td>(n − 2) Platten</td><td>2 Platten</td><td>Doppelte Parität</td></tr>
            <tr><td>RAID 10</td><td>4</td><td>50 %</td><td>1 pro Spiegel</td><td>Gespiegelt + gestriped: Speed und Redundanz</td></tr>
          </tbody>
        </table>
        <p>
          <em>n</em> steht für die Anzahl der Festplatten. Bei RAID 5 verlierst du
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

        <h2>Jetzt selbst testen</h2>
        <p>Beantworte die Fragen und bekomme sofort Feedback — so viele Versuche du willst.</p>

        <QuizFrage
          frage={"Wie viele Festplatten braucht RAID 5 mindestens?"}
          optionen={[
            { text: "2", richtig: false },
            { text: "3", richtig: true },
            { text: "4", richtig: false },
            { text: "5", richtig: false },
          ]}
          erklaerung={"RAID 5 braucht mindestens 3 Festplatten — zwei für die Daten (Striping) plus den über alle Platten verteilten Paritätsanteil."}
        />

        <QuizFrage
          frage={"Wie groß ist die Nutzkapazität von 5 × 4 TB im RAID 5?"}
          optionen={[
            { text: "20 TB", richtig: false },
            { text: "12 TB", richtig: false },
            { text: "16 TB", richtig: true },
            { text: "10 TB", richtig: false },
          ]}
          erklaerung={"Nutzkapazität = (n − 1) × Plattengröße = (5 − 1) × 4 TB = 16 TB. Die Kapazität einer Platte geht an die Parität."}
        />

        <QuizFrage
          frage={"Welches RAID-Level bietet keine Ausfallsicherheit?"}
          optionen={[
            { text: "RAID 0", richtig: true },
            { text: "RAID 1", richtig: false },
            { text: "RAID 5", richtig: false },
            { text: "RAID 10", richtig: false },
          ]}
          erklaerung={"RAID 0 verteilt die Daten nur über die Platten (Striping) ohne Redundanz. Fällt eine Platte aus, ist der gesamte Verbund verloren."}
        />

        <h2>Verwandte Themen</h2>
        <div className="lp-related">
          <Link href="/lernen/subnetting" className="lp-chip">Subnetting üben →</Link>
          <Link href="/lernen/osi-modell" className="lp-chip">OSI-Modell →</Link>
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
