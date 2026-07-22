import type { Metadata } from "next";
import Link from "next/link";
import QuizFrage from "../_components/QuizFrage";

export const metadata: Metadata = {
  title: "SQL üben — SELECT, JOIN & GROUP BY einfach erklärt (IHK)",
  description: "SQL für die IHK-Prüfung: SELECT, WHERE, JOIN, GROUP BY und HAVING mit Beispielen erklärt — plus interaktive Übungsaufgaben für Fachinformatiker (AP1 und AP2).",
  alternates: {
    canonical: "https://lernarena.app/lernen/sql",
  },
  openGraph: {
    type: "article",
    locale: "de_DE",
    url: "https://lernarena.app/lernen/sql",
    siteName: "Lernarena",
    title: "SQL üben — SELECT, JOIN & GROUP BY einfach erklärt (IHK)",
    description: "SQL für die Fachinformatiker-Prüfung: SELECT, JOIN, GROUP BY — mit Beispielen und Übungsaufgaben.",
  },
};

const faq: { q: string; a: string }[] = [
  {
    "q": "Was ist der Unterschied zwischen WHERE und HAVING?",
    "a": "WHERE filtert einzelne Zeilen, bevor gruppiert wird. HAVING filtert erst nach der Gruppierung und darf deshalb Aggregatfunktionen wie COUNT() oder SUM() enthalten. Beides kann in derselben Abfrage vorkommen."
  },
  {
    "q": "Was ist der Unterschied zwischen INNER JOIN und LEFT JOIN?",
    "a": "Ein INNER JOIN liefert nur Datensätze, die in beiden Tabellen einen passenden Partner haben. Ein LEFT JOIN liefert zusätzlich alle Datensätze der linken Tabelle ohne Partner — deren Spalten aus der rechten Tabelle sind dann NULL."
  },
  {
    "q": "Welche Aggregatfunktionen muss ich für die IHK-Prüfung kennen?",
    "a": "Die fünf Klassiker: COUNT() zählt Zeilen, SUM() summiert, AVG() bildet den Durchschnitt, MIN() und MAX() liefern kleinsten und größten Wert. Sie werden fast immer zusammen mit GROUP BY geprüft."
  },
  {
    "q": "Kommt SQL in der AP1 oder AP2 dran?",
    "a": "SQL kann in beiden Prüfungsteilen vorkommen. In der AP1 eher Grundlagen wie SELECT und WHERE, in der AP2 (besonders Anwendungsentwicklung) komplexere Abfragen mit JOINs, Gruppierungen und Unterabfragen."
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
          <Link href="/">Lernarena</Link> · <Link href="/lernen">Lernen</Link> · SQL üben
        </nav>

        <h1>SQL üben — SELECT, JOIN und GROUP BY für die IHK-Prüfung</h1>
        <p className="lp-lead">
          SQL-Abfragen schreiben gehört zu den häufigsten Aufgaben in der
          Fachinformatiker-Prüfung — vor allem für Anwendungsentwickler. Hier lernst
          du das Grundgerüst, JOINs und Gruppierungen mit typischen Prüfungsbeispielen.
        </p>

        <div className="lp-cta-row">
          <Link href="/signup" className="lp-btn lp-btn-primary">Kostenlos üben</Link>
          <Link href="/pruefungen" className="lp-btn lp-btn-ghost">Zu den Prüfungen</Link>
        </div>

        <h2>Das Grundgerüst jeder Abfrage</h2>
        <div className="lp-card">
          <p>
            <span className="lp-mono">SELECT spalten FROM tabelle WHERE bedingung ORDER BY spalte;</span>
          </p>
          <p>
            <strong>SELECT</strong> wählt die Spalten, <strong>FROM</strong> die
            Tabelle, <strong>WHERE</strong> filtert Zeilen <em>vor</em> der Ausgabe,{" "}
            <strong>ORDER BY</strong> sortiert (Standard aufsteigend,{" "}
            <span className="lp-mono">DESC</span> für absteigend).
          </p>
        </div>

        <h2>JOIN — zwei Tabellen verbinden</h2>
        <p>
          In der Prüfung fast immer dabei: Daten aus zwei Tabellen zusammenführen.
          Gegeben seien <span className="lp-mono">kunde(kunden_nr, name, ort)</span> und{" "}
          <span className="lp-mono">auftrag(auftrags_nr, kunden_nr, summe)</span>:
        </p>
        <div className="lp-card">
          <p>
            <span className="lp-mono">
              SELECT k.name, a.summe FROM kunde k INNER JOIN auftrag a ON k.kunden_nr = a.kunden_nr;
            </span>
          </p>
          <p>
            Der <strong>INNER JOIN</strong> liefert nur Kunden, die mindestens einen
            Auftrag haben. Ein <strong>LEFT JOIN</strong> liefert zusätzlich alle
            Kunden ohne Auftrag (mit NULL in den Auftragsspalten) — ein beliebter
            Prüfungsunterschied.
          </p>
        </div>

        <h2>GROUP BY und HAVING</h2>
        <p>
          <strong>GROUP BY</strong> fasst Zeilen zu Gruppen zusammen, Aggregatfunktionen
          wie <span className="lp-mono">COUNT()</span>, <span className="lp-mono">SUM()</span>,{" "}
          <span className="lp-mono">AVG()</span>, <span className="lp-mono">MIN()</span> und{" "}
          <span className="lp-mono">MAX()</span> rechnen pro Gruppe.{" "}
          <strong>HAVING</strong> filtert <em>nach</em> der Gruppierung — während
          WHERE <em>vor</em> der Gruppierung filtert.
        </p>
        <div className="lp-card">
          <p>
            <span className="lp-mono">
              SELECT ort, COUNT(*) AS anzahl FROM kunde GROUP BY ort HAVING COUNT(*) &gt;= 5;
            </span>
          </p>
          <p>
            Liefert alle Orte, in denen mindestens 5 Kunden wohnen. Merke:{" "}
            <strong>WHERE filtert Zeilen, HAVING filtert Gruppen.</strong>
          </p>
        </div>

        <h2>Jetzt selbst testen</h2>
        <p>Beantworte die Fragen und bekomme sofort Feedback — so viele Versuche du willst.</p>

        <QuizFrage
          frage={"Welche Klausel filtert Gruppen nach einer Aggregatfunktion?"}
          optionen={[
            { text: "WHERE", richtig: false },
            { text: "HAVING", richtig: true },
            { text: "GROUP BY", richtig: false },
            { text: "ORDER BY", richtig: false },
          ]}
          erklaerung={"HAVING filtert nach der Gruppierung und darf Aggregatfunktionen enthalten — WHERE filtert Zeilen davor und darf das nicht."}
        />

        <QuizFrage
          frage={"Was liefert ein LEFT JOIN von kunde nach auftrag zusätzlich zum INNER JOIN?"}
          optionen={[
            { text: "Aufträge ohne Kunden", richtig: false },
            { text: "Kunden ohne Aufträge", richtig: true },
            { text: "Nur Kunden mit mehreren Aufträgen", richtig: false },
            { text: "Doppelte Datensätze", richtig: false },
          ]}
          erklaerung={"Der LEFT JOIN behält alle Zeilen der linken Tabelle (kunde) — auch Kunden ohne passenden Auftrag. Deren Auftragsspalten sind dann NULL."}
        />

        <QuizFrage
          frage={"Welche Abfrage zählt die Kunden pro Ort?"}
          optionen={[
            { text: "SELECT ort, SUM(ort) FROM kunde;", richtig: false },
            { text: "SELECT ort, COUNT(*) FROM kunde GROUP BY ort;", richtig: true },
            { text: "SELECT COUNT(ort) FROM kunde ORDER BY ort;", richtig: false },
            { text: "SELECT ort FROM kunde WHERE COUNT(*) > 0;", richtig: false },
          ]}
          erklaerung={"COUNT(*) zählt die Zeilen pro Gruppe, GROUP BY ort bildet die Gruppen. WHERE mit COUNT(*) ist ungültig — dafür gibt es HAVING."}
        />

        <h2>Verwandte Themen</h2>
        <div className="lp-related">
          <Link href="/lernen/er-diagramm" className="lp-chip">ER-Diagramm →</Link>
          <Link href="/lernen/normalisierung" className="lp-chip">Normalisierung →</Link>
          <Link href="/pruefungen" className="lp-chip">Alle IHK-Prüfungen →</Link>
        </div>

        <section className="lp-final">
          <h2>SQL interaktiv trainieren</h2>
          <p>
            In der Lernarena schreibst du SQL-Abfragen mit sofortigem Feedback, echten
            IHK-Prüfungsfragen und einem KI-Tutor, der dir jede Klausel erklärt.
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
