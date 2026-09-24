import type { Metadata } from "next";
import { LsAbschnitt, LsHinweis } from "../../lernen/_components/LsBausteine";
import PythonRunner from "../_components/PythonRunner";
import LektionLayout from "../../components/kurs/LektionLayout";
import { pythonKurs } from "../_components/lektionen";
import { Aufgabe, Loesung } from "../../components/kurs/KursBausteine";

export const metadata: Metadata = {
  title: "Python Lektion 8: Funktionen",
  description:
    "Eigene Funktionen in Python: def, Parameter, return und warum Funktionen Code besser machen. Lektion 8 des kostenlosen Python-Kurses für Fachinformatiker.",
  alternates: { canonical: "https://lernarena.app/python-kurs/lektion-8" },
};

export default function Lektion8() {
  return (
    <LektionLayout
      kurs={pythonKurs}
      nr={8}
      lead="Eigene Funktionen in Python: def, Parameter, return und warum Funktionen Code besser machen."
      uebungen={2}
    >
      <LsAbschnitt id="def" titel="Eigene Funktionen">
        <p>
          Du benutzt schon die ganze Zeit Funktionen: <code>print()</code>, <code>input()</code>,{" "}
          <code>len()</code>. Jetzt schreibst du eigene. Eine <strong>Funktion</strong> ist ein
          Codeblock mit Namen, den du beliebig oft aufrufen kannst:
        </p>

        <PythonRunner
          rows={7}
          dateiname="begruessung.py"
          initialCode={`def begruessung():
    print("Willkommen bei Lernarena!")
    print("Viel Erfolg beim Lernen.")

begruessung()
begruessung()`}
        />
      </LsAbschnitt>

      <LsAbschnitt id="parameter" titel="Parameter und return">
        <p>
          Richtig nützlich werden Funktionen mit <strong>Parametern</strong> (Werte, die
          reingehen) und <code>return</code> (der Wert, der rauskommt):
        </p>

        <PythonRunner
          rows={8}
          dateiname="brutto.py"
          initialCode={`def brutto(netto):
    return netto * 1.19

print(brutto(100))
print(brutto(250))

einkauf = brutto(19.99) + brutto(45.50)
print(f"Gesamt: {einkauf:.2f} Euro")`}
        />

        <p>
          Das <code>:.2f</code> im f-String rundet übrigens auf zwei Nachkommastellen, praktisch
          für Geldbeträge. Funktionen können auch mehrere Parameter haben:
        </p>

        <PythonRunner
          rows={8}
          dateiname="noten.py"
          initialCode={`def note_fuer_punkte(punkte, max_punkte):
    prozent = punkte / max_punkte * 100
    if prozent >= 92: return 1
    if prozent >= 81: return 2
    if prozent >= 67: return 3
    if prozent >= 50: return 4
    return 5

print(note_fuer_punkte(74, 100))
print(note_fuer_punkte(45, 50))`}
        />

        <LsHinweis titel="Warum das Gold wert ist">
          <p>
            Der Notenschlüssel steht jetzt an genau EINER Stelle. Ändert die IHK die Grenzen,
            änderst du eine Funktion statt zwanzig Codestellen. Dieses Prinzip heißt „Don&apos;t
            repeat yourself“ (DRY) und ist eine beliebte Frage im Fachgespräch.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="uebungen" titel="Übungen">
        <p>Erst selbst versuchen, dann die Lösung aufklappen.</p>

        <Aufgabe nr="8.1">
          <p>
            Schreib eine Funktion <code>ist_gerade(zahl)</code>, die <code>True</code> oder{" "}
            <code>False</code> zurückgibt. Teste sie mit ein paar Zahlen.
          </p>
          <PythonRunner
            rows={6}
            dateiname="uebung_8_1.py"
            label="Python-Code: Übung 8.1"
            initialCode={`# Dein Code:

`}
          />
          <Loesung
            code={`def ist_gerade(zahl):
    return zahl % 2 == 0

print(ist_gerade(8))    # True
print(ist_gerade(7))    # False`}
          />
        </Aufgabe>

        <Aufgabe nr="8.2">
          <p>
            Schreib eine Funktion <code>durchschnitt(liste)</code>, die den Durchschnitt einer
            Zahlenliste zurückgibt, und teste sie mit den Punktelisten aus Lektion 7.
          </p>
          <PythonRunner
            rows={7}
            dateiname="uebung_8_2.py"
            label="Python-Code: Übung 8.2"
            initialCode={`punkte = [82, 45, 91, 67, 55]
# Dein Code:
`}
          />
          <Loesung
            code={`def durchschnitt(liste):
    summe = 0
    for wert in liste:
        summe = summe + wert
    return summe / len(liste)

punkte = [82, 45, 91, 67, 55]
print(durchschnitt(punkte))
print(durchschnitt([1, 2, 3]))`}
          />
        </Aufgabe>
      </LsAbschnitt>
    </LektionLayout>
  );
}
