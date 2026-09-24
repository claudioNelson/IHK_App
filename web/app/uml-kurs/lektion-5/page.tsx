import type { Metadata } from "next";
import { LsAbschnitt, LsHinweis } from "../../lernen/_components/LsBausteine";
import QuizFrage from "../../lernen/_components/QuizFrage";
import LektionLayout from "../../components/kurs/LektionLayout";
import { Zeichenaufgabe } from "../../components/kurs/KursBausteine";
import {
  L5BestellungLoesung,
  L5Elemente,
  L5Objektfluss,
  L5PasswortLoesung,
  L5TicketDiagramm,
  L5Vergleich,
} from "../_components/UmlDiagramme";
import { umlKurs } from "../_components/lektionen";

export const metadata: Metadata = {
  title: "UML Lektion 5: Aktivitätsdiagramm mit Verzweigung, Parallelität und Schwimmbahnen",
  description:
    "Aktivitätsdiagramme für die IHK-Prüfung: Start und Ende, Aktionen, Entscheidungen mit Bedingungen, Gabelung und Vereinigung, Schwimmbahnen und Objektfluss. Mit Abgrenzung zu Programmablaufplan und Struktogramm und zwei Zeichenaufgaben.",
  alternates: { canonical: "https://lernarena.app/uml-kurs/lektion-5" },
};

const vergleich: { merkmal: string; ad: string; pap: string; ns: string }[] = [
  {
    merkmal: "Norm",
    ad: "UML 2.5 (OMG)",
    pap: "DIN 66001",
    ns: "DIN 66261, auch Nassi-Shneiderman-Diagramm",
  },
  {
    merkmal: "Start und Ende",
    ad: "gefüllter Kreis, Kreis mit Punkt",
    pap: "Oval (Terminator) mit „Start“ und „Ende“",
    ns: "keine eigenen Symbole",
  },
  {
    merkmal: "Anweisung",
    ad: "Aktion, abgerundetes Rechteck",
    pap: "Rechteck; Ein- und Ausgabe als Parallelogramm",
    ns: "Rechteckiger Block",
  },
  {
    merkmal: "Verzweigung",
    ad: "leere Raute, Bedingungen [ … ] an den Kanten",
    pap: "Raute mit Frage, Ausgänge „ja“ und „nein“",
    ns: "Block mit Dreieck, Spalten „ja“ und „nein“",
  },
  {
    merkmal: "Schleife",
    ad: "Rückfluss in eine Zusammenführung",
    pap: "Rückpfeil vor die Entscheidung",
    ns: "eigener Schleifenblock, kopf- oder fußgesteuert",
  },
  {
    merkmal: "Parallelität",
    ad: "Gabelung und Vereinigung",
    pap: "in Prüfungen praktisch nie",
    ns: "in Prüfungen praktisch nie",
  },
  {
    merkmal: "Wer macht was",
    ad: "Schwimmbahnen",
    pap: "nicht vorgesehen",
    ns: "nicht vorgesehen",
  },
  {
    merkmal: "Typischer Einsatz",
    ad: "Geschäftsprozesse und Systemabläufe mit mehreren Beteiligten",
    pap: "Programmlogik, nah am Code",
    ns: "Programmlogik ohne Sprünge, strukturierte Programmierung",
  },
];

export default function Lektion5() {
  return (
    <LektionLayout
      kurs={umlKurs}
      nr={5}
      lead="Das Aktivitätsdiagramm zeigt einen Ablauf: welche Schritte in welcher Reihenfolge passieren, wo entschieden wird, was parallel läuft und wer zuständig ist. Du lernst alle Elemente, grenzt es sauber von Programmablaufplan und Struktogramm ab und zeichnest zwei Prüfungsaufgaben."
      uebungen={2}
      aufgabenText="2 Zeichenaufgaben, 5 Quizfragen"
    >
      <LsAbschnitt id="elemente" titel="Die Elemente">
        <p>
          Ein Aktivitätsdiagramm (activity diagram) beschreibt eine Aktivität, also einen Ablauf von
          Anfang bis Ende. Stell dir eine Spielfigur vor, die vom Startknoten aus den Pfeilen folgt:
          UML nennt sie Token. Wo sie gerade steht, passiert etwas. Mit diesem Bild lassen sich alle
          Elemente erklären.
        </p>
        <L5Elemente />
        <ul>
          <li>
            <strong>Startknoten</strong> (initial node): gefüllter Kreis. Hier beginnt der Ablauf.
          </li>
          <li>
            <strong>Aktion</strong> (action): abgerundetes Rechteck mit einem Verb, etwa „Ticket
            erfassen“. Eine Aktion ist ein Schritt, der nicht weiter zerlegt wird.
          </li>
          <li>
            <strong>Kontrollfluss</strong> (control flow): Pfeil mit offener Spitze von einem
            Knoten zum nächsten.
          </li>
          <li>
            <strong>Aktivitätsende</strong> (activity final node): Kreis mit gefülltem Punkt. Sobald
            ein Token hier ankommt, endet die gesamte Aktivität, auch alle parallelen Zweige. Das{" "}
            <strong>Ablaufende</strong> (flow final node, Kreis mit Kreuz) beendet dagegen nur den
            einen Zweig, der dort ankommt.
          </li>
        </ul>
        <h3>Entscheidung und Zusammenführung</h3>
        <p>
          Die leere Raute ist als Entscheidung (decision node) ein Weichensteller: Ein Pfeil geht
          hinein, mehrere gehen heraus, und an jedem ausgehenden Pfeil steht eine Bedingung
          (guard) in eckigen Klammern, etwa <code>[hoch]</code> und <code>[niedrig]</code>. Die
          Bedingungen müssen sich gegenseitig ausschließen und zusammen alle Fälle abdecken; für
          „alles andere“ gibt es <code>[else]</code>. Ein Fragetext neben der Raute, etwa „Rad
          frei?“, ist verbreitet und schadet nicht; entscheidend sind die Wächter in eckigen
          Klammern an jedem Ausgang.
        </p>
        <p>
          Dieselbe Raute mit mehreren Eingängen und einem Ausgang ist eine Zusammenführung (merge
          node). Sie führt die Zweige wieder zusammen, ohne zu warten: Jedes ankommende Token läuft
          sofort weiter. Auch jede Schleife braucht eine Zusammenführung, denn der Rückweg mündet
          nicht direkt in eine Aktion, sondern in eine Raute davor.
        </p>
        <h3>Gabelung und Vereinigung</h3>
        <p>
          Der schwarze Balken ist als Gabelung (fork node) der Startschuss für Parallelität: Ein
          Token kommt an, auf jedem ausgehenden Pfeil läuft eines weiter. Der Balken als Vereinigung
          (join node) wartet, bis <strong>alle</strong> parallelen Zweige angekommen sind, und lässt
          erst dann ein Token weiter. „Parallel“ heißt dabei nicht zwingend gleichzeitig, sondern:
          Die Reihenfolge ist egal.
        </p>
        <p>
          Zwei Symbole solltest du erkennen, aber nicht zeichnen müssen: das Zeitereignis
          (Sanduhr, etwa „nach 14 Tagen“) und der Signalempfang (Rechteck mit eingekerbter Seite,
          etwa „Zahlung eingegangen“). Beide lösen einen Kontrollfluss von außen aus.
        </p>
        <LsHinweis titel="Raute oder Balken?">
          <p>
            Nach einer Raute läuft <strong>genau einer</strong> der Wege, nach einem Balken laufen{" "}
            <strong>alle</strong>. Schließt du nach einer Entscheidung mit einem Balken, wartet die
            Vereinigung ewig auf einen Zweig, der nie kommt. Schließt du nach einer Gabelung mit
            einer Raute, läuft der Rest des Ablaufs doppelt. Darum gilt: Raute schließt Raute,
            Balken schließt Balken.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="bahnen" titel="Schwimmbahnen und Objektfluss">
        <h3>Schwimmbahnen</h3>
        <p>
          Sobald mehrere Beteiligte am Ablauf mitwirken, teilst du das Diagramm in Schwimmbahnen
          (swimlanes), in UML 2.5 offiziell Partitionen (activity partitions). Jede Bahn trägt oben
          den Namen einer Rolle, Abteilung oder eines Systems, und jede Aktion liegt in der Bahn
          dessen, der sie ausführt. Pfeile dürfen die Bahnen frei kreuzen; genau dort sieht man,
          wo eine Aufgabe übergeben wird.
        </p>
        <h3>Objektfluss</h3>
        <p>
          Manchmal ist wichtig, <strong>was</strong> zwischen zwei Aktionen weitergereicht wird. Dann
          setzt du einen Objektknoten (object node) dazwischen: ein eckiges Rechteck mit dem Namen des
          Objekts, optional mit seinem Zustand in eckigen Klammern. Die Pfeile davor und danach heißen
          Objektfluss (object flow). In Prüfungen kommt das selten vor, erkennen solltest du es aber.
        </p>
        <L5Objektfluss />
      </LsAbschnitt>

      <LsAbschnitt id="abgrenzung" titel="Abgrenzung zu PAP und Struktogramm">
        <p>
          Die IHK fragt Abläufe in drei Notationen ab: als UML-Aktivitätsdiagramm, als
          Programmablaufplan (PAP) und als Struktogramm. Alle drei zeigen Reihenfolge und
          Verzweigung, aber mit unterschiedlichen Symbolen. Hier dieselbe kleine Logik in allen drei
          Formen:
        </p>
        <L5Vergleich />
        <div className="ls-table-wrap">
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Merkmal</th>
                <th scope="col">Aktivitätsdiagramm</th>
                <th scope="col">PAP</th>
                <th scope="col">Struktogramm</th>
              </tr>
            </thead>
            <tbody>
              {vergleich.map((v) => (
                <tr key={v.merkmal}>
                  <td className="txt">
                    <strong>{v.merkmal}</strong>
                  </td>
                  <td className="txt">{v.ad}</td>
                  <td className="txt">{v.pap}</td>
                  <td className="txt">{v.ns}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        <LsHinweis titel="Prüfungsbezug" icon="buch" label="Prüfungsbezug">
          <p>
            Die Aufgabe nennt die Notation fast immer ausdrücklich: „Stellen Sie den Ablauf als
            UML-Aktivitätsdiagramm dar“, „als Struktogramm“ oder „als Programmablaufplan“. Lies
            genau, denn eine gemischte Notation kann Punkte kosten. Typische Mischfehler sind
            Ausgänge ohne Wächter in eckigen Klammern an einer UML-Raute (ein Fragetext neben der
            Raute ist dagegen unschädlich), ein Oval mit „Start“ im Aktivitätsdiagramm oder Pfeile
            im Struktogramm. Geht es um mehrere Beteiligte oder
            parallele Schritte, ist fast immer das Aktivitätsdiagramm gemeint; geht es um einen
            Algorithmus mit Schleifen und Variablen, eher Struktogramm, PAP oder Pseudocode.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="beispiel" titel="Beispiel Schritt für Schritt: Störungsticket">
        <p>
          So sieht eine typische Prüfungsaufgabe aus. Lies den Text einmal ganz, dann gehst du in
          drei Schritten vor.
        </p>
        <div className="uml-szenario">
          <span className="uml-szenario-titel">Ausgangssituation</span>
          <p>
            Der IT-Support eines Systemhauses bearbeitet Störungsmeldungen. Geht eine Meldung ein,{" "}
            <mark>erfasst</mark> der <mark>Support</mark> ein Ticket und <mark>prüft</mark> dessen{" "}
            <mark>Priorität</mark>. Tickets mit niedriger Priorität werden zunächst in die{" "}
            <mark>Warteschlange eingereiht</mark>, Tickets mit hoher Priorität gehen sofort in die
            Bearbeitung. Danach geschieht zweierlei, in beliebiger Reihenfolge: Der Support{" "}
            <mark>informiert den Kunden</mark> über den Stand, und die <mark>Technik</mark>{" "}
            <mark>behebt die Störung</mark> und <mark>dokumentiert die Lösung</mark>. Erst wenn beides
            erledigt ist, <mark>schließt</mark> der Support das Ticket.
          </p>
          <p>
            <strong>Aufgabe:</strong> Stellen Sie den Ablauf als UML-Aktivitätsdiagramm mit
            Schwimmbahnen dar.
          </p>
        </div>

        <h3>Schritt 1: Aktionen und Beteiligte sammeln</h3>
        <p>
          Die markierten Verben werden zu Aktionen, jeweils mit Objekt und Verb: Ticket erfassen,
          Priorität prüfen, In Warteschlange einreihen, Kunde informieren, Störung beheben, Lösung
          dokumentieren, Ticket schließen. Die markierten Beteiligten werden zu Schwimmbahnen:
          Support und Technik. Der Kunde handelt im Text selbst nicht, er bekommt keine eigene Bahn.
        </p>

        <h3>Schritt 2: Reihenfolge, Entscheidung und Parallelität</h3>
        <p>
          Jetzt ordnest du die Aktionen. „Tickets mit niedriger Priorität …, Tickets mit hoher
          Priorität …“ ist eine Entscheidung mit den Bedingungen <code>[niedrig]</code> und{" "}
          <code>[hoch]</code>; der Weg für hoch führt ohne eigene Aktion direkt zur
          Zusammenführung. „In beliebiger Reihenfolge“ und „erst wenn beides erledigt ist“ sind die
          Signalwörter für Gabelung und Vereinigung.
        </p>
        <L5TicketDiagramm stufe="ablauf" caption="Schritt 2: der Ablauf mit Entscheidung und Parallelität, noch ohne Schwimmbahnen" />

        <h3>Schritt 3: Schwimmbahnen einziehen</h3>
        <p>
          Zum Schluss legst du die Bahnen Support und Technik an und schiebst jede Aktion in die Bahn
          dessen, der sie ausführt. Gabelung und Vereinigung reichen über beide Bahnen, weil die
          parallelen Zweige bei verschiedenen Beteiligten liegen.
        </p>
        <L5TicketDiagramm caption="Schritt 3: das fertige Aktivitätsdiagramm mit Schwimmbahnen" />
        <LsHinweis titel="Die Probe mit dem Token">
          <p>
            Fahr mit dem Finger jeden möglichen Weg ab. Bei jeder Raute nimmst du genau einen
            Ausgang, bei jedem Gabelungsbalken alle. Kommst du immer am Ende an, und wartet keine
            Vereinigung auf einen Zweig, der nie kommt? Dann ist der Ablauf korrekt.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="uebungen" titel="Zeichenaufgaben">
        <p>
          Zeichne erst selbst, dann klapp die Musterlösung auf und vergleiche Punkt für Punkt. Die
          Punkte sind Richtwerte im Stil der IHK; die tatsächliche Verteilung legt jede Prüfung selbst
          fest.
        </p>

        <Zeichenaufgabe
          nr="5.1"
          loesung={<L5BestellungLoesung />}
          erklaerung={
            <p>
              Der Rückweg nach „Zahlungsart ändern“ mündet in eine Zusammenführung vor „Zahlung
              prüfen“, nicht direkt in die Aktion. Rechnung und Versand laufen parallel, deshalb
              Gabelung und Vereinigung über die Bahnen Shop und Lager. Bietest du dem Kunden nach
              einer Ablehnung zusätzlich den Abbruch an, brauchst du eine zweite Entscheidung und ein
              weiteres Ende; auch das ist eine gute Lösung.
            </p>
          }
          bewertung={[
            "1 Punkt: drei Schwimmbahnen Kunde, Shop und Lager mit Namen.",
            "2 Punkte: Startknoten, Endknoten und alle Aktionen in der richtigen Bahn.",
            "2 Punkte: Entscheidung nach „Zahlung prüfen“ mit Bedingungen in eckigen Klammern.",
            "2 Punkte: Schleife über eine Zusammenführung vor „Zahlung prüfen“.",
            "2 Punkte: Gabelung und Vereinigung um Rechnung und Versand.",
            "1 Punkt: Bestellung abschließen erst nach der Vereinigung.",
            "Richtwert gesamt: 10 Punkte.",
          ]}
        >
          <div className="uml-szenario">
            <span className="uml-szenario-titel">Online-Bestellung, Richtwert 10 Punkte</span>
            <p>
              Ein Kunde sendet im Onlineshop eine Bestellung ab. Der Shop prüft daraufhin die
              Zahlung. Wird sie abgelehnt, ändert der Kunde die Zahlungsart und der Shop prüft
              erneut. Wird sie bestätigt, sendet der Shop die Rechnung per E-Mail, während das Lager
              gleichzeitig die Ware verpackt und versendet. Sind Rechnung und Versand erledigt, schließt
              der Shop die Bestellung ab.
            </p>
            <p>
              <strong>Aufgabe:</strong> Stellen Sie den Ablauf als UML-Aktivitätsdiagramm mit den
              Schwimmbahnen Kunde, Shop und Lager dar.
            </p>
          </div>
        </Zeichenaufgabe>

        <Zeichenaufgabe
          nr="5.2"
          loesung={<L5PasswortLoesung />}
          erklaerung={
            <p>
              Beide Fehlerpfade sind Schleifen und brauchen je eine Zusammenführung: Der abgelaufene
              Link führt zurück an den Anfang, das zu schwache Passwort nur zurück zur Eingabe.
              Eine Kleinigkeit aus der IT-Sicherheit: Ob die E-Mail-Adresse existiert, verrät ein
              gutes System nicht; es zeigt immer dieselbe Meldung. Deshalb gibt es an dieser Stelle
              bewusst keine Entscheidung.
            </p>
          }
          bewertung={[
            "1 Punkt: Startknoten und Endknoten.",
            "2 Punkte: Aktionen in sinnvoller Reihenfolge von „Zurücksetzen anfordern“ bis „Passwort speichern“.",
            "2 Punkte: Entscheidung zum Link mit [abgelaufen] und [gültig], Rückweg an den Anfang.",
            "2 Punkte: Entscheidung zur Passwortstärke mit Bedingungen, Rückweg zur Eingabe.",
            "2 Punkte: beide Rückwege münden in Zusammenführungen, nicht direkt in Aktionen.",
            "1 Punkt: UML-Notation durchgehalten, Wächter in eckigen Klammern an jedem Ausgang der Rauten.",
            "Richtwert gesamt: 10 Punkte.",
          ]}
        >
          <div className="uml-szenario">
            <span className="uml-szenario-titel">Passwort zurücksetzen, Richtwert 10 Punkte</span>
            <p>
              Ein Nutzer fordert im Kundenportal an, sein Passwort zurückzusetzen. Das System sendet
              ihm einen Link per E-Mail, den er öffnet. Ist der Link abgelaufen, erhält er einen
              Hinweis und muss das Zurücksetzen erneut anfordern. Ist der Link gültig, gibt er ein
              neues Passwort ein. Ist es zu schwach, zeigt das System eine Fehlermeldung und der
              Nutzer gibt ein anderes Passwort ein. Ist es stark genug, wird es gespeichert.
            </p>
            <p>
              <strong>Aufgabe:</strong> Stellen Sie den Ablauf einschließlich der Fehlerpfade als
              UML-Aktivitätsdiagramm dar. Schwimmbahnen sind nicht gefordert.
            </p>
          </div>
        </Zeichenaufgabe>
      </LsAbschnitt>

      <LsAbschnitt id="fehler" titel="Typische Fehler">
        <LsHinweis art="warnung" titel="Darauf achten die Prüfer">
          <ul>
            <li>
              Bedingungen ohne eckige Klammern oder als „ja“ und „nein“: Das ist PAP-Notation. In
              UML steht an jedem Ausgang einer Entscheidung eine Bedingung wie <code>[gültig]</code>.
            </li>
            <li>
              Parallele Zweige mit einer Raute wieder zusammengeführt oder Alternativen mit einem
              Balken. Raute schließt Raute, Balken schließt Balken.
            </li>
            <li>
              Schleifen, die direkt in eine Aktion zurückführen, statt in eine Zusammenführung davor.
            </li>
            <li>
              Aktionen als eckige Rechtecke oder Zustände: Aktionen sind abgerundet und beschreiben
              ein Tun mit Verb, keinen Zustand wie „bezahlt“.
            </li>
            <li>
              Aktionen in der falschen Schwimmbahn: Maßgeblich ist, wer die Aktion ausführt, nicht
              wen sie betrifft.
            </li>
          </ul>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="quiz" titel="Jetzt selbst testen">
        <p style={{ marginBottom: 18 }}>
          Fünf Fragen zur Notation. Du hast so viele Versuche, wie du willst.
        </p>

        <QuizFrage
          nr={1}
          von={5}
          frage="Welches Symbol wartet, bis alle eingehenden Zweige angekommen sind?"
          optionen={[
            { text: "Die Zusammenführung, eine leere Raute", richtig: false },
            { text: "Die Vereinigung, ein Balken", richtig: true },
            { text: "Das Ablaufende, ein Kreis mit Kreuz", richtig: false },
            { text: "Der Objektknoten, ein eckiges Rechteck", richtig: false },
          ]}
          erklaerung="Die Vereinigung (join) ist ein Balken und synchronisiert: Sie wartet auf alle parallelen Zweige. Die Zusammenführung (merge) lässt jedes ankommende Token sofort weiter."
        />

        <QuizFrage
          nr={2}
          von={5}
          frage="Wie werden die Ausgänge einer Entscheidung im UML-Aktivitätsdiagramm beschriftet?"
          optionen={[
            { text: "Mit „ja“ und „nein“", richtig: false },
            { text: "Mit Bedingungen in eckigen Klammern, etwa [Betrag > 100]", richtig: true },
            { text: "Mit der Frage in der Raute, die Ausgänge bleiben leer", richtig: false },
            { text: "Mit Nummern in runden Klammern", richtig: false },
          ]}
          erklaerung="In UML steht an jedem ausgehenden Kontrollfluss eine Bedingung (guard) in eckigen Klammern. „ja“ und „nein“ mit der Frage in der Raute ist die Notation des Programmablaufplans."
        />

        <QuizFrage
          nr={3}
          von={5}
          frage="Was passiert, wenn in einem Diagramm mit parallelen Zweigen ein Token das Aktivitätsende erreicht?"
          optionen={[
            { text: "Nur dieser Zweig endet, die anderen laufen weiter.", richtig: false },
            { text: "Die gesamte Aktivität endet, auch alle anderen Zweige.", richtig: true },
            { text: "Die Aktivität startet neu.", richtig: false },
            { text: "Nichts, das Ende wird erst nach der Vereinigung wirksam.", richtig: false },
          ]}
          erklaerung="Das Aktivitätsende (Kreis mit gefülltem Punkt) beendet die ganze Aktivität. Soll nur ein Zweig enden, nimmst du das Ablaufende, den Kreis mit Kreuz."
        />

        <QuizFrage
          nr={4}
          von={5}
          frage="Wozu dienen Schwimmbahnen im Aktivitätsdiagramm?"
          optionen={[
            { text: "Sie zeigen, welche Aktionen parallel laufen.", richtig: false },
            { text: "Sie ordnen jede Aktion dem Beteiligten zu, der sie ausführt.", richtig: true },
            { text: "Sie trennen den Hauptablauf von den Fehlerpfaden.", richtig: false },
            { text: "Sie ersetzen Start- und Endknoten.", richtig: false },
          ]}
          erklaerung="Schwimmbahnen (Partitionen) zeigen die Zuständigkeit: Jede Aktion liegt in der Bahn der Rolle, Abteilung oder des Systems, das sie ausführt. Parallelität zeigen Gabelung und Vereinigung."
        />

        <QuizFrage
          nr={5}
          von={5}
          frage="Eine Aufgabe verlangt ein Struktogramm. Welches Element gehört NICHT hinein?"
          optionen={[
            { text: "Ein Verzweigungsblock mit „ja“ und „nein“", richtig: false },
            { text: "Ein Schleifenblock für eine kopfgesteuerte Schleife", richtig: false },
            { text: "Ein Pfeil zurück zu einer früheren Anweisung", richtig: true },
            { text: "Ein Block mit einer einzelnen Anweisung", richtig: false },
          ]}
          erklaerung="Struktogramme kennen keine Pfeile und keine Sprünge. Sie werden als Blöcke von oben nach unten gelesen; Wiederholungen stehen in eigenen Schleifenblöcken."
        />
      </LsAbschnitt>
    </LektionLayout>
  );
}
