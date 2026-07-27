import type { Metadata } from "next";
import Link from "next/link";
import QuizFrage from "../_components/QuizFrage";

export const metadata: Metadata = {
  title: "Nutzwertanalyse einfach erklärt — mit Beispiel & Rechnung (IHK)",
  description: "Nutzwertanalyse Schritt für Schritt: Kriterien gewichten, Punkte vergeben, Nutzwert berechnen — mit vollständigem Rechenbeispiel und Übungsaufgaben für die IHK-Prüfung (AP1).",
  alternates: {
    canonical: "https://lernarena.app/lernen/nutzwertanalyse",
  },
  openGraph: {
    type: "article",
    locale: "de_DE",
    url: "https://lernarena.app/lernen/nutzwertanalyse",
    siteName: "Lernarena",
    title: "Nutzwertanalyse einfach erklärt — mit Beispiel & Rechnung (IHK)",
    description: "Nutzwertanalyse mit Rechenbeispiel und Übungsaufgaben — der WiSo- und AP1-Klassiker verständlich erklärt.",
  },
};

const faq: { q: string; a: string }[] = [
  {
    "q": "Was ist eine Nutzwertanalyse?",
    "a": "Ein Bewertungsverfahren, das mehrere Alternativen anhand gewichteter Kriterien vergleichbar macht. Jede Alternative bekommt pro Kriterium Punkte, die mit dem Kriteriengewicht multipliziert und aufsummiert werden. Die Alternative mit dem höchsten Nutzwert ist die beste Wahl."
  },
  {
    "q": "Wie berechnet man den Nutzwert?",
    "a": "Pro Kriterium: vergebene Punkte mal Gewichtung. Diese gewichteten Punkte werden für jede Alternative aufsummiert. Wichtig: Die Summe aller Gewichte muss 100 % (bzw. 1,0) ergeben."
  },
  {
    "q": "Wann verwendet man eine Nutzwertanalyse?",
    "a": "Immer wenn eine Entscheidung von mehreren, auch nicht-monetären Kriterien abhängt — typisch beim Vergleich von Angeboten, Lieferanten, Software oder Standorten. In der IHK-Prüfung ist sie ein Klassiker im Bereich Wirtschafts- und Geschäftsprozesse."
  },
  {
    "q": "Was ist der Vorteil gegenüber einem reinen Preisvergleich?",
    "a": "Qualitative Faktoren wie Service, Qualität oder Lieferzeit fließen messbar in die Entscheidung ein. Das günstigste Angebot gewinnt dadurch nicht automatisch — die Entscheidung wird nachvollziehbar und objektiver."
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
`}</style>

      <div className="lp-container">
        <nav className="lp-crumb">
          <Link href="/">Lernarena</Link> · <Link href="/lernen">Lernen</Link> · Nutzwertanalyse
        </nav>

        <h1>Nutzwertanalyse — Schritt für Schritt mit Rechenbeispiel</h1>
        <p className="lp-lead">
          Die Nutzwertanalyse ist der Dauerbrenner in der AP1: Angebote oder Anbieter
          anhand gewichteter Kriterien objektiv vergleichen. Hier lernst du das
          Verfahren in vier Schritten und rechnest ein komplettes Beispiel durch.
        </p>

        <div className="lp-cta-row">
          <Link href="/signup" className="lp-btn lp-btn-primary">Kostenlos üben</Link>
          <Link href="/pruefungen" className="lp-btn lp-btn-ghost">Zu den Prüfungen</Link>
        </div>

        <h2>Wozu dient die Nutzwertanalyse?</h2>
        <p>
          Wenn eine Entscheidung nicht nur vom Preis abhängt, sondern auch von
          qualitativen Kriterien (Service, Qualität, Lieferzeit), macht die{" "}
          <strong>Nutzwertanalyse</strong> die Alternativen vergleichbar: Kriterien
          werden <strong>gewichtet</strong>, jede Alternative bekommt{" "}
          <strong>Punkte</strong>, und die gewichtete Summe ergibt den{" "}
          <strong>Nutzwert</strong>. Die Alternative mit dem höchsten Nutzwert gewinnt.
        </p>

        <div className="lp-tip">
          <p>
            <strong>🏠 Stell es dir wie Wohnungssuche vor:</strong> Du entscheidest ja
            nicht nur nach der Miete. Lage, Größe und Zustand zählen auch — aber nicht
            gleich stark. Vielleicht ist dir die Lage doppelt so wichtig wie der Zustand.
            Genau das machst du mit der <strong>Gewichtung</strong>: Jedem Kriterium gibst
            du ein Gewicht, vergibst pro Wohnung Punkte und rechnest zusammen. Am Ende
            gewinnt nicht automatisch die billigste — sondern die, die zu deinen
            Prioritäten am besten passt.
          </p>
        </div>

        <h2>Die vier Schritte</h2>
        <p>
          <strong>1.</strong> Kriterien festlegen. <strong>2.</strong> Kriterien
          gewichten (Summe der Gewichte = 100 %). <strong>3.</strong> Jede
          Alternative pro Kriterium bewerten (z. B. 1–10 Punkte).{" "}
          <strong>4.</strong> Punkte × Gewicht rechnen, pro Alternative aufsummieren
          und die Rangfolge bilden.
        </p>

        <h2>Komplettes Rechenbeispiel</h2>
        <div className="lp-card">
          <p>
            Zwei Server-Angebote, drei Kriterien: Preis (Gewicht 40 %), Qualität
            (35 %), Service (25 %). Punkteskala 1–10.
          </p>
          <table className="lp-table">
            <thead>
              <tr>
                <th>Kriterium</th>
                <th>Gewicht</th>
                <th>Anbieter A</th>
                <th>Anbieter B</th>
              </tr>
            </thead>
            <tbody>
              <tr><td>Preis</td><td>40 %</td><td>8 → 3,2</td><td>6 → 2,4</td></tr>
              <tr><td>Qualität</td><td>35 %</td><td>6 → 2,1</td><td>9 → 3,15</td></tr>
              <tr><td>Service</td><td>25 %</td><td>7 → 1,75</td><td>8 → 2,0</td></tr>
              <tr><td>Nutzwert</td><td>100 %</td><td>7,05</td><td>7,55</td></tr>
            </tbody>
          </table>
          <p>
            <strong>Anbieter B gewinnt</strong> (7,55 gegen 7,05) — obwohl A beim
            Preis vorn liegt. Genau dieser Effekt („der Billigste gewinnt nicht
            automatisch") ist die typische Prüfungserkenntnis.
          </p>
        </div>

        <div className="lp-tip">
          <p>
            <strong>💡 Prüfungstipp — in dieser Reihenfolge rechnen:</strong> Erst prüfen,
            ob die Gewichte zusammen <span className="lp-mono">100 %</span> ergeben, dann
            pro Feld <span className="lp-mono">Punkte × Gewicht</span>, dann pro Spalte
            aufsummieren, zuletzt die Rangfolge bilden. So kann fast nichts schiefgehen —
            und <strong>runde immer erst ganz am Ende</strong>.
          </p>
        </div>

        <div className="lp-warn">
          <p><strong>⚠️ Häufige Fehler in der Prüfung:</strong></p>
          <ul>
            <li>
              Nicht prüfen, ob die <strong>Gewichte 100 %</strong> ergeben — der häufigste
              Fehler überhaupt.
            </li>
            <li>
              Zwischenergebnisse zu früh runden. Rechne mit den genauen Werten und runde
              erst das Endergebnis.
            </li>
            <li>
              Punkte und Gewicht vertauschen oder das Gewicht als ganze Zahl (40 statt
              0,40) einsetzen.
            </li>
            <li>
              Denken, „der Billigste gewinnt" — die Nutzwertanalyse bezieht bewusst auch
              qualitative Kriterien mit ein.
            </li>
          </ul>
        </div>

        <h2>Jetzt selbst testen</h2>
        <p>Beantworte die Fragen und bekomme sofort Feedback — so viele Versuche du willst.</p>

        <QuizFrage
          frage={"Die Gewichte einer Nutzwertanalyse ergeben zusammen 90 %. Was bedeutet das?"}
          optionen={[
            { text: "Das ist erlaubt, solange alle Kriterien bewertet sind", richtig: false },
            { text: "Die Analyse ist fehlerhaft — die Gewichte müssen 100 % ergeben", richtig: true },
            { text: "Die restlichen 10 % gelten als Puffer", richtig: false },
            { text: "Der Nutzwert muss durch 0,9 geteilt werden", richtig: false },
          ]}
          erklaerung={"Die Summe der Gewichte muss immer 100 % ergeben — sonst ist die Gewichtung inkonsistent und die Nutzwerte sind nicht vergleichbar."}
        />

        <QuizFrage
          frage={"Kriterium Preis: Gewicht 40 %, Anbieter erhält 5 Punkte. Wie viele gewichtete Punkte sind das?"}
          optionen={[
            { text: "0,8", richtig: false },
            { text: "2,0", richtig: true },
            { text: "4,5", richtig: false },
            { text: "5,4", richtig: false },
          ]}
          erklaerung={"Gewichtete Punkte = Punkte × Gewicht = 5 × 0,40 = 2,0."}
        />

        <QuizFrage
          frage={"Wofür ist die Nutzwertanalyse das richtige Werkzeug?"}
          optionen={[
            { text: "Nur für reine Preisvergleiche", richtig: false },
            { text: "Für Entscheidungen mit mehreren, auch qualitativen Kriterien", richtig: true },
            { text: "Für die Berechnung von Abschreibungen", richtig: false },
            { text: "Für die Liquiditätsplanung", richtig: false },
          ]}
          erklaerung={"Die Nutzwertanalyse macht qualitative und quantitative Kriterien gemeinsam vergleichbar — genau dann ist sie das Mittel der Wahl."}
        />

        <QuizFrage
          frage={"Anbieter A hat Nutzwert 7,05, Anbieter B 7,55. Wer bekommt den Zuschlag?"}
          optionen={[
            { text: "Anbieter A", richtig: false },
            { text: "Anbieter B", richtig: true },
            { text: "Beide gleich", richtig: false },
            { text: "Der mit dem niedrigeren Preis", richtig: false },
          ]}
          erklaerung={"Es gewinnt immer die Alternative mit dem höchsten Nutzwert — hier Anbieter B mit 7,55, auch wenn A beim reinen Preis vorne lag."}
        />

        <QuizFrage
          frage={"Kriterium mit Gewicht 25 %, Alternative erhält 8 Punkte. Gewichtete Punkte?"}
          optionen={[
            { text: "2,0", richtig: true },
            { text: "3,2", richtig: false },
            { text: "0,25", richtig: false },
            { text: "8,25", richtig: false },
          ]}
          erklaerung={"8 × 0,25 = 2,0. Immer Punkte mal Gewicht (als Dezimalzahl) rechnen."}
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
          <Link href="/lernen/zahlensysteme" className="lp-chip">Zahlensysteme →</Link>
          <Link href="/lernen/subnetting" className="lp-chip">Subnetting üben →</Link>
          <Link href="/lernen" className="lp-chip">Alle Lernthemen →</Link>
          <Link href="/pruefungen" className="lp-chip">Alle IHK-Prüfungen →</Link>
        </div>

        <section className="lp-final">
          <h2>AP1-Themen interaktiv trainieren</h2>
          <p>
            In der Lernarena rechnest du Nutzwertanalysen und andere AP1-Klassiker mit
            sofortigem Feedback, echten IHK-Prüfungsaufgaben und einem KI-Tutor.
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
