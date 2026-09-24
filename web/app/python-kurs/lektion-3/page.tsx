import type { Metadata } from "next";
import { LsAbschnitt } from "../../lernen/_components/LsBausteine";
import PythonRunner from "../_components/PythonRunner";
import LektionLayout from "../../components/kurs/LektionLayout";
import { pythonKurs } from "../_components/lektionen";
import { Aufgabe, Loesung } from "../../components/kurs/KursBausteine";

export const metadata: Metadata = {
  title: "Python Lektion 3: Rechnen, Modulo und f-Strings",
  description:
    "Division, Ganzzahl-Division, Modulo und f-Strings in Python, mit interaktiven Übungen im Browser. Lektion 3 des kostenlosen Python-Kurses für Fachinformatiker.",
  alternates: { canonical: "https://lernarena.app/python-kurs/lektion-3" },
};

export default function Lektion3() {
  return (
    <LektionLayout
      kurs={pythonKurs}
      nr={3}
      lead="Division, Ganzzahl-Division, Modulo und f-Strings in Python, mit interaktiven Übungen im Browser."
      uebungen={2}
    >
      <LsAbschnitt id="rechnen" titel="Rechnen mit Python">
        <p>
          Python ist ein vollwertiger Taschenrechner. Neben <code>+</code>, <code>-</code>,{" "}
          <code>*</code> und <code>/</code> gibt es drei Operatoren, die du noch nicht aus der
          Schule kennst, die aber in der Praxis (und in Prüfungsaufgaben) dauernd vorkommen:
        </p>

        <PythonRunner
          rows={7}
          dateiname="rechnen.py"
          initialCode={`print(17 / 5)    # normale Division -> 3.4
print(17 // 5)   # Ganzzahl-Division -> 3 (Rest wird abgeschnitten)
print(17 % 5)    # Modulo -> 2 (nur der Rest!)
print(2 ** 10)   # Potenz -> 1024

# Klassiker: Ist eine Zahl gerade?
print(8 % 2)     # 0 bedeutet: glatt teilbar, also gerade`}
        />

        <p>
          Besonders <code>%</code> (Modulo) solltest du dir merken: „Rest bei der Division“. Damit
          prüfst du, ob eine Zahl gerade ist, ob ein Jahr ein Schaltjahr ist oder wie viele
          Minuten in einer Sekundenzahl stecken. Das taucht in fast jeder
          Programmier-Prüfungsaufgabe irgendwo auf.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="f-strings" titel="Schöne Ausgaben mit f-Strings">
        <p>
          Bisher hast du Ausgaben mit <code>+</code> oder Kommas zusammengebaut. Es geht
          eleganter: Ein <strong>f-String</strong> ist ein String mit einem <code>f</code> davor,
          in den du Variablen direkt in geschweiften Klammern einsetzt:
        </p>

        <PythonRunner
          rows={6}
          dateiname="f_strings.py"
          initialCode={`name = "Alex"
punkte = 87

print(f"{name} hat {punkte} von 100 Punkten.")
print(f"Das sind {punkte / 100} Prozent als Dezimalzahl.")
print(f"In 3 Jahren: {punkte + 3} Punkte (Quatsch, aber es rechnet!)")`}
        />

        <p>
          Strings können noch mehr. Mit <code>len()</code> misst du die Länge, mit{" "}
          <code>.upper()</code> und <code>.lower()</code> änderst du die Schreibweise:
        </p>

        <PythonRunner
          rows={5}
          dateiname="strings.py"
          initialCode={`wort = "Fachinformatiker"

print(len(wort))
print(wort.upper())
print(wort.lower())`}
        />
      </LsAbschnitt>

      <LsAbschnitt id="uebungen" titel="Übungen">
        <p>Erst selbst versuchen, dann die Lösung aufklappen.</p>

        <Aufgabe nr="3.1">
          <p>
            Ein Netto-Preis von 250 Euro soll mit 19 Prozent Mehrwertsteuer ausgegeben werden.
            Berechne den Brutto-Preis und gib ihn mit einem f-String aus, z. B. „Brutto: 297.5
            Euro“.
          </p>
          <PythonRunner
            rows={4}
            dateiname="uebung_3_1.py"
            label="Python-Code: Übung 3.1"
            initialCode={`netto = 250
# Dein Code:
`}
          />
          <Loesung
            code={`netto = 250
brutto = netto * 1.19
print(f"Brutto: {brutto} Euro")`}
          />
        </Aufgabe>

        <Aufgabe nr="3.2">
          <p>
            Wandle 347 Sekunden in Minuten und Sekunden um (Ergebnis: 5 Minuten, 47 Sekunden).
            Tipp: Ganzzahl-Division <code>//</code> für die Minuten, Modulo <code>%</code> für den
            Rest.
          </p>
          <PythonRunner
            rows={5}
            dateiname="uebung_3_2.py"
            label="Python-Code: Übung 3.2"
            initialCode={`sekunden = 347
# Dein Code:
`}
          />
          <Loesung
            code={`sekunden = 347
minuten = sekunden // 60
rest = sekunden % 60
print(f"{minuten} Minuten, {rest} Sekunden")`}
          />
        </Aufgabe>
      </LsAbschnitt>
    </LektionLayout>
  );
}
