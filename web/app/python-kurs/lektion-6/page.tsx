import type { Metadata } from "next";
import { LsAbschnitt, LsHinweis } from "../../lernen/_components/LsBausteine";
import PythonRunner from "../_components/PythonRunner";
import LektionLayout from "../../components/kurs/LektionLayout";
import { pythonKurs } from "../_components/lektionen";
import { Aufgabe, Loesung } from "../../components/kurs/KursBausteine";

export const metadata: Metadata = {
  title: "Python Lektion 6: Projekt Zahlenraten",
  description:
    "Dein erstes Spiel in Python: Zahlenraten mit random, while und break, Schritt für Schritt gebaut, direkt im Browser spielbar. Lektion 6 des kostenlosen Python-Kurses.",
  alternates: { canonical: "https://lernarena.app/python-kurs/lektion-6" },
};

export default function Lektion6() {
  return (
    <LektionLayout
      kurs={pythonKurs}
      nr={6}
      lead="Dein erstes Spiel in Python: Zahlenraten mit random, while und break, Schritt für Schritt gebaut, direkt im Browser spielbar."
      uebungen={2}
    >
      <LsAbschnitt id="spiel" titel="Dein erstes richtiges Programm">
        <p>
          Zeit für dein <strong>erstes richtiges Programm</strong>. Der Computer denkt sich eine
          Zahl zwischen 1 und 100 aus, du rätst, und er sagt dir nach jedem Versuch „zu groß“ oder
          „zu klein“. Alles, was du dafür brauchst, kennst du schon: Variablen, if/elif, eine
          while-Schleife und break. Neu ist nur eine Sache.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="zufall" titel="Baustein 1: Der Zufall">
        <p>
          Python bringt fertige Werkzeugkästen mit, sogenannte <strong>Module</strong>. Mit{" "}
          <code>import random</code> holst du dir den Zufalls-Werkzeugkasten, und{" "}
          <code>random.randint(1, 100)</code> liefert eine zufällige ganze Zahl von 1 bis 100.
          Führ das mehrmals aus, es kommt (fast) jedes Mal etwas anderes:
        </p>

        <PythonRunner
          rows={4}
          dateiname="zufall.py"
          initialCode={`import random

geheimzahl = random.randint(1, 100)
print(geheimzahl)`}
        />
      </LsAbschnitt>

      <LsAbschnitt id="rateversuch" titel="Baustein 2: Ein einzelner Rateversuch">
        <p>
          Bevor die Schleife dazukommt, bau die Logik für <strong>einen</strong> Versuch. Das ist
          ein sauberer Weg, Programme zu entwickeln: erst ein kleines Stück bauen und testen, dann
          erweitern.
        </p>

        <PythonRunner
          rows={9}
          dateiname="rateversuch.py"
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
      </LsAbschnitt>

      <LsAbschnitt id="schleife" titel="Baustein 3: Die Schleife macht das Spiel">
        <p>
          Jetzt kommt der Trick: Wir packen den Rateversuch in eine <code>while True</code>
          -Schleife. Die läuft absichtlich endlos, und erst bei einem Treffer bricht{" "}
          <code>break</code> aus. Dazu zählt eine Variable die Versuche mit. Das ist das komplette
          Spiel, spiel eine Runde:
        </p>

        <PythonRunner
          rows={16}
          dateiname="zahlenraten.py"
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

        <LsHinweis titel="Profi-Frage" icon="buch" label="Prüfungsbezug">
          <p>
            Wie viele Versuche brauchst du höchstens, wenn du clever rätst? Antwort: 7. Wenn du
            immer die Mitte des verbleibenden Bereichs tippst (50, dann 25 oder 75, ...), halbierst
            du den Suchraum jedes Mal. Das ist die <strong>binäre Suche</strong>, ein Algorithmus,
            der in der IHK-Prüfung regelmäßig vorkommt. Du hast ihn gerade beim Spielen benutzt.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="uebungen" titel="Übungen">
        <p>Erst selbst versuchen, dann die Lösung aufklappen.</p>

        <Aufgabe nr="6.1">
          <p>
            Baue das Spiel so um, dass der Spieler nur <strong>7 Versuche</strong> hat. Nach dem 7.
            Fehlversuch endet das Spiel mit „Verloren! Die Zahl war ...“. Tipp: Ersetze{" "}
            <code>while True</code> durch <code>while versuche &lt; 7</code> und gib die
            Verloren-Meldung nach der Schleife aus, falls kein Treffer kam.
          </p>
          <PythonRunner
            rows={16}
            dateiname="uebung_6_1.py"
            label="Python-Code: Übung 6.1"
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
          <Loesung
            code={`import random

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
    print(f"Verloren! Die Zahl war {geheimzahl}.")`}
          />
        </Aufgabe>

        <Aufgabe nr="6.2">
          <p>
            Gib dem Spieler am Ende eine Bewertung: bis 5 Versuche „Stark!“, bis 8 „Solide.“, ab 9
            „Da geht noch was.“ Du brauchst nur ein if/elif/else nach dem Treffer.
          </p>
          <Loesung
            code={`# Nach dem "Treffer"-print, vor dem break:
if versuche <= 5:
    print("Stark!")
elif versuche <= 8:
    print("Solide.")
else:
    print("Da geht noch was.")`}
          />
        </Aufgabe>
      </LsAbschnitt>
    </LektionLayout>
  );
}
