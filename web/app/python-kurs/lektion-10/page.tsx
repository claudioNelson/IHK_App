import type { Metadata } from "next";
import PythonRunner from "../_components/PythonRunner";
import LektionLayout from "../_components/LektionLayout";

export const metadata: Metadata = {
  title: "Python Lektion 10: Klassen & Objekte (OOP-Basics)",
  description:
    "Objektorientierung verständlich: Klassen, Objekte, Attribute, Methoden und Vererbung in Python, mit Bezug zum UML-Klassendiagramm der IHK-Prüfung. Lektion 10 des kostenlosen Python-Kurses.",
  alternates: { canonical: "https://lernarena.app/python-kurs/lektion-10" },
};

export default function Lektion10() {
  return (
    <LektionLayout nr={10}>
      <p>
        Jetzt kommt das Thema, das in der IHK-Prüfung am häufigsten
        drankommt: <strong>Objektorientierung</strong>. Die Idee: Statt Daten
        (Variablen) und Verhalten (Funktionen) getrennt zu halten, packst du
        beides zusammen in eine <strong>Klasse</strong>. Eine Klasse ist der
        Bauplan, ein <strong>Objekt</strong> ist ein konkretes Exemplar davon.
      </p>

      <PythonRunner
        rows={13}
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
        Die Bausteine im Einzelnen:{" "}
        <span className="lp-mono">__init__</span> ist der{" "}
        <strong>Konstruktor</strong>, er läuft automatisch beim Erzeugen des
        Objekts und füllt die <strong>Attribute</strong> (
        <span className="lp-mono">self.name</span>,{" "}
        <span className="lp-mono">self.jahr</span>).{" "}
        <span className="lp-mono">self</span> ist das Objekt selbst, darüber
        greifen <strong>Methoden</strong> (Funktionen in der Klasse) auf die
        eigenen Attribute zu.
      </p>

      <div className="lp-tip">
        <p>
          <strong>Brücke zur IHK:</strong> Das hier ist exakt das, was im
          UML-Klassendiagramm steht. Oben der Klassenname (Azubi), in der
          Mitte die Attribute (name, jahr), unten die Methoden
          (vorstellen()). Wenn du eine Klasse in Python schreiben kannst,
          kannst du auch das Diagramm dazu zeichnen, und umgekehrt.
        </p>
      </div>

      <p>
        Das zweite große OOP-Konzept ist <strong>Vererbung</strong>: Eine
        Klasse übernimmt alles von einer anderen und ergänzt oder ändert nur,
        was anders ist. Die &quot;ist-ein&quot;-Beziehung aus dem
        UML-Diagramm:
      </p>

      <PythonRunner
        rows={12}
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

      <div className="pk-aufgabe">
        <p>
          <strong>Übung 10.1:</strong> Schreib eine Klasse{" "}
          <span className="lp-mono">Rechteck</span> mit den Attributen{" "}
          <span className="lp-mono">breite</span> und{" "}
          <span className="lp-mono">hoehe</span> und einer Methode{" "}
          <span className="lp-mono">flaeche()</span>, die die Fläche
          zurückgibt. Erzeuge zwei Rechtecke und gib ihre Flächen aus.
        </p>
      </div>
      <PythonRunner
        rows={10}
        initialCode={`# Dein Code:

`}
      />
      <details className="pk-loesung">
        <summary>Musterlösung anzeigen</summary>
        <pre>{`class Rechteck:
    def __init__(self, breite, hoehe):
        self.breite = breite
        self.hoehe = hoehe

    def flaeche(self):
        return self.breite * self.hoehe

r1 = Rechteck(4, 5)
r2 = Rechteck(10, 3)
print(r1.flaeche())   # 20
print(r2.flaeche())   # 30`}</pre>
      </details>

      <div className="pk-aufgabe">
        <p>
          <strong>Übung 10.2:</strong> Erweitere die Azubi-Klasse um eine
          Methode <span className="lp-mono">geburtstag()</span>, die das
          Lehrjahr um 1 erhöht (okay, fachlich eher &quot;neues
          Ausbildungsjahr&quot;, aber du verstehst das Prinzip). Rufe sie auf
          und lass das Objekt sich davor und danach vorstellen.
        </p>
      </div>
      <PythonRunner
        rows={13}
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
      <details className="pk-loesung">
        <summary>Musterlösung anzeigen</summary>
        <pre>{`    def geburtstag(self):
        self.jahr = self.jahr + 1

# Und unten:
a = Azubi("Alex", 1)
a.vorstellen()
a.geburtstag()
a.vorstellen()   # jetzt 2. Lehrjahr`}</pre>
      </details>
    </LektionLayout>
  );
}
