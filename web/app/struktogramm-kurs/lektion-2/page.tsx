import type { Metadata } from "next";
import { LsAbschnitt, LsHinweis } from "../../lernen/_components/LsBausteine";
import QuizFrage from "../../lernen/_components/QuizFrage";
import LektionLayout from "../../components/kurs/LektionLayout";
import { Aufgabe, CodeBlock, Loesung, Zeichenaufgabe } from "../../components/kurs/KursBausteine";
import Struktogramm, { TraceTabelle } from "../_components/Struktogramm";
import { anw, wenn } from "../_components/struktogramm-typen";
import { struktogrammKurs } from "../_components/lektionen";

export const metadata: Metadata = {
  title: "Struktogramm Lektion 2: Sequenz, Verzweigung und Operatoren",
  description:
    "Sequenz, einseitige und zweiseitige Verzweigung im Struktogramm und in Pseudocode, dazu Vergleiche, UND/ODER/NICHT, DIV und MOD. Mit Schreibtischtests und Zeichenaufgaben.",
  alternates: { canonical: "https://lernarena.app/struktogramm-kurs/lektion-2" },
};

/* ---- Beispiele der Lektion ---- */

// Sequenz: Eingabe, Rechnung, Ausgabe
const rechnung = [
  anw("Eingabe preis"),
  anw("Eingabe menge"),
  anw("gesamt = preis * menge"),
  anw("Ausgabe gesamt"),
];
const rechnungCode = `EINGABE preis
EINGABE menge
gesamt = preis * menge
AUSGABE gesamt`;

// Ueberschreiben: der Wert von a geht verloren
const ueberschreiben = [anw("a = 5"), anw("b = 7"), anw("a = b"), anw("b = a"), anw("Ausgabe a, b")];

// Einseitige Verzweigung
const jugend = [anw("Eingabe alter"), wenn("alter < 18", [anw('Ausgabe "Jugendtarif"')]), anw('Ausgabe "Vielen Dank"')];
const jugendCode = `EINGABE alter
WENN alter < 18 DANN
    AUSGABE "Jugendtarif"
ENDE WENN
AUSGABE "Vielen Dank"`;

// Zweiseitige Verzweigung: Rabatt
const rabatt = [
  anw("Eingabe bestellwert"),
  wenn("bestellwert >= 100", [anw("rabatt = 10")], [anw("rabatt = 0")]),
  anw("Ausgabe rabatt"),
];
const rabattCode = `EINGABE bestellwert
WENN bestellwert >= 100 DANN
    rabatt = 10
SONST
    rabatt = 0
ENDE WENN
AUSGABE rabatt`;

// Dieselbe Logik einseitig mit Initialisierung
const rabattEinseitig = [
  anw("Eingabe bestellwert"),
  anw("rabatt = 0"),
  wenn("bestellwert >= 100", [anw("rabatt = 10")]),
  anw("Ausgabe rabatt"),
];

// Versandkosten mit UND
const versand = [
  anw("Eingabe bestellwert"),
  anw("Eingabe land"),
  wenn('bestellwert >= 50 UND land == "DE"', [anw("versand = 0")], [anw("versand = 5")]),
  anw("Ausgabe versand"),
];
const versandCode = `EINGABE bestellwert
EINGABE land
WENN bestellwert >= 50 UND land == "DE" DANN
    versand = 0
SONST
    versand = 5
ENDE WENN
AUSGABE versand`;

// Fehlerbeispiel: rabatt ohne Initialisierung
const ohneInit = [
  anw("Eingabe bestellwert"),
  wenn("bestellwert >= 100", [anw("rabatt = 10")]),
  anw("Ausgabe rabatt"),
];

/* ---- Aufgaben ---- */

// 2.1: Sequenz mit Ueberschreiben
const aufgabe21 = [anw("x = 4"), anw("y = 9"), anw("x = x + y"), anw("y = x - y"), anw("x = y"), anw("Ausgabe x, y")];

// 2.2: Verzweigung mit UND und ODER
const aufgabe22 = [
  anw("Eingabe alter"),
  anw("Eingabe mitglied"),
  wenn("alter < 18 ODER (alter >= 65 UND mitglied == wahr)", [anw('Ausgabe "ermäßigt"')], [anw('Ausgabe "normal"')]),
];

/* ---- Musterloesungen der Zeichenaufgaben ---- */

const porto = [
  anw("Eingabe gewicht"),
  wenn("gewicht <= 20", [anw("porto = 95")], [wenn("gewicht <= 50", [anw("porto = 110")], [anw("porto = 160")])]),
  anw("Ausgabe porto"),
];

const teilbar = [
  anw("Eingabe zahl"),
  wenn("zahl MOD 2 == 0 UND zahl MOD 3 == 0", [anw('Ausgabe "ja"')], [anw('Ausgabe "nein"')]),
];

export default function Lektion2() {
  return (
    <LektionLayout
      kurs={struktogrammKurs}
      nr={2}
      lead="Die zwei einfachsten Bausteine tragen fast jedes Struktogramm: Anweisungen der Reihe nach und eine Frage, die den Weg teilt. Dazu die Operatoren, mit denen du Bedingungen formulierst, und die Fehler, die dabei am häufigsten passieren."
      uebungen={8}
      aufgabenText="2 Leseaufgaben, 2 Zeichenaufgaben, 4 Quizfragen"
    >
      <LsAbschnitt id="sequenz" titel="Sequenz: eine Anweisung nach der anderen">
        <p>
          Eine <strong>Sequenz</strong> ist die einfachste Struktur: Anweisungen, die von oben nach
          unten genau einmal ausgeführt werden. Jede Anweisung bekommt ein eigenes Rechteck. Drei
          Arten von Anweisungen kommen immer wieder vor:
        </p>
        <ul>
          <li>
            <strong>Eingabe</strong>: Ein Wert kommt von außen (Benutzer, Datei) und landet in einer
            Variablen: <code>Eingabe preis</code>.
          </li>
          <li>
            <strong>Zuweisung</strong>: Rechts wird gerechnet, links wird das Ergebnis gespeichert:{" "}
            <code>gesamt = preis * menge</code>. Der alte Wert der Variablen links ist danach weg.
          </li>
          <li>
            <strong>Ausgabe</strong>: Ein Wert oder ein Text wird angezeigt: <code>Ausgabe gesamt</code>.
          </li>
        </ul>
        <div className="sg-paar">
          <div>
            <h4>Struktogramm</h4>
            <Struktogramm titel="Gesamtpreis" bloecke={rechnung} />
          </div>
          <div>
            <h4>Pseudocode</h4>
            <CodeBlock code={rechnungCode} />
          </div>
        </div>
        <p>
          Die <strong>Reihenfolge zählt</strong>. Stünde <code>gesamt = preis * menge</code> vor den
          beiden Eingaben, würde mit Werten gerechnet, die es noch gar nicht gibt. Das klingt banal,
          ist aber die häufigste Fehlerquelle beim Lesen: Man sieht eine Zeile und vergisst, dass die
          Variable zu diesem Zeitpunkt noch einen anderen Wert hatte. Schau dir dieses kleine
          Beispiel an:
        </p>
        <Struktogramm
          titel="Überschreiben"
          bloecke={ueberschreiben}
          breite={300}
          caption="Zwei Variablen, zwei Zuweisungen. Was wird ausgegeben?"
        />
        <TraceTabelle
          spalten={["Schritt", "a", "b", "Ausgabe"]}
          zeilen={[
            ["a = 5", 5, "", ""],
            ["b = 7", 5, 7, ""],
            ["a = b", 7, 7, ""],
            ["b = a", 7, 7, ""],
            ["Ausgabe a, b", 7, 7, "7, 7"],
          ]}
          caption="Schreibtischtest (Wertetabelle): Die 5 ist nach der dritten Zeile verloren, und die vierte Zeile kopiert nur noch eine 7 in eine andere 7."
        />
        <p>
          Wer hier „5, 7“ oder „7, 5“ erwartet, hat die Zuweisung als Tausch gelesen. Eine Zuweisung
          kopiert aber nur in eine Richtung und überschreibt, was links stand. Um zwei Werte
          wirklich zu tauschen, braucht man eine dritte Variable als Zwischenspeicher; das ist ein
          eigenes Grundmuster, das in Lektion 6 drankommt.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="operatoren" titel="Operatoren und Datentypen">
        <p>
          Bedingungen und Rechnungen bestehen aus Operatoren. Diese Liste solltest du auswendig
          können, weil sie in Struktogrammen, Pseudocode und in den Lösungshinweisen gleich aussieht.
        </p>
        <div className="ls-table-wrap">
          <table className="ls-table sg-text-tabelle">
            <thead>
              <tr>
                <th scope="col">Vergleich</th>
                <th scope="col">Bedeutung</th>
                <th scope="col">Beispiel (wahr)</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><code>==</code></td>
                <td>ist gleich</td>
                <td><code>7 == 7</code></td>
              </tr>
              <tr>
                <td><code>!=</code></td>
                <td>ist ungleich</td>
                <td><code>7 != 8</code></td>
              </tr>
              <tr>
                <td><code>&lt;</code>, <code>&lt;=</code></td>
                <td>kleiner, kleiner oder gleich</td>
                <td><code>3 &lt; 4</code>, <code>4 &lt;= 4</code></td>
              </tr>
              <tr>
                <td><code>&gt;</code>, <code>&gt;=</code></td>
                <td>größer, größer oder gleich</td>
                <td><code>9 &gt; 2</code>, <code>2 &gt;= 2</code></td>
              </tr>
            </tbody>
          </table>
        </div>
        <p>
          Ein Vergleich liefert immer einen <strong>Wahrheitswert</strong>: wahr oder falsch. Mehrere
          Vergleiche verknüpfst du mit <strong>UND</strong>, <strong>ODER</strong> und{" "}
          <strong>NICHT</strong>. UND ist nur wahr, wenn beide Seiten wahr sind; ODER ist schon wahr,
          wenn eine Seite wahr ist; NICHT dreht den Wert um.
        </p>
        <div className="ls-table-wrap">
          <table className="ls-table sg-text-tabelle">
            <thead>
              <tr>
                <th scope="col">A</th>
                <th scope="col">B</th>
                <th scope="col">A UND B</th>
                <th scope="col">A ODER B</th>
                <th scope="col">NICHT A</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>wahr</td>
                <td>wahr</td>
                <td>wahr</td>
                <td>wahr</td>
                <td>falsch</td>
              </tr>
              <tr>
                <td>wahr</td>
                <td>falsch</td>
                <td>falsch</td>
                <td>wahr</td>
                <td>falsch</td>
              </tr>
              <tr>
                <td>falsch</td>
                <td>wahr</td>
                <td>falsch</td>
                <td>wahr</td>
                <td>wahr</td>
              </tr>
              <tr>
                <td>falsch</td>
                <td>falsch</td>
                <td>falsch</td>
                <td>falsch</td>
                <td>wahr</td>
              </tr>
            </tbody>
          </table>
        </div>
        <p>
          Beispiel: Für <code>alter = 20</code> ist <code>alter &gt;= 18 UND alter &lt; 65</code> wahr,
          weil beide Teile stimmen. <code>alter &lt; 18 ODER alter &gt;= 65</code> ist falsch, weil
          keiner der beiden Teile stimmt. Und <code>NICHT (alter &lt; 18)</code> ist wahr. Bei
          gemischten Ausdrücken setzt du Klammern, dann muss niemand über die Reihenfolge rätseln.
        </p>
        <h4>DIV und MOD</h4>
        <p>
          Zwei Operatoren, die in Prüfungsaufgaben häufig vorkommen. <strong>DIV</strong> ist die ganzzahlige Division: Es wird
          geteilt und der Rest weggelassen. <strong>MOD</strong> liefert genau diesen Rest.
        </p>
        <div className="ls-table-wrap">
          <table className="ls-table sg-text-tabelle">
            <thead>
              <tr>
                <th scope="col">Ausdruck</th>
                <th scope="col">Ergebnis</th>
                <th scope="col">Rechnung</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><code>17 DIV 5</code></td>
                <td>3</td>
                <td>5 passt dreimal in 17 (3 · 5 = 15)</td>
              </tr>
              <tr>
                <td><code>17 MOD 5</code></td>
                <td>2</td>
                <td>17 − 15 = 2 bleibt übrig</td>
              </tr>
              <tr>
                <td><code>20 DIV 5</code>, <code>20 MOD 5</code></td>
                <td>4, 0</td>
                <td>geht auf, kein Rest</td>
              </tr>
              <tr>
                <td><code>17 / 5</code></td>
                <td>3,4</td>
                <td>normale Division mit Nachkommastellen</td>
              </tr>
            </tbody>
          </table>
        </div>
        <p>
          Die wichtigste Anwendung: <strong>Teilbarkeit</strong>. Eine Zahl ist durch 5 teilbar,
          wenn <code>zahl MOD 5 == 0</code>. Sie ist <strong>gerade</strong>, wenn{" "}
          <code>zahl MOD 2 == 0</code>, und ungerade, wenn <code>zahl MOD 2 == 1</code>. Auch das
          Schaltjahr, ein Klassiker in Aufgaben, ist nur eine Kombination aus MOD und Logik: Ein Jahr
          ist Schaltjahr, wenn <code>jahr MOD 4 == 0 UND (jahr MOD 100 != 0 ODER jahr MOD 400 == 0)</code>.
          Für 2024 ist das wahr, für 1900 falsch, für 2000 wieder wahr. Rechne es einmal nach, dann
          hast du DIV, MOD und die Logik in einem Rutsch geübt.
        </p>
        <h4>Datentypen</h4>
        <p>
          Jede Variable hat einen Typ, und der entscheidet, was Operatoren mit ihr machen. In
          Struktogrammen wird der Typ selten hingeschrieben, aber die Aufgabe nennt ihn meist im
          Text. Vier reichen für diesen Kurs:
        </p>
        <ul>
          <li>
            <strong>Ganzzahl</strong> (Integer): 0, 17, −3. Hier gibt es DIV und MOD; bei „/“ hängt
            die Bedeutung vom Datentyp ab, den die Aufgabe nennt; im Zweifel DIV bzw. / ausdrücklich
            schreiben. Lies genau.
          </li>
          <li>
            <strong>Kommazahl</strong> (Gleitkommazahl, Double): 3,4 oder 19,99. Division liefert
            Nachkommastellen.
          </li>
          <li>
            <strong>Zeichenkette</strong> (String): Text in geraden Anführungszeichen, <code>"DE"</code>.
            Vergleiche mit <code>==</code> prüfen, ob der Text genau gleich ist.
          </li>
          <li>
            <strong>Wahrheitswert</strong> (Boolean): wahr oder falsch. Ergebnis jedes Vergleichs;
            als Variable oft ein <em>Merker</em> wie <code>gefunden</code>.
          </li>
        </ul>
      </LsAbschnitt>

      <LsAbschnitt id="einseitig" titel="Einseitige Verzweigung">
        <p>
          Eine <strong>Verzweigung</strong> stellt eine Frage und führt je nach Antwort andere
          Anweisungen aus. Im Struktogramm steht die Bedingung im Dreieck, darunter links der
          Ja-Zweig und rechts der Nein-Zweig. Bei der <strong>einseitigen</strong> Verzweigung
          passiert nur im Ja-Fall etwas; der Nein-Zweig bleibt leer und wird mit dem Zeichen ∅
          markiert, damit klar ist, dass dort nichts vergessen wurde.
        </p>
        <div className="sg-paar">
          <div>
            <h4>Struktogramm</h4>
            <Struktogramm titel="Jugendtarif" bloecke={jugend} />
          </div>
          <div>
            <h4>Pseudocode</h4>
            <CodeBlock code={jugendCode} />
          </div>
        </div>
        <p>
          Im Pseudocode fehlt einfach das SONST. Wichtig ist, was <em>nach</em> der Verzweigung
          steht: „Vielen Dank“ liegt unterhalb des Verzweigungskastens und wird deshalb in beiden
          Fällen ausgegeben. Alles, was beide Zweige gemeinsam tun sollen, gehört unter die
          Verzweigung, nicht doppelt in beide Zweige.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="zweiseitig" titel="Zweiseitige Verzweigung">
        <p>
          Bei der <strong>zweiseitigen</strong> Verzweigung haben beide Zweige Inhalt. Beispiel:
          Ab einem Bestellwert von 100 gibt es 10 % Rabatt, sonst keinen.
        </p>
        <div className="sg-paar">
          <div>
            <h4>Struktogramm</h4>
            <Struktogramm titel="Rabatt" bloecke={rabatt} />
          </div>
          <div>
            <h4>Pseudocode</h4>
            <CodeBlock code={rabattCode} />
          </div>
        </div>
        <p>
          Genau einer der beiden Zweige läuft, nie beide und nie keiner. Für{" "}
          <code>bestellwert = 100</code> ist „100 &gt;= 100“ wahr, also 10; für 99 ist es falsch,
          also 0. Achte auf die Grenze: „ab 100“ heißt <code>&gt;=</code>, „über 100“ hieße{" "}
          <code>&gt;</code>.
        </p>
        <p>
          Dieselbe Logik lässt sich auch einseitig schreiben, wenn du den Normalfall vorher als
          Startwert setzt:
        </p>
        <Struktogramm
          titel="Rabatt, einseitig"
          bloecke={rabattEinseitig}
          breite={380}
          caption="Erst rabatt = 0 als Startwert, dann nur im Ja-Fall überschreiben. Beide Fassungen sind richtig und werden gleich bewertet."
        />
        <p>
          Bedingungen dürfen zusammengesetzt sein. Versandkostenfrei soll es nur geben, wenn der
          Bestellwert mindestens 50 beträgt <em>und</em> nach Deutschland geliefert wird:
        </p>
        <div className="sg-paar">
          <div>
            <h4>Struktogramm</h4>
            <Struktogramm titel="Versandkosten" bloecke={versand} />
          </div>
          <div>
            <h4>Pseudocode</h4>
            <CodeBlock code={versandCode} />
          </div>
        </div>
        <p>
          Prüfe solche Bedingungen mit Beispielwerten in alle Richtungen: 60 und „DE“ ergibt
          versandfrei; 60 und „AT“ kostet 5, weil das UND beide Teile verlangt; 40 und „DE“ kostet
          ebenfalls 5. Erst wenn alle drei Fälle stimmen, ist die Bedingung richtig.
        </p>
        <LsHinweis titel="Wie die Verzweigung bewertet wird" icon="buch" label="Prüfungsbezug">
          <p>
            In vielen Lösungshinweisen gibt es getrennte Punkte für die richtige Bedingung
            (inklusive der Grenze, also <code>&gt;=</code> statt <code>&gt;</code>), für die
            korrekte Zuordnung der Zweige und für die Ausgabe an der richtigen Stelle. Eine
            einseitige Verzweigung mit Startwert und eine zweiseitige gelten typischerweise als
            gleichwertig.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="fehler" titel="Verschachtelung und typische Fehler">
        <p>
          In jedem Zweig darf wieder eine Verzweigung stehen. So entstehen Ketten wie „bis 20 g:
          95 Cent, sonst: bis 50 g: 110 Cent, sonst: 160 Cent“. Wie du solche Ketten sauber zeichnest
          und wann die Mehrfachauswahl die bessere Wahl ist, zeigt Lektion 4. In Übung 2.3 probierst
          du es schon einmal aus. Vorher die vier Fehler, die bei Verzweigungen am häufigsten
          Punkte kosten:
        </p>
        <ul>
          <li>
            <strong>Bedingung falsch herum.</strong> „Ab 100 Rabatt“ als <code>bestellwert &lt; 100</code>{" "}
            geschrieben. Test: Setze einen Wert ein, der laut Aufgabe in den Ja-Zweig gehört, und prüfe,
            ob die Bedingung dafür wirklich wahr ist.
          </li>
          <li>
            <strong>Zweige vertauscht.</strong> Bedingung richtig, aber „rabatt = 10“ steht im
            Nein-Zweig. Im Struktogramm ist der Ja-Zweig immer links, sofern die Beschriftung nichts
            anderes sagt.
          </li>
          <li>
            <strong>Gleichheit mit = statt ==.</strong> <code>WENN land = "DE"</code> sieht aus wie
            eine Zuweisung. Im Kurs und in vielen Lösungshinweisen steht für den Vergleich{" "}
            <code>==</code>. Wenn du <code>=</code> für den Vergleich nutzt, dann durchgehend und mit{" "}
            <code>:=</code> oder <code>←</code> für die Zuweisung.
          </li>
          <li>
            <strong>Fehlende Initialisierung.</strong> Der gefährlichste Fehler, weil er im
            Struktogramm unauffällig ist:
          </li>
        </ul>
        <Struktogramm
          titel="Rabatt, fehlerhaft"
          bloecke={ohneInit}
          breite={380}
          caption="Für bestellwert = 80 läuft der leere Nein-Zweig, rabatt bekommt nie einen Wert, und die Ausgabe zeigt etwas Undefiniertes. Es fehlt rabatt = 0 vor der Verzweigung (oder ein Nein-Zweig mit rabatt = 0)."
        />
        <LsHinweis titel="Regel für einseitige Verzweigungen" art="warnung">
          <p>
            Wenn eine Variable nach einer einseitigen Verzweigung benutzt wird, muss sie{" "}
            <em>vor</em> der Verzweigung einen Wert bekommen haben. Prüfe das bei jeder Verzweigung,
            die du zeichnest, indem du den Nein-Fall einmal gedanklich durchspielst.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="uebungen" titel="Übungen">
        <Aufgabe nr="2.1" label="Leseaufgabe 2.1">
          <p>
            Führen Sie einen Schreibtischtest durch: Welche Werte werden am Ende dieser Sequenz
            ausgegeben? Notiere nach jeder Zeile die Werte von x und y, bevor du die Lösung aufklappst.
          </p>
          <Struktogramm titel="Sequenz" bloecke={aufgabe21} breite={300} />
          <Loesung>
            <TraceTabelle
              spalten={["Schritt", "x", "y", "Ausgabe"]}
              zeilen={[
                ["x = 4", 4, "", ""],
                ["y = 9", 4, 9, ""],
                ["x = x + y", 13, 9, ""],
                ["y = x - y", 13, 4, ""],
                ["x = y", 4, 4, ""],
                ["Ausgabe x, y", 4, 4, "4, 4"],
              ]}
            />
            <p>
              Ausgabe: <strong>4, 4</strong>. In der Zeile <code>y = x - y</code> wird mit dem{" "}
              <em>neuen</em> x gerechnet (13 − 9 = 4), nicht mit dem alten. Danach überschreibt{" "}
              <code>x = y</code> die 13, und die ist verloren. Wer „13, 4“ ausgibt, hat die letzte
              Zuweisung übersehen; wer „−5, −5“ ausgibt, hat in der vierten Zeile mit dem alten x
              gerechnet (4 − 9 = −5). Wer „9, 4“ erwartet, hat den Tauschtrick im Kopf, dessen letzte
              Zeile <code>x = x - y</code> lautet (Lektion 6).
            </p>
          </Loesung>
        </Aufgabe>

        <Aufgabe nr="2.2" label="Leseaufgabe 2.2">
          <p>
            Ermitteln Sie die Ausgabe des Struktogramms für die folgenden Eingaben. Die Variable{" "}
            <code>mitglied</code> ist ein Wahrheitswert.
          </p>
          <ol>
            <li>alter = 16, mitglied = falsch</li>
            <li>alter = 70, mitglied = falsch</li>
            <li>alter = 70, mitglied = wahr</li>
          </ol>
          <Struktogramm titel="Eintrittspreis" bloecke={aufgabe22} breite={460} />
          <Loesung>
            <ol>
              <li>
                <code>16 &lt; 18</code> ist wahr. Bei ODER reicht eine wahre Seite, der Rest muss
                nicht mehr geprüft werden: <strong>„ermäßigt“</strong>.
              </li>
              <li>
                <code>70 &lt; 18</code> ist falsch. Die Klammer: <code>70 &gt;= 65</code> ist wahr,{" "}
                <code>mitglied == wahr</code> ist falsch, UND daraus ist falsch. Falsch ODER falsch
                ist falsch: <strong>„normal“</strong>.
              </li>
              <li>
                <code>70 &lt; 18</code> ist falsch. Die Klammer: wahr UND wahr ist wahr. Falsch
                ODER wahr ist wahr: <strong>„ermäßigt“</strong>.
              </li>
            </ol>
            <p>
              Der typische Fehler ist Fall 2: Wer das UND wie ein ODER liest, gibt auch dort
              „ermäßigt“ aus. Ohne Klammer hängt die Lesart von der Vorrangregel ab (UND bindet
              stärker als ODER); die Klammer macht sie eindeutig.
            </p>
          </Loesung>
        </Aufgabe>

        <Zeichenaufgabe
          nr="2.3"
          toolHinweis={false}
          loesung={<Struktogramm titel="Porto" bloecke={porto} breite={460} />}
          erklaerung={
            <p>
              Drei Bereiche brauchen zwei Fragen. Die erste Verzweigung trennt „bis 20 g“ ab, im
              Nein-Zweig steht eine zweite Verzweigung für „bis 50 g“, deren Nein-Zweig den Rest
              abdeckt. Die zweite Bedingung darf einfach <code>gewicht &lt;= 50</code> lauten, denn
              dass das Gewicht über 20 liegt, steht an dieser Stelle schon fest. Die Ausgabe gehört
              einmal unter die ganze Verzweigung und nicht dreimal in die Zweige. Ebenfalls richtig:
              drei einseitige Verzweigungen nacheinander mit vollständigen Bedingungen (
              <code>gewicht &gt; 20 UND gewicht &lt;= 50</code>), oder die umgekehrte Reihenfolge
              (erst <code>gewicht &gt; 50</code> prüfen).
            </p>
          }
          bewertung={[
            "Eingabe oben, Ausgabe einmal nach der Verzweigung",
            "Bedingungen mit den richtigen Grenzen (<= 20, <= 50; „bis“ schließt den Wert ein)",
            "Alle drei Bereiche erreichbar, keiner doppelt (verschachtelt oder mit vollständigen Bedingungen nacheinander)",
            "Form: Dreieck mit Bedingung, Ja-Zweig links, innere Verzweigung sauber im Zweig",
          ]}
        >
          <p>
            Entwerfen Sie das Struktogramm: Das Porto eines Briefs hängt vom Gewicht in Gramm ab.
            Bis 20 g kostet er 95 Cent, bis 50 g 110 Cent, darüber 160 Cent. Das Gewicht wird
            eingelesen, das Porto in Cent ausgegeben. Prüfe deine Lösung mit 20, 21 und 50.
          </p>
        </Zeichenaufgabe>

        <Zeichenaufgabe
          nr="2.4"
          toolHinweis={false}
          loesung={<Struktogramm titel="Gerade und durch 3 teilbar" bloecke={teilbar} breite={460} />}
          erklaerung={
            <p>
              Beide Eigenschaften werden mit MOD geprüft und müssen gleichzeitig gelten, also UND.
              Für 12 sind beide Reste 0, Ausgabe „ja“; für 9 ist <code>9 MOD 2 == 1</code>, Ausgabe
              „nein“; für 8 ist <code>8 MOD 3 == 2</code>, ebenfalls „nein“. Gleichwertig und
              kürzer: <code>zahl MOD 6 == 0</code>, denn durch 2 und durch 3 teilbar heißt durch 6
              teilbar. Auch zwei verschachtelte Verzweigungen sind richtig, solange „nein“ in
              beiden Nein-Zweigen ausgegeben wird.
            </p>
          }
          bewertung={[
            "Teilbarkeit mit MOD geprüft (Rest gleich 0), nicht mit DIV oder /",
            "Beide Bedingungen mit UND verknüpft (oder gleichwertig MOD 6, oder verschachtelt)",
            "Beide Ausgaben vorhanden und den richtigen Zweigen zugeordnet",
            "Form: Eingabe, Verzweigung mit Dreieck, Ja-Zweig links",
          ]}
        >
          <p>
            Entwerfen Sie das Struktogramm: Eine Ganzzahl wird eingelesen. Ist sie gerade und
            zugleich durch 3 teilbar, wird „ja“ ausgegeben, sonst „nein“. Prüfe deine Lösung mit
            12, 9 und 8.
          </p>
        </Zeichenaufgabe>
      </LsAbschnitt>

      <LsAbschnitt id="quiz" titel="Jetzt selbst testen">
        <p style={{ marginBottom: 18 }}>Vier Fragen zu Sequenz, Operatoren und Verzweigung.</p>
        <QuizFrage
          nr={1}
          von={4}
          frage="Was ergibt 23 MOD 4?"
          optionen={[
            { text: "3", richtig: true },
            { text: "5", richtig: false },
            { text: "5,75", richtig: false },
            { text: "0", richtig: false },
          ]}
          erklaerung="4 passt fünfmal in 23 (5 · 4 = 20), der Rest ist 23 − 20 = 3. Die 5 wäre 23 DIV 4, die 5,75 das Ergebnis von 23 / 4."
        />
        <QuizFrage
          nr={2}
          von={4}
          frage="Welche Bedingung ist genau dann wahr, wenn zahl ungerade ist?"
          optionen={[
            { text: "zahl MOD 2 == 1", richtig: true },
            { text: "zahl DIV 2 == 1", richtig: false },
            { text: "zahl MOD 2 == 0", richtig: false },
            { text: "zahl / 2 == 0", richtig: false },
          ]}
          erklaerung="Ungerade Zahlen lassen beim Teilen durch 2 den Rest 1, also zahl MOD 2 == 1 (für nicht negative Zahlen; sicherer ist MOD 2 != 0). MOD 2 == 0 prüft auf gerade, DIV 2 == 1 ist nur für 2 und 3 wahr, und zahl / 2 == 0 nur für die 0."
        />
        <QuizFrage
          nr={3}
          von={4}
          frage="a = 3, b = 5. Was ergibt (a < b) UND NICHT (b == 5)?"
          optionen={[
            { text: "falsch", richtig: true },
            { text: "wahr", richtig: false },
            { text: "Das hängt von der Reihenfolge ab", richtig: false },
            { text: "Der Ausdruck ist ungültig", richtig: false },
          ]}
          erklaerung="a < b ist wahr. b == 5 ist wahr, NICHT davon ist falsch. Wahr UND falsch ergibt falsch."
        />
        <QuizFrage
          nr={4}
          von={4}
          frage="Eine einseitige Verzweigung setzt rabatt = 10, wenn bestellwert >= 100. Danach wird rabatt ausgegeben. Was ist das Problem?"
          optionen={[
            { text: "Für Werte unter 100 hat rabatt keinen Wert; es fehlt rabatt = 0 vor der Verzweigung", richtig: true },
            { text: "Einseitige Verzweigungen dürfen keine Zuweisung enthalten", richtig: false },
            { text: "Die Bedingung müsste bestellwert > 100 lauten", richtig: false },
            { text: "Es gibt kein Problem", richtig: false },
          ]}
          erklaerung="Im Nein-Fall passiert nichts, und rabatt wurde vorher nie gesetzt. Entweder vor der Verzweigung rabatt = 0 setzen oder einen Nein-Zweig mit rabatt = 0 ergänzen. Ob >= oder > richtig ist, entscheidet die Aufgabe („ab 100“ heißt >=)."
        />
      </LsAbschnitt>
    </LektionLayout>
  );
}
