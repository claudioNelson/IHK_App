import type { Metadata } from "next";
import type { ReactNode } from "react";
import { LsAbschnitt, LsHinweis } from "../../lernen/_components/LsBausteine";
import PythonRunner from "../_components/PythonRunner";
import LektionLayout from "../../components/kurs/LektionLayout";
import { pythonKurs } from "../_components/lektionen";
import { Aufgabe, CodeBlock, Loesung } from "../../components/kurs/KursBausteine";

export const metadata: Metadata = {
  title: "Python Lektion 12: Abschluss und Brücke zum IHK-Pseudocode",
  description:
    "Vom Python-Code zum IHK-Pseudocode: die Übersetzungstabelle, eine echte Prüfungsaufgabe in beiden Schreibweisen und dein Fahrplan nach dem Kurs. Finale des kostenlosen Python-Kurses.",
  alternates: { canonical: "https://lernarena.app/python-kurs/lektion-12" },
};

// Uebersetzungstabelle Python und IHK-Pseudocode. Mehrzeilige Zellen per <br />,
// Einrueckung bleibt dank .pk-code-tabelle (white-space: pre) erhalten.
const zeilen: { python: ReactNode; ihk: ReactNode }[] = [
  { python: "x = 5", ihk: "x = 5  (oder: SETZE x AUF 5)" },
  { python: "if x > 3:", ihk: "WENN x > 3 DANN" },
  { python: "else:", ihk: "SONST" },
  { python: "elif ...:", ihk: "SONST WENN ..." },
  { python: "(Ende durch Einrückung)", ihk: "ENDE WENN" },
  { python: "while x < 10:", ihk: "SOLANGE x < 10" },
  { python: "(Ende durch Einrückung)", ihk: "ENDE SOLANGE" },
  {
    python: "for i in range(1, 11):",
    ihk: (
      <>
        FUER i = 1 BIS 10
        <br />
        ENDE FUER
      </>
    ),
  },
  {
    python: (
      <>
        def summe(a, b):
        <br />
        {"    return a + b"}
      </>
    ),
    ihk: (
      <>
        FUNKTION summe(a, b)
        <br />
        {"    RUECKGABE a + b"}
        <br />
        ENDE FUNKTION
      </>
    ),
  },
  {
    python: "liste[0]",
    ihk: (
      <>
        liste[0] oder liste[1]!
        <br />
        (Achtung: Startindex steht in der Aufgabe, oft 1!)
      </>
    ),
  },
  { python: "print(x)", ihk: "AUSGABE x" },
  { python: "x = int(input())", ihk: "EINGABE x" },
];

export default function Lektion12() {
  return (
    <LektionLayout
      kurs={pythonKurs}
      nr={12}
      lead="Vom Python-Code zum IHK-Pseudocode: die Übersetzungstabelle, eine echte Prüfungsaufgabe in beiden Schreibweisen und dein Fahrplan nach dem Kurs."
      uebungen={1}
    >
      <LsAbschnitt id="geschafft" titel="Was du jetzt kannst">
        <p>
          Geschafft! Du kannst Variablen, Bedingungen, Schleifen, Listen, Funktionen und Klassen,
          und du hast zwei Spiele gebaut. Zum Abschluss schlagen wir die Brücke zu dem, was in
          deiner <strong>IHK-Prüfung</strong> auf dem Papier steht: Pseudocode.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="uebersetzung" titel="Die Übersetzungstabelle">
        <p>
          Die IHK nutzt eine deutsche, sprachneutrale Schreibweise. Die Konzepte sind aber eins zu
          eins die aus diesem Kurs:
        </p>

        <div
          className="ls-table-wrap"
          role="region"
          aria-label="Python und IHK-Pseudocode, seitlich scrollbar"
          tabIndex={0}
        >
          <table className="ls-table pk-code-tabelle">
            <thead>
              <tr>
                <th scope="col">Python</th>
                <th scope="col">IHK-Pseudocode</th>
              </tr>
            </thead>
            <tbody>
              {zeilen.map((z, i) => (
                <tr key={i}>
                  <td>{z.python}</td>
                  <td>{z.ihk}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        <LsHinweis art="warnung" titel="Der eine große Stolperstein">
          <p>
            In IHK-Aufgaben starten Arrays manchmal bei Index 1 statt 0. Lies die Aufgabenstellung
            genau, dort steht es immer dabei. Wer stur „Index 0“ denkt, verrechnet sich bei
            Schleifengrenzen um eins, der berühmte Off-by-one-Fehler.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="pruefungsaufgabe" titel="Eine echte Prüfungsaufgabe, beide Schreibweisen">
        <p>
          Typische AP1-Aufgabe: „Entwickeln Sie einen Algorithmus, der das Minimum eines Arrays
          ermittelt.“ In IHK-Schreibweise:
        </p>

        <CodeBlock
          code={`FUNKTION minimum(werte)
    kleinstes = werte[0]
    FUER i = 1 BIS laenge(werte) - 1
        WENN werte[i] < kleinstes DANN
            kleinstes = werte[i]
        ENDE WENN
    ENDE FUER
    RUECKGABE kleinstes
ENDE FUNKTION`}
        />

        <p>Und hier zum Vergleich lauffähig in Python, teste es:</p>

        <PythonRunner
          rows={9}
          dateiname="minimum.py"
          initialCode={`def minimum(werte):
    kleinstes = werte[0]
    for i in range(1, len(werte)):
        if werte[i] < kleinstes:
            kleinstes = werte[i]
    return kleinstes

print(minimum([44, 12, 89, 7, 33]))`}
        />

        <Aufgabe nr="12" label="Abschluss-Übung">
          <p>
            Nimm die Pseudocode-Denkweise und schreib eine Funktion, die zählt, wie viele Werte
            eines Arrays über einem Schwellenwert liegen (typische Prüfungsaufgabe, z. B. „Wie
            viele Messwerte überschreiten den Grenzwert?“).
          </p>
          <PythonRunner
            rows={9}
            dateiname="abschluss.py"
            label="Python-Code: Abschluss-Übung"
            initialCode={`messwerte = [71, 85, 62, 90, 78, 95, 60]
grenzwert = 80
# Dein Code: Funktion anzahl_ueber(werte, grenze)
`}
          />
          <Loesung
            code={`def anzahl_ueber(werte, grenze):
    zaehler = 0
    for wert in werte:
        if wert > grenze:
            zaehler = zaehler + 1
    return zaehler

messwerte = [71, 85, 62, 90, 78, 95, 60]
print(anzahl_ueber(messwerte, 80))   # 3`}
          />
        </Aufgabe>
      </LsAbschnitt>

      <LsAbschnitt id="weiter" titel="Wie geht es für dich weiter?">
        <p>
          Programmieren lernst du durch Programmieren. Drei Vorschläge: Bau die
          Snake-Erweiterungen aus Lektion 11 fertig. Nimm dir kleine Alltagsprobleme vor
          (Notenrechner, Vokabeltrainer, Würfelspiel) und setz sie um. Und übe die Prüfungsseite
          der Konzepte in der Lernarena-App: Dort warten Pseudocode-Aufgaben, UML-Fragen und
          komplette Prüfungssimulationen mit KI-Korrektur auf dich. Viel Erfolg bei deiner
          Abschlussprüfung!
        </p>
      </LsAbschnitt>
    </LektionLayout>
  );
}
