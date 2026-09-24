import type { Metadata } from "next";
import { LsAbschnitt, LsHinweis } from "../../lernen/_components/LsBausteine";
import QuizFrage from "../../lernen/_components/QuizFrage";
import LektionLayout from "../../components/kurs/LektionLayout";
import { Zeichenaufgabe } from "../../components/kurs/KursBausteine";
import {
  L2AkteurGeneralisierung,
  L2BibliothekLoesung,
  L2IncludeExtend,
  L2LastenradUseCase,
  L2TierarztLoesung,
} from "../_components/UmlDiagramme";
import { umlKurs } from "../_components/lektionen";

export const metadata: Metadata = {
  title: "UML Lektion 2: Use-Case-Diagramm mit include und extend",
  description:
    "Use-Case-Diagramme für die IHK-Prüfung: Akteure, Systemgrenze, Anwendungsfälle, include und extend mit der richtigen Pfeilrichtung sowie Generalisierung von Akteuren. Mit Schritt-für-Schritt-Beispiel und zwei Zeichenaufgaben.",
  alternates: { canonical: "https://lernarena.app/uml-kurs/lektion-2" },
};

const elemente: { element: string; symbol: string; bedeutung: string }[] = [
  {
    element: "Akteur (actor)",
    symbol: "Strichmännchen mit Namen",
    bedeutung: "Rolle außerhalb des Systems, die mit ihm arbeitet: Mensch oder anderes System.",
  },
  {
    element: "Anwendungsfall (use case)",
    symbol: "Ellipse mit Objekt und Verb im Infinitiv (Lastenrad buchen)",
    bedeutung: "Ein Ziel, das ein Akteur mit dem System erreicht und das ihm einen Nutzen bringt.",
  },
  {
    element: "Systemgrenze (system boundary)",
    symbol: "Rechteck mit Systemnamen",
    bedeutung: "Trennt, was das System leistet (innen), von denen, die es nutzen (außen).",
  },
  {
    element: "Assoziation (association)",
    symbol: "durchgezogene Linie",
    bedeutung: "Der Akteur ist am Anwendungsfall beteiligt. Keine Pfeilspitze nötig.",
  },
  {
    element: "Einbindung (include)",
    symbol: "gestrichelter Pfeil mit «include»",
    bedeutung: "Der Basisfall führt den anderen Fall immer mit aus. Pfeil zeigt zum eingebundenen Fall.",
  },
  {
    element: "Erweiterung (extend)",
    symbol: "gestrichelter Pfeil mit «extend»",
    bedeutung: "Der Fall erweitert den Basisfall nur unter einer Bedingung. Pfeil zeigt zum Basisfall.",
  },
  {
    element: "Generalisierung (generalization)",
    symbol: "Linie mit hohlem Dreieck",
    bedeutung: "Ein spezieller Akteur erbt alle Anwendungsfälle des allgemeinen. Dreieck am allgemeinen.",
  },
];

export default function Lektion2() {
  return (
    <LektionLayout
      kurs={umlKurs}
      nr={2}
      lead="Das Use-Case-Diagramm zeigt, wer ein System wofür nutzt, ohne zu verraten, wie es intern funktioniert. Hier lernst du alle Elemente, die Pfeilrichtung bei include und extend, und wie du ein Diagramm aus einem Szenariotext ableitest."
      uebungen={2}
      aufgabenText="2 Zeichenaufgaben, 5 Quizfragen"
    >
      <LsAbschnitt id="wozu" titel="Wozu ein Use-Case-Diagramm?">
        <p>
          Das Use-Case-Diagramm (use case diagram, auf Deutsch auch Anwendungsfalldiagramm) steht
          am Anfang eines Projekts. Es beantwortet zwei Fragen: <strong>Wer</strong> arbeitet mit dem
          System, und <strong>was</strong> will diese Person oder dieses System damit erreichen? Wie
          das technisch umgesetzt wird, spielt hier noch keine Rolle. Genau darin liegt der Wert: Ein
          Auftraggeber ohne IT-Kenntnisse kann das Diagramm lesen und sagen, ob etwas fehlt.
        </p>
        <p>
          In der Prüfung ist es deshalb oft die erste Teilaufgabe einer Modellierung: Aus einem
          Gesprächsprotokoll oder einer Anforderungsliste sollst du Akteure und Anwendungsfälle
          herausarbeiten. Die Elemente auf einen Blick:
        </p>
        <div className="ls-table-wrap">
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Element</th>
                <th scope="col">Darstellung</th>
                <th scope="col">Bedeutung</th>
              </tr>
            </thead>
            <tbody>
              {elemente.map((e) => (
                <tr key={e.element}>
                  <td className="txt">
                    <strong>{e.element}</strong>
                  </td>
                  <td className="txt">{e.symbol}</td>
                  <td className="txt">{e.bedeutung}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </LsAbschnitt>

      <LsAbschnitt id="grundelemente" titel="Akteure, Anwendungsfälle und Systemgrenze">
        <h3>Akteure</h3>
        <p>
          Ein Akteur (actor) ist eine <strong>Rolle</strong>, keine konkrete Person. Frau Yilmaz aus
          dem Kundenservice ist kein Akteur, „Mitarbeiter“ schon. Eine Person kann mehrere Rollen
          haben: Wer im Verleih arbeitet und privat ein Rad bucht, ist einmal Mitarbeiter und einmal
          Kunde. Akteure stehen immer <strong>außerhalb</strong> der Systemgrenze.
        </p>
        <p>
          Auch ein <strong>anderes System</strong> kann Akteur sein, etwa ein Zahlungsanbieter, ein
          SMS-Dienst oder ein Warenwirtschaftssystem. Es wird ebenfalls als Strichmännchen
          gezeichnet; alternativ ist ein Rechteck mit dem Schlüsselwort «actor» erlaubt, das
          Fremdsysteme optisch von Menschen abhebt. Beides gibt in der Prüfung volle Punkte, solange
          du innerhalb eines Diagramms bei einer Form bleibst.
        </p>
        <h3>Anwendungsfälle</h3>
        <p>
          Ein Anwendungsfall (use case) beschreibt ein <strong>Ziel</strong> mit erkennbarem Nutzen
          für den Akteur. Du benennst ihn mit Objekt und Verb im Infinitiv: „Lastenrad buchen“,
          „Rechnung bezahlen“, „Termin verschieben“. Ein guter Test ist die Frage: Würde der Akteur
          nach diesem Schritt zufrieden aufhören? Nach „Lastenrad buchen“ ja, nach „Button klicken“
          oder „Formular öffnen“ nicht. Solche Einzelschritte gehören in ein Aktivitätsdiagramm
          (Lektion 5).
        </p>
        <h3>Systemgrenze und Assoziation</h3>
        <p>
          Die Systemgrenze (system boundary) ist ein Rechteck, oben links steht der Name des Systems.
          Alle Anwendungsfälle liegen innen, alle Akteure außen. Eine durchgezogene Linie, die
          Assoziation (association), verbindet einen Akteur mit jedem Anwendungsfall, an dem er
          beteiligt ist. Pfeilspitzen brauchst du dort nicht; wer den Fall anstößt, geht aus dem Text
          hervor und nicht aus der Linie.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="include-extend" titel="include und extend: der Klassiker für Fehler">
        <p>
          Zwei Beziehungen verbinden Anwendungsfälle untereinander. Beide sind gestrichelte Pfeile
          mit offener Spitze und einem Stereotyp in französischen Anführungszeichen. Den Unterschied
          machen die Bedeutung und vor allem die <strong>Pfeilrichtung</strong>.
        </p>
        <L2IncludeExtend />
        <h3>include: immer dabei</h3>
        <p>
          Bei «include» (einbinden) führt der Basisfall den anderen Fall <strong>jedes Mal</strong>{" "}
          mit aus. Wer ein Lastenrad bucht, bezahlt immer. Der Pfeil zeigt vom Basisfall zum
          eingebundenen Fall, denn der Basisfall „ruft“ ihn auf, ähnlich wie eine Methode eine andere
          aufruft. Sinnvoll ist include vor allem, wenn mehrere Fälle denselben Teil brauchen: „Rad
          buchen“ und „Buchung verlängern“ binden beide „Bezahlen“ ein, und du beschreibst das
          Bezahlen nur einmal.
        </p>
        <h3>extend: nur unter einer Bedingung</h3>
        <p>
          Bei «extend» (erweitern) kommt der erweiternde Fall <strong>nur manchmal</strong> hinzu,
          nämlich wenn eine Bedingung erfüllt ist. Der Basisfall funktioniert auch ohne ihn und weiß
          nichts von ihm. Deshalb zeigt der Pfeil <strong>von der Erweiterung zum Basisfall</strong>:
          Die Erweiterung klinkt sich ein. Die Bedingung schreibst du in eine Notiz, die an der
          extend-Linie hängt. Die Stelle, an der sich die Erweiterung einklinkt, heißt
          Erweiterungspunkt (extension point) und darf unter dem Namen in der Ellipse stehen, etwa
          „extension points: Zusatzleistungen“. In Prüfungen wird er selten verlangt.
        </p>
        <LsHinweis titel="Eselsbrücke für die Pfeilrichtung">
          <p>
            Der Pfeil zeigt immer vom Fall, der den anderen kennt, zum Fall, der gekannt wird. Beim
            include kennt der Basisfall seinen Teil, also Pfeil weg vom Basisfall. Beim extend kennt
            die Erweiterung ihren Basisfall, also Pfeil hin zum Basisfall. Kurz:{" "}
            <strong>include zeigt weg, extend zeigt hin</strong>.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="generalisierung" titel="Generalisierung von Akteuren">
        <p>
          Hat ein Akteur alle Rechte eines anderen und dazu weitere, zeichnest du eine
          Generalisierung (generalization): eine durchgezogene Linie mit hohlem Dreieck, das auf den{" "}
          <strong>allgemeineren</strong> Akteur zeigt. Die Stationsleitung ist ein Mitarbeiter mit
          Zusatzrechten. Sie darf alles, was ein Mitarbeiter darf, ohne dass du jede Linie doppelt
          ziehst, und zusätzlich Räder ausmustern.
        </p>
        <L2AkteurGeneralisierung />
        <p>
          Das Dreieck ist dasselbe Symbol wie bei der Vererbung im Klassendiagramm (Lektion 4). Auch
          zwischen Anwendungsfällen ist eine Generalisierung erlaubt, etwa „Bezahlen“ mit den
          Spezialfällen „Per Karte bezahlen“ und „Per Rechnung bezahlen“. In Prüfungen kommt sie aber
          fast nur bei Akteuren vor.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="beispiel" titel="Beispiel Schritt für Schritt: Lastenrad-Verleih">
        <p>
          Dasselbe Szenario wie im Klassendiagramm der Lektion 3, diesmal aus Sicht der Nutzer. Lies
          den Text einmal ganz, dann gehst du in drei Schritten vor.
        </p>
        <div className="uml-szenario">
          <span className="uml-szenario-titel">Ausgangssituation</span>
          <p>
            Die Stadtwerke Mittelstadt planen einen Online-Verleih für Lastenräder.{" "}
            <mark>Kunden</mark> sollen ein <mark>Lastenrad buchen</mark> können; zu jeder Buchung
            gehört die <mark>Bezahlung</mark>, die über einen externen{" "}
            <mark>Zahlungsanbieter</mark> abgewickelt wird. Auf Wunsch kann der Kunde bei der Buchung{" "}
            <mark>Zubehör</mark> wie einen Kindersitz oder eine Regenplane{" "}
            <mark>hinzubuchen</mark>. Bis 24 Stunden vor Beginn kann ein Kunde seine{" "}
            <mark>Buchung stornieren</mark>. <mark>Mitarbeiter</mark> der Stadtwerke{" "}
            <mark>warten die Räder</mark> und melden sich dazu am System an.
          </p>
          <p>
            <strong>Aufgabe:</strong> Erstellen Sie ein Use-Case-Diagramm mit allen Akteuren,
            Anwendungsfällen und Beziehungen.
          </p>
        </div>

        <h3>Schritt 1: Akteure und Systemgrenze</h3>
        <p>
          Suche alle, die mit dem System arbeiten, und frage jeweils: Steht er innerhalb oder
          außerhalb? Kunde und Mitarbeiter sind Menschen außerhalb. Der Zahlungsanbieter ist ein
          fremdes System, mit dem der Verleih Daten austauscht, also ebenfalls ein Akteur. Die
          Stadtwerke sind nur der Auftraggeber; sie arbeiten nicht selbst mit dem System und werden
          kein Akteur. Das System bekommt einen kurzen Namen: Lastenrad-Verleih.
        </p>
        <L2LastenradUseCase stufe="akteure" caption="Schritt 1: Systemgrenze und die drei Akteure" />

        <h3>Schritt 2: Anwendungsfälle und Assoziationen</h3>
        <p>
          Jetzt sammelst du die Ziele. Aus den markierten Verben werden „Lastenrad buchen“, „Buchung
          stornieren“ und „Rad warten“. Das Anmelden des Mitarbeiters ist kein eigenständiger
          Anwendungsfall: Es ist eine Voraussetzung, kein Ziel. Niemand meldet sich an, um danach
          zufrieden aufzuhören. Als per «include» eingebundener Fall „Anmelden“ ist es dagegen
          üblich und wird in IHK-Lösungen akzeptiert. Jeder Fall bekommt eine Linie zu seinem
          Akteur.
        </p>
        <L2LastenradUseCase stufe="faelle" caption="Schritt 2: die Ziele der Akteure" />

        <h3>Schritt 3: include, extend und die Fremdsysteme</h3>
        <p>
          Jetzt prüfst du jeden Nebensatz auf „immer“ oder „auf Wunsch“:
        </p>
        <ul>
          <li>
            „Zu jeder Buchung gehört die Bezahlung“: immer, also{" "}
            <strong>«include»</strong> von „Lastenrad buchen“ zu „Bezahlen“. Der Zahlungsanbieter
            hängt am Fall „Bezahlen“, denn nur dort ist er beteiligt.
          </li>
          <li>
            „Auf Wunsch Zubehör hinzubuchen“: nur manchmal und nur während einer Buchung, also{" "}
            <strong>«extend»</strong> von „Zubehör hinzubuchen“ zu „Lastenrad buchen“, mit der
            Bedingung in einer Notiz.
          </li>
          <li>
            Und das Stornieren? Es ist kein extend von „Lastenrad buchen“, obwohl es mit der Buchung
            zu tun hat. Der Kunde storniert später, in einem eigenen Vorgang mit eigenem Ziel. Darum
            ist „Buchung stornieren“ ein eigenständiger Anwendungsfall mit eigener Linie zum Kunden.
          </li>
        </ul>
        <L2LastenradUseCase caption="Schritt 3: das fertige Use-Case-Diagramm" />
        <LsHinweis titel="Prüfungsbezug" icon="buch" label="Prüfungsbezug">
          <p>
            Typische Aufgaben lauten „Ergänzen Sie das Use-Case-Diagramm um …“ oder „Erstellen Sie
            ein Use-Case-Diagramm aus der Gesprächsnotiz“. Punkte gibt es meist einzeln für jeden
            Akteur, jeden Anwendungsfall, die Systemgrenze und jede korrekte include- oder
            extend-Beziehung. Ein vertauschter Pfeil kostet genau diese Beziehung, eine fehlende
            Systemgrenze oft einen ganzen Punkt. Achte auch darauf, ob nach dem Diagramm eine
            Erklärung gefragt ist, etwa „Erläutern Sie den Unterschied zwischen include und extend
            an Ihrem Diagramm“.
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
          nr="2.1"
          loesung={<L2BibliothekLoesung />}
          erklaerung={
            <p>
              „Leserkonto prüfen“ steckt in beiden Leser-Fällen, deshalb lohnt sich hier ein
              include: Du beschreibst die Prüfung einmal und nutzt sie zweimal. Die Mahngebühr kommt
              nur bei verspäteter Rückgabe dazu, das ist ein extend mit Pfeil zur Rückgabe. Eine
              zusätzliche Linie vom Leser zur Rückgabe ist vertretbar, weil er das Medium ja
              abgibt; entscheidend ist, dass der Bibliothekar die Rückgabe im System erfasst.
            </p>
          }
          bewertung={[
            "2 Punkte: Akteure Leser und Bibliothekar außerhalb der Systemgrenze, je 1 Punkt.",
            "1 Punkt: Systemgrenze mit Namen.",
            "3 Punkte: Anwendungsfälle Medium ausleihen, Ausleihe verlängern, Rückgabe entgegennehmen mit den richtigen Assoziationen.",
            "2 Punkte: Leserkonto prüfen per «include» aus beiden Fällen, Pfeile zum eingebundenen Fall.",
            "2 Punkte: Mahngebühr erheben per «extend», Pfeil zur Rückgabe, Bedingung angegeben.",
            "Richtwert gesamt: 10 Punkte.",
          ]}
        >
          <div className="uml-szenario">
            <span className="uml-szenario-titel">Stadtbibliothek, Richtwert 10 Punkte</span>
            <p>
              Die Stadtbibliothek führt ein neues Bibliothekssystem ein. Leser leihen Medien an
              Selbstbedienungsterminals aus und können laufende Ausleihen online verlängern. Vor
              jeder Ausleihe und jeder Verlängerung prüft das System das Leserkonto auf Sperren und
              offene Gebühren. Zurückgegebene Medien nimmt ein Bibliothekar an der Theke entgegen und
              bucht sie im System zurück. Ist die Leihfrist dabei überschritten, erhebt er zusätzlich
              eine Mahngebühr.
            </p>
            <p>
              <strong>Aufgabe:</strong> Erstellen Sie ein Use-Case-Diagramm mit Systemgrenze,
              Akteuren, Anwendungsfällen sowie den include- und extend-Beziehungen.
            </p>
          </div>
        </Zeichenaufgabe>

        <Zeichenaufgabe
          nr="2.2"
          loesung={<L2TierarztLoesung />}
          erklaerung={
            <p>
              Der SMS-Dienst ist ein fremdes System und damit ein Akteur außerhalb der Grenze. Er
              hängt nur an „SMS-Erinnerung senden“, nicht an den Terminfällen. Die Erinnerung wird
              bei jeder Buchung und jeder Verschiebung eingeplant, deshalb include aus beiden Fällen.
              Die Tierärztin erbt vom Praxismitarbeiter: Sie darf den Tagesplan einsehen, ohne dass du eine
              zweite Linie ziehst, und dokumentiert zusätzlich Behandlungen.
            </p>
          }
          bewertung={[
            "3 Punkte: Akteure Tierhalter, Praxismitarbeiter und SMS-Dienst, der SMS-Dienst als Akteur außerhalb der Systemgrenze.",
            "1 Punkt: Tierärztin mit Generalisierung, Dreieck am Praxismitarbeiter.",
            "3 Punkte: Anwendungsfälle Termin buchen, Termin verschieben, Tagesplan einsehen, Behandlung dokumentieren mit richtigen Assoziationen.",
            "2 Punkte: SMS-Erinnerung senden per «include» aus beiden Terminfällen, Pfeile zur SMS-Erinnerung.",
            "1 Punkt: Systemgrenze mit Namen.",
            "Richtwert gesamt: 10 Punkte.",
          ]}
        >
          <div className="uml-szenario">
            <span className="uml-szenario-titel">Tierarztpraxis, Richtwert 10 Punkte</span>
            <p>
              Eine Tierarztpraxis bekommt ein Terminsystem. Tierhalter buchen Termine online und
              können gebuchte Termine verschieben. Bei jeder Buchung und jeder Verschiebung plant das
              System automatisch eine Erinnerung per SMS ein, die über einen externen SMS-Dienst
              verschickt wird. Praxismitarbeiter sehen den Tagesplan ein. Tierärztinnen sind
              Praxismitarbeiter und dokumentieren zusätzlich die Behandlungen.
            </p>
            <p>
              <strong>Aufgabe:</strong> Erstellen Sie ein Use-Case-Diagramm. Berücksichtigen Sie
              dabei auch die Beziehung zwischen Praxismitarbeiter und Tierärztin.
            </p>
          </div>
        </Zeichenaufgabe>
      </LsAbschnitt>

      <LsAbschnitt id="fehler" titel="Typische Fehler">
        <LsHinweis art="warnung" titel="Darauf achten die Prüfer">
          <ul>
            <li>
              Abläufe statt Ziele: „Button Buchen klicken“, „Daten eingeben“ oder „Anmelden“ sind
              Schritte, keine eigenständigen Anwendungsfälle. Frag dich, ob der Akteur danach
              zufrieden aufhört. Ein per «include» eingebundenes „Anmelden“ ist dagegen üblich und
              wird akzeptiert.
            </li>
            <li>
              Pfeilrichtung vertauscht: include zeigt vom Basisfall weg, extend zeigt zum Basisfall
              hin. Durchgezogene Linien oder fehlende Stereotype zählen nicht.
            </li>
            <li>
              Systemgrenze vergessen oder Akteure hineingezeichnet. Auch ein Fremdsystem wie der
              Zahlungsanbieter steht außen.
            </li>
            <li>
              Alles per include verketten, bis das Diagramm wie ein Ablaufplan aussieht. Reihenfolgen
              zeigt das Use-Case-Diagramm nicht; dafür gibt es das Aktivitätsdiagramm.
            </li>
            <li>
              Konkrete Personen oder das eigene System als Akteur: „Frau Yilmaz“ oder
              „Buchungsplattform“ sind keine Akteure, „Mitarbeiter“ schon.
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
          frage="„Beim Buchen eines Termins wird immer die Versicherungskarte geprüft.“ Wie modellierst du das?"
          optionen={[
            { text: "«extend»-Pfeil von „Termin buchen“ zu „Versicherungskarte prüfen“", richtig: false },
            { text: "«include»-Pfeil von „Termin buchen“ zu „Versicherungskarte prüfen“", richtig: true },
            { text: "«include»-Pfeil von „Versicherungskarte prüfen“ zu „Termin buchen“", richtig: false },
            { text: "Durchgezogene Linie zwischen beiden Anwendungsfällen", richtig: false },
          ]}
          erklaerung="„Immer“ bedeutet include. Der Pfeil zeigt vom Basisfall (Termin buchen) zum eingebundenen Fall (Versicherungskarte prüfen)."
        />

        <QuizFrage
          nr={2}
          von={5}
          frage="Wohin zeigt der gestrichelte Pfeil bei einer «extend»-Beziehung?"
          optionen={[
            { text: "Vom Basisfall zur Erweiterung", richtig: false },
            { text: "Von der Erweiterung zum Basisfall", richtig: true },
            { text: "Vom Akteur zur Erweiterung", richtig: false },
            { text: "Die Richtung ist bei extend beliebig.", richtig: false },
          ]}
          erklaerung="Die Erweiterung kennt ihren Basisfall und klinkt sich unter einer Bedingung ein, der Basisfall weiß nichts von ihr. Darum zeigt der Pfeil zum Basisfall."
        />

        <QuizFrage
          nr={3}
          von={5}
          frage="Ein Onlineshop fragt Lieferzeiten automatisch beim System eines Paketdienstes ab. Wie stellst du den Paketdienst dar?"
          optionen={[
            { text: "Als Anwendungsfall innerhalb der Systemgrenze", richtig: false },
            { text: "Gar nicht, Systeme sind nie Akteure.", richtig: false },
            { text: "Als Akteur außerhalb der Systemgrenze", richtig: true },
            { text: "Als zweite Systemgrenze um den Shop herum", richtig: false },
          ]}
          erklaerung="Ein fremdes System, mit dem dein System Daten austauscht, ist ein Akteur. Es steht außerhalb der Systemgrenze, als Strichmännchen oder als Rechteck mit «actor»."
        />

        <QuizFrage
          nr={4}
          von={5}
          frage="Welcher Name ist als Anwendungsfall am besten geeignet?"
          optionen={[
            { text: "Auf „Bestellen“ klicken", richtig: false },
            { text: "Bestellung aufgeben", richtig: true },
            { text: "Datenbank aktualisieren", richtig: false },
            { text: "Bestellformular", richtig: false },
          ]}
          erklaerung="Ein Anwendungsfall ist ein Ziel mit Nutzen für den Akteur, benannt mit Objekt und Verb im Infinitiv (Lastenrad buchen). Ein Klick ist ein Ablaufschritt, das Aktualisieren der Datenbank ein interner Vorgang und „Bestellformular“ nur ein Substantiv."
        />

        <QuizFrage
          nr={5}
          von={5}
          frage="Zwischen den Akteuren Administrator und Benutzer steht eine Linie mit hohlem Dreieck am Benutzer. Was bedeutet das?"
          optionen={[
            { text: "Der Benutzer darf alles, was der Administrator darf.", richtig: false },
            { text: "Der Administrator ist ein spezieller Benutzer und darf alle Anwendungsfälle des Benutzers.", richtig: true },
            { text: "Der Administrator ruft den Benutzer auf.", richtig: false },
            { text: "Beide Akteure sind dieselbe Person.", richtig: false },
          ]}
          erklaerung="Das Dreieck zeigt auf den allgemeineren Akteur. Der Administrator erbt damit alle Anwendungsfälle des Benutzers und kann eigene zusätzliche haben."
        />
      </LsAbschnitt>
    </LektionLayout>
  );
}
