import type { Metadata } from "next";
import { LsAbschnitt, LsHinweis } from "../../lernen/_components/LsBausteine";
import QuizFrage from "../../lernen/_components/QuizFrage";
import LektionLayout from "../../components/kurs/LektionLayout";
import { Aufgabe, CodeBlock, Loesung, Zeichenaufgabe } from "../../components/kurs/KursBausteine";
import Struktogramm, { TraceTabelle } from "../_components/Struktogramm";
import { anw, fuer, solange, wenn, wiederholeBis } from "../_components/struktogramm-typen";
import { struktogrammKurs } from "../_components/lektionen";

export const metadata: Metadata = {
  title: "Struktogramm Lektion 3: Schleifen (kopfgesteuert, fußgesteuert, Zählschleife)",
  description:
    "Die drei Schleifenarten im Struktogramm und in Pseudocode: wann welche passt, wie du Durchläufe zählst und Endlosschleifen vermeidest. Mit Schreibtischtests und Zeichenaufgaben.",
  alternates: { canonical: "https://lernarena.app/struktogramm-kurs/lektion-3" },
};

/* ---- Beispiele der Lektion ---- */

// Kopfgesteuert: wie oft laesst sich n halbieren, bis 1 erreicht ist?
const halbieren = [
  anw("Eingabe n"),
  anw("schritte = 0"),
  solange("n > 1", [anw("n = n / 2"), anw("schritte = schritte + 1")]),
  anw("Ausgabe schritte"),
];
const halbierenCode = `EINGABE n
schritte = 0
SOLANGE n > 1
    n = n / 2
    schritte = schritte + 1
ENDE SOLANGE
AUSGABE schritte`;

// Fussgesteuert: Eingabe wiederholen, bis ein gueltiger Wuerfelwert kommt
const wuerfel = [
  wiederholeBis("wurf >= 1 UND wurf <= 6", [anw('Ausgabe "Wurf eingeben (1 bis 6):"'), anw("Eingabe wurf")]),
  anw('Ausgabe "Gültig:", wurf'),
];
const wuerfelCode = `WIEDERHOLE
    AUSGABE "Wurf eingeben (1 bis 6):"
    EINGABE wurf
BIS wurf >= 1 UND wurf <= 6
AUSGABE "Gültig:", wurf`;

// Zaehlschleife: Einmaleins-Reihe
const reihe = [
  anw("Eingabe zahl"),
  fuer("für i = 1 bis 10", [anw('Ausgabe i, "x", zahl, "=", i * zahl')]),
];
const reiheCode = `EINGABE zahl
FÜR i = 1 BIS 10
    AUSGABE i, "x", zahl, "=", i * zahl
ENDE FÜR`;

// Vergleich: dieselbe Zaehlschleife als kopfgesteuerte Schleife
const reiheSolange = [
  anw("Eingabe zahl"),
  anw("i = 1"),
  solange("i <= 10", [anw('Ausgabe i, "x", zahl, "=", i * zahl'), anw("i = i + 1")]),
];

// Durchlaeufe zaehlen: zwei fast gleiche Schleifen
const bisKleiner = [anw("i = 0"), solange("i < 5", [anw("Ausgabe i"), anw("i = i + 1")])];
const bisKleinerGleich = [anw("i = 0"), solange("i <= 5", [anw("Ausgabe i"), anw("i = i + 1")])];

/* ---- Musterloesungen der Zeichenaufgaben ---- */

const fakultaet = [
  anw("Eingabe n"),
  anw("ergebnis = 1"),
  fuer("für i = 2 bis n", [anw("ergebnis = ergebnis * i")]),
  anw("Ausgabe ergebnis"),
];

const passwort = [
  anw("versuche = 0"),
  wiederholeBis('passwort == "geheim" ODER versuche == 3', [
    anw('Ausgabe "Passwort:"'),
    anw("Eingabe passwort"),
    anw("versuche = versuche + 1"),
  ]),
  wenn('passwort == "geheim"', [anw('Ausgabe "Willkommen"')], [anw('Ausgabe "Gesperrt"')]),
];

export default function Lektion3() {
  return (
    <LektionLayout
      kurs={struktogrammKurs}
      nr={3}
      lead="Drei Schleifenarten, eine Frage: Wird die Bedingung vor oder nach dem Rumpf geprüft, oder zählt die Schleife selbst? Danach kannst du jede Wiederholung zeichnen und ihre Durchläufe sicher abzählen."
      uebungen={7}
      aufgabenText="1 Leseaufgabe, 2 Zeichenaufgaben, 4 Quizfragen"
    >
      <LsAbschnitt id="ueberblick" titel="Drei Arten, eine Idee">
        <p>
          Eine Schleife wiederholt einen Block von Anweisungen, den <strong>Rumpf</strong>. Was die
          drei Arten unterscheidet, ist nur, <em>wann</em> entschieden wird, ob der Rumpf (noch
          einmal) läuft:
        </p>
        <ul>
          <li>
            <strong>Kopfgesteuert</strong> (SOLANGE): Die Bedingung wird <em>vor</em> jedem
            Durchlauf geprüft. Ist sie beim ersten Mal falsch, läuft der Rumpf nie.
          </li>
          <li>
            <strong>Fußgesteuert</strong> (WIEDERHOLE … BIS): Der Rumpf läuft erst, dann wird
            geprüft. Der Rumpf läuft also <em>mindestens einmal</em>.
          </li>
          <li>
            <strong>Zählschleife</strong> (FÜR): Eine kopfgesteuerte Schleife, bei der die Anzahl
            der Durchläufe von vornherein feststeht. Der Zähler wird automatisch hochgezählt.
          </li>
        </ul>
        <p>
          Im Struktogramm erkennst du alle drei am <strong>Balken links</strong>, der den Rumpf
          umklammert. Die Bedingung steht bei kopfgesteuerten Schleifen und Zählschleifen in der
          Kopfzeile, bei fußgesteuerten in der Fußzeile.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="kopf" titel="Kopfgesteuert: SOLANGE">
        <p>
          Die allgemeinste Schleife. Du nimmst sie, wenn du <em>nicht weißt</em>, wie oft wiederholt
          werden muss, und wenn es sein kann, dass gar nicht wiederholt werden muss. Beispiel: Wie
          oft lässt sich eine Zahl halbieren, bis sie bei 1 oder darunter ankommt?
        </p>
        <div className="sg-paar">
          <div>
            <h4>Struktogramm</h4>
            <Struktogramm titel="Halbieren zählen" bloecke={halbieren} />
          </div>
          <div>
            <h4>Pseudocode</h4>
            <CodeBlock code={halbierenCode} />
          </div>
        </div>
        <p>
          Für <code>n = 8</code> passiert Folgendes: 8 ist größer als 1, also halbieren: 4, ein
          Schritt. 4 ist größer als 1: 2, zwei Schritte. 2 ist größer als 1: 1, drei Schritte. 1
          ist nicht größer als 1, die Schleife endet, Ausgabe 3.
        </p>
        <TraceTabelle
          spalten={["Prüfung n > 1", "n", "schritte"]}
          zeilen={[
            ["Start", 8, 0],
            ["8 > 1: ja", 4, 1],
            ["4 > 1: ja", 2, 2],
            ["2 > 1: ja", 1, 3],
            ["1 > 1: nein, Ende", 1, 3],
          ]}
          caption="Schreibtischtest (Wertetabelle) für n = 8. Bei der kopfgesteuerten Schleife lohnt sich eine Spalte für die Prüfung. Die letzte Prüfung ist immer die, bei der die Schleife endet."
        />
        <p>
          Und für <code>n = 1</code>? Die erste Prüfung „1 &gt; 1“ ist schon falsch. Der Rumpf
          läuft nie, ausgegeben wird der Startwert 0. Das ist das typische Verhalten der
          kopfgesteuerten Schleife: <strong>null Durchläufe sind möglich</strong>.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="fuss" titel="Fußgesteuert: WIEDERHOLE … BIS">
        <p>
          Die fußgesteuerte Schleife nimmst du, wenn der Rumpf auf jeden Fall einmal laufen muss,
          bevor überhaupt geprüft werden kann. Das klassische Beispiel ist eine Eingabe, die so
          lange wiederholt wird, bis sie gültig ist. Man muss ja erst etwas eingeben, bevor man es
          prüfen kann.
        </p>
        <div className="sg-paar">
          <div>
            <h4>Struktogramm</h4>
            <Struktogramm titel="Gültigen Wurf einlesen" bloecke={wuerfel} />
          </div>
          <div>
            <h4>Pseudocode</h4>
            <CodeBlock code={wuerfelCode} />
          </div>
        </div>
        <p>
          Achte auf die Logik der Bedingung: Bei <strong>WIEDERHOLE … BIS</strong> steht unten die{" "}
          <em>Abbruchbedingung</em>. Die Schleife läuft, <em>bis</em> sie wahr ist. Bei SOLANGE ist
          es umgekehrt: Dort steht die <em>Fortsetzungsbedingung</em>, die Schleife läuft,{" "}
          <em>solange</em> sie wahr ist. Wer beides verwechselt, baut eine Schleife, die genau dann
          endet, wenn sie weiterlaufen sollte.
        </p>
        <LsHinweis titel="Manche Lösungshinweise schreiben es anders" icon="buch" label="Schreibweise">
          <p>
            Statt „BIS Bedingung“ siehst du gelegentlich „SOLANGE Bedingung“ in der Fußzeile, so wie
            es Java und C mit <code>do … while</code> machen. Dann steht dort die
            Fortsetzungsbedingung, also das Gegenteil: <code>SOLANGE wurf &lt; 1 ODER wurf &gt; 6</code>.
            Beides ist erlaubt. Entscheidend ist, dass aus dem Wort klar wird, ob die Bedingung
            fortsetzt oder beendet.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="zaehl" titel="Zählschleife: FÜR">
        <p>
          Wenn du vorher weißt, wie oft wiederholt wird, nimmst du die Zählschleife. Sie hat einen{" "}
          <strong>Zähler</strong> mit Startwert und Endwert; nach jedem Durchlauf wird er
          automatisch um eins erhöht. Beispiel: die Einmaleins-Reihe einer Zahl.
        </p>
        <div className="sg-paar">
          <div>
            <h4>Struktogramm</h4>
            <Struktogramm titel="Einmaleins-Reihe" bloecke={reihe} />
          </div>
          <div>
            <h4>Pseudocode</h4>
            <CodeBlock code={reiheCode} />
          </div>
        </div>
        <p>
          Die Zählschleife ist nur eine Abkürzung. Dieselbe Reihe mit SOLANGE braucht zwei Zeilen
          mehr: den Startwert vor der Schleife und das Hochzählen im Rumpf. Die Prüfung wandert vom
          Kopf der Zählschleife in den Kopf der SOLANGE-Schleife. Genau diese drei Dinge (Start,
          Prüfung, Schritt) stecken in der Kopfzeile der Zählschleife:
        </p>
        <Struktogramm
          titel="Einmaleins-Reihe mit SOLANGE"
          bloecke={reiheSolange}
          breite={380}
          caption="Das Gleiche kopfgesteuert. Merke: Startwert vor der Schleife, Prüfung im Kopf, Hochzählen als letzte Zeile im Rumpf. Wer das Hochzählen vergisst, hat eine Endlosschleife."
        />
        <p>
          Zählschleifen können auch <strong>rückwärts</strong> laufen („für i = 10 bis 1,
          Schrittweite −1“) oder in anderen Schritten („für i = 0 bis 100, Schrittweite 5“). Wenn
          nichts dabeisteht, ist die Schrittweite 1.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="wahl" titel="Wann welche Schleife?">
        <div className="ls-table-wrap">
          <table className="ls-table sg-text-tabelle">
            <thead>
              <tr>
                <th scope="col">Situation in der Aufgabe</th>
                <th scope="col">Schleife</th>
                <th scope="col">Signalwörter</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>Anzahl steht vorher fest: alle Elemente einer Liste, 1 bis n, zehnmal</td>
                <td>Zählschleife</td>
                <td>„für jedes“, „n-mal“, „von 1 bis“, „alle Einträge“</td>
              </tr>
              <tr>
                <td>Unbekannte Anzahl, und null Durchläufe sind möglich</td>
                <td>Kopfgesteuert</td>
                <td>„solange noch“, „während noch …“, „während“</td>
              </tr>
              <tr>
                <td>Rumpf muss mindestens einmal laufen: Eingabe, Menü, Spielrunde</td>
                <td>Fußgesteuert</td>
                <td>„wiederhole, bis“, „erneut eingeben, falls“, „mindestens einmal“</td>
              </tr>
            </tbody>
          </table>
        </div>
        <p>
          Im Zweifel ist die kopfgesteuerte Schleife nie falsch: Jede Zählschleife und jede
          fußgesteuerte Schleife lässt sich als SOLANGE schreiben. Die Prüfer erwarten aber die
          passende Art, wenn die Aufgabe sie nahelegt. „Der Benutzer soll so lange eingeben, bis
          der Wert gültig ist“ legt die fußgesteuerte Form nahe; eine kopfgesteuerte Lösung mit
          einer Eingabe vor der Schleife ist ebenfalls richtig, nur länger.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="zaehlen" titel="Durchläufe zählen">
        <p>
          Die häufigste Fehlerquelle bei Schleifen ist ein Durchlauf zu viel oder zu wenig.
          Vergleiche diese beiden Schleifen, die sich nur in einem Zeichen unterscheiden:
        </p>
        <div className="sg-paar">
          <div>
            <h4>Bedingung i &lt; 5</h4>
            <Struktogramm bloecke={bisKleiner} />
          </div>
          <div>
            <h4>Bedingung i &lt;= 5</h4>
            <Struktogramm bloecke={bisKleinerGleich} />
          </div>
        </div>
        <p>
          Links werden 0, 1, 2, 3, 4 ausgegeben: <strong>fünf</strong> Durchläufe. Rechts kommt
          die 5 dazu: <strong>sechs</strong> Durchläufe. Faustregeln, die du auswendig können
          solltest:
        </p>
        <ul>
          <li>
            Zählschleife „für i = a bis b“: <strong>b − a + 1</strong> Durchläufe. „für i = 1 bis
            10“ sind 10, „für i = 0 bis 10“ sind 11.
          </li>
          <li>
            SOLANGE mit Zähler ab 0 und „i &lt; n“: <strong>n</strong> Durchläufe. Mit „i &lt;= n“:
            n + 1.
          </li>
          <li>
            Bei jeder anderen Schleife: nicht raten, sondern <strong>Schreibtischtest</strong>. Zwei
            Minuten Tabelle sind billiger als ein verlorener Punkt.
          </li>
        </ul>
        <LsHinweis titel="Endlosschleifen erkennen" art="warnung">
          <p>
            Eine Schleife endet nur, wenn sich im Rumpf etwas ändert, das in der Bedingung
            vorkommt. Prüfe bei jeder Schleife, die du zeichnest: Welche Variable steht in der
            Bedingung, und wo im Rumpf wird sie verändert? Findest du keine Stelle, hast du eine
            Endlosschleife. In der Prüfung kostet das typischerweise Punkte, bei der Zählschleife
            passiert es nicht, solange du den Zähler im Rumpf nicht veränderst (was du nie tun
            solltest).
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="uebungen" titel="Übungen">
        <Aufgabe nr="3.1" label="Leseaufgabe 3.1">
          <p>
            Führen Sie einen Schreibtischtest durch: Was gibt „Halbieren zählen“ aus dem Abschnitt
            ‚Kopfgesteuert: SOLANGE‘ für <code>n = 20</code> aus? Achtung, die Division ergibt
            hier auch Nachkommastellen (20 / 2 = 10, 10 / 2 = 5, 5 / 2 = 2,5 …). Führe ihn
            auf Papier, bevor du die Lösung aufklappst.
          </p>
          <Loesung>
            <TraceTabelle
              spalten={["Prüfung n > 1", "n", "schritte"]}
              zeilen={[
                ["Start", 20, 0],
                ["20 > 1: ja", 10, 1],
                ["10 > 1: ja", 5, 2],
                ["5 > 1: ja", "2,5", 3],
                ["2,5 > 1: ja", "1,25", 4],
                ["1,25 > 1: ja", "0,625", 5],
                ["0,625 > 1: nein, Ende", "0,625", 5],
              ]}
            />
            <p>
              Ausgabe: <strong>5</strong>. Der häufigste Fehler ist, bei 1,25 aufzuhören: 1,25 ist
              aber größer als 1, also läuft der Rumpf noch einmal. Wäre n eine Ganzzahl und / eine
              ganzzahlige Division (DIV), lautete das Ergebnis 4 (20, 10, 5, 2, 1). Achte in der
              Prüfung auf den Datentyp.
            </p>
          </Loesung>
        </Aufgabe>

        <Zeichenaufgabe
          nr="3.2"
          toolHinweis={false}
          loesung={<Struktogramm titel="Fakultät" bloecke={fakultaet} breite={380} />}
          erklaerung={
            <p>
              Die Anzahl der Multiplikationen steht mit n fest, also Zählschleife. Der Startwert
              ist 1 und nicht 0, weil 0 mal irgendetwas immer 0 bleibt. Ob die Schleife bei 1 oder
              bei 2 beginnt, ist egal (1 mal 1 ändert nichts); beide Lösungen sind richtig. Für n =
              0 und n = 1 läuft die Schleife nicht und die Ausgabe ist 1, was mathematisch stimmt.
            </p>
          }
          bewertung={[
            "Passende Schleife (Zählschleife; alternativ kopfgesteuert mit eigenem Zähler) korrekt beschriftet (Start, Ende)",
            "ergebnis mit 1 initialisiert, nicht mit 0",
            "Multiplikation im Rumpf, Ausgabe nach der Schleife",
            "Form: Eingabe oben, Balken links, Ausgabe außerhalb des Rumpfs",
          ]}
        >
          <p>
            Entwerfen Sie das Struktogramm: Eine Zahl n wird eingelesen und die Fakultät n!
            ausgegeben, also das Produkt 1 · 2 · 3 · … · n. Für n = 4 soll 24 herauskommen.
          </p>
        </Zeichenaufgabe>

        <Zeichenaufgabe
          nr="3.3"
          toolHinweis={false}
          loesung={<Struktogramm titel="Passwort mit drei Versuchen" bloecke={passwort} breite={400} />}
          erklaerung={
            <p>
              Eine Eingabe muss vor der ersten Prüfung stattfinden, also fußgesteuert. Die Schleife
              endet aus zwei Gründen, deshalb steht ein ODER in der Abbruchbedingung. Den Zähler
              vor der Schleife auf 0 setzen und im Rumpf erhöhen. Nach der Schleife weiß man noch
              nicht, <em>warum</em> sie geendet hat, deshalb die Verzweigung am Ende. Wer die
              Verzweigung vergisst, gibt bei drei falschen Eingaben trotzdem „Willkommen“ aus oder
              gar nichts. Ebenfalls richtig: eine kopfgesteuerte Schleife mit einer Eingabe vor
              der Schleife, ein Merker <code>erfolgreich</code>, der im Rumpf gesetzt und nach der
              Schleife geprüft wird, oder eine Verzweigung im Rumpf, die „Willkommen“ direkt bei
              der richtigen Eingabe ausgibt.
            </p>
          }
          bewertung={[
            "Passende Schleife gewählt (fußgesteuert; alternativ kopfgesteuert mit Eingabe vor der Schleife)",
            "Abbruchbedingung mit beiden Fällen (richtig ODER drei Versuche)",
            "Zähler initialisiert und im Rumpf erhöht",
            "Eingabe im Rumpf, beide Ausgaben korrekt",
            "Verzweigung nach der Schleife (oder Merker) entscheidet über die Ausgabe",
          ]}
        >
          <p>
            Entwerfen Sie das Struktogramm: Ein Programm fragt ein Passwort ab und speichert es in
            der Variablen <code>passwort</code>. Der Benutzer hat höchstens drei Versuche. Ist das
            Passwort „geheim“, wird „Willkommen“ ausgegeben. Sind drei Versuche verbraucht, ohne
            dass das Passwort stimmte, wird „Gesperrt“ ausgegeben.
          </p>
        </Zeichenaufgabe>
      </LsAbschnitt>

      <LsAbschnitt id="quiz" titel="Jetzt selbst testen">
        <p style={{ marginBottom: 18 }}>Vier Fragen zu Schleifen.</p>
        <QuizFrage
          nr={1}
          von={4}
          frage="Welche Schleife läuft auf jeden Fall mindestens einmal?"
          optionen={[
            { text: "Die fußgesteuerte Schleife (WIEDERHOLE … BIS)", richtig: true },
            { text: "Die kopfgesteuerte Schleife (SOLANGE)", richtig: false },
            { text: "Die Zählschleife (FÜR)", richtig: false },
            { text: "Alle drei", richtig: false },
          ]}
          erklaerung="Nur bei der fußgesteuerten Schleife wird erst nach dem Rumpf geprüft. Kopfgesteuerte Schleifen und Zählschleifen können null Durchläufe haben, etwa „für i = 1 bis 0“."
        />
        <QuizFrage
          nr={2}
          von={4}
          frage="Wie viele Durchläufe hat „für i = 3 bis 12“?"
          optionen={[
            { text: "10", richtig: true },
            { text: "9", richtig: false },
            { text: "12", richtig: false },
            { text: "11", richtig: false },
          ]}
          erklaerung="Endwert minus Startwert plus 1: 12 − 3 + 1 = 10. Die Werte 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 sind zehn Stück."
        />
        <QuizFrage
          nr={3}
          von={4}
          frage="i = 0. SOLANGE i < 4: Ausgabe i, i = i + 1. Was wird zuletzt ausgegeben?"
          optionen={[
            { text: "3", richtig: true },
            { text: "4", richtig: false },
            { text: "0", richtig: false },
            { text: "5", richtig: false },
          ]}
          erklaerung="Ausgegeben wird 0, 1, 2, 3. Beim Wert 4 ist die Bedingung „4 < 4“ falsch, die Schleife endet, ohne noch einmal auszugeben. Die Ausgabe steht vor dem Hochzählen, deshalb ist der letzte ausgegebene Wert 3, obwohl i am Ende 4 ist."
        />
        <QuizFrage
          nr={4}
          von={4}
          frage="Ein Menü soll angezeigt werden, dann eine Auswahl gelesen, und das Ganze wiederholt sich, bis der Benutzer „Beenden“ wählt. Welche Schleife?"
          optionen={[
            { text: "Fußgesteuert, weil das Menü mindestens einmal erscheinen muss", richtig: true },
            { text: "Zählschleife, weil das Menü eine feste Anzahl Einträge hat", richtig: false },
            { text: "Kopfgesteuert, weil man vorher prüfen muss, ob der Benutzer beenden will", richtig: false },
            { text: "Gar keine, das ist eine Verzweigung", richtig: false },
          ]}
          erklaerung="Bevor der Benutzer „Beenden“ wählen kann, muss das Menü angezeigt und eine Auswahl gelesen worden sein. Der Rumpf läuft also mindestens einmal: fußgesteuert. Die Bedingung lautet BIS auswahl == &quot;Beenden&quot;."
        />
      </LsAbschnitt>
    </LektionLayout>
  );
}
