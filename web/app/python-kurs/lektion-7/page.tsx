import type { Metadata } from "next";
import { LsAbschnitt, LsHinweis } from "../../lernen/_components/LsBausteine";
import PythonRunner from "../_components/PythonRunner";
import LektionLayout from "../_components/LektionLayout";
import { Aufgabe, Loesung } from "../_components/KursBausteine";

export const metadata: Metadata = {
  title: "Python Lektion 7: Listen und Dictionaries",
  description:
    "Listen und Dictionaries in Python: anlegen, durchlaufen, ändern, mit Übungen direkt im Browser. Lektion 7 des kostenlosen Python-Kurses für Fachinformatiker.",
  alternates: { canonical: "https://lernarena.app/python-kurs/lektion-7" },
};

export default function Lektion7() {
  return (
    <LektionLayout
      nr={7}
      lead="Listen und Dictionaries in Python: anlegen, durchlaufen, ändern, mit Übungen direkt im Browser."
      uebungen={2}
    >
      <LsAbschnitt id="listen" titel="Listen">
        <p>
          Bisher konnte jede Variable genau <strong>einen</strong> Wert speichern. Eine{" "}
          <strong>Liste</strong> speichert beliebig viele, in einer festen Reihenfolge. Du erkennst
          sie an den eckigen Klammern:
        </p>

        <PythonRunner
          rows={7}
          dateiname="listen.py"
          initialCode={`faecher = ["Netzwerke", "Datenbanken", "Programmierung"]

print(faecher)
print(faecher[0])      # erstes Element (Zaehlung startet bei 0!)
print(faecher[2])      # drittes Element
print(len(faecher))    # Anzahl der Elemente`}
        />

        <p>
          Der Index startet bei 0, genau wie <code>range()</code> in Lektion 5. Mit{" "}
          <code>.append()</code> hängst du Elemente an, mit <code>.remove()</code> löschst du sie,
          und mit <code>in</code> prüfst du, ob etwas enthalten ist:
        </p>

        <PythonRunner
          rows={8}
          dateiname="todo.py"
          initialCode={`todo = ["Backup pruefen", "Server patchen"]

todo.append("Doku schreiben")
print(todo)

todo.remove("Server patchen")
print(todo)

print("Doku schreiben" in todo)`}
        />

        <p>
          Ihre volle Kraft entfalten Listen zusammen mit der for-Schleife. Die läuft einfach über
          jedes Element, ganz ohne Index:
        </p>

        <PythonRunner
          rows={7}
          dateiname="durchschnitt.py"
          initialCode={`punkte = [82, 45, 91, 67, 55]

summe = 0
for p in punkte:
    summe = summe + p

print(f"Durchschnitt: {summe / len(punkte)}")`}
        />
      </LsAbschnitt>

      <LsAbschnitt id="dictionaries" titel="Dictionaries: Nachschlagen statt durchzählen">
        <p>
          Ein <strong>Dictionary</strong> speichert Paare aus Schlüssel und Wert, wie ein
          Wörterbuch: Du schlägst mit dem Schlüssel nach und bekommst den Wert. Es nutzt
          geschweifte Klammern:
        </p>

        <PythonRunner
          rows={9}
          dateiname="dictionary.py"
          initialCode={`azubi = {
    "name": "Alex",
    "beruf": "FIAE",
    "jahr": 2,
}

print(azubi["name"])
azubi["jahr"] = 3          # Wert aendern
azubi["betrieb"] = "DevSoft"  # neues Paar anlegen
print(azubi)`}
        />

        <LsHinweis titel="Wann Liste, wann Dictionary?">
          <p>
            Liste, wenn die Reihenfolge zählt oder du viele gleichartige Dinge hast (Messwerte,
            Aufgaben). Dictionary, wenn du Dinge über einen Namen nachschlagen willst
            (Eigenschaften eines Azubis, Preise pro Artikel). In der IHK-Prüfung heißen Listen
            übrigens meist „Array“, das Konzept ist dasselbe.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="uebungen" titel="Übungen">
        <p>Erst selbst versuchen, dann die Lösung aufklappen.</p>

        <Aufgabe nr="7.1">
          <p>
            Gegeben ist eine Liste mit Noten. Gib die beste (kleinste) Note aus. Tipp: Entweder mit
            einer Schleife wie beim Minimum-Beispiel aus der AP-Vorbereitung, oder du entdeckst die
            eingebaute Funktion <code>min()</code>.
          </p>
          <PythonRunner
            rows={4}
            dateiname="uebung_7_1.py"
            label="Python-Code: Übung 7.1"
            initialCode={`noten = [3, 1, 4, 2, 2]
# Dein Code:
`}
          />
          <Loesung
            code={`noten = [3, 1, 4, 2, 2]

# Weg 1: eingebaute Funktion
print(min(noten))

# Weg 2: von Hand (so will es die IHK sehen)
beste = noten[0]
for n in noten:
    if n < beste:
        beste = n
print(beste)`}
          />
        </Aufgabe>

        <Aufgabe nr="7.2">
          <p>
            Baue ein Dictionary <code>preise</code> mit drei Artikeln und ihren Preisen. Frag den
            Nutzer nach einem Artikel und gib den Preis aus. Bonus: Melde „Artikel unbekannt“, wenn
            er nicht existiert (Tipp: <code>in</code> funktioniert auch bei Dictionaries).
          </p>
          <PythonRunner
            rows={8}
            dateiname="uebung_7_2.py"
            label="Python-Code: Übung 7.2"
            initialCode={`preise = {"USB-Stick": 8.99, "Maus": 19.90, "Headset": 45.00}
# Dein Code:
`}
          />
          <Loesung
            code={`preise = {"USB-Stick": 8.99, "Maus": 19.90, "Headset": 45.00}

artikel = input("Welcher Artikel? ")
if artikel in preise:
    print(f"{artikel} kostet {preise[artikel]} Euro")
else:
    print("Artikel unbekannt")`}
          />
        </Aufgabe>
      </LsAbschnitt>
    </LektionLayout>
  );
}
