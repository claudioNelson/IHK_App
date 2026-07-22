import type { Metadata } from "next";
import Link from "next/link";
import QuizFrage from "../_components/QuizFrage";

export const metadata: Metadata = {
  title: "Sortieralgorithmen — Bubblesort, Quicksort & Mergesort (IHK)",
  description: "Sortieralgorithmen für die IHK-Prüfung: Bubblesort, Insertionsort, Quicksort und Mergesort mit Laufzeiten, Stabilität und Beispieldurchlauf — plus interaktive Übungsaufgaben.",
  alternates: {
    canonical: "https://lernarena.app/lernen/sortieralgorithmen",
  },
  openGraph: {
    type: "article",
    locale: "de_DE",
    url: "https://lernarena.app/lernen/sortieralgorithmen",
    siteName: "Lernarena",
    title: "Sortieralgorithmen — Bubblesort, Quicksort & Mergesort (IHK)",
    description: "Bubblesort, Quicksort, Mergesort: Laufzeiten, Stabilität und Beispieldurchlauf für die Fachinformatiker-Prüfung.",
  },
};

const faq: { q: string; a: string }[] = [
  {
    "q": "Welcher Sortieralgorithmus ist der schnellste?",
    "a": "Im Durchschnitt gehört Quicksort mit O(n log n) zu den schnellsten Verfahren. Mergesort garantiert O(n log n) sogar im schlechtesten Fall, braucht aber zusätzlichen Speicher. Einfache Verfahren wie Bubblesort liegen bei O(n²) und sind nur für kleine Datenmengen geeignet."
  },
  {
    "q": "Was bedeutet ein stabiles Sortierverfahren?",
    "a": "Ein Verfahren ist stabil, wenn Elemente mit gleichem Sortierwert ihre ursprüngliche Reihenfolge behalten. Bubblesort, Insertionsort und Mergesort sind stabil — Selectionsort und Quicksort in der Standardform nicht."
  },
  {
    "q": "Wie funktioniert Bubblesort?",
    "a": "Bubblesort vergleicht wiederholt benachbarte Elemente und vertauscht sie, wenn sie in der falschen Reihenfolge stehen. Nach jedem Durchlauf steht das größte verbleibende Element am Ende — es steigt wie eine Blase auf. Laufzeit im Normalfall O(n²)."
  },
  {
    "q": "Wann hat Quicksort seinen Worst Case?",
    "a": "Wenn das Pivot-Element wiederholt ungünstig gewählt wird — klassisch bei einer bereits sortierten Folge und Pivot am Rand. Dann zerfällt die Aufteilung in extrem ungleiche Teile und die Laufzeit wird O(n²)."
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
          font-weight: 600; font-size: 16px; text-decoration: none; transition: transform .12s ease;
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
          <Link href="/">Lernarena</Link> · <Link href="/lernen">Lernen</Link> · Sortieralgorithmen
        </nav>

        <h1>Sortieralgorithmen — Bubblesort, Quicksort und Mergesort im Vergleich</h1>
        <p className="lp-lead">
          Sortierverfahren mit ihren Laufzeiten vergleichen und einen Durchlauf per
          Hand ausführen — beides sind Klassiker der Fachinformatiker-Prüfung
          (besonders Anwendungsentwicklung). Hier bekommst du beides kompakt.
        </p>

        <div className="lp-cta-row">
          <Link href="/signup" className="lp-btn lp-btn-primary">Kostenlos üben</Link>
          <Link href="/pruefungen" className="lp-btn lp-btn-ghost">Zu den Prüfungen</Link>
        </div>

        <h2>Die wichtigsten Verfahren im Vergleich</h2>
        <table className="lp-table">
          <thead>
            <tr>
              <th>Verfahren</th>
              <th>Best Case</th>
              <th>Average</th>
              <th>Worst Case</th>
              <th>Stabil?</th>
            </tr>
          </thead>
          <tbody>
            <tr><td>Bubblesort</td><td>O(n)</td><td>O(n²)</td><td>O(n²)</td><td>ja</td></tr>
            <tr><td>Insertionsort</td><td>O(n)</td><td>O(n²)</td><td>O(n²)</td><td>ja</td></tr>
            <tr><td>Selectionsort</td><td>O(n²)</td><td>O(n²)</td><td>O(n²)</td><td>nein</td></tr>
            <tr><td>Quicksort</td><td>O(n log n)</td><td>O(n log n)</td><td>O(n²)</td><td>nein</td></tr>
            <tr><td>Mergesort</td><td>O(n log n)</td><td>O(n log n)</td><td>O(n log n)</td><td>ja</td></tr>
          </tbody>
        </table>
        <p>
          <strong>Stabil</strong> heißt: Gleiche Werte behalten ihre ursprüngliche
          Reihenfolge. Das ist wichtig, wenn nach mehreren Kriterien nacheinander
          sortiert wird — ein beliebtes Prüfungsdetail.
        </p>

        <h2>Bubblesort per Hand — ein Durchlauf</h2>
        <div className="lp-card">
          <p>
            <strong>Ausgangsfolge:</strong> <span className="lp-mono">5, 2, 4, 1</span>.
            Bubblesort vergleicht immer zwei Nachbarn und tauscht, wenn sie falsch
            herum stehen.
          </p>
          <p>
            Vergleich 5|2 → tauschen: <span className="lp-mono">2, 5, 4, 1</span><br />
            Vergleich 5|4 → tauschen: <span className="lp-mono">2, 4, 5, 1</span><br />
            Vergleich 5|1 → tauschen: <span className="lp-mono">2, 4, 1, 5</span>
          </p>
          <p>
            Nach dem ersten Durchlauf steht das <strong>größte Element ganz
            hinten</strong> — es ist wie eine Blase nach oben „aufgestiegen". Genau
            diese Eigenschaft wird in Prüfungen gern abgefragt.
          </p>
        </div>

        <h2>Quicksort und Mergesort in Kürze</h2>
        <p>
          <strong>Quicksort</strong> wählt ein Pivot-Element, teilt die Folge in
          „kleiner" und „größer" und sortiert die Teile rekursiv. Im Schnitt sehr
          schnell — aber bei ungünstigem Pivot (z. B. bereits sortierte Folge)
          degradiert er zu O(n²). <strong>Mergesort</strong> teilt die Folge immer in
          der Mitte, sortiert beide Hälften rekursiv und verschmilzt sie (Merge).
          Er garantiert O(n log n), braucht dafür aber zusätzlichen Speicher.
        </p>

        <h2>Jetzt selbst testen</h2>
        <p>Beantworte die Fragen und bekomme sofort Feedback — so viele Versuche du willst.</p>

        <QuizFrage
          frage={"Welches Verfahren ist stabil UND garantiert O(n log n) im Worst Case?"}
          optionen={[
            { text: "Quicksort", richtig: false },
            { text: "Mergesort", richtig: true },
            { text: "Bubblesort", richtig: false },
            { text: "Selectionsort", richtig: false },
          ]}
          erklaerung={"Mergesort ist stabil und läuft auch im schlechtesten Fall in O(n log n). Quicksort ist im Worst Case O(n²) und nicht stabil."}
        />

        <QuizFrage
          frage={"Was gilt nach dem ersten kompletten Durchlauf von Bubblesort?"}
          optionen={[
            { text: "Das kleinste Element steht vorne", richtig: false },
            { text: "Das größte Element steht hinten", richtig: true },
            { text: "Die Folge ist fertig sortiert", richtig: false },
            { text: "Die Hälfte der Elemente ist sortiert", richtig: false },
          ]}
          erklaerung={"Bubblesort schiebt in jedem Durchlauf das größte verbleibende Element ans Ende — nach Durchlauf 1 steht das Maximum ganz hinten."}
        />

        <QuizFrage
          frage={"Bei welcher Eingabe zeigt Quicksort (Pivot = letztes Element) seinen Worst Case?"}
          optionen={[
            { text: "Bei zufälliger Reihenfolge", richtig: false },
            { text: "Bei einer bereits sortierten Folge", richtig: true },
            { text: "Bei lauter gleichen Elementen im besten Fall", richtig: false },
            { text: "Quicksort hat keinen Worst Case", richtig: false },
          ]}
          erklaerung={"Bei einer sortierten Folge teilt das Rand-Pivot die Folge maximal ungleich — die Rekursionstiefe wird n und die Laufzeit O(n²)."}
        />

        <h2>Verwandte Themen</h2>
        <div className="lp-related">
          <Link href="/lernen/sql" className="lp-chip">SQL üben →</Link>
          <Link href="/lernen/er-diagramm" className="lp-chip">ER-Diagramm →</Link>
          <Link href="/pruefungen" className="lp-chip">Alle IHK-Prüfungen →</Link>
        </div>

        <section className="lp-final">
          <h2>Algorithmen interaktiv trainieren</h2>
          <p>
            In der Lernarena führst du Sortierdurchläufe Schritt für Schritt aus — mit
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
