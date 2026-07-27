import type { Metadata } from "next";
import Link from "next/link";
import QuizFrage from "../_components/QuizFrage";

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
    q: "Warum ist ein RAID kein Backup?",
    a: "Ein RAID schützt vor dem Ausfall einzelner Festplatten (Hardware). Es schützt aber nicht vor versehentlichem Löschen, Dateibeschädigung, Viren oder Ransomware — solche Fehler werden sofort auf alle Platten übernommen. Deshalb braucht man zusätzlich echte Backups.",
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
          --bg: #08080C; --bg-muted: #0E0E14; --surface: #12121C; --surface-2: #151521;
          --border: rgba(255,255,255,0.08); --border-strong: rgba(255,255,255,0.14);
          --text: #F5F5F7; --text-body: #C8C8D2; --text-dim: #A0A0B0;
          --accent: #7C6DFF; --accent-soft: rgba(124,109,255,0.14); --accent-text: #C4BBFF;
          --chip-bg: rgba(255,255,255,0.05); --chip-border: rgba(255,255,255,0.1);
          --input-bg: rgba(255,255,255,0.05); --input-border: rgba(255,255,255,0.15);
          --pre-bg: rgba(0,0,0,0.35);
          --ok: #5FD98A; --ok-bg: rgba(52,199,89,0.16); --ok-border: rgba(52,199,89,0.6); --ok-text: #B8F0C4;
          --err: #FF6B63; --err-bg: rgba(255,69,58,0.16); --err-border: rgba(255,69,58,0.6); --err-text: #A32620;
          --warn-bg: rgba(255,159,10,0.14); --warn-border: rgba(255,159,10,0.55); --warn-text: #FFD79A;
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
          --warn-bg: rgba(180,120,0,0.10); --warn-border: rgba(180,120,0,0.45); --warn-text: #8A5A00;
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
        .lp-tip { background: var(--accent-soft); border: 1px solid var(--accent); border-radius: 14px; padding: 18px 22px; margin: 22px 0; }
        .lp-tip p { margin: 0; }
        .lp-tip strong { color: var(--accent-text); }
        .lp-warn { background: var(--warn-bg); border: 1px solid var(--warn-border); border-radius: 14px; padding: 18px 22px; margin: 22px 0; }
        .lp-warn p { margin: 0 0 8px; }
        .lp-warn strong { color: var(--warn-text); }
        .lp-warn ul { margin: 8px 0 0; padding-left: 20px; }
        .lp-warn li { color: var(--text-body); margin: 6px 0; }
        .lp-faq { margin: 8px 0; }
        .lp-faq details { background: var(--surface); border: 1px solid var(--border); border-radius: 12px; padding: 2px 22px; margin: 10px 0; transition: border-color .15s ease; }
        .lp-faq details[open] { border-color: var(--border-strong); }
        .lp-faq summary { cursor: pointer; font-weight: 600; color: var(--text); padding: 16px 0; list-style: none; display: flex; justify-content: space-between; align-items: center; gap: 16px; }
        .lp-faq summary::-webkit-details-marker { display: none; }
        .lp-faq summary::after { content: "+"; color: var(--accent); font-size: 22px; font-weight: 400; line-height: 1; }
        .lp-faq details[open] summary::after { content: "−"; }
        .lp-faq details p { padding: 0 0 16px; margin: 0; color: var(--text-body); }
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
          <Link href="/">Lernarena</Link> · <Link href="/lernen">Lernen</Link> · RAID Level erklärt
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

        <div className="lp-tip">
          <p>
            <strong>📄 Stell es dir mit Kopien vor:</strong>{" "}
            <strong>RAID 1</strong> ist wie ein <em>Durchschlag</em> — von jedem Blatt gibt
            es sofort eine identische Kopie in der zweiten Schublade. Verbrennt eine, hast
            du noch die andere. <strong>RAID 0</strong> zerreißt jedes Blatt in zwei
            Hälften und legt die Hälften auf zwei Schubladen — das geht doppelt so schnell,
            aber fehlt eine Schublade, ist <em>alles</em> unlesbar.{" "}
            <strong>RAID 5</strong> ist eine Lerngruppe: Fällt eine Person aus, lässt sich
            ihr Wissen aus den Notizen der anderen (der „Parität") rekonstruieren.
          </p>
        </div>

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

        <h2>Was ist „Parität"?</h2>
        <p>
          Die <strong>Parität</strong> ist eine clevere Prüfsumme. Vereinfacht: Aus den
          Datenblöcken der übrigen Platten wird ein Wert berechnet, mit dem sich ein
          fehlender Block wieder ausrechnen lässt — wie in der Gleichung{" "}
          <span className="lp-mono">3 + 4 + ? = 12</span>: Fehlt eine Zahl, kannst du sie
          aus den anderen zurückrechnen (hier 5). Genau so stellt RAID 5 die Daten einer
          ausgefallenen Platte wieder her. Deshalb kostet die Parität immer den Platz{" "}
          <strong>einer</strong> Platte (RAID 5) bzw. <strong>zweier</strong> Platten
          (RAID 6).
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

        <div className="lp-tip">
          <p>
            <strong>💡 Prüfungstipp — die Formeln im Kopf:</strong>{" "}
            <span className="lp-mono">RAID 0 = n</span> (alles),{" "}
            <span className="lp-mono">RAID 1 = 50 %</span>,{" "}
            <span className="lp-mono">RAID 5 = (n−1)</span>,{" "}
            <span className="lp-mono">RAID 6 = (n−2)</span>,{" "}
            <span className="lp-mono">RAID 10 = 50 %</span>. Rechne die Nutzkapazität immer
            in Platten und multipliziere erst am Ende mit der Plattengröße — so vermeidest
            du Rechenfehler.
          </p>
        </div>

        <div className="lp-warn">
          <p><strong>⚠️ Häufige Fehler in der Prüfung:</strong></p>
          <ul>
            <li>
              „RAID ist ein Backup" ankreuzen — <strong>ist es nicht</strong>. Es schützt
              nur vor Plattenausfall, nicht vor Löschen oder Ransomware.
            </li>
            <li>
              Bei RAID 5 die volle Kapazität rechnen. Es geht immer eine Platte an die
              Parität verloren: <span className="lp-mono">(n − 1)</span>.
            </li>
            <li>
              RAID 6 mit RAID 5 verwechseln: RAID 6 verträgt <strong>zwei</strong>{" "}
              Ausfälle, RAID 5 nur einen.
            </li>
            <li>
              Die Mindest-Plattenzahl vergessen: RAID 5 braucht mindestens{" "}
              <strong>3</strong>, RAID 6 und RAID 10 mindestens <strong>4</strong>.
            </li>
          </ul>
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
          erklaerung={"RAID 5 braucht mindestens 3 Platten: Die Daten werden gestriped und die Parität verteilt über alle Platten gespeichert."}
        />

        <QuizFrage
          frage={"Wie groß ist die Nutzkapazität von 5 × 4 TB im RAID 5?"}
          optionen={[
            { text: "20 TB", richtig: false },
            { text: "16 TB", richtig: true },
            { text: "12 TB", richtig: false },
            { text: "10 TB", richtig: false },
          ]}
          erklaerung={"(n − 1) × Plattengröße = (5 − 1) × 4 TB = 16 TB. Eine Platte (4 TB) geht für die Parität verloren."}
        />

        <QuizFrage
          frage={"Welches RAID-Level bietet KEINE Ausfallsicherheit?"}
          optionen={[
            { text: "RAID 0", richtig: true },
            { text: "RAID 1", richtig: false },
            { text: "RAID 5", richtig: false },
            { text: "RAID 6", richtig: false },
          ]}
          erklaerung={"RAID 0 verteilt die Daten nur über die Platten (Striping) ohne jede Redundanz. Fällt eine Platte aus, ist der gesamte Verbund verloren."}
        />

        <QuizFrage
          frage={"Wie viele Festplatten dürfen bei RAID 6 gleichzeitig ausfallen?"}
          optionen={[
            { text: "Keine", richtig: false },
            { text: "1", richtig: false },
            { text: "2", richtig: true },
            { text: "Beliebig viele", richtig: false },
          ]}
          erklaerung={"RAID 6 nutzt doppelte Parität und verträgt damit den gleichzeitigen Ausfall von zwei Platten — deshalb braucht es auch mindestens 4 Platten."}
        />

        <QuizFrage
          frage={"Ein Kunde will maximale Schreibgeschwindigkeit UND Ausfallsicherheit. Welches Level passt am besten?"}
          optionen={[
            { text: "RAID 0", richtig: false },
            { text: "RAID 1", richtig: false },
            { text: "RAID 10", richtig: true },
            { text: "RAID 6", richtig: false },
          ]}
          erklaerung={"RAID 10 kombiniert Spiegelung (Sicherheit) und Striping (Geschwindigkeit). Es kostet zwar 50 % Kapazität, liefert aber beides zusammen — anders als RAID 0 (kein Schutz) oder RAID 1 (kein Striping-Speed)."}
        />

        <h2>Häufige Fragen</h2>
        <div className="lp-faq">
          {faq.map((f) => (
            <details key={f.q}>
              <summary>{f.q}</summary>
              <p>{f.a}</p>
            </details>
          ))}
        </div>

        <h2>Verwandte Themen</h2>
        <div className="lp-related">
          <Link href="/lernen/subnetting" className="lp-chip">Subnetting üben →</Link>
          <Link href="/lernen/osi-modell" className="lp-chip">OSI-Modell →</Link>
          <Link href="/lernen" className="lp-chip">Alle Lernthemen →</Link>
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
