import type { Metadata } from "next";
import { LsAbschnitt, LsHinweis } from "../../lernen/_components/LsBausteine";
import PythonRunner from "../_components/PythonRunner";
import LektionLayout from "../../components/kurs/LektionLayout";
import { pythonKurs } from "../_components/lektionen";
import { Aufgabe, Loesung } from "../../components/kurs/KursBausteine";

export const metadata: Metadata = {
  title: "Python Lektion 10: Klassen und Objekte (OOP-Basics)",
  description:
    "Objektorientierung verständlich: Klassen, Objekte, Attribute, Methoden und Vererbung in Python, mit Bezug zum UML-Klassendiagramm der IHK-Prüfung. Lektion 10 des kostenlosen Python-Kurses.",
  alternates: { canonical: "https://lernarena.app/python-kurs/lektion-10" },
};

export default function Lektion10() {
  return (
    <LektionLayout
      kurs={pythonKurs}
      nr={10}
      lead="Objektorientierung verständlich: Klassen, Objekte, Attribute, Methoden und Vererbung in Python, mit Bezug zum UML-Klassendiagramm der IHK-Prüfung."
      uebungen={2}
    >
      <LsAbschnitt id="klassen" titel="Klassen und Objekte">
        <p>
          Jetzt kommt das Thema, das in der IHK-Prüfung am häufigsten drankommt:{" "}
          <strong>Objektorientierung</strong>. Die Idee: Statt Daten (Variablen) und Verhalten
          (Funktionen) getrennt zu halten, packst du beides zusammen in eine{" "}
          <strong>Klasse</strong>. Eine Klasse ist der Bauplan, ein <strong>Objekt</strong> ist
          ein konkretes Exemplar davon.
        </p>

        <PythonRunner
          rows={13}
          dateiname="azubi.py"
          initialCode={`class Azubi:
    def __init__(self, name, jahr):
        self.name = name
        self.jahr = jahr

    def vorstellen(self):
        print(f"Hi, ich bin {self.name}, {self.jahr}. Lehrjahr.")

# Zwei Objekte aus demselben Bauplan:
a1 = Azubi("Alex", 2)
a2 = Azubi("Sam", 1)

a1.vorstellen()
a2.vorstellen()`}
        />

        <p>
          Die Bausteine im Einzelnen: <code>__init__</code> ist der <strong>Konstruktor</strong>,
          er läuft automatisch beim Erzeugen des Objekts und füllt die{" "}
          <strong>Attribute</strong> (<code>self.name</code>, <code>self.jahr</code>).{" "}
          <code>self</code> ist das Objekt selbst, darüber greifen <strong>Methoden</strong>{" "}
          (Funktionen in der Klasse) auf die eigenen Attribute zu.
        </p>

        <LsHinweis titel="Brücke zur IHK" icon="buch" label="Prüfungsbezug">
          <p>
            Das hier ist exakt das, was im UML-Klassendiagramm steht. Oben der Klassenname
            (Azubi), in der Mitte die Attribute (name, jahr), unten die Methoden (vorstellen()).
            Wenn du eine Klasse in Python schreiben kannst, kannst du auch das Diagramm dazu
            zeichnen, und umgekehrt.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="vererbung" titel="Vererbung">
        <p>
          Das zweite große OOP-Konzept ist <strong>Vererbung</strong>: Eine Klasse übernimmt
          alles von einer anderen und ergänzt oder ändert nur, was anders ist. Die
          „ist-ein“-Beziehung aus dem UML-Diagramm:
        </p>

        <PythonRunner
          rows={12}
          dateiname="vererbung.py"
          initialCode={`class Azubi:
    def __init__(self, name):
        self.name = name

    def vorstellen(self):
        print(f"Ich bin {self.name}.")

class Fachinformatiker(Azubi):   # erbt von Azubi
    def vorstellen(self):        # ueberschreibt die Methode
        print(f"Ich bin {self.name} und ich programmiere!")

a = Azubi("Sam")
f = Fachinformatiker("Alex")
a.vorstellen()
f.vorstellen()`}
        />
      </LsAbschnitt>

      <LsAbschnitt id="uebungen" titel="Übungen">
        <p>Erst selbst versuchen, dann die Lösung aufklappen.</p>

        <Aufgabe nr="10.1">
          <p>
            Schreib eine Klasse <code>Rechteck</code> mit den Attributen <code>breite</code> und{" "}
            <code>hoehe</code> und einer Methode <code>flaeche()</code>, die die Fläche
            zurückgibt. Erzeuge zwei Rechtecke und gib ihre Flächen aus.
          </p>
          <PythonRunner
            rows={10}
            dateiname="uebung_10_1.py"
            label="Python-Code: Übung 10.1"
            initialCode={`# Dein Code:

`}
          />
          <Loesung
            code={`class Rechteck:
    def __init__(self, breite, hoehe):
        self.breite = breite
        self.hoehe = hoehe

    def flaeche(self):
        return self.breite * self.hoehe

r1 = Rechteck(4, 5)
r2 = Rechteck(10, 3)
print(r1.flaeche())   # 20
print(r2.flaeche())   # 30`}
          />
        </Aufgabe>

        <Aufgabe nr="10.2">
          <p>
            Erweitere die Azubi-Klasse um eine Methode <code>geburtstag()</code>, die das Lehrjahr
            um 1 erhöht (okay, fachlich eher „neues Ausbildungsjahr“, aber du verstehst das
            Prinzip). Rufe sie auf und lass das Objekt sich davor und danach vorstellen.
          </p>
          <PythonRunner
            rows={13}
            dateiname="uebung_10_2.py"
            label="Python-Code: Übung 10.2"
            initialCode={`class Azubi:
    def __init__(self, name, jahr):
        self.name = name
        self.jahr = jahr

    def vorstellen(self):
        print(f"Hi, ich bin {self.name}, {self.jahr}. Lehrjahr.")

    # Deine neue Methode hier:

a = Azubi("Alex", 1)
a.vorstellen()`}
          />
          <Loesung
            code={`    def geburtstag(self):
        self.jahr = self.jahr + 1

# Und unten:
a = Azubi("Alex", 1)
a.vorstellen()
a.geburtstag()
a.vorstellen()   # jetzt 2. Lehrjahr`}
          />
        </Aufgabe>
      </LsAbschnitt>
    </LektionLayout>
  );
}
