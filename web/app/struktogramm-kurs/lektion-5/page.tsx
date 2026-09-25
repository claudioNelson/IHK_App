import type { Metadata } from "next";
import { LsAbschnitt, LsHinweis } from "../../lernen/_components/LsBausteine";
import QuizFrage from "../../lernen/_components/QuizFrage";
import LektionLayout from "../../components/kurs/LektionLayout";
import { Aufgabe, CodeBlock, Loesung, Zeichenaufgabe } from "../../components/kurs/KursBausteine";
import Struktogramm, { TraceTabelle } from "../_components/Struktogramm";
import { anw, fuer, luecke, solange, wenn } from "../_components/struktogramm-typen";
import { struktogrammKurs } from "../_components/lektionen";

export const metadata: Metadata = {
  title: "Struktogramm Lektion 5: Felder und die Grundmuster",
  description:
    "Felder (Arrays) im Struktogramm: Zugriff über den Index, Durchlauf mit der Zählschleife und die Grundmuster Summe, Durchschnitt, Maximum, Zählen und lineare Suche. Mit Schreibtischtests.",
  alternates: { canonical: "https://lernarena.app/struktogramm-kurs/lektion-5" },
};

/* ---- Beispiele der Lektion ---- */

// Durchlauf ueber alle Elemente
const durchlauf = [fuer("für i = 1 bis n", [anw("Ausgabe zahlen[i]")])];
const durchlaufCode = `FÜR i = 1 BIS n
    AUSGABE zahlen[i]
ENDE FÜR`;

// Summe
const summe = [anw("summe = 0"), fuer("für i = 1 bis n", [anw("summe = summe + zahlen[i]")]), anw("Ausgabe summe")];
const summeCode = `summe = 0
FÜR i = 1 BIS n
    summe = summe + zahlen[i]
ENDE FÜR
AUSGABE summe`;

// Durchschnitt
const durchschnitt = [
  anw("summe = 0"),
  fuer("für i = 1 bis n", [anw("summe = summe + zahlen[i]")]),
  anw("durchschnitt = summe / n"),
  anw("Ausgabe durchschnitt"),
];
const durchschnittCode = `summe = 0
FÜR i = 1 BIS n
    summe = summe + zahlen[i]
ENDE FÜR
durchschnitt = summe / n
AUSGABE durchschnitt`;

// Maximum mit Index
const maximum = [
  anw("max = zahlen[1]"),
  anw("pos = 1"),
  fuer("für i = 2 bis n", [wenn("zahlen[i] > max", [anw("max = zahlen[i]"), anw("pos = i")])]),
  anw("Ausgabe max, pos"),
];
const maximumCode = `max = zahlen[1]
pos = 1
FÜR i = 2 BIS n
    WENN zahlen[i] > max DANN
        max = zahlen[i]
        pos = i
    ENDE WENN
ENDE FÜR
AUSGABE max, pos`;

// Minimum als Variante
const minimum = [
  anw("min = zahlen[1]"),
  anw("pos = 1"),
  fuer("für i = 2 bis n", [wenn("zahlen[i] < min", [anw("min = zahlen[i]"), anw("pos = i")])]),
  anw("Ausgabe min, pos"),
];

// Zaehlen mit Bedingung
const zaehlen = [
  anw("anzahl = 0"),
  fuer("für i = 1 bis n", [wenn("zahlen[i] > 5", [anw("anzahl = anzahl + 1")])]),
  anw("Ausgabe anzahl"),
];
const zaehlenCode = `anzahl = 0
FÜR i = 1 BIS n
    WENN zahlen[i] > 5 DANN
        anzahl = anzahl + 1
    ENDE WENN
ENDE FÜR
AUSGABE anzahl`;

// Lineare Suche, kopfgesteuert mit Abbruch
const suche = [
  anw("Eingabe gesucht"),
  anw("gefunden = falsch"),
  anw("i = 1"),
  solange("i <= n UND NICHT gefunden", [
    wenn("zahlen[i] == gesucht", [anw("gefunden = wahr"), anw("position = i")]),
    anw("i = i + 1"),
  ]),
  wenn("gefunden", [anw('Ausgabe "Position", position')], [anw('Ausgabe "nicht gefunden"')]),
];
const sucheCode = `EINGABE gesucht
gefunden = falsch
i = 1
SOLANGE i <= n UND NICHT gefunden
    WENN zahlen[i] == gesucht DANN
        gefunden = wahr
        position = i
    ENDE WENN
    i = i + 1
ENDE SOLANGE
WENN gefunden DANN
    AUSGABE "Position", position
SONST
    AUSGABE "nicht gefunden"
ENDE WENN`;

// Lineare Suche als Zaehlschleife mit Merker (laeuft weiter)
const sucheZaehl = [
  anw("Eingabe gesucht"),
  anw("gefunden = falsch"),
  fuer("für i = 1 bis n", [wenn("zahlen[i] == gesucht", [anw("gefunden = wahr"), anw("position = i")])]),
  wenn("gefunden", [anw('Ausgabe "Position", position')], [anw('Ausgabe "nicht gefunden"')]),
];

/* ---- Aufgaben ---- */

// 5.1: Maximum mit Index ueber fuenf Werte
const aufgabe51 = [
  anw("max = zahlen[1]"),
  anw("pos = 1"),
  fuer("für i = 2 bis 5", [wenn("zahlen[i] > max", [anw("max = zahlen[i]"), anw("pos = i")])]),
  anw("Ausgabe max, pos"),
];

// 5.4: Minimum mit Luecken
const aufgabe54 = [
  luecke("1"),
  anw("pos = 1"),
  fuer("für i = 2 bis n", [wenn("(2)", [anw("min = zahlen[i]"), anw("pos = i")])]),
  anw("Ausgabe min, pos"),
];
const aufgabe54Loesung = [
  anw("min = zahlen[1]"),
  anw("pos = 1"),
  fuer("für i = 2 bis n", [wenn("zahlen[i] < min", [anw("min = zahlen[i]"), anw("pos = i")])]),
  anw("Ausgabe min, pos"),
];

/* ---- Musterloesungen der Zeichenaufgaben ---- */

const ueberDurchschnitt = [
  anw("summe = 0"),
  fuer("für i = 1 bis n", [anw("summe = summe + zahlen[i]")]),
  anw("durchschnitt = summe / n"),
  anw("anzahl = 0"),
  fuer("für i = 1 bis n", [wenn("zahlen[i] > durchschnitt", [anw("anzahl = anzahl + 1")])]),
  anw("Ausgabe anzahl"),
];

const kundenSuche = [
  anw("Eingabe gesucht"),
  anw("gefunden = falsch"),
  anw("i = 1"),
  solange("i <= n UND NICHT gefunden", [
    wenn("kunden[i] == gesucht", [anw("gefunden = wahr"), anw("position = i")]),
    anw("i = i + 1"),
  ]),
  wenn("gefunden", [anw('Ausgabe "Position", position')], [anw('Ausgabe "nicht gefunden"')]),
];

export default function Lektion5() {
  return (
    <LektionLayout
      kurs={struktogrammKurs}
      nr={5}
      lead="Viele Werte, ein Name: das Feld. Mit der Zählschleife gehst du alle Elemente durch, und daraus entstehen die Grundmuster, die in Prüfungsaufgaben immer wieder auftauchen: Summe, Durchschnitt, Maximum, Zählen und Suchen. Wer die fünf Muster sicher zeichnen kann, erkennt sie später in vielen Aufgabentexten wieder."
      uebungen={8}
      aufgabenText="1 Leseaufgabe, 2 Zeichenaufgaben, 1 Ergänzungsaufgabe, 4 Quizfragen"
    >
      <LsAbschnitt id="felder" titel="Felder: viele Werte unter einem Namen">
        <p>
          Bisher hatte jede Variable genau einen Wert. Sobald eine Aufgabe von „den Messwerten“,
          „allen Kunden“ oder „einer Liste von Preisen“ spricht, brauchst du ein{" "}
          <strong>Feld</strong> (Array). Stell dir ein Feld als Reihe nummerierter Fächer vor: Jedes
          Fach enthält einen Wert, und die Nummer des Fachs heißt <strong>Index</strong>. Das Feld{" "}
          <code>zahlen</code> mit vier Werten sieht so aus:
        </p>
        <div className="ls-table-wrap">
          <table className="ls-table sg-text-tabelle">
            <thead>
              <tr>
                <th scope="col">Index i</th>
                <th scope="col">1</th>
                <th scope="col">2</th>
                <th scope="col">3</th>
                <th scope="col">4</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>zahlen[i]</td>
                <td>4</td>
                <td>9</td>
                <td>2</td>
                <td>7</td>
              </tr>
            </tbody>
          </table>
        </div>
        <p>
          Auf ein einzelnes Fach greifst du mit dem Index in eckigen Klammern zu:{" "}
          <code>zahlen[2]</code> ist 9, <code>zahlen[4]</code> ist 7. Der Index darf auch eine Variable
          sein, und genau das macht Felder so nützlich: <code>zahlen[i]</code> meint je nach Wert
          von i ein anderes Fach. Die Anzahl der Elemente heißt im Kurs <code>n</code>; manche
          Aufgaben schreiben stattdessen <code>laenge(zahlen)</code> oder geben die Anzahl im Text
          fest vor („ein Feld mit 20 Messwerten“).
        </p>
        <LsHinweis titel="Index 1 oder Index 0?" art="warnung">
          <p>
            In diesem Kurs hat das erste Element den Index 1, das letzte den Index n. Viele
            Prüfungsaufgaben beginnen dagegen bei 0, weil die meisten Programmiersprachen das
            tun; das erste Element ist dann <code>zahlen[0]</code>, das letzte{" "}
            <code>zahlen[n - 1]</code>, und die Schleife lautet „für i = 0 bis n − 1“. Welche
            Indexbasis gilt, steht in der Aufgabe. Lies das nach, bevor du zeichnest, und halte
            dich dann konsequent daran. Der häufigste Fehler bei Feldern ist eine Schleife, die
            ein Element zu weit oder zu kurz läuft.
          </p>
        </LsHinweis>
        <p>
          Alle Elemente der Reihe nach anzusehen ist die Grundbewegung bei Feldern. Weil die Anzahl
          vorher feststeht, ist die Zählschleife aus Lektion 3 das passende Werkzeug. Der Zähler ist
          zugleich der Index:
        </p>
        <div className="sg-paar">
          <div>
            <h4>Struktogramm</h4>
            <Struktogramm titel="Alle Elemente ausgeben" bloecke={durchlauf} />
          </div>
          <div>
            <h4>Pseudocode</h4>
            <CodeBlock code={durchlaufCode} />
          </div>
        </div>
        <p>
          Für das Feld oben werden nacheinander 4, 9, 2 und 7 ausgegeben. Jedes der folgenden Muster
          ist nichts anderes als dieser Durchlauf mit etwas Zusatz davor, im Rumpf und danach.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="summe" titel="Summe und Durchschnitt">
        <p>
          Das erste Muster: alle Werte zusammenzählen. Dafür braucht es eine Variable, die vor der
          Schleife auf 0 gesetzt wird und in jedem Durchlauf das aktuelle Element dazubekommt. Eine
          solche Variable heißt <strong>Akkumulator</strong> („Sammler“).
        </p>
        <div className="sg-paar">
          <div>
            <h4>Struktogramm</h4>
            <Struktogramm titel="Summe" bloecke={summe} />
          </div>
          <div>
            <h4>Pseudocode</h4>
            <CodeBlock code={summeCode} />
          </div>
        </div>
        <p>
          Der <strong>Schreibtischtest</strong> (Wertetabelle) für <code>zahlen = [4, 9, 2, 7]</code>{" "}
          mit n = 4:
        </p>
        <TraceTabelle
          spalten={["Schritt", "i", "zahlen[i]", "summe", "Ausgabe"]}
          zeilen={[
            ["Start", "", "", 0, ""],
            ["summe = 0 + 4", 1, 4, 4, ""],
            ["summe = 4 + 9", 2, 9, 13, ""],
            ["summe = 13 + 2", 3, 2, 15, ""],
            ["summe = 15 + 7", 4, 7, 22, ""],
            ["Schleife beendet, Ausgabe", 5, "", 22, 22],
          ]}
          caption="Summe von [4, 9, 2, 7]: 22. Am Ende steht i auf 5, die Prüfung 5 > 4 beendet die Schleife. Die Ausgabe steht nach der Schleife, nicht im Rumpf; sonst würden alle Zwischensummen ausgegeben."
        />
        <p>
          Der <strong>Durchschnitt</strong> ist die Summe geteilt durch die Anzahl. Er kommt nach
          der Schleife dazu, als eine Anweisung. Wir setzen n &gt;= 1 voraus (mindestens ein
          Wert), sonst würde durch 0 geteilt:
        </p>
        <div className="sg-paar">
          <div>
            <h4>Struktogramm</h4>
            <Struktogramm titel="Durchschnitt" bloecke={durchschnitt} />
          </div>
          <div>
            <h4>Pseudocode</h4>
            <CodeBlock code={durchschnittCode} />
          </div>
        </div>
        <p>
          Für unser Feld: 22 / 4 = 5,5. Achte auf den Datentyp: <code>durchschnitt</code> muss eine
          Kommazahl sein, und die Division ist das <code>/</code> mit Nachkommastellen, nicht{" "}
          <code>DIV</code>. Mit ganzzahliger Division käme 5 heraus, und das ist in vielen
          Lösungshinweisen ein eigener Abzug. Wenn eine Aufgabe die Datentypen nennen lässt, schreibe
          „summe: Ganzzahl, durchschnitt: Kommazahl“ dazu.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="maximum" titel="Maximum und Minimum mit Index">
        <p>
          Das größte Element finden: Du merkst dir einen Kandidaten und vergleichst jedes weitere
          Element mit ihm. Ist das Element größer, wird es der neue Kandidat. Oft will die Aufgabe
          nicht nur den Wert, sondern auch die Stelle, an der er steht; dann merkst du dir den
          Index gleich mit. Wir setzen n &gt;= 1 voraus (mindestens ein Wert), damit der
          Startkandidat existiert.
        </p>
        <div className="sg-paar">
          <div>
            <h4>Struktogramm</h4>
            <Struktogramm titel="Maximum mit Index" bloecke={maximum} />
          </div>
          <div>
            <h4>Pseudocode</h4>
            <CodeBlock code={maximumCode} />
          </div>
        </div>
        <TraceTabelle
          spalten={["Prüfung", "i", "zahlen[i]", "max", "pos", "Ausgabe"]}
          zeilen={[
            ["Start: max = zahlen[1]", "", "", 4, 1, ""],
            ["9 > 4: ja", 2, 9, 9, 2, ""],
            ["2 > 9: nein", 3, 2, 9, 2, ""],
            ["7 > 9: nein", 4, 7, 9, 2, ""],
            ["Schleife beendet, Ausgabe", 5, "", 9, 2, "9, 2"],
          ]}
          caption="Maximum von [4, 9, 2, 7]: der Wert 9 an Position 2. Die Schleife beginnt bei 2, weil das erste Element schon der Startkandidat ist."
        />
        <LsHinweis titel="Startwert: das erste Element, nicht 0" art="warnung">
          <p>
            Wer <code>max = 0</code> als Startwert nimmt, bekommt bei einem Feld aus lauter negativen
            Werten das falsche Ergebnis 0, das gar nicht im Feld steht. Der sichere Startwert ist{" "}
            <code>zahlen[1]</code> (bei Indexbasis 0 entsprechend <code>zahlen[0]</code>), und die
            Schleife beginnt dann beim zweiten Element. Eine Schleife ab dem ersten Element ist
            ebenfalls richtig, sie vergleicht das erste Element nur einmal überflüssig mit sich
            selbst.
          </p>
        </LsHinweis>
        <p>
          Das <strong>Minimum</strong> ist dieselbe Struktur mit umgedrehtem Vergleich: Der Kandidat
          wird ersetzt, wenn das Element <em>kleiner</em> ist.
        </p>
        <Struktogramm
          titel="Minimum mit Index"
          bloecke={minimum}
          breite={380}
          caption="Für [4, 9, 2, 7]: min startet mit 4; 9 < 4 nein, 2 < 4 ja (min = 2, pos = 3), 7 < 2 nein. Ausgabe 2, 3."
        />
        <p>
          Kommt der größte Wert mehrfach vor, behält <code>&gt;</code> die erste Stelle, weil ein
          gleich großes Element die Bedingung nicht erfüllt. Mit <code>&gt;=</code> würde die letzte
          Stelle gemerkt. Wenn die Aufgabe dazu nichts sagt, sind beide Varianten in Ordnung; sag im
          Zweifel in einem Satz dazu, welche du gewählt hast.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="zaehlen" titel="Zählen mit Bedingung">
        <p>
          „Wie viele Werte sind größer als 5?“ Das Muster kennst du aus Lektion 4: ein Zähler, der
          vor der Schleife auf 0 gesetzt wird, und eine Verzweigung im Rumpf, in deren Ja-Zweig der
          Zähler um 1 erhöht wird. Neu ist nur, dass die Bedingung ein Feldelement prüft.
        </p>
        <div className="sg-paar">
          <div>
            <h4>Struktogramm</h4>
            <Struktogramm titel="Werte über 5 zählen" bloecke={zaehlen} />
          </div>
          <div>
            <h4>Pseudocode</h4>
            <CodeBlock code={zaehlenCode} />
          </div>
        </div>
        <TraceTabelle
          spalten={["Prüfung", "i", "zahlen[i]", "anzahl", "Ausgabe"]}
          zeilen={[
            ["Start", "", "", 0, ""],
            ["4 > 5: nein", 1, 4, 0, ""],
            ["9 > 5: ja", 2, 9, 1, ""],
            ["2 > 5: nein", 3, 2, 1, ""],
            ["7 > 5: ja", 4, 7, 2, ""],
            ["Schleife beendet, Ausgabe", 5, "", 2, 2],
          ]}
          caption="Zwei Werte von [4, 9, 2, 7] liegen über 5: die 9 und die 7."
        />
        <p>
          Der Unterschied zur Summe: Beim Zählen kommt in jedem Treffer <code>+ 1</code> dazu, bei
          der Summe <code>+ zahlen[i]</code>. Beides lässt sich kombinieren, etwa „Summe aller
          geraden Werte“: Verzweigung mit <code>zahlen[i] MOD 2 == 0</code>, im Ja-Zweig{" "}
          <code>summe = summe + zahlen[i]</code>.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="suche" titel="Lineare Suche">
        <p>
          „Kommt der Wert 2 im Feld vor, und wenn ja, an welcher Stelle?“ Die{" "}
          <strong>lineare Suche</strong> geht die Elemente von vorn nach hinten durch und vergleicht
          jedes mit dem gesuchten Wert. Zwei Dinge musst du dir merken: <em>ob</em> etwas gefunden
          wurde (ein Merker vom Typ Wahrheitswert) und <em>wo</em> (die Position). Sobald der Wert
          gefunden ist, darf die Suche aufhören. Deshalb ist die Standardform eine kopfgesteuerte
          Schleife mit doppelter Bedingung:
        </p>
        <div className="sg-paar">
          <div>
            <h4>Struktogramm</h4>
            <Struktogramm titel="Lineare Suche" bloecke={suche} />
          </div>
          <div>
            <h4>Pseudocode</h4>
            <CodeBlock code={sucheCode} />
          </div>
        </div>
        <p>
          Die Schleife läuft, solange noch Elemente übrig sind (<code>i &lt;= n</code>){" "}
          <em>und</em> noch nichts gefunden wurde (<code>NICHT gefunden</code>). Sobald eine der
          beiden Bedingungen kippt, endet sie: entweder am Feldende oder nach dem Treffer. Der
          Schreibtischtest für die Suche nach 2 in <code>[4, 9, 2, 7]</code>:
        </p>
        <TraceTabelle
          spalten={["Prüfung", "i", "zahlen[i]", "gefunden", "position", "Ausgabe"]}
          zeilen={[
            ["Start: i = 1", 1, "", "falsch", "", ""],
            ["1 <= 4 UND NICHT falsch: ja; 4 == 2: nein", 1, 4, "falsch", "", ""],
            ["2 <= 4 UND NICHT falsch: ja; 9 == 2: nein", 2, 9, "falsch", "", ""],
            ["3 <= 4 UND NICHT falsch: ja; 2 == 2: ja", 3, 2, "wahr", 3, ""],
            ["4 <= 4 UND NICHT wahr: nein, Schleife endet", 4, "", "wahr", 3, ""],
            ["gefunden: ja, Ausgabe", 4, "", "wahr", 3, "Position 3"],
          ]}
          caption="Suche nach 2: Treffer im dritten Durchlauf. Die 7 wird nicht mehr angesehen. Die Spalte i zeigt den Wert bei der Prüfung; am Ende jedes Durchlaufs erhöht i = i + 1 den Zähler, deshalb steht i in der nächsten Zeile um 1 höher."
        />
        <p>
          Würde nach 5 gesucht, bliebe <code>gefunden</code> falsch, i liefe bis 5, die Bedingung{" "}
          <code>5 &lt;= 4</code> wäre falsch, und die Ausgabe wäre „nicht gefunden“. Die Verzweigung{" "}
          <em>nach</em> der Schleife entscheidet über die Ausgabe; im Rumpf selbst wird nichts
          ausgegeben.
        </p>
        <p>
          Die Alternative ist eine Zählschleife mit Merker. Sie ist kürzer, läuft aber nach dem
          Treffer bis zum Feldende weiter und merkt sich bei mehrfach vorkommenden Werten die{" "}
          <em>letzte</em> Position:
        </p>
        <Struktogramm
          titel="Lineare Suche mit Zählschleife"
          bloecke={sucheZaehl}
          breite={420}
          caption="Gleichwertig, wenn die Aufgabe keinen Abbruch verlangt. Den Zähler i im Rumpf auf n zu setzen, um abzubrechen, ist keine Lösung: Der Zähler einer Zählschleife wird im Rumpf nicht verändert."
        />
        <LsHinweis titel="Muster im Aufgabentext erkennen" icon="buch" label="Prüfungsbezug">
          <p>
            Prüfungsaufgaben nennen die Muster nicht beim Namen, sie beschreiben ein Ergebnis.
            Typische Formulierungen: „Wie viele …“ oder „die Anzahl der …“ ist ein Zähler. „Das
            größte …“, „der teuerste …“, „an welcher Stelle steht der höchste …“ ist Maximum mit
            Index. „Ob … vorkommt“, „ob die Kundennummer bereits vergeben ist“ ist eine Suche.
            „Gesamt …“, „insgesamt …“ ist eine Summe, „im Mittel“, „durchschnittlich“ Summe durch
            Anzahl. Manche Aufgaben kombinieren zwei Muster, dann brauchst du oft zwei Schleifen
            nacheinander.
          </p>
        </LsHinweis>
        <h4>Merkregeln für alle Muster</h4>
        <ol>
          <li>
            <strong>Startwert passend zum Muster</strong>: 0 für Summe und Zähler, 1 für ein Produkt,
            das erste Element für Maximum und Minimum, <code>falsch</code> für den gefunden-Merker.
          </li>
          <li>
            <strong>Eine Schleife über alle Elemente</strong>, der Zähler ist der Index. Grenzen zur
            Indexbasis passend: 1 bis n oder 0 bis n − 1.
          </li>
          <li>
            <strong>Ausgabe nach der Schleife</strong>, nicht im Rumpf. Im Rumpf wird nur
            gerechnet, verglichen und gemerkt.
          </li>
        </ol>
      </LsAbschnitt>

      <LsAbschnitt id="uebungen" titel="Übungen">
        <Aufgabe nr="5.1" label="Leseaufgabe 5.1">
          <p>
            Führen Sie einen Schreibtischtest durch: Gegeben ist das Feld{" "}
            <code>zahlen = [3, 8, 5, 8, 1]</code>; das erste Element hat den Index 1. Welche Werte
            gibt das Struktogramm aus? Lege die Spalten i, zahlen[i], max und pos an und notiere zu
            jedem Durchlauf, ob die Bedingung zutrifft.
          </p>
          <Struktogramm titel="Maximum mit Index" bloecke={aufgabe51} breite={380} />
          <Loesung>
            <TraceTabelle
              spalten={["Prüfung", "i", "zahlen[i]", "max", "pos", "Ausgabe"]}
              zeilen={[
                ["Start: max = zahlen[1]", "", "", 3, 1, ""],
                ["8 > 3: ja", 2, 8, 8, 2, ""],
                ["5 > 8: nein", 3, 5, 8, 2, ""],
                ["8 > 8: nein", 4, 8, 8, 2, ""],
                ["1 > 8: nein", 5, 1, 8, 2, ""],
                ["Schleife beendet, Ausgabe", 6, "", 8, 2, "8, 2"],
              ]}
            />
            <p>
              Ausgabe: <strong>8, 2</strong>. Die zweite 8 an Position 4 ändert nichts, weil{" "}
              <code>8 &gt; 8</code> falsch ist; gemerkt bleibt die erste Fundstelle. Wer hier pos = 4
              notiert, hat den Vergleich als <code>&gt;=</code> gelesen.
            </p>
          </Loesung>
        </Aufgabe>

        <Zeichenaufgabe
          nr="5.2"
          toolHinweis={false}
          loesung={<Struktogramm titel="Werte über dem Durchschnitt zählen" bloecke={ueberDurchschnitt} breite={400} />}
          erklaerung={
            <p>
              Zwei Schleifen nacheinander: Die erste bildet die Summe, daraus entsteht der
              Durchschnitt, die zweite zählt. In einer einzigen Schleife geht es nicht, weil der
              Durchschnitt erst feststeht, wenn alle Werte gesehen wurden. Probe mit{" "}
              <code>[4, 9, 2, 7]</code>: Summe 22, Durchschnitt 5,5, darüber liegen 9 und 7, Ausgabe
              2. Der Zähler i darf in beiden Schleifen gleich heißen, weil die erste Schleife
              beendet ist, bevor die zweite beginnt.
            </p>
          }
          bewertung={[
            "Erste Schleife über alle n Elemente bildet die Summe, Akkumulator vorher auf 0",
            "Durchschnitt nach der ersten Schleife als summe / n (Kommazahl)",
            "Zweite Schleife über alle Elemente mit Verzweigung zahlen[i] > durchschnitt",
            "Zähler vor der zweiten Schleife auf 0, Erhöhung im Ja-Zweig, Ausgabe nach der Schleife",
            "Gleichwertig: andere Schleifenart mit denselben Grenzen oder ein anderer Name für den zweiten Zähler; ein Zähler ab 0 nur mit Zugriff zahlen[i + 1]",
          ]}
        >
          <p>
            Entwerfen Sie ein Struktogramm: Gegeben ist ein Feld <code>zahlen</code> mit n Werten;
            das erste Element hat den Index 1. Es soll ausgegeben werden, wie viele Werte über dem
            Durchschnitt aller Werte liegen. Überlege zuerst, was du wissen musst, bevor du zählen
            kannst.
          </p>
        </Zeichenaufgabe>

        <Zeichenaufgabe
          nr="5.3"
          toolHinweis={false}
          loesung={<Struktogramm titel="Kundennummer suchen" bloecke={kundenSuche} breite={440} />}
          erklaerung={
            <p>
              Die kopfgesteuerte Schleife mit <code>i &lt;= n UND NICHT gefunden</code> bricht nach
              dem Treffer ab. Der Merker startet mit <code>falsch</code>, die Position wird nur im
              Ja-Zweig gesetzt. Die Ausgabe hängt nach der Schleife am Merker, nicht an der
              Position, weil die Position bei Misserfolg gar keinen Wert hat. Probe: Für{" "}
              <code>kunden = [1007, 1042, 1015]</code> und gesucht = 1042 endet die Schleife nach dem
              zweiten Durchlauf mit Ausgabe „Position 2“; für 1099 läuft sie bis i = 4 durch und
              gibt „nicht gefunden“ aus.
            </p>
          }
          bewertung={[
            "Eingabe der gesuchten Nummer, Merker gefunden mit Startwert falsch",
            "Schleife über das Feld mit Vergleich kunden[i] == gesucht",
            "Im Ja-Zweig Merker auf wahr und Position gemerkt",
            "Ausgabe nach der Schleife per Verzweigung über den Merker: Position oder „nicht gefunden“",
            "Gleichwertig: Zählschleife mit Merker ohne Abbruch, oder eine Position mit Startwert 0 als Merker (0 heißt „nicht gefunden“)",
          ]}
        >
          <p>
            Entwerfen Sie ein Struktogramm: In einem Feld <code>kunden</code> stehen n Kundennummern;
            das erste Element hat den Index 1. Eine Kundennummer wird eingegeben. Kommt sie im Feld
            vor, soll ihre Position ausgegeben werden, sonst der Text „nicht gefunden“. Die Suche
            soll nach dem ersten Treffer beendet werden.
          </p>
        </Zeichenaufgabe>

        <Aufgabe nr="5.4" label="Ergänzungsaufgabe 5.4">
          <p>
            Ergänzen Sie das Struktogramm an den Stellen (1) und (2): Es soll der kleinste Wert des
            Feldes <code>zahlen</code> mit n Elementen zusammen mit seiner Position ausgegeben werden;
            das erste Element hat den Index 1. Lücke (2) steht im Kopf der Verzweigung.
          </p>
          <Struktogramm titel="Minimum mit Index" bloecke={aufgabe54} breite={380} />
          <Loesung>
            <Struktogramm titel="Minimum mit Index" bloecke={aufgabe54Loesung} breite={380} />
            <p>
              (1) <code>min = zahlen[1]</code>: der Startkandidat ist das erste Element, passend
              dazu steht schon <code>pos = 1</code> darunter und die Schleife beginnt bei 2. (2){" "}
              <code>zahlen[i] &lt; min</code>: kleiner, nicht größer; <code>zahlen[i] &lt;= min</code>{" "}
              ist ebenfalls richtig, dann gilt bei gleichen Werten die letzte Fundstelle. Probe mit{" "}
              <code>[6, 3, 9, 3]</code>: min startet mit 6; 3 &lt; 6 ja (min = 3, pos = 2); 9 &lt; 3
              nein; 3 &lt; 3 nein. Ausgabe 3, 2. Wer in (1) <code>min = 0</code> schreibt, bekommt
              für dieses Feld die Ausgabe 0, 1, obwohl keine 0 im Feld steht.
            </p>
          </Loesung>
        </Aufgabe>
      </LsAbschnitt>

      <LsAbschnitt id="quiz" titel="Jetzt selbst testen">
        <p style={{ marginBottom: 18 }}>Vier Fragen zu Feldern und den Grundmustern.</p>
        <QuizFrage
          nr={1}
          von={4}
          frage="Ein Feld hat n Elemente, das erste Element hat den Index 0. Wie lautet die Zählschleife über alle Elemente?"
          optionen={[
            { text: "für i = 0 bis n − 1", richtig: true },
            { text: "für i = 1 bis n", richtig: false },
            { text: "für i = 0 bis n", richtig: false },
            { text: "für i = 1 bis n − 1", richtig: false },
          ]}
          erklaerung="Bei Indexbasis 0 ist das letzte Element zahlen[n − 1]. „0 bis n“ greift ein Element zu weit, „1 bis n“ lässt das erste aus und greift ebenfalls zu weit. Bei Indexbasis 1 wäre „1 bis n“ richtig."
        />
        <QuizFrage
          nr={2}
          von={4}
          frage="Welcher Startwert ist für die Suche nach dem Maximum sicher?"
          optionen={[
            { text: "Das erste Element des Feldes", richtig: true },
            { text: "0", richtig: false },
            { text: "n", richtig: false },
            { text: "Der Durchschnitt aller Werte", richtig: false },
          ]}
          erklaerung="Mit 0 als Start liefert ein Feld aus negativen Werten ein Maximum, das gar nicht vorkommt. Das erste Element ist immer ein gültiger Kandidat; die Schleife beginnt dann beim zweiten."
        />
        <QuizFrage
          nr={3}
          von={4}
          frage="Aufgabentext: „Geben Sie aus, wie viele Bestellungen einen Wert über 100 Euro haben.“ Welches Muster ist gemeint?"
          optionen={[
            { text: "Zählen mit Bedingung: Zähler ab 0, +1 im Ja-Zweig", richtig: true },
            { text: "Summe: Akkumulator ab 0, Wert addieren", richtig: false },
            { text: "Maximum mit Index", richtig: false },
            { text: "Lineare Suche mit Abbruch", richtig: false },
          ]}
          erklaerung="„Wie viele“ fragt nach einer Anzahl, nicht nach einem Gesamtbetrag. Die Bedingung bestellwerte[i] > 100 steht in der Verzweigung, im Ja-Zweig wird um 1 erhöht, die Ausgabe folgt nach der Schleife."
        />
        <QuizFrage
          nr={4}
          von={4}
          frage="Die lineare Suche läuft mit „solange i <= n UND NICHT gefunden“. Was bewirkt der zweite Teil der Bedingung?"
          optionen={[
            { text: "Die Schleife endet nach dem ersten Treffer, statt bis zum Feldende weiterzulaufen", richtig: true },
            { text: "Die Schleife läuft mindestens einmal", richtig: false },
            { text: "Die Schleife überspringt gefundene Werte", richtig: false },
            { text: "Der Zähler i wird auf n gesetzt", richtig: false },
          ]}
          erklaerung="Sobald gefunden auf wahr steht, ist NICHT gefunden falsch, die UND-Bedingung kippt, und die Schleife endet vor dem nächsten Durchlauf. Der erste Teil sorgt dafür, dass die Suche am Feldende aufhört, wenn nichts gefunden wurde."
        />
      </LsAbschnitt>
    </LektionLayout>
  );
}
