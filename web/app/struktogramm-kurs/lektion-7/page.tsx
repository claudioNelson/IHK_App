import type { Metadata } from "next";
import Link from "next/link";
import { LsAbschnitt, LsHinweis } from "../../lernen/_components/LsBausteine";
import QuizFrage from "../../lernen/_components/QuizFrage";
import LektionLayout from "../../components/kurs/LektionLayout";
import { Aufgabe, CodeBlock, Loesung, Zeichenaufgabe } from "../../components/kurs/KursBausteine";
import PythonRunner from "../../python-kurs/_components/PythonRunner";
import Struktogramm, { TraceTabelle } from "../_components/Struktogramm";
import { anw, fuer, solange, wenn } from "../_components/struktogramm-typen";
import { struktogrammKurs } from "../_components/lektionen";

export const metadata: Metadata = {
  title: "Struktogramm Lektion 7: Pseudocode und Python",
  description:
    "Zusatzlektion: Struktogramme und Pseudocode in Python übersetzen, im Browser ausführen und so die eigene Logik prüfen. Mit Übersetzungstabelle, Indexverschiebung und Bubblesort.",
  alternates: { canonical: "https://lernarena.app/struktogramm-kurs/lektion-7" },
};

/* ---- Beispiele der Lektion ---- */

// Summe 1 bis n (Lektion 1)
const summe = [
  anw("Eingabe n"),
  anw("summe = 0"),
  fuer("für i = 1 bis n", [anw("summe = summe + i")]),
  anw("Ausgabe summe"),
];
const summePython = `n = 5            # in der Prüfung: Eingabe n
summe = 0
for i in range(1, n + 1):
    summe = summe + i
print(summe)`;

// Maximum mit Index (Lektion 5)
const maximum = [
  anw("max = zahlen[1]"),
  anw("pos = 1"),
  fuer("für i = 2 bis n", [wenn("zahlen[i] > max", [anw("max = zahlen[i]"), anw("pos = i")])]),
  anw("Ausgabe max, pos"),
];
const maximumPython = `zahlen = [4, 9, 2, 7]
n = len(zahlen)
maximum = zahlen[0]      # erstes Element hat Index 0
pos = 0
for i in range(1, n):    # zweites bis letztes Element
    if zahlen[i] > maximum:
        maximum = zahlen[i]
        pos = i
print(maximum, pos)      # 9 1
print(maximum, pos + 1)  # 9 2, wie im Struktogramm`;

// Rueckwaerts: Python-Snippet, das in ein Struktogramm uebersetzt wird
const halbierenPython = `n = 20
schritte = 0
while n > 1:
    n = n // 2
    schritte += 1
print(schritte)`;
const halbieren = [
  anw("n = 20"),
  anw("schritte = 0"),
  solange("n > 1", [anw("n = n DIV 2"), anw("schritte = schritte + 1")]),
  anw("Ausgabe schritte"),
];

/* ---- Aufgaben ---- */

const aufgabe71Start = `zahlen = [5, 2, 4, 1]
n = len(zahlen)
for durchlauf in range(1, n):
    # (1) Hier fehlt die innere Schleife über i.
    #     Struktogramm: für i = 1 bis n - durchlauf, in Python ab 0.
    # (2) Hier fehlt der Vergleich zahlen[i] > zahlen[i + 1].
    # (3) Hier fehlt der Tausch mit hilf.
    pass
print(zahlen)`;
const aufgabe71Loesung = `zahlen = [5, 2, 4, 1]
n = len(zahlen)
for durchlauf in range(1, n):
    for i in range(0, n - durchlauf):
        if zahlen[i] > zahlen[i + 1]:
            hilf = zahlen[i]
            zahlen[i] = zahlen[i + 1]
            zahlen[i + 1] = hilf
print(zahlen)`;

const aufgabe72Python = `guthaben = 50
preis = 12
anzahl = 0
while guthaben >= preis:
    guthaben = guthaben - preis
    anzahl = anzahl + 1
    if anzahl == 3:
        preis = 10
print(anzahl, guthaben)`;
const aufgabe72Loesung = [
  anw("guthaben = 50"),
  anw("preis = 12"),
  anw("anzahl = 0"),
  solange("guthaben >= preis", [
    anw("guthaben = guthaben - preis"),
    anw("anzahl = anzahl + 1"),
    wenn("anzahl == 3", [anw("preis = 10")]),
  ]),
  anw("Ausgabe anzahl, guthaben"),
];

export default function Lektion7() {
  return (
    <LektionLayout
      kurs={struktogrammKurs}
      nr={7}
      lead="Zusatzlektion: Für die Prüfung brauchst du kein Python. Aber wer ein Struktogramm in ein paar Zeilen Code übersetzt und laufen lässt, sieht sofort, ob die Logik stimmt. Das ist die schnellste Art, die eigenen Lösungen aus den Lektionen 1 bis 6 zu prüfen, und du lernst nebenbei, was die Kurzschreibweisen bedeuten."
      uebungen={6}
      aufgabenText="1 Programmieraufgabe, 1 Zeichenaufgabe, 4 Quizfragen"
    >
      <LsAbschnitt id="warum" titel="Warum übersetzen?">
        <p>
          Ein Struktogramm beschreibt einen Ablauf, ein Programm führt ihn aus. Die Bausteine sind
          dieselben: Sequenz, Verzweigung, Schleife, Feld (Array), Unterprogramm. Python schreibt sie nur
          in einer anderen Schreibweise, und weil Python fast ohne Klammern und Semikolons
          auskommt, liest sich der Code beinahe wie der Pseudocode aus Lektion 1. Der Vorteil für
          dich: Du kannst jedes Struktogramm, das du zeichnest, in wenige Zeilen übersetzen, im
          Browser ausführen und die Ausgabe mit deinem Schreibtischtest (Wertetabelle) vergleichen.
          Stimmt beides überein, stimmt die Logik.
        </p>
        <p>
          Du musst dafür nicht programmieren können. Die Übersetzungstabelle unten reicht für alles,
          was in diesem Kurs vorkommt. Wer mehr will, findet im{" "}
          <Link href="/python-kurs">Python-Kurs</Link> den ganzen Weg von der ersten Ausgabe bis zu
          Klassen und Objekten.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="tabelle" titel="Die Übersetzungstabelle">
        <p>
          Links die Schreibweise aus Struktogramm und Pseudocode, rechts das Gegenstück in Python.
          Drei Dinge fallen auf: Python schreibt Schlüsselwörter klein und englisch, Blöcke enden
          nicht mit „ENDE …“, sondern werden nur durch die Einrückung zusammengehalten, und jede
          Kopfzeile endet mit einem Doppelpunkt.
        </p>
        <div className="ls-table-wrap">
          <table className="ls-table sg-text-tabelle">
            <thead>
              <tr>
                <th scope="col">Struktogramm / Pseudocode</th>
                <th scope="col">Python</th>
                <th scope="col">Hinweis</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>WENN … DANN / SONST / ENDE WENN</td>
                <td>
                  <code>if …:</code> / <code>elif …:</code> / <code>else:</code>
                </td>
                <td>Kein ENDE, der Block endet, wo die Einrückung endet. Eine Verzweigungskette wird zu if, elif, else.</td>
              </tr>
              <tr>
                <td>SOLANGE … / ENDE SOLANGE</td>
                <td>
                  <code>while …:</code>
                </td>
                <td>Kopfgesteuert, genau wie im Struktogramm.</td>
              </tr>
              <tr>
                <td>FÜR i = 1 BIS n</td>
                <td>
                  <code>for i in range(1, n + 1):</code>
                </td>
                <td>
                  <code>range(a, b)</code> zählt von a bis b − 1. Für „bis n“ musst du n + 1 schreiben.
                </td>
              </tr>
              <tr>
                <td>WIEDERHOLE … BIS bedingung</td>
                <td>
                  <code>while True:</code> mit <code>if bedingung: break</code> am Ende
                </td>
                <td>
                  Python hat keine fußgesteuerte Schleife. Alternative: Bedingung umkehren und als{" "}
                  <code>while</code> schreiben, mit einer ersten Eingabe vor der Schleife.
                </td>
              </tr>
              <tr>
                <td>FALLS x / FALL 1: / SONST</td>
                <td>
                  <code>if x == 1:</code> / <code>elif x == 2:</code> / <code>else:</code>
                </td>
                <td>Die Mehrfachauswahl wird zur Verzweigungskette.</td>
              </tr>
              <tr>
                <td>DIV</td>
                <td>
                  <code>//</code>
                </td>
                <td>Ganzzahlige Division. Das einfache <code>/</code> liefert Nachkommastellen.</td>
              </tr>
              <tr>
                <td>MOD</td>
                <td>
                  <code>%</code>
                </td>
                <td>Rest der Division.</td>
              </tr>
              <tr>
                <td>UND / ODER / NICHT</td>
                <td>
                  <code>and</code> / <code>or</code> / <code>not</code>
                </td>
                <td>Klein geschrieben, sonst gleich.</td>
              </tr>
              <tr>
                <td>Feld zahlen[i], erstes Element Index 1</td>
                <td>
                  Liste <code>zahlen[i]</code>, erstes Element Index 0
                </td>
                <td>
                  Anzahl mit <code>len(zahlen)</code>. Letztes Element ist <code>zahlen[n - 1]</code>.
                </td>
              </tr>
              <tr>
                <td>FUNKTION name(a, b): Typ / RÜCKGABE x</td>
                <td>
                  <code>def name(a, b):</code> / <code>return x</code>
                </td>
                <td>Ohne Datentypen. Eine Prozedur ist ein def ohne return.</td>
              </tr>
              <tr>
                <td>EINGABE n</td>
                <td>
                  <code>n = int(input())</code>
                </td>
                <td>
                  <code>input()</code> liefert Text; <code>int()</code> macht eine Ganzzahl daraus,{" "}
                  <code>float()</code> eine Kommazahl. Im Browser öffnet sich dafür ein kleines Fenster.
                </td>
              </tr>
              <tr>
                <td>AUSGABE x, y</td>
                <td>
                  <code>print(x, y)</code>
                </td>
                <td>Mehrere Werte mit Komma, getrennt durch ein Leerzeichen.</td>
              </tr>
              <tr>
                <td>Zuweisung =, Vergleich ==, !=</td>
                <td>
                  <code>=</code>, <code>==</code>, <code>!=</code>
                </td>
                <td>Identisch mit der Konvention dieses Kurses.</td>
              </tr>
            </tbody>
          </table>
        </div>
        <LsHinweis titel="Einrückung ist in Python keine Kosmetik" art="warnung">
          <p>
            Im Pseudocode zeigt die Einrückung nur, was zusammengehört; in Python <em>ist</em> sie
            die Struktur. Was um vier Leerzeichen eingerückt unter <code>for</code> steht, gehört
            in den Rumpf; die erste Zeile, die wieder ganz links beginnt, steht nach der Schleife.
            Das ist derselbe Unterschied wie „Ausgabe im Rumpf“ gegen „Ausgabe nach der Schleife“
            aus Lektion 5, nur dass Python ihn beim Ausführen sofort sichtbar macht.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="summe" titel="Beispiel 1: Summe von 1 bis n">
        <p>
          Das erste Struktogramm aus Lektion 1, daneben die Übersetzung. Zeile für Zeile: Die
          Eingabe ersetzt du durch einen festen Wert, damit der Code ohne Fenster läuft; die
          Zählschleife „für i = 1 bis n“ wird zu <code>range(1, n + 1)</code>, weil die Obergrenze
          bei <code>range</code> nicht dazugehört.
        </p>
        <div className="sg-paar">
          <div>
            <h4>Struktogramm</h4>
            <Struktogramm titel="Summe von 1 bis n" bloecke={summe} />
          </div>
          <div>
            <h4>Python</h4>
            <CodeBlock code={summePython} />
          </div>
        </div>
        <p>
          Führe den Code aus. Für n = 5 muss 15 erscheinen, genau wie im Schreibtischtest aus
          Leseaufgabe 1.1. Ändere dann n auf 3 (Ausgabe 6) oder auf 0 (Ausgabe 0, die Schleife
          läuft nicht) und vergleiche mit dem, was du in Lektion 1 gelernt hast. Wer statt{" "}
          <code>n + 1</code> nur <code>n</code> schreibt, bekommt 10 statt 15: ein Durchlauf zu
          wenig, der klassische Off-by-one-Fehler.
        </p>
        <PythonRunner rows={6} dateiname="summe.py" label="Python-Code: Summe von 1 bis n" initialCode={summePython} />
      </LsAbschnitt>

      <LsAbschnitt id="maximum" titel="Beispiel 2: Maximum mit Index">
        <p>
          Beim Feld wird es interessant, denn hier verschiebt sich der Index. Im Kurs hat das erste
          Element den Index 1, in Python den Index 0. Das Struktogramm aus Lektion 5 startet mit{" "}
          <code>zahlen[1]</code> und läuft von 2 bis n; die Übersetzung startet mit{" "}
          <code>zahlen[0]</code> und läuft von 1 bis n − 1, also <code>range(1, n)</code>. Jede
          Grenze rutscht um eins nach unten, die Anzahl der Durchläufe bleibt gleich.
        </p>
        <div className="sg-paar">
          <div>
            <h4>Struktogramm (Index ab 1)</h4>
            <Struktogramm titel="Maximum mit Index" bloecke={maximum} />
          </div>
          <div>
            <h4>Python (Index ab 0)</h4>
            <CodeBlock code={maximumPython} />
          </div>
        </div>
        <p>
          Die Variable heißt im Code <code>maximum</code> statt <code>max</code>, weil{" "}
          <code>max</code> in Python eine eingebaute Funktion ist, die man nicht überschreiben
          sollte. Für <code>[4, 9, 2, 7]</code> gibt die erste Ausgabe „9 1“ aus: der Wert 9 an
          Python-Index 1. Das Struktogramm in Lektion 5 sagt „9, 2“. Beides meint dasselbe Element,
          das zweite. Beachte auch das Format: <code>print</code> trennt mehrere Werte durch ein
          Leerzeichen, im Struktogramm und im Pseudocode schreibt der Kurs sie mit Komma. Wenn eine Aufgabe die Position ab 1 verlangt, gibst du <code>pos + 1</code>{" "}
          aus, wie in der zweiten Zeile.
        </p>
        <TraceTabelle
          spalten={["Element", "Struktogramm i", "Python i", "zahlen[i]"]}
          zeilen={[
            ["erstes", 1, 0, 4],
            ["zweites", 2, 1, 9],
            ["drittes", 3, 2, 2],
            ["viertes", 4, 3, 7],
          ]}
          caption="Die Indexverschiebung: dasselbe Element, um eins verschobener Index. Schleife im Struktogramm 2 bis n, in Python range(1, n)."
        />
        <PythonRunner rows={10} dateiname="maximum.py" label="Python-Code: Maximum mit Index" initialCode={maximumPython} />
        <p>
          Probiere das Feld <code>[3, 8, 5, 8, 1]</code> aus Leseaufgabe 5.1: Die erste Zeile muss
          „8 1“ zeigen (die zweite „8 2“), also die erste 8. Und ersetze <code>&gt;</code> durch{" "}
          <code>&gt;=</code>: Dann wird die letzte 8 gemerkt, mit <code>&gt;=</code> „8 3“ bzw. „8 4“.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="rueckwaerts" titel="Umgekehrt: aus Python ein Struktogramm">
        <p>
          In der Prüfung kommt gelegentlich ein kurzer Codeausschnitt vor, zu dem ein Struktogramm
          oder ein Schreibtischtest verlangt wird. Der Weg ist derselbe wie eben, nur rückwärts:
          Jede Kopfzeile mit Doppelpunkt wird zu einem Baustein, die eingerückten Zeilen darunter
          zu seinem Rumpf oder Zweig. Beispiel:
        </p>
        <CodeBlock code={halbierenPython} />
        <p>
          Zwei Kurzschreibweisen musst du kennen: <code>n // 2</code> ist die ganzzahlige Division,
          also DIV, und <code>schritte += 1</code> ist die Abkürzung für{" "}
          <code>schritte = schritte + 1</code>. Der Rest ist die kopfgesteuerte Schleife aus
          Lektion 3:
        </p>
        <Struktogramm
          titel="Halbieren zählen"
          bloecke={halbieren}
          breite={380}
          caption="Das Struktogramm zum Python-Code. Ausgabe für n = 20: die Folge 20, 10, 5, 2, 1 braucht 4 Halbierungen, also 4. Mit dem einfachen / wären es 5 (Leseaufgabe 3.1)."
        />
        <LsHinweis titel="Was du beim Übersetzen mitnimmst" icon="buch" label="Prüfungsbezug">
          <p>
            Die Prüfung verlangt kein Python, und du solltest im Struktogramm bei der deutschen
            Schreibweise bleiben (Eingabe, Ausgabe, DIV, MOD). Was dir das Übersetzen bringt, ist
            das Gefühl dafür, wo Blöcke enden, wie Zählschleifen wirklich zählen und dass der
            Index eines Feldes je nach Aufgabe bei 0 oder bei 1 beginnt. Genau diese drei Dinge
            kosten in Struktogramm-Aufgaben typischerweise die meisten Punkte.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="uebungen" titel="Übungen">
        <Aufgabe nr="7.1" label="Programmieraufgabe 7.1">
          <p>
            Vervollständigen Sie das Programm: Der Bubblesort aus Lektion 6 soll das Feld{" "}
            <code>[5, 2, 4, 1]</code> aufsteigend sortieren. Die äußere Schleife ist schon
            übersetzt. Ergänze an den Stellen (1), (2) und (3) die innere Schleife, den Vergleich
            und den Tausch, und ersetze dabei das <code>pass</code>. Denk an die Indexverschiebung:
            Die innere Schleife läuft im Struktogramm „für i = 1 bis n − durchlauf“, in Python also
            von 0 bis n − durchlauf − 1. Erwartete Ausgabe: <code>[1, 2, 4, 5]</code>.
          </p>
          <PythonRunner rows={10} dateiname="bubblesort.py" label="Python-Code: Übung 7.1" initialCode={aufgabe71Start} />
          <Loesung code={aufgabe71Loesung}>
            <p>
              <code>range(0, n - durchlauf)</code> liefert die Werte 0 bis n − durchlauf − 1, im
              ersten Durchlauf bei n = 4 also 0, 1, 2: drei Vergleiche, genau wie in der Tabelle
              aus Lektion 6. Wer <code>range(0, n - durchlauf + 1)</code> schreibt, greift mit{" "}
              <code>zahlen[i + 1]</code> hinter das Feldende und bekommt einen Fehler „list index
              out of range“. Das ist derselbe Fehler, den in Lektion 6 die Grenze n statt n − 1
              verursacht hätte, nur dass Python ihn sofort meldet.
            </p>
          </Loesung>
        </Aufgabe>

        <Zeichenaufgabe
          nr="7.2"
          toolHinweis={false}
          loesung={<Struktogramm titel="Kaufen bis das Guthaben nicht mehr reicht" bloecke={aufgabe72Loesung} breite={400} />}
          erklaerung={
            <>
              <p>
                <code>while</code> wird zur kopfgesteuerten Schleife, <code>if</code> ohne{" "}
                <code>else</code> zur einseitigen Verzweigung im Rumpf, <code>print</code> zur
                Ausgabe nach der Schleife. Der Schreibtischtest:
              </p>
              <TraceTabelle
                spalten={["Prüfung guthaben >= preis", "guthaben", "anzahl", "preis"]}
                zeilen={[
                  ["Start", 50, 0, 12],
                  ["50 >= 12: ja", 38, 1, 12],
                  ["38 >= 12: ja", 26, 2, 12],
                  ["26 >= 12: ja; anzahl == 3: ja", 14, 3, 10],
                  ["14 >= 10: ja", 4, 4, 10],
                  ["4 >= 10: nein, Ende", 4, 4, 10],
                ]}
              />
              <p>
                Ausgabe: <strong>4 4</strong>, denn <code>print</code> trennt die beiden Werte
                durch ein Leerzeichen; im Struktogramm steht „Ausgabe anzahl, guthaben“, also „4, 4“.
                Beachte, dass sich ab dem dritten Kauf die Bedingung
                der Schleife ändert, weil der Preis sinkt; der vierte Kauf ist nur deshalb möglich.
              </p>
            </>
          }
          bewertung={[
            "Drei Initialisierungen vor der Schleife",
            "Kopfgesteuerte Schleife mit Bedingung guthaben >= preis",
            "Beide Zuweisungen im Rumpf, Verzweigung mit anzahl == 3 ebenfalls im Rumpf, einseitig",
            "Ausgabe beider Werte nach der Schleife",
            "Schreibtischtest mit Ausgabe 4 4 (Python) bzw. 4, 4 (Struktogramm); gleichwertig: Spalte für die Verzweigungsprüfung statt Notiz in der Prüfungsspalte",
          ]}
        >
          <p>
            Zeichnen Sie das Struktogramm zu folgendem Programm und ermitteln Sie mit einem
            Schreibtischtest die Ausgabe. Achte darauf, welche Zeilen im Rumpf der Schleife stehen
            und welche im Zweig der Verzweigung.
          </p>
          <CodeBlock code={aufgabe72Python} />
        </Zeichenaufgabe>
      </LsAbschnitt>

      <LsAbschnitt id="quiz" titel="Jetzt selbst testen">
        <p style={{ marginBottom: 18 }}>Vier Fragen zur Übersetzung.</p>
        <QuizFrage
          nr={1}
          von={4}
          frage="Welche Zählschleife entspricht „FÜR i = 3 BIS 8“ in Python?"
          optionen={[
            { text: "for i in range(3, 9):", richtig: true },
            { text: "for i in range(3, 8):", richtig: false },
            { text: "for i in range(2, 8):", richtig: false },
            { text: "for i in range(8):", richtig: false },
          ]}
          erklaerung="range(a, b) läuft von a bis b − 1. Für die Werte 3, 4, 5, 6, 7, 8 (sechs Durchläufe) muss die Obergrenze 9 lauten. range(3, 8) hört bei 7 auf, ein Durchlauf zu wenig."
        />
        <QuizFrage
          nr={2}
          von={4}
          frage="Ein Struktogramm mit Indexbasis 1 gibt für ein Feld die Position pos = 4 des Maximums aus. Welchen Index hat dasselbe Element in der Python-Liste?"
          optionen={[
            { text: "3", richtig: true },
            { text: "4", richtig: false },
            { text: "5", richtig: false },
            { text: "Das hängt vom Wert des Elements ab", richtig: false },
          ]}
          erklaerung="Python zählt ab 0, der Kurs ab 1. Das vierte Element hat im Struktogramm den Index 4 und in Python den Index 3. Wer die Position wie im Struktogramm ausgeben will, gibt pos + 1 aus."
        />
        <QuizFrage
          nr={3}
          von={4}
          frage="Was geben print(17 // 5) und print(17 % 5) in Python aus?"
          optionen={[
            { text: "3 und 2", richtig: true },
            { text: "3,4 und 2", richtig: false },
            { text: "2 und 3", richtig: false },
            { text: "3 und 0", richtig: false },
          ]}
          erklaerung="// ist die ganzzahlige Division (DIV): 5 passt dreimal in 17. % liefert den Rest (MOD): 17 − 15 = 2. Nachkommastellen gäbe nur das einfache /, also 17 / 5 = 3.4."
        />
        <QuizFrage
          nr={4}
          von={4}
          frage="Wie wird „WIEDERHOLE … BIS eingabe > 0“ in Python übersetzt?"
          optionen={[
            { text: "while True: mit dem Rumpf und am Ende if eingabe > 0: break", richtig: true },
            { text: "repeat: mit dem Rumpf und until eingabe > 0", richtig: false },
            { text: "while eingabe > 0: mit dem Rumpf", richtig: false },
            { text: "for eingabe in range(1): mit dem Rumpf", richtig: false },
          ]}
          erklaerung="Python hat keine fußgesteuerte Schleife. while True: läuft den Rumpf mindestens einmal, und break verlässt die Schleife, sobald die Abbruchbedingung am Ende des Rumpfs wahr ist. while eingabe > 0: prüft vor dem ersten Durchlauf und ist die kopfgesteuerte Schleife mit umgekehrter Logik; repeat/until gibt es in Python nicht."
        />
      </LsAbschnitt>
    </LektionLayout>
  );
}
