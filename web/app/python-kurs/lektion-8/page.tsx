import type { Metadata } from "next";
import PythonRunner from "../_components/PythonRunner";
import LektionLayout from "../_components/LektionLayout";

export const metadata: Metadata = {
  title: "Python Lektion 8: Funktionen",
  description:
    "Eigene Funktionen in Python: def, Parameter, return und warum Funktionen Code besser machen. Lektion 8 des kostenlosen Python-Kurses für Fachinformatiker.",
  alternates: { canonical: "https://lernarena.app/python-kurs/lektion-8" },
};

export default function Lektion8() {
  return (
    <LektionLayout nr={8}>
      <p>
        Du benutzt schon die ganze Zeit Funktionen:{" "}
        <span className="lp-mono">print()</span>,{" "}
        <span className="lp-mono">input()</span>,{" "}
        <span className="lp-mono">len()</span>. Jetzt schreibst du eigene.
        Eine <strong>Funktion</strong> ist ein Codeblock mit Namen, den du
        beliebig oft aufrufen kannst:
      </p>

      <PythonRunner
        rows={7}
        initialCode={`def begruessung():
    print("Willkommen bei Lernarena!")
    print("Viel Erfolg beim Lernen.")

begruessung()
begruessung()`}
      />

      <p>
        Richtig nützlich werden Funktionen mit <strong>Parametern</strong>{" "}
        (Werte, die reingehen) und <span className="lp-mono">return</span>{" "}
        (der Wert, der rauskommt):
      </p>

      <PythonRunner
        rows={8}
        initialCode={`def brutto(netto):
    return netto * 1.19

print(brutto(100))
print(brutto(250))

einkauf = brutto(19.99) + brutto(45.50)
print(f"Gesamt: {einkauf:.2f} Euro")`}
      />

      <p>
        Das <span className="lp-mono">:.2f</span> im f-String rundet übrigens
        auf zwei Nachkommastellen, praktisch für Geldbeträge. Funktionen können
        auch mehrere Parameter haben:
      </p>

      <PythonRunner
        rows={8}
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

      <div className="lp-tip">
        <p>
          <strong>Warum das Gold wert ist:</strong> Der Notenschlüssel steht
          jetzt an genau EINER Stelle. Ändert die IHK die Grenzen, änderst du
          eine Funktion statt zwanzig Codestellen. Dieses Prinzip heißt
          &quot;Don&apos;t repeat yourself&quot; (DRY) und ist eine beliebte
          Frage im Fachgespräch.
        </p>
      </div>

      <div className="pk-aufgabe">
        <p>
          <strong>Übung 8.1:</strong> Schreib eine Funktion{" "}
          <span className="lp-mono">ist_gerade(zahl)</span>, die{" "}
          <span className="lp-mono">True</span> oder{" "}
          <span className="lp-mono">False</span> zurückgibt. Teste sie mit ein
          paar Zahlen.
        </p>
      </div>
      <PythonRunner
        rows={6}
        initialCode={`# Dein Code:

`}
      />
      <details className="pk-loesung">
        <summary>Musterlösung anzeigen</summary>
        <pre>{`def ist_gerade(zahl):
    return zahl % 2 == 0

print(ist_gerade(8))    # True
print(ist_gerade(7))    # False`}</pre>
      </details>

      <div className="pk-aufgabe">
        <p>
          <strong>Übung 8.2:</strong> Schreib eine Funktion{" "}
          <span className="lp-mono">durchschnitt(liste)</span>, die den
          Durchschnitt einer Zahlenliste zurückgibt, und teste sie mit den
          Punktelisten aus Lektion 7.
        </p>
      </div>
      <PythonRunner
        rows={7}
        initialCode={`punkte = [82, 45, 91, 67, 55]
# Dein Code:
`}
      />
      <details className="pk-loesung">
        <summary>Musterlösung anzeigen</summary>
        <pre>{`def durchschnitt(liste):
    summe = 0
    for wert in liste:
        summe = summe + wert
    return summe / len(liste)

punkte = [82, 45, 91, 67, 55]
print(durchschnitt(punkte))
print(durchschnitt([1, 2, 3]))`}</pre>
      </details>
    </LektionLayout>
  );
}
