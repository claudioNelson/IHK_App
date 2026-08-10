import type { Metadata } from "next";
import PythonRunner from "../_components/PythonRunner";
import LektionLayout from "../_components/LektionLayout";

export const metadata: Metadata = {
  title: "Python Lektion 4: if, elif und else",
  description:
    "Entscheidungen in Python: if/elif/else, Vergleichsoperatoren und and/or, erklärt am echten IHK-Notenschlüssel. Lektion 4 des kostenlosen Python-Kurses für Fachinformatiker.",
  alternates: { canonical: "https://lernarena.app/python-kurs/lektion-4" },
};

export default function Lektion4() {
  return (
    <LektionLayout nr={4}>
      <p>
        Bis jetzt läuft dein Code stur von oben nach unten. Mit{" "}
        <span className="lp-mono">if</span> bekommt er Verzweigungen:
        &quot;WENN das gilt, DANN tu dies, SONST das.&quot; Genau so steht es
        später auch im IHK-Pseudocode.
      </p>

      <PythonRunner
        rows={7}
        initialCode={`alter = 17

if alter >= 18:
    print("Du bist volljährig.")
else:
    print("Du bist minderjährig.")

print("Diese Zeile kommt immer.")`}
      />

      <p>
        Zwei Dinge sind hier entscheidend. Erstens die{" "}
        <strong>Einrückung</strong>: Alles, was um vier Leerzeichen eingerückt
        ist, gehört zum if-Block. Python erzwingt das, andere Sprachen nutzen
        dafür geschweifte Klammern. Zweitens der{" "}
        <strong>Vergleichsoperator</strong>{" "}
        <span className="lp-mono">&gt;=</span>. Davon gibt es sechs:{" "}
        <span className="lp-mono">==</span> (gleich, mit ZWEI
        Gleichheitszeichen!), <span className="lp-mono">!=</span> (ungleich),{" "}
        <span className="lp-mono">&lt;</span>, <span className="lp-mono">&gt;</span>,{" "}
        <span className="lp-mono">&lt;=</span> und{" "}
        <span className="lp-mono">&gt;=</span>.
      </p>

      <div className="lp-tip">
        <p>
          <strong>Der häufigste Anfängerfehler:</strong>{" "}
          <span className="lp-mono">=</span> speichert einen Wert,{" "}
          <span className="lp-mono">==</span> vergleicht zwei Werte. Wenn du
          in einer Bedingung nur ein Gleichheitszeichen schreibst, meckert
          Python sofort.
        </p>
      </div>

      <p>
        Mit <span className="lp-mono">elif</span> (&quot;else if&quot;) prüfst
        du mehrere Fälle nacheinander. Perfektes Beispiel: der echte
        IHK-Notenschlüssel. Python geht die Bedingungen von oben nach unten
        durch und nimmt die <strong>erste</strong>, die zutrifft:
      </p>

      <PythonRunner
        rows={12}
        initialCode={`punkte = 74

if punkte >= 92:
    print("Note 1, sehr gut!")
elif punkte >= 81:
    print("Note 2, gut")
elif punkte >= 67:
    print("Note 3, befriedigend")
elif punkte >= 50:
    print("Note 4, bestanden")
else:
    print("Leider durchgefallen")`}
      />

      <p>
        Bedingungen lassen sich mit <span className="lp-mono">and</span> und{" "}
        <span className="lp-mono">or</span> kombinieren, und mit{" "}
        <span className="lp-mono">not</span> umdrehen:
      </p>

      <PythonRunner
        rows={6}
        initialCode={`alter = 22
azubi = True

if alter < 25 and azubi:
    print("Du bekommst den Azubi-Rabatt!")`}
      />

      <div className="pk-aufgabe">
        <p>
          <strong>Übung 4.1:</strong> Frag den Nutzer nach einer Zahl und gib
          aus, ob sie gerade oder ungerade ist. Tipp: Lektion 3, Modulo.
        </p>
      </div>
      <PythonRunner
        rows={6}
        initialCode={`zahl = int(input("Eine Zahl: "))
# Dein Code:
`}
      />
      <details className="pk-loesung">
        <summary>Musterlösung anzeigen</summary>
        <pre>{`zahl = int(input("Eine Zahl: "))
if zahl % 2 == 0:
    print("gerade")
else:
    print("ungerade")`}</pre>
      </details>

      <div className="pk-aufgabe">
        <p>
          <strong>Übung 4.2:</strong> Ein Onlineshop berechnet Versandkosten:
          unter 20 Euro Bestellwert kosten sie 4,95 Euro, ab 20 Euro noch 1,95
          Euro, und ab 50 Euro ist der Versand gratis. Schreib das mit
          if/elif/else und teste verschiedene Werte.
        </p>
      </div>
      <PythonRunner
        rows={8}
        initialCode={`bestellwert = 35
# Dein Code:
`}
      />
      <details className="pk-loesung">
        <summary>Musterlösung anzeigen</summary>
        <pre>{`bestellwert = 35
if bestellwert >= 50:
    print("Versand gratis")
elif bestellwert >= 20:
    print("Versand: 1.95 Euro")
else:
    print("Versand: 4.95 Euro")

# Wichtig: von der GROESSTEN Grenze abwaerts pruefen,
# sonst schnappt sich "ab 20 Euro" auch die 50er-Faelle.`}</pre>
      </details>
    </LektionLayout>
  );
}
