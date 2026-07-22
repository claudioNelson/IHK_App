import type { Metadata } from "next";
import Link from "next/link";
import QuizFrage from "../_components/QuizFrage";

export const metadata: Metadata = {
  title: "Normalisierung — 1. bis 3. Normalform einfach erklärt (IHK)",
  description: "Datenbank-Normalisierung einfach erklärt: 1., 2. und 3. Normalform mit Beispielen, Anomalien und Merksätzen — plus interaktive Übungsaufgaben für die IHK-Prüfung.",
  alternates: {
    canonical: "https://lernarena.app/lernen/normalisierung",
  },
  openGraph: {
    type: "article",
    locale: "de_DE",
    url: "https://lernarena.app/lernen/normalisierung",
    siteName: "Lernarena",
    title: "Normalisierung — 1. bis 3. Normalform einfach erklärt (IHK)",
    description: "1NF, 2NF und 3NF mit Beispielen und Merksätzen — für die Fachinformatiker-Prüfung.",
  },
};

const faq: { q: string; a: string }[] = [
  {
    "q": "Was bedeutet die 1. Normalform?",
    "a": "Alle Attributwerte müssen atomar sein — in jedem Feld steht genau ein Wert. Listen, Aufzählungen oder zusammengesetzte Angaben wie 'Name, Vorname' in einem Feld verletzen die 1. Normalform."
  },
  {
    "q": "Was bedeutet die 2. Normalform?",
    "a": "Die Tabelle ist in der 1. Normalform und jedes Nicht-Schlüssel-Attribut hängt vom gesamten Primärschlüssel ab — nicht nur von einem Teil. Relevant ist das bei zusammengesetzten Schlüsseln, etwa (rechnungs_nr, artikel_nr)."
  },
  {
    "q": "Was bedeutet die 3. Normalform?",
    "a": "Die Tabelle ist in der 2. Normalform und kein Nicht-Schlüssel-Attribut hängt transitiv, also über ein anderes Nicht-Schlüssel-Attribut, vom Schlüssel ab. Beispiel: Der Ort hängt von der Postleitzahl ab — dann gehören PLZ und Ort in eine eigene Tabelle."
  },
  {
    "q": "Welche Anomalien verhindert die Normalisierung?",
    "a": "Änderungsanomalien (derselbe Wert müsste an vielen Stellen geändert werden), Einfügeanomalien (Daten lassen sich nicht ohne fremde Daten anlegen) und Löschanomalien (beim Löschen gehen ungewollt andere Informationen verloren)."
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
          <Link href="/">Lernarena</Link> · <Link href="/lernen">Lernen</Link> · Normalisierung
        </nav>

        <h1>Normalisierung — die 1. bis 3. Normalform einfach erklärt</h1>
        <p className="lp-lead">
          Kaum eine Datenbankprüfung ohne Normalisierung: Tabellen in die 1., 2. und
          3. Normalform bringen. Hier bekommst du die drei Regeln mit Beispielen und
          Merksätzen — und testest dich direkt.
        </p>

        <div className="lp-cta-row">
          <Link href="/signup" className="lp-btn lp-btn-primary">Kostenlos üben</Link>
          <Link href="/pruefungen" className="lp-btn lp-btn-ghost">Zu den Prüfungen</Link>
        </div>

        <h2>Warum normalisieren?</h2>
        <p>
          Schlecht strukturierte Tabellen führen zu <strong>Redundanz</strong>{" "}
          (dieselben Daten mehrfach) und <strong>Anomalien</strong>: Änderungsanomalie
          (ein Wert muss an vielen Stellen geändert werden), Einfügeanomalie (Daten
          können nicht ohne fremde Daten angelegt werden) und Löschanomalie (beim
          Löschen gehen ungewollt Informationen verloren). Die Normalformen beseitigen
          diese Probleme Schritt für Schritt.
        </p>

        <h2>Die drei Normalformen</h2>
        <table className="lp-table">
          <thead>
            <tr>
              <th>Normalform</th>
              <th>Regel</th>
              <th>Merksatz</th>
            </tr>
          </thead>
          <tbody>
            <tr><td>1. NF</td><td>Alle Attribute sind atomar — keine Listen oder zusammengesetzten Werte in einem Feld</td><td>Ein Wert pro Feld</td></tr>
            <tr><td>2. NF</td><td>1. NF + jedes Nicht-Schlüssel-Attribut hängt vom ganzen Primärschlüssel ab</td><td>Keine partiellen Abhängigkeiten</td></tr>
            <tr><td>3. NF</td><td>2. NF + kein Nicht-Schlüssel-Attribut hängt von einem anderen Nicht-Schlüssel-Attribut ab</td><td>Keine transitiven Abhängigkeiten</td></tr>
          </tbody>
        </table>

        <h2>Beispiel: eine Rechnungstabelle normalisieren</h2>
        <div className="lp-card">
          <p>
            <strong>Ausgangslage (unnormalisiert):</strong>{" "}
            <span className="lp-mono">rechnung(rechnungs_nr, datum, kunde_name, kunde_ort, artikel_liste)</span>{" "}
            — im Feld artikel_liste stehen mehrere Artikel als Text.
          </p>
          <p>
            <strong>1. NF:</strong> Die Artikelliste wird aufgelöst — pro Artikel eine
            eigene Zeile, alle Felder atomar.
          </p>
          <p>
            <strong>2. NF:</strong> Bei zusammengesetztem Schlüssel (rechnungs_nr,
            artikel_nr) hängen Artikeldaten nur von artikel_nr ab → eigene
            Artikel-Tabelle.
          </p>
          <p>
            <strong>3. NF:</strong> kunde_ort hängt von kunde_name ab (nicht vom
            Schlüssel rechnungs_nr) → eigene Kunden-Tabelle. Ergebnis: rechnung,
            rechnungsposition, artikel, kunde.
          </p>
        </div>

        <h2>Jetzt selbst testen</h2>
        <p>Beantworte die Fragen und bekomme sofort Feedback — so viele Versuche du willst.</p>

        <QuizFrage
          frage={"In einem Feld steht 'Müller, Hans, Berlin'. Welche Normalform ist verletzt?"}
          optionen={[
            { text: "1. Normalform", richtig: true },
            { text: "2. Normalform", richtig: false },
            { text: "3. Normalform", richtig: false },
            { text: "Keine — das ist erlaubt", richtig: false },
          ]}
          erklaerung={"Mehrere Werte in einem Feld verletzen die Atomarität — das ist ein klassischer Verstoß gegen die 1. Normalform."}
        />

        <QuizFrage
          frage={"Der Ort hängt von der Postleitzahl ab, die PLZ vom Schlüssel. Welche Normalform ist verletzt?"}
          optionen={[
            { text: "1. Normalform", richtig: false },
            { text: "2. Normalform", richtig: false },
            { text: "3. Normalform", richtig: true },
            { text: "Keine", richtig: false },
          ]}
          erklaerung={"Das ist eine transitive Abhängigkeit: Ort hängt über die PLZ (ein Nicht-Schlüssel-Attribut) vom Schlüssel ab — Verstoß gegen die 3. Normalform."}
        />

        <QuizFrage
          frage={"Ein Wert muss bei einer Änderung in 20 Zeilen gleichzeitig angepasst werden. Wie heißt dieses Problem?"}
          optionen={[
            { text: "Löschanomalie", richtig: false },
            { text: "Einfügeanomalie", richtig: false },
            { text: "Änderungsanomalie", richtig: true },
            { text: "Transitive Abhängigkeit", richtig: false },
          ]}
          erklaerung={"Wenn derselbe Wert redundant in vielen Zeilen steht und überall geändert werden muss, spricht man von einer Änderungsanomalie."}
        />

        <h2>Verwandte Themen</h2>
        <div className="lp-related">
          <Link href="/lernen/er-diagramm" className="lp-chip">ER-Diagramm →</Link>
          <Link href="/lernen/sql" className="lp-chip">SQL üben →</Link>
          <Link href="/pruefungen" className="lp-chip">Alle IHK-Prüfungen →</Link>
        </div>

        <section className="lp-final">
          <h2>Datenbanken interaktiv trainieren</h2>
          <p>
            In der Lernarena normalisierst du Tabellen mit sofortigem Feedback, echten
            IHK-Prüfungsaufgaben und einem KI-Tutor, der dir jeden Schritt erklärt.
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
