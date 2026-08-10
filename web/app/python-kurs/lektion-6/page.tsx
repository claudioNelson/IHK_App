import type { Metadata } from "next";
import PythonRunner from "../_components/PythonRunner";
import LektionLayout from "../_components/LektionLayout";

export const metadata: Metadata = {
  title: "Python Lektion 6: Projekt Zahlenraten",
  description:
    "Dein erstes Spiel in Python: Zahlenraten mit random, while und break, Schritt für Schritt gebaut, direkt im Browser spielbar. Lektion 6 des kostenlosen Python-Kurses.",
  alternates: { canonical: "https://lernarena.app/python-kurs/lektion-6" },
};

export default function Lektion6() {
  return (
    <LektionLayout nr={6}>
      <p>
        Zeit für dein <strong>erstes richtiges Programm</strong>. Der Computer
        denkt sich eine Zahl zwischen 1 und 100 aus, du rätst, und er sagt
        dir nach jedem Versuch &quot;zu groß&quot; oder &quot;zu klein&quot;.
        Alles, was du dafür brauchst, kennst du schon: Variablen, if/elif,
        eine while-Schleife und break. Neu ist nur eine Sache.
      </p>

      <h3>Baustein 1: Der Zufall</h3>
      <p>
        Python bringt fertige Werkzeugkästen mit, sogenannte{" "}
        <strong>Module</strong>. Mit{" "}
        <span className="lp-mono">import random</span> holst du dir den
        Zufalls-Werkzeugkasten, und{" "}
        <span className="lp-mono">random.randint(1, 100)</span> liefert eine
        zufällige ganze Zahl von 1 bis 100. Führ das mehrmals aus, es kommt
        (fast) jedes Mal etwas anderes:
      </p>

      <PythonRunner
        rows={4}
        initialCode={`import random

geheimzahl = random.randint(1, 100)
print(geheimzahl)`}
      />

      <h3>Baustein 2: Ein einzelner Rateversuch</h3>
      <p>
        Bevor die Schleife dazukommt, bau die Logik für <strong>einen</strong>{" "}
        Versuch. Das ist ein sauberer Weg, Programme zu entwickeln: erst ein
        kleines Stück bauen und testen, dann erweitern.
      </p>

      <PythonRunner
        rows={9}
        initialCode={`import random
geheimzahl = random.randint(1, 100)

tipp = int(input("Dein Tipp (1-100): "))

if tipp < geheimzahl:
    print("Zu klein!")
elif tipp > geheimzahl:
    print("Zu gross!")
else:
    print("Treffer!")`}
      />

      <h3>Baustein 3: Die Schleife macht das Spiel</h3>
      <p>
        Jetzt kommt der Trick: Wir packen den Rateversuch in eine{" "}
        <span className="lp-mono">while True</span>-Schleife. Die läuft
        absichtlich endlos, und erst bei einem Treffer bricht{" "}
        <span className="lp-mono">break</span> aus. Dazu zählt eine Variable
        die Versuche mit. Das ist das komplette Spiel, spiel eine Runde:
      </p>

      <PythonRunner
        rows={16}
        initialCode={`import random

geheimzahl = random.randint(1, 100)
versuche = 0

print("Ich denke an eine Zahl zwischen 1 und 100...")

while True:
    tipp = int(input("Dein Tipp: "))
    versuche = versuche + 1

    if tipp < geheimzahl:
        print("Zu klein!")
    elif tipp > geheimzahl:
        print("Zu gross!")
    else:
        print(f"Treffer! Du hast {versuche} Versuche gebraucht.")
        break`}
      />

      <div className="lp-tip">
        <p>
          <strong>Profi-Frage:</strong> Wie viele Versuche brauchst du
          höchstens, wenn du clever rätst? Antwort: 7. Wenn du immer die
          Mitte des verbleibenden Bereichs tippst (50, dann 25 oder 75, ...),
          halbierst du den Suchraum jedes Mal. Das ist die{" "}
          <strong>binäre Suche</strong>, ein Algorithmus, der in der
          IHK-Prüfung regelmäßig vorkommt. Du hast ihn gerade beim Spielen
          benutzt.
        </p>
      </div>

      <div className="pk-aufgabe">
        <p>
          <strong>Übung 6.1:</strong> Baue das Spiel so um, dass der Spieler
          nur <strong>7 Versuche</strong> hat. Nach dem 7. Fehlversuch endet
          das Spiel mit &quot;Verloren! Die Zahl war ...&quot;. Tipp: Ersetze{" "}
          <span className="lp-mono">while True</span> durch{" "}
          <span className="lp-mono">while versuche &lt; 7</span> und gib die
          Verloren-Meldung nach der Schleife aus, falls kein Treffer kam.
        </p>
      </div>
      <PythonRunner
        rows={16}
        initialCode={`import random

geheimzahl = random.randint(1, 100)
versuche = 0
gewonnen = False

# Bau die Schleife um:
while True:
    tipp = int(input("Dein Tipp: "))
    versuche = versuche + 1

    if tipp < geheimzahl:
        print("Zu klein!")
    elif tipp > geheimzahl:
        print("Zu gross!")
    else:
        print(f"Treffer nach {versuche} Versuchen!")
        break`}
      />
      <details className="pk-loesung">
        <summary>Musterlösung anzeigen</summary>
        <pre>{`import random

geheimzahl = random.randint(1, 100)
versuche = 0
gewonnen = False

while versuche < 7:
    tipp = int(input("Dein Tipp: "))
    versuche = versuche + 1

    if tipp < geheimzahl:
        print("Zu klein!")
    elif tipp > geheimzahl:
        print("Zu gross!")
    else:
        print(f"Treffer nach {versuche} Versuchen!")
        gewonnen = True
        break

if not gewonnen:
    print(f"Verloren! Die Zahl war {geheimzahl}.")`}</pre>
      </details>

      <div className="pk-aufgabe">
        <p>
          <strong>Übung 6.2:</strong> Gib dem Spieler am Ende eine Bewertung:
          bis 5 Versuche &quot;Stark!&quot;, bis 8 &quot;Solide.&quot;, ab 9
          &quot;Da geht noch was.&quot; Du brauchst nur ein if/elif/else nach
          dem Treffer.
        </p>
      </div>
      <details className="pk-loesung">
        <summary>Musterlösung anzeigen</summary>
        <pre>{`# Nach dem "Treffer"-print, vor dem break:
if versuche <= 5:
    print("Stark!")
elif versuche <= 8:
    print("Solide.")
else:
    print("Da geht noch was.")`}</pre>
      </details>
    </LektionLayout>
  );
}
