import type { Metadata } from "next";
import Link from "next/link";
import LernSeite, { type Abschnitt, type MetaEintrag, type Verwandt } from "../_components/LernSeite";
import { LsAbschnitt, LsFaq, LsHinweis, type FaqEintrag } from "../_components/LsBausteine";
import QuizFrage from "../_components/QuizFrage";

export const metadata: Metadata = {
  title: "ER-Diagramm: Kardinalitäten und n:m-Auflösung (IHK)",
  description:
    "ER-Diagramme einfach erklärt: Entitäten, Attribute, Beziehungen und Kardinalitäten (1:1, 1:n, n:m), mit Beispiel, n:m-Auflösung und Übungsaufgaben für die IHK-Prüfung.",
  alternates: {
    canonical: "https://lernarena.app/lernen/er-diagramm",
  },
  openGraph: {
    type: "article",
    url: "https://lernarena.app/lernen/er-diagramm",
    title: "ER-Diagramm: Kardinalitäten und n:m-Auflösung (IHK)",
    description:
      "ER-Modell für die Fachinformatiker-Prüfung: Kardinalitäten, n:m-Auflösung und Übungsaufgaben.",
    images: ["/og-image.png"],
  },
};

const abschnitte: Abschnitt[] = [
  { id: "bausteine", titel: "Die drei Bausteine" },
  { id: "kardinalitaeten", titel: "Kardinalitäten" },
  { id: "nm-aufloesen", titel: "n:m auflösen" },
  { id: "tabellen", titel: "Vom ER-Modell zur Tabelle" },
  { id: "fehler", titel: "Häufige Fehler" },
  { id: "quiz", titel: "Selbst testen" },
  { id: "faq", titel: "Häufige Fragen" },
];

const meta: MetaEintrag[] = [
  { icon: "zeit", text: "Etwa 6 Minuten" },
  { icon: "rechner", text: "Kardinalitäten-Tabelle und n:m-Beispiel" },
  { icon: "quiz", text: "5 Quizfragen" },
  { icon: "pruefung", text: "Datenbankaufgaben der IHK-Prüfung" },
];

const verwandt: Verwandt[] = [
  { href: "/lernen/normalisierung", titel: "Normalisierung", untertitel: "1. bis 3. Normalform mit Beispielen" },
  { href: "/lernen/sql", titel: "SQL üben", untertitel: "SELECT, JOIN und GROUP BY" },
  { href: "/lernen", titel: "Alle Lernthemen", untertitel: "10 Themen für AP1 und AP2" },
  { href: "/pruefungen", titel: "Übungsprüfungen", untertitel: "Aufgaben im IHK-Stil mit Korrektur" },
];

const kardinalitaeten: { typ: string; bedeutung: string; beispiel: string }[] = [
  { typ: "1:1", bedeutung: "Jedem A gehört genau ein B", beispiel: "Mitarbeiter und Firmenlaptop" },
  { typ: "1:n", bedeutung: "Ein A hat viele B, jedes B genau ein A", beispiel: "Kunde und Aufträge" },
  { typ: "n:m", bedeutung: "Viele A stehen mit vielen B in Beziehung", beispiel: "Schüler und Kurse" },
];

const faq: FaqEintrag[] = [
  {
    q: "Was ist ein ER-Diagramm?",
    a: "Ein Entity-Relationship-Diagramm modelliert einen Datenbestand grafisch: Entitäten (Objekte wie Kunde oder Artikel), deren Attribute und die Beziehungen zwischen den Entitäten inklusive Kardinalitäten. Es ist die Vorstufe zum Tabellenentwurf einer relationalen Datenbank.",
  },
  {
    q: "Welche Kardinalitäten gibt es?",
    a: "Die drei Grundtypen sind 1:1 (jedem A gehört genau ein B), 1:n (ein A hat beliebig viele B) und n:m (viele A stehen mit vielen B in Beziehung). In der Prüfung wird oft die passende Kardinalität zu einem Sachverhalt gesucht.",
  },
  {
    q: "Wie löst man eine n:m-Beziehung auf?",
    a: "Durch eine Zwischentabelle, die die Primärschlüssel beider Entitäten als Fremdschlüssel enthält und die n:m-Beziehung in zwei 1:n-Beziehungen zerlegt. Die Zwischentabelle kann eigene Attribute tragen, etwa eine Note bei Schüler-Kurs.",
  },
  {
    q: "Wohin kommt der Fremdschlüssel bei einer 1:n-Beziehung?",
    a: "Immer in die Tabelle der n-Seite. Beispiel Kunde und Auftrag: Die kunden_nr steht als Fremdschlüssel in der Auftragstabelle, denn jeder Auftrag gehört zu genau einem Kunden.",
  },
];

export default function ErDiagrammPage() {
  return (
    <LernSeite
      titel="ER-Diagramm erstellen: Entitäten, Beziehungen und Kardinalitäten"
      lead="Das Entity-Relationship-Modell ist der Standard-Einstieg in jede Datenbankaufgabe der IHK-Prüfung. Hier lernst du Entitäten, Beziehungen und Kardinalitäten kennen. Außerdem zeigen wir dir, wie du eine n:m-Beziehung sauber auflöst."
      pfad="ER-Diagramm"
      meta={meta}
      abschnitte={abschnitte}
      seitenNotiz={
        <>
          Steht das Modell, geht es mit der{" "}
          <Link href="/lernen/normalisierung">Normalisierung</Link> weiter.
        </>
      }
      verwandt={verwandt}
      cta={{
        titel: "Datenbanken interaktiv trainieren.",
        text: "In der Lernarena modellierst du ER-Diagramme und überführst sie in Tabellen: mit sofortigem Feedback, Aufgaben im IHK-Stil und der KI-Tutorin Ada.",
      }}
    >
      <LsAbschnitt id="bausteine" titel="Die drei Bausteine">
        <p>
          Eine <strong>Entität</strong> ist ein Objekt der realen Welt (Kunde, Artikel,
          Auftrag). <strong>Attribute</strong> beschreiben die Entität (Name, Preis, Datum).
          Eines davon ist der <strong>Primärschlüssel</strong>, der jeden Datensatz eindeutig
          identifiziert. <strong>Beziehungen</strong> verbinden Entitäten miteinander und
          tragen die Kardinalität.
        </p>
        <LsHinweis titel="Merkhilfe: der Bauplan für deine Datenbank" icon="haus" label="Merkhilfe">
          <p>
            Bevor ein Haus gebaut wird, zeichnet der Architekt einen Grundriss. Das
            ER-Diagramm ist genau dieser Grundriss für deine Datenbank. Die{" "}
            <strong>Entitäten</strong> sind die Räume (Kunde, Artikel), die{" "}
            <strong>Attribute</strong> die Einrichtung darin, und die{" "}
            <strong>Beziehungen</strong> sind die Türen zwischen den Räumen. Die{" "}
            <strong>Kardinalität</strong> sagt, wie viele durch eine Tür passen: eine Person
            oder viele Personen? Erst wenn der Plan steht, „baust“ du daraus die Tabellen.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="kardinalitaeten" titel="Die Kardinalitäten">
        <div
          className="ls-table-wrap"
          role="region"
          aria-label="Kardinalitäten im Überblick, seitlich scrollbar"
          tabIndex={0}
        >
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Typ</th>
                <th scope="col">Bedeutung</th>
                <th scope="col">Beispiel</th>
              </tr>
            </thead>
            <tbody>
              {kardinalitaeten.map((k) => (
                <tr key={k.typ}>
                  <td>{k.typ}</td>
                  <td className="txt">{k.bedeutung}</td>
                  <td>{k.beispiel}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </LsAbschnitt>

      <LsAbschnitt id="nm-aufloesen" titel="Der Prüfungsklassiker: n:m auflösen">
        <p>
          Eine <strong>n:m-Beziehung</strong> lässt sich nicht direkt in Tabellen umsetzen.
          Sie wird über eine <strong>Zwischentabelle</strong> (auch Kreuz- oder
          Beziehungstabelle) in zwei 1:n-Beziehungen zerlegt.
        </p>
        <p>
          Beispiel: <code>schueler(schueler_id, name)</code> und{" "}
          <code>kurs(kurs_id, titel)</code> bekommen die Zwischentabelle{" "}
          <code>belegung(schueler_id, kurs_id, note)</code>. Ihr Primärschlüssel ist meist die
          Kombination beider Fremdschlüssel, und sie kann eigene Attribute tragen (hier: die
          Note).
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="tabellen" titel="Vom ER-Modell zur Tabelle">
        <p>
          Bei der Überführung gilt: Jede Entität wird eine Tabelle. Bei <strong>1:n</strong>{" "}
          wandert der Primärschlüssel der 1-Seite als <strong>Fremdschlüssel</strong> in die
          n-Seite (der Kunde steckt als <code>kunden_nr</code> im Auftrag, nie umgekehrt). Bei{" "}
          <strong>n:m</strong> entsteht die Zwischentabelle. Genau diese Überführung ist eine
          Standard-Teilaufgabe der Prüfung.
        </p>
        <LsHinweis titel="Prüfungstipp: Fremdschlüssel richtig setzen">
          <p>
            Der Fremdschlüssel wandert bei <code>1:n</code>{" "}
            <strong>immer auf die n-Seite</strong> („der Kunde steckt im Auftrag, nicht
            umgekehrt“). Und eine <code>n:m</code>-Beziehung wird <strong>nie</strong> direkt
            umgesetzt, sie braucht immer eine Zwischentabelle. Wer sich nur diese zwei Regeln
            merkt, holt sich fast alle Punkte bei Datenbankaufgaben.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="fehler" titel="Häufige Fehler in der Prüfung">
        <LsHinweis art="warnung" titel="Vier Stolperfallen, die regelmäßig Punkte kosten">
          <ul>
            <li>
              Den Fremdschlüssel auf die falsche Seite setzen (bei 1:n auf die 1-Seite statt
              auf die n-Seite).
            </li>
            <li>
              Die <code>n:m</code>-Beziehung ohne Zwischentabelle „direkt“ verbinden. Das geht
              in einer relationalen Datenbank nicht.
            </li>
            <li>
              Den Primärschlüssel vergessen. Jede Tabelle braucht einen, denn er identifiziert
              jeden Datensatz eindeutig.
            </li>
            <li>
              Kardinalität aus der falschen Richtung lesen: „Ein Kunde hat viele Aufträge“ ist
              aus Kundensicht 1:n, aus Auftragssicht n:1. Beides beschreibt dieselbe
              Beziehung.
            </li>
          </ul>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="quiz" titel="Jetzt selbst testen">
        <p style={{ marginBottom: 18 }}>
          Beantworte die Fragen und bekomme sofort Feedback. Du hast so viele Versuche, wie
          du willst.
        </p>

        <QuizFrage
          nr={1}
          von={5}
          frage="Ein Kunde kann viele Aufträge haben, jeder Auftrag gehört zu genau einem Kunden. Welche Kardinalität ist das?"
          optionen={[
            { text: "1:1", richtig: false },
            { text: "1:n", richtig: true },
            { text: "n:m", richtig: false },
            { text: "n:1 von Kunde aus gesehen", richtig: false },
          ]}
          erklaerung="Von Kunde zu Auftrag ist es 1:n. Ein Kunde hat beliebig viele Aufträge, aber jeder Auftrag genau einen Kunden."
        />

        <QuizFrage
          nr={2}
          von={5}
          frage="Wie wird eine n:m-Beziehung in einer relationalen Datenbank umgesetzt?"
          optionen={[
            { text: "Durch einen doppelten Primärschlüssel in einer der Tabellen", richtig: false },
            { text: "Durch eine Zwischentabelle mit beiden Fremdschlüsseln", richtig: true },
            { text: "Durch NULL-Werte in beiden Tabellen", richtig: false },
            { text: "Gar nicht, n:m ist verboten", richtig: false },
          ]}
          erklaerung="Die Zwischentabelle enthält die Primärschlüssel beider Entitäten als Fremdschlüssel und zerlegt die n:m-Beziehung in zwei 1:n-Beziehungen."
        />

        <QuizFrage
          nr={3}
          von={5}
          frage="Wohin gehört der Fremdschlüssel bei der Beziehung Kunde (1) zu Auftrag (n)?"
          optionen={[
            { text: "In die Kundentabelle", richtig: false },
            { text: "In die Auftragstabelle", richtig: true },
            { text: "In eine Zwischentabelle", richtig: false },
            { text: "In beide Tabellen", richtig: false },
          ]}
          erklaerung="Bei 1:n wandert der Primärschlüssel der 1-Seite als Fremdschlüssel in die n-Seite: die kunden_nr steht in jedem Auftrag."
        />

        <QuizFrage
          nr={4}
          von={5}
          frage="Ein Schüler kann viele Kurse belegen, ein Kurs hat viele Schüler. Welche Kardinalität liegt vor?"
          optionen={[
            { text: "1:1", richtig: false },
            { text: "1:n", richtig: false },
            { text: "n:m", richtig: true },
            { text: "n:1", richtig: false },
          ]}
          erklaerung="Viele Schüler stehen mit vielen Kursen in Beziehung, das ist n:m. In Tabellen wird das über eine Zwischentabelle (z. B. belegung) aufgelöst."
        />

        <QuizFrage
          nr={5}
          von={5}
          frage="Was identifiziert einen Datensatz in einer Tabelle eindeutig?"
          optionen={[
            { text: "Der Fremdschlüssel", richtig: false },
            { text: "Der Primärschlüssel", richtig: true },
            { text: "Das erste Attribut", richtig: false },
            { text: "Die Kardinalität", richtig: false },
          ]}
          erklaerung="Der Primärschlüssel macht jeden Datensatz eindeutig. Der Fremdschlüssel verweist dagegen auf den Primärschlüssel einer anderen Tabelle."
        />
      </LsAbschnitt>

      <LsAbschnitt id="faq" titel="Häufige Fragen">
        <LsFaq eintraege={faq} />
      </LsAbschnitt>
    </LernSeite>
  );
}
