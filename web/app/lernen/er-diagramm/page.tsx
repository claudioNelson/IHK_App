import type { Metadata } from "next";
import Link from "next/link";
import QuizFrage from "../_components/QuizFrage";

export const metadata: Metadata = {
  title: "ER-Diagramm erstellen — Entitäten, Beziehungen & Kardinalitäten (IHK)",
  description: "ER-Diagramme einfach erklärt: Entitäten, Attribute, Beziehungen und Kardinalitäten (1:1, 1:n, n:m) — mit Beispiel, n:m-Auflösung und Übungsaufgaben für die IHK-Prüfung.",
  alternates: {
    canonical: "https://lernarena.app/lernen/er-diagramm",
  },
  openGraph: {
    type: "article",
    locale: "de_DE",
    url: "https://lernarena.app/lernen/er-diagramm",
    siteName: "Lernarena",
    title: "ER-Diagramm erstellen — Entitäten, Beziehungen & Kardinalitäten (IHK)",
    description: "ER-Modell für die Fachinformatiker-Prüfung: Kardinalitäten, n:m-Auflösung und Übungsaufgaben.",
  },
};

const faq: { q: string; a: string }[] = [
  {
    "q": "Was ist ein ER-Diagramm?",
    "a": "Ein Entity-Relationship-Diagramm modelliert einen Datenbestand grafisch: Entitäten (Objekte wie Kunde oder Artikel), deren Attribute und die Beziehungen zwischen den Entitäten inklusive Kardinalitäten. Es ist die Vorstufe zum Tabellenentwurf einer relationalen Datenbank."
  },
  {
    "q": "Welche Kardinalitäten gibt es?",
    "a": "Die drei Grundtypen sind 1:1 (jedem A gehört genau ein B), 1:n (ein A hat beliebig viele B) und n:m (viele A stehen mit vielen B in Beziehung). In der Prüfung wird oft die passende Kardinalität zu einem Sachverhalt gesucht."
  },
  {
    "q": "Wie löst man eine n:m-Beziehung auf?",
    "a": "Durch eine Zwischentabelle, die die Primärschlüssel beider Entitäten als Fremdschlüssel enthält und die n:m-Beziehung in zwei 1:n-Beziehungen zerlegt. Die Zwischentabelle kann eigene Attribute tragen, etwa eine Note bei Schüler-Kurs."
  },
  {
    "q": "Wohin kommt der Fremdschlüssel bei einer 1:n-Beziehung?",
    "a": "Immer in die Tabelle der n-Seite. Beispiel Kunde–Auftrag: Die kunden_nr steht als Fremdschlüssel in der Auftragstabelle, denn jeder Auftrag gehört zu genau einem Kunden."
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
          <Link href="/">Lernarena</Link> · <Link href="/lernen">Lernen</Link> · ER-Diagramm
        </nav>

        <h1>ER-Diagramm erstellen — Entitäten, Beziehungen und Kardinalitäten</h1>
        <p className="lp-lead">
          Das Entity-Relationship-Modell ist der Standard-Einstieg in jede
          Datenbankaufgabe der IHK-Prüfung. Hier lernst du Entitäten, Beziehungen
          und Kardinalitäten — und wie du eine n:m-Beziehung sauber auflöst.
        </p>

        <div className="lp-cta-row">
          <Link href="/signup" className="lp-btn lp-btn-primary">Kostenlos üben</Link>
          <Link href="/pruefungen" className="lp-btn lp-btn-ghost">Zu den Prüfungen</Link>
        </div>

        <h2>Die drei Bausteine</h2>
        <p>
          Eine <strong>Entität</strong> ist ein Objekt der realen Welt (Kunde,
          Artikel, Auftrag). <strong>Attribute</strong> beschreiben die Entität
          (Name, Preis, Datum) — eines davon ist der <strong>Primärschlüssel</strong>,
          der jeden Datensatz eindeutig identifiziert. <strong>Beziehungen</strong>{" "}
          verbinden Entitäten miteinander und tragen die Kardinalität.
        </p>

        <h2>Die Kardinalitäten</h2>
        <table className="lp-table">
          <thead>
            <tr>
              <th>Typ</th>
              <th>Bedeutung</th>
              <th>Beispiel</th>
            </tr>
          </thead>
          <tbody>
            <tr><td>1:1</td><td>Jedem A gehört genau ein B</td><td>Mitarbeiter — Firmenlaptop</td></tr>
            <tr><td>1:n</td><td>Ein A hat viele B, jedes B genau ein A</td><td>Kunde — Aufträge</td></tr>
            <tr><td>n:m</td><td>Viele A stehen mit vielen B in Beziehung</td><td>Schüler — Kurse</td></tr>
          </tbody>
        </table>

        <h2>Der Prüfungsklassiker: n:m auflösen</h2>
        <div className="lp-card">
          <p>
            Eine <strong>n:m-Beziehung</strong> lässt sich nicht direkt in Tabellen
            umsetzen. Sie wird über eine <strong>Zwischentabelle</strong> (auch
            Kreuz- oder Beziehungstabelle) in zwei 1:n-Beziehungen zerlegt.
          </p>
          <p>
            Beispiel: <span className="lp-mono">schueler(schueler_id, name)</span> und{" "}
            <span className="lp-mono">kurs(kurs_id, titel)</span> bekommen die
            Zwischentabelle{" "}
            <span className="lp-mono">belegung(schueler_id, kurs_id, note)</span>.
            Ihr Primärschlüssel ist meist die Kombination beider Fremdschlüssel —
            und sie kann eigene Attribute tragen (hier: die Note).
          </p>
        </div>

        <h2>Vom ER-Modell zur Tabelle</h2>
        <p>
          Bei der Überführung gilt: Jede Entität wird eine Tabelle. Bei{" "}
          <strong>1:n</strong> wandert der Primärschlüssel der 1-Seite als{" "}
          <strong>Fremdschlüssel</strong> in die n-Seite (der Kunde steckt als{" "}
          <span className="lp-mono">kunden_nr</span> im Auftrag — nie umgekehrt).
          Bei <strong>n:m</strong> entsteht die Zwischentabelle. Genau diese
          Überführung ist eine Standard-Teilaufgabe der Prüfung.
        </p>

        <h2>Jetzt selbst testen</h2>
        <p>Beantworte die Fragen und bekomme sofort Feedback — so viele Versuche du willst.</p>

        <QuizFrage
          frage={"Ein Kunde kann viele Aufträge haben, jeder Auftrag gehört zu genau einem Kunden. Welche Kardinalität ist das?"}
          optionen={[
            { text: "1:1", richtig: false },
            { text: "1:n", richtig: true },
            { text: "n:m", richtig: false },
            { text: "n:1 von Kunde aus gesehen", richtig: false },
          ]}
          erklaerung={"Von Kunde zu Auftrag ist es 1:n — ein Kunde hat beliebig viele Aufträge, aber jeder Auftrag genau einen Kunden."}
        />

        <QuizFrage
          frage={"Wie wird eine n:m-Beziehung in einer relationalen Datenbank umgesetzt?"}
          optionen={[
            { text: "Durch einen doppelten Primärschlüssel in einer der Tabellen", richtig: false },
            { text: "Durch eine Zwischentabelle mit beiden Fremdschlüsseln", richtig: true },
            { text: "Durch NULL-Werte in beiden Tabellen", richtig: false },
            { text: "Gar nicht — n:m ist verboten", richtig: false },
          ]}
          erklaerung={"Die Zwischentabelle enthält die Primärschlüssel beider Entitäten als Fremdschlüssel und zerlegt die n:m-Beziehung in zwei 1:n-Beziehungen."}
        />

        <QuizFrage
          frage={"Wohin gehört der Fremdschlüssel bei Kunde (1) — Auftrag (n)?"}
          optionen={[
            { text: "In die Kundentabelle", richtig: false },
            { text: "In die Auftragstabelle", richtig: true },
            { text: "In eine Zwischentabelle", richtig: false },
            { text: "In beide Tabellen", richtig: false },
          ]}
          erklaerung={"Bei 1:n wandert der Primärschlüssel der 1-Seite als Fremdschlüssel in die n-Seite: die kunden_nr steht in jedem Auftrag."}
        />

        <h2>Verwandte Themen</h2>
        <div className="lp-related">
          <Link href="/lernen/normalisierung" className="lp-chip">Normalisierung →</Link>
          <Link href="/lernen/sql" className="lp-chip">SQL üben →</Link>
          <Link href="/pruefungen" className="lp-chip">Alle IHK-Prüfungen →</Link>
        </div>

        <section className="lp-final">
          <h2>Datenbanken interaktiv trainieren</h2>
          <p>
            In der Lernarena modellierst du ER-Diagramme und überführst sie in Tabellen —
            mit sofortigem Feedback, echten IHK-Prüfungsaufgaben und einem KI-Tutor.
            Kostenlos starten, direkt üben.
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
