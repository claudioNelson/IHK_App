import type { Metadata } from "next";
import { LsAbschnitt, LsHinweis } from "../../lernen/_components/LsBausteine";
import QuizFrage from "../../lernen/_components/QuizFrage";
import LektionLayout from "../../components/kurs/LektionLayout";
import { Zeichenaufgabe } from "../../components/kurs/KursBausteine";
import {
  AmpelZustaende,
  AnmeldungLoesung,
  BestellungZustaende,
  LastenradSequenz,
  NachrichtMuster,
  SequenzAufbau,
  TicketLoesung,
  type NachrichtArt,
} from "../_components/UmlDiagramme2";
import { umlKurs } from "../_components/lektionen";

export const metadata: Metadata = {
  title: "UML Lektion 6: Sequenzdiagramm und Zustandsdiagramm",
  description:
    "Sequenzdiagramme und Zustandsdiagramme für die IHK-Prüfung: Lebenslinien, synchrone und asynchrone Nachrichten, Antworten, alt und loop, Zustände und Übergänge mit Ereignis, Bedingung und Aktion. Mit zwei Zeichenaufgaben und Musterlösung.",
  alternates: { canonical: "https://lernarena.app/uml-kurs/lektion-6" },
};

const nachrichten: { art: NachrichtArt; name: string; bedeutung: string }[] = [
  {
    art: "synchron",
    name: "Synchrone Nachricht",
    bedeutung: "Gefüllte Spitze. Der Sender wartet, bis die Antwort kommt. Der normale Methodenaufruf.",
  },
  {
    art: "asynchron",
    name: "Asynchrone Nachricht",
    bedeutung: "Offene Spitze. Der Sender arbeitet sofort weiter, etwa bei einer Benachrichtigung oder einem Webhook.",
  },
  {
    art: "antwort",
    name: "Antwort (reply)",
    bedeutung: "Gestrichelt mit offener Spitze (eine gefüllte Spitze ist ebenfalls erlaubt). Rückgabe an den Aufrufer, beschriftet mit dem Ergebnis.",
  },
];

const fragmente: { operator: string; bedeutung: string; beispiel: string }[] = [
  { operator: "alt", bedeutung: "Alternativen, genau ein Bereich wird ausgeführt", beispiel: "[frei] buchen, [else] Hinweis" },
  { operator: "opt", bedeutung: "Optional, ein Bereich, der nur bei erfüllter Bedingung läuft", beispiel: "[Newsletter gewünscht] Mail senden" },
  { operator: "loop", bedeutung: "Wiederholung, solange der Wächter gilt", beispiel: "[für jede Position] Preis addieren" },
];

const uebergangTeile: { teil: string; bedeutung: string; beispiel: string }[] = [
  { teil: "Ereignis", bedeutung: "Was den Übergang auslöst (Trigger)", beispiel: "zahlungEingang" },
  { teil: "[Bedingung]", bedeutung: "Wächter: Übergang nur, wenn sie wahr ist", beispiel: "[vollständig]" },
  { teil: "/ Aktion", bedeutung: "Was beim Übergang ausgeführt wird", beispiel: "/ rechnungSenden" },
];

const abgrenzung: { frage: string; diagramm: string; merkmal: string }[] = [
  {
    frage: "Wer ruft wen in welcher Reihenfolge auf?",
    diagramm: "Sequenzdiagramm",
    merkmal: "Mehrere Objekte, Zeit läuft nach unten, Nachrichten zwischen Lebenslinien.",
  },
  {
    frage: "Welche Schritte hat ein Prozess, mit Entscheidungen und Parallelität?",
    diagramm: "Aktivitätsdiagramm",
    merkmal: "Ein Ablauf aus Aktionen, Rauten und Balken, oft über mehrere Beteiligte.",
  },
  {
    frage: "Welche Zustände durchläuft ein einzelnes Objekt?",
    diagramm: "Zustandsdiagramm",
    merkmal: "Ein Objekt, Zustände als abgerundete Rechtecke, Ereignisse an den Übergängen.",
  },
];

export default function Lektion6() {
  return (
    <LektionLayout
      kurs={umlKurs}
      nr={6}
      lead="Das Sequenzdiagramm zeigt, welches Objekt wann welche Nachricht an ein anderes schickt. Das Zustandsdiagramm zeigt, welche Zustände ein Objekt durchläuft und wodurch es sie wechselt. Beide gehören zu den Verhaltensdiagrammen und kommen in der AP2 Anwendungsentwicklung gelegentlich vor."
      uebungen={2}
      aufgabenText="2 Zeichenaufgaben, 5 Quizfragen"
    >
      <LsAbschnitt id="sequenz" titel="Aufbau eines Sequenzdiagramms">
        <p>
          Ein Sequenzdiagramm (sequence diagram) beantwortet eine Frage: <strong>Wer schickt wem
          wann welche Nachricht?</strong> Die Beteiligten stehen oben nebeneinander, die Zeit läuft
          von oben nach unten. Was weiter unten steht, passiert später. Mehr Leserichtung gibt es
          nicht, und genau das macht das Diagramm so gut prüfbar.
        </p>

        <SequenzAufbau />

        <h3>Lebenslinien</h3>
        <p>
          Jeder Beteiligte bekommt eine Lebenslinie (lifeline): oben ein Rechteck mit dem Namen,
          darunter eine senkrechte gestrichelte Linie. Der Name folgt dem Muster{" "}
          <code>rolle: Klasse</code>, zum Beispiel <code>b: Buchungsservice</code>. Brauchst du
          keinen Rollennamen, lässt du ihn weg und schreibst <code>:Buchungsservice</code>; der
          Doppelpunkt bleibt stehen und zeigt, dass ein Objekt dieser Klasse gemeint ist. Ein
          Mensch, der von außen mit dem System arbeitet, darf als Strichfigur erscheinen wie im
          Use-Case-Diagramm.
        </p>
        <LsHinweis titel="Unterstreichen oder nicht?">
          <p>
            Viele IHK-Musterlösungen unterstreichen den Namen im Kopf, wie bei Objekten im
            Objektdiagramm. UML 2.5 verlangt das nicht mehr, falsch ist es aber auch nicht. Wir
            unterstreichen im Kurs, weil du es in der Prüfung so am häufigsten sehen wirst.
            Entscheidend ist der Doppelpunkt vor dem Klassennamen.
          </p>
        </LsHinweis>

        <h3>Aktivierungsbalken</h3>
        <p>
          Ein schmales Rechteck auf der Lebenslinie zeigt, wann ein Objekt gerade arbeitet: Es
          beginnt, wenn eine Nachricht ankommt, und endet mit der Antwort. Ruft ein Objekt während
          dieser Zeit selbst andere auf, bleibt sein Balken stehen, denn es wartet auf deren
          Antwort. Aktivierungsbalken (execution specification) sind in der Prüfung selten
          Pflicht, machen dein Diagramm aber deutlich lesbarer und bringen manchmal einen
          Zusatzpunkt.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="nachrichten" titel="Nachrichten: synchron, asynchron, Antwort">
        <p>
          Eine Nachricht (message) ist ein waagerechter Pfeil von der Lebenslinie des Senders zur
          Lebenslinie des Empfängers, beschriftet mit dem Methodenaufruf, etwa{" "}
          <code>istFrei(radNr, zeitraum)</code>. Welche Art gemeint ist, erkennst du nur an Spitze
          und Linie. Genau hier gehen in der Prüfung die meisten Punkte verloren.
        </p>
        <div className="ls-table-wrap">
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Pfeil</th>
                <th scope="col">Art</th>
                <th scope="col">Bedeutung</th>
              </tr>
            </thead>
            <tbody>
              {nachrichten.map((n) => (
                <tr key={n.art}>
                  <td className="uml-muster-zelle">
                    <NachrichtMuster art={n.art} label={`Pfeil für ${n.name}`} />
                  </td>
                  <td className="txt">
                    <strong>{n.name}</strong>
                  </td>
                  <td className="txt">{n.bedeutung}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        <p>
          Die Antwort beschriftest du mit dem Rückgabewert, also <code>frei</code> oder{" "}
          <code>buchungsNr</code>. Eine Antwort ohne vorherigen synchronen Aufruf gibt es nicht.
          Umgekehrt darfst du Antworten weglassen, wenn die Aufgabe sie nicht verlangt; zeichnest du
          sie, dann gestrichelt.
        </p>
        <h3>Selbstaufruf</h3>
        <p>
          Ruft ein Objekt eine eigene Methode auf, läuft der Pfeil von seiner Lebenslinie nach
          rechts, ein Stück nach unten und zurück auf dieselbe Lebenslinie. Dort beginnt ein
          zweiter, leicht versetzter Aktivierungsbalken. Im Beispiel unten lädt der
          Buchungsservice so mit <code>ladeBelegung(radNr)</code> die bestehenden Buchungen.
        </p>
        <h3>Objekt erzeugen und zerstören</h3>
        <p>
          Entsteht ein Objekt erst während des Ablaufs, zeigt ein gestrichelter Pfeil mit{" "}
          <code>«create»</code> auf den Kopf seiner Lebenslinie, der dann auf dieser Höhe beginnt.
          Wird ein Objekt zerstört, endet seine Lebenslinie mit einem großen X, meist ausgelöst
          durch eine Nachricht mit <code>«destroy»</code>.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="fragmente" titel="Fragmente: alt, opt und loop in Kürze">
        <p>
          Verzweigungen und Wiederholungen zeichnest du mit einem kombinierten Fragment (combined
          fragment): ein Rahmen über die beteiligten Lebenslinien, links oben der Operator in
          einem kleinen Fünfeck. Jeder Bereich bekommt einen Wächter (guard) in eckigen Klammern.
          Bei <code>alt</code> trennt eine gestrichelte Linie die Bereiche, der letzte heißt oft{" "}
          <code>[else]</code>.
        </p>
        <div className="ls-table-wrap">
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Operator</th>
                <th scope="col">Bedeutung</th>
                <th scope="col">Beispiel</th>
              </tr>
            </thead>
            <tbody>
              {fragmente.map((f) => (
                <tr key={f.operator}>
                  <td>{f.operator}</td>
                  <td className="txt">{f.bedeutung}</td>
                  <td className="txt">{f.beispiel}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        <p>
          UML kennt noch weitere Operatoren wie <code>par</code> für parallele Bereiche oder{" "}
          <code>break</code>. In Prüfungen reichen fast immer <code>alt</code>, <code>opt</code>{" "}
          und <code>loop</code>.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="beispiel-sequenz" titel="Beispiel: Ein Lastenrad buchen">
        <div className="uml-szenario">
          <span className="uml-szenario-titel">Ausgangssituation</span>
          <p>
            Auf der Buchungsplattform der Stadtwerke Mittelstadt bucht ein <mark>Kunde</mark> in
            der <mark>Web-App</mark> ein Lastenrad für einen Zeitraum. Die Web-App fragt beim{" "}
            <mark>Buchungsservice</mark> an, ob das Rad frei ist; dieser lädt dazu die vorhandenen
            Belegungen. Ist das Rad frei, legt der Buchungsservice die Buchung an und lässt den
            Betrag beim <mark>Zahlungsanbieter</mark> reservieren. Der Kunde erhält eine
            Bestätigung. Sobald die Zahlung endgültig durch ist, meldet der Zahlungsanbieter das
            von sich aus an den Buchungsservice. Ist das Rad belegt, bekommt der Kunde einen
            Hinweis.
          </p>
        </div>
        <LastenradSequenz caption="Sequenzdiagramm: Buchung eines Lastenrads mit alt-Fragment" />
        <p>So liest du das Diagramm von oben nach unten:</p>
        <ol className="uml-ol">
          <li>
            Der Kunde ruft <code>buche(radNr, zeitraum)</code> auf. Die Web-App wird aktiv und
            bleibt es bis zur Antwort an den Kunden.
          </li>
          <li>
            Die Web-App fragt synchron <code>istFrei(…)</code> an und wartet. Der Buchungsservice
            ruft sich selbst mit <code>ladeBelegung(radNr)</code> auf und antwortet mit{" "}
            <code>frei</code>.
          </li>
          <li>
            Das <code>alt</code>-Fragment verzweigt: Im Fall <code>[frei]</code> folgt die Buchung
            mit Reservierung beim Zahlungsanbieter, jede synchrone Nachricht bekommt ihre
            gestrichelte Antwort.
          </li>
          <li>
            Die Meldung <code>bestaetigt(zahlungsId)</code> kommt später und asynchron: Der
            Zahlungsanbieter wartet auf keine Antwort, darum die offene Spitze und kein
            Rückpfeil.
          </li>
          <li>
            Im Fall <code>[else]</code> antwortet die Web-App dem Kunden nur mit einem Hinweis.
          </li>
        </ol>
      </LsAbschnitt>

      <LsAbschnitt id="zustand" titel="Das Zustandsdiagramm">
        <p>
          Ein Zustandsdiagramm (state machine diagram) beschreibt <strong>ein einzelnes
          Objekt</strong> über seine Lebenszeit: in welchen Zuständen es sein kann und welches
          Ereignis es in den nächsten bringt. Eine Bestellung ist neu, dann bezahlt, dann
          versandt. Mehr Objekte oder Nachrichten gibt es hier nicht.
        </p>
        <ul>
          <li>
            <strong>Zustand</strong> (state): abgerundetes Rechteck mit einem Namen, der eine
            Situation beschreibt, etwa „Bezahlt“ oder „Wartet auf Kunde“.
          </li>
          <li>
            <strong>Startzustand</strong>: gefüllter Kreis. Genau ein Pfeil führt heraus, ohne
            Ereignis und Bedingung; eine Aktion ist erlaubt.
          </li>
          <li>
            <strong>Endzustand</strong>: Kreis mit gefülltem Kern. Es darf mehrere geben, aber
            keiner hat einen Pfeil nach draußen.
          </li>
          <li>
            <strong>Übergang</strong> (transition): Pfeil mit offener Spitze von einem Zustand
            zum nächsten, beschriftet nach dem Muster <code>ereignis [bedingung] / aktion</code>.
          </li>
        </ul>
        <div className="ls-table-wrap">
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Teil</th>
                <th scope="col">Bedeutung</th>
                <th scope="col">Beispiel</th>
              </tr>
            </thead>
            <tbody>
              {uebergangTeile.map((u) => (
                <tr key={u.teil}>
                  <td>{u.teil}</td>
                  <td className="txt">{u.bedeutung}</td>
                  <td className="txt">{u.beispiel}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        <p>
          Alle drei Teile sind optional, die Reihenfolge ist aber fest. Soll ein Zustand beim
          Betreten, während er aktiv ist oder beim Verlassen etwas tun, schreibst du das unter
          einen Trennstrich in den Zustand: <code>entry / …</code>, <code>do / …</code> und{" "}
          <code>exit / …</code>.
        </p>

        <h3>Beispiel Bestellstatus</h3>
        <div className="uml-szenario">
          <span className="uml-szenario-titel">Ausgangssituation</span>
          <p>
            Eine neue Bestellung wird bezahlt, sobald die Zahlung vollständig eingegangen ist; dabei
            wird die Rechnung verschickt. Beim Versand erhält der Kunde die Sendungsnummer per
            Mail. Meldet der Paketdienst die Zustellung, ist die Bestellung abgeschlossen. Eine
            neue oder bezahlte Bestellung kann storniert werden, bei einer bezahlten wird der
            Betrag erstattet. Versandte Bestellungen lassen sich nicht mehr stornieren.
          </p>
        </div>
        <BestellungZustaende caption="Zustandsdiagramm: Status einer Bestellung" />
        <p>
          Achte auf das, was fehlt: Von „Versandt“ führt kein Pfeil nach „Storniert“, weil der Text
          das ausschließt. Ein Zustandsdiagramm sagt also nicht nur, was möglich ist, sondern auch,
          was nicht geht. Und ein Ereignis wie <code>zahlungEingang</code> wirkt nur im Zustand
          „Neu“; in jedem anderen Zustand wird es ignoriert.
        </p>

        <h3>Beispiel Ampel</h3>
        <p>
          Eine Verkehrsampel wechselt zeitgesteuert. Zeitereignisse schreibst du mit{" "}
          <code>after(…)</code>, gemessen ab dem Betreten des Zustands. Weil die Ampel endlos
          läuft, hat ihr Diagramm keinen Endzustand. Das ist erlaubt und hier sogar richtig.
        </p>
        <AmpelZustaende caption="Zustandsdiagramm: Ampel mit Zeitereignissen" />
      </LsAbschnitt>

      <LsAbschnitt id="abgrenzung" titel="Sequenz, Aktivität oder Zustand?">
        <p>
          Alle drei beschreiben Verhalten, und in der Aufgabe ist nicht immer der Name des
          Diagramms genannt. Frag dich, was im Mittelpunkt steht:
        </p>
        <div className="ls-table-wrap">
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Leitfrage</th>
                <th scope="col">Diagramm</th>
                <th scope="col">Erkennungsmerkmal</th>
              </tr>
            </thead>
            <tbody>
              {abgrenzung.map((a) => (
                <tr key={a.diagramm}>
                  <td className="txt">{a.frage}</td>
                  <td className="txt">
                    <strong>{a.diagramm}</strong>
                  </td>
                  <td className="txt">{a.merkmal}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        <p>
          Faustregel: Stehen im Text Klassen oder Systemteile, die sich gegenseitig aufrufen (App,
          Server, Datenbank, Schnittstelle), ist es ein Sequenzdiagramm. Stehen dort Tätigkeiten
          von Menschen oder Abteilungen mit „wenn, dann“ und „gleichzeitig“, ist es ein
          Aktivitätsdiagramm. Geht es um die Zustände eines Objekts (Ticket, Auftrag, Gerät), ist es
          ein Zustandsdiagramm.
        </p>
        <LsHinweis titel="So fragt die IHK" icon="buch" label="Prüfungsbezug">
          <p>
            Sequenzdiagramme kommen vor allem in der AP2 für Anwendungsentwickler, oft als
            Ergänzung eines vorgegebenen Klassendiagramms: „Stellen Sie den Ablauf der Methode … als
            Sequenzdiagramm dar.“ Dann müssen die Nachrichten zu den Methoden im Klassendiagramm
            passen. Zustandsdiagramme sind seltener, meist für Tickets, Aufträge oder Geräte, und
            bringen mit sauber beschrifteten Übergängen schnell Punkte.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="uebungen" titel="Zeichenaufgaben">
        <p>Zeichne erst selbst, dann klapp die Musterlösung auf und vergleiche Punkt für Punkt.</p>

        <Zeichenaufgabe
          nr="6.1"
          loesung={<AnmeldungLoesung />}
          erklaerung={
            <p>
              Die Benutzerverwaltung vergleicht den Hash, darum der Selbstaufruf{" "}
              <code>berechneHash(passwort)</code> auf ihrer Lebenslinie und nicht auf der
              LoginSeite. Das <code>alt</code>-Fragment umfasst nur, was sich je nach Ergebnis
              unterscheidet. Die Antworten an den Nutzer sind gestrichelt, weil sie den
              synchronen Aufruf <code>anmelden(…)</code> beantworten. Andere sinnvolle
              Methodennamen sind natürlich ebenso richtig.
            </p>
          }
          bewertung={[
            "2 Punkte: drei Lebenslinien, Nutzer (Strichfigur oder Rechteck), :LoginSeite und :Benutzerverwaltung, mit Doppelpunkt.",
            "2 Punkte: synchrone Aufrufe anmelden(…) und pruefe(…) mit gefüllter Spitze und Parametern.",
            "1 Punkt: Selbstaufruf berechneHash(…) auf der Benutzerverwaltung.",
            "1 Punkt: Antwort ok gestrichelt zurück an die LoginSeite.",
            "3 Punkte: alt-Fragment mit Operator, Wächtern [ok] und [else] und gestrichelter Trennlinie.",
            "1 Punkt: starteSitzung() im ersten Bereich, Startseite und Fehlermeldung als Antworten an den Nutzer.",
          ]}
        >
          <div className="uml-szenario">
            <span className="uml-szenario-titel">Mitarbeiterportal, 10 Punkte</span>
            <p>
              Die Nordwerk AG baut ein Mitarbeiterportal. Ein Nutzer meldet sich auf der LoginSeite
              mit Benutzername und Passwort an. Die LoginSeite übergibt beides an die
              Benutzerverwaltung. Diese berechnet zunächst den Hash des eingegebenen Passworts und
              gibt dann zurück, ob die Anmeldung korrekt ist. Stimmt sie, startet die LoginSeite
              eine Sitzung und zeigt die Startseite an. Andernfalls erhält der Nutzer eine
              Fehlermeldung.
            </p>
            <p>
              <strong>Aufgabe:</strong> Stellen Sie den Ablauf der Anmeldung als Sequenzdiagramm
              mit den drei Beteiligten dar. Verwenden Sie für die Fallunterscheidung ein
              geeignetes kombiniertes Fragment.
            </p>
          </div>
        </Zeichenaufgabe>

        <Zeichenaufgabe
          nr="6.2"
          loesung={<TicketLoesung />}
          erklaerung={
            <p>
              Zwischen „In Bearbeitung“ und „Gelöst“ laufen zwei Übergänge in entgegengesetzte
              Richtungen, ebenso zwischen „In Bearbeitung“ und „Wartet auf Kunde“; jeder bekommt
              sein eigenes Ereignis. Die beiden Wege von „Gelöst“ nach „Geschlossen“ darfst du als
              einen Übergang mit zwei Auslösern schreiben (durch Komma getrennt) oder als zwei
              getrennte Pfeile. Die 14 und 7 Tage sind Zeitereignisse, darum <code>after(…)</code>.
              Die Mail an den Techniker steht als Aktion am Übergang <code>zuweisen</code> und nicht
              als <code>entry</code> in „In Bearbeitung“: Ein entry würde bei jeder Rückkehr aus
              „Wartet auf Kunde“ die Mail erneut auslösen, gewollt ist sie nur bei der Zuweisung.
            </p>
          }
          bewertung={[
            "2 Punkte: Startzustand mit Pfeil nach Offen, Endzustand nach Geschlossen.",
            "2 Punkte: alle fünf Zustände als abgerundete Rechtecke mit passenden Namen.",
            "4 Punkte: Übergänge vollständig und in der richtigen Richtung, auch die beiden Rückwege nach In Bearbeitung.",
            "2 Punkte: Beschriftung nach dem Muster Ereignis [Bedingung] / Aktion, darunter die Aktion technikerMailen und die Zeitereignisse after(14 Tage) und after(7 Tage).",
          ]}
        >
          <div className="uml-szenario">
            <span className="uml-szenario-titel">IT-Service, 10 Punkte</span>
            <p>
              Der IT-Service der Nordwerk AG verwaltet Störungstickets. Ein neues Ticket ist offen.
              Wird es einem Techniker zugewiesen, ist es in Bearbeitung, und der Techniker wird per
              Mail informiert. Braucht er weitere Informationen, stellt er eine Rückfrage, und das
              Ticket wartet auf den Kunden. Antwortet der Kunde, geht es in Bearbeitung zurück;
              antwortet er 14 Tage lang nicht, wird das Ticket geschlossen. Trägt der Techniker
              eine Lösung ein, gilt das Ticket als gelöst. Meldet der Kunde, dass das Problem
              weiter besteht, ist es wieder in Bearbeitung. Bestätigt er die Lösung oder meldet er
              sich 7 Tage lang nicht, wird das Ticket geschlossen und nicht mehr verändert.
            </p>
            <p>
              <strong>Aufgabe:</strong> Erstellen Sie ein Zustandsdiagramm für ein Störungsticket
              mit den Zuständen Offen, In Bearbeitung, Wartet auf Kunde, Gelöst und Geschlossen.
              Beschriften Sie alle Übergänge.
            </p>
          </div>
        </Zeichenaufgabe>
      </LsAbschnitt>

      <LsAbschnitt id="fehler" titel="Typische Fehler">
        <LsHinweis art="warnung" titel="Darauf achten die Prüfer">
          <ul>
            <li>
              Pfeilspitzen verwechselt: Ein normaler Methodenaufruf ist synchron und hat eine
              gefüllte Spitze. Eine offene Spitze an einer durchgezogenen Linie bedeutet asynchron.
            </li>
            <li>
              Antworten durchgezogen gezeichnet oder Antworten auf asynchrone Nachrichten ergänzt.
              Antworten sind gestrichelt und gehören nur zu synchronen Aufrufen.
            </li>
            <li>
              Nachrichten schräg nach oben gezeichnet. Die Zeit läuft nach unten, ein Pfeil darf
              nie in die Vergangenheit zeigen.
            </li>
            <li>
              Im Zustandsdiagramm Tätigkeiten als Zustände: „Rechnung senden“ ist eine Aktion am
              Übergang, der Zustand heißt „Bezahlt“. Zustände beschreiben eine Situation, keine
              Handlung.
            </li>
            <li>
              Unbeschriftete Übergänge. UML erlaubt sie zwar (sie feuern, sobald der Zustand
              seine Arbeit erledigt hat), aber nennt der Text ein Ereignis, fehlt ohne Beschriftung
              der Punkt. Nur der Pfeil aus dem Startzustand hat nie ein Ereignis.
            </li>
          </ul>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="quiz" titel="Jetzt selbst testen">
        <p style={{ marginBottom: 18 }}>
          Fünf Fragen zu beiden Diagrammen. Du hast so viele Versuche, wie du willst.
        </p>

        <QuizFrage
          nr={1}
          von={5}
          frage="Ein Pfeil im Sequenzdiagramm ist durchgezogen und hat eine gefüllte Spitze. Was bedeutet das?"
          optionen={[
            { text: "Eine Antwort auf einen Aufruf", richtig: false },
            { text: "Eine synchrone Nachricht: Der Sender wartet auf die Antwort.", richtig: true },
            { text: "Eine asynchrone Nachricht: Der Sender arbeitet sofort weiter.", richtig: false },
            { text: "Das Erzeugen eines neuen Objekts", richtig: false },
          ]}
          erklaerung="Durchgezogen mit gefüllter Spitze ist die synchrone Nachricht, der normale Methodenaufruf. Asynchron hat eine offene Spitze, die Antwort ist gestrichelt."
        />

        <QuizFrage
          nr={2}
          von={5}
          frage="Wie beschriftest du den Kopf einer Lebenslinie für ein Objekt der Klasse Warenkorb ohne eigenen Rollennamen?"
          optionen={[
            { text: "Warenkorb:", richtig: false },
            { text: ":Warenkorb", richtig: true },
            { text: "Warenkorb()", richtig: false },
            { text: "<<Warenkorb>>", richtig: false },
          ]}
          erklaerung="Das Muster ist rolle: Klasse. Ohne Rollennamen bleibt der Doppelpunkt vor der Klasse stehen: :Warenkorb."
        />

        <QuizFrage
          nr={3}
          von={5}
          frage="Ein Webshop soll für jede Position im Warenkorb den Preis beim Lagerservice abfragen. Welches Fragment passt?"
          optionen={[
            { text: "alt", richtig: false },
            { text: "opt", richtig: false },
            { text: "loop", richtig: true },
            { text: "par", richtig: false },
          ]}
          erklaerung="„Für jede Position“ ist eine Wiederholung, also loop mit einem Wächter wie [für jede Position]. alt steht für Alternativen, opt für einen optionalen Teil."
        />

        <QuizFrage
          nr={4}
          von={5}
          frage="Welche Beschriftung eines Übergangs ist nach UML richtig aufgebaut?"
          optionen={[
            { text: "/ mailSenden [bezahlt] versenden", richtig: false },
            { text: "versenden [bezahlt] / mailSenden", richtig: true },
            { text: "[versenden] bezahlt / mailSenden", richtig: false },
            { text: "versenden / [bezahlt] mailSenden", richtig: false },
          ]}
          erklaerung="Die feste Reihenfolge ist Ereignis [Bedingung] / Aktion. Die Bedingung steht in eckigen Klammern, die Aktion hinter dem Schrägstrich."
        />

        <QuizFrage
          nr={5}
          von={5}
          frage="Die Aufgabe lautet: „Stellen Sie dar, welche Status ein Reparaturauftrag durchläuft.“ Welches Diagramm zeichnest du?"
          optionen={[
            { text: "Sequenzdiagramm", richtig: false },
            { text: "Aktivitätsdiagramm", richtig: false },
            { text: "Zustandsdiagramm", richtig: true },
            { text: "Klassendiagramm", richtig: false },
          ]}
          erklaerung="Status eines einzelnen Objekts und ihre Wechsel sind der Fall für das Zustandsdiagramm. Ein Aktivitätsdiagramm zeigt dagegen die Schritte eines Prozesses."
        />
      </LsAbschnitt>
    </LektionLayout>
  );
}
