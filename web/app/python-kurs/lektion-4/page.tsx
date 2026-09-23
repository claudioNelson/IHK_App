import type { Metadata } from "next";
import { LsAbschnitt, LsHinweis } from "../../lernen/_components/LsBausteine";
import PythonRunner from "../_components/PythonRunner";
import LektionLayout from "../_components/LektionLayout";
import { Aufgabe, Loesung } from "../_components/KursBausteine";

export const metadata: Metadata = {
  title: "Python Lektion 4: if, elif und else",
  description:
    "Entscheidungen in Python: if/elif/else, Vergleichsoperatoren und and/or, erklärt am echten IHK-Notenschlüssel. Lektion 4 des kostenlosen Python-Kurses für Fachinformatiker.",
  alternates: { canonical: "https://lernarena.app/python-kurs/lektion-4" },
};

export default function Lektion4() {
  return (
    <LektionLayout
      nr={4}
      lead="Entscheidungen in Python: if/elif/else, Vergleichsoperatoren und and/or, erklärt am echten IHK-Notenschlüssel."
      uebungen={2}
    >
      <LsAbschnitt id="if-else" titel="Wenn, dann, sonst">
        <p>
          Bis jetzt läuft dein Code stur von oben nach unten. Mit <code>if</code> bekommt er
          Verzweigungen: „WENN das gilt, DANN tu dies, SONST das.“ Genau so steht es später auch
          im IHK-Pseudocode.
        </p>

        <PythonRunner
          rows={7}
          dateiname="volljaehrig.py"
          initialCode={`alter = 17

if alter >= 18:
    print("Du bist volljährig.")
else:
    print("Du bist minderjährig.")

print("Diese Zeile kommt immer.")`}
        />

        <p>
          Zwei Dinge sind hier entscheidend. Erstens die <strong>Einrückung</strong>: Alles, was um
          vier Leerzeichen eingerückt ist, gehört zum if-Block. Python erzwingt das, andere
          Sprachen nutzen dafür geschweifte Klammern. Zweitens der{" "}
          <strong>Vergleichsoperator</strong> <code>&gt;=</code>. Davon gibt es sechs:{" "}
          <code>==</code> (gleich, mit ZWEI Gleichheitszeichen!), <code>!=</code> (ungleich),{" "}
          <code>&lt;</code>, <code>&gt;</code>, <code>&lt;=</code> und <code>&gt;=</code>.
        </p>

        <LsHinweis titel="Der häufigste Anfängerfehler">
          <p>
            <code>=</code> speichert einen Wert, <code>==</code> vergleicht zwei Werte. Wenn du in
            einer Bedingung nur ein Gleichheitszeichen schreibst, meckert Python sofort.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="elif" titel="Mehrere Fälle mit elif">
        <p>
          Mit <code>elif</code> („else if“) prüfst du mehrere Fälle nacheinander. Perfektes
          Beispiel: der echte IHK-Notenschlüssel. Python geht die Bedingungen von oben nach unten
          durch und nimmt die <strong>erste</strong>, die zutrifft:
        </p>

        <PythonRunner
          rows={12}
          dateiname="notenschluessel.py"
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
      </LsAbschnitt>

      <LsAbschnitt id="and-or" titel="Bedingungen verknüpfen">
        <p>
          Bedingungen lassen sich mit <code>and</code> und <code>or</code> kombinieren, und mit{" "}
          <code>not</code> umdrehen:
        </p>

        <PythonRunner
          rows={6}
          dateiname="rabatt.py"
          initialCode={`alter = 22
azubi = True

if alter < 25 and azubi:
    print("Du bekommst den Azubi-Rabatt!")`}
        />
      </LsAbschnitt>

      <LsAbschnitt id="uebungen" titel="Übungen">
        <p>Erst selbst versuchen, dann die Lösung aufklappen.</p>

        <Aufgabe nr="4.1">
          <p>
            Frag den Nutzer nach einer Zahl und gib aus, ob sie gerade oder ungerade ist. Tipp:
            Lektion 3, Modulo.
          </p>
          <PythonRunner
            rows={6}
            dateiname="uebung_4_1.py"
            label="Python-Code: Übung 4.1"
            initialCode={`zahl = int(input("Eine Zahl: "))
# Dein Code:
`}
          />
          <Loesung
            code={`zahl = int(input("Eine Zahl: "))
if zahl % 2 == 0:
    print("gerade")
else:
    print("ungerade")`}
          />
        </Aufgabe>

        <Aufgabe nr="4.2">
          <p>
            Ein Onlineshop berechnet Versandkosten: unter 20 Euro Bestellwert kosten sie 4,95 Euro,
            ab 20 Euro noch 1,95 Euro, und ab 50 Euro ist der Versand gratis. Schreib das mit
            if/elif/else und teste verschiedene Werte.
          </p>
          <PythonRunner
            rows={8}
            dateiname="uebung_4_2.py"
            label="Python-Code: Übung 4.2"
            initialCode={`bestellwert = 35
# Dein Code:
`}
          />
          <Loesung
            code={`bestellwert = 35
if bestellwert >= 50:
    print("Versand gratis")
elif bestellwert >= 20:
    print("Versand: 1.95 Euro")
else:
    print("Versand: 4.95 Euro")

# Wichtig: von der GROESSTEN Grenze abwaerts pruefen,
# sonst schnappt sich "ab 20 Euro" auch die 50er-Faelle.`}
          />
        </Aufgabe>
      </LsAbschnitt>
    </LektionLayout>
  );
}
