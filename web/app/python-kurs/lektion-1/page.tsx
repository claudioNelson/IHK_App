import type { Metadata } from "next";
import { LsAbschnitt, LsHinweis } from "../../lernen/_components/LsBausteine";
import PythonRunner from "../_components/PythonRunner";
import LektionLayout from "../_components/LektionLayout";
import { Aufgabe, Loesung } from "../_components/KursBausteine";

export const metadata: Metadata = {
  title: "Python Lektion 1: Dein erster Code mit print()",
  description:
    "Schreib deine erste Zeile Python direkt im Browser: print(), Strings und erste Rechnungen. Lektion 1 des kostenlosen Python-Kurses für angehende Fachinformatiker.",
  alternates: { canonical: "https://lernarena.app/python-kurs/lektion-1" },
};

export default function Lektion1() {
  return (
    <LektionLayout
      nr={1}
      lead="Schreib deine erste Zeile Python direkt im Browser: print(), Strings und erste Rechnungen."
      uebungen={2}
    >
      <LsAbschnitt id="erster-code" titel="Dein erster Code">
        <p>
          Programmieren heißt: dem Computer <strong>präzise Anweisungen</strong> geben. Nicht mehr,
          nicht weniger. Der Computer macht exakt das, was du schreibst, und zwar Zeile für Zeile
          von oben nach unten. Der wichtigste Befehl am Anfang ist <code>print()</code>: Er gibt
          etwas auf dem Bildschirm aus.
        </p>
        <p>
          Hier ist dein erster Python-Code. Klick auf <strong>Ausführen</strong> und schau, was
          passiert:
        </p>

        <PythonRunner
          rows={4}
          dateiname="hallo.py"
          label="Python-Code: Beispiel, dein erster Code"
          initialCode={`print("Hallo Welt!")
print("Ich lerne programmieren.")
print(3 + 4)`}
        />

        <p>
          Drei Dinge sind hier passiert: Text in Anführungszeichen (ein <strong>String</strong>)
          wird wörtlich ausgegeben. Jede <code>print()</code>-Zeile erzeugt eine eigene
          Ausgabezeile. Und <code>3 + 4</code> ohne Anführungszeichen wird{" "}
          <strong>berechnet</strong>, deshalb steht da 7 und nicht „3 + 4“.
        </p>

        <LsHinweis titel="Probier es kaputt!">
          <p>
            Ändere den Code oben: Lass mal die Anführungszeichen weg, schreib eine eigene Rechnung,
            tipp dich absichtlich. Fehlermeldungen sind keine Katastrophe, sondern dein wichtigstes
            Werkzeug. Jeder Profi liest täglich welche.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="uebungen" titel="Übungen">
        <p>Erst selbst versuchen, dann die Lösung aufklappen.</p>

        <Aufgabe nr="1.1">
          <p>Gib deinen Namen und dein Ausbildungsjahr in zwei getrennten Zeilen aus.</p>
          <PythonRunner
            rows={3}
            dateiname="uebung_1_1.py"
            label="Python-Code: Übung 1.1"
            initialCode={`# Schreib deinen Code unter diese Zeile:
`}
          />
          <Loesung
            code={`print("Max Mustermann")
print("1. Ausbildungsjahr")`}
          />
        </Aufgabe>

        <Aufgabe nr="1.2">
          <p>
            Was gibt <code>print(&quot;5&quot;)</code> aus und was <code>print(5 + 5)</code>?
            Überleg zuerst, dann führ es aus und prüf dich selbst.
          </p>
          <PythonRunner
            rows={3}
            dateiname="uebung_1_2.py"
            label="Python-Code: Übung 1.2"
            initialCode={`print("5")
print(5 + 5)`}
          />
          <Loesung art="erklaerung">
            <p>
              <code>&quot;5&quot;</code> ist ein String (Text) und wird wörtlich ausgegeben: 5.{" "}
              <code>5 + 5</code> sind Zahlen und werden berechnet: 10. Der Unterschied zwischen
              Text und Zahl wird in Lektion 2 wichtig.
            </p>
          </Loesung>
        </Aufgabe>
      </LsAbschnitt>
    </LektionLayout>
  );
}
