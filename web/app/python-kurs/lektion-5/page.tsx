import type { Metadata } from "next";
import { LsAbschnitt, LsHinweis } from "../../lernen/_components/LsBausteine";
import PythonRunner from "../_components/PythonRunner";
import LektionLayout from "../../components/kurs/LektionLayout";
import { pythonKurs } from "../_components/lektionen";
import { Aufgabe, Loesung } from "../../components/kurs/KursBausteine";

export const metadata: Metadata = {
  title: "Python Lektion 5: Schleifen (for und while)",
  description:
    "for-Schleifen mit range(), while-Schleifen und break, mit Übungen direkt im Browser. Lektion 5 des kostenlosen Python-Kurses für Fachinformatiker.",
  alternates: { canonical: "https://lernarena.app/python-kurs/lektion-5" },
};

export default function Lektion5() {
  return (
    <LektionLayout
      kurs={pythonKurs}
      nr={5}
      lead="for-Schleifen mit range(), while-Schleifen und break, mit Übungen direkt im Browser."
      uebungen={2}
    >
      <LsAbschnitt id="for" titel="Die for-Schleife">
        <p>
          Computer sind gut in einer Sache: stumpf wiederholen, ohne sich zu beschweren. Eine{" "}
          <code>for</code>-Schleife mit <code>range()</code> wiederholt Code eine feste Anzahl von
          Malen:
        </p>

        <PythonRunner
          rows={4}
          dateiname="for_schleife.py"
          initialCode={`for i in range(5):
    print(f"Durchlauf Nummer {i}")`}
        />

        <p>
          Wichtig: <code>range(5)</code> zählt <strong>ab 0</strong> und hört{" "}
          <strong>vor 5</strong> auf (0, 1, 2, 3, 4). Das verwirrt jeden am Anfang. Willst du von
          1 bis 10 zählen, schreibst du <code>range(1, 11)</code>. Damit lassen sich in drei
          Zeilen Dinge bauen, für die du früher zehn Minuten getippt hättest:
        </p>

        <PythonRunner
          rows={6}
          dateiname="gauss.py"
          initialCode={`# Summe aller Zahlen von 1 bis 100 (der kleine Gauss)
summe = 0
for zahl in range(1, 101):
    summe = summe + zahl
print(summe)`}
        />
      </LsAbschnitt>

      <LsAbschnitt id="while" titel="Die while-Schleife">
        <p>
          Die zweite Schleifenart ist <code>while</code>: Sie läuft, <strong>solange</strong> eine
          Bedingung wahr ist. Du weißt vorher nicht, wie oft, und genau das ist ihr
          Einsatzgebiet:
        </p>

        <PythonRunner
          rows={7}
          dateiname="countdown.py"
          initialCode={`countdown = 5
while countdown > 0:
    print(countdown)
    countdown = countdown - 1
print("Start!")`}
        />

        <LsHinweis art="warnung" titel="Achtung, Endlosschleife">
          <p>
            Wenn du das <code>countdown = countdown - 1</code> vergisst, bleibt die Bedingung für
            immer wahr und die Schleife läuft endlos. Falls dir das hier im Browser passiert:
            Seite neu laden, Code korrigieren, weitermachen. Merke: Eine while-Schleife braucht
            immer etwas, das ihre Bedingung irgendwann kippt.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="break" titel="Abbrechen mit break">
        <p>
          Mit <code>break</code> brichst du eine Schleife sofort ab. Das brauchst du gleich in
          Lektion 6 fürs Spiel:
        </p>

        <PythonRunner
          rows={7}
          dateiname="break.py"
          initialCode={`for zahl in range(1, 100):
    if zahl * zahl > 200:
        print(f"{zahl} ist die erste Zahl, deren Quadrat ueber 200 liegt.")
        break`}
        />
      </LsAbschnitt>

      <LsAbschnitt id="uebungen" titel="Übungen">
        <p>Erst selbst versuchen, dann die Lösung aufklappen.</p>

        <Aufgabe nr="5.1">
          <p>
            Gib das kleine Einmaleins der 7 aus, also „1 x 7 = 7“ bis „10 x 7 = 70“. Eine
            for-Schleife, ein f-String, fertig.
          </p>
          <PythonRunner
            rows={4}
            dateiname="uebung_5_1.py"
            label="Python-Code: Übung 5.1"
            initialCode={`# Dein Code:
`}
          />
          <Loesung
            code={`for i in range(1, 11):
    print(f"{i} x 7 = {i * 7}")`}
          />
        </Aufgabe>

        <Aufgabe nr="5.2">
          <p>
            Simuliere eine PIN-Abfrage: Die richtige PIN ist 4711. Frag mit einer while-Schleife so
            lange nach der PIN, bis sie stimmt, und begrüße den Nutzer dann.
          </p>
          <PythonRunner
            rows={6}
            dateiname="uebung_5_2.py"
            label="Python-Code: Übung 5.2"
            initialCode={`richtige_pin = 4711
# Dein Code:
`}
          />
          <Loesung
            code={`richtige_pin = 4711
eingabe = int(input("PIN eingeben: "))
while eingabe != richtige_pin:
    eingabe = int(input("Falsch! Nochmal: "))
print("Willkommen!")`}
          />
        </Aufgabe>
      </LsAbschnitt>
    </LektionLayout>
  );
}
