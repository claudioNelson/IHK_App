import type { Metadata } from "next";
import Link from "next/link";
import { LsAbschnitt, LsHinweis } from "../../lernen/_components/LsBausteine";
import LektionLayout from "../../components/kurs/LektionLayout";
import { Aufgabe, CodeBlock, Loesung, Zeichenaufgabe } from "../../components/kurs/KursBausteine";
import Struktogramm, { TraceTabelle } from "../_components/Struktogramm";
import { anw, falls, fuer, luecke, wenn, wiederholeBis } from "../_components/struktogramm-typen";
import { struktogrammKurs } from "../_components/lektionen";

export const metadata: Metadata = {
  title: "Struktogramm Lektion 8: Prüfungstraining",
  description:
    "Drei Aufgaben im Stil der IHK-Abschlussprüfung Teil 1: Schreibtischtest und Fehlersuche, Struktogramm ergänzen, Funktion und Hauptprogramm entwerfen. Mit Musterlösungen und typischer Bewertung.",
  alternates: { canonical: "https://lernarena.app/struktogramm-kurs/lektion-8" },
};

/* ---- Aufgabe 1: Nachbestellung (mit Fehler: Schleife beginnt bei 1 statt 0) ---- */

const nachbestellungFehlerhaft = [
  anw("Eingabe minimum"),
  anw("anzahl = 0"),
  anw("fehlmenge = 0"),
  fuer("für i = 1 bis 4", [
    wenn("bestand[i] < minimum", [anw("anzahl = anzahl + 1"), anw("fehlmenge = fehlmenge + (minimum - bestand[i])")]),
  ]),
  wenn("anzahl == 0", [anw('Ausgabe "Alles ausreichend"')], [anw("Ausgabe anzahl, fehlmenge")]),
];

const nachbestellungKorrigiert = [
  anw("Eingabe minimum"),
  anw("anzahl = 0"),
  anw("fehlmenge = 0"),
  fuer("für i = 0 bis 4", [
    wenn("bestand[i] < minimum", [anw("anzahl = anzahl + 1"), anw("fehlmenge = fehlmenge + (minimum - bestand[i])")]),
  ]),
  wenn("anzahl == 0", [anw('Ausgabe "Alles ausreichend"')], [anw("Ausgabe anzahl, fehlmenge")]),
];

/* ---- Aufgabe 2: Parkhaus ---- */

const parkhausLuecken = [
  anw("Eingabe minuten"),
  anw("Eingabe kundenart"),
  anw("stunden = minuten DIV 60"),
  wenn("(1)", [anw("stunden = stunden + 1")]),
  falls(
    "kundenart",
    [
      { wert: '"K"', bloecke: [anw("satz = 3")] },
      { wert: '"D"', bloecke: [luecke("2")] },
      { wert: '"M"', bloecke: [anw("satz = 0")] },
    ],
    [anw('Ausgabe "Unbekannte Kundenart"'), anw("satz = 0")],
  ),
  anw("gebuehr = stunden * satz"),
  wenn("gebuehr > 20", [luecke("3")]),
  anw("Ausgabe gebuehr"),
];

const parkhausVollstaendig = [
  anw("Eingabe minuten"),
  anw("Eingabe kundenart"),
  anw("stunden = minuten DIV 60"),
  wenn("minuten MOD 60 > 0", [anw("stunden = stunden + 1")]),
  falls(
    "kundenart",
    [
      { wert: '"K"', bloecke: [anw("satz = 3")] },
      { wert: '"D"', bloecke: [anw("satz = 2")] },
      { wert: '"M"', bloecke: [anw("satz = 0")] },
    ],
    [anw('Ausgabe "Unbekannte Kundenart"'), anw("satz = 0")],
  ),
  anw("gebuehr = stunden * satz"),
  wenn("gebuehr > 20", [anw("gebuehr = 20")]),
  anw("Ausgabe gebuehr"),
];

const parkhausErweitert = [
  wiederholeBis("minuten >= 1 UND minuten <= 1440", [
    anw('Ausgabe "Parkdauer in Minuten (1 bis 1440):"'),
    anw("Eingabe minuten"),
    wenn("minuten < 1 ODER minuten > 1440", [anw('Ausgabe "Ungültige Eingabe"')]),
  ]),
  anw("Eingabe kundenart"),
  anw("stunden = minuten DIV 60"),
  wenn("minuten MOD 60 > 0", [anw("stunden = stunden + 1")]),
  falls(
    "kundenart",
    [
      { wert: '"K"', bloecke: [anw("satz = 3")] },
      { wert: '"D"', bloecke: [anw("satz = 2")] },
      { wert: '"M"', bloecke: [anw("satz = 0")] },
    ],
    [anw('Ausgabe "Unbekannte Kundenart"'), anw("satz = 0")],
  ),
  anw("gebuehr = stunden * satz"),
  wenn("gebuehr > 20", [anw("gebuehr = 20")]),
  anw("Ausgabe gebuehr"),
];

const parkhausPseudocode = `FALLS kundenart
    FALL "K":
        satz = 3
    FALL "D":
        satz = 2
    FALL "M":
        satz = 0
    SONST
        AUSGABE "Unbekannte Kundenart"
        satz = 0
ENDE FALLS`;

/* ---- Aufgabe 3: Temperaturmessungen ---- */

const anzahlFrosttage = [
  anw("anzahl = 0"),
  fuer("für i = 1 bis n", [wenn("temperaturen[i] < 0", [anw("anzahl = anzahl + 1")])]),
  anw("Rückgabe anzahl"),
];

const temperaturHaupt = [
  anw("Eingabe n"),
  fuer("für i = 1 bis n", [anw("Eingabe temperaturen[i]")]),
  anw("frost = anzahlFrosttage(temperaturen, n)"),
  anw('Ausgabe "Frosttage:", frost'),
  anw("max = temperaturen[1]"),
  anw("tag = 1"),
  fuer("für i = 2 bis n", [wenn("temperaturen[i] > max", [anw("max = temperaturen[i]"), anw("tag = i")])]),
  anw('Ausgabe "Wärmster Tag:", tag, "mit", max, "Grad"'),
];

export default function Lektion8() {
  return (
    <LektionLayout
      kurs={struktogrammKurs}
      nr={8}
      lead="Drei Aufgaben, wie sie in der Abschlussprüfung Teil 1 vorkommen könnten: ein Struktogramm lesen und einen Fehler finden, ein Struktogramm ergänzen und erweitern, ein Unterprogramm und ein Hauptprogramm entwerfen. Jede Aufgabe hat ein Szenario, Teilaufgaben mit Punkten, eine Musterlösung und ein Bewertungsraster. Plane 25 Minuten je Aufgabe und arbeite auf Papier, bevor du eine Lösung aufklappst."
      uebungen={9}
      aufgabenText="3 Prüfungsaufgaben mit 9 Teilaufgaben"
    >
      <LsAbschnitt id="vorgehen" titel="So gehst du an eine Aufgabe">
        <p>
          Prüfungsaufgaben zu Struktogrammen sind selten schwer, aber oft lang: eine halbe
          Seite Szenario, drei Teilaufgaben, ein vorgegebenes Struktogramm. Wer einfach losschreibt,
          verliert Punkte an Stellen, die er längst kann. Deshalb ein festes Vorgehen:
        </p>
        <ol>
          <li>
            <strong>Text lesen und Signalwörter markieren.</strong> „Wie viele“ ist ein Zähler,
            „das größte“ ein Maximum mit Index, „bis die Eingabe gültig ist“ eine fußgesteuerte
            Schleife, „ob … vorkommt“ eine Suche (Lektion 5). Markiere auch Zahlen: Anzahl der
            Elemente, Indexbasis, Grenzwerte.
          </li>
          <li>
            <strong>Variablen und Startwerte notieren.</strong> Bevor du zeichnest: Welche
            Variablen gibt es, welchen Typ haben sie, womit beginnen sie? 0 für Summe und Zähler,
            das erste Element für Maximum und Minimum, falsch für einen Merker.
          </li>
          <li>
            <strong>Muster erkennen.</strong> Fast jede Aufgabe ist eines der Grundmuster aus
            Lektion 5 oder eine Kombination aus zweien. Erkennst du das Muster, steht die Form
            schon fest.
          </li>
          <li>
            <strong>Form zeichnen.</strong> Erst die groben Kästen (Eingabe, Schleife, Ausgabe),
            dann die Details im Rumpf. Verzweigung mit Dreieck, Schleife mit Balken, Schlüsselwort
            „solange“ oder „bis“ an der Bedingung.
          </li>
          <li>
            <strong>Schreibtischtest (Wertetabelle) mit kleinem Beispiel.</strong> Drei oder vier
            Werte reichen.
            Prüfe besonders den ersten und den letzten Durchlauf und den Fall „kein Treffer“.
          </li>
          <li>
            <strong>Zeit einteilen.</strong> Etwa ein Punkt pro Minute ist ein brauchbarer Richtwert.
            Bleibst du bei einer Teilaufgabe hängen, mach mit der nächsten weiter; Teilaufgaben
            werden typischerweise unabhängig voneinander bewertet.
          </li>
        </ol>
        <LsHinweis titel="Punkte sind Richtwerte" icon="buch" label="Bewertung">
          <p>
            Die Punkte in dieser Lektion orientieren sich an der Größenordnung der AP1, in der eine
            Handlungssituation häufig 25 Punkte hat. Wie die Punkte auf Teilaufgaben verteilt werden,
            legt jede Prüfung selbst fest; das Raster hier zeigt eine typische Aufteilung.
            Gleichwertige Lösungen zählen: eine andere Schleifenart, ein Zähler ab 0 statt ab 1 (sofern
            Zugriff und Grenzen zur Indexbasis passen), ein Merker statt einer Verzweigung. Die Lösungshinweise erkennen solche Varianten an, solange
            die Logik stimmt und die Form eindeutig ist.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="aufgabe-1" titel="Aufgabe 1: Schreibtischtest und Fehlersuche (25 Punkte)">
        <p>
          <strong>Zeitempfehlung: 25 Minuten.</strong>
        </p>
        <p>
          <strong>Szenario.</strong> Ein Getränkehandel prüft jeden Abend, welche Artikel
          nachbestellt werden müssen. Die Bestände der fünf Artikel stehen in einem Feld (Array){" "}
          <code>bestand</code> mit fünf Ganzzahlen; <strong>das erste Element hat den Index 0</strong>,
          das letzte den Index 4. Der Mindestbestand <code>minimum</code> gilt für alle Artikel und
          wird eingegeben. Es soll gezählt werden, wie viele Artikel unter dem Mindestbestand
          liegen, und wie viele Stück insgesamt fehlen, um bei diesen Artikeln den Mindestbestand
          zu erreichen. Liegt kein Artikel unter dem Mindestbestand,
          wird „Alles ausreichend“ ausgegeben. Ein Auszubildender hat dazu das folgende
          Struktogramm entworfen:
        </p>
        <Struktogramm titel="Nachbestellung" bloecke={nachbestellungFehlerhaft} breite={460} />

        <Aufgabe nr="1a" label="Aufgabe 1 a) Schreibtischtest (10 Punkte)">
          <p>
            Führen Sie einen Schreibtischtest für das Feld <code>bestand = [30, 8, 15, 4, 12]</code>{" "}
            und die Eingabe <code>minimum = 10</code> durch. Legen Sie eine Tabelle mit den Spalten
            i, bestand[i], Prüfung, anzahl und fehlmenge an und geben Sie die Ausgabe an.
          </p>
          <Loesung>
            <TraceTabelle
              spalten={["Prüfung", "i", "bestand[i]", "anzahl", "fehlmenge", "Ausgabe"]}
              zeilen={[
                ["Start, minimum = 10", "", "", 0, 0, ""],
                ["8 < 10: ja", 1, 8, 1, 2, ""],
                ["15 < 10: nein", 2, 15, 1, 2, ""],
                ["4 < 10: ja", 3, 4, 2, 8, ""],
                ["12 < 10: nein", 4, 12, 2, 8, ""],
                ["anzahl == 0: nein, Ausgabe", "", "", 2, 8, "2, 8"],
              ]}
              caption="Die Schleife beginnt, wie im Struktogramm angegeben, bei i = 1. bestand[0] = 30 wird nicht angesehen."
            />
            <p>
              Ausgabe: <strong>2, 8</strong>. Zwei Artikel liegen unter dem Mindestbestand (8 und 4),
              es fehlen 2 + 6 = 8 Stück. Wichtig beim Schreibtischtest: Du führst aus, was da steht,
              auch wenn dir die Schleifengrenze schon verdächtig vorkommt. Für dieses Feld ändert
              das nichts am Ergebnis, weil der Artikel mit Index 0 ohnehin über dem Minimum liegt.
            </p>
          </Loesung>
        </Aufgabe>

        <Aufgabe nr="1b" label="Aufgabe 1 b) Zweite Eingabe (5 Punkte)">
          <p>
            Ermitteln Sie die Ausgabe des Struktogramms für <code>bestand = [20, 25, 11, 30, 18]</code>{" "}
            und <code>minimum = 10</code>. Notieren Sie die Prüfungen je Durchlauf.
          </p>
          <Loesung>
            <TraceTabelle
              spalten={["Prüfung", "i", "bestand[i]", "anzahl", "fehlmenge", "Ausgabe"]}
              zeilen={[
                ["Start, minimum = 10", "", "", 0, 0, ""],
                ["25 < 10: nein", 1, 25, 0, 0, ""],
                ["11 < 10: nein", 2, 11, 0, 0, ""],
                ["30 < 10: nein", 3, 30, 0, 0, ""],
                ["18 < 10: nein", 4, 18, 0, 0, ""],
                ["anzahl == 0: ja, Ausgabe", "", "", 0, 0, "Alles ausreichend"],
              ]}
            />
            <p>
              Ausgabe: <strong>„Alles ausreichend“</strong>. Kein Durchlauf erhöht den Zähler, also
              läuft nach der Schleife der Ja-Zweig. Die 11 ist der knappste Wert, liegt aber nicht{" "}
              <em>unter</em> 10.
            </p>
          </Loesung>
        </Aufgabe>

        <Aufgabe nr="1c" label="Aufgabe 1 c) Fehler finden und korrigieren (10 Punkte)">
          <p>
            Für das Feld <code>bestand = [3, 20, 20, 20, 20]</code> und <code>minimum = 10</code> gibt
            das Struktogramm „Alles ausreichend“ aus, obwohl der erste Artikel nur 3 Stück auf
            Lager hat. Nennen Sie den Fehler im Struktogramm, erklären Sie, warum er bei den
            Feldern aus a) und b) nicht aufgefallen ist, und korrigieren Sie das Struktogramm.
            Geben Sie außerdem die richtige Ausgabe für dieses Feld an.
          </p>
          <Loesung>
            <p>
              <strong>Fehler:</strong> Die Zählschleife läuft „für i = 1 bis 4“, das Feld beginnt
              aber laut Aufgabe beim Index 0. Das erste Element <code>bestand[0]</code> wird nie
              geprüft; die Schleife hat nur vier statt fünf Durchläufe. Ein typischer
              Off-by-one-Fehler, der hier daher kommt, dass der Zähler wie gewohnt bei 1 gestartet
              wurde, ohne die Indexbasis zu prüfen.
            </p>
            <p>
              <strong>Warum er nicht aufgefallen ist:</strong> In a) und b) lag der Artikel mit
              Index 0 (30 bzw. 20) über dem Mindestbestand. Ob er geprüft wird oder nicht, ändert
              dort nichts an Zähler und Fehlmenge. Erst wenn genau dieser Artikel knapp ist, liefert
              das Struktogramm ein falsches Ergebnis: „Alles ausreichend“ statt 1, 7.
            </p>
            <p>
              <strong>Korrektur:</strong> Schleifenkopf „für i = 0 bis 4“. Gleichwertig: „für i = 0
              bis n − 1“ mit n = 5, oder eine kopfgesteuerte Schleife mit i = 0 und „solange i &lt;
              5“.
            </p>
            <Struktogramm titel="Nachbestellung (korrigiert)" bloecke={nachbestellungKorrigiert} breite={460} />
          </Loesung>
        </Aufgabe>

        <h4>Typisches Bewertungsraster</h4>
        <div className="ls-table-wrap">
          <table className="ls-table sg-text-tabelle">
            <thead>
              <tr>
                <th scope="col">Teilaufgabe</th>
                <th scope="col">Wofür es Punkte gibt</th>
                <th scope="col">Punkte</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>a)</td>
                <td>Startzeile mit Initialisierung (1), je Durchlauf Prüfung mit Ergebnis und richtige Werte für anzahl und fehlmenge (4 × 2), Ausgabe nach der Schleife (1)</td>
                <td>10</td>
              </tr>
              <tr>
                <td>b)</td>
                <td>Vier Prüfungen mit Ergebnis (4 × 1), Ausgabe „Alles ausreichend“ über den Ja-Zweig (1)</td>
                <td>5</td>
              </tr>
              <tr>
                <td>c)</td>
                <td>Richtige Ausgabe 1, 7 für das Feld aus c) angegeben (2), Fehler benannt: Index 0 wird nie geprüft (3), Begründung, warum er bei a) und b) nicht aufgefallen ist (2), Korrektur des Schleifenkopfs oder gleichwertige Schleife (3)</td>
                <td>10</td>
              </tr>
              <tr>
                <td>Summe</td>
                <td>Gleichwertig: Tabelle mit einer Zeile je Anweisung statt je Durchlauf; Prüfung als eigene Spalte oder in der Schrittspalte</td>
                <td>25</td>
              </tr>
            </tbody>
          </table>
        </div>
        <LsHinweis titel="Typische Punktabzüge bei Aufgabe 1" art="warnung">
          <ul>
            <li>
              Im Schreibtischtest die Schleife „stillschweigend“ bei 0 beginnen lassen, weil das
              richtiger wäre. Getestet wird das gegebene Struktogramm; die Korrektur gehört in c).
            </li>
            <li>Die Fehlmenge als Differenz falsch herum rechnen (bestand − minimum ergibt negative Werte).</li>
            <li>Die Ausgabe in jede Zeile schreiben, statt nur in die letzte, in der sie erreicht wird.</li>
            <li>In c) nur „die Schleife ist falsch“ schreiben, ohne zu sagen, welches Element fehlt und wie der Kopf richtig lautet.</li>
          </ul>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="aufgabe-2" titel="Aufgabe 2: Ergänzen und erweitern (25 Punkte)">
        <p>
          <strong>Zeitempfehlung: 25 Minuten.</strong>
        </p>
        <p>
          <strong>Szenario.</strong> Ein Parkhaus rechnet die Parkgebühr am Kassenautomaten ab. Der
          Automat liest die Parkdauer in Minuten und die Kundenart ein; die Parkdauer beträgt
          höchstens einen Tag (1440 Minuten). Abgerechnet wird jede{" "}
          <em>angefangene</em> Stunde: 61 Minuten zählen als zwei Stunden, genau 60 Minuten als eine.
          Der Stundensatz hängt von der Kundenart ab: Kurzparker („K“) zahlen 3 Euro, Dauerparker
          („D“) 2 Euro, Mitarbeiter („M“) parken kostenlos. Bei einer unbekannten Kundenart wird
          ein Hinweis ausgegeben und keine Gebühr berechnet. Die Gebühr beträgt höchstens 20 Euro
          pro Tag (Tagesmaximum). Zum Schluss wird die Gebühr ausgegeben. Das Struktogramm dazu ist
          an drei Stellen unvollständig:
        </p>
        <Struktogramm titel="Parkgebühr" bloecke={parkhausLuecken} breite={520} />

        <Aufgabe nr="2a" label="Aufgabe 2 a) Lücken ergänzen (10 Punkte)">
          <p>
            Ergänzen Sie das Struktogramm an den Stellen (1), (2) und (3). Lücke (1) steht im Kopf
            der Verzweigung, Lücke (2) im Fall „D“ der Mehrfachauswahl, Lücke (3) im Ja-Zweig der
            letzten Verzweigung. Prüfen Sie Ihre Lösung mit 125 Minuten als Kurzparker (Ergebnis 9
            Euro) und 500 Minuten als Kurzparker (Ergebnis 20 Euro).
          </p>
          <Loesung>
            <Struktogramm titel="Parkgebühr" bloecke={parkhausVollstaendig} breite={520} />
            <p>
              (1) <code>minuten MOD 60 &gt; 0</code>: Bleibt bei der Division durch 60 ein Rest, ist
              eine weitere Stunde angefangen. Gleichwertig: <code>minuten MOD 60 != 0</code> oder{" "}
              <code>stunden * 60 &lt; minuten</code>. (2) <code>satz = 2</code>, der Stundensatz für
              Dauerparker. (3) <code>gebuehr = 20</code>: die Deckelung auf das Tagesmaximum.
            </p>
            <p>
              Probe: 125 Minuten ergeben 125 DIV 60 = 2 und 125 MOD 60 = 5, also 3 angefangene
              Stunden; als Kurzparker 3 · 3 = 9 Euro, unter 20, Ausgabe 9. 500 Minuten: 500 DIV 60 =
              8, Rest 20, also 9 Stunden; 9 · 3 = 27, größer als 20, Ausgabe 20. Und 45 Minuten als
              Dauerparker: 0 volle Stunden, Rest 45, also 1 Stunde, 2 Euro.
            </p>
          </Loesung>
        </Aufgabe>

        <Zeichenaufgabe
          nr="2b"
          toolHinweis={false}
          loesung={<Struktogramm titel="Parkgebühr mit Eingabeprüfung" bloecke={parkhausErweitert} breite={520} />}
          erklaerung={
            <p>
              Die Eingabe muss stattfinden, bevor sie geprüft werden kann, also fußgesteuert: Rumpf
              mit Aufforderung, Eingabe und Hinweis, darunter die Abbruchbedingung „bis minuten
              &gt;= 1 UND minuten &lt;= 1440“. Die Verzweigung für den Hinweis prüft das Gegenteil
              der Abbruchbedingung, deshalb ODER statt UND. Der Rest des Struktogramms bleibt
              unverändert. Gleichwertig: eine kopfgesteuerte Schleife „solange minuten &lt; 1 ODER
              minuten &gt; 1440“ mit einer ersten Eingabe davor; dann kann der Hinweis auch als
              erste Anweisung im Rumpf stehen und die Verzweigung entfällt.
            </p>
          }
          bewertung={[
            "Fußgesteuerte Schleife um die Eingabe (3); gleichwertig kopfgesteuert mit Eingabe vor der Schleife",
            "Abbruchbedingung mit beiden Grenzen richtig, UND bei „bis“ bzw. ODER bei „solange“ (4)",
            "Hinweis bei ungültiger Eingabe wird nur bei ungültiger Eingabe ausgegeben (2)",
            "Schleife ersetzt genau die Eingabe der Minuten, das übrige Struktogramm bleibt unverändert (1)",
          ]}
        >
          <p>
            <strong>Aufgabe 2 b) Erweitern (10 Punkte).</strong> Erweitern Sie das vollständige
            Struktogramm aus a): Die Parkdauer soll erst
            weiterverarbeitet werden, wenn sie gültig ist, also mindestens 1 und höchstens 1440
            Minuten (ein Tag) beträgt. Bei einer ungültigen Eingabe soll „Ungültige Eingabe“
            ausgegeben und die Eingabe wiederholt werden. Zeichnen Sie das erweiterte Struktogramm
            und wählen Sie die Schleifenart, die zur Situation passt.
          </p>
        </Zeichenaufgabe>

        <Aufgabe nr="2c" label="Aufgabe 2 c) Pseudocode (5 Punkte)">
          <p>
            Schreiben Sie die Mehrfachauswahl aus dem Struktogramm (die Ermittlung des
            Stundensatzes aus der Kundenart) als Pseudocode.
          </p>
          <Loesung>
            <CodeBlock code={parkhausPseudocode} />
            <p>
              Gleichwertig ist eine Verzweigungskette WENN kundenart == "K" … SONST WENN … SONST …,
              solange alle vier Fälle vorkommen und die unbekannte Kundenart im letzten SONST landet.
              Die Schreibweise der Schlüsselwörter ist frei, muss aber durchgehend gleich bleiben.
            </p>
          </Loesung>
        </Aufgabe>

        <h4>Typisches Bewertungsraster</h4>
        <div className="ls-table-wrap">
          <table className="ls-table sg-text-tabelle">
            <thead>
              <tr>
                <th scope="col">Teilaufgabe</th>
                <th scope="col">Wofür es Punkte gibt</th>
                <th scope="col">Punkte</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>a)</td>
                <td>Lücke (1) Bedingung mit MOD oder gleichwertig (4), Lücke (2) Stundensatz 2 (3), Lücke (3) Deckelung auf 20 (3)</td>
                <td>10</td>
              </tr>
              <tr>
                <td>b)</td>
                <td>Passende Schleifenart (3), Bedingung mit beiden Grenzen und richtiger Logik (4), Hinweis nur bei ungültiger Eingabe (2), Rest unverändert eingebaut (1)</td>
                <td>10</td>
              </tr>
              <tr>
                <td>c)</td>
                <td>Rahmen FALLS … ENDE FALLS oder gleichwertige Kette (1), drei Fälle mit richtigen Sätzen (3), SONST mit Hinweis (1)</td>
                <td>5</td>
              </tr>
              <tr>
                <td>Summe</td>
                <td>Gleichwertig: Stunden mit (minuten + 59) DIV 60 in einer Zeile, dann entfällt Lücke (1) und die Punkte gehen auf diese Zeile über</td>
                <td>25</td>
              </tr>
            </tbody>
          </table>
        </div>
        <LsHinweis titel="Typische Punktabzüge bei Aufgabe 2" art="warnung">
          <ul>
            <li>
              In (1) <code>minuten MOD 60 &gt;= 0</code> schreiben: Das ist immer wahr, und genau 60
              Minuten würden als zwei Stunden abgerechnet.
            </li>
            <li>
              In b) die Grenzen mit UND in einer „solange“-Bedingung verknüpfen (solange minuten &lt; 1
              UND minuten &gt; 1440 ist nie wahr, die Schleife endet sofort).
            </li>
            <li>Nur die Eingabe wiederholen, aber den Hinweis auch bei gültiger Eingabe ausgeben.</li>
            <li>Beim Pseudocode ein FALL vergessen oder die Schlüsselwörter mittendrin wechseln.</li>
          </ul>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="aufgabe-3" titel="Aufgabe 3: Entwerfen (25 Punkte)">
        <p>
          <strong>Zeitempfehlung: 25 Minuten.</strong>
        </p>
        <p>
          <strong>Szenario.</strong> Eine Wetterstation speichert die Tageshöchsttemperaturen eines
          Monats als Ganzzahlen in Grad Celsius im Feld <code>temperaturen</code> mit n Werten;{" "}
          <strong>das erste Element hat den Index 1</strong>, der Index entspricht dem Tag des
          Monats. Ein Monat hat 28 bis 31 Tage, es gilt also n &gt;= 1. Ein Frosttag ist ein Tag mit
          einer Temperatur unter 0 Grad. Es soll ein
          Unterprogramm entstehen, das die Anzahl der Frosttage liefert, und ein Hauptprogramm, das
          die Werte einliest, das Unterprogramm nutzt und zusätzlich den wärmsten Tag ausgibt.
        </p>

        <Zeichenaufgabe
          nr="3a"
          toolHinweis={false}
          loesung={<Struktogramm titel="anzahlFrosttage(temperaturen: Feld, n: Ganzzahl): Ganzzahl" bloecke={anzahlFrosttage} breite={440} />}
          erklaerung={
            <p>
              Das Zählmuster aus Lektion 5 als Funktion: Zähler ab 0, eine Zählschleife über alle n
              Elemente, im Rumpf die Verzweigung <code>temperaturen[i] &lt; 0</code> mit der
              Erhöhung im Ja-Zweig, und nach der Schleife die Rückgabe. Die Funktion gibt nichts aus,
              das ist Sache des Hauptprogramms. Genau 0 Grad ist kein Frosttag, deshalb{" "}
              <code>&lt;</code> und nicht <code>&lt;=</code>.
            </p>
          }
          bewertung={[
            "Signatur als Titel mit den Parametern temperaturen und n und dem Rückgabetyp Ganzzahl (2)",
            "Zähler mit 0 initialisiert, vor der Schleife (2)",
            "Zählschleife über alle n Elemente, Grenzen passend zur Indexbasis 1 (2)",
            "Verzweigung temperaturen[i] < 0 mit Erhöhung des Zählers im Ja-Zweig (3)",
            "Rückgabe des Zählers nach der Schleife, keine Ausgabe (1)",
            "Gleichwertig: kopfgesteuerte Schleife mit eigenem Zähler, anderer Variablenname",
          ]}
        >
          <p>
            <strong>Aufgabe 3 a) Funktion (10 Punkte).</strong> Entwerfen Sie die Funktion{" "}
            <code>anzahlFrosttage(temperaturen: Feld, n: Ganzzahl): Ganzzahl</code> als
            Struktogramm. Sie liefert zurück, wie viele der n Werte unter 0 liegen.
          </p>
        </Zeichenaufgabe>

        <Zeichenaufgabe
          nr="3b"
          toolHinweis={false}
          loesung={<Struktogramm titel="Hauptprogramm" bloecke={temperaturHaupt} breite={460} />}
          erklaerung={
            <p>
              Vier Teile hintereinander: die Anzahl einlesen, die Werte in einer Zählschleife in das
              Feld einlesen, die Funktion aufrufen und das Ergebnis ausgeben, dann das Maximum mit
              Index aus Lektion 5. Der Startkandidat ist das erste Element mit Tag 1, die Schleife
              beginnt beim zweiten. Der Index i ist zugleich der Tag, deshalb reicht{" "}
              <code>tag = i</code>. Die Ausgabe des wärmsten Tags steht nach der zweiten Schleife.
              Gleichwertig: das Maximum ebenfalls als Funktion auslagern, die den Index zurückgibt,
              oder beide Ergebnisse erst am Ende ausgeben.
            </p>
          }
          bewertung={[
            "Eingabe von n und Einlesen der n Werte in einer Schleife in das Feld (2)",
            "Aufruf anzahlFrosttage(temperaturen, n) mit Argumenten in Signaturreihenfolge, Ergebnis zugewiesen oder direkt ausgegeben (3)",
            "Maximum: Startkandidat erstes Element und Tag 1, nicht 0 (2)",
            "Schleife ab dem zweiten Element mit Vergleich und Aktualisierung von Wert und Tag (2)",
            "Ausgabe von Tag und Wert nach der Schleife (1)",
            "Gleichwertig: Schleife ab 1 mit einem überflüssigen Vergleich, Maximum als eigene Funktion",
          ]}
        >
          <p>
            <strong>Aufgabe 3 b) Hauptprogramm (10 Punkte).</strong> Entwerfen Sie das
            Hauptprogramm als Struktogramm: Es liest zuerst die Anzahl n und dann
            die n Temperaturen in das Feld ein, ruft die Funktion aus a) auf und gibt die Anzahl der
            Frosttage aus. Anschließend ermittelt es den wärmsten Tag und gibt dessen Tag (Index)
            und Temperatur aus. Kommt die höchste Temperatur mehrmals vor, soll der erste dieser
            Tage ausgegeben werden.
          </p>
        </Zeichenaufgabe>

        <Aufgabe nr="3c" label="Aufgabe 3 c) Schreibtischtest der eigenen Lösung (5 Punkte)">
          <p>
            Führen Sie einen Schreibtischtest Ihrer Lösung aus a) und b) für das Feld{" "}
            <code>temperaturen = [3, -2, 5, -1]</code> mit n = 4 durch und geben Sie beide Ausgaben
            an.
          </p>
          <Loesung>
            <TraceTabelle
              spalten={["Prüfung in anzahlFrosttage", "i", "temperaturen[i]", "anzahl"]}
              zeilen={[
                ["Start", "", "", 0],
                ["3 < 0: nein", 1, 3, 0],
                ["−2 < 0: ja", 2, "−2", 1],
                ["5 < 0: nein", 3, 5, 1],
                ["−1 < 0: ja", 4, "−1", 2],
                ["Rückgabe", "", "", 2],
              ]}
              caption="Die Funktion liefert 2. Das Hauptprogramm gibt „Frosttage: 2“ aus."
            />
            <TraceTabelle
              spalten={["Prüfung im Hauptprogramm", "i", "temperaturen[i]", "max", "tag"]}
              zeilen={[
                ["Start: max = temperaturen[1]", "", "", 3, 1],
                ["−2 > 3: nein", 2, "−2", 3, 1],
                ["5 > 3: ja", 3, 5, 5, 3],
                ["−1 > 5: nein", 4, "−1", 5, 3],
                ["Schleife beendet, Ausgabe", "", "", 5, 3],
              ]}
              caption="Wärmster Tag: Tag 3 mit 5 Grad."
            />
            <p>
              Ausgaben: <strong>Frosttage: 2</strong> und <strong>Wärmster Tag: 3 mit 5 Grad</strong>.
              Hast du in a) oder b) eine andere, gleichwertige Form gewählt, muss dein
              Schreibtischtest dieser Form folgen und dieselben Ausgaben liefern.
            </p>
          </Loesung>
        </Aufgabe>

        <h4>Typisches Bewertungsraster</h4>
        <div className="ls-table-wrap">
          <table className="ls-table sg-text-tabelle">
            <thead>
              <tr>
                <th scope="col">Teilaufgabe</th>
                <th scope="col">Wofür es Punkte gibt</th>
                <th scope="col">Punkte</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>a)</td>
                <td>Signatur (2), Initialisierung (2), Schleife über alle Elemente (2), Verzweigung mit Zählung (3), Rückgabe (1)</td>
                <td>10</td>
              </tr>
              <tr>
                <td>b)</td>
                <td>Einlesen (2), Aufruf mit Verwendung des Ergebnisses (3), Startkandidat für das Maximum (2), Schleife mit Vergleich und Aktualisierung beider Merker (2), Ausgabe nach der Schleife (1)</td>
                <td>10</td>
              </tr>
              <tr>
                <td>c)</td>
                <td>Schreibtischtest der Funktion mit Ergebnis 2 (2), Schreibtischtest des Maximums mit Tag 3 und 5 Grad (3)</td>
                <td>5</td>
              </tr>
              <tr>
                <td>Summe</td>
                <td>Gleichwertig: kopfgesteuerte Schleifen, Maximum als zweite Funktion; die Indexbasis 1 ist durch das Szenario festgelegt (Index = Tag)</td>
                <td>25</td>
              </tr>
            </tbody>
          </table>
        </div>
        <LsHinweis titel="Typische Punktabzüge bei Aufgabe 3" art="warnung">
          <ul>
            <li>Die Funktion gibt die Anzahl aus, statt sie zurückzugeben; das Hauptprogramm hat dann nichts, womit es arbeiten kann.</li>
            <li>Aufruf ohne Argumente oder in falscher Reihenfolge (n, temperaturen).</li>
            <li>
              Startwert <code>max = 0</code>: Bei einem Monat mit lauter Minusgraden gäbe das einen
              wärmsten Tag mit 0 Grad, den es nicht gibt.
            </li>
            <li>Den Tag vergessen und nur die Temperatur merken; die Aufgabe verlangt beides.</li>
            <li>
              <code>&gt;=</code> statt <code>&gt;</code> beim Maximum: liefert den letzten statt den
              ersten wärmsten Tag, die Aufgabe verlangt den ersten.
            </li>
            <li>Die Ausgabe des Maximums in den Rumpf der Schleife setzen, dann erscheint sie bei jedem neuen Kandidaten.</li>
          </ul>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="abschluss" titel="Was jetzt sitzt">
        <p>
          Wenn du die drei Aufgaben auf Papier gelöst und mit den Musterlösungen verglichen hast,
          beherrschst du alles, was Struktogramm-Aufgaben in der AP1 typischerweise verlangen: ein
          gegebenes Struktogramm mit dem Schreibtischtest sicher lesen, Fehler in Grenzen und
          Startwerten finden, Lücken sinnvoll füllen, eine Eingabeprüfung als fußgesteuerte
          Schleife ergänzen, die Grundmuster über ein Feld zeichnen und sie in Funktion und
          Hauptprogramm aufteilen. Was noch fehlt, ist Routine: Wiederhole die Aufgabe, die dir
          am schwersten fiel, in einer Woche noch einmal ohne Lösung.
        </p>
        <p>
          Weiter geht es mit den <Link href="/pruefungen">Übungsprüfungen</Link>, in denen
          Struktogramm-Aufgaben zwischen den anderen Themen der AP1 stehen, so wie in der echten
          Prüfung. Anwendungsentwickler, die in der AP2 Struktogramme zu Klassendiagrammen zeichnen
          müssen, finden im <Link href="/uml-kurs">UML-Kurs</Link> die andere Hälfte: Klassen,
          Attribute und Methoden, deren Signaturen du hier schon gelesen hast.
        </p>
      </LsAbschnitt>
    </LektionLayout>
  );
}
