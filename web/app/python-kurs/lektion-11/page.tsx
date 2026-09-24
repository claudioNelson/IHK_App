import type { Metadata } from "next";
import { LsAbschnitt, LsHinweis } from "../../lernen/_components/LsBausteine";
import LektionLayout from "../../components/kurs/LektionLayout";
import { pythonKurs } from "../_components/lektionen";
import { Aufgabe, CodeBlock } from "../../components/kurs/KursBausteine";

export const metadata: Metadata = {
  title: "Python Lektion 11: Projekt Snake auf deinem Rechner",
  description:
    "Das Abschlussprojekt: Python lokal installieren und ein komplettes Snake-Spiel mit dem turtle-Modul bauen, Schritt für Schritt erklärt. Lektion 11 des kostenlosen Python-Kurses.",
  alternates: { canonical: "https://lernarena.app/python-kurs/lektion-11" },
};

const snakeCode = `import turtle
import random

# Fenster
fenster = turtle.Screen()
fenster.title("Snake - Lernarena Edition")
fenster.bgcolor("#0D1117")
fenster.setup(width=600, height=600)
fenster.tracer(0)   # wir zeichnen selbst, wann wir wollen

# Schlange
kopf = turtle.Turtle()
kopf.shape("square")
kopf.color("#5FD98A")
kopf.penup()
kopf.goto(0, 0)
richtung = "stop"

koerper = []   # Liste der Koerper-Segmente (Lektion 7!)

# Futter
futter = turtle.Turtle()
futter.shape("circle")
futter.color("#FF6B63")
futter.penup()
futter.goto(0, 100)

# Punkte
punkte = 0
anzeige = turtle.Turtle()
anzeige.hideturtle()
anzeige.penup()
anzeige.color("white")
anzeige.goto(0, 260)
anzeige.write("Punkte: 0", align="center", font=("Arial", 16, "bold"))

# Steuerung (Funktionen, Lektion 8!)
def hoch():
    global richtung
    if richtung != "runter":
        richtung = "hoch"

def runter():
    global richtung
    if richtung != "hoch":
        richtung = "runter"

def links():
    global richtung
    if richtung != "rechts":
        richtung = "links"

def rechts():
    global richtung
    if richtung != "links":
        richtung = "rechts"

fenster.listen()
fenster.onkey(hoch, "Up")
fenster.onkey(runter, "Down")
fenster.onkey(links, "Left")
fenster.onkey(rechts, "Right")

# Spiel-Schleife (Lektion 5!)
def spiel_schritt():
    global punkte, richtung

    # Koerper folgt dem Kopf (von hinten nach vorne)
    for i in range(len(koerper) - 1, 0, -1):
        x = koerper[i - 1].xcor()
        y = koerper[i - 1].ycor()
        koerper[i].goto(x, y)
    if koerper:
        koerper[0].goto(kopf.xcor(), kopf.ycor())

    # Kopf bewegen
    if richtung == "hoch":
        kopf.sety(kopf.ycor() + 20)
    elif richtung == "runter":
        kopf.sety(kopf.ycor() - 20)
    elif richtung == "links":
        kopf.setx(kopf.xcor() - 20)
    elif richtung == "rechts":
        kopf.setx(kopf.xcor() + 20)

    # Futter gefressen? (if/else, Lektion 4!)
    if kopf.distance(futter) < 20:
        futter.goto(random.randint(-280, 280), random.randint(-280, 280))
        neu = turtle.Turtle()
        neu.shape("square")
        neu.color("#B8F0C4")
        neu.penup()
        koerper.append(neu)
        punkte = punkte + 10
        anzeige.clear()
        anzeige.write(f"Punkte: {punkte}", align="center",
                      font=("Arial", 16, "bold"))

    # Wand beruehrt? -> Game over
    if (abs(kopf.xcor()) > 290 or abs(kopf.ycor()) > 290):
        anzeige.clear()
        anzeige.write(f"GAME OVER - {punkte} Punkte", align="center",
                      font=("Arial", 16, "bold"))
        return   # Schleife stoppt

    # Sich selbst beruehrt? -> Game over
    for segment in koerper:
        if kopf.distance(segment) < 10:
            anzeige.clear()
            anzeige.write(f"GAME OVER - {punkte} Punkte", align="center",
                          font=("Arial", 16, "bold"))
            return

    fenster.update()
    fenster.ontimer(spiel_schritt, 120)   # naechster Schritt in 120 ms

spiel_schritt()
fenster.mainloop()`;

export default function Lektion11() {
  return (
    <LektionLayout
      kurs={pythonKurs}
      nr={11}
      lead="Das Abschlussprojekt: Python lokal installieren und ein komplettes Snake-Spiel mit dem turtle-Modul bauen, Schritt für Schritt erklärt."
      uebungen={3}
      mitLoesung={false}
      lokal
    >
      <LsAbschnitt id="finale" titel="Raus aus dem Browser">
        <p>
          Das große Finale: <strong>Snake</strong>, das Kult-Spiel. Dafür verlässt du zum ersten
          Mal den Browser, denn ein echtes Spiel mit Grafik und Tastatursteuerung braucht Python{" "}
          <strong>auf deinem eigenen Rechner</strong>. Genau so arbeitest du später auch im
          Betrieb, das gehört also sowieso ins Repertoire.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="installieren" titel="Schritt 1: Python installieren (einmalig, 5 Minuten)">
        <p>
          Lade Python von <strong>python.org/downloads</strong> herunter und starte den
          Installer. Wichtig bei Windows: Setz im ersten Fenster den Haken bei{" "}
          <strong>„Add python.exe to PATH“</strong>, sonst findet die Kommandozeile Python später
          nicht. Danach prüfst du die Installation: Eingabeaufforderung öffnen (Windows-Taste,
          „cmd“ tippen) und eingeben:
        </p>
        <CodeBlock
          code={`python --version
# Ausgabe z. B.: Python 3.12.4`}
        />
      </LsAbschnitt>

      <LsAbschnitt id="datei" titel="Schritt 2: Eine Code-Datei anlegen">
        <p>
          Erstelle einen Ordner, z. B. <code>snake</code>, und darin eine Datei{" "}
          <code>snake.py</code>. Am bequemsten geht das mit einem Editor wie VS Code (kostenlos),
          zur Not reicht sogar der Windows-Editor. Ausgeführt wird die Datei in der
          Eingabeaufforderung mit:
        </p>
        <CodeBlock
          code={`cd snake
python snake.py`}
        />
      </LsAbschnitt>

      <LsAbschnitt id="spiel" titel="Schritt 3: Das Spiel">
        <p>
          Wir nutzen das <code>turtle</code>-Modul, das bei Python schon dabei ist (nichts extra zu
          installieren). Kopiere den kompletten Code in deine <code>snake.py</code> und starte
          sie. Steuerung: Pfeiltasten.
        </p>

        <CodeBlock code={snakeCode} />

        <p>
          Schau dir den Code in Ruhe an: Da steckt <strong>alles</strong> aus dem Kurs drin. Die
          Segmentliste ist Lektion 7, die Steuerungsfunktionen sind Lektion 8, die
          Spiel-Schleife ist Lektion 5, die Kollisionsprüfungen sind Lektion 4, und{" "}
          <code>random</code> kennst du aus Lektion 6.
        </p>

        <LsHinweis titel="Falls etwas nicht läuft">
          <p>
            Lies die Fehlermeldung (Lektion 9!). Häufigste Ursachen: Tippfehler beim Abtippen
            (deshalb: kopieren), oder auf manchen Linux-Systemen fehlt turtle/tkinter (dann{" "}
            <code>sudo apt install python3-tk</code>).
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="uebungen" titel="Übungen">
        <p>Diese Übungen löst du direkt in deiner <code>snake.py</code>.</p>

        <Aufgabe nr="11.1">
          <p>
            Mach das Spiel schneller oder langsamer: Ändere den Wert <code>120</code> beim{" "}
            <code>ontimer</code>-Aufruf und finde deine Lieblingsgeschwindigkeit.
          </p>
        </Aufgabe>

        <Aufgabe nr="11.2">
          <p>
            Jedes gefressene Futter soll das Spiel um 2 ms schneller machen. Tipp: Mach aus der 120
            eine Variable <code>tempo</code> (mit <code>global tempo</code> in der Funktion) und
            verringere sie beim Fressen.
          </p>
        </Aufgabe>

        <Aufgabe nr="11.3" label="Übung 11.3 (Königsklasse)">
          <p>
            Bau einen Highscore ein, der auch nach Game Over stehen bleibt, oder lass die Schlange
            bei Wandberührung auf der gegenüberliegenden Seite wieder erscheinen statt zu sterben.
          </p>
        </Aufgabe>
      </LsAbschnitt>
    </LektionLayout>
  );
}
