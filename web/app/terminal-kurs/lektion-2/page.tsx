import type { Metadata } from "next";
import { LsAbschnitt, LsHinweis } from "../../lernen/_components/LsBausteine";
import QuizFrage from "../../lernen/_components/QuizFrage";
import LektionLayout from "../../components/kurs/LektionLayout";
import { Aufgabe, CodeBlock, Loesung } from "../../components/kurs/KursBausteine";
import Terminal from "../_components/Terminal";
import { terminalKurs } from "../_components/lektionen";

export const metadata: Metadata = {
  title: "Terminal-Kurs Lektion 2: Im Dateisystem bewegen",
  description:
    "Wie das Linux-Dateisystem aufgebaut ist, welche Ordner wichtig sind und wie du dich mit pwd, cd, ls und tree darin bewegst. Absolute und relative Pfade verständlich erklärt, mit Übungs-Terminal im Browser.",
  alternates: { canonical: "https://lernarena.app/terminal-kurs/lektion-2" },
};

/** Pfad, der am Handy nach jedem Schrägstrich umbrechen darf. */
const umbrechbar = (pfad: string) =>
  pfad.split("/").map((teil, i) => (
    <span key={i}>
      {i > 0 ? "/" : ""}
      {i > 0 && <wbr />}
      {teil}
    </span>
  ));

const EIN_MOEGLICHER_WEG = "Ein möglicher Weg. Andere Wege sind genauso richtig, geprüft wird nur das Ergebnis.";

export default function Lektion2() {
  return (
    <LektionLayout
      kurs={terminalKurs}
      nr={2}
      lead="Wie das Dateisystem unter Linux aufgebaut ist, welche Ordner du kennen solltest und wie du mit pwd, cd, ls und tree sicher von Ordner zu Ordner kommst. Dazu der Unterschied zwischen absoluten und relativen Pfaden."
      uebungen={8}
      aufgabenText="3 Übungen und 1 Knobelaufgabe im Terminal, 4 Quizfragen"
    >
      <LsAbschnitt id="baum" titel="Ein Baum mit einer Wurzel">
        <p>
          Unter Windows hat jedes Laufwerk einen eigenen Buchstaben: <code>C:</code>, <code>D:</code>{" "}
          und so weiter. Linux kennt keine Laufwerksbuchstaben. Es gibt genau einen großen Baum aus
          Ordnern, und der beginnt ganz oben bei <code>/</code>, der <strong>Wurzel</strong>{" "}
          (englisch root directory). Alles hängt darunter, auch eine zweite Festplatte oder ein
          USB-Stick: Sie werden in einen Ordner eingehängt, zum Beispiel unter <code>/media</code>{" "}
          oder <code>/mnt</code>.
        </p>
        <p>
          Der Weg durch diesen Baum heißt <strong>Pfad</strong>. Die Ordnernamen werden mit{" "}
          <code>/</code> getrennt: <code>/home/azubi/notizen.txt</code> ist die Datei{" "}
          <code>notizen.txt</code> im Ordner <code>azubi</code>, der im Ordner <code>home</code>{" "}
          liegt, der direkt unter der Wurzel liegt.
        </p>
        <p>
          Wo du gerade bist, verrät dir <code>pwd</code> (print working directory, zeige den
          Arbeitsordner). Diesen Ordner nennt man den <strong>aktuellen Ordner</strong>. Auch der
          Prompt zeigt ihn an, allerdings verkürzt: Statt <code>/home/azubi</code> steht dort nur{" "}
          <code>~</code>.
        </p>
        <CodeBlock
          code={`azubi@lernarena:~$ pwd
/home/azubi`}
        />
        <LsHinweis titel="Dreimal root">
          <p>
            Das Wort root begegnet dir unter Linux in drei Bedeutungen: <code>/</code> ist die
            Wurzel des Dateisystems, <code>root</code> ist der Administrator und{" "}
            <code>/root</code> ist der Home-Ordner des Administrators. Was gemeint ist, ergibt sich
            meist aus dem Zusammenhang.
          </p>
        </LsHinweis>
        <p>
          Im freien Terminal kannst du dich umsehen. <code>tree -L 1 /</code> zeigt dir die oberste
          Ebene des Baums, also alles, was direkt unter der Wurzel liegt.
        </p>
        <Terminal aufgabe="l2-frei" titel="Freies Übungs-Terminal" hoehe={280} />
      </LsAbschnitt>

      <LsAbschnitt id="ordner" titel="Die wichtigsten Ordner">
        <p>
          Welcher Ordner wofür da ist, ist auf fast allen Linux-Systemen gleich geregelt (im
          Filesystem Hierarchy Standard). Wer diese Ordner kennt, findet sich auf jedem fremden
          Server zurecht:
        </p>
        <div className="ls-table-wrap">
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Ordner</th>
                <th scope="col">Was dort liegt</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>/</td>
                <td className="txt">Die Wurzel. Hier beginnt jeder absolute Pfad.</td>
              </tr>
              <tr>
                <td>/home</td>
                <td className="txt">Die Home-Ordner der Benutzer, etwa <code>/home/azubi</code>. Hier liegen eigene Dateien.</td>
              </tr>
              <tr>
                <td>/root</td>
                <td className="txt">Der Home-Ordner des Administrators root. Normale Benutzer dürfen nicht hinein.</td>
              </tr>
              <tr>
                <td>/etc</td>
                <td className="txt">Einstellungen des Systems und der Dienste, fast alles als Textdateien.</td>
              </tr>
              <tr>
                <td>/var</td>
                <td className="txt">
                  Daten, die sich ständig ändern. Besonders wichtig: <code>/var/log</code> mit den
                  Protokolldateien (log, englisch für Protokoll). Unter Ubuntu liegen in{" "}
                  <code>/var/www</code> die Webseiten, sobald ein Webserver installiert ist.
                </td>
              </tr>
              <tr>
                <td>/tmp</td>
                <td className="txt">Ablage für temporäre Dateien. Jeder darf hier schreiben, beim Neustart wird oft aufgeräumt.</td>
              </tr>
              <tr>
                <td>/usr/bin</td>
                <td className="txt">Die meisten Programme, zum Beispiel <code>ls</code> und <code>cp</code>. Unter Ubuntu führt <code>/bin</code> an dieselbe Stelle.</td>
              </tr>
              <tr>
                <td>/dev</td>
                <td className="txt">Geräte wie Festplatten, dargestellt als Dateien. Dazu <code>/dev/null</code>, ein Abfluss, der alles schluckt, was man hineinschreibt.</td>
              </tr>
              <tr>
                <td>/opt</td>
                <td className="txt">Zusätzliche Software, die nicht über die Paketverwaltung kommt.</td>
              </tr>
            </tbody>
          </table>
        </div>
        <p>
          Auf einem echten Server gibt es noch ein paar Ordner mehr, etwa <code>/boot</code> für den
          Systemstart oder <code>/proc</code> mit Angaben zu laufenden Programmen. Die Tabelle
          enthält die, mit denen du im Alltag arbeitest.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="cd" titel="Mit cd den Ordner wechseln">
        <p>
          <code>cd</code> steht für change directory, wechsle den Ordner. Hinter <code>cd</code>{" "}
          schreibst du, wohin du willst:
        </p>
        <div className="ls-table-wrap">
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Eingabe</th>
                <th scope="col">Wohin es geht</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>cd projekte</td>
                <td className="txt">In den Unterordner <code>projekte</code> des aktuellen Ordners.</td>
              </tr>
              <tr>
                <td>cd ..</td>
                <td className="txt">Eine Ebene nach oben. Die zwei Punkte stehen immer für den übergeordneten Ordner.</td>
              </tr>
              <tr>
                <td>cd</td>
                <td className="txt">Ohne Ziel: zurück in deinen Home-Ordner, egal wo du gerade bist. <code>cd ~</code> macht dasselbe.</td>
              </tr>
              <tr>
                <td>cd -</td>
                <td className="txt">Zurück in den Ordner, in dem du vorher warst. Den Ordner zeigt cd dabei an. Praktisch, um zwischen zwei Ordnern hin und her zu springen.</td>
              </tr>
            </tbody>
          </table>
        </div>
        <p>
          Wenn alles klappt, antwortet <code>cd</code> meist gar nicht. Wie unter Linux üblich
          bedeutet keine Ausgabe: erledigt. Den Wechsel siehst du am Prompt, der jetzt den neuen Ordner zeigt:
        </p>
        <CodeBlock
          code={`azubi@lernarena:~$ cd projekte
azubi@lernarena:~/projekte$ pwd
/home/azubi/projekte
azubi@lernarena:~/projekte$ cd ..
azubi@lernarena:~$`}
        />

        <Aufgabe nr="2.1">
          <p>
            Prüfe mit <code>pwd</code>, wo du bist. Wechsle mit <code>cd</code> in den Ordner{" "}
            <code>projekte</code> und von dort in <code>webshop</code>. Geh mit <code>cd ..</code>{" "}
            eine Ebene nach oben und kehre zum Schluss mit <code>cd</code> ohne Ziel in deinen
            Home-Ordner zurück. Achte dabei auf den Prompt.
          </p>
          <Terminal aufgabe="l2-cd" titel="Übung 2.1" />
          <Loesung code={"pwd\ncd projekte\ncd webshop\ncd ..\ncd"}>
            <p>
              {EIN_MOEGLICHER_WEG} Statt zweimal <code>cd</code> geht auch <code>cd projekte/webshop</code>{" "}
              auf einmal. Der Prompt zeigt nacheinander <code>~</code>, <code>~/projekte</code>,{" "}
              <code>~/projekte/webshop</code>, wieder <code>~/projekte</code> und zum Schluss{" "}
              <code>~</code>.
            </p>
          </Loesung>
        </Aufgabe>
      </LsAbschnitt>

      <LsAbschnitt id="pfade" titel="Absolute und relative Pfade">
        <p>Einen Ordner kannst du auf zwei Arten angeben:</p>
        <ul>
          <li>
            <strong>Absoluter Pfad:</strong> Er beginnt mit <code>/</code> und beschreibt den
            ganzen Weg von der Wurzel aus, zum Beispiel <code>/var/log</code>. Er führt immer an
            dieselbe Stelle, egal wo du gerade bist. Wie eine vollständige Postanschrift.
          </li>
          <li>
            <strong>Relativer Pfad:</strong> Er beginnt nicht mit <code>/</code> und gilt ab dem
            aktuellen Ordner, zum Beispiel <code>projekte/webshop</code>. Wie die Beschreibung
            „zweite Tür links“: Sie stimmt nur, wenn du am richtigen Ort startest.
          </li>
        </ul>
        <p>
          In relativen Pfaden helfen zwei Kurzzeichen: <code>..</code> ist der übergeordnete Ordner,{" "}
          <code>.</code> der aktuelle Ordner selbst. Beide hast du in Lektion 1 schon in der Ausgabe
          von <code>ls -a</code> gesehen. Die Tilde <code>~</code> ersetzt die Shell durch deinen
          Home-Ordner, <code>~/downloads</code> ist also eigentlich der absolute Pfad{" "}
          <code>/home/azubi/downloads</code>.
        </p>
        <p>
          So wirken verschiedene Ziele hinter <code>cd</code>, wenn du gerade in{" "}
          <code>/home/azubi/projekte</code> bist. Die ersten drei Pfade sind relativ, die letzten
          zwei absolut:
        </p>
        <div className="ls-table-wrap">
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Eingabe</th>
                <th scope="col">Du landest in</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>cd webshop</td>
                <td className="tk-umbruch">{umbrechbar("/home/azubi/projekte/webshop")}</td>
              </tr>
              <tr>
                <td>cd ../downloads</td>
                <td className="tk-umbruch">{umbrechbar("/home/azubi/downloads")}</td>
              </tr>
              <tr>
                <td>cd ../..</td>
                <td className="tk-umbruch">{umbrechbar("/home")}</td>
              </tr>
              <tr>
                <td>cd /var/log</td>
                <td className="tk-umbruch">{umbrechbar("/var/log")}</td>
              </tr>
              <tr>
                <td>cd ~/downloads</td>
                <td className="tk-umbruch">{umbrechbar("/home/azubi/downloads")}</td>
              </tr>
            </tbody>
          </table>
        </div>
        <p>
          Bei <code>../downloads</code> geht es erst eine Ebene nach oben in den Home-Ordner und
          von dort hinein in <code>downloads</code>. Relative Pfade sind kürzer, absolute
          eindeutig. In Anleitungen und Skripten stehen deshalb meist absolute Pfade, beim Tippen
          nimmt man oft den kürzeren Weg.
        </p>
        <LsHinweis titel="Tab hilft auch bei Pfaden">
          <p>
            Tippe <code>cd /v</code> und drücke <kbd>Tab</kbd>: Daraus wird <code>cd /var/</code>.
            Dann <code>w</code> und noch einmal <kbd>Tab</kbd> für <code>/var/www/</code>. Passen
            mehrere Namen, tippst du einen Buchstaben mehr. So musst du keinen Ordnernamen ganz
            ausschreiben und vertippst dich nicht.
          </p>
        </LsHinweis>

        <Aufgabe nr="2.2">
          <p>
            Wechsle mit einem absoluten Pfad nach <code>/var/log</code> und lass dir mit{" "}
            <code>ls</code> anzeigen, was dort liegt. Wechsle danach mit einem relativen Pfad nach{" "}
            <code>/var/www/html</code>: Von <code>/var/log</code> aus führt <code>..</code> zuerst
            nach <code>/var</code>, von dort geht es weiter nach <code>www/html</code>.
          </p>
          <Terminal aufgabe="l2-pfade" titel="Übung 2.2" />
          <Loesung code={"cd /var/log\nls\ncd ../www/html"}>
            <p>
              Ein möglicher Weg. Geprüft wird hier auch, dass du einmal einen absoluten und einmal
              einen relativen Pfad benutzt. Mit <code>cd /var/www/html</code> wärst du zwar auch
              angekommen, aber das ist ein absoluter Pfad. In zwei Schritten geht es ebenfalls:{" "}
              <code>cd ..</code> und dann <code>cd www/html</code>.
            </p>
          </Loesung>
        </Aufgabe>
      </LsAbschnitt>

      <LsAbschnitt id="ueberblick" titel="Mehr sehen mit ls und tree">
        <p>
          Zwei weitere Optionen von <code>ls</code> und der Befehl <code>tree</code> verschaffen dir
          schnell einen Überblick:
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
                <td>ls -lh</td>
                <td className="txt">
                  Die lange Form mit lesbaren Größen (human-readable): <code>69K</code> statt einer
                  langen Zahl in Byte. K steht für Kilobyte, M für Megabyte, G für Gigabyte, eine
                  Zahl ohne Buchstaben sind Byte.
                </td>
              </tr>
              <tr>
                <td>ls -R</td>
                <td className="txt">Alle Unterordner nacheinander (rekursiv), jeweils mit dem Pfad als Überschrift.</td>
              </tr>
              <tr>
                <td>tree</td>
                <td className="txt">Ordner und Dateien als Baum, mit allen Unterordnern.</td>
              </tr>
              <tr>
                <td>tree -L 2</td>
                <td className="txt">Nur die ersten zwei Ebenen. Hilfreich bei großen Ordnern.</td>
              </tr>
              <tr>
                <td>tree -d</td>
                <td className="txt">Nur die Ordner, ohne Dateien.</td>
              </tr>
            </tbody>
          </table>
        </div>
        <p>
          Wie bei <code>cd</code> kannst du hinter <code>ls</code> und <code>tree</code> einen
          Ordner angeben, zum Beispiel <code>ls -lh /var/log</code> oder <code>tree projekte</code>.
          Ohne Ordner nehmen beide den aktuellen.
        </p>
        <LsHinweis titel="tree ist nicht überall installiert">
          <p>
            Auf vielen Servern fehlt <code>tree</code> und muss erst mit{" "}
            <code>sudo apt install tree</code> nachinstalliert werden. <code>ls -R</code> gibt es
            dagegen auf jedem Linux. Im Übungs-Terminal funktioniert beides.
          </p>
        </LsHinweis>

        <Aufgabe nr="2.3">
          <p>
            Zeige den Ordner <code>/var/log</code> in der langen Form mit lesbaren Größen an. Welche
            Datei ist die größte? Lass dir danach deinen Ordner <code>projekte</code> mit allen
            Unterordnern als Baum anzeigen.
          </p>
          <Terminal aufgabe="l2-ueberblick" titel="Übung 2.3" />
          <Loesung code={"ls -lh /var/log\ntree projekte"}>
            <p>
              {EIN_MOEGLICHER_WEG} Die größte Datei ist <code>syslog</code>, das allgemeine
              Protokoll des Systems. Statt <code>tree projekte</code> geht auch{" "}
              <code>ls -R projekte</code>.
            </p>
          </Loesung>
        </Aufgabe>

        <Aufgabe nr="2.4" label="Zum Knobeln 2.4">
          <p>
            Diese Aufgabe ist freiwillig, hier steht nicht genau, wie es geht. Irgendwo in deinem Ordner <code>projekte</code> liegt die
            Datei <code>serverliste.txt</code>. Finde heraus, in welchem Ordner sie liegt, ohne jeden
            Ordner einzeln zu öffnen. Wechsle dann mit einem einzigen <code>cd</code> direkt
            dorthin.
          </p>
          <Terminal aufgabe="l2-knobel" titel="Knobelaufgabe 2.4" />
          <Loesung code={"tree projekte\ncd projekte/intranet/doku/netzwerk"}>
            <p>
              {EIN_MOEGLICHER_WEG} Im Baum liest du den Weg von oben nach unten ab:{" "}
              <code>projekte</code>, <code>intranet</code>, <code>doku</code>,{" "}
              <code>netzwerk</code>. Mit <code>cd ~/projekte/intranet/doku/netzwerk</code> klappt es
              von jedem Ordner aus.
            </p>
          </Loesung>
        </Aufgabe>
      </LsAbschnitt>

      <LsAbschnitt id="windows" titel="Unter Windows">
        <LsHinweis titel="Dasselbe in PowerShell und cmd" icon="buch" label="Unter Windows">
          <p>
            Windows hat für jedes Laufwerk einen eigenen Baum, ein absoluter Pfad beginnt deshalb
            mit dem Laufwerksbuchstaben: <code>C:\Windows\System32</code>. Ordner werden mit dem
            umgekehrten Schrägstrich <code>\</code> getrennt, die PowerShell versteht aber auch{" "}
            <code>/</code>. Groß- und Kleinschreibung spielt bei Pfaden keine Rolle. Der Home-Ordner
            liegt unter <code>C:\Users\azubi</code>.
          </p>
          <p>
            <code>cd ordner</code> und <code>cd ..</code> funktionieren in PowerShell und cmd wie
            unter Linux. Den aktuellen Ordner zeigt in der PowerShell <code>Get-Location</code>{" "}
            (Kurzname <code>pwd</code>). Vorsicht bei <code>cd</code> ohne Ziel: In der cmd zeigt es
            den aktuellen Ordner an, in der PowerShell 7 führt es nach Hause und in der älteren
            Windows PowerShell passiert gar nichts. Alle Unterordner zeigen{" "}
            <code>Get-ChildItem -Recurse</code> oder in der cmd <code>dir /s</code>, und auch{" "}
            <code>tree</code> gibt es in der cmd, mit <code>tree /f</code> samt Dateien.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="quiz" titel="Jetzt selbst testen">
        <p style={{ marginBottom: 18 }}>Vier Fragen zum Abschluss. Du hast so viele Versuche, wie du willst.</p>
        <QuizFrage
          nr={1}
          von={4}
          frage="Welcher dieser Pfade ist absolut?"
          optionen={[
            { text: "etc/ssh", richtig: false },
            { text: "../ssh", richtig: false },
            { text: "/etc/ssh", richtig: true },
            { text: "ssh", richtig: false },
          ]}
          erklaerung="Ein absoluter Pfad beginnt mit / und führt von der Wurzel aus immer an dieselbe Stelle. Die anderen gelten ab dem aktuellen Ordner und führen je nach Standort woandershin."
        />
        <QuizFrage
          nr={2}
          von={4}
          frage="Du bist in /home/azubi/projekte und tippst cd ../.. Wo landest du?"
          optionen={[
            { text: "/home/azubi", richtig: false },
            { text: "/home", richtig: true },
            { text: "/", richtig: false },
            { text: "Es gibt eine Fehlermeldung", richtig: false },
          ]}
          erklaerung="Jedes .. ist eine Ebene nach oben: von /home/azubi/projekte nach /home/azubi und von dort nach /home."
        />
        <QuizFrage
          nr={3}
          von={4}
          frage="Was macht cd ohne Ziel unter Linux?"
          optionen={[
            { text: "Es wechselt in deinen Home-Ordner", richtig: true },
            { text: "Es zeigt den aktuellen Ordner an", richtig: false },
            { text: "Es wechselt zur Wurzel /", richtig: false },
            { text: "Es meldet einen Fehler, weil das Ziel fehlt", richtig: false },
          ]}
          erklaerung="Ohne Ziel bringt dich cd nach Hause, genau wie cd ~. Den aktuellen Ordner zeigt pwd. In der cmd unter Windows ist das anders: Dort zeigt cd ohne Ziel den aktuellen Ordner an."
        />
        <QuizFrage
          nr={4}
          von={4}
          frage="Ein Dienst startet nicht und du suchst seine Protokolldateien. Wo schaust du zuerst nach?"
          optionen={[
            { text: "/etc", richtig: false },
            { text: "/usr/bin", richtig: false },
            { text: "/tmp", richtig: false },
            { text: "/var/log", richtig: true },
          ]}
          erklaerung="Protokolle liegen unter /var/log. In /etc stehen die Einstellungen der Dienste, in /usr/bin die Programme selbst."
        />
      </LsAbschnitt>
    </LektionLayout>
  );
}
