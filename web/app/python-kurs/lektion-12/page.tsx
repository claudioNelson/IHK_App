import type { Metadata } from "next";
import PythonRunner from "../_components/PythonRunner";
import LektionLayout from "../_components/LektionLayout";

export const metadata: Metadata = {
  title: "Python Lektion 12: Abschluss & Brücke zum IHK-Pseudocode",
  description:
    "Vom Python-Code zum IHK-Pseudocode: die Übersetzungstabelle, eine echte Prüfungsaufgabe in beiden Schreibweisen und dein Fahrplan nach dem Kurs. Finale des kostenlosen Python-Kurses.",
  alternates: { canonical: "https://lernarena.app/python-kurs/lektion-12" },
};

export default function Lektion12() {
  return (
    <LektionLayout nr={12}>
      <p>
        Geschafft! Du kannst Variablen, Bedingungen, Schleifen, Listen,
        Funktionen und Klassen, und du hast zwei Spiele gebaut. Zum Abschluss
        schlagen wir die Brücke zu dem, was in deiner{" "}
        <strong>IHK-Prüfung</strong> auf dem Papier steht: Pseudocode.
      </p>

      <h3>Die Übersetzungstabelle</h3>
      <p>
        Die IHK nutzt eine deutsche, sprachneutrale Schreibweise. Die Konzepte
        sind aber eins zu eins die aus diesem Kurs:
      </p>

      <details className="pk-loesung" open>
        <summary>Python ↔ IHK-Pseudocode</summary>
        <pre>{`Python                          IHK-Pseudocode
─────────────────────────────   ─────────────────────────────
x = 5                           x = 5  (oder: SETZE x AUF 5)
if x > 3:                       WENN x > 3 DANN
else:                           SONST
elif ...:                       SONST WENN ...
(Ende durch Einrueckung)        ENDE WENN

while x < 10:                   SOLANGE x < 10
(Ende durch Einrueckung)        ENDE SOLANGE

for i in range(1, 11):          FUER i = 1 BIS 10
                                ENDE FUER

def summe(a, b):                FUNKTION summe(a, b)
    return a + b                    RUECKGABE a + b
                                ENDE FUNKTION

liste[0]                        liste[0] oder liste[1]!
                                (Achtung: Startindex steht
                                 in der Aufgabe, oft 1!)
print(x)                        AUSGABE x
x = int(input())                EINGABE x`}</pre>
      </details>

      <div className="lp-tip">
        <p>
          <strong>Der eine große Stolperstein:</strong> In IHK-Aufgaben
          starten Arrays manchmal bei Index 1 statt 0. Lies die
          Aufgabenstellung genau, dort steht es immer dabei. Wer stur
          &quot;Index 0&quot; denkt, verrechnet sich bei Schleifengrenzen um
          eins, der berühmte Off-by-one-Fehler.
        </p>
      </div>

      <h3>Eine echte Prüfungsaufgabe, beide Schreibweisen</h3>
      <p>
        Typische AP1-Aufgabe: &quot;Entwickeln Sie einen Algorithmus, der das
        Minimum eines Arrays ermittelt.&quot; In IHK-Schreibweise:
      </p>

      <details className="pk-loesung" open>
        <summary>IHK-Pseudocode</summary>
        <pre>{`FUNKTION minimum(werte)
    kleinstes = werte[0]
    FUER i = 1 BIS laenge(werte) - 1
        WENN werte[i] < kleinstes DANN
            kleinstes = werte[i]
        ENDE WENN
    ENDE FUER
    RUECKGABE kleinstes
ENDE FUNKTION`}</pre>
      </details>

      <p>Und hier zum Vergleich lauffähig in Python, teste es:</p>

      <PythonRunner
        rows={9}
        initialCode={`def minimum(werte):
    kleinstes = werte[0]
    for i in range(1, len(werte)):
        if werte[i] < kleinstes:
            kleinstes = werte[i]
    return kleinstes

print(minimum([44, 12, 89, 7, 33]))`}
      />

      <div className="pk-aufgabe">
        <p>
          <strong>Abschluss-Übung:</strong> Nimm die Pseudocode-Denkweise und
          schreib eine Funktion, die zählt, wie viele Werte eines Arrays über
          einem Schwellenwert liegen (typische Prüfungsaufgabe, z. B.
          &quot;Wie viele Messwerte überschreiten den Grenzwert?&quot;).
        </p>
      </div>
      <PythonRunner
        rows={9}
        initialCode={`messwerte = [71, 85, 62, 90, 78, 95, 60]
grenzwert = 80
# Dein Code: Funktion anzahl_ueber(werte, grenze)
`}
      />
      <details className="pk-loesung">
        <summary>Musterlösung anzeigen</summary>
        <pre>{`def anzahl_ueber(werte, grenze):
    zaehler = 0
    for wert in werte:
        if wert > grenze:
            zaehler = zaehler + 1
    return zaehler

messwerte = [71, 85, 62, 90, 78, 95, 60]
print(anzahl_ueber(messwerte, 80))   # 3`}</pre>
      </details>

      <h3>Wie geht es für dich weiter?</h3>
      <p>
        Programmieren lernst du durch Programmieren. Drei Vorschläge: Bau die
        Snake-Erweiterungen aus Lektion 11 fertig. Nimm dir kleine
        Alltagsprobleme vor (Notenrechner, Vokabeltrainer, Würfelspiel) und
        setz sie um. Und übe die Prüfungsseite der Konzepte in der
        Lernarena-App: Dort warten Pseudocode-Aufgaben, UML-Fragen und
        komplette Prüfungssimulationen mit KI-Korrektur auf dich. Viel Erfolg
        bei deiner Abschlussprüfung!
      </p>
    </LektionLayout>
  );
}
