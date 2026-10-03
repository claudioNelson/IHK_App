import type { Metadata } from "next";
import { LsAbschnitt, LsHinweis } from "../../lernen/_components/LsBausteine";
import QuizFrage from "../../lernen/_components/QuizFrage";
import LektionLayout from "../../components/kurs/LektionLayout";
import { Aufgabe, CodeBlock, Loesung } from "../../components/kurs/KursBausteine";
import Terminal from "../_components/Terminal";
import { terminalKurs } from "../_components/lektionen";

export const metadata: Metadata = {
  title: "Terminal-Kurs Lektion 3: Dateien und Ordner",
  description:
    "Dateien und Ordner im Linux-Terminal anlegen, kopieren, verschieben, umbenennen und löschen: mkdir, touch, cp, mv, rm und rmdir, dazu der Platzhalter *. Mit Übungs-Terminal im Browser.",
  alternates: { canonical: "https://lernarena.app/terminal-kurs/lektion-3" },
};

const EIN_MOEGLICHER_WEG = "Ein möglicher Weg. Andere Wege sind genauso richtig, geprüft wird nur das Ergebnis.";

export default function Lektion3() {
  return (
    <LektionLayout
      kurs={terminalKurs}
      nr={3}
      lead="Ordner und Dateien anlegen, kopieren, verschieben, umbenennen und löschen. Dazu der Platzhalter *, mit dem ein Befehl viele Dateien auf einmal erfasst, und die wichtigste Vorsicht beim Löschen."
      uebungen={8}
      aufgabenText="3 Übungen und 1 Knobelaufgabe im Terminal, 4 Quizfragen"
    >
      <LsAbschnitt id="anlegen" titel="Ordner und Dateien anlegen">
        <p>Zwei Befehle legen Neues an:</p>
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
                <td>mkdir rechnungen</td>
                <td className="txt">Legt den Ordner <code>rechnungen</code> an (make directory).</td>
              </tr>
              <tr>
                <td>mkdir -p a/b/c</td>
                <td className="txt">
                  Legt mehrere Ebenen auf einmal an (parents). Ohne <code>-p</code> meldet mkdir einen
                  Fehler, wenn <code>a</code> oder <code>a/b</code> noch fehlen.
                </td>
              </tr>
              <tr>
                <td>touch liste.txt</td>
                <td className="txt">
                  Legt eine leere Datei an. Gibt es sie schon, bekommt sie nur eine neue Änderungszeit.
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <p>
          Beide Befehle nehmen auch Pfade: <code>touch rechnungen/liste.txt</code> legt die Datei im
          Ordner <code>rechnungen</code> an, ohne dass du hineinwechseln musst. Und beide nehmen
          mehrere Namen auf einmal, zum Beispiel <code>mkdir bilder musik</code>.
        </p>
        <LsHinweis titel="Keine Leerzeichen in Namen">
          <p>
            Unter Linux sind Leerzeichen in Namen erlaubt, aber lästig: Jedes Mal brauchst du
            Anführungszeichen. Administratoren schreiben deshalb <code>wochen-bericht.txt</code>{" "}
            oder <code>wochen_bericht.txt</code>. Groß- und Kleinschreibung zählt auch hier:{" "}
            <code>Liste.txt</code> und <code>liste.txt</code> sind zwei verschiedene Dateien.
          </p>
        </LsHinweis>
        <p>Im freien Terminal kannst du alles gefahrlos ausprobieren:</p>
        <Terminal aufgabe="l3-frei" titel="Freies Übungs-Terminal" hoehe={260} />

        <Aufgabe nr="3.1">
          <p>
            Lege im Home-Ordner den Ordner <code>rechnungen</code> an und darin mit{" "}
            <code>touch</code> die leere Datei <code>liste.txt</code>. Lege danach mit einem einzigen{" "}
            <code>mkdir</code> die drei Ebenen <code>archiv/2026/oktober</code> an.
          </p>
          <Terminal aufgabe="l3-anlegen" titel="Übung 3.1" />
          <Loesung code={"mkdir rechnungen\ntouch rechnungen/liste.txt\nmkdir -p archiv/2026/oktober"}>
            <p>
              {EIN_MOEGLICHER_WEG} Mit <code>tree archiv</code> siehst du, dass alle drei Ebenen
              entstanden sind.
            </p>
          </Loesung>
        </Aufgabe>
      </LsAbschnitt>

      <LsAbschnitt id="kopieren" titel="Kopieren, verschieben, umbenennen">
        <p>
          Kopieren und Verschieben funktionieren gleich: erst die <strong>Quelle</strong>, dann das{" "}
          <strong>Ziel</strong>.
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
                <td>cp notizen.txt backup/</td>
                <td className="txt">Kopiert die Datei in den Ordner <code>backup</code> (copy). Das Original bleibt.</td>
              </tr>
              <tr>
                <td>cp notizen.txt kopie.txt</td>
                <td className="txt">Legt eine Kopie unter neuem Namen im selben Ordner an.</td>
              </tr>
              <tr>
                <td>cp -r projekte sicherung</td>
                <td className="txt">Kopiert einen ganzen Ordner mit allem, was darin liegt (rekursiv).</td>
              </tr>
              <tr>
                <td>mv bericht.txt projekte/</td>
                <td className="txt">Verschiebt die Datei in den Ordner <code>projekte</code> (move). Am alten Platz ist sie weg.</td>
              </tr>
              <tr>
                <td>mv todo.txt aufgaben.txt</td>
                <td className="txt">Benennt die Datei um. Für einzelne Dateien nimmt man unter Linux immer mv.</td>
              </tr>
            </tbody>
          </table>
        </div>
        <p>
          Ob <code>mv</code> verschiebt oder umbenennt, entscheidet das Ziel: Ist es ein vorhandener
          Ordner, landet die Datei darin. Sonst bekommt sie den neuen Namen. Ein <code>/</code> am
          Ende des Ziels macht klar, dass du einen Ordner meinst. Gibt es den Ordner nicht, bekommst
          du dann eine Fehlermeldung statt einer umbenannten Datei.
        </p>
        <LsHinweis titel="Vorsicht: Linux fragt nicht nach" art="warnung">
          <p>
            Gibt es am Ziel schon eine Datei mit demselben Namen, überschreiben <code>cp</code> und{" "}
            <code>mv</code> sie ohne Rückfrage. Auf echten Servern hilft die Option <code>-i</code>{" "}
            (interactive): Dann fragt der Befehl vorher nach. Das Übungs-Terminal kennt diese
            Option nicht, weil es keine Rückfragen stellen kann.
          </p>
        </LsHinweis>

        <Aufgabe nr="3.2">
          <p>
            Kopiere <code>notizen.txt</code> in den Ordner <code>backup</code>. Benenne{" "}
            <code>todo.txt</code> in <code>aufgaben.txt</code> um. Verschiebe{" "}
            <code>bericht-entwurf.txt</code> in den Ordner <code>projekte</code>.
          </p>
          <Terminal aufgabe="l3-kopieren" titel="Übung 3.2" />
          <Loesung code={"cp notizen.txt backup/\nmv todo.txt aufgaben.txt\nmv bericht-entwurf.txt projekte/"}>
            <p>
              {EIN_MOEGLICHER_WEG} Nach dem Kopieren gibt es <code>notizen.txt</code> zweimal, nach
              dem Verschieben gibt es <code>bericht-entwurf.txt</code> nur noch in{" "}
              <code>projekte</code>. Prüfe es mit <code>ls</code> und <code>ls backup projekte</code>.
            </p>
          </Loesung>
        </Aufgabe>
      </LsAbschnitt>

      <LsAbschnitt id="loeschen" titel="Löschen und der Platzhalter *">
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
                <td>rm datei.txt</td>
                <td className="txt">Löscht eine Datei (remove).</td>
              </tr>
              <tr>
                <td>rmdir alt</td>
                <td className="txt">Löscht einen Ordner, aber nur, wenn er leer ist (remove directory).</td>
              </tr>
              <tr>
                <td>rm -r ordner</td>
                <td className="txt">Löscht einen Ordner mit allem, was darin liegt.</td>
              </tr>
              <tr>
                <td>rm -f datei.txt</td>
                <td className="txt">Löscht ohne Fehlermeldung, auch wenn die Datei gar nicht existiert (force).</td>
              </tr>
            </tbody>
          </table>
        </div>
        <LsHinweis titel="Im Terminal gibt es keinen Papierkorb" art="warnung">
          <p>
            Was <code>rm</code> löscht, ist weg. Es gibt kein Rückgängig. Schau dir deshalb vorher mit{" "}
            <code>ls</code> an, was du löschen willst, besonders bei <code>rm -r</code>. Den
            berüchtigten Befehl <code>rm -rf /</code> verweigert ein modernes Linux zwar, aber{" "}
            <code>rm -rf ~</code> oder ein Tippfehler im Pfad sind nicht geschützt. Im
            Übungs-Terminal hilft im Notfall „Zurücksetzen“, auf einem echten Server nur eine
            Sicherung.
          </p>
        </LsHinweis>
        <p>
          Oft willst du viele Dateien auf einmal erfassen. Dafür gibt es <strong>Platzhalter</strong>{" "}
          (englisch wildcards). Die Shell ersetzt sie durch alle passenden Namen, bevor der Befehl
          startet:
        </p>
        <div className="ls-table-wrap">
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Muster</th>
                <th scope="col">Passt auf</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>*.tmp</td>
                <td className="txt">Alle Namen, die auf <code>.tmp</code> enden. Der Stern steht für beliebig viele Zeichen, auch keins.</td>
              </tr>
              <tr>
                <td>foto*</td>
                <td className="txt">Alle Namen, die mit <code>foto</code> beginnen.</td>
              </tr>
              <tr>
                <td>foto?.jpg</td>
                <td className="txt">Das Fragezeichen steht für genau ein Zeichen: <code>foto1.jpg</code>, aber nicht <code>foto10.jpg</code>.</td>
              </tr>
            </tbody>
          </table>
        </div>
        <p>
          Zwei Besonderheiten: Der Stern erfasst keine versteckten Dateien, die mit einem Punkt
          beginnen. Und passt kein einziger Name, gibt die Shell das Muster unverändert weiter.
          Dann meldet der Befehl zum Beispiel <code>No such file or directory</code> für{" "}
          <code>*.tmp</code>. Ein guter Brauch vor jedem Löschen mit Platzhalter: erst{" "}
          <code>ls</code> mit demselben Muster. Was dabei erscheint, würde auch <code>rm</code>{" "}
          löschen.
        </p>
        <CodeBlock
          code={`azubi@lernarena:~$ ls downloads/*.tmp
downloads/cache.tmp  downloads/setup.tmp
azubi@lernarena:~$ rm downloads/*.tmp`}
        />

        <Aufgabe nr="3.3">
          <p>
            Lösche mit einem Befehl alle Dateien mit der Endung <code>.tmp</code> im Ordner{" "}
            <code>downloads</code>, die anderen Dateien dort bleiben. Lösche den leeren Ordner{" "}
            <code>alt</code> mit <code>rmdir</code> und den Ordner <code>papierkorb</code> samt
            Inhalt mit <code>rm -r</code>.
          </p>
          <Terminal aufgabe="l3-loeschen" titel="Übung 3.3" />
          <Loesung code={"ls downloads/*.tmp\nrm downloads/*.tmp\nrmdir alt\nrm -r papierkorb"}>
            <p>
              {EIN_MOEGLICHER_WEG} Hättest du <code>rmdir papierkorb</code> probiert, hätte Linux{" "}
              <code>Directory not empty</code> gemeldet (Ordner nicht leer), weil noch Dateien darin
              liegen. Zu viel gelöscht? „Zurücksetzen“ stellt alles wieder her.
            </p>
          </Loesung>
        </Aufgabe>

        <Aufgabe nr="3.4" label="Zum Knobeln 3.4">
          <p>
            Diese Aufgabe ist freiwillig, hier steht nicht genau, wie es geht. Sichere den
            kompletten Ordner <code>projekte/webshop</code> als <code>webshop-backup</code> in deinem
            Home-Ordner. Räume danach auf: Beide Fotos aus <code>downloads</code> sollen mit einem
            einzigen <code>mv</code> in einen neuen Ordner <code>bilder</code> wandern.
          </p>
          <Terminal aufgabe="l3-knobel" titel="Knobelaufgabe 3.4" />
          <Loesung code={"cp -r projekte/webshop webshop-backup\nmkdir bilder\nmv downloads/*.jpg bilder/"}>
            <p>
              {EIN_MOEGLICHER_WEG} Ohne <code>-r</code> meldet <code>cp</code>{" "}
              <code>-r not specified; omitting directory</code> und kopiert nichts. Gibt es{" "}
              <code>webshop-backup</code> schon, landet die Kopie darin als Unterordner{" "}
              <code>webshop-backup/webshop</code>. Gibt es das Ziel noch nicht, bekommt die Kopie
              seinen Namen. Statt{" "}
              <code>*.jpg</code> kannst du beide Namen hintereinander schreiben:{" "}
              <code>mv downloads/foto1.jpg downloads/foto2.jpg bilder/</code>.
            </p>
          </Loesung>
        </Aufgabe>
      </LsAbschnitt>

      <LsAbschnitt id="windows" titel="Unter Windows">
        <LsHinweis titel="Dasselbe in PowerShell und cmd" icon="buch" label="Unter Windows">
          <p>
            In der PowerShell heißen die Befehle <code>New-Item</code>, <code>Copy-Item</code>,{" "}
            <code>Move-Item</code>, <code>Rename-Item</code> und <code>Remove-Item</code>. Die
            Linux-Namen <code>mkdir</code>, <code>cp</code>, <code>mv</code> und <code>rm</code>{" "}
            funktionieren dort als Kurznamen. Linux-Optionen wie <code>-rf</code> kennt die
            PowerShell aber nicht, dort heißen sie <code>-Recurse</code> und <code>-Force</code>,
            etwa <code>Remove-Item ordner -Recurse</code>. <code>mkdir</code> legt fehlende
            Zwischenordner von selbst an. <code>touch</code> gibt es nicht, eine leere Datei legt{" "}
            <code>New-Item liste.txt -ItemType File</code> an.
          </p>
          <p>
            In der cmd heißen die Befehle <code>md</code> (oder <code>mkdir</code>),{" "}
            <code>copy</code>, <code>move</code>, <code>ren</code> und <code>del</code>. Einen Ordner
            mit Inhalt löscht <code>rd /s ordner</code>, ganze Ordner kopiert{" "}
            <code>robocopy</code>. Der Platzhalter <code>*</code> funktioniert in beiden. Anders als
            unter Linux werten unter Windows die Befehle ihn selbst aus, nicht die Shell.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="quiz" titel="Jetzt selbst testen">
        <p style={{ marginBottom: 18 }}>Vier Fragen zum Abschluss. Du hast so viele Versuche, wie du willst.</p>
        <QuizFrage
          nr={1}
          von={4}
          frage="Wie benennst du unter Linux die Datei alt.txt in neu.txt um?"
          optionen={[
            { text: "rename alt.txt neu.txt", richtig: false },
            { text: "cp alt.txt neu.txt", richtig: false },
            { text: "mv alt.txt neu.txt", richtig: true },
            { text: "ren alt.txt neu.txt", richtig: false },
          ]}
          erklaerung="Umbenennen ist Verschieben an einen neuen Namen, deshalb mv. cp würde eine Kopie anlegen und alt.txt behalten. ren ist der Befehl der Windows-cmd. Ein Programm rename gibt es unter Linux zwar, es arbeitet aber mit Mustern für viele Dateien und versteht diesen Aufruf nicht."
        />
        <QuizFrage
          nr={2}
          von={4}
          frage="mkdir projekte/2026/neu meldet No such file or directory. Was hilft?"
          optionen={[
            { text: "mkdir -p projekte/2026/neu", richtig: true },
            { text: "touch projekte/2026/neu", richtig: false },
            { text: "sudo mkdir projekte/2026/neu", richtig: false },
            { text: "mkdir -r projekte/2026/neu", richtig: false },
          ]}
          erklaerung="Der Ordner 2026 (oder schon projekte) fehlt. Die Option -p legt alle fehlenden Ebenen mit an. sudo hilft nicht, denn es fehlt kein Recht, sondern ein Ordner."
        />
        <QuizFrage
          nr={3}
          von={4}
          frage="Welche Dateien löscht rm *.log?"
          optionen={[
            { text: "Nur eine Datei namens *.log", richtig: false },
            { text: "Alle Dateien im aktuellen Ordner, deren Name auf .log endet", richtig: true },
            { text: "Alle .log-Dateien auf dem ganzen Server", richtig: false },
            { text: "Alle .log-Dateien, aber vorher fragt rm nach", richtig: false },
          ]}
          erklaerung="Die Shell ersetzt *.log durch alle passenden Namen im aktuellen Ordner, Unterordner zählen nicht. rm fragt dabei nicht nach. Vorher mit ls *.log prüfen, was erfasst wird."
        />
        <QuizFrage
          nr={4}
          von={4}
          frage="rmdir alt meldet Directory not empty. Was bedeutet das?"
          optionen={[
            { text: "Dir fehlt das Recht zum Löschen", richtig: false },
            { text: "Den Ordner gibt es nicht", richtig: false },
            { text: "rmdir funktioniert nur mit sudo", richtig: false },
            { text: "Im Ordner liegt noch etwas, rmdir löscht nur leere Ordner", richtig: true },
          ]}
          erklaerung="rmdir ist absichtlich vorsichtig. Ordner mit Inhalt löscht rm -r, nachdem du mit ls nachgesehen hast, was darin liegt."
        />
      </LsAbschnitt>
    </LektionLayout>
  );
}
