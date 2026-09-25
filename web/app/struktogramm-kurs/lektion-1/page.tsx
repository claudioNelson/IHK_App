import type { Metadata } from "next";
import { LsAbschnitt, LsHinweis } from "../../lernen/_components/LsBausteine";
import QuizFrage from "../../lernen/_components/QuizFrage";
import LektionLayout from "../../components/kurs/LektionLayout";
import { Aufgabe, CodeBlock, Loesung } from "../../components/kurs/KursBausteine";
import Struktogramm, { TraceTabelle } from "../_components/Struktogramm";
import { anw, fuer, solange, wenn, wiederholeBis } from "../_components/struktogramm-typen";
import { struktogrammKurs } from "../_components/lektionen";

export const metadata: Metadata = {
  title: "Struktogramm Lektion 1: Was die IHK-Prüfung erwartet",
  description:
    "Struktogramm, Programmablaufplan und Pseudocode im Vergleich, die Schreibweise vieler Lösungshinweise und der Schreibtischtest. Lektion 1 des kostenlosen Struktogramm-Kurses.",
  alternates: { canonical: "https://lernarena.app/struktogramm-kurs/lektion-1" },
};

// Das durchgehende Beispiel der Lektion: Notenbewertung
const bewertung = [
  anw("Eingabe punkte"),
  wenn("punkte >= 50", [anw('Ausgabe "bestanden"')], [anw('Ausgabe "nicht bestanden"')]),
];

const pseudocodeBewertung = `EINGABE punkte
WENN punkte >= 50 DANN
    AUSGABE "bestanden"
SONST
    AUSGABE "nicht bestanden"
ENDE WENN`;

// Erstes komplettes Struktogramm zum Lesen: Summe der Zahlen 1 bis n
const summe = [
  anw("Eingabe n"),
  anw("summe = 0"),
  fuer("für i = 1 bis n", [anw("summe = summe + i")]),
  anw("Ausgabe summe"),
];

export default function Lektion1() {
  return (
    <LektionLayout
      kurs={struktogrammKurs}
      nr={1}
      lead="Was ein Struktogramm ist, warum es in IHK-Aufgaben so oft vorkommt, welche Schreibweise in vielen Lösungshinweisen steht, und wie du dein erstes Struktogramm Zeile für Zeile mit dem Schreibtischtest liest."
      uebungen={5}
      aufgabenText="1 Leseaufgabe, 4 Quizfragen"
    >
      <LsAbschnitt id="warum" titel="Warum es Struktogramme gibt">
        <p>
          Bevor jemand ein Programm schreibt, muss klar sein, <strong>was</strong> es in welcher
          Reihenfolge tun soll. Ein Struktogramm hält genau das fest: den Ablauf, ohne
          Programmiersprache, ohne Semikolons, ohne Klammern. Erfunden haben es Isaac Nassi und
          Ben Shneiderman Anfang der 1970er Jahre, deshalb heißt es auch{" "}
          <strong>Nassi-Shneiderman-Diagramm</strong>; in Deutschland ist es in der{" "}
          <strong>DIN 66261</strong> festgelegt.
        </p>
        <p>
          Die Idee ist einfach: Jeder Schritt ist ein Rechteck. Die Rechtecke stapeln sich von oben
          nach unten. Eine Entscheidung bekommt ein Dreieck im Kopf und teilt den Kasten in zwei
          Spalten. Eine Wiederholung bekommt einen Balken, der den Rumpf umklammert. Das sind die
          Grundformen: Sequenz, Verzweigung und Schleife in drei Varianten. Dazu kommen später die
          Mehrfachauswahl (Lektion 4) und der Aufruf eines Unterprogramms (Lektion 6). Genau
          deshalb eignet sich das Struktogramm für Prüfungsaufgaben: Man sieht auf einen Blick, ob jemand Sequenz,
          Auswahl und Wiederholung verstanden hat.
        </p>

        <Struktogramm
          titel="Bewertung"
          bloecke={bewertung}
          breite={380}
          caption="Ein Struktogramm mit einer Eingabe und einer Verzweigung. Lies es von oben nach unten: Erst die Eingabe, dann die Frage, dann je nach Antwort die linke oder die rechte Spalte."
        />

        <p>
          Das Beispiel liest sich fast wie ein Satz: „Lies die Punkte ein. Wenn sie mindestens 50
          sind, gib ‚bestanden‘ aus, sonst ‚nicht bestanden‘.“ Diese Lesbarkeit ist der Sinn der
          Sache, und sie ist auch das, was die Prüfer sehen wollen.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="pruefung" titel="Was die IHK-Prüfung erwartet">
        <p>
          Struktogramme und Pseudocode gehören zur <strong>Abschlussprüfung Teil 1</strong>, die
          alle IT-Berufe gemeinsam schreiben. Häufig kommt dort eine Aufgabe vor, in der du einen
          Ablauf entweder <em>lesen</em> oder <em>selbst entwerfen</em> musst. Typische
          Formulierungen:
        </p>
        <div className="ls-table-wrap">
          <table className="ls-table sg-text-tabelle">
            <thead>
              <tr>
                <th scope="col">So steht es in der Aufgabe</th>
                <th scope="col">Was verlangt ist</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>„Ermitteln Sie die Ausgabe des Struktogramms für die Eingabe …“</td>
                <td>Lesen und nachvollziehen, meist mit einer Tabelle der Variablenwerte (Schreibtischtest, Lektion 4).</td>
              </tr>
              <tr>
                <td>„Führen Sie einen Schreibtischtest durch …“</td>
                <td>Die Werte der Variablen Schritt für Schritt notieren, meist für eine vorgegebene Eingabe.</td>
              </tr>
              <tr>
                <td>„Ergänzen Sie das Struktogramm um …“</td>
                <td>Ein vorgegebenes Struktogramm um einen Zweig oder eine Schleife erweitern.</td>
              </tr>
              <tr>
                <td>„Finden und korrigieren Sie den Fehler im Pseudocode“</td>
                <td>Fehlersuche: Stimmt die Bedingung, der Startwert, die Zahl der Durchläufe (Off-by-one)?</td>
              </tr>
              <tr>
                <td>„Entwerfen Sie den Algorithmus als Struktogramm oder in Pseudocode“</td>
                <td>Selbst entwerfen. Du darfst wählen; das Struktogramm macht Strukturfehler sichtbar, Pseudocode ist auf Papier schneller zu korrigieren.</td>
              </tr>
              <tr>
                <td>„… in einer Programmiersprache Ihrer Wahl oder in Pseudocode“</td>
                <td>Auch hier zählt nur die Logik. Pseudocode reicht, solange die Struktur eindeutig ist.</td>
              </tr>
            </tbody>
          </table>
        </div>
        <p>
          Bewertet wird typischerweise in kleinen Portionen: ein Punkt für die richtige
          Schleifenart, einer für die Bedingung, einer für die Initialisierung der Variablen, einer
          für die Ausgabe an der richtigen Stelle. Wer die Form beherrscht, sammelt diese Punkte
          auch dann, wenn der Algorithmus nicht perfekt ist. Andere richtige Lösungen werden in
          den Lösungshinweisen in der Regel anerkannt. Anwendungsentwickler treffen Struktogramme
          in der AP2 erneut, dann oft in Kombination mit einem Klassendiagramm.
        </p>

        <LsHinweis titel="Struktogramm, PAP oder Pseudocode?" icon="buch" label="Einordnung">
          <p>
            Neben dem Struktogramm gibt es den <strong>Programmablaufplan</strong> (PAP, DIN 66001)
            mit Kästen und Pfeilen und den <strong>Pseudocode</strong> als Text. Alle drei
            beschreiben dasselbe. In der Prüfung darfst du in der Regel wählen. Der PAP verleitet
            zu Sprüngen kreuz und quer, der Pseudocode zu Flüchtigkeitsfehlern bei den Einrückungen.
            Das Struktogramm zwingt dich zu sauberer Struktur, deshalb steht es im Mittelpunkt
            dieses Kurses. Pseudocode lernst du daneben, weil viele Lösungshinweise ihn nutzen.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="elemente" titel="Die Grundbausteine auf einen Blick">
        <p>
          Jedes Struktogramm besteht aus diesen Formen. Du lernst sie in den nächsten Lektionen
          einzeln; hier siehst du sie einmal nebeneinander, damit du sie wiedererkennst.
        </p>
        <div className="ls-table-wrap">
          <table className="ls-table sg-elemente">
            <thead>
              <tr>
                <th scope="col">Form</th>
                <th scope="col">Bedeutung</th>
                <th scope="col">Pseudocode</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>
                  <Struktogramm klein bloecke={[anw("x = 5"), anw("Ausgabe x")]} />
                </td>
                <td>
                  <strong>Sequenz.</strong> Anweisungen der Reihe nach, jede in einem eigenen Rechteck.
                </td>
                <td>
                  <code>x = 5</code>
                  <br />
                  <code>AUSGABE x</code>
                </td>
              </tr>
              <tr>
                <td>
                  <Struktogramm klein bloecke={[wenn("x > 0", [anw('Ausgabe "positiv"')], [anw('Ausgabe "nicht positiv"')])]} />
                </td>
                <td>
                  <strong>Verzweigung.</strong> Bedingung im Dreieck, links der Ja-Zweig, rechts der Nein-Zweig.
                </td>
                <td>
                  <code>WENN x &gt; 0 DANN … SONST … ENDE WENN</code>
                </td>
              </tr>
              <tr>
                <td>
                  <Struktogramm klein bloecke={[solange("x < 10", [anw("x = x + 1")])]} />
                </td>
                <td>
                  <strong>Kopfgesteuerte Schleife.</strong> Bedingung oben, Rumpf eingerückt. Wird geprüft, bevor der Rumpf läuft.
                </td>
                <td>
                  <code>SOLANGE x &lt; 10 … ENDE SOLANGE</code>
                </td>
              </tr>
              <tr>
                <td>
                  <Struktogramm klein bloecke={[wiederholeBis("x >= 10", [anw("x = x + 1")])]} />
                </td>
                <td>
                  <strong>Fußgesteuerte Schleife.</strong> Rumpf zuerst, Bedingung unten. Läuft mindestens einmal.
                </td>
                <td>
                  <code>WIEDERHOLE … BIS x &gt;= 10</code>
                </td>
              </tr>
              <tr>
                <td>
                  <Struktogramm klein bloecke={[fuer("für i = 1 bis 5", [anw("Ausgabe i")])]} />
                </td>
                <td>
                  <strong>Zählschleife.</strong> Eine kopfgesteuerte Schleife mit eingebautem Zähler.
                </td>
                <td>
                  <code>FÜR i = 1 BIS 5 … ENDE FÜR</code>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <p>
          Zwei Formen kommen später dazu: die Mehrfachauswahl (FALLS) in Lektion 4 und der Aufruf
          eines Unterprogramms in Lektion 6.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="pseudocode" titel="Die Pseudocode-Schreibweise dieses Kurses">
        <p>
          Für Pseudocode gibt es keine Norm. Du darfst in der Prüfung eigene Wörter wählen, musst
          sie aber durchgehend gleich benutzen. Dieser Kurs nutzt eine deutsche Schreibweise, wie
          sie in Lehrbüchern und vielen Lösungshinweisen vorkommt. Schlüsselwörter in Großbuchstaben,
          Blöcke eingerückt, jeder Block mit einem eigenen Ende:
        </p>
        <div className="sg-paar">
          <div>
            <h4>Struktogramm</h4>
            <Struktogramm bloecke={bewertung} />
          </div>
          <div>
            <h4>Pseudocode</h4>
            <CodeBlock code={pseudocodeBewertung} />
          </div>
        </div>
        <p>Die wichtigsten Regeln, die in beiden Schreibweisen gelten:</p>
        <ul>
          <li>
            <strong>Zuweisung</strong> mit <code>=</code> (manche schreiben <code>:=</code> oder{" "}
            <code>←</code>, alle drei sind üblich). Links steht die Variable, rechts der Wert:{" "}
            <code>summe = summe + i</code>.
          </li>
          <li>
            <strong>Vergleich</strong> mit <code>==</code> für „ist gleich“, damit er sich von der
            Zuweisung unterscheidet, sowie <code>&lt;</code>, <code>&gt;</code>,{" "}
            <code>&lt;=</code>, <code>&gt;=</code>, <code>!=</code>. In vielen Struktogrammen und
            Lösungshinweisen steht <code>=</code> für den Vergleich und <code>:=</code> oder{" "}
            <code>←</code> für die Zuweisung. Der Kurs nutzt <code>==</code> für den Vergleich;
            beides ist verständlich, solange du es durchgehend gleich machst.
          </li>
          <li>
            <strong>Ein- und Ausgabe</strong> als <code>EINGABE x</code> und{" "}
            <code>AUSGABE "Text"</code>. Im Struktogramm reicht „Eingabe x“ im Rechteck.
            Zeichenketten bekommen in Code und im Struktogramm gerade Anführungszeichen:{" "}
            <code>"Text"</code>.
          </li>
          <li>
            <strong>Bedingungen</strong> verknüpfst du mit <code>UND</code>, <code>ODER</code>,{" "}
            <code>NICHT</code>.
          </li>
          <li>
            <strong>Variablen</strong> bekommen sprechende Namen ohne Leerzeichen:{" "}
            <code>anzahl</code>, <code>maxWert</code>, <code>istGueltig</code>.
          </li>
        </ul>
        <LsHinweis titel="Wenn die Aufgabe eine Schreibweise vorgibt, nimm die" art="warnung">
          <p>
            Manche Aufgaben legen ein Pseudocode-Blatt bei oder geben im Struktogramm schon
            Schreibweisen vor, etwa <code>zahlen[i]</code> für den Zugriff auf eine Liste. Dann
            übernimmst du genau diese Form. Eigene Erfindungen in einer vorgegebenen Notation
            riskieren Missverständnisse beim Korrektor. Übernimm die vorgegebene Form.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="lesen" titel="Ein Struktogramm lesen">
        <p>
          Lesen heißt: mit dem Finger von oben nach unten gehen und bei jeder Zeile aufschreiben,
          was sich ändert. Das üben wir gleich am ersten kompletten Beispiel. Es berechnet die
          Summe der Zahlen von 1 bis n.
        </p>
        <Struktogramm
          titel="Summe von 1 bis n"
          bloecke={summe}
          breite={380}
          caption="Die Zählschleife läuft für i = 1, 2, 3, … bis n. Bei jedem Durchlauf kommt das aktuelle i zur Summe dazu."
        />
        <p>
          So gehst du vor, wenn du herausfinden willst, was für <code>n = 3</code> ausgegeben wird:
        </p>
        <ol>
          <li>
            <code>Eingabe n</code>: n ist 3.
          </li>
          <li>
            <code>summe = 0</code>: summe ist 0. Diese Zeile heißt <strong>Initialisierung</strong>,
            sie legt den Startwert fest. Ohne sie wüsste niemand, womit die Addition beginnt.
          </li>
          <li>
            Die Schleife: i startet bei 1. 1 ist nicht größer als 3, also Rumpf ausführen:
            summe = 0 + 1 = 1. Dann i = 2: summe = 1 + 2 = 3. Dann i = 3: summe = 3 + 3 = 6.
            Dann i = 4, das ist größer als n, die Schleife endet.
          </li>
          <li>
            <code>Ausgabe summe</code>: 6.
          </li>
        </ol>
        <p>
          Genau diese Schritte schreibt man in der Prüfung in eine Tabelle, den{" "}
          <strong>Schreibtischtest</strong> (Wertetabelle, englisch Trace), damit nichts verloren
          geht:
        </p>
        <TraceTabelle
          spalten={["Schritt", "i", "summe", "Ausgabe"]}
          zeilen={[
            ["Start", "", 0, ""],
            ["Durchlauf 1", 1, 1, ""],
            ["Durchlauf 2", 2, 3, ""],
            ["Durchlauf 3", 3, 6, ""],
            ["Ende", 4, 6, 6],
          ]}
          caption="Schreibtischtest für n = 3. Jede Zeile ist ein Zustand, jede Spalte eine Variable. Am Ende steht i auf 4: Die Prüfung 4 > 3 beendet die Schleife. In Lektion 4 lernst du, den Schreibtischtest auch für verschachtelte Abläufe zu führen."
        />

        <Aufgabe nr="1.1" label="Leseaufgabe 1.1">
          <p>
            Führen Sie einen Schreibtischtest durch: Was gibt das Struktogramm „Summe von 1 bis n“
            für <code>n = 5</code> aus? Führe den Schreibtischtest auf Papier weiter, bevor du die
            Lösung aufklappst.
          </p>
          <Loesung>
            <p>
              Ausgabe: <strong>15</strong>. Die Summe wächst 1, 3, 6, 10, 15. Fünf Durchläufe,
              weil i die Werte 1 bis 5 annimmt; beim sechsten Prüfen ist i = 6 größer als n und
              die Schleife endet.
            </p>
          </Loesung>
        </Aufgabe>

        <LsHinweis titel="Drei Fehler, die beim Lesen am häufigsten passieren" art="warnung">
          <ul>
            <li>
              <strong>Die Initialisierung überspringen.</strong> Wer <code>summe = 0</code> nicht
              notiert, rechnet später mit einem Fantasiewert.
            </li>
            <li>
              <strong>Einen Durchlauf zu viel oder zu wenig.</strong> Bei „für i = 1 bis n“ läuft
              der Rumpf genau n-mal. Bei „solange i &lt; n“ hängt es davon ab, wo i startet. Zähle
              die Durchläufe immer einzeln.
            </li>
            <li>
              <strong>Die Ausgabe zu früh eintragen.</strong> Ausgegeben wird erst, wenn die Zeile
              „Ausgabe“ erreicht ist, nicht schon, wenn der Wert feststeht.
            </li>
          </ul>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="quiz" titel="Jetzt selbst testen">
        <p style={{ marginBottom: 18 }}>
          Vier Fragen zum Einstieg. Du hast so viele Versuche, wie du willst.
        </p>
        <QuizFrage
          nr={1}
          von={4}
          frage="Welche Form hat im Struktogramm eine Verzweigung?"
          optionen={[
            { text: "Ein Rechteck mit einem Dreieck im Kopf, darunter zwei Spalten", richtig: true },
            { text: "Eine Raute mit zwei abgehenden Pfeilen", richtig: false },
            { text: "Ein Kreis mit der Bedingung in der Mitte", richtig: false },
            { text: "Ein Rechteck mit abgerundeten Ecken", richtig: false },
          ]}
          erklaerung="Die Raute mit Pfeilen gehört zum Programmablaufplan. Im Struktogramm gibt es keine Pfeile: Die Bedingung steht im Dreieck, der Ja-Zweig links, der Nein-Zweig rechts."
        />
        <QuizFrage
          nr={2}
          von={4}
          frage="Woran erkennst du im Struktogramm eine fußgesteuerte Schleife?"
          optionen={[
            { text: "Die Bedingung steht unter dem Rumpf", richtig: true },
            { text: "Die Bedingung steht über dem Rumpf", richtig: false },
            { text: "Der Rumpf ist doppelt umrandet", richtig: false },
            { text: "Sie hat keinen Balken links", richtig: false },
          ]}
          erklaerung="Kopfgesteuert: Bedingung oben, Prüfung vor dem ersten Durchlauf. Fußgesteuert: Bedingung unten, der Rumpf läuft mindestens einmal. Der Balken links ist bei beiden da."
        />
        <QuizFrage
          nr={3}
          von={4}
          frage="Was gibt „Summe von 1 bis n“ für n = 0 aus?"
          optionen={[
            { text: "0", richtig: true },
            { text: "1", richtig: false },
            { text: "Nichts, das Struktogramm bricht ab", richtig: false },
            { text: "Das ist nicht festgelegt", richtig: false },
          ]}
          erklaerung="Die Zählschleife „für i = 1 bis 0“ läuft kein einziges Mal, weil der Startwert schon über dem Endwert liegt. summe bleibt beim Startwert 0, und genau der wird ausgegeben. Deshalb ist die Initialisierung so wichtig."
        />
        <QuizFrage
          nr={4}
          von={4}
          frage="Eine Aufgabe sagt: „Entwerfen Sie den Algorithmus in Pseudocode oder als Struktogramm.“ Was gilt?"
          optionen={[
            { text: "Du wählst eine Form und hältst sie durchgehend ein", richtig: true },
            { text: "Du musst beides abgeben", richtig: false },
            { text: "Nur das Struktogramm gibt volle Punkte", richtig: false },
            { text: "Pseudocode muss in Englisch geschrieben sein", richtig: false },
          ]}
          erklaerung="Beide Formen sind gleichwertig. Bewertet wird die Logik: Schleifenart, Bedingungen, Initialisierung, Ausgabe. Wichtig ist nur, dass du nicht mittendrin die Schreibweise wechselst."
        />
      </LsAbschnitt>
    </LektionLayout>
  );
}
