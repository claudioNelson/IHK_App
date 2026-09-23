import type { Metadata } from "next";
import Link from "next/link";
import LernSeite, { type Abschnitt, type MetaEintrag, type Verwandt } from "../_components/LernSeite";
import { LsAbschnitt, LsFaq, LsHinweis, type FaqEintrag } from "../_components/LsBausteine";
import QuizFrage from "../_components/QuizFrage";

export const metadata: Metadata = {
  title: "Nutzwertanalyse mit Rechenbeispiel erklärt (IHK)",
  description:
    "Nutzwertanalyse Schritt für Schritt: Kriterien gewichten, Punkte vergeben, Nutzwert berechnen. Mit vollständigem Rechenbeispiel und Übungsaufgaben für die IHK-Prüfung (AP1).",
  alternates: {
    canonical: "https://lernarena.app/lernen/nutzwertanalyse",
  },
  openGraph: {
    type: "article",
    url: "https://lernarena.app/lernen/nutzwertanalyse",
    title: "Nutzwertanalyse mit Rechenbeispiel erklärt (IHK)",
    description:
      "Nutzwertanalyse mit Rechenbeispiel und Übungsaufgaben: der AP1-Klassiker verständlich erklärt.",
    images: ["/og-image.png"],
  },
};

const abschnitte: Abschnitt[] = [
  { id: "wozu", titel: "Wozu dient die Nutzwertanalyse?" },
  { id: "schritte", titel: "Die vier Schritte" },
  { id: "beispiel", titel: "Rechenbeispiel" },
  { id: "fehler", titel: "Häufige Fehler" },
  { id: "quiz", titel: "Selbst testen" },
  { id: "faq", titel: "Häufige Fragen" },
];

const meta: MetaEintrag[] = [
  { icon: "zeit", text: "Etwa 6 Minuten" },
  { icon: "rechner", text: "Komplettes Rechenbeispiel" },
  { icon: "quiz", text: "5 Quizfragen" },
  { icon: "pruefung", text: "AP1" },
];

const verwandt: Verwandt[] = [
  { href: "/lernen/zahlensysteme", titel: "Zahlensysteme umrechnen", untertitel: "Binär, dezimal, hexadezimal" },
  { href: "/lernen/subnetting", titel: "Subnetting üben", untertitel: "Maske, Blockgröße, Broadcast" },
  { href: "/lernen", titel: "Alle Lernthemen", untertitel: "10 Themen für AP1 und AP2" },
  { href: "/pruefungen", titel: "Übungsprüfungen", untertitel: "Aufgaben im IHK-Stil mit Korrektur" },
];

const rechnung: {
  kriterium: string;
  gewicht: string;
  aPunkte: string;
  aGewichtet: string;
  bPunkte: string;
  bGewichtet: string;
}[] = [
  { kriterium: "Preis", gewicht: "40 %", aPunkte: "8", aGewichtet: "3,2", bPunkte: "6", bGewichtet: "2,4" },
  { kriterium: "Qualität", gewicht: "35 %", aPunkte: "6", aGewichtet: "2,1", bPunkte: "9", bGewichtet: "3,15" },
  { kriterium: "Service", gewicht: "25 %", aPunkte: "7", aGewichtet: "1,75", bPunkte: "8", bGewichtet: "2,0" },
];

const faq: FaqEintrag[] = [
  {
    q: "Was ist eine Nutzwertanalyse?",
    a: "Ein Bewertungsverfahren, das mehrere Alternativen anhand gewichteter Kriterien vergleichbar macht. Jede Alternative bekommt pro Kriterium Punkte, die mit dem Kriteriengewicht multipliziert und aufsummiert werden. Die Alternative mit dem höchsten Nutzwert ist die beste Wahl.",
  },
  {
    q: "Wie berechnet man den Nutzwert?",
    a: "Pro Kriterium: vergebene Punkte mal Gewichtung. Diese gewichteten Punkte werden für jede Alternative aufsummiert. Wichtig: Die Summe aller Gewichte muss 100 % (bzw. 1,0) ergeben.",
  },
  {
    q: "Wann verwendet man eine Nutzwertanalyse?",
    a: "Immer wenn eine Entscheidung von mehreren, auch nicht-monetären Kriterien abhängt, typisch beim Vergleich von Angeboten, Lieferanten, Software oder Standorten. In der IHK-Prüfung ist sie ein Klassiker im Bereich Wirtschafts- und Geschäftsprozesse.",
  },
  {
    q: "Was ist der Vorteil gegenüber einem reinen Preisvergleich?",
    a: "Qualitative Faktoren wie Service, Qualität oder Lieferzeit fließen messbar in die Entscheidung ein. Das günstigste Angebot gewinnt dadurch nicht automatisch. Die Entscheidung wird nachvollziehbar und objektiver.",
  },
];

export default function NutzwertanalysePage() {
  return (
    <LernSeite
      titel="Nutzwertanalyse: Schritt für Schritt mit Rechenbeispiel"
      lead="Die Nutzwertanalyse ist der Dauerbrenner in der AP1: Angebote oder Anbieter anhand gewichteter Kriterien objektiv vergleichen. Hier lernst du das Verfahren in vier Schritten und rechnest ein komplettes Beispiel durch."
      pfad="Nutzwertanalyse"
      meta={meta}
      abschnitte={abschnitte}
      seitenNotiz={
        <>
          Die Nutzwertanalyse kommt in der AP1 regelmäßig dran. Weitere Aufgaben findest du
          in den <Link href="/pruefungen">Übungsprüfungen</Link>.
        </>
      }
      verwandt={verwandt}
      cta={{
        titel: "AP1-Themen interaktiv trainieren.",
        text: "In der Lernarena rechnest du Nutzwertanalysen und andere AP1-Klassiker mit sofortigem Feedback, Aufgaben im IHK-Stil und der KI-Tutorin Ada.",
      }}
    >
      <LsAbschnitt id="wozu" titel="Wozu dient die Nutzwertanalyse?">
        <p>
          Wenn eine Entscheidung nicht nur vom Preis abhängt, sondern auch von qualitativen
          Kriterien (Service, Qualität, Lieferzeit), macht die{" "}
          <strong>Nutzwertanalyse</strong> die Alternativen vergleichbar: Kriterien werden{" "}
          <strong>gewichtet</strong>, jede Alternative bekommt <strong>Punkte</strong>, und
          die gewichtete Summe ergibt den <strong>Nutzwert</strong>. Die Alternative mit dem
          höchsten Nutzwert gewinnt.
        </p>
        <LsHinweis titel="Merkhilfe: die Wohnungssuche" icon="haus" label="Merkhilfe">
          <p>
            Du entscheidest ja nicht nur nach der Miete. Lage, Größe und Zustand zählen auch,
            aber nicht gleich stark. Vielleicht ist dir die Lage doppelt so wichtig wie der
            Zustand. Genau das machst du mit der <strong>Gewichtung</strong>: Jedem Kriterium
            gibst du ein Gewicht, vergibst pro Wohnung Punkte und rechnest zusammen. Am Ende
            gewinnt nicht automatisch die billigste, sondern die, die zu deinen Prioritäten am
            besten passt.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="schritte" titel="Die vier Schritte">
        <ol className="ls-steps">
          <li className="ls-step">
            <div>
              <h3>Kriterien festlegen</h3>
              <p>Lege fest, nach welchen Kriterien die Alternativen verglichen werden.</p>
            </div>
          </li>
          <li className="ls-step">
            <div>
              <h3>Kriterien gewichten</h3>
              <p>
                Jedes Kriterium bekommt ein Gewicht. Die Summe der Gewichte ist{" "}
                <code>100 %</code>.
              </p>
            </div>
          </li>
          <li className="ls-step">
            <div>
              <h3>Alternativen bewerten</h3>
              <p>
                Jede Alternative wird pro Kriterium bewertet, z. B. mit 1 bis 10 Punkten.
              </p>
            </div>
          </li>
          <li className="ls-step">
            <div>
              <h3>Nutzwert berechnen</h3>
              <p>
                <code>Punkte × Gewicht</code> rechnen, pro Alternative aufsummieren und die
                Rangfolge bilden.
              </p>
            </div>
          </li>
        </ol>
      </LsAbschnitt>

      <LsAbschnitt id="beispiel" titel="Komplettes Rechenbeispiel">
        <p className="ls-task">
          <strong>Aufgabe:</strong> Zwei Server-Angebote, drei Kriterien: Preis (Gewicht 40 %),
          Qualität (35 %), Service (25 %). Punkteskala 1 bis 10.
        </p>
        <div
          className="ls-table-wrap"
          role="region"
          aria-label="Rechenbeispiel Nutzwertanalyse, seitlich scrollbar"
          tabIndex={0}
        >
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Kriterium</th>
                <th scope="col" className="num">Gewicht</th>
                <th scope="col" className="num">A Punkte</th>
                <th scope="col" className="num">A gewichtet</th>
                <th scope="col" className="num">B Punkte</th>
                <th scope="col" className="num">B gewichtet</th>
              </tr>
            </thead>
            <tbody>
              {rechnung.map((r) => (
                <tr key={r.kriterium}>
                  <td>{r.kriterium}</td>
                  <td className="num">{r.gewicht}</td>
                  <td className="num">{r.aPunkte}</td>
                  <td className="num">{r.aGewichtet}</td>
                  <td className="num">{r.bPunkte}</td>
                  <td className="num">{r.bGewichtet}</td>
                </tr>
              ))}
              <tr>
                <td>
                  <strong>Nutzwert</strong>
                </td>
                <td className="num">100 %</td>
                <td className="num"></td>
                <td className="num">
                  <strong>7,05</strong>
                </td>
                <td className="num"></td>
                <td className="num">
                  <strong>7,55</strong>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <p>
          <strong>Anbieter B gewinnt</strong> (7,55 gegen 7,05), obwohl A beim Preis vorn
          liegt. Genau dieser Effekt („der Billigste gewinnt nicht automatisch“) ist die
          typische Prüfungserkenntnis.
        </p>
        <LsHinweis titel="Prüfungstipp: Rechne in dieser Reihenfolge">
          <p>
            Erst prüfen, ob die Gewichte zusammen <code>100 %</code> ergeben, dann pro Feld{" "}
            <code>Punkte × Gewicht</code>, dann pro Spalte aufsummieren, zuletzt die
            Rangfolge bilden. So kann fast nichts schiefgehen. Und{" "}
            <strong>runde immer erst ganz am Ende</strong>.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="fehler" titel="Häufige Fehler in der Prüfung">
        <LsHinweis art="warnung" titel="Vier Stolperfallen, die regelmäßig Punkte kosten">
          <ul>
            <li>
              Nicht prüfen, ob die <strong>Gewichte 100 %</strong> ergeben. Das ist der
              häufigste Fehler überhaupt.
            </li>
            <li>
              Zwischenergebnisse zu früh runden. Rechne mit den genauen Werten und runde erst
              das Endergebnis.
            </li>
            <li>
              Punkte und Gewicht vertauschen oder das Gewicht als ganze Zahl (40 statt 0,40)
              einsetzen.
            </li>
            <li>
              Denken, „der Billigste gewinnt“. Dabei bezieht die Nutzwertanalyse bewusst auch
              qualitative Kriterien mit ein.
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
          frage="Die Gewichte einer Nutzwertanalyse ergeben zusammen 90 %. Was bedeutet das?"
          optionen={[
            { text: "Das ist erlaubt, solange alle Kriterien bewertet sind", richtig: false },
            { text: "Die Analyse ist fehlerhaft, denn die Gewichte müssen 100 % ergeben", richtig: true },
            { text: "Die restlichen 10 % gelten als Puffer", richtig: false },
            { text: "Der Nutzwert muss durch 0,9 geteilt werden", richtig: false },
          ]}
          erklaerung="Die Summe der Gewichte muss immer 100 % ergeben, sonst ist die Gewichtung inkonsistent und die Nutzwerte sind nicht vergleichbar."
        />

        <QuizFrage
          nr={2}
          von={5}
          frage="Kriterium Preis: Gewicht 40 %, Anbieter erhält 5 Punkte. Wie viele gewichtete Punkte sind das?"
          optionen={[
            { text: "0,8", richtig: false },
            { text: "2,0", richtig: true },
            { text: "4,5", richtig: false },
            { text: "5,4", richtig: false },
          ]}
          erklaerung="Gewichtete Punkte = Punkte × Gewicht = 5 × 0,40 = 2,0."
        />

        <QuizFrage
          nr={3}
          von={5}
          frage="Wofür ist die Nutzwertanalyse das richtige Werkzeug?"
          optionen={[
            { text: "Nur für reine Preisvergleiche", richtig: false },
            { text: "Für Entscheidungen mit mehreren, auch qualitativen Kriterien", richtig: true },
            { text: "Für die Berechnung von Abschreibungen", richtig: false },
            { text: "Für die Liquiditätsplanung", richtig: false },
          ]}
          erklaerung="Die Nutzwertanalyse macht qualitative und quantitative Kriterien gemeinsam vergleichbar. Genau dann ist sie das Mittel der Wahl."
        />

        <QuizFrage
          nr={4}
          von={5}
          frage="Anbieter A hat Nutzwert 7,05, Anbieter B 7,55. Wer bekommt den Zuschlag?"
          optionen={[
            { text: "Anbieter A", richtig: false },
            { text: "Anbieter B", richtig: true },
            { text: "Beide gleich", richtig: false },
            { text: "Der mit dem niedrigeren Preis", richtig: false },
          ]}
          erklaerung="Es gewinnt immer die Alternative mit dem höchsten Nutzwert. Hier ist das Anbieter B mit 7,55, auch wenn A beim reinen Preis vorne lag."
        />

        <QuizFrage
          nr={5}
          von={5}
          frage="Kriterium mit Gewicht 25 %, Alternative erhält 8 Punkte. Gewichtete Punkte?"
          optionen={[
            { text: "2,0", richtig: true },
            { text: "3,2", richtig: false },
            { text: "0,25", richtig: false },
            { text: "8,25", richtig: false },
          ]}
          erklaerung="8 × 0,25 = 2,0. Immer Punkte mal Gewicht (als Dezimalzahl) rechnen."
        />
      </LsAbschnitt>

      <LsAbschnitt id="faq" titel="Häufige Fragen">
        <LsFaq eintraege={faq} />
      </LsAbschnitt>
    </LernSeite>
  );
}
