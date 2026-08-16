import type { Metadata } from "next";
import PythonRunner from "../_components/PythonRunner";
import LektionLayout from "../_components/LektionLayout";

export const metadata: Metadata = {
  title: "Python Lektion 1: Dein erster Code mit print()",
  description:
    "Schreib deine erste Zeile Python direkt im Browser: print(), Strings und erste Rechnungen. Lektion 1 des kostenlosen Python-Kurses für angehende Fachinformatiker.",
  alternates: { canonical: "https://lernarena.app/python-kurs/lektion-1" },
};

export default function Lektion1() {
  return (
    <LektionLayout nr={1}>
      <p>
        Programmieren heißt: dem Computer <strong>präzise Anweisungen</strong>{" "}
        geben. Nicht mehr, nicht weniger. Der Computer macht exakt das, was du
        schreibst, und zwar Zeile für Zeile von oben nach unten. Der wichtigste
        Befehl am Anfang ist <span className="lp-mono">print()</span>: Er gibt
        etwas auf dem Bildschirm aus.
      </p>
      <p>
        Hier ist dein erster Python-Code. Klick auf{" "}
        <strong>▶ Ausführen</strong> und schau, was passiert:
      </p>

      <PythonRunner
        rows={4}
        initialCode={`print("Hallo Welt!")
print("Ich lerne programmieren.")
print(3 + 4)`}
      />

      <p>
        Drei Dinge sind hier passiert: Text in Anführungszeichen (ein{" "}
        <strong>String</strong>) wird wörtlich ausgegeben. Jede{" "}
        <span className="lp-mono">print()</span>-Zeile erzeugt eine eigene
        Ausgabezeile. Und <span className="lp-mono">3 + 4</span> ohne
        Anführungszeichen wird <strong>berechnet</strong>, deshalb steht da 7
        und nicht &quot;3 + 4&quot;.
      </p>

      <div className="lp-tip">
        <p>
          <strong>Probier es kaputt!</strong> Ändere den Code oben: Lass mal
          die Anführungszeichen weg, schreib eine eigene Rechnung, tipp dich
          absichtlich. Fehlermeldungen sind keine Katastrophe, sondern dein
          wichtigstes Werkzeug. Jeder Profi liest täglich welche.
        </p>
      </div>

      <div className="pk-aufgabe">
        <p>
          <strong>Übung 1.1:</strong> Gib deinen Namen und dein Ausbildungsjahr
          in zwei getrennten Zeilen aus.
        </p>
      </div>
      <PythonRunner
        rows={3}
        initialCode={`# Schreib deinen Code unter diese Zeile:
`}
      />
      <details className="pk-loesung">
        <summary>Musterlösung anzeigen</summary>
        <pre>{`print("Max Mustermann")
print("1. Ausbildungsjahr")`}</pre>
      </details>

      <div className="pk-aufgabe">
        <p>
          <strong>Übung 1.2:</strong> Was gibt{" "}
          <span className="lp-mono">print(&quot;5&quot; )</span> aus und was{" "}
          <span className="lp-mono">print(5 + 5)</span>? Überleg zuerst, dann
          führ es aus und prüf dich selbst.
        </p>
      </div>
      <PythonRunner
        rows={3}
        initialCode={`print("5" )
print(5 + 5)`}
      />
      <details className="pk-loesung">
        <summary>Erklärung anzeigen</summary>
        <pre>{`"5" ist ein String (Text) und wird wörtlich ausgegeben: 5
5 + 5 sind Zahlen und werden berechnet: 10
Der Unterschied zwischen Text und Zahl wird in Lektion 2 wichtig!`}</pre>
      </details>
    </LektionLayout>
  );
}
