import type { Metadata } from "next";
import LernSeite, { type Abschnitt, type MetaEintrag, type Verwandt } from "../_components/LernSeite";
import { LsAbschnitt, LsFaq, LsHinweis, type FaqEintrag } from "../_components/LsBausteine";
import QuizFrage from "../_components/QuizFrage";

export const metadata: Metadata = {
  title: "Sortieralgorithmen: Bubblesort, Quicksort, Mergesort (IHK)",
  description:
    "Sortieralgorithmen für die IHK-Prüfung: Bubblesort, Insertionsort, Quicksort und Mergesort mit Laufzeiten, Stabilität und Beispieldurchlauf, plus interaktive Übungsaufgaben.",
  alternates: {
    canonical: "https://lernarena.app/lernen/sortieralgorithmen",
  },
  openGraph: {
    type: "article",
    url: "https://lernarena.app/lernen/sortieralgorithmen",
    title: "Sortieralgorithmen: Bubblesort, Quicksort, Mergesort (IHK)",
    description:
      "Bubblesort, Quicksort, Mergesort: Laufzeiten, Stabilität und Beispieldurchlauf für die Fachinformatiker-Prüfung.",
    images: ["/og-image.png"],
  },
};

const abschnitte: Abschnitt[] = [
  { id: "vergleich", titel: "Verfahren im Vergleich" },
  { id: "bubblesort", titel: "Bubblesort per Hand" },
  { id: "quicksort-mergesort", titel: "Quicksort und Mergesort" },
  { id: "fehler", titel: "Häufige Fehler" },
  { id: "quiz", titel: "Selbst testen" },
  { id: "faq", titel: "Häufige Fragen" },
];

const meta: MetaEintrag[] = [
  { icon: "zeit", text: "Etwa 7 Minuten" },
  { icon: "rechner", text: "Laufzeittabelle und Beispieldurchlauf" },
  { icon: "quiz", text: "5 Quizfragen" },
  { icon: "pruefung", text: "AP2, besonders Anwendungsentwicklung" },
];

const verwandt: Verwandt[] = [
  { href: "/lernen/sql", titel: "SQL üben", untertitel: "SELECT, JOIN, GROUP BY und HAVING" },
  { href: "/lernen/er-diagramm", titel: "ER-Diagramm", untertitel: "Entitäten, Kardinalitäten, n:m-Auflösung" },
  { href: "/lernen", titel: "Alle Lernthemen", untertitel: "10 Themen für AP1 und AP2" },
  { href: "/pruefungen", titel: "Übungsprüfungen", untertitel: "Aufgaben im IHK-Stil mit Korrektur" },
];

const verfahren: { name: string; best: string; mittel: string; worst: string; stabil: string }[] = [
  { name: "Bubblesort", best: "O(n)", mittel: "O(n²)", worst: "O(n²)", stabil: "ja" },
  { name: "Insertionsort", best: "O(n)", mittel: "O(n²)", worst: "O(n²)", stabil: "ja" },
  { name: "Selectionsort", best: "O(n²)", mittel: "O(n²)", worst: "O(n²)", stabil: "nein" },
  { name: "Quicksort", best: "O(n log n)", mittel: "O(n log n)", worst: "O(n²)", stabil: "nein" },
  { name: "Mergesort", best: "O(n log n)", mittel: "O(n log n)", worst: "O(n log n)", stabil: "ja" },
];

const faq: FaqEintrag[] = [
  {
    q: "Welcher Sortieralgorithmus ist der schnellste?",
    a: "Im Durchschnitt gehört Quicksort mit O(n log n) zu den schnellsten Verfahren. Mergesort garantiert O(n log n) sogar im schlechtesten Fall, braucht aber zusätzlichen Speicher. Einfache Verfahren wie Bubblesort liegen bei O(n²) und sind nur für kleine Datenmengen geeignet.",
  },
  {
    q: "Was bedeutet ein stabiles Sortierverfahren?",
    a: "Ein Verfahren ist stabil, wenn Elemente mit gleichem Sortierwert ihre ursprüngliche Reihenfolge behalten. Bubblesort, Insertionsort und Mergesort sind stabil, Selectionsort und Quicksort in der Standardform nicht.",
  },
  {
    q: "Wie funktioniert Bubblesort?",
    a: "Bubblesort vergleicht wiederholt benachbarte Elemente und vertauscht sie, wenn sie in der falschen Reihenfolge stehen. Nach jedem Durchlauf steht das größte verbleibende Element am Ende, es steigt wie eine Blase auf. Laufzeit im Normalfall O(n²).",
  },
  {
    q: "Wann tritt bei Quicksort der schlechteste Fall ein?",
    a: "Wenn das Pivot-Element wiederholt ungünstig gewählt wird, klassisch bei einer bereits sortierten Folge und Pivot am Rand. Dann zerfällt die Aufteilung in extrem ungleiche Teile und die Laufzeit wird O(n²).",
  },
];

export default function SortieralgorithmenPage() {
  return (
    <LernSeite
      titel="Sortieralgorithmen: Bubblesort, Quicksort und Mergesort im Vergleich"
      lead="Sortierverfahren mit ihren Laufzeiten vergleichen und einen Durchlauf per Hand ausführen: Beides sind Klassiker der Fachinformatiker-Prüfung (besonders Anwendungsentwicklung). Hier bekommst du beides kompakt."
      pfad="Sortieralgorithmen"
      meta={meta}
      abschnitte={abschnitte}
      verwandt={verwandt}
      cta={{
        titel: "Algorithmen interaktiv trainieren.",
        text: "In der Lernarena führst du Sortierdurchläufe Schritt für Schritt aus: mit sofortigem Feedback, Aufgaben im IHK-Stil und der KI-Tutorin Ada.",
      }}
    >
      <LsAbschnitt id="vergleich" titel="Die wichtigsten Verfahren im Vergleich">
        <LsHinweis titel="Zuerst kurz zur O-Notation">
          <p>
            Sie beschreibt nur, wie stark der Aufwand <em>wächst</em>, wenn die Datenmenge
            größer wird, nicht die genaue Zeit. <code>O(n²)</code> heißt: Doppelt so viele
            Elemente bedeuten viermal so viel Arbeit (schlecht bei großen Mengen).{" "}
            <code>O(n log n)</code> wächst viel langsamer und ist deshalb bei großen
            Datenmengen klar besser. Denk an Karten sortieren: <strong>Insertionsort</strong>{" "}
            ist genau das, was du intuitiv tust. Du nimmst eine Karte und steckst sie an die
            richtige Stelle in deiner Hand.
          </p>
        </LsHinweis>
        <p>
          Die Tabelle zeigt die Laufzeit im besten, mittleren und schlechtesten Fall. In
          Prüfungsaufgaben stehen dafür oft die englischen Begriffe Best Case, Average Case
          und Worst Case.
        </p>
        <div
          className="ls-table-wrap"
          role="region"
          aria-label="Sortierverfahren im Vergleich, seitlich scrollbar"
          tabIndex={0}
        >
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Verfahren</th>
                <th scope="col">Bester Fall</th>
                <th scope="col">Mittlerer Fall</th>
                <th scope="col">Schlechtester Fall</th>
                <th scope="col">Stabil?</th>
              </tr>
            </thead>
            <tbody>
              {verfahren.map((v) => (
                <tr key={v.name}>
                  <td>{v.name}</td>
                  <td>{v.best}</td>
                  <td>{v.mittel}</td>
                  <td>{v.worst}</td>
                  <td>{v.stabil}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        <p>
          <strong>Stabil</strong> heißt: Gleiche Werte behalten ihre ursprüngliche
          Reihenfolge. Das ist wichtig, wenn nach mehreren Kriterien nacheinander sortiert
          wird (ein beliebtes Prüfungsdetail).
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="bubblesort" titel="Bubblesort per Hand: ein Durchlauf">
        <p className="ls-task">
          <strong>Ausgangsfolge:</strong> <code>5, 2, 4, 1</code>. Bubblesort vergleicht
          immer zwei Nachbarn und tauscht, wenn sie falsch herum stehen.
        </p>
        <pre className="ls-pre" tabIndex={0}>
          <code>{`Start:                          5, 2, 4, 1
5 und 2 vergleichen, tauschen:  2, 5, 4, 1
5 und 4 vergleichen, tauschen:  2, 4, 5, 1
5 und 1 vergleichen, tauschen:  2, 4, 1, 5`}</code>
        </pre>
        <p>
          Nach dem ersten Durchlauf steht das <strong>größte Element ganz hinten</strong>, es
          ist wie eine Blase nach oben „aufgestiegen“. Genau diese Eigenschaft wird in
          Prüfungen gern abgefragt.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="quicksort-mergesort" titel="Quicksort und Mergesort in Kürze">
        <p>
          <strong>Quicksort</strong> wählt ein Pivot-Element, teilt die Folge in „kleiner“
          und „größer“ und sortiert die Teile rekursiv. Im Schnitt sehr schnell, aber bei
          ungünstigem Pivot (z. B. bereits sortierte Folge) degradiert er zu O(n²).{" "}
          <strong>Mergesort</strong> teilt die Folge immer in der Mitte, sortiert beide
          Hälften rekursiv und verschmilzt sie (Merge). Er garantiert O(n log n), braucht
          dafür aber zusätzlichen Speicher.
        </p>
        <LsHinweis titel="Prüfungstipp: Das musst du sicher wissen">
          <p>
            <code>Mergesort</code> = immer <code>O(n log n)</code> und stabil (aber extra
            Speicher). <code>Quicksort</code> = im Schnitt schnell, aber im schlechtesten Fall{" "}
            <code>O(n²)</code> bei schon sortierter Folge.{" "}
            <code>Bubble-, Insertion- und Selectionsort</code> = einfach, aber{" "}
            <code>O(n²)</code>. Diese drei Fakten decken die meisten Fragen ab.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="fehler" titel="Häufige Fehler in der Prüfung">
        <LsHinweis art="warnung" titel="Vier Stolperfallen, die regelmäßig Punkte kosten">
          <ul>
            <li>
              Quicksort für „immer schnell“ halten. Sein schlechtester Fall ist{" "}
              <code>O(n²)</code>, nicht O(n log n).
            </li>
            <li>
              „Stabil“ mit „schnell“ verwechseln. Stabil heißt nur: Gleiche Werte behalten
              ihre Reihenfolge.
            </li>
            <li>
              Bei Bubblesort einen Durchlauf falsch zählen. Pro Durchlauf wandert{" "}
              <strong>ein</strong> größtes Element ans Ende, nicht die halbe Folge.
            </li>
            <li>
              <code>O(n log n)</code> und <code>O(n²)</code> verwechseln: n log n wächst
              deutlich langsamer und ist bei großen Datenmengen besser.
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
          frage="Welches Verfahren ist stabil UND garantiert O(n log n) auch im schlechtesten Fall?"
          optionen={[
            { text: "Quicksort", richtig: false },
            { text: "Mergesort", richtig: true },
            { text: "Bubblesort", richtig: false },
            { text: "Selectionsort", richtig: false },
          ]}
          erklaerung="Mergesort ist stabil und läuft auch im schlechtesten Fall in O(n log n). Quicksort ist im schlechtesten Fall O(n²) und nicht stabil."
        />

        <QuizFrage
          nr={2}
          von={5}
          frage="Was gilt nach dem ersten kompletten Durchlauf von Bubblesort?"
          optionen={[
            { text: "Das kleinste Element steht vorne", richtig: false },
            { text: "Das größte Element steht hinten", richtig: true },
            { text: "Die Folge ist fertig sortiert", richtig: false },
            { text: "Die Hälfte der Elemente ist sortiert", richtig: false },
          ]}
          erklaerung="Bubblesort schiebt in jedem Durchlauf das größte verbleibende Element ans Ende. Nach Durchlauf 1 steht das Maximum also ganz hinten."
        />

        <QuizFrage
          nr={3}
          von={5}
          frage="Bei welcher Eingabe zeigt Quicksort (Pivot = letztes Element) seinen schlechtesten Fall?"
          optionen={[
            { text: "Bei zufälliger Reihenfolge", richtig: false },
            { text: "Bei einer bereits sortierten Folge", richtig: true },
            { text: "Bei lauter gleichen Elementen im besten Fall", richtig: false },
            { text: "Quicksort hat keinen schlechtesten Fall", richtig: false },
          ]}
          erklaerung="Bei einer sortierten Folge teilt das Rand-Pivot die Folge maximal ungleich: Die Rekursionstiefe wird n und die Laufzeit O(n²)."
        />

        <QuizFrage
          nr={4}
          von={5}
          frage="Was bedeutet „stabiles“ Sortierverfahren?"
          optionen={[
            { text: "Es stürzt nie ab", richtig: false },
            { text: "Gleiche Werte behalten ihre ursprüngliche Reihenfolge", richtig: true },
            { text: "Es braucht keinen zusätzlichen Speicher", richtig: false },
            { text: "Es ist immer O(n log n)", richtig: false },
          ]}
          erklaerung="Stabil heißt: Elemente mit gleichem Sortierwert bleiben in ihrer ursprünglichen Reihenfolge. Wichtig, wenn nach mehreren Kriterien nacheinander sortiert wird."
        />

        <QuizFrage
          nr={5}
          von={5}
          frage="Welche durchschnittliche Laufzeit hat Bubblesort?"
          optionen={[
            { text: "O(n)", richtig: false },
            { text: "O(log n)", richtig: false },
            { text: "O(n log n)", richtig: false },
            { text: "O(n²)", richtig: true },
          ]}
          erklaerung="Bubblesort vergleicht in verschachtelten Schleifen jedes Element mit jedem. Das ergibt im Durchschnitt O(n²). Nur im besten Fall (fast sortiert) kann er O(n) erreichen."
        />
      </LsAbschnitt>

      <LsAbschnitt id="faq" titel="Häufige Fragen">
        <LsFaq eintraege={faq} />
      </LsAbschnitt>
    </LernSeite>
  );
}
