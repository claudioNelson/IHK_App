import type { Metadata } from "next";
import PythonRunner from "../_components/PythonRunner";
import LektionLayout from "../_components/LektionLayout";

export const metadata: Metadata = {
  title: "Python Lektion 7: Listen & Dictionaries",
  description:
    "Listen und Dictionaries in Python: anlegen, durchlaufen, ändern, mit Übungen direkt im Browser. Lektion 7 des kostenlosen Python-Kurses für Fachinformatiker.",
  alternates: { canonical: "https://lernarena.app/python-kurs/lektion-7" },
};

export default function Lektion7() {
  return (
    <LektionLayout nr={7}>
      <p>
        Bisher konnte jede Variable genau <strong>einen</strong> Wert
        speichern. Eine <strong>Liste</strong> speichert beliebig viele, in
        einer festen Reihenfolge. Du erkennst sie an den eckigen Klammern:
      </p>

      <PythonRunner
        rows={7}
        initialCode={`faecher = ["Netzwerke", "Datenbanken", "Programmierung"]

print(faecher)
print(faecher[0])      # erstes Element (Zaehlung startet bei 0!)
print(faecher[2])      # drittes Element
print(len(faecher))    # Anzahl der Elemente`}
      />

      <p>
        Der Index startet bei 0, genau wie{" "}
        <span className="lp-mono">range()</span> in Lektion 5. Mit{" "}
        <span className="lp-mono">.append()</span> hängst du Elemente an, mit{" "}
        <span className="lp-mono">.remove()</span> löschst du sie, und mit{" "}
        <span className="lp-mono">in</span> prüfst du, ob etwas enthalten ist:
      </p>

      <PythonRunner
        rows={8}
        initialCode={`todo = ["Backup pruefen", "Server patchen"]

todo.append("Doku schreiben")
print(todo)

todo.remove("Server patchen")
print(todo)

print("Doku schreiben" in todo)`}
      />

      <p>
        Ihre volle Kraft entfalten Listen zusammen mit der for-Schleife. Die
        läuft einfach über jedes Element, ganz ohne Index:
      </p>

      <PythonRunner
        rows={7}
        initialCode={`punkte = [82, 45, 91, 67, 55]

summe = 0
for p in punkte:
    summe = summe + p

print(f"Durchschnitt: {summe / len(punkte)}")`}
      />

      <h3>Dictionaries: Nachschlagen statt durchzählen</h3>
      <p>
        Ein <strong>Dictionary</strong> speichert Paare aus Schlüssel und
        Wert, wie ein Wörterbuch: Du schlägst mit dem Schlüssel nach und
        bekommst den Wert. Es nutzt geschweifte Klammern:
      </p>

      <PythonRunner
        rows={9}
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

      <div className="lp-tip">
        <p>
          <strong>Wann Liste, wann Dictionary?</strong> Liste, wenn die
          Reihenfolge zählt oder du viele gleichartige Dinge hast (Messwerte,
          Aufgaben). Dictionary, wenn du Dinge über einen Namen nachschlagen
          willst (Eigenschaften eines Azubis, Preise pro Artikel). In der
          IHK-Prüfung heißen Listen übrigens meist &quot;Array&quot;, das
          Konzept ist dasselbe.
        </p>
      </div>

      <div className="pk-aufgabe">
        <p>
          <strong>Übung 7.1:</strong> Gegeben ist eine Liste mit Noten. Gib die
          beste (kleinste) Note aus. Tipp: Entweder mit einer Schleife wie beim
          Minimum-Beispiel aus der AP-Vorbereitung, oder du entdeckst die
          eingebaute Funktion <span className="lp-mono">min()</span>.
        </p>
      </div>
      <PythonRunner
        rows={4}
        initialCode={`noten = [3, 1, 4, 2, 2]
# Dein Code:
`}
      />
      <details className="pk-loesung">
        <summary>Musterlösung anzeigen</summary>
        <pre>{`noten = [3, 1, 4, 2, 2]

# Weg 1: eingebaute Funktion
print(min(noten))

# Weg 2: von Hand (so will es die IHK sehen)
beste = noten[0]
for n in noten:
    if n < beste:
        beste = n
print(beste)`}</pre>
      </details>

      <div className="pk-aufgabe">
        <p>
          <strong>Übung 7.2:</strong> Baue ein Dictionary{" "}
          <span className="lp-mono">preise</span> mit drei Artikeln und ihren
          Preisen. Frag den Nutzer nach einem Artikel und gib den Preis aus.
          Bonus: Melde &quot;Artikel unbekannt&quot;, wenn er nicht existiert
          (Tipp: <span className="lp-mono">in</span> funktioniert auch bei
          Dictionaries).
        </p>
      </div>
      <PythonRunner
        rows={8}
        initialCode={`preise = {"USB-Stick": 8.99, "Maus": 19.90, "Headset": 45.00}
# Dein Code:
`}
      />
      <details className="pk-loesung">
        <summary>Musterlösung anzeigen</summary>
        <pre>{`preise = {"USB-Stick": 8.99, "Maus": 19.90, "Headset": 45.00}

artikel = input("Welcher Artikel? ")
if artikel in preise:
    print(f"{artikel} kostet {preise[artikel]} Euro")
else:
    print("Artikel unbekannt")`}</pre>
      </details>
    </LektionLayout>
  );
}
