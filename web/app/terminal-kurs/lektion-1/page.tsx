import type { Metadata } from "next";
import { LsAbschnitt, LsHinweis } from "../../lernen/_components/LsBausteine";
import QuizFrage from "../../lernen/_components/QuizFrage";
import LektionLayout from "../../components/kurs/LektionLayout";
import { Aufgabe, CodeBlock, Loesung } from "../../components/kurs/KursBausteine";
import Terminal from "../_components/Terminal";
import { terminalKurs } from "../_components/lektionen";

export const metadata: Metadata = {
  title: "Terminal-Kurs Lektion 1: Was ist ein Terminal?",
  description:
    "Was ein Terminal ist, warum Administratoren damit arbeiten, wie du die Eingabeaufforderung liest und wie ein Befehl aus Befehl, Option und Argument aufgebaut ist. Mit Übungs-Terminal im Browser.",
  alternates: { canonical: "https://lernarena.app/terminal-kurs/lektion-1" },
};

const EIN_MOEGLICHER_WEG = "Ein möglicher Weg. Andere Wege sind genauso richtig, geprüft wird nur das Ergebnis.";

export default function Lektion1() {
  return (
    <LektionLayout
      kurs={terminalKurs}
      nr={1}
      lead="Was ein Terminal ist, warum Administratoren damit arbeiten, wie du die Eingabeaufforderung liest und wie jeder Befehl aus Befehl, Option und Argument aufgebaut ist. Alles probierst du direkt im Übungs-Terminal aus."
      uebungen={8}
      aufgabenText="3 Übungen und 1 Knobelaufgabe im Terminal, 4 Quizfragen"
    >
      <LsAbschnitt id="warum" titel="Warum Administratoren das Terminal nutzen">
        <p>
          Server im Rechenzentrum oder in der Cloud haben fast nie einen Bildschirm, eine Maus
          oder Fenster. Du verbindest dich über das Netzwerk mit ihnen, meist per{" "}
          <strong>SSH</strong> (Secure Shell, eine verschlüsselte Verbindung zu einem entfernten
          Rechner), und bekommst genau eines: eine Zeile, in die du Befehle tippst.
          Darunter erscheint die Antwort als Text. Genau das ist ein <strong>Terminal</strong>.
        </p>
        <p>Was zuerst altmodisch wirkt, hat handfeste Vorteile:</p>
        <ul>
          <li>
            <strong>Schnell:</strong> Ein Befehl erledigt, wofür du sonst zehnmal klicken müsstest.
          </li>
          <li>
            <strong>Wiederholbar:</strong> Befehle lassen sich aufschreiben und später als Skript
            immer wieder ausführen, auf einem oder auf hundert Servern.
          </li>
          <li>
            <strong>Überall gleich:</strong> Jeder Linux-Server versteht dieselben Grundbefehle, egal
            wer ihn eingerichtet hat.
          </li>
          <li>
            <strong>Sparsam:</strong> Text braucht kaum Bandbreite. Ein Terminal funktioniert auch
            über eine schwache Verbindung.
          </li>
        </ul>
        <p>
          Zwei Begriffe begegnen dir ständig. Das <strong>Terminal</strong> ist das Fenster, in dem
          du tippst und Text zurückbekommst. Die <strong>Shell</strong> ist das Programm darin, das
          deine Befehle versteht und ausführt. Unter Linux ist das fast immer die{" "}
          <strong>Bash</strong>, unter Windows die <strong>PowerShell</strong>. Im Alltag sagt man
          auch einfach Konsole oder Kommandozeile.
        </p>

        <LsHinweis titel="Kaputt machen kannst du hier nichts">
          <p>
            Das Übungs-Terminal läuft komplett in deinem Browser. Es ist ein nachgebautes Linux mit
            eigenen Ordnern und Dateien, getrennt von deinem Rechner. Mit „Zurücksetzen“ ist alles
            wieder wie am Anfang.
          </p>
        </LsHinweis>

        <p>
          Probier es gleich aus: Klicke in das dunkle Feld, tippe <code>help</code> und drücke{" "}
          <kbd>Enter</kbd>.
        </p>
        <Terminal aufgabe="l1-frei" titel="Freies Übungs-Terminal" hoehe={260} />
      </LsAbschnitt>

      <LsAbschnitt id="prompt" titel="Die Eingabeaufforderung lesen">
        <p>
          Vor dem Cursor steht immer eine kurze Zeile, zum Beispiel{" "}
          <code>azubi@lernarena:~$</code>. Das ist die <strong>Eingabeaufforderung</strong>, auf
          Englisch <strong>Prompt</strong>. Sie sagt dir, wo du bist und wer du bist:
        </p>
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
                <td>azubi</td>
                <td className="txt">Der Benutzer, mit dem du angemeldet bist.</td>
              </tr>
              <tr>
                <td>@lernarena</td>
                <td className="txt">Der Name des Rechners (Hostname). Wichtig, sobald du mit mehreren Servern gleichzeitig arbeitest.</td>
              </tr>
              <tr>
                <td>:~</td>
                <td className="txt">Der Ordner, in dem du gerade bist. Die Tilde ~ steht für deinen Home-Ordner, hier /home/azubi.</td>
              </tr>
              <tr>
                <td>$</td>
                <td className="txt">Du arbeitest als normaler Benutzer. Steht dort ein #, bist du root, der Administrator mit allen Rechten.</td>
              </tr>
            </tbody>
          </table>
        </div>
        <LsHinweis titel="Endet der Prompt mit #, ist Vorsicht angesagt" art="warnung">
          <p>
            root darf alles, auch Systemdateien löschen, ohne nachzufragen. Deshalb arbeiten
            Administratoren normalerweise als normaler Benutzer und holen sich Administratorrechte
            nur für einzelne Befehle mit <code>sudo</code>. Das kommt in Lektion 5.
          </p>
        </LsHinweis>
        <p>
          In Anleitungen im Netz steht vor Befehlen oft ein <code>$</code>, zum Beispiel{" "}
          <code>$ ls -l</code>. Das Zeichen zeigt nur, dass hier ein Befehl folgt. Du tippst es
          nicht mit.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="erster-befehl" titel="Dein erster Befehl">
        <p>
          Ein Befehl ist ein Wort, das du hinter den Prompt tippst und mit <kbd>Enter</kbd>{" "}
          abschickst. Das Terminal führt ihn aus, zeigt die Antwort und wartet mit einem neuen
          Prompt auf den nächsten Befehl. Drei einfache Befehle zum Anfang:
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
                <td>whoami</td>
                <td className="txt">Zeigt, als welcher Benutzer du angemeldet bist („who am I“, wer bin ich).</td>
              </tr>
              <tr>
                <td>date</td>
                <td className="txt">Zeigt Datum und Uhrzeit des Servers. Viele Server laufen in UTC, der Weltzeit.</td>
              </tr>
              <tr>
                <td>echo Hallo</td>
                <td className="txt">Gibt den Text dahinter einfach wieder aus. Klingt banal, ist in Skripten ständig im Einsatz.</td>
              </tr>
            </tbody>
          </table>
        </div>
        <p>
          Linux unterscheidet konsequent zwischen Groß- und Kleinschreibung. <code>whoami</code>{" "}
          funktioniert, <code>WhoAmI</code> nicht: Einen Befehl mit diesem Namen gibt es nicht.
          Befehle schreibst du fast immer klein.
        </p>

        <Aufgabe nr="1.1">
          <p>
            Finde heraus, als welcher Benutzer du angemeldet bist, und lass dir Datum und Uhrzeit
            des Servers anzeigen.
          </p>
          <Terminal aufgabe="l1-erster-befehl" titel="Übung 1.1" />
          <Loesung code={"whoami\ndate"}>
            <p>{EIN_MOEGLICHER_WEG} Die Uhrzeit ist die des Servers in UTC, deshalb weicht sie von deiner Uhr ab.</p>
          </Loesung>
        </Aufgabe>
      </LsAbschnitt>

      <LsAbschnitt id="aufbau" titel="Befehl, Option, Argument">
        <p>
          Die meisten Befehle folgen demselben Aufbau. Hier am Beispiel <code>ls -l /etc</code>:
        </p>
        <div className="ls-table-wrap">
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Teil</th>
                <th scope="col">Beispiel</th>
                <th scope="col">Bedeutung</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>Befehl</td>
                <td>ls</td>
                <td className="txt">Was passieren soll. ls listet den Inhalt eines Ordners auf (list).</td>
              </tr>
              <tr>
                <td>Option</td>
                <td>-l</td>
                <td className="txt">Wie es passieren soll. -l zeigt die lange Form mit Details.</td>
              </tr>
              <tr>
                <td>Argument</td>
                <td>/etc</td>
                <td className="txt">Womit oder wo. Hier der Ordner /etc statt des Ordners, in dem du gerade bist.</td>
              </tr>
            </tbody>
          </table>
        </div>
        <p>Dazu ein paar Regeln, die für fast alle Befehle gelten:</p>
        <ul>
          <li>
            <strong>Leerzeichen trennen die Teile.</strong> <code>ls -l</code> ist ls mit einer
            Option, <code>ls-l</code> wäre ein Befehl namens „ls-l“, den es nicht gibt.
          </li>
          <li>
            <strong>Kurze Optionen</strong> bestehen aus einem Minus und einem Buchstaben:{" "}
            <code>-l</code>, <code>-a</code>. Mehrere lassen sich zusammenfassen:{" "}
            <code>ls -l -a</code> ist dasselbe wie <code>ls -la</code>.
          </li>
          <li>
            <strong>Lange Optionen</strong> haben zwei Minus und ein ganzes Wort. Sie sind leichter
            zu lesen, zum Beispiel <code>ls --all</code> statt <code>ls -a</code>.
          </li>
          <li>
            <strong>Optionen und Argumente sind meist freiwillig.</strong> <code>ls</code> ohne
            alles zeigt den aktuellen Ordner in der kurzen Form.
          </li>
          <li>
            <strong>Leerzeichen im Namen</strong> brauchen Anführungszeichen:{" "}
            <code>{'ls "mein ordner"'}</code>. Sonst hält die Shell „mein“ und „ordner“ für zwei
            Argumente.
          </li>
        </ul>
        <p>Zwei Optionen von <code>ls</code> brauchst du gleich in den Übungen:</p>
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
                <td>ls -l</td>
                <td className="txt">Die lange Form: jede Datei in einer eigenen Zeile, mit Rechten, Besitzer, Größe und Datum.</td>
              </tr>
              <tr>
                <td>ls -a</td>
                <td className="txt">
                  Alle Dateien (all), auch die versteckten. Unter Linux ist eine Datei versteckt, wenn ihr
                  Name mit einem Punkt beginnt, zum Beispiel <code>.bashrc</code>. Ohne <code>-a</code>{" "}
                  zeigt ls sie nicht an.
                </td>
              </tr>
              <tr>
                <td>ls -la</td>
                <td className="txt">Beides zusammen: alle Dateien in der langen Form.</td>
              </tr>
            </tbody>
          </table>
        </div>
        <p>
          So sieht <code>ls -l</code> in deinem Home-Ordner aus. Was die Spalten bedeuten, lernst du
          in Lektion 5; für den Anfang reicht: ganz rechts steht der Name, links davon Datum und
          Größe in Byte. Datum und Uhrzeit sehen bei dir anders aus, weil die Dateien im
          Übungs-Terminal immer ein paar Tage alt sind.
        </p>
        <CodeBlock
          code={`azubi@lernarena:~$ ls -l
total 20
-rw-r--r-- 1 azubi azubi   20 Sep 28 09:30 bericht.txt
drwxr-xr-x 2 azubi azubi 4096 Sep  2 09:30 bilder
-rw-r--r-- 1 azubi azubi   40 Sep 14 09:30 notizen.txt
drwxr-xr-x 3 azubi azubi 4096 Sep 18 09:30 projekte
-rw-r--r-- 1 azubi azubi   28 Sep 22 09:30 todo.txt`}
        />

        <Aufgabe nr="1.2">
          <p>
            In deinem Home-Ordner liegen versteckte Dateien. Tippe zuerst nur <code>ls</code> und
            danach <code>ls -a</code>: Welche Namen kommen dazu? Zeige zum Schluss alle Dateien in
            der langen Form, indem du <code>-l</code> und <code>-a</code> kombinierst.
          </p>
          <Terminal aufgabe="l1-option" titel="Übung 1.2" />
          <Loesung code={"ls -a\nls -la"}>
            <p>
              {EIN_MOEGLICHER_WEG} Statt <code>ls -la</code> geht auch <code>ls -l -a</code> oder{" "}
              <code>ls -l --all</code>. In der Liste tauchen außerdem <code>.</code> und{" "}
              <code>..</code> auf: der aktuelle und der übergeordnete Ordner. Mehr dazu in Lektion 2.
            </p>
          </Loesung>
        </Aufgabe>

        <Aufgabe nr="1.3">
          <p>
            In <code>/etc</code> liegen unter Linux die Einstellungen des Systems. Liste den Inhalt
            dieses Ordners auf, ohne dorthin zu wechseln. Zeige danach nur die Datei{" "}
            <code>/etc/hostname</code> in der langen Form.
          </p>
          <Terminal aufgabe="l1-argument" titel="Übung 1.3" />
          <Loesung code={"ls /etc\nls -l /etc/hostname"}>
            <p>
              {EIN_MOEGLICHER_WEG} Das Argument kann ein Ordner oder eine einzelne Datei sein. In{" "}
              <code>hostname</code> steht übrigens der Name des Rechners, der auch im Prompt
              auftaucht.
            </p>
          </Loesung>
        </Aufgabe>
      </LsAbschnitt>

      <LsAbschnitt id="hilfe" titel="Hilfe holen, ohne das Terminal zu verlassen">
        <p>
          Niemand kennt alle Optionen auswendig. Deshalb bringt Linux seine Anleitungen gleich mit:
        </p>
        <div className="ls-table-wrap">
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Eingabe</th>
                <th scope="col">Was du bekommst</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>man ls</td>
                <td className="txt">
                  Die Anleitung zu ls (manual). Auf einem echten Linux ausführlich und auf Englisch,
                  du blätterst mit der Leertaste und beendest mit q. Im Übungs-Terminal bekommst du
                  eine deutsche Kurzfassung.
                </td>
              </tr>
              <tr>
                <td>ls --help</td>
                <td className="txt">Eine kurze Übersicht der Optionen direkt im Terminal.</td>
              </tr>
              <tr>
                <td>help</td>
                <td className="txt">
                  Im Übungs-Terminal: alle Befehle, die es kennt. In der echten Bash listet help die
                  Befehle, die in die Shell eingebaut sind.
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <p>Dazu kommen ein paar Tasten, die dir viel Tipparbeit sparen:</p>
        <div className="ls-table-wrap">
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Taste</th>
                <th scope="col">Wirkung</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>Pfeil hoch / runter</td>
                <td className="txt">Holt frühere Befehle zurück, zum Wiederholen oder Ändern.</td>
              </tr>
              <tr>
                <td>Tab</td>
                <td className="txt">
                  Ergänzt Befehle und Namen. Gibt es mehrere Treffer, zeigt das Übungs-Terminal sie
                  an; auf einem echten Linux drückst du dafür zweimal Tab.
                </td>
              </tr>
              <tr>
                <td>Strg+C</td>
                <td className="txt">Bricht die aktuelle Eingabe ab, auf einem echten Linux auch einen laufenden Befehl.</td>
              </tr>
              <tr>
                <td>Strg+L</td>
                <td className="txt">Leert den Bildschirm, wie der Befehl clear.</td>
              </tr>
            </tbody>
          </table>
        </div>
        <p>
          Der Befehl <code>history</code> zeigt dir außerdem alle Befehle, die du bisher getippt
          hast, jeweils mit einer Nummer davor.
        </p>
        <LsHinweis titel="Tab ist die wichtigste Taste">
          <p>
            Wer viel im Terminal arbeitet, tippt selten ganze Namen: ein paar Buchstaben, Tab,
            fertig. Das spart Zeit und verhindert Tippfehler. Auf dem Handy findest du Tab in der
            Leiste unter dem Terminal, zusammen mit Zeichen wie <code>|</code> und <code>~</code>,
            die auf der Bildschirmtastatur schwer zu finden sind.
          </p>
        </LsHinweis>

        <Aufgabe nr="1.4" label="Zum Knobeln 1.4">
          <p>
            Diese Aufgabe ist freiwillig. Hier steht nicht, wie es geht, du findest es selbst heraus,
            genau wie später im Beruf. Rufe die Anleitung zu <code>ls</code> auf und suche darin die
            Option, mit der das Neueste oben steht. Liste deinen Home-Ordner damit auf. Lass dir zum
            Schluss alle Befehle anzeigen, die du in diesem Terminal getippt hast.
          </p>
          <Terminal aufgabe="l1-hilfe" titel="Knobelaufgabe 1.4" />
          <Loesung code={"man ls\nls -lt\nhistory"}>
            <p>
              {EIN_MOEGLICHER_WEG} Mit <code>ls -lt</code> siehst du zusätzlich die Zeiten und
              erkennst, dass <code>bericht.txt</code> die neueste Datei ist.
            </p>
          </Loesung>
        </Aufgabe>
      </LsAbschnitt>

      <LsAbschnitt id="fehler" titel="Fehlermeldungen lesen">
        <p>
          Fehler gehören dazu, auch bei Profis. Wichtig ist, die Meldung zu lesen, statt einfach
          noch einmal dasselbe zu tippen. Auf Linux-Servern sind die Meldungen meist englisch. Vier
          davon siehst du ständig:
        </p>
        <div className="ls-table-wrap">
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Meldung</th>
                <th scope="col">Bedeutung</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>command not found</td>
                <td className="txt">Den Befehl gibt es nicht. Meist ein Tippfehler oder falsche Großschreibung.</td>
              </tr>
              <tr>
                <td>No such file or directory</td>
                <td className="txt">Datei oder Ordner gibt es an dieser Stelle nicht. Name und Pfad prüfen.</td>
              </tr>
              <tr>
                <td>Permission denied</td>
                <td className="txt">Dir fehlt das Recht dafür. Um Rechte geht es in Lektion 5.</td>
              </tr>
              <tr>
                <td>invalid option</td>
                <td className="txt">Diese Option kennt der Befehl nicht. Ein Blick in die Anleitung hilft.</td>
              </tr>
            </tbody>
          </table>
        </div>
        <p>
          Im Übungs-Terminal steht unter jeder Fehlermeldung zusätzlich ein Hinweis auf Deutsch.
          Auf einem echten Server gibt es den nicht, deshalb lohnt es sich, die englischen
          Meldungen von Anfang an mitzulesen. Probier es aus: Tippe im freien Terminal oben{" "}
          <code>lss</code> oder <code>ls gibtsnicht</code>.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="windows" titel="Unter Windows">
        <LsHinweis titel="Dasselbe in PowerShell und cmd" icon="buch" label="Unter Windows">
          <p>
            Windows hat zwei Kommandozeilen: die ältere Eingabeaufforderung (<code>cmd</code>) und
            die <strong>PowerShell</strong>. Der Prompt der PowerShell zeigt Laufwerk und Ordner,
            etwa <code>PS C:\Users\azubi&gt;</code>. <code>whoami</code> gibt es dort auch, die
            Ausgabe hat den Rechnernamen davor, zum Beispiel <code>pc01\azubi</code>. Datum und
            Uhrzeit zeigt <code>Get-Date</code>.
          </p>
          <p>
            PowerShell-Befehle bestehen aus Verb und Substantiv: <code>Get-ChildItem</code> zeigt
            den Inhalt eines Ordners. Dafür gibt es Kurznamen, die Linux-Nutzern vertraut sind:{" "}
            <code>ls</code> und <code>dir</code> rufen genau diesen Befehl auf. Optionen heißen dort
            Parameter und werden ausgeschrieben: <code>Get-ChildItem -Force</code> zeigt auch
            versteckte Dateien. Hilfe gibt es mit <code>Get-Help Get-ChildItem</code>. In der{" "}
            <code>cmd</code> sehen Optionen anders aus, mit Schrägstrich: <code>dir /a</code>{" "}
            zeigt versteckte Dateien.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="quiz" titel="Jetzt selbst testen">
        <p style={{ marginBottom: 18 }}>Vier Fragen zum Abschluss. Du hast so viele Versuche, wie du willst.</p>
        <QuizFrage
          nr={1}
          von={4}
          frage="Der Prompt lautet root@web01:/var/log#. Was stimmt?"
          optionen={[
            { text: "Du bist Benutzer web01 im Ordner root", richtig: false },
            { text: "Du bist root auf web01 im Ordner /var/log", richtig: true },
            { text: "Das # meldet einen Fehler im letzten Befehl", richtig: false },
            { text: "Du bist im Home-Ordner des Benutzers root", richtig: false },
          ]}
          erklaerung="Vor dem @ steht der Benutzer (root), dahinter der Rechner (web01), nach dem Doppelpunkt der aktuelle Ordner (/var/log). Das # am Ende zeigt ebenfalls: Hier arbeitet root, der Administrator. Also Vorsicht bei jedem Befehl."
        />
        <QuizFrage
          nr={2}
          von={4}
          frage="Was ist in ls -l /etc das Argument?"
          optionen={[
            { text: "ls", richtig: false },
            { text: "-l", richtig: false },
            { text: "/etc", richtig: true },
            { text: "Es gibt keins", richtig: false },
          ]}
          erklaerung="ls ist der Befehl, -l die Option (lange Form), /etc das Argument: der Ordner, dessen Inhalt gezeigt werden soll."
        />
        <QuizFrage
          nr={3}
          von={4}
          frage="Welche Eingabe macht dasselbe wie ls -l -a?"
          optionen={[
            { text: "ls -la", richtig: true },
            { text: "ls -l-a", richtig: false },
            { text: "ls la", richtig: false },
            { text: "LS -la", richtig: false },
          ]}
          erklaerung="Kurze Optionen lassen sich hinter einem Minus zusammenfassen. ls la würde eine Datei namens la suchen, ls -l-a kennt keine Option „-“, und LS gibt es wegen der Großschreibung nicht."
        />
        <QuizFrage
          nr={4}
          von={4}
          frage="Das Terminal meldet: bash: Ls: command not found. Woran liegt das?"
          optionen={[
            { text: "ls ist auf diesem Server nicht installiert", richtig: false },
            { text: "Es fehlt ein Argument hinter dem Befehl", richtig: false },
            { text: "Dafür braucht man Administratorrechte", richtig: false },
            { text: "Linux unterscheidet Groß- und Kleinschreibung", richtig: true },
          ]}
          erklaerung="Der Befehl heißt ls, klein geschrieben. Ls ist für Linux ein anderes Wort, und ein Programm mit diesem Namen gibt es nicht. Deshalb command not found."
        />
      </LsAbschnitt>
    </LektionLayout>
  );
}
