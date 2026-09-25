import type { Metadata } from "next";
import { LsAbschnitt, LsHinweis } from "../../lernen/_components/LsBausteine";
import QuizFrage from "../../lernen/_components/QuizFrage";
import LektionLayout from "../../components/kurs/LektionLayout";
import { Aufgabe, CodeBlock, Loesung, Zeichenaufgabe } from "../../components/kurs/KursBausteine";
import Struktogramm, { TraceTabelle } from "../_components/Struktogramm";
import { anw, falls, fuer, luecke, wenn } from "../_components/struktogramm-typen";
import { struktogrammKurs } from "../_components/lektionen";

export const metadata: Metadata = {
  title: "Struktogramm Lektion 4: Mehrfachauswahl, Verschachtelung, Schreibtischtest",
  description:
    "Die Mehrfachauswahl (FALLS) im Struktogramm und in Pseudocode, Verzweigungen und Schleifen ineinander, und der Schreibtischtest bei verschachtelten Abläufen. Mit Übungen und Quiz.",
  alternates: { canonical: "https://lernarena.app/struktogramm-kurs/lektion-4" },
};

/* ---- Beispiele der Lektion ---- */

// Mehrfachauswahl: Menue
const menue = [
  anw("Eingabe auswahl"),
  falls(
    "auswahl",
    [
      { wert: "1", bloecke: [anw('Ausgabe "Neu"')] },
      { wert: "2", bloecke: [anw('Ausgabe "Öffnen"')] },
      { wert: "3", bloecke: [anw('Ausgabe "Beenden"')] },
    ],
    [anw('Ausgabe "Ungültig"')],
  ),
];
const menueCode = `EINGABE auswahl
FALLS auswahl
    FALL 1:
        AUSGABE "Neu"
    FALL 2:
        AUSGABE "Öffnen"
    FALL 3:
        AUSGABE "Beenden"
    SONST
        AUSGABE "Ungültig"
ENDE FALLS`;

// Dasselbe als Kette von Verzweigungen
const menueKette = [
  anw("Eingabe auswahl"),
  wenn(
    "auswahl == 1",
    [anw('Ausgabe "Neu"')],
    [wenn("auswahl == 2", [anw('Ausgabe "Öffnen"')], [wenn("auswahl == 3", [anw('Ausgabe "Beenden"')], [anw('Ausgabe "Ungültig"')])])],
  ),
];

// Bereiche: drei Stufen als Verzweigungskette und als Bereichs-Faelle
const stufenKette = [
  anw("Eingabe prozent"),
  wenn("prozent >= 80", [anw('note = "gut"')], [wenn("prozent >= 50", [anw('note = "bestanden"')], [anw('note = "nicht bestanden"')])]),
  anw("Ausgabe note"),
];
const stufenFaelle = [
  anw("Eingabe prozent"),
  falls(
    "prozent",
    [
      { wert: "80 bis 100", bloecke: [anw('note = "gut"')] },
      { wert: "50 bis 79", bloecke: [anw('note = "bestanden"')] },
    ],
    [anw('note = "nicht bestanden"')],
  ),
  anw("Ausgabe note"),
];
const notenCode = `EINGABE prozent
WENN prozent >= 92 DANN
    note = 1
SONST
    WENN prozent >= 81 DANN
        note = 2
    SONST
        WENN prozent >= 67 DANN
            note = 3
        SONST
            WENN prozent >= 50 DANN
                note = 4
            SONST
                WENN prozent >= 30 DANN
                    note = 5
                SONST
                    note = 6
                ENDE WENN
            ENDE WENN
        ENDE WENN
    ENDE WENN
ENDE WENN
AUSGABE note`;

// Verzweigung in Schleife: gerade Zahlen zaehlen
const geradeZaehlen = [
  anw("Eingabe n"),
  anw("anzahl = 0"),
  fuer("für i = 1 bis n", [wenn("i MOD 2 == 0", [anw("anzahl = anzahl + 1")])]),
  anw("Ausgabe anzahl"),
];
const geradeZaehlenCode = `EINGABE n
anzahl = 0
FÜR i = 1 BIS n
    WENN i MOD 2 == 0 DANN
        anzahl = anzahl + 1
    ENDE WENN
ENDE FÜR
AUSGABE anzahl`;

// Schleife in Schleife: kleines Einmaleins
const tabelle = [fuer("für i = 1 bis 3", [fuer("für j = 1 bis 3", [anw('Ausgabe i, "x", j, "=", i * j')])])];
const tabelleCode = `FÜR i = 1 BIS 3
    FÜR j = 1 BIS 3
        AUSGABE i, "x", j, "=", i * j
    ENDE FÜR
ENDE FÜR`;

// Verzweigung in Verzweigung
const tarif = [
  anw("Eingabe alter"),
  anw("Eingabe mitglied"),
  wenn("alter >= 18", [wenn("mitglied == wahr", [anw("preis = 8")], [anw("preis = 12")])], [anw("preis = 5")]),
  anw("Ausgabe preis"),
];

// Schreibtischtest: durch 3 teilbare Werte in einem Feld zaehlen
const teilbarZaehlen = [
  anw("anzahl = 0"),
  fuer("für i = 1 bis 5", [wenn("zahlen[i] MOD 3 == 0", [anw("anzahl = anzahl + 1")])]),
  anw("Ausgabe anzahl"),
];

/* ---- Aufgaben ---- */

// 4.1: verschachtelte Zaehlschleifen
const aufgabe41 = [
  anw("summe = 0"),
  fuer("für i = 1 bis 3", [fuer("für j = 1 bis i", [anw("summe = summe + j")]), anw("Ausgabe summe")]),
];

// 4.2: Mehrfachauswahl mit sonst, danach Verzweigung
const aufgabe42 = [
  anw("Eingabe code"),
  falls(
    "code",
    [
      { wert: "1", bloecke: [anw("preis = 10")] },
      { wert: "2", bloecke: [anw("preis = 25")] },
      { wert: "3", bloecke: [anw("preis = 40")] },
    ],
    [anw("preis = 0")],
  ),
  wenn("preis > 20", [anw("preis = preis - 5")]),
  anw("Ausgabe preis"),
];

// 4.4: Ergaenzungsaufgabe mit Luecken
const aufgabe44 = [
  anw("Eingabe grenze"),
  luecke("1"),
  fuer("für i = 1 bis 5", [anw("Eingabe wert"), wenn("(2)", [luecke("3")])]),
  anw("Ausgabe anzahl"),
];
const aufgabe44Loesung = [
  anw("Eingabe grenze"),
  anw("anzahl = 0"),
  fuer("für i = 1 bis 5", [anw("Eingabe wert"), wenn("wert > grenze", [anw("anzahl = anzahl + 1")])]),
  anw("Ausgabe anzahl"),
];

/* ---- Musterloesung der Zeichenaufgabe ---- */

const fizzbuzz = [
  fuer("für i = 1 bis 15", [
    wenn(
      "i MOD 3 == 0 UND i MOD 5 == 0",
      [anw('Ausgabe "FizzBuzz"')],
      [wenn("i MOD 3 == 0", [anw('Ausgabe "Fizz"')], [wenn("i MOD 5 == 0", [anw('Ausgabe "Buzz"')], [anw("Ausgabe i")])])],
    ),
  ]),
];

export default function Lektion4() {
  return (
    <LektionLayout
      kurs={struktogrammKurs}
      nr={4}
      lead="Ein Ausdruck, viele Fälle: die Mehrfachauswahl. Danach das, was Prüfungsaufgaben schwer macht: Verzweigungen in Schleifen, Schleifen in Schleifen. Und der Schreibtischtest als Werkzeug, mit dem du auch verschachtelte Abläufe sicher liest."
      uebungen={8}
      aufgabenText="2 Leseaufgaben, 1 Zeichenaufgabe, 1 Ergänzungsaufgabe, 4 Quizfragen"
    >
      <LsAbschnitt id="mehrfachauswahl" titel="Mehrfachauswahl: FALLS">
        <p>
          Die Verzweigung kennt zwei Wege. Manchmal hängt der Weg aber von einem Wert ab, der viele
          verschiedene Ausprägungen hat: eine Menünummer, ein Wochentag, ein Kürzel. Dafür gibt es
          die <strong>Mehrfachauswahl</strong>. Im Struktogramm steht oben der Ausdruck, darunter
          eine Spalte je Fall und ganz rechts eine Spalte <em>sonst</em> für alle Werte, die zu
          keinem Fall passen.
        </p>
        <div className="sg-paar">
          <div>
            <h4>Struktogramm</h4>
            <Struktogramm titel="Menü" bloecke={menue} />
          </div>
          <div>
            <h4>Pseudocode</h4>
            <CodeBlock code={menueCode} />
          </div>
        </div>
        <p>
          Es läuft genau die Spalte, deren Wert dem Ausdruck entspricht. Für <code>auswahl = 2</code>{" "}
          also „Öffnen“, für <code>auswahl = 9</code> die Sonst-Spalte „Ungültig“. Das SONST ist
          nicht Pflicht; fehlt es und passt kein Fall, passiert einfach nichts und es geht unter
          der Mehrfachauswahl weiter. In Aufgaben mit Eingaben lohnt sich ein SONST fast immer,
          weil es die ungültige Eingabe abfängt.
        </p>
        <p>
          Dieselbe Logik geht auch als Kette von Verzweigungen. Vergleiche:
        </p>
        <Struktogramm
          titel="Menü als Verzweigungskette"
          bloecke={menueKette}
          breite={460}
          caption="Jede weitere Auswahl rückt eine Ebene nach rechts. Bei drei Fällen ist das noch lesbar, bei sieben Wochentagen nicht mehr."
        />
        <p>
          Faustregel: <strong>Mehrfachauswahl</strong>, wenn ein einziger Ausdruck mit mehreren{" "}
          <em>festen Werten</em> verglichen wird. <strong>Verzweigungen</strong>, wenn die Fälle
          unterschiedliche Bedingungen haben („alter &lt; 18“, „mitglied == wahr“) oder Bereiche
          abdecken. Beides ist in der Prüfung erlaubt; die Mehrfachauswahl ist bei vielen Fällen nur
          übersichtlicher und spart Punkte, die man sonst mit verrutschten Zweigen verliert.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="bereiche" titel="Einzelwerte oder Bereiche?">
        <p>
          Die Fälle einer Mehrfachauswahl sind im Grunde <strong>Einzelwerte</strong>: 1, 2, 3 oder{" "}
          <code>"A"</code>, <code>"B"</code>, <code>"C"</code>. Sobald eine Aufgabe Bereiche verlangt („ab 80 Prozent gut, ab 50 bestanden“),
          bist du mit Verzweigungen auf der sicheren Seite, weil dort die Vergleiche <code>&gt;=</code>{" "}
          hingehören:
        </p>
        <div className="sg-paar">
          <div>
            <h4>Verzweigungen (immer korrekt)</h4>
            <Struktogramm titel="Drei Stufen" bloecke={stufenKette} />
          </div>
          <div>
            <h4>Bereichs-Fälle (in manchen Lösungshinweisen)</h4>
            <Struktogramm titel="Drei Stufen" bloecke={stufenFaelle} />
          </div>
        </div>
        <p>
          Die rechte Form mit Bereichen als Fallbeschriftung kommt in manchen Lösungshinweisen und
          Lehrbüchern vor und ist dort auch gemeint. Wenn du sie nutzt, müssen die Bereiche
          lückenlos und überschneidungsfrei sein (bei ganzzahligen Prozentwerten: 79 gehört zu „50 bis 79“, 80 zu „80 bis 100“).
          Die Verzweigungskette prüft die Grenzen von oben nach unten, deshalb reicht in der zweiten
          Bedingung <code>prozent &gt;= 50</code>: Dass der Wert unter 80 liegt, steht dort schon
          fest. Der IHK-Notenschlüssel mit sechs Stufen sieht als Pseudocode so aus:
        </p>
        <CodeBlock code={notenCode} />
        <p>
          Fünf Verzweigungen, jede im Nein-Zweig der vorigen. Die Reihenfolge der Grenzen (92, 81,
          67, 50, 30) muss fallend sein, sonst fängt eine frühere Bedingung Werte ab, die einer
          späteren gehören. Wer die Bedingungen in beliebiger Reihenfolge prüfen will, braucht
          vollständige Bereiche wie <code>prozent &gt;= 81 UND prozent &lt; 92</code>.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="verschachtelung" titel="Verschachtelung: Blöcke in Blöcken">
        <p>
          Jeder Zweig und jeder Rumpf darf wieder beliebige Bausteine enthalten. Das nennt man{" "}
          <strong>Verschachtelung</strong>, und sie kommt häufig in Prüfungsaufgaben vor. Die
          Regel zum Lesen ist in beiden Schreibweisen gleich: Im Pseudocode zeigt die{" "}
          <strong>Einrückung</strong> die Tiefe, im Struktogramm zeigen es die{" "}
          <strong>Kästen</strong>, die ineinander liegen. Drei Kombinationen musst du kennen.
        </p>
        <h4>Verzweigung in Schleife</h4>
        <p>
          Die häufigste Form: Eine Schleife geht Werte durch, und für jeden Wert wird geprüft, ob er
          eine Eigenschaft hat. Beispiel: Wie viele gerade Zahlen gibt es von 1 bis n?
        </p>
        <div className="sg-paar">
          <div>
            <h4>Struktogramm</h4>
            <Struktogramm titel="Gerade Zahlen zählen" bloecke={geradeZaehlen} />
          </div>
          <div>
            <h4>Pseudocode</h4>
            <CodeBlock code={geradeZaehlenCode} />
          </div>
        </div>
        <p>
          Die Verzweigung liegt <em>im</em> Rumpf und wird bei jedem Durchlauf neu geprüft. Der
          Zähler <code>anzahl</code> wird vor der Schleife initialisiert, nicht im Rumpf; sonst
          würde er bei jedem Durchlauf wieder auf 0 gesetzt. Für n = 7 zählt die Schleife 2, 4 und
          6, Ausgabe 3.
        </p>
        <h4>Schleife in Schleife</h4>
        <p>
          Die innere Schleife läuft bei <em>jedem</em> Durchlauf der äußeren komplett durch. Das
          kleine Einmaleins von 1 bis 3:
        </p>
        <div className="sg-paar">
          <div>
            <h4>Struktogramm</h4>
            <Struktogramm titel="Einmaleins bis 3" bloecke={tabelle} />
          </div>
          <div>
            <h4>Pseudocode</h4>
            <CodeBlock code={tabelleCode} />
          </div>
        </div>
        <p>
          Ausgegeben werden neun Zeilen: 1 x 1 = 1, 1 x 2 = 2, 1 x 3 = 3, dann 2 x 1 = 2, 2 x 2 = 4,
          2 x 3 = 6, dann 3 x 1 = 3, 3 x 2 = 6, 3 x 3 = 9. Die äußere Schleife hat 3 Durchläufe,
          die innere in jedem davon ebenfalls 3, zusammen 3 · 3 = 9 Ausgaben. Merke: Der innere
          Zähler heißt anders als der äußere (i und j), und der innere Rumpf ist zwei Ebenen tief.
        </p>
        <h4>Verzweigung in Verzweigung</h4>
        <p>
          Das kennst du aus Lektion 2: Im Ja- oder im Nein-Zweig steht eine weitere Frage. Sie wird
          nur gestellt, wenn der Weg dorthin überhaupt genommen wird.
        </p>
        <Struktogramm
          titel="Eintrittspreis"
          bloecke={tarif}
          breite={460}
          caption="Erst die Frage nach dem Alter, dann nur bei Erwachsenen die Frage nach der Mitgliedschaft. Für alter = 15 wird mitglied gar nicht geprüft, preis ist 5."
        />
        <LsHinweis titel="Ebenen zählen" icon="buch" label="Lesetipp">
          <p>
            Wenn ein Struktogramm unübersichtlich wird, nummeriere die Ebenen: Der äußerste Kasten
            ist Ebene 0, alles im ersten Rumpf oder Zweig Ebene 1, und so weiter. Beim Übersetzen in
            Pseudocode entspricht jede Ebene einer Einrückung um vier Leerzeichen. Beim Lesen
            fragst du bei jeder Anweisung: Auf welcher Ebene bin ich, und wie oft läuft diese Ebene?
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="schreibtischtest" titel="Der Schreibtischtest systematisch">
        <p>
          Aus Lektion 1 und 3 kennst du den <strong>Schreibtischtest</strong> (Wertetabelle) schon
          als Werkzeug. Bei verschachtelten Abläufen brauchst du ihn wirklich, weil man im Kopf
          sehr schnell einen Durchlauf verliert. So legst du ihn an, und so bewerten es typischerweise
          auch die Lösungshinweise:
        </p>
        <ol>
          <li>
            <strong>Eine Spalte je Variable</strong>, dazu eine Spalte „Ausgabe“ und links eine
            Spalte für den Schritt oder die Prüfung. Zähler von Schleifen sind auch Variablen.
          </li>
          <li>
            <strong>Erste Zeile: Initialisierung.</strong> Alle Startwerte eintragen, leere Zellen
            für Variablen, die noch keinen Wert haben.
          </li>
          <li>
            <strong>Mindestens eine Zeile je Durchlauf bzw. Prüfung.</strong> Änderungen innerhalb eines
            Durchlaufs dürfen in einer Zeile stehen. Werte, die gleich bleiben, werden mitgeschrieben.
          </li>
          <li>
            <strong>Bedingungen mit Ergebnis notieren</strong>: „6 MOD 3 == 0: ja“. So siehst du
            später, warum ein Zweig gelaufen ist.
          </li>
          <li>
            <strong>Ausgabe nur in der Ausgabe-Spalte</strong>, und nur in der Zeile, in der die
            Ausgabe-Anweisung wirklich erreicht wird.
          </li>
        </ol>
        <p>
          Das komplette Beispiel: Gegeben ist ein Feld (Array) <code>zahlen</code> mit den fünf
          Werten 6, 7, 9, 4, 12; das erste Element hat den Index 1, also <code>zahlen[1] = 6</code>.
          Gezählt wird, wie viele Werte durch 3 teilbar sind.
        </p>
        <Struktogramm titel="Durch 3 teilbare Werte zählen" bloecke={teilbarZaehlen} breite={380} />
        <TraceTabelle
          spalten={["Prüfung", "i", "zahlen[i]", "anzahl", "Ausgabe"]}
          zeilen={[
            ["Start", "", "", 0, ""],
            ["6 MOD 3 == 0: ja", 1, 6, 1, ""],
            ["7 MOD 3 == 0: nein (Rest 1)", 2, 7, 1, ""],
            ["9 MOD 3 == 0: ja", 3, 9, 2, ""],
            ["4 MOD 3 == 0: nein (Rest 1)", 4, 4, 2, ""],
            ["12 MOD 3 == 0: ja", 5, 12, 3, ""],
            ["Schleife beendet, Ausgabe", 6, "", 3, 3],
          ]}
          caption="Schreibtischtest für zahlen = [6, 7, 9, 4, 12]. Eine Zeile je Durchlauf, weil in jedem Durchlauf eine Bedingung geprüft wird. Am Ende steht i auf 6: Die Prüfung 6 > 5 beendet die Schleife. Ausgabe: 3."
        />
        <LsHinweis titel="Was in der Prüfung gewertet wird" icon="buch" label="Prüfungsbezug">
          <p>
            In vielen Lösungshinweisen zum Schreibtischtest zählen die Zwischenwerte einzeln: jede
            Zeile, in der die Variablen richtig stehen, bringt etwas, und die Endausgabe noch
            einmal. Deshalb lohnt sich die vollständige Tabelle auch dann, wenn du die Ausgabe
            schon im Kopf weißt. Eine Zeile, die sich aus der vorigen richtig ergibt, wird meist
            auch dann gewertet, wenn die vorige einen Folgefehler enthielt.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="uebungen" titel="Übungen">
        <Aufgabe nr="4.1" label="Leseaufgabe 4.1">
          <p>
            Führen Sie einen Schreibtischtest durch: Welche Werte gibt das folgende Struktogramm
            aus, und in welcher Reihenfolge? Lege die Tabelle mit den Spalten i, j, summe und
            Ausgabe an, bevor du die Lösung aufklappst. Achte darauf, auf welcher Ebene die
            Ausgabe steht.
          </p>
          <Struktogramm titel="Verschachtelte Zählschleifen" bloecke={aufgabe41} breite={380} />
          <Loesung>
            <TraceTabelle
              spalten={["Schritt", "i", "j", "summe", "Ausgabe"]}
              zeilen={[
                ["Start", "", "", 0, ""],
                ["i = 1, j = 1", 1, 1, 1, ""],
                ["innere Schleife fertig, Ausgabe", 1, "", 1, 1],
                ["i = 2, j = 1", 2, 1, 2, ""],
                ["i = 2, j = 2", 2, 2, 4, ""],
                ["innere Schleife fertig, Ausgabe", 2, "", 4, 4],
                ["i = 3, j = 1", 3, 1, 5, ""],
                ["i = 3, j = 2", 3, 2, 7, ""],
                ["i = 3, j = 3", 3, 3, 10, ""],
                ["innere Schleife fertig, Ausgabe", 3, "", 10, 10],
              ]}
            />
            <p>
              Ausgabe: <strong>1, 4, 10</strong>. Die innere Schleife läuft „für j = 1 bis i“, also
              beim ersten Mal einmal, dann zweimal, dann dreimal, zusammen sechs Durchläufe. Die
              Ausgabe steht im Rumpf der äußeren, aber außerhalb der inneren Schleife und wird
              deshalb dreimal erreicht, nicht sechsmal und nicht einmal. Wer nur „10“ notiert, hat
              die Ausgabe unter die äußere Schleife gesetzt; wer sechs Zahlen notiert, hat sie in
              die innere gesetzt.
            </p>
          </Loesung>
        </Aufgabe>

        <Aufgabe nr="4.2" label="Leseaufgabe 4.2">
          <p>
            Ermitteln Sie die Ausgabe des Struktogramms für die Eingaben <code>code = 2</code>,{" "}
            <code>code = 3</code> und <code>code = 7</code>.
          </p>
          <Struktogramm titel="Preis nach Code" bloecke={aufgabe42} breite={460} />
          <Loesung>
            <ol>
              <li>
                code = 2: Fall 2, preis = 25. Dann <code>25 &gt; 20</code>: ja, preis = 20. Ausgabe{" "}
                <strong>20</strong>.
              </li>
              <li>
                code = 3: Fall 3, preis = 40. <code>40 &gt; 20</code>: ja, preis = 35. Ausgabe{" "}
                <strong>35</strong>.
              </li>
              <li>
                code = 7: kein Fall passt, also sonst, preis = 0. <code>0 &gt; 20</code>: nein, preis
                bleibt 0. Ausgabe <strong>0</strong>.
              </li>
            </ol>
            <p>
              Die Verzweigung nach der Mehrfachauswahl liegt außerhalb und wird in jedem Fall
              geprüft, auch nach dem Sonst-Zweig. Typischer Fehler: den Abzug nur bei Fall 3
              anzuwenden oder ihn für den Sonst-Fall zu vergessen.
            </p>
          </Loesung>
        </Aufgabe>

        <Zeichenaufgabe
          nr="4.3"
          toolHinweis={false}
          loesung={<Struktogramm titel="Fizz Buzz bis 15" bloecke={fizzbuzz} breite={460} />}
          erklaerung={
            <p>
              Der Fall „durch beides teilbar“ muss <em>zuerst</em> geprüft werden. Stünde{" "}
              <code>i MOD 3 == 0</code> zuerst, würde die 15 schon dort als „Fizz“ ausgegeben und
              „FizzBuzz“ nie erreicht. Ausgabe der Reihe nach: 1, 2, Fizz, 4, Buzz, Fizz, 7, 8,
              Fizz, Buzz, 11, Fizz, 13, 14, FizzBuzz. Gleichwertig: <code>i MOD 15 == 0</code> als
              erste Bedingung, oder drei einseitige Verzweigungen mit einem Merker{" "}
              <code>ausgegeben</code>, der am Ende entscheidet, ob die Zahl selbst ausgegeben wird.
            </p>
          }
          bewertung={[
            "Zählschleife von 1 bis 15 (alternativ kopfgesteuert mit eigenem Zähler)",
            "Teilbarkeit mit MOD geprüft",
            "Der Fall „durch 3 und 5“ wird vor den Einzelfällen geprüft (oder gleichwertig gelöst, etwa mit MOD 15 oder Merker)",
            "Alle vier Ausgaben vorhanden, die Zahl selbst nur, wenn keine Bedingung zutrifft",
            "Verschachtelung sauber gezeichnet: Verzweigungen im Rumpf, jede weitere im Nein-Zweig",
          ]}
        >
          <p>
            Entwerfen Sie das Struktogramm: Für die Zahlen 1 bis 15 soll jeweils eine Zeile
            ausgegeben werden. Ist die Zahl durch 3 und durch 5 teilbar, wird „FizzBuzz“
            ausgegeben; ist sie nur durch 3 teilbar, „Fizz“; nur durch 5, „Buzz“; sonst die Zahl
            selbst. Prüfe deine Lösung mit 9, 10 und 15.
          </p>
        </Zeichenaufgabe>

        <Aufgabe nr="4.4" label="Ergänzungsaufgabe 4.4">
          <p>
            Ergänzen Sie das Struktogramm an den Stellen (1), (2) und (3): Ein Grenzwert wird
            eingelesen, danach fünf Werte nacheinander. Am Ende soll ausgegeben werden, wie viele
            der fünf Werte <em>über</em> dem Grenzwert liegen. Lücke (2) steht im Kopf der
            Verzweigung.
          </p>
          <Struktogramm titel="Werte über der Grenze zählen" bloecke={aufgabe44} breite={400} />
          <Loesung>
            <Struktogramm titel="Werte über der Grenze zählen" bloecke={aufgabe44Loesung} breite={400} />
            <p>
              (1) <code>anzahl = 0</code>: die Initialisierung des Zählers, vor der Schleife. (2){" "}
              <code>wert &gt; grenze</code>: „über“ heißt echt größer, nicht <code>&gt;=</code>. (3){" "}
              <code>anzahl = anzahl + 1</code>: die Zählanweisung im Ja-Zweig. Probe mit grenze = 10
              und den Werten 4, 12, 10, 15, 7: Nur 12 und 15 liegen darüber, Ausgabe 2. Die 10
              zählt nicht, weil sie nicht über der Grenze liegt.
            </p>
          </Loesung>
        </Aufgabe>
      </LsAbschnitt>

      <LsAbschnitt id="quiz" titel="Jetzt selbst testen">
        <p style={{ marginBottom: 18 }}>Vier Fragen zu Mehrfachauswahl, Verschachtelung und Schreibtischtest.</p>
        <QuizFrage
          nr={1}
          von={4}
          frage="Eine Wochentagsnummer 1 bis 7 soll in den Namen umgewandelt werden. Welche Struktur passt am besten?"
          optionen={[
            { text: "Mehrfachauswahl mit sieben Fällen und SONST für ungültige Nummern", richtig: true },
            { text: "Eine Zählschleife von 1 bis 7", richtig: false },
            { text: "Eine zweiseitige Verzweigung", richtig: false },
            { text: "Eine fußgesteuerte Schleife", richtig: false },
          ]}
          erklaerung="Ein Ausdruck, sieben feste Einzelwerte: das ist der Fall für die Mehrfachauswahl. Eine Kette aus sieben verschachtelten Verzweigungen (mit SONST für ungültige Nummern) wäre auch richtig, aber unübersichtlich."
        />
        <QuizFrage
          nr={2}
          von={4}
          frage="FÜR i = 1 BIS 4 enthält FÜR j = 1 BIS 3 mit einer Ausgabe im inneren Rumpf. Wie oft wird ausgegeben?"
          optionen={[
            { text: "12-mal", richtig: true },
            { text: "7-mal", richtig: false },
            { text: "4-mal", richtig: false },
            { text: "3-mal", richtig: false },
          ]}
          erklaerung="Die innere Schleife läuft bei jedem der 4 äußeren Durchläufe 3-mal: 4 · 3 = 12. Wer 7 sagt, hat addiert statt multipliziert."
        />
        <QuizFrage
          nr={3}
          von={4}
          frage="Eine Mehrfachauswahl hat die Fälle 1, 2 und 3, aber kein SONST. Der Ausdruck hat den Wert 5. Was passiert?"
          optionen={[
            { text: "Kein Fall läuft; es geht mit der Anweisung nach der Mehrfachauswahl weiter", richtig: true },
            { text: "Der letzte Fall (3) wird ausgeführt", richtig: false },
            { text: "Das Struktogramm ist ungültig", richtig: false },
            { text: "Der erste Fall (1) wird ausgeführt", richtig: false },
          ]}
          erklaerung="Ohne SONST ist der Fall „kein Treffer“ einfach leer, wie der leere Nein-Zweig einer einseitigen Verzweigung. Danach geht es normal weiter. Ein SONST ist nur nötig, wenn für diesen Fall etwas geschehen soll."
        />
        <QuizFrage
          nr={4}
          von={4}
          frage="Wie viele Zeilen bekommt der Schreibtischtest mindestens?"
          optionen={[
            { text: "Eine je Schleifendurchlauf bzw. je geprüfter Bedingung; Änderungen innerhalb eines Durchlaufs dürfen in einer Zeile stehen", richtig: true },
            { text: "Eine für das Ergebnis am Ende der Schleife", richtig: false },
            { text: "Nur bei einer Ausgabe", richtig: false },
            { text: "Einmal pro Variable", richtig: false },
          ]}
          erklaerung="Jede Zeile ist ein Zustand nach einem Durchlauf oder einer Prüfung. Wer nur das Ergebnis am Ende notiert, verliert die Zwischenwerte, die in vielen Lösungshinweisen einzeln gewertet werden. Mehrere Änderungen innerhalb eines Durchlaufs dürfen in einer Zeile stehen."
        />
      </LsAbschnitt>
    </LektionLayout>
  );
}
