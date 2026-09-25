import type { Metadata } from "next";
import { LsAbschnitt, LsHinweis } from "../../lernen/_components/LsBausteine";
import QuizFrage from "../../lernen/_components/QuizFrage";
import LektionLayout from "../../components/kurs/LektionLayout";
import { Aufgabe, CodeBlock, Loesung, Zeichenaufgabe } from "../../components/kurs/KursBausteine";
import Struktogramm, { TraceTabelle } from "../_components/Struktogramm";
import { anw, aufruf, fuer, luecke, wenn } from "../_components/struktogramm-typen";
import { struktogrammKurs } from "../_components/lektionen";

export const metadata: Metadata = {
  title: "Struktogramm Lektion 6: Tauschen, Sortieren, Unterprogramme",
  description:
    "Zwei Werte mit Hilfsvariable tauschen, Bubblesort mit Schreibtischtest je Durchlauf, dazu Funktionen und Prozeduren mit Parametern, Rückgabe und Aufruf im Struktogramm.",
  alternates: { canonical: "https://lernarena.app/struktogramm-kurs/lektion-6" },
};

/* ---- Beispiele der Lektion ---- */

// Tauschen: falsch und richtig
const tauschFalsch = [anw("a = b"), anw("b = a")];
const tauschRichtig = [anw("hilf = a"), anw("a = b"), anw("b = hilf")];
const tauschCode = `hilf = a
a = b
b = hilf`;

// Bubblesort
const bubblesort = [
  fuer("für durchlauf = 1 bis n - 1", [
    fuer("für i = 1 bis n - durchlauf", [
      wenn("zahlen[i] > zahlen[i + 1]", [anw("hilf = zahlen[i]"), anw("zahlen[i] = zahlen[i + 1]"), anw("zahlen[i + 1] = hilf")]),
    ]),
  ]),
];
const bubblesortCode = `FÜR durchlauf = 1 BIS n - 1
    FÜR i = 1 BIS n - durchlauf
        WENN zahlen[i] > zahlen[i + 1] DANN
            hilf = zahlen[i]
            zahlen[i] = zahlen[i + 1]
            zahlen[i + 1] = hilf
        ENDE WENN
    ENDE FÜR
ENDE FÜR`;

// Funktion istGerade
const istGerade = [wenn("zahl MOD 2 == 0", [anw("Rückgabe wahr")], [anw("Rückgabe falsch")])];
const istGeradeCode = `FUNKTION istGerade(zahl: Ganzzahl): Wahrheitswert
    WENN zahl MOD 2 == 0 DANN
        RÜCKGABE wahr
    SONST
        RÜCKGABE falsch
    ENDE WENN
ENDE FUNKTION`;

// Funktion summe
const summeFunktion = [
  anw("ergebnis = 0"),
  fuer("für i = 1 bis n", [anw("ergebnis = ergebnis + zahlen[i]")]),
  anw("Rückgabe ergebnis"),
];
const summeFunktionCode = `FUNKTION summe(zahlen: Feld, n: Ganzzahl): Ganzzahl
    ergebnis = 0
    FÜR i = 1 BIS n
        ergebnis = ergebnis + zahlen[i]
    ENDE FÜR
    RÜCKGABE ergebnis
ENDE FUNKTION`;

// Prozedur ausgabeFeld
const ausgabeFeld = [fuer("für i = 1 bis n", [anw("Ausgabe zahlen[i]")])];
const ausgabeFeldCode = `PROZEDUR ausgabeFeld(zahlen: Feld, n: Ganzzahl)
    FÜR i = 1 BIS n
        AUSGABE zahlen[i]
    ENDE FÜR
ENDE PROZEDUR`;

// Hauptprogramm mit Aufrufen
const hauptprogramm = [
  aufruf("ausgabeFeld(zahlen, n)"),
  anw("gesamt = summe(zahlen, n)"),
  anw("Ausgabe gesamt"),
  wenn("istGerade(gesamt)", [anw('Ausgabe "Summe ist gerade"')], [anw('Ausgabe "Summe ist ungerade"')]),
];
const hauptprogrammCode = `ausgabeFeld(zahlen, n)
gesamt = summe(zahlen, n)
AUSGABE gesamt
WENN istGerade(gesamt) DANN
    AUSGABE "Summe ist gerade"
SONST
    AUSGABE "Summe ist ungerade"
ENDE WENN`;

/* ---- Aufgaben ---- */

// 6.2: Bubblesort mit Luecken
const aufgabe62 = [
  fuer("für durchlauf = 1 bis n - 1", [
    fuer("(1)", [wenn("(2)", [anw("hilf = zahlen[i]"), anw("zahlen[i] = zahlen[i + 1]"), anw("zahlen[i + 1] = hilf")])]),
  ]),
];

/* ---- Musterloesungen der Zeichenaufgaben ---- */

const anzahlGroesser = [
  anw("anzahl = 0"),
  fuer("für i = 1 bis n", [wenn("zahlen[i] > grenze", [anw("anzahl = anzahl + 1")])]),
  anw("Rückgabe anzahl"),
];
const anzahlGroesserHaupt = [
  anw("Eingabe grenze"),
  anw("ergebnis = anzahlGroesser(zahlen, n, grenze)"),
  anw('Ausgabe "Anzahl über der Grenze:", ergebnis'),
];

const istPrimzahl = [
  wenn(
    "zahl < 2",
    [anw("istPrim = falsch")],
    [anw("istPrim = wahr"), fuer("für i = 2 bis zahl - 1", [wenn("zahl MOD i == 0", [anw("istPrim = falsch")])])],
  ),
  anw("Rückgabe istPrim"),
];

export default function Lektion6() {
  return (
    <LektionLayout
      kurs={struktogrammKurs}
      nr={6}
      lead="Drei Dinge, die in Prüfungsaufgaben zu Feldern oft zusammen auftreten: zwei Werte tauschen, ein Feld mit Bubblesort sortieren und Abläufe in Unterprogramme auslagern. Mit dieser Lektion hast du alle Bausteine beisammen, die ein Struktogramm in der AP1 und AP2 typischerweise braucht."
      uebungen={8}
      aufgabenText="1 Leseaufgabe, 1 Ergänzungsaufgabe, 2 Zeichenaufgaben, 4 Quizfragen"
    >
      <LsAbschnitt id="tauschen" titel="Zwei Werte tauschen">
        <p>
          In <code>a</code> steht 5, in <code>b</code> steht 8, und danach soll es umgekehrt sein.
          Der naheliegende Versuch <code>a = b</code>, dann <code>b = a</code> geht schief. Erinnere
          dich an Lektion 2: Eine Zuweisung überschreibt den alten Wert der Variablen links, und
          der ist danach weg.
        </p>
        <div className="sg-paar">
          <div>
            <h4>Falsch: der alte Wert geht verloren</h4>
            <Struktogramm titel="Tauschversuch" bloecke={tauschFalsch} />
          </div>
          <div>
            <h4>Richtig: mit Hilfsvariable</h4>
            <Struktogramm titel="Tauschen" bloecke={tauschRichtig} />
          </div>
        </div>
        <TraceTabelle
          spalten={["Anweisung", "a", "b", "hilf"]}
          zeilen={[
            ["Start", 5, 8, ""],
            ["hilf = a", 5, 8, 5],
            ["a = b", 8, 8, 5],
            ["b = hilf", 8, 5, 5],
          ]}
          caption="Der Tausch mit Hilfsvariable im Schreibtischtest (Wertetabelle). Nach a = b steht die 8 zweimal da; die 5 ist nur noch in hilf und wird von dort zurückgeholt."
        />
        <p>
          Ohne <code>hilf</code> stünde nach <code>a = b</code> in beiden Variablen die 8, und{" "}
          <code>b = a</code> wäre wirkungslos. Der Tausch ist also immer ein Dreischritt:
        </p>
        <CodeBlock code={tauschCode} />
        <p>
          Die Hilfsvariable heißt in Lösungshinweisen oft <code>hilf</code>, <code>temp</code> oder{" "}
          <code>tausch</code>; der Name ist egal, die drei Zeilen nicht. Bei einem Feld (Array) tauschst du
          genauso, nur mit indizierten Elementen: <code>hilf = zahlen[i]</code>,{" "}
          <code>zahlen[i] = zahlen[i + 1]</code>, <code>zahlen[i + 1] = hilf</code>. Genau das
          braucht das Sortieren.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="bubblesort" titel="Bubblesort">
        <p>
          <strong>Bubblesort</strong> sortiert ein Feld aufsteigend nach einer einfachen Idee: Gehe
          das Feld von vorn nach hinten durch und vergleiche jedes Element mit seinem rechten
          Nachbarn. Steht links der größere Wert, tausche die beiden. Nach einem solchen Durchlauf
          ist das größte Element ganz hinten angekommen; es ist wie eine Luftblase nach oben
          gestiegen, daher der Name. Dann beginnt der nächste Durchlauf, der nur noch bis vor das
          bereits einsortierte Ende gehen muss.
        </p>
        <div className="sg-paar">
          <div>
            <h4>Struktogramm</h4>
            <Struktogramm titel="Bubblesort" bloecke={bubblesort} />
          </div>
          <div>
            <h4>Pseudocode</h4>
            <CodeBlock code={bubblesortCode} />
          </div>
        </div>
        <p>
          Zwei Zählschleifen ineinander. Die äußere zählt die <strong>Durchläufe</strong>: Bei n
          Elementen reichen n − 1, weil nach jedem Durchlauf ein weiteres Element hinten sicher
          steht und das letzte übrig bleibende von selbst richtig liegt. Die innere Schleife
          vergleicht die <strong>Nachbarpaare</strong> und läuft nur bis n − durchlauf, weil dahinter
          schon sortiert ist. Der Vergleich <code>zahlen[i] &gt; zahlen[i + 1]</code> greift bis auf{" "}
          <code>zahlen[n - durchlauf + 1]</code> zu, im ersten Durchlauf also bis zum letzten
          Element; das ist der Grund, warum die innere Grenze eins kleiner sein muss als die Anzahl
          der noch unsortierten Elemente.
        </p>
        <p>
          Der Schreibtischtest für <code>zahlen = [5, 2, 4, 1]</code> mit n = 4, das erste Element
          hat den Index 1. Die Spalte „Feld danach“ zeigt den Zustand nach dem jeweiligen Vergleich:
        </p>
        <div className="ls-table-wrap">
          <table className="ls-table sg-text-tabelle">
            <thead>
              <tr>
                <th scope="col">durchlauf</th>
                <th scope="col">i</th>
                <th scope="col">Vergleich</th>
                <th scope="col">Tausch?</th>
                <th scope="col">Feld danach</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>1</td>
                <td>1</td>
                <td>5 &gt; 2</td>
                <td>ja</td>
                <td>
                  <code>[2, 5, 4, 1]</code>
                </td>
              </tr>
              <tr>
                <td>1</td>
                <td>2</td>
                <td>5 &gt; 4</td>
                <td>ja</td>
                <td>
                  <code>[2, 4, 5, 1]</code>
                </td>
              </tr>
              <tr>
                <td>1</td>
                <td>3</td>
                <td>5 &gt; 1</td>
                <td>ja</td>
                <td>
                  <code>[2, 4, 1, 5]</code>
                </td>
              </tr>
              <tr>
                <td>2</td>
                <td>1</td>
                <td>2 &gt; 4</td>
                <td>nein</td>
                <td>
                  <code>[2, 4, 1, 5]</code>
                </td>
              </tr>
              <tr>
                <td>2</td>
                <td>2</td>
                <td>4 &gt; 1</td>
                <td>ja</td>
                <td>
                  <code>[2, 1, 4, 5]</code>
                </td>
              </tr>
              <tr>
                <td>3</td>
                <td>1</td>
                <td>2 &gt; 1</td>
                <td>ja</td>
                <td>
                  <code>[1, 2, 4, 5]</code>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <p>
          Nach Durchlauf 1 steht die 5 hinten, nach Durchlauf 2 die 4 an vorletzter Stelle, nach
          Durchlauf 3 ist das Feld sortiert. Die innere Schleife hat 3, 2 und 1 Durchläufe, zusammen
          6 Vergleiche; allgemein sind es n · (n − 1) / 2. Das musst du nicht herleiten können, aber
          es erklärt, warum Bubblesort bei großen Feldern langsam ist und in Lehrbüchern und Aufgaben
          trotzdem verbreitet ist: Er ist kurz und lässt sich gut nachvollziehen.
        </p>
        <LsHinweis titel="Was Prüfungsaufgaben zum Sortieren fragen" icon="buch" label="Prüfungsbezug">
          <p>
            Typisch sind Lücken bei der Tauschbedingung oder der Schleifengrenze in einem
            gegebenen Sortier-Struktogramm, oder ein Schreibtischtest, der den Zustand des Feldes
            nach dem ersten Durchlauf oder nach k Durchläufen abfragt. Übe deshalb vor allem, einen einzelnen Durchlauf sauber
            durchzuspielen: Paar für Paar, mit dem Feldzustand nach jedem Tausch. Absteigend
            sortieren heißt nur, den Vergleich zu drehen (<code>&lt;</code> statt <code>&gt;</code>).
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="unterprogramme" titel="Unterprogramme: Funktion und Prozedur">
        <p>
          Die Grundmuster aus Lektion 5 tauchen in größeren Aufgaben mehrfach auf. Statt sie jedes
          Mal neu hinzuschreiben, lagerst du sie in ein <strong>Unterprogramm</strong> aus: ein
          eigenes Struktogramm mit Namen, das vom Hauptprogramm aufgerufen wird. Zwei Arten gibt es:
        </p>
        <ul>
          <li>
            Eine <strong>Funktion</strong> liefert ein Ergebnis zurück. Die letzte Anweisung ist
            typischerweise <code>Rückgabe …</code>, und der Aufruf steht dort, wo man den Wert
            braucht: in einer Zuweisung oder in einer Bedingung.
          </li>
          <li>
            Eine <strong>Prozedur</strong> tut etwas (gibt aus, verändert ein Feld), liefert aber
            nichts zurück. Sie wird als eigene Anweisung aufgerufen.
          </li>
        </ul>
        <p>
          Der Titel des Struktogramms ist die <strong>Signatur</strong>: Name, in Klammern die{" "}
          <strong>Parameter</strong> mit Datentyp, und bei Funktionen nach dem Doppelpunkt der
          Rückgabetyp. Parameter sind die Werte, die der Aufrufer hineingibt; im Unterprogramm
          benutzt du sie wie Variablen.
        </p>
        <div className="sg-paar">
          <div>
            <h4>Struktogramm</h4>
            <Struktogramm titel="istGerade(zahl: Ganzzahl): Wahrheitswert" bloecke={istGerade} />
          </div>
          <div>
            <h4>Pseudocode</h4>
            <CodeBlock code={istGeradeCode} />
          </div>
        </div>
        <p>
          <code>istGerade(7)</code> liefert falsch, <code>istGerade(10)</code> wahr. Kürzer wäre eine
          einzige Anweisung <code>Rückgabe zahl MOD 2 == 0</code>; beides ist richtig. Die Summe aus
          Lektion 5 als Funktion mit zwei Parametern:
        </p>
        <div className="sg-paar">
          <div>
            <h4>Struktogramm</h4>
            <Struktogramm titel="summe(zahlen: Feld, n: Ganzzahl): Ganzzahl" bloecke={summeFunktion} />
          </div>
          <div>
            <h4>Pseudocode</h4>
            <CodeBlock code={summeFunktionCode} />
          </div>
        </div>
        <p>
          Beachte den Namen <code>ergebnis</code> für den Akkumulator: Die Variable darf nicht so
          heißen wie die Funktion selbst, sonst wird es beim Lesen unklar. Und eine Prozedur, die ein
          Feld ausgibt:
        </p>
        <div className="sg-paar">
          <div>
            <h4>Struktogramm</h4>
            <Struktogramm titel="ausgabeFeld(zahlen: Feld, n: Ganzzahl)" bloecke={ausgabeFeld} />
          </div>
          <div>
            <h4>Pseudocode</h4>
            <CodeBlock code={ausgabeFeldCode} />
          </div>
        </div>
        <h4>Der Aufruf im Hauptprogramm</h4>
        <p>
          Für den Aufruf einer Prozedur ist ein eigener Kasten mit doppelten Seitenlinien
          üblich. Das Ergebnis einer Funktion wird dagegen meist in einer normalen
          Anweisung verwendet, also zugewiesen oder direkt in einer Bedingung geprüft:
        </p>
        <div className="sg-paar">
          <div>
            <h4>Struktogramm</h4>
            <Struktogramm titel="Hauptprogramm" bloecke={hauptprogramm} />
          </div>
          <div>
            <h4>Pseudocode</h4>
            <CodeBlock code={hauptprogrammCode} />
          </div>
        </div>
        <p>
          Beim Aufruf stehen die <strong>Argumente</strong> in derselben Reihenfolge wie die
          Parameter in der Signatur: <code>summe(zahlen, n)</code> übergibt das Feld an{" "}
          <code>zahlen</code> und die Anzahl an <code>n</code>. Für <code>zahlen = [4, 9, 2, 7]</code>{" "}
          gibt das Hauptprogramm 4, 9, 2, 7 aus, dann 22, dann „Summe ist gerade“. Ob du den
          Funktionsaufruf mit Zuweisung als normale Anweisung oder ebenfalls im Aufrufkasten
          zeichnest, ist in vielen Lösungshinweisen gleichwertig; wichtig ist, dass der Rückgabewert
          irgendwo landet und nicht verloren geht. Wird ein Feld übergeben, bekommt das
          Unterprogramm das Feld selbst, keine Kopie: Änderungen an den Elementen, etwa durch ein
          Sortieren, wirken nach außen und sind nach dem Aufruf im Hauptprogramm sichtbar.
        </p>
        <LsHinweis titel="Unterprogramme in der AP2" icon="buch" label="Prüfungsbezug">
          <p>
            In der AP2 für Anwendungsentwickler sind Unterprogramme meist <strong>Methoden</strong>{" "}
            einer Klasse aus einem Klassendiagramm: Die Signatur aus dem Diagramm, etwa{" "}
            <code>berechneGesamt(): Kommazahl</code>, wird als Struktogramm oder Pseudocode
            ausformuliert, und Attribute der Klasse stehen darin wie Variablen zur Verfügung. Die
            Regeln aus dieser Lektion gelten dort unverändert. Wie du Signaturen im
            Klassendiagramm liest, zeigt der UML-Kurs.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="uebungen" titel="Übungen">
        <Aufgabe nr="6.1" label="Leseaufgabe 6.1">
          <p>
            Führen Sie einen Schreibtischtest durch: Das Feld <code>zahlen = [7, 3, 9, 1]</code> wird
            mit dem Bubblesort aus dieser Lektion aufsteigend sortiert; das erste Element hat den
            Index 1, n = 4. Geben Sie den Zustand des Feldes nach dem ersten und nach dem zweiten
            Durchlauf der äußeren Schleife an. Notiere jeden Vergleich einzeln.
          </p>
          <Loesung>
            <div className="ls-table-wrap">
              <table className="ls-table sg-text-tabelle">
                <thead>
                  <tr>
                    <th scope="col">durchlauf</th>
                    <th scope="col">i</th>
                    <th scope="col">Vergleich</th>
                    <th scope="col">Tausch?</th>
                    <th scope="col">Feld danach</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>1</td>
                    <td>1</td>
                    <td>7 &gt; 3</td>
                    <td>ja</td>
                    <td>
                      <code>[3, 7, 9, 1]</code>
                    </td>
                  </tr>
                  <tr>
                    <td>1</td>
                    <td>2</td>
                    <td>7 &gt; 9</td>
                    <td>nein</td>
                    <td>
                      <code>[3, 7, 9, 1]</code>
                    </td>
                  </tr>
                  <tr>
                    <td>1</td>
                    <td>3</td>
                    <td>9 &gt; 1</td>
                    <td>ja</td>
                    <td>
                      <code>[3, 7, 1, 9]</code>
                    </td>
                  </tr>
                  <tr>
                    <td>2</td>
                    <td>1</td>
                    <td>3 &gt; 7</td>
                    <td>nein</td>
                    <td>
                      <code>[3, 7, 1, 9]</code>
                    </td>
                  </tr>
                  <tr>
                    <td>2</td>
                    <td>2</td>
                    <td>7 &gt; 1</td>
                    <td>ja</td>
                    <td>
                      <code>[3, 1, 7, 9]</code>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
            <p>
              Nach dem ersten Durchlauf: <strong>[3, 7, 1, 9]</strong>, die 9 ist hinten. Nach dem
              zweiten Durchlauf: <strong>[3, 1, 7, 9]</strong>, die 7 steht an vorletzter Stelle.
              Der dritte Durchlauf tauscht noch 3 und 1, Endzustand [1, 3, 7, 9]. Typischer Fehler:
              im zweiten Durchlauf noch einmal bis i = 3 vergleichen; die innere Schleife läuft nur
              bis n − 2 = 2.
            </p>
          </Loesung>
        </Aufgabe>

        <Aufgabe nr="6.2" label="Ergänzungsaufgabe 6.2">
          <p>
            Ergänzen Sie das Struktogramm an den Stellen (1) und (2), damit es das Feld{" "}
            <code>zahlen</code> mit n Elementen aufsteigend sortiert; das erste Element hat den
            Index 1. Lücke (1) ist der Kopf der inneren Zählschleife, Lücke (2) die Bedingung, unter
            der getauscht wird.
          </p>
          <Struktogramm titel="Bubblesort" bloecke={aufgabe62} breite={420} />
          <Loesung>
            <Struktogramm titel="Bubblesort" bloecke={bubblesort} breite={420} />
            <p>
              (1) <code>für i = 1 bis n - durchlauf</code>: Im ersten Durchlauf bis n − 1, weil der
              Vergleich auf <code>zahlen[i + 1]</code> zugreift und das bei i = n über das Feldende
              hinausginge. In jedem weiteren Durchlauf eins weniger, weil hinten schon sortiert ist.
              (2) <code>zahlen[i] &gt; zahlen[i + 1]</code>: Getauscht wird, wenn links der größere
              Wert steht; <code>&gt;=</code> in Lücke (2) sortiert ebenfalls, nur mit unnötigen
              Tauschen gleicher Werte. Gleichwertig, nur langsamer: die innere Schleife immer bis
              n − 1 laufen zu lassen; falsch wäre eine Grenze n, weil dann <code>zahlen[n + 1]</code>{" "}
              gelesen würde.
            </p>
          </Loesung>
        </Aufgabe>

        <Zeichenaufgabe
          nr="6.3"
          toolHinweis={false}
          loesung={
            <div className="sg-paar">
              <div>
                <h4>Funktion</h4>
                <Struktogramm titel="anzahlGroesser(zahlen: Feld, n: Ganzzahl, grenze: Ganzzahl): Ganzzahl" bloecke={anzahlGroesser} />
              </div>
              <div>
                <h4>Hauptprogramm</h4>
                <Struktogramm titel="Hauptprogramm" bloecke={anzahlGroesserHaupt} />
              </div>
            </div>
          }
          erklaerung={
            <p>
              Die Funktion ist das Zählmuster aus Lektion 5, nur dass die Grenze als Parameter
              hereinkommt und die Ausgabe durch <code>Rückgabe anzahl</code> ersetzt ist: Eine
              Funktion gibt nichts aus, sie liefert. Das Hauptprogramm liest die Grenze ein, ruft
              die Funktion mit drei Argumenten in der Reihenfolge der Signatur auf, legt das
              Ergebnis in einer Variablen ab und gibt es aus. Probe mit <code>[4, 9, 2, 7]</code>{" "}
              und grenze = 5: Rückgabe 2.
            </p>
          }
          bewertung={[
            "Signatur als Titel mit drei Parametern und Rückgabetyp Ganzzahl",
            "Zähler ab 0, Zählschleife über alle n Elemente, Verzweigung zahlen[i] > grenze",
            "Rückgabe des Zählers nach der Schleife, keine Ausgabe in der Funktion",
            "Hauptprogramm: Eingabe der Grenze, Aufruf mit Argumenten in Signaturreihenfolge, Ergebnis zugewiesen und ausgegeben",
            "Gleichwertig: andere Schleifenart mit denselben Grenzen (ein Zähler ab 0 nur mit Zugriff zahlen[i + 1]), Aufruf direkt in der Ausgabe ohne Zwischenvariable oder im Aufrufkasten",
          ]}
        >
          <p>
            Entwerfen Sie die Funktion <code>anzahlGroesser(zahlen: Feld, n: Ganzzahl, grenze:
            Ganzzahl): Ganzzahl</code>, die zurückgibt, wie viele Elemente des Feldes größer als die
            Grenze sind; das erste Element hat den Index 1. Entwerfen Sie außerdem ein
            Hauptprogramm, das eine Grenze einliest, die Funktion aufruft und das Ergebnis ausgibt.
          </p>
        </Zeichenaufgabe>

        <Zeichenaufgabe
          nr="6.4"
          toolHinweis={false}
          loesung={<Struktogramm titel="istPrimzahl(zahl: Ganzzahl): Wahrheitswert" bloecke={istPrimzahl} breite={440} />}
          erklaerung={
            <p>
              Eine Primzahl ist nur durch 1 und sich selbst teilbar. Der Merker <code>istPrim</code>{" "}
              startet mit wahr und kippt auf falsch, sobald ein Teiler zwischen 2 und zahl − 1
              gefunden wird. Der Sonderfall zahl &lt; 2 wird vorab abgefangen, weil 0 und 1 keine
              Primzahlen sind. Für zahl = 2 läuft die Schleife „für i = 2 bis 1“ gar nicht, der Merker
              bleibt wahr, und das ist richtig. Probe: 9 hat den Teiler 3 (9 MOD 3 == 0), Rückgabe
              falsch; 7 hat keinen Teiler von 2 bis 6, Rückgabe wahr. Gleichwertig ist eine
              kopfgesteuerte Schleife „solange i &lt;= zahl − 1 UND istPrim“, die nach dem ersten
              Teiler abbricht; die Zählschleife darf dafür nicht im Rumpf verändert werden.
            </p>
          }
          bewertung={[
            "Signatur mit Parameter zahl und Rückgabetyp Wahrheitswert",
            "Sonderfall zahl < 2 liefert falsch",
            "Merker mit Startwert wahr, Schleife von 2 bis zahl − 1 mit Prüfung zahl MOD i == 0",
            "Merker im Ja-Zweig auf falsch, Rückgabe des Merkers nach der Schleife",
            "Gleichwertig: kopfgesteuerte Schleife mit Abbruch nach dem ersten Teiler, direkte Rückgabe falsch im Ja-Zweig oder Schleife nur bis zur Wurzel von zahl",
          ]}
        >
          <p>
            Entwerfen Sie die Funktion <code>istPrimzahl(zahl: Ganzzahl): Wahrheitswert</code>. Sie
            liefert wahr, wenn zahl eine Primzahl ist, sonst falsch. Prüfe dazu alle möglichen Teiler
            von 2 bis zahl − 1 mit MOD. Beachte, dass Zahlen kleiner als 2 keine Primzahlen sind.
            Kontrolliere deine Lösung mit zahl = 1, 2, 7 und 9.
          </p>
        </Zeichenaufgabe>
      </LsAbschnitt>

      <LsAbschnitt id="quiz" titel="Jetzt selbst testen">
        <p style={{ marginBottom: 18 }}>Vier Fragen zu Tauschen, Bubblesort und Unterprogrammen.</p>
        <QuizFrage
          nr={1}
          von={4}
          frage="a = 3, b = 9. Es werden nacheinander a = b und b = a ausgeführt. Was steht danach in a und b?"
          optionen={[
            { text: "a = 9, b = 9", richtig: true },
            { text: "a = 9, b = 3", richtig: false },
            { text: "a = 3, b = 9", richtig: false },
            { text: "a = 3, b = 3", richtig: false },
          ]}
          erklaerung="Nach a = b ist die 3 überschrieben; a und b enthalten beide 9, und b = a ändert nichts mehr. Für einen Tausch muss die 3 vorher in eine Hilfsvariable gerettet werden."
        />
        <QuizFrage
          nr={2}
          von={4}
          frage="Was gilt nach dem ersten Durchlauf der äußeren Schleife eines aufsteigenden Bubblesorts sicher?"
          optionen={[
            { text: "Das größte Element steht an der letzten Stelle", richtig: true },
            { text: "Das kleinste Element steht an der ersten Stelle", richtig: false },
            { text: "Das Feld ist vollständig sortiert", richtig: false },
            { text: "Es wurde genau ein Tausch ausgeführt", richtig: false },
          ]}
          erklaerung="Jeder Vergleich schiebt den größeren Wert nach rechts, so wandert das Maximum im ersten Durchlauf ganz nach hinten. Über den Anfang des Feldes sagt das nichts aus; bei [5, 2, 4, 1] steht nach dem ersten Durchlauf vorn die 2, nicht die 1."
        />
        <QuizFrage
          nr={3}
          von={4}
          frage="Worin unterscheidet sich eine Funktion von einer Prozedur?"
          optionen={[
            { text: "Eine Funktion liefert einen Rückgabewert, eine Prozedur nicht", richtig: true },
            { text: "Eine Funktion hat Parameter, eine Prozedur nicht", richtig: false },
            { text: "Eine Prozedur darf keine Schleifen enthalten", richtig: false },
            { text: "Eine Funktion darf nicht aus dem Hauptprogramm aufgerufen werden", richtig: false },
          ]}
          erklaerung="Beide können Parameter und beliebige Bausteine enthalten. Der Unterschied ist die Rückgabe: Die Signatur einer Funktion endet mit dem Rückgabetyp, im Rumpf steht Rückgabe, und der Aufruf wird zugewiesen oder in einer Bedingung benutzt."
        />
        <QuizFrage
          nr={4}
          von={4}
          frage="Warum läuft die innere Schleife des Bubblesorts nur bis n − durchlauf und nicht bis n?"
          optionen={[
            { text: "Der Vergleich greift auf zahlen[i + 1] zu, und die hinteren Elemente sind schon sortiert", richtig: true },
            { text: "Weil der Zähler einer Zählschleife nie n erreichen darf", richtig: false },
            { text: "Damit das kleinste Element vorne bleibt", richtig: false },
            { text: "Weil die äußere Schleife sonst nicht endet", richtig: false },
          ]}
          erklaerung="Bei i = n gäbe es kein Element zahlen[n + 1] mehr; die Grenze muss also mindestens eins unter n liegen. Und nach jedem Durchlauf ist ein weiteres Element hinten fertig, deshalb darf die Grenze mit jedem Durchlauf um eins sinken."
        />
      </LsAbschnitt>
    </LektionLayout>
  );
}
