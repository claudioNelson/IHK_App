import type { Metadata } from "next";
import { LsAbschnitt, LsHinweis } from "../../lernen/_components/LsBausteine";
import QuizFrage from "../../lernen/_components/QuizFrage";
import LektionLayout from "../../components/kurs/LektionLayout";
import { Aufgabe, CodeBlock, Loesung } from "../../components/kurs/KursBausteine";
import Terminal from "../_components/Terminal";
import { terminalKurs } from "../_components/lektionen";

export const metadata: Metadata = {
  title: "Terminal-Kurs Lektion 6: Pipes und Umleitung",
  description:
    "Ausgaben in Dateien schreiben mit > und >>, Fehler umleiten mit 2> und /dev/null, Befehle mit | verketten und mit sort, uniq, cut, wc und tee auswerten. Mit Übungs-Terminal im Browser.",
  alternates: { canonical: "https://lernarena.app/terminal-kurs/lektion-6" },
};

const EIN_MOEGLICHER_WEG = "Ein möglicher Weg. Andere Wege sind genauso richtig, geprüft wird nur das Ergebnis.";

export default function Lektion6() {
  return (
    <LektionLayout
      kurs={terminalKurs}
      nr={6}
      lead="Die eigentliche Stärke des Terminals: Ausgaben in Dateien schreiben, Fehlermeldungen getrennt behandeln und kleine Befehle mit | zu einer Kette verbinden, die in einer Zeile auswertet, wofür man sonst ein Programm bräuchte."
      uebungen={8}
      aufgabenText="3 Übungen und 1 Knobelaufgabe im Terminal, 4 Quizfragen"
    >
      <LsAbschnitt id="kanaele" titel="Drei Kanäle">
        <p>
          Jeder Befehl hat drei Kanäle, über die Text fließt. Bisher landete alles auf dem
          Bildschirm, aber du kannst jeden Kanal umleiten:
        </p>
        <div className="ls-table-wrap">
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Kanal</th>
                <th scope="col">Nummer</th>
                <th scope="col">Wofür</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>stdin</td>
                <td>0</td>
                <td className="txt">Eingabe, die in den Befehl hineinfließt (standard input).</td>
              </tr>
              <tr>
                <td>stdout</td>
                <td>1</td>
                <td className="txt">Die normale Ausgabe (standard output).</td>
              </tr>
              <tr>
                <td>stderr</td>
                <td>2</td>
                <td className="txt">Fehlermeldungen (standard error). Getrennt, damit sie nicht in den Ergebnissen landen.</td>
              </tr>
            </tbody>
          </table>
        </div>
      </LsAbschnitt>

      <LsAbschnitt id="umleiten" titel="Ausgabe in Dateien schreiben">
        <div className="ls-table-wrap">
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Eingabe</th>
                <th scope="col">Was passiert</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>ls -l &gt; liste.txt</td>
                <td className="txt">
                  Die Ausgabe landet in <code>liste.txt</code> statt auf dem Bildschirm. Gibt es die
                  Datei schon, wird sie <strong>überschrieben</strong>.
                </td>
              </tr>
              <tr>
                <td>echo Text &gt;&gt; log.txt</td>
                <td className="txt">Zwei <code>&gt;&gt;</code> hängen die Ausgabe an das Ende an. Der alte Inhalt bleibt.</td>
              </tr>
              <tr>
                <td>wc -l &lt; liste.txt</td>
                <td className="txt">Umgekehrt: Der Befehl liest seine Eingabe aus der Datei.</td>
              </tr>
            </tbody>
          </table>
        </div>
        <p>
          Mit <code>echo</code> und <code>&gt;</code> schreibst du schnell eine Zeile in eine Datei,
          ganz ohne Texteditor. Enthält der Text Leerzeichen, setze ihn in Anführungszeichen. Bei
          Sonderzeichen wie <code>!</code> oder <code>$</code> nimm einfache Anführungszeichen{" "}
          <code>{"'…'"}</code>, denn in doppelten wertet die Bash sie noch aus.
        </p>
        <CodeBlock
          code={`azubi@lernarena:~$ echo "Erste Zeile" > test.txt
azubi@lernarena:~$ echo "Zweite Zeile" >> test.txt
azubi@lernarena:~$ cat test.txt
Erste Zeile
Zweite Zeile`}
        />
        <LsHinweis titel="Ein > zu wenig, und alles ist weg" art="warnung">
          <p>
            <code>&gt;</code> leert die Datei, bevor der Befehl überhaupt startet. Wer ein Protokoll
            ergänzen will und versehentlich nur ein <code>&gt;</code> tippt, hat danach nur noch die
            neue Zeile. Im Zweifel lieber <code>&gt;&gt;</code>.
          </p>
        </LsHinweis>
        <Terminal aufgabe="l6-frei" titel="Freies Übungs-Terminal" hoehe={260} />

        <Aufgabe nr="6.1">
          <p>
            Schreib mit <code>echo</code> die Zeile <code>Server web01 geprüft</code> in die neue
            Datei <code>protokoll.txt</code>. Hänge danach die Zeile <code>Backup ok</code> an, ohne
            die erste zu verlieren. Speichere zum Schluss die Ausgabe von <code>ls -l</code> in der
            Datei <code>liste.txt</code>.
          </p>
          <Terminal aufgabe="l6-umleiten" titel="Übung 6.1" />
          <Loesung code={'echo "Server web01 geprüft" > protokoll.txt\necho "Backup ok" >> protokoll.txt\nls -l > liste.txt\ncat protokoll.txt'}>
            <p>
              {EIN_MOEGLICHER_WEG} Hast du beim zweiten Mal nur ein <code>&gt;</code> getippt, ist
              die erste Zeile weg. Dann einfach beide Befehle noch einmal richtig.
            </p>
          </Loesung>
        </Aufgabe>
      </LsAbschnitt>

      <LsAbschnitt id="pipes" titel="Befehle verketten mit |">
        <p>
          Das Zeichen <code>|</code> heißt <strong>Pipe</strong> (Rohr). Es leitet die Ausgabe des
          linken Befehls direkt als Eingabe in den rechten, ohne Umweg über eine Datei. So lassen
          sich kleine Befehle wie Bausteine zusammenstecken:
        </p>
        <CodeBlock
          code={`azubi@lernarena:~$ cat /etc/passwd | wc -l
5`}
        />
        <p>
          Dafür gibt es eine Reihe von Befehlen, die Text aus einer Pipe lesen und umformen:
        </p>
        <div className="ls-table-wrap">
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Befehl</th>
                <th scope="col">Was er tut</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>wc -l</td>
                <td className="txt">Zählt die Zeilen (word count, -l für lines).</td>
              </tr>
              <tr>
                <td>sort</td>
                <td className="txt">Sortiert alphabetisch. <code>-n</code> nach Zahlenwert, <code>-r</code> umgekehrt.</td>
              </tr>
              <tr>
                <td>uniq -c</td>
                <td className="txt">Fasst gleiche Zeilen, die direkt untereinander stehen, zusammen und zählt sie. Deshalb immer erst sortieren.</td>
              </tr>
              <tr>
                <td>cut -d: -f1</td>
                <td className="txt">Schneidet eine Spalte aus. <code>-d</code> nennt das Trennzeichen, <code>-f</code> die Nummer der Spalte (field).</td>
              </tr>
              <tr>
                <td>grep</td>
                <td className="txt">
                  Filtert Zeilen, auch mitten in einer Kette. Mit <code>-o</code> nur den passenden
                  Teil statt der ganzen Zeile, zum Beispiel <code>{"grep -o 'from [0-9.]*'"}</code>: das
                  Wort „from“, ein Leerzeichen und dann beliebig viele Ziffern und Punkte.
                </td>
              </tr>
              <tr>
                <td>head, tail</td>
                <td className="txt">Nur die ersten oder letzten Zeilen, zum Beispiel die ersten drei einer Rangliste.</td>
              </tr>
            </tbody>
          </table>
        </div>
        <p>
          In <code>/etc/passwd</code> stehen die Angaben eines Benutzers in Spalten, getrennt durch
          Doppelpunkte. Ganz vorn steht der Name:
        </p>
        <CodeBlock code={`azubi:x:1000:1000:Azubi:/home/azubi:/bin/bash`} />

        <Aufgabe nr="6.2">
          <p>
            Zähle mit einer Pipe, wie viele Zeilen <code>/etc/passwd</code> hat, also wie viele
            Benutzer es gibt. Zeige danach nur die Benutzernamen, alphabetisch sortiert: erst mit{" "}
            <code>cut</code> die erste Spalte ausschneiden, dann mit <code>|</code> an{" "}
            <code>sort</code> weiterreichen.
          </p>
          <Terminal aufgabe="l6-pipes" titel="Übung 6.2" />
          <Loesung code={"cat /etc/passwd | wc -l\ncut -d: -f1 /etc/passwd | sort"}>
            <p>
              {EIN_MOEGLICHER_WEG} Auf einem echten Server stehen in <code>/etc/passwd</code> noch
              viele weitere Systembenutzer, oft über 30 Zeilen.
            </p>
          </Loesung>
        </Aufgabe>
      </LsAbschnitt>

      <LsAbschnitt id="fehler" titel="Fehlermeldungen umleiten">
        <p>
          Fehlermeldungen laufen über Kanal 2 und kommen deshalb an <code>&gt;</code> vorbei. Für sie
          gibt es eigene Zeichen:
        </p>
        <div className="ls-table-wrap">
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Eingabe</th>
                <th scope="col">Was passiert</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>befehl 2&gt; fehler.txt</td>
                <td className="txt">Fehlermeldungen in eine Datei, die normale Ausgabe bleibt auf dem Bildschirm.</td>
              </tr>
              <tr>
                <td>befehl 2&gt;/dev/null</td>
                <td className="txt">
                  Fehlermeldungen wegwerfen. <code>/dev/null</code> ist ein Gerät, das alles schluckt,
                  was man hineinschreibt.
                </td>
              </tr>
              <tr>
                <td>befehl &gt; alles.txt 2&gt;&amp;1</td>
                <td className="txt">Beides in dieselbe Datei: Kanal 2 geht dorthin, wohin Kanal 1 gerade zeigt.</td>
              </tr>
            </tbody>
          </table>
        </div>
        <p>
          Typischer Fall: Du durchsuchst <code>/etc</code>, aber einige Dateien darfst du nicht lesen.
          Zwischen den Treffern stehen dann lauter <code>Permission denied</code>. Mit{" "}
          <code>2&gt;/dev/null</code> siehst du nur noch die Treffer.
        </p>

        <Aufgabe nr="6.3">
          <p>
            Leite die Fehlermeldung von <code>ls gibtsnicht</code> mit <code>2&gt;</code> in die
            Datei <code>fehler.txt</code> um. Suche danach mit <code>grep -r</code> nach{" "}
            <code>PermitRootLogin</code> in <code>/etc</code>, zuerst ohne und dann mit{" "}
            <code>2&gt;/dev/null</code>, damit keine Fehlermeldung mehr erscheint.
          </p>
          <Terminal aufgabe="l6-fehler" titel="Übung 6.3" />
          <Loesung code={"ls gibtsnicht 2> fehler.txt\ncat fehler.txt\ngrep -r PermitRootLogin /etc 2>/dev/null"}>
            <p>
              {EIN_MOEGLICHER_WEG} Die Meldung zu <code>/etc/shadow</code> verschwindet, der Treffer
              in <code>/etc/ssh/sshd_config</code> bleibt. <code>PermitRootLogin no</code> heißt
              übrigens: root darf sich nicht direkt per SSH anmelden. Das ist eine wichtige
              Sicherheitseinstellung.
            </p>
          </Loesung>
        </Aufgabe>

        <Aufgabe nr="6.4" label="Zum Knobeln 6.4">
          <p>
            Diese Aufgabe ist freiwillig, hier steht nicht genau, wie es geht. In Lektion 4 hast du
            die Adresse mit den meisten Fehlversuchen in <code>/var/log/auth.log</code> noch selbst
            heraussuchen müssen. Jetzt soll eine
            einzige Zeile eine Rangliste erstellen: Welche IP-Adresse hatte wie viele Fehlversuche,
            die häufigste oben. Speichere das Ergebnis in <code>rangliste.txt</code>.
          </p>
          <Terminal aufgabe="l6-knobel" titel="Knobelaufgabe 6.4" />
          <Loesung code={"grep Failed /var/log/auth.log | grep -o 'from [0-9.]*' | sort | uniq -c | sort -nr > rangliste.txt\ncat rangliste.txt"}>
            <p>
              {EIN_MOEGLICHER_WEG} Lies die Kette von links nach rechts: Zeilen mit Failed, daraus
              nur „from“ und die Adresse, sortieren, gleiche zählen, nach Anzahl absteigend
              sortieren, in die Datei. In <code>[0-9.]*</code> stehen die eckigen Klammern für
              „eine Ziffer oder ein Punkt“, der Stern für „beliebig oft“. Genau so werten
              Administratoren Protokolle aus, bevor sie eine Adresse sperren.
            </p>
          </Loesung>
        </Aufgabe>
      </LsAbschnitt>

      <LsAbschnitt id="tee" titel="Sehen und speichern mit tee">
        <p>
          Manchmal willst du eine Ausgabe sehen und gleichzeitig speichern. <code>tee</code>{" "}
          funktioniert wie ein T-Stück in einer Wasserleitung: Es schreibt alles auf den Bildschirm
          und zusätzlich in eine Datei. Mit <code>-a</code> hängt es an, statt zu überschreiben.
        </p>
        <CodeBlock
          code={`azubi@lernarena:~$ grep -c Failed /var/log/auth.log | tee anzahl.txt
13`}
        />
        <LsHinweis titel="Geschafft: der erste Teil des Kurses">
          <p>
            Mit diesen sechs Lektionen kennst du die wichtigsten Grundbefehle der Administration.
            Im freien Terminal kannst du alles kombinieren. Weitere Lektionen zu Prozessen,
            Netzwerk, Paketen und Windows sind geplant.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="windows" titel="Unter Windows">
        <LsHinweis titel="Dasselbe in PowerShell und cmd" icon="buch" label="Unter Windows">
          <p>
            <code>&gt;</code>, <code>&gt;&gt;</code> und <code>2&gt;</code> gibt es auch in der
            PowerShell und in der cmd. Nur der Abfluss für Ausgaben heißt anders: in der PowerShell{" "}
            <code>2&gt;$null</code>, in der cmd <code>2&gt;nul</code>.
          </p>
          <p>
            Auch die Pipe <code>|</code> gibt es in beiden. In der PowerShell fließen dabei aber keine
            Textzeilen, sondern Objekte mit Eigenschaften. Statt mit <code>cut</code> Spalten
            auszuschneiden, wählst du Eigenschaften aus:{" "}
            <code>Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 Name, CPU</code>.
            Die Gegenstücke heißen <code>Sort-Object</code>, <code>Select-Object</code> (wie{" "}
            <code>head</code> und <code>cut</code>), <code>Group-Object</code> (wie{" "}
            <code>uniq -c</code>), <code>Measure-Object</code> (wie <code>wc</code>) und{" "}
            <code>Tee-Object</code>.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="quiz" titel="Jetzt selbst testen">
        <p style={{ marginBottom: 18 }}>Vier Fragen zum Abschluss. Du hast so viele Versuche, wie du willst.</p>
        <QuizFrage
          nr={1}
          von={4}
          frage="In log.txt stehen 100 Zeilen. Was steht nach echo fertig > log.txt darin?"
          optionen={[
            { text: "101 Zeilen, fertig steht am Ende", richtig: false },
            { text: "Nur noch die Zeile fertig", richtig: true },
            { text: "Die 100 Zeilen, echo schreibt nur auf den Bildschirm", richtig: false },
            { text: "Eine Fehlermeldung, weil die Datei schon existiert", richtig: false },
          ]}
          erklaerung="Ein > überschreibt die Datei. Zum Anhängen braucht es >>."
        />
        <QuizFrage
          nr={2}
          von={4}
          frage="Warum steht vor uniq -c fast immer ein sort?"
          optionen={[
            { text: "uniq funktioniert nur mit Zahlen", richtig: false },
            { text: "sort entfernt die doppelten Zeilen", richtig: false },
            { text: "uniq fasst nur gleiche Zeilen zusammen, die direkt untereinander stehen", richtig: true },
            { text: "Ohne sort gibt uniq eine Fehlermeldung", richtig: false },
          ]}
          erklaerung="uniq vergleicht jede Zeile nur mit der vorherigen. sort bringt gleiche Zeilen nebeneinander, erst dann zählt uniq -c richtig."
        />
        <QuizFrage
          nr={3}
          von={4}
          frage="Was bewirkt 2>/dev/null am Ende eines Befehls?"
          optionen={[
            { text: "Fehlermeldungen werden weggeworfen", richtig: true },
            { text: "Die normale Ausgabe wird weggeworfen", richtig: false },
            { text: "Der Befehl läuft zweimal", richtig: false },
            { text: "Die Ausgabe landet in einer Datei namens null", richtig: false },
          ]}
          erklaerung="2 ist der Kanal für Fehlermeldungen, /dev/null schluckt alles. Die normale Ausgabe (Kanal 1) erscheint weiter auf dem Bildschirm."
        />
        <QuizFrage
          nr={4}
          von={4}
          frage="Was gibt cut -d: -f1 /etc/passwd aus?"
          optionen={[
            { text: "Die erste Zeile der Datei", richtig: false },
            { text: "Alle Zeilen, die mit einem Doppelpunkt beginnen", richtig: false },
            { text: "Die Anzahl der Benutzer als Zahl", richtig: false },
            { text: "Die Namen aller Benutzer", richtig: true },
          ]}
          erklaerung="-d: legt den Doppelpunkt als Trennzeichen fest, -f1 wählt die erste Spalte. In /etc/passwd ist das der Benutzername."
        />
      </LsAbschnitt>
    </LektionLayout>
  );
}
