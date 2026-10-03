import type { Metadata } from "next";
import { LsAbschnitt, LsHinweis } from "../../lernen/_components/LsBausteine";
import QuizFrage from "../../lernen/_components/QuizFrage";
import LektionLayout from "../../components/kurs/LektionLayout";
import { Aufgabe, CodeBlock, Loesung } from "../../components/kurs/KursBausteine";
import Terminal from "../_components/Terminal";
import { terminalKurs } from "../_components/lektionen";

export const metadata: Metadata = {
  title: "Terminal-Kurs Lektion 5: Benutzer und Rechte",
  description:
    "Linux-Rechte verstehen: ls -l lesen, r, w und x für Besitzer, Gruppe und andere, Rechte als Zahl wie 755 und 644, chmod, chown, sudo, id und groups. Mit Übungs-Terminal im Browser.",
  alternates: { canonical: "https://lernarena.app/terminal-kurs/lektion-5" },
};

const EIN_MOEGLICHER_WEG = "Ein möglicher Weg. Andere Wege sind genauso richtig, geprüft wird nur das Ergebnis.";

export default function Lektion5() {
  return (
    <LektionLayout
      kurs={terminalKurs}
      nr={5}
      lead="Wer darf was? Du lernst, die Rechte in ls -l zu lesen, sie mit chmod als Buchstaben oder Zahl zu ändern, Besitzer mit chown zu wechseln und mit sudo kurz Administrator zu werden."
      uebungen={8}
      aufgabenText="3 Übungen und 1 Knobelaufgabe im Terminal, 4 Quizfragen"
    >
      <LsAbschnitt id="benutzer" titel="Benutzer und Gruppen">
        <p>
          Linux ist von Anfang an für viele Benutzer gebaut. Jede Datei und jeder Ordner hat
          genau einen <strong>Besitzer</strong> und genau eine <strong>Gruppe</strong>. Gruppen
          fassen Benutzer zusammen, die dieselben Rechte brauchen, zum Beispiel alle, die
          Protokolle lesen dürfen (Gruppe <code>adm</code>) oder alle, die Administrator werden
          dürfen (Gruppe <code>sudo</code>). Auch Dienste laufen als eigene Benutzer: Der Webserver
          ist meist <code>www-data</code>.
        </p>
        <div className="ls-table-wrap">
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Eingabe</th>
                <th scope="col">Was du erfährst</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>id</td>
                <td className="txt">Deine Benutzernummer (uid), deine Hauptgruppe (gid) und alle Gruppen, in denen du bist.</td>
              </tr>
              <tr>
                <td>groups</td>
                <td className="txt">Nur die Namen deiner Gruppen. <code>groups mia</code> zeigt die Gruppen von mia.</td>
              </tr>
              <tr>
                <td>cat /etc/passwd</td>
                <td className="txt">Alle Benutzer des Systems, einer pro Zeile.</td>
              </tr>
              <tr>
                <td>cat /etc/group</td>
                <td className="txt">Alle Gruppen und ihre Mitglieder.</td>
              </tr>
            </tbody>
          </table>
        </div>
        <CodeBlock
          code={`azubi@lernarena:~$ id
uid=1000(azubi) gid=1000(azubi) groups=1000(azubi),4(adm),27(sudo)`}
        />
      </LsAbschnitt>

      <LsAbschnitt id="lesen" titel="Rechte in ls -l lesen">
        <p>Jetzt kannst du endlich jede Spalte von <code>ls -l</code> verstehen:</p>
        <CodeBlock code={`-rw-r--r-- 1 azubi azubi 83 Sep 28 09:30 backup.sh`} />
        <div className="ls-table-wrap">
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Teil</th>
                <th scope="col">Bedeutung</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>-</td>
                <td className="txt">Die Art: <code>-</code> ist eine Datei, <code>d</code> ein Ordner (directory).</td>
              </tr>
              <tr>
                <td>rw-r--r--</td>
                <td className="txt">Die Rechte, drei Gruppen zu je drei Zeichen (siehe unten).</td>
              </tr>
              <tr>
                <td>1</td>
                <td className="txt">Die Anzahl der Verweise auf die Datei. Für den Anfang unwichtig.</td>
              </tr>
              <tr>
                <td>azubi azubi</td>
                <td className="txt">Erst der Besitzer, dann die Gruppe.</td>
              </tr>
              <tr>
                <td>83 Sep 28 09:30</td>
                <td className="txt">Größe in Byte und Zeitpunkt der letzten Änderung.</td>
              </tr>
            </tbody>
          </table>
        </div>
        <p>
          Die neun Rechte-Zeichen sind drei Dreiergruppen: für den <strong>Besitzer</strong> (u wie
          user), für die <strong>Gruppe</strong> (g wie group) und für alle <strong>anderen</strong>{" "}
          (o wie others). Jede Gruppe liest sich gleich:
        </p>
        <div className="ls-table-wrap">
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Zeichen</th>
                <th scope="col">Bei einer Datei</th>
                <th scope="col">Bei einem Ordner</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>r</td>
                <td className="txt">Inhalt lesen (read)</td>
                <td className="txt">Mit ls auflisten, was darin liegt</td>
              </tr>
              <tr>
                <td>w</td>
                <td className="txt">Inhalt ändern (write)</td>
                <td className="txt">Darin Dateien anlegen, umbenennen, löschen (zusammen mit x)</td>
              </tr>
              <tr>
                <td>x</td>
                <td className="txt">Als Programm ausführen (execute)</td>
                <td className="txt">Mit cd hineinwechseln und auf die Dateien darin zugreifen</td>
              </tr>
              <tr>
                <td>-</td>
                <td className="txt">Dieses Recht fehlt</td>
                <td className="txt">Dieses Recht fehlt</td>
              </tr>
            </tbody>
          </table>
        </div>
        <p>
          <code>rw-r--r--</code> heißt also: Der Besitzer darf lesen und schreiben, die Gruppe und
          alle anderen nur lesen. Linux prüft dabei nur eine Dreiergruppe: Bist du der Besitzer,
          gilt die erste, bist du in der Gruppe, die zweite, sonst die dritte.
        </p>
        <Terminal aufgabe="l5-frei" titel="Freies Übungs-Terminal" hoehe={260} />

        <Aufgabe nr="5.1">
          <p>
            Finde mit <code>id</code> oder <code>groups</code> heraus, in welchen Gruppen du bist.
            Lass dir danach mit <code>ls -l</code> die Rechte von <code>backup.sh</code> anzeigen.
            Darfst du die Datei ausführen?
          </p>
          <Terminal aufgabe="l5-lesen" titel="Übung 5.1" />
          <Loesung code={"id\nls -l backup.sh"}>
            <p>
              {EIN_MOEGLICHER_WEG} Die Rechte lauten <code>rw-r--r--</code>: Nirgends steht ein{" "}
              <code>x</code>, also darf niemand die Datei ausführen, auch du als Besitzer nicht.
            </p>
          </Loesung>
        </Aufgabe>
      </LsAbschnitt>

      <LsAbschnitt id="chmod" titel="Rechte ändern mit chmod">
        <p>
          <code>chmod</code> (change mode) ändert die Rechte. Das darf nur der Besitzer oder root.
          Es gibt zwei Schreibweisen. Mit <strong>Buchstaben</strong> sagst du, wer welches Recht
          bekommt oder verliert:
        </p>
        <div className="ls-table-wrap">
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Eingabe</th>
                <th scope="col">Wirkung</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>chmod u+x backup.sh</td>
                <td className="txt">Der Besitzer (u) bekommt (+) das Recht zum Ausführen (x).</td>
              </tr>
              <tr>
                <td>chmod g-w bericht.txt</td>
                <td className="txt">Die Gruppe (g) verliert (-) das Schreibrecht (w).</td>
              </tr>
              <tr>
                <td>chmod o=r index.html</td>
                <td className="txt">Andere (o) haben genau (=) nur noch das Leserecht.</td>
              </tr>
              <tr>
                <td>chmod a+r liste.txt</td>
                <td className="txt">Alle (a wie all) bekommen das Leserecht.</td>
              </tr>
            </tbody>
          </table>
        </div>
        <p>
          Die zweite Schreibweise ist eine <strong>Zahl</strong> aus drei Ziffern, eine je
          Dreiergruppe. Jedes Recht hat einen Wert: r = 4, w = 2, x = 1. Die Werte einer Gruppe
          zählst du zusammen. <code>rwx</code> ist 4 + 2 + 1 = 7, <code>r-x</code> ist 4 + 1 = 5,{" "}
          <code>r--</code> ist 4. Aus <code>rwxr-xr-x</code> wird so 755. Diese Werte begegnen dir
          ständig:
        </p>
        <div className="ls-table-wrap">
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Zahl</th>
                <th scope="col">Rechte</th>
                <th scope="col">Typisch für</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>755</td>
                <td>rwxr-xr-x</td>
                <td className="txt">Ordner und Programme: alle dürfen lesen und ausführen, nur der Besitzer ändern.</td>
              </tr>
              <tr>
                <td>644</td>
                <td>rw-r--r--</td>
                <td className="txt">Normale Dateien: alle lesen, nur der Besitzer schreibt.</td>
              </tr>
              <tr>
                <td>700</td>
                <td>rwx------</td>
                <td className="txt">Private Ordner und Skripte, nur für den Besitzer.</td>
              </tr>
              <tr>
                <td>600</td>
                <td>rw-------</td>
                <td className="txt">Geheimes wie Passwörter oder private Schlüssel.</td>
              </tr>
              <tr>
                <td>750</td>
                <td>rwxr-x---</td>
                <td className="txt">Ordner für ein Team: Gruppe darf lesen und hinein, andere nichts.</td>
              </tr>
            </tbody>
          </table>
        </div>
        <LsHinweis titel="Nie 777" art="warnung">
          <p>
            Bei Rechteproblemen liest man im Netz oft <code>chmod 777</code>. Dann darf jeder auf dem
            Server die Datei ändern und, wenn es ein Programm ist, ausführen. Das löst das Problem nicht, sondern öffnet ein
            neues. Besser: herausfinden, wer wirklich Zugriff braucht, und Besitzer oder Gruppe
            passend setzen.
          </p>
        </LsHinweis>

        <Aufgabe nr="5.2">
          <p>
            Mach <code>backup.sh</code> mit <code>chmod u+x</code> für dich als Besitzer ausführbar.
            In <code>zugang.txt</code> steht ein Passwort: Setze die Datei mit <code>chmod</code> und
            einer Zahl so, dass nur noch du lesen und schreiben darfst (<code>rw-------</code>, die
            Zahl steht in der Tabelle oben).
          </p>
          <Terminal aufgabe="l5-chmod" titel="Übung 5.2" />
          <Loesung code={"chmod u+x backup.sh\nchmod 600 zugang.txt\nls -l"}>
            <p>
              {EIN_MOEGLICHER_WEG} Nach <code>chmod u+x</code> erscheint <code>backup.sh</code> in{" "}
              <code>ls</code> grün: Das ist die Farbe für ausführbare Dateien.
            </p>
          </Loesung>
        </Aufgabe>
      </LsAbschnitt>

      <LsAbschnitt id="sudo" titel="sudo und chown">
        <p>
          Der Benutzer <strong>root</strong> darf alles. Damit niemand dauerhaft als root arbeitet,
          gibt es <code>sudo</code> (etwa: „tu das als Administrator“). Es führt einen einzelnen
          Befehl mit root-Rechten aus, aber nur für Mitglieder der Gruppe <code>sudo</code>. Auf
          einem echten Server fragt sudo dabei nach deinem eigenen Passwort, das Übungs-Terminal
          lässt das weg. Jeder Aufruf landet in <code>/var/log/auth.log</code>.
        </p>
        <CodeBlock
          code={`azubi@lernarena:~$ cat /etc/shadow
cat: /etc/shadow: Permission denied
azubi@lernarena:~$ sudo cat /etc/shadow
root:*:20000:0:99999:7:::
azubi:$y$j9T$geheim:20000:0:99999:7:::`}
        />
        <p>
          <code>chown</code> (change owner) ändert Besitzer und Gruppe. Dateien verschenken darf nur
          root, deshalb steht fast immer <code>sudo</code> davor:
        </p>
        <div className="ls-table-wrap">
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Eingabe</th>
                <th scope="col">Wirkung</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>sudo chown mia bericht.txt</td>
                <td className="txt">mia wird Besitzerin, die Gruppe bleibt.</td>
              </tr>
              <tr>
                <td>sudo chown mia:mia bericht.txt</td>
                <td className="txt">Besitzer und Gruppe auf einmal, getrennt durch einen Doppelpunkt.</td>
              </tr>
              <tr>
                <td>sudo chown -R www-data:www-data /var/www/html</td>
                <td className="txt">Ein ganzer Ordner mit allem darin (rekursiv).</td>
              </tr>
            </tbody>
          </table>
        </div>

        <Aufgabe nr="5.3">
          <p>
            Die Webseiten in <code>/var/www/html</code> gehören noch root. Der Webserver läuft als{" "}
            <code>www-data</code> und soll sie besitzen. Übergib beide Dateien mit{" "}
            <code>sudo chown</code> an <code>www-data</code>, Besitzer und Gruppe. Probier es ruhig
            zuerst ohne <code>sudo</code>.
          </p>
          <Terminal aufgabe="l5-chown" titel="Übung 5.3" />
          <Loesung code={"sudo chown www-data:www-data /var/www/html/index.html /var/www/html/kontakt.html\nls -l /var/www/html"}>
            <p>
              {EIN_MOEGLICHER_WEG} Kürzer geht es mit dem Platzhalter:{" "}
              <code>sudo chown www-data:www-data /var/www/html/*</code>. Ohne <code>sudo</code>{" "}
              meldet chown <code>Operation not permitted</code>.
            </p>
          </Loesung>
        </Aufgabe>

        <Aufgabe nr="5.4" label="Zum Knobeln 5.4">
          <p>
            Diese Aufgabe ist freiwillig, hier steht nicht genau, wie es geht. Lege den Ordner{" "}
            <code>team</code> an: Du darfst alles, deine Gruppe darf hineinschauen und hineinwechseln,
            alle anderen gar nichts. Lege darin die Datei <code>plan.txt</code> an: Du darfst lesen
            und schreiben, deine Gruppe nur lesen, alle anderen gar nichts.
          </p>
          <Terminal aufgabe="l5-knobel" titel="Knobelaufgabe 5.4" />
          <Loesung code={"mkdir team\nchmod 750 team\ntouch team/plan.txt\nchmod 640 team/plan.txt\nls -l team"}>
            <p>
              {EIN_MOEGLICHER_WEG} Der Ordner braucht <code>rwxr-x---</code> = 750, die Datei{" "}
              <code>rw-r-----</code> = 640. Ohne <code>x</code> am Ordner könnte die Gruppe die
              Datei darin nicht lesen, selbst wenn die Datei es erlaubt.
            </p>
          </Loesung>
        </Aufgabe>
      </LsAbschnitt>

      <LsAbschnitt id="windows" titel="Unter Windows">
        <LsHinweis titel="Rechte unter Windows" icon="buch" label="Unter Windows">
          <p>
            Windows kennt keine drei Dreiergruppen <code>rwx</code>, sondern Zugriffslisten (ACL):
            Zu jeder Datei steht eine Liste von Benutzern und Gruppen mit ihren Rechten wie Lesen,
            Ändern oder Vollzugriff. In der cmd zeigt <code>icacls datei.txt</code> diese Liste an,
            mit <code>/grant</code> und <code>/deny</code> änderst du sie. In der PowerShell gibt es
            dafür <code>Get-Acl</code> und <code>Set-Acl</code>. Den Besitzer übernimmt{" "}
            <code>takeown</code>.
          </p>
          <p>
            Deine Gruppen zeigt <code>whoami /groups</code>. Statt <code>sudo</code> startet man ein
            Programm „Als Administrator“, etwa über einen Rechtsklick auf die PowerShell. Ab Windows 11
            24H2 gibt es auch einen eigenen Befehl <code>sudo</code>, den man erst in den
            Einstellungen einschaltet.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="quiz" titel="Jetzt selbst testen">
        <p style={{ marginBottom: 18 }}>Vier Fragen zum Abschluss. Du hast so viele Versuche, wie du willst.</p>
        <QuizFrage
          nr={1}
          von={4}
          frage="ls -l zeigt -rw-r----- 1 syslog adm syslog. Wer darf die Datei lesen?"
          optionen={[
            { text: "Nur der Benutzer syslog", richtig: false },
            { text: "syslog und alle Mitglieder der Gruppe adm", richtig: true },
            { text: "Alle Benutzer", richtig: false },
            { text: "Niemand, es fehlt das x", richtig: false },
          ]}
          erklaerung="rw- gilt für den Besitzer syslog, r-- für die Gruppe adm, --- für alle anderen. root darf ohnehin alles. Zum Lesen einer Datei braucht man kein x, das ist nur zum Ausführen."
        />
        <QuizFrage
          nr={2}
          von={4}
          frage="Welche Zahl entspricht rwxr-x---?"
          optionen={[
            { text: "755", richtig: false },
            { text: "740", richtig: false },
            { text: "750", richtig: true },
            { text: "640", richtig: false },
          ]}
          erklaerung="rwx = 4 + 2 + 1 = 7, r-x = 4 + 1 = 5, --- = 0. Zusammen 750."
        />
        <QuizFrage
          nr={3}
          von={4}
          frage="chown mia bericht.txt meldet Operation not permitted. Was ist die übliche Lösung?"
          optionen={[
            { text: "chmod 777 bericht.txt", richtig: false },
            { text: "sudo chown mia bericht.txt", richtig: true },
            { text: "chown -R mia bericht.txt", richtig: false },
            { text: "Die Datei löschen und neu anlegen", richtig: false },
          ]}
          erklaerung="Den Besitzer ändern darf nur root. sudo führt den Befehl mit root-Rechten aus. chmod 777 ändert nicht den Besitzer, sondern öffnet die Datei für alle."
        />
        <QuizFrage
          nr={4}
          von={4}
          frage="Ein Ordner hat die Rechte rw-rw-rw-. Was passiert, wenn du cd ordner tippst?"
          optionen={[
            { text: "Es klappt, weil du lesen und schreiben darfst", richtig: false },
            { text: "Es klappt nur mit -r", richtig: false },
            { text: "Der Ordner wird gelöscht", richtig: false },
            { text: "Permission denied, weil das x zum Hineinwechseln fehlt", richtig: true },
          ]}
          erklaerung="Bei Ordnern bedeutet x: hineinwechseln und auf die Dateien darin zugreifen. Ohne x hilft auch r und w nichts."
        />
      </LsAbschnitt>
    </LektionLayout>
  );
}
