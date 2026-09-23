import type { Metadata } from "next";
import Link from "next/link";
import LernSeite, { type Abschnitt, type MetaEintrag, type Verwandt } from "../_components/LernSeite";
import { LsAbschnitt, LsFaq, LsHinweis, type FaqEintrag } from "../_components/LsBausteine";
import QuizFrage from "../_components/QuizFrage";

export const metadata: Metadata = {
  title: "SQL üben: SELECT, JOIN und GROUP BY erklärt (IHK)",
  description:
    "SQL für die IHK-Prüfung: SELECT, WHERE, JOIN, GROUP BY und HAVING mit Beispielen erklärt, plus interaktive Übungsaufgaben für Fachinformatiker (AP1 und AP2).",
  alternates: {
    canonical: "https://lernarena.app/lernen/sql",
  },
  openGraph: {
    type: "article",
    url: "https://lernarena.app/lernen/sql",
    title: "SQL üben: SELECT, JOIN und GROUP BY erklärt (IHK)",
    description:
      "SQL für die Fachinformatiker-Prüfung: SELECT, JOIN und GROUP BY mit Beispielen und Übungsaufgaben.",
    images: ["/og-image.png"],
  },
};

const abschnitte: Abschnitt[] = [
  { id: "grundgeruest", titel: "Das Grundgerüst" },
  { id: "join", titel: "JOIN" },
  { id: "group-by", titel: "GROUP BY und HAVING" },
  { id: "fehler", titel: "Häufige Fehler" },
  { id: "quiz", titel: "Selbst testen" },
  { id: "faq", titel: "Häufige Fragen" },
];

const meta: MetaEintrag[] = [
  { icon: "zeit", text: "Etwa 8 Minuten" },
  { icon: "rechner", text: "3 Beispielabfragen" },
  { icon: "quiz", text: "5 Quizfragen" },
  { icon: "pruefung", text: "AP1 und AP2" },
];

const verwandt: Verwandt[] = [
  { href: "/lernen/er-diagramm", titel: "ER-Diagramm", untertitel: "Entitäten, Kardinalitäten, n:m-Auflösung" },
  { href: "/lernen/normalisierung", titel: "Normalisierung", untertitel: "1. bis 3. Normalform mit Beispielen" },
  { href: "/lernen", titel: "Alle Lernthemen", untertitel: "10 Themen für AP1 und AP2" },
  { href: "/pruefungen", titel: "Übungsprüfungen", untertitel: "Aufgaben im IHK-Stil mit Korrektur" },
];

const faq: FaqEintrag[] = [
  {
    q: "Was ist der Unterschied zwischen WHERE und HAVING?",
    a: "WHERE filtert einzelne Zeilen, bevor gruppiert wird. HAVING filtert erst nach der Gruppierung und darf deshalb Aggregatfunktionen wie COUNT() oder SUM() enthalten. Beides kann in derselben Abfrage vorkommen.",
  },
  {
    q: "Was ist der Unterschied zwischen INNER JOIN und LEFT JOIN?",
    a: "Ein INNER JOIN liefert nur Datensätze, die in beiden Tabellen einen passenden Partner haben. Ein LEFT JOIN liefert zusätzlich alle Datensätze der linken Tabelle ohne Partner. Deren Spalten aus der rechten Tabelle sind dann NULL.",
  },
  {
    q: "Welche Aggregatfunktionen muss ich für die IHK-Prüfung kennen?",
    a: "Die fünf Klassiker: COUNT() zählt Zeilen, SUM() summiert, AVG() bildet den Durchschnitt, MIN() und MAX() liefern kleinsten und größten Wert. Sie werden fast immer zusammen mit GROUP BY geprüft.",
  },
  {
    q: "Kommt SQL in der AP1 oder AP2 dran?",
    a: "SQL kann in beiden Prüfungsteilen vorkommen. In der AP1 eher Grundlagen wie SELECT und WHERE, in der AP2 (besonders Anwendungsentwicklung) komplexere Abfragen mit JOINs, Gruppierungen und Unterabfragen.",
  },
];

export default function SqlPage() {
  return (
    <LernSeite
      titel="SQL üben: SELECT, JOIN und GROUP BY für die IHK-Prüfung"
      lead="SQL-Abfragen schreiben gehört zu den häufigsten Aufgaben in der Fachinformatiker-Prüfung, vor allem für Anwendungsentwickler. Hier lernst du das Grundgerüst, JOINs und Gruppierungen mit typischen Prüfungsbeispielen."
      pfad="SQL"
      meta={meta}
      abschnitte={abschnitte}
      seitenNotiz={
        <>
          Tabellen und Schlüssel noch unklar? Dann zuerst das{" "}
          <Link href="/lernen/er-diagramm">ER-Diagramm</Link> ansehen, danach lesen sich
          JOINs leichter.
        </>
      }
      verwandt={verwandt}
      cta={{
        titel: "SQL interaktiv trainieren.",
        text: "In der Lernarena schreibst du SQL-Abfragen mit sofortigem Feedback, Aufgaben im IHK-Stil und der KI-Tutorin Ada, die dir jede Klausel erklärt.",
      }}
    >
      <LsAbschnitt id="grundgeruest" titel="Das Grundgerüst jeder Abfrage">
        <pre className="ls-pre" tabIndex={0}>
          <code>{`SELECT spalten
FROM tabelle
WHERE bedingung
ORDER BY spalte;`}</code>
        </pre>
        <p>
          <strong>SELECT</strong> wählt die Spalten, <strong>FROM</strong> die Tabelle,{" "}
          <strong>WHERE</strong> filtert Zeilen <em>vor</em> der Ausgabe,{" "}
          <strong>ORDER BY</strong> sortiert (Standard aufsteigend, <code>DESC</code> für
          absteigend).
        </p>
        <LsHinweis titel="Merkhilfe: die Bestellung beim Bibliothekar" icon="buch" label="Merkhilfe">
          <p>
            <code>SELECT</code> sagt, <em>was</em> du sehen willst (welche Angaben),{" "}
            <code>FROM</code> sagt, <em>aus welchem Regal</em> (welche Tabelle),{" "}
            <code>WHERE</code> ist deine Bedingung („nur Bücher nach 2020“), und{" "}
            <code>ORDER BY</code> ist die Sortierung („alphabetisch bitte“).
          </p>
          <p>
            So schreibst du die Abfrage auf, die Datenbank wertet sie aber logisch in einer
            anderen Reihenfolge aus: <code>FROM</code>, <code>WHERE</code>,{" "}
            <code>GROUP BY</code>, <code>HAVING</code>, <code>SELECT</code> und zuletzt{" "}
            <code>ORDER BY</code>. Deshalb kennt <code>WHERE</code> noch keinen Spaltenalias
            aus dem <code>SELECT</code>, <code>ORDER BY</code> dagegen schon.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="join" titel="JOIN: zwei Tabellen verbinden">
        <p>
          In der Prüfung fast immer dabei: Daten aus zwei Tabellen zusammenführen. Gegeben
          seien die Tabellen <code>kunde</code> und <code>auftrag</code>:
        </p>
        <pre className="ls-pre" tabIndex={0}>
          <code>{`kunde(kunden_nr, name, ort)
auftrag(auftrags_nr, kunden_nr, summe)`}</code>
        </pre>
        <pre className="ls-pre" tabIndex={0}>
          <code>{`SELECT k.name, a.summe
FROM kunde k
INNER JOIN auftrag a ON k.kunden_nr = a.kunden_nr;`}</code>
        </pre>
        <p>
          Der <strong>INNER JOIN</strong> liefert nur Kunden, die mindestens einen Auftrag
          haben. Ein <strong>LEFT JOIN</strong> liefert zusätzlich alle Kunden ohne Auftrag
          (mit NULL in den Auftragsspalten), ein beliebter Prüfungsunterschied.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="group-by" titel="GROUP BY und HAVING">
        <p>
          <strong>GROUP BY</strong> fasst Zeilen zu Gruppen zusammen, Aggregatfunktionen wie{" "}
          <code>COUNT()</code>, <code>SUM()</code>, <code>AVG()</code>, <code>MIN()</code> und{" "}
          <code>MAX()</code> rechnen pro Gruppe. <strong>HAVING</strong> filtert{" "}
          <em>nach</em> der Gruppierung, während WHERE <em>vor</em> der Gruppierung filtert.
        </p>
        <pre className="ls-pre" tabIndex={0}>
          <code>{`SELECT ort, COUNT(*) AS anzahl
FROM kunde
GROUP BY ort
HAVING COUNT(*) >= 5;`}</code>
        </pre>
        <p>
          Liefert alle Orte, in denen mindestens 5 Kunden wohnen. Merke:{" "}
          <strong>WHERE filtert Zeilen, HAVING filtert Gruppen.</strong>
        </p>
        <LsHinweis titel="Prüfungstipp zur Schreibreihenfolge">
          <p>
            Geschrieben wird immer in der festen Reihenfolge <code>SELECT</code>,{" "}
            <code>FROM</code>, <code>WHERE</code>, <code>GROUP BY</code>, <code>HAVING</code>,{" "}
            <code>ORDER BY</code>. Wer sie einhält, macht schon die halbe Aufgabe richtig.
            Faustregel: <strong>WHERE kommt vor der Gruppierung, HAVING danach</strong>, und
            von beiden darf nur HAVING Aggregatfunktionen wie <code>COUNT()</code> enthalten.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="fehler" titel="Häufige Fehler in der Prüfung">
        <LsHinweis art="warnung" titel="Vier Fehler, die in SQL-Aufgaben Punkte kosten">
          <ul>
            <li>
              <code>COUNT()</code> in der <code>WHERE</code>-Klausel benutzen. Das ist
              ungültig, Aggregate gehören in <code>HAVING</code>.
            </li>
            <li>
              Das <strong>Semikolon</strong> am Ende der Abfrage vergessen.
            </li>
            <li>
              Beim <code>GROUP BY</code> Spalten im <code>SELECT</code> vergessen, die nicht
              in einer Aggregatfunktion stehen. Die müssen mit gruppiert werden.
            </li>
            <li>
              <code>INNER JOIN</code> und <code>LEFT JOIN</code> verwechseln: INNER lässt
              Zeilen ohne Partner weg, LEFT behält sie (mit NULL).
            </li>
          </ul>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="quiz" titel="Jetzt selbst testen">
        <p style={{ marginBottom: 18 }}>
          Beantworte die Fragen und bekomme sofort Feedback, so viele Versuche du willst.
        </p>

        <QuizFrage
          nr={1}
          von={5}
          frage="Welche Klausel filtert Gruppen nach einer Aggregatfunktion?"
          optionen={[
            { text: "WHERE", richtig: false },
            { text: "HAVING", richtig: true },
            { text: "GROUP BY", richtig: false },
            { text: "ORDER BY", richtig: false },
          ]}
          erklaerung="HAVING filtert nach der Gruppierung und darf Aggregatfunktionen enthalten. WHERE filtert Zeilen davor und darf das nicht."
        />

        <QuizFrage
          nr={2}
          von={5}
          frage="Was liefert ein LEFT JOIN von kunde nach auftrag zusätzlich zum INNER JOIN?"
          optionen={[
            { text: "Aufträge ohne Kunden", richtig: false },
            { text: "Kunden ohne Aufträge", richtig: true },
            { text: "Nur Kunden mit mehreren Aufträgen", richtig: false },
            { text: "Doppelte Datensätze", richtig: false },
          ]}
          erklaerung="Der LEFT JOIN behält alle Zeilen der linken Tabelle (kunde), also auch Kunden ohne passenden Auftrag. Deren Auftragsspalten sind dann NULL."
        />

        <QuizFrage
          nr={3}
          von={5}
          frage="Welche Abfrage zählt die Kunden pro Ort?"
          optionen={[
            { text: "SELECT ort, SUM(ort) FROM kunde;", richtig: false },
            { text: "SELECT ort, COUNT(*) FROM kunde GROUP BY ort;", richtig: true },
            { text: "SELECT COUNT(ort) FROM kunde ORDER BY ort;", richtig: false },
            { text: "SELECT ort FROM kunde WHERE COUNT(*) > 0;", richtig: false },
          ]}
          erklaerung="COUNT(*) zählt die Zeilen pro Gruppe, GROUP BY ort bildet die Gruppen. WHERE mit COUNT(*) ist ungültig, dafür gibt es HAVING."
        />

        <QuizFrage
          nr={4}
          von={5}
          frage="Wie sortierst du das Ergebnis absteigend nach der Spalte summe?"
          optionen={[
            { text: "ORDER BY summe ASC", richtig: false },
            { text: "ORDER BY summe DESC", richtig: true },
            { text: "GROUP BY summe DESC", richtig: false },
            { text: "SORT BY summe DOWN", richtig: false },
          ]}
          erklaerung="ORDER BY summe DESC sortiert absteigend (höchster Wert zuerst). Ohne Zusatz sortiert ORDER BY aufsteigend (ASC). SORT BY gibt es in Standard-SQL nicht."
        />

        <QuizFrage
          nr={5}
          von={5}
          frage="Welche Aggregatfunktion berechnet den Durchschnitt einer Spalte?"
          optionen={[
            { text: "SUM()", richtig: false },
            { text: "COUNT()", richtig: false },
            { text: "AVG()", richtig: true },
            { text: "MAX()", richtig: false },
          ]}
          erklaerung="AVG() liefert den Mittelwert. SUM() summiert, COUNT() zählt Zeilen, MAX() gibt den größten Wert zurück."
        />
      </LsAbschnitt>

      <LsAbschnitt id="faq" titel="Häufige Fragen">
        <LsFaq eintraege={faq} />
      </LsAbschnitt>
    </LernSeite>
  );
}
