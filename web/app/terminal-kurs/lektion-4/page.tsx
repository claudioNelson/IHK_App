import type { Metadata } from "next";
import { LsAbschnitt, LsHinweis } from "../../lernen/_components/LsBausteine";
import QuizFrage from "../../lernen/_components/QuizFrage";
import LektionLayout from "../../components/kurs/LektionLayout";
import { Aufgabe, CodeBlock, Loesung } from "../../components/kurs/KursBausteine";
import Terminal from "../_components/Terminal";
import { terminalKurs } from "../_components/lektionen";

export const metadata: Metadata = {
  title: "Terminal-Kurs Lektion 4: Dateien lesen und durchsuchen",
  description:
    "Dateien und Logdateien im Linux-Terminal lesen und durchsuchen: cat, less, head, tail und grep mit den wichtigsten Optionen. Mit Übungs-Terminal und Spurensuche in einem Anmeldeprotokoll.",
  alternates: { canonical: "https://lernarena.app/terminal-kurs/lektion-4" },
};

const EIN_MOEGLICHER_WEG = "Ein möglicher Weg. Andere Wege sind genauso richtig, geprüft wird nur das Ergebnis.";

export default function Lektion4() {
  return (
    <LektionLayout
      kurs={terminalKurs}
      nr={4}
      lead="Dateien anzeigen, lange Protokolle in Ruhe lesen, nur den Anfang oder das Ende zeigen und mit grep genau die Zeilen finden, die dich interessieren. Zum Schluss gehst du in einem Anmeldeprotokoll mit Einbruchsversuch auf Spurensuche."
      uebungen={8}
      aufgabenText="3 Übungen und 1 Knobelaufgabe im Terminal, 4 Quizfragen"
    >
      <LsAbschnitt id="anzeigen" titel="Dateien anzeigen">
        <p>
          Auf einem Server ist fast alles Text: Einstellungen in <code>/etc</code>, Protokolle in{" "}
          <code>/var/log</code>, Skripte. Diese Befehle zeigen dir den Inhalt:
        </p>
        <div className="ls-table-wrap">
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Eingabe</th>
                <th scope="col">Was du siehst</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>cat notizen.txt</td>
                <td className="txt">Den ganzen Inhalt auf einmal. Gut für kurze Dateien.</td>
              </tr>
              <tr>
                <td>cat -n notizen.txt</td>
                <td className="txt">Dasselbe mit Zeilennummern.</td>
              </tr>
              <tr>
                <td>less /var/log/syslog</td>
                <td className="txt">
                  Lange Dateien zum Blättern: Leertaste weiter, <code>b</code> zurück,{" "}
                  <code>/wort</code> sucht, <code>q</code> beendet. Im Übungs-Terminal erscheint der
                  Inhalt direkt.
                </td>
              </tr>
              <tr>
                <td>head datei</td>
                <td className="txt">Die ersten 10 Zeilen. Mit <code>-n 3</code> nur die ersten 3.</td>
              </tr>
              <tr>
                <td>tail datei</td>
                <td className="txt">Die letzten 10 Zeilen. Mit <code>-n 5</code> nur die letzten 5.</td>
              </tr>
            </tbody>
          </table>
        </div>
        <p>
          Für Administratoren ist <code>tail</code> besonders wichtig: In Protokolldateien steht das
          Neueste immer unten. Wenn ein Dienst gerade abgestürzt ist, zeigt{" "}
          <code>tail /var/log/syslog</code> sofort, was zuletzt passiert ist. Und{" "}
          <code>tail -f</code> (follow) bleibt offen und zeigt jede neue Zeile, sobald sie dazukommt,
          bis du <kbd>Strg+C</kbd> drückst. So schaust du einem Dienst in Echtzeit bei der Arbeit zu.
        </p>
        <p>
          Eine Zeile aus <code>/var/log/syslog</code> ist meist so aufgebaut: Zeitpunkt, Name des
          Rechners, Programm mit Prozessnummer in eckigen Klammern, dann die Meldung.
        </p>
        <CodeBlock code={`2026-10-01T05:00:00.105200+00:00 lernarena backup.sh[1922]: ERROR: Ziel /mnt/backup nicht erreichbar`} />
        <Terminal aufgabe="l4-frei" titel="Freies Übungs-Terminal" hoehe={260} />

        <Aufgabe nr="4.1">
          <p>
            Zeige <code>notizen.txt</code> mit Zeilennummern an. Lass dir danach die letzten 5 Zeilen
            von <code>/var/log/syslog</code> anzeigen.
          </p>
          <Terminal aufgabe="l4-lesen" titel="Übung 4.1" />
          <Loesung code={"cat -n notizen.txt\ntail -n 5 /var/log/syslog"}>
            <p>
              {EIN_MOEGLICHER_WEG} Statt <code>tail -n 5</code> geht auch die Kurzform{" "}
              <code>tail -5</code>.
            </p>
          </Loesung>
        </Aufgabe>
      </LsAbschnitt>

      <LsAbschnitt id="grep" titel="Suchen mit grep">
        <p>
          Protokolle haben schnell Tausende Zeilen. <code>grep</code> zeigt nur die Zeilen, in denen
          ein Suchwort vorkommt. Erst kommt das Suchwort, dann die Datei:
        </p>
        <CodeBlock
          code={`azubi@lernarena:~$ grep ERROR /var/log/syslog
2026-10-01T05:00:00.105200+00:00 lernarena backup.sh[1922]: ERROR: Ziel /mnt/backup nicht erreichbar`}
        />
        <p>
          Das Suchwort wird im Terminal rot hervorgehoben. Die Zeit sieht bei dir anders aus, weil
          sie immer aktuell ist. Enthält das Suchwort Leerzeichen, gehört es in Anführungszeichen: <code>{'grep "Failed password" /var/log/auth.log'}</code>. Diese
          Optionen brauchst du am häufigsten:
        </p>
        <div className="ls-table-wrap">
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Option</th>
                <th scope="col">Wirkung</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>-i</td>
                <td className="txt">Groß- und Kleinschreibung egal: findet error, Error und ERROR (ignore case).</td>
              </tr>
              <tr>
                <td>-n</td>
                <td className="txt">Zeilennummer vor jedem Treffer.</td>
              </tr>
              <tr>
                <td>-c</td>
                <td className="txt">Nur zählen, wie viele Zeilen passen (count).</td>
              </tr>
              <tr>
                <td>-v</td>
                <td className="txt">Umgekehrt: nur die Zeilen, die das Wort NICHT enthalten.</td>
              </tr>
              <tr>
                <td>-r</td>
                <td className="txt">Alle Dateien in einem Ordner und seinen Unterordnern durchsuchen (rekursiv). Vor jedem Treffer steht dann der Dateiname.</td>
              </tr>
            </tbody>
          </table>
        </div>
        <p>
          Optionen lassen sich wie bei <code>ls</code> zusammenfassen: <code>grep -in error</code>{" "}
          ist dasselbe wie <code>grep -i -n error</code>.
        </p>

        <Aufgabe nr="4.2">
          <p>
            In <code>/var/log/auth.log</code> protokolliert der Server jede Anmeldung. Zeige alle
            Zeilen, in denen <code>Failed</code> vorkommt, also alle fehlgeschlagenen Anmeldungen.
            Lass grep danach mit <code>-c</code> zählen, wie viele es sind.
          </p>
          <Terminal aufgabe="l4-grep" titel="Übung 4.2" />
          <Loesung code={"grep Failed /var/log/auth.log\ngrep -c Failed /var/log/auth.log"}>
            <p>
              {EIN_MOEGLICHER_WEG} grep unterscheidet Groß- und Kleinschreibung:{" "}
              <code>grep failed</code> findet hier nichts.
            </p>
          </Loesung>
        </Aufgabe>

        <Aufgabe nr="4.3">
          <p>
            Suche in <code>/var/log/syslog</code> nach <code>error</code>, egal ob groß oder klein
            geschrieben, und lass dir die Zeilennummern zeigen. Finde danach mit <code>grep -r</code>{" "}
            alle Zeilen mit <code>TODO</code> in allen Dateien unter <code>projekte</code>.
          </p>
          <Terminal aufgabe="l4-suchen" titel="Übung 4.3" />
          <Loesung code={"grep -in error /var/log/syslog\ngrep -r TODO projekte"}>
            <p>
              {EIN_MOEGLICHER_WEG} Ohne <code>-i</code> fehlen die Zeilen mit <code>ERROR</code>{" "}
              und <code>Error</code>. Bei <code>-r</code> steht vor jedem Treffer die Datei, in der
              er steht.
            </p>
          </Loesung>
        </Aufgabe>

        <Aufgabe nr="4.4" label="Zum Knobeln 4.4">
          <p>
            Diese Aufgabe ist freiwillig, hier steht nicht genau, wie es geht. Jemand versucht, sich
            von außen auf dem Server anzumelden. Finde in <code>/var/log/auth.log</code> die fremde
            IP-Adresse, von der die meisten Fehlversuche kommen. Zähle dann mit grep, wie viele
            Fehlversuche von genau dieser Adresse kamen.
          </p>
          <Terminal aufgabe="l4-knobel" titel="Knobelaufgabe 4.4" />
          <Loesung code={'grep Failed /var/log/auth.log\ngrep -c "from 203.0.113.45" /var/log/auth.log'}>
            <p>
              {EIN_MOEGLICHER_WEG} Es sind 9 Versuche mit den Benutzernamen <code>root</code>,{" "}
              <code>admin</code> und <code>oracle</code>. Mit nur{" "}
              <code>grep -c 203.0.113.45</code> kommen 10 heraus, weil die Adresse auch in der Zeile
              steht, in der der Server die Verbindung trennt. Lies deshalb immer nach, was du zählst.
              In Lektion 6 lernst du, wie du solche Ranglisten automatisch erstellst.
            </p>
          </Loesung>
        </Aufgabe>
      </LsAbschnitt>

      <LsAbschnitt id="logs" titel="Wo welche Protokolle liegen">
        <div className="ls-table-wrap">
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Datei</th>
                <th scope="col">Was darin steht</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>/var/log/syslog</td>
                <td className="txt">Allgemeine Meldungen des Systems und vieler Dienste.</td>
              </tr>
              <tr>
                <td>/var/log/auth.log</td>
                <td className="txt">Anmeldungen, fehlgeschlagene Passwörter und jede Nutzung von sudo.</td>
              </tr>
              <tr>
                <td>/var/log/nginx/</td>
                <td className="txt">Zugriffe und Fehler des Webservers nginx (bei Apache: <code>/var/log/apache2/</code>).</td>
              </tr>
            </tbody>
          </table>
        </div>
        <p>
          Die Protokolle gehören dem Benutzer <code>syslog</code>, der sie schreibt, und der Gruppe{" "}
          <code>adm</code>. Lesen darf, wer in dieser Gruppe ist. Unter Ubuntu ist das der Benutzer,
          der bei der Installation angelegt wurde, hier also <code>azubi</code>. Andere brauchen{" "}
          <code>sudo</code>, dazu mehr in Lektion 5. Zusätzlich sammelt systemd alle Meldungen in
          seinem Journal, das du mit <code>journalctl</code> liest. Manche Systeme schreiben nur
          noch dorthin. Das Übungs-Terminal kennt nur die Dateien.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="windows" titel="Unter Windows">
        <LsHinweis titel="Dasselbe in PowerShell und cmd" icon="buch" label="Unter Windows">
          <p>
            In der PowerShell zeigt <code>Get-Content datei.txt</code> den Inhalt, als Kurznamen
            gehen auch <code>cat</code> und <code>type</code>. Anfang und Ende zeigen{" "}
            <code>Get-Content datei.txt -Head 5</code> und <code>-Tail 5</code>, und{" "}
            <code>Get-Content datei.txt -Wait</code> beobachtet die Datei wie <code>tail -f</code>.
            Gesucht wird mit <code>Select-String</code>, zum Beispiel{" "}
            <code>Select-String -Path datei.txt -Pattern error</code>. Es achtet standardmäßig
            nicht auf Groß- und Kleinschreibung.
          </p>
          <p>
            In der cmd zeigt <code>type datei.txt</code> den Inhalt, gesucht wird mit{" "}
            <code>findstr error datei.txt</code> (mit <code>/i</code> ohne Rücksicht auf Groß und
            Klein). Seine Systemmeldungen sammelt Windows in der Ereignisanzeige, in der PowerShell
            erreichbar mit <code>Get-WinEvent</code>.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="quiz" titel="Jetzt selbst testen">
        <p style={{ marginBottom: 18 }}>Vier Fragen zum Abschluss. Du hast so viele Versuche, wie du willst.</p>
        <QuizFrage
          nr={1}
          von={4}
          frage="Ein Dienst ist gerade abgestürzt. Welcher Befehl zeigt dir am schnellsten die neuesten Meldungen?"
          optionen={[
            { text: "head /var/log/syslog", richtig: false },
            { text: "tail /var/log/syslog", richtig: true },
            { text: "cat /etc/syslog", richtig: false },
            { text: "grep -c syslog", richtig: false },
          ]}
          erklaerung="In Protokollen steht das Neueste unten, tail zeigt die letzten Zeilen. head zeigt die ältesten."
        />
        <QuizFrage
          nr={2}
          von={4}
          frage="Was gibt grep -c Failed /var/log/auth.log aus?"
          optionen={[
            { text: "Alle Zeilen mit Failed", richtig: false },
            { text: "Alle Zeilen ohne Failed", richtig: false },
            { text: "Die Anzahl der Zeilen, in denen Failed vorkommt", richtig: true },
            { text: "Die Zeilennummern der Treffer", richtig: false },
          ]}
          erklaerung="-c steht für count, grep zählt nur. Die Zeilen ohne Treffer zeigt -v, Zeilennummern zeigt -n."
        />
        <QuizFrage
          nr={3}
          von={4}
          frage="grep error /var/log/syslog findet nichts, obwohl im Protokoll ERROR steht. Woran liegt das?"
          optionen={[
            { text: "grep unterscheidet Groß- und Kleinschreibung, -i hilft", richtig: true },
            { text: "grep braucht sudo, um Protokolle zu lesen", richtig: false },
            { text: "Das Suchwort muss in Anführungszeichen stehen", richtig: false },
            { text: "grep durchsucht nur die ersten 10 Zeilen", richtig: false },
          ]}
          erklaerung="Für grep sind error und ERROR verschiedene Wörter. Mit -i ist die Schreibweise egal. Anführungszeichen braucht man vor allem bei Leerzeichen im Suchwort."
        />
        <QuizFrage
          nr={4}
          von={4}
          frage="Wie beendest du tail -f, wenn du genug gesehen hast?"
          optionen={[
            { text: "Mit q", richtig: false },
            { text: "Mit exit", richtig: false },
            { text: "Gar nicht, es endet nach 10 Zeilen", richtig: false },
            { text: "Mit Strg+C", richtig: true },
          ]}
          erklaerung="tail -f läuft, bis du es mit Strg+C abbrichst. q beendet less, aber nicht tail."
        />
      </LsAbschnitt>
    </LektionLayout>
  );
}
