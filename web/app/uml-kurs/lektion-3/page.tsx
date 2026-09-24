import type { Metadata } from "next";
import { LsAbschnitt, LsHinweis } from "../../lernen/_components/LsBausteine";
import QuizFrage from "../../lernen/_components/QuizFrage";
import LektionLayout from "../../components/kurs/LektionLayout";
import { Zeichenaufgabe } from "../../components/kurs/KursBausteine";
import {
  BibliothekLoesung,
  KlassenAufbau,
  LastenradDiagramm,
  LinienMuster,
  TierarztLoesung,
  type KantenArt,
} from "../_components/UmlDiagramme";
import { umlKurs } from "../_components/lektionen";

export const metadata: Metadata = {
  title: "UML Lektion 3: Klassendiagramm mit Attributen, Methoden und Multiplizitäten",
  description:
    "Klassendiagramme für die IHK-Prüfung: Attribute und Methoden mit Sichtbarkeit und Datentyp, Assoziationen, Multiplizitäten, Rollen und Navigierbarkeit. Mit Schritt-für-Schritt-Beispiel und zwei Zeichenaufgaben.",
  alternates: { canonical: "https://lernarena.app/uml-kurs/lektion-3" },
};

const sichtbarkeiten: { zeichen: string; name: string; bedeutung: string }[] = [
  { zeichen: "+", name: "public (öffentlich)", bedeutung: "Von überall zugreifbar. Typisch für Methoden." },
  { zeichen: "-", name: "private (privat)", bedeutung: "Nur innerhalb der eigenen Klasse. Typisch für Attribute." },
  { zeichen: "#", name: "protected (geschützt)", bedeutung: "In der Klasse und in ihren Unterklassen." },
  { zeichen: "~", name: "package (Paket)", bedeutung: "Innerhalb desselben Pakets. In Prüfungen selten." },
];

const multiplizitaeten: { notation: string; bedeutung: string; beispiel: string }[] = [
  { notation: "1", bedeutung: "genau eins", beispiel: "Jede Buchung hat genau einen Kunden." },
  { notation: "0..1", bedeutung: "keins oder eins", beispiel: "Ein Mitarbeiter hat höchstens einen Dienstwagen." },
  { notation: "*", bedeutung: "beliebig viele, auch keins (gleich 0..*)", beispiel: "Ein Kunde hat beliebig viele Buchungen." },
  { notation: "1..*", bedeutung: "mindestens eins", beispiel: "Eine Station hat mindestens ein Lastenrad." },
  { notation: "2..4", bedeutung: "fester Bereich", beispiel: "Ein Projektteam hat zwei bis vier Mitglieder." },
];

const linien: { art: KantenArt; name: string; bedeutung: string }[] = [
  { art: "assoziation", name: "Assoziation", bedeutung: "Klassen kennen sich. Navigierbarkeit nicht festgelegt." },
  { art: "gerichtet", name: "Gerichtete Assoziation", bedeutung: "Nur in Pfeilrichtung navigierbar." },
  { art: "aggregation", name: "Aggregation", bedeutung: "Teil und Ganzes, leere Raute am Ganzen. Teile existieren auch allein." },
  { art: "komposition", name: "Komposition", bedeutung: "Teil und Ganzes, gefüllte Raute am Ganzen. Teile leben und sterben mit dem Ganzen." },
  { art: "vererbung", name: "Vererbung (Generalisierung)", bedeutung: "Dreieck zeigt auf die Oberklasse. Lektion 4." },
];

export default function Lektion3() {
  return (
    <LektionLayout
      kurs={umlKurs}
      nr={3}
      lead="Das Klassendiagramm ist der häufigste UML-Typ in der Prüfung. Hier lernst du, eine Klasse vollständig aufzuschreiben, Beziehungen mit Multiplizitäten zu versehen und ein Diagramm aus einem Szenariotext abzuleiten."
      uebungen={2}
      aufgabenText="2 Zeichenaufgaben, 5 Quizfragen"
    >
      <LsAbschnitt id="klasse" titel="Aufbau einer Klasse">
        <p>
          Eine Klasse (class) ist der Bauplan für gleichartige Objekte: Jedes Lastenrad hat eine
          Nummer und ein Modell, jedes kann gebucht werden. Im Diagramm ist sie ein Rechteck mit drei
          Fächern, von oben nach unten: <strong>Name</strong>, <strong>Attribute</strong> (was ein
          Objekt speichert) und <strong>Methoden</strong> (was ein Objekt kann), in UML auch
          Operationen (operations) genannt.
        </p>

        <KlassenAufbau />

        <h3>Attribute</h3>
        <p>
          Ein Attribut schreibst du als <code>Sichtbarkeit name: Typ</code>, zum Beispiel{" "}
          <code>- radNr: int</code>. Der Name beginnt klein, zusammengesetzte Wörter schreibst du im
          camelCase (<code>preisProStunde</code>). Ohne Datentyp gibt es in der Prüfung meist keinen
          vollen Punkt.
        </p>
        <h3>Methoden</h3>
        <p>
          Eine Methode schreibst du als <code className="uml-lang">Sichtbarkeit name(parameter: Typ): Rückgabetyp</code>,
          zum Beispiel <code className="uml-lang">+ berechnePreis(stunden: int): double</code>. Mehrere Parameter trennst du
          mit Komma. Gibt eine Methode nichts zurück, ist der Rückgabetyp <code>void</code>. Auch eine
          Methode ohne Parameter bekommt die leeren Klammern: <code>+ stornieren(): void</code>.
        </p>
        <h3>Sichtbarkeit</h3>
        <p>
          Das Zeichen vor jedem Attribut und jeder Methode legt fest, wer darauf zugreifen darf.
          Faustregel für die Prüfung: Attribute privat, Methoden öffentlich (Datenkapselung).
        </p>
        <div className="ls-table-wrap">
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Zeichen</th>
                <th scope="col">Sichtbarkeit</th>
                <th scope="col">Zugriff</th>
              </tr>
            </thead>
            <tbody>
              {sichtbarkeiten.map((s) => (
                <tr key={s.zeichen}>
                  <td>{s.zeichen}</td>
                  <td className="txt">{s.name}</td>
                  <td className="txt">{s.bedeutung}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        <LsHinweis titel="Welche Datentypen?">
          <p>
            UML selbst kennt nur wenige Grundtypen wie Integer, Real, Boolean und String. In
            IHK-Aufgaben sind die Typen aus Java oder C# üblich: <code>int</code>,{" "}
            <code>double</code>, <code>boolean</code>, <code>String</code>, dazu <code>Date</code>{" "}
            oder <code>DateTime</code>. Entscheidend ist, dass du einheitlich bleibst. Statische
            Attribute und Methoden (static), die zur Klasse statt zum Objekt gehören, werden
            unterstrichen.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="beziehungen" titel="Assoziationen und Multiplizitäten">
        <p>
          Eine Assoziation (association) ist eine durchgezogene Linie zwischen zwei Klassen und sagt:
          Objekte dieser Klassen kennen sich. Ein Kunde kennt seine Buchungen, eine Buchung kennt
          ihren Kunden. Erst die Beschriftung an den Linienenden macht daraus eine präzise Aussage.
        </p>
        <h3>Multiplizitäten</h3>
        <p>
          Die Multiplizität (multiplicity) gibt an, wie viele Objekte an einer Beziehung beteiligt
          sind. Die wichtigste Regel: <strong>Sie steht an der Klasse, deren Anzahl sie
          beschreibt.</strong> Du liest sie also von der gegenüberliegenden Klasse aus.
        </p>
        <LastenradDiagramm caption="Das fertige Klassendiagramm aus dem Beispiel unten. Die Multiplizitäten stehen in Akzentfarbe." />
        <p>
          Die Linie zwischen Kunde und Buchung liest du in beide Richtungen: „Ein Kunde legt{" "}
          <strong>0..*</strong> Buchungen an“, darum steht 0..* an Buchung. „Eine Buchung gehört zu{" "}
          <strong>1</strong> Kunden“, darum steht 1 an Kunde.
        </p>
        <div className="ls-table-wrap">
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Notation</th>
                <th scope="col">Bedeutung</th>
                <th scope="col">Beispiel</th>
              </tr>
            </thead>
            <tbody>
              {multiplizitaeten.map((m) => (
                <tr key={m.notation}>
                  <td>{m.notation}</td>
                  <td className="txt">{m.bedeutung}</td>
                  <td className="txt">{m.beispiel}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        <h3>Assoziationsname und Rollen</h3>
        <p>
          In der Mitte der Linie darf ein <strong>Assoziationsname</strong> stehen, meist ein Verb
          wie „legt an“. Er macht das Diagramm lesbarer, ist aber optional. Ein{" "}
          <strong>Rollenname</strong> (role) steht dagegen an einem Linienende und sagt, welche Rolle
          die Klasse dort spielt. Im Diagramm oben ist das Lastenrad für die Buchung das{" "}
          <em>rad</em>. Im Code wird aus dem Rollennamen später ein Attribut:{" "}
          <code>- rad: Lastenrad</code> in der Klasse Buchung.
        </p>
        <h3>Navigierbarkeit</h3>
        <p>
          Eine offene Pfeilspitze am Linienende bedeutet: Von der anderen Seite aus kommt man hierhin.
          Im Beispiel kennt die Buchung ihr Lastenrad, das Lastenrad muss seine Buchungen aber nicht
          kennen. Ohne Pfeilspitze ist die Navigierbarkeit offen; in Prüfungen wird eine solche
          Linie meist als „beide kennen sich“ gelesen. Zeichne Pfeile nur, wenn die Aufgabe eine
          Richtung verlangt oder sie eindeutig aus dem Text folgt.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="teil-ganzes" titel="Aggregation und Komposition in Kürze">
        <p>
          Zwei Sonderformen der Assoziation beschreiben eine Teil-Ganzes-Beziehung. Die Raute sitzt
          dabei immer am <strong>Ganzen</strong>:
        </p>
        <ul>
          <li>
            <strong>Aggregation</strong> (leere Raute): Die Teile gehören zum Ganzen, können aber
            auch ohne es existieren. Ein Team besteht aus Mitarbeitern; löst sich das Team auf, gibt
            es die Mitarbeiter weiterhin.
          </li>
          <li>
            <strong>Komposition</strong> (gefüllte Raute): Die Teile existieren nur mit dem Ganzen
            und gehören zu genau einem Ganzen. Wird ein Gebäude abgerissen, sind auch seine Räume
            weg. Am Ganzen steht deshalb die Multiplizität 1 (oder 0..1).
          </li>
        </ul>
        <p>
          Im Lastenrad-Beispiel ist die Beziehung zwischen Station und Lastenrad bewusst eine
          einfache Assoziation: Schließt eine Station, gibt es die Räder weiterhin. Alle Linienarten
          auf einen Blick, vertieft werden Komposition und Vererbung in Lektion 4:
        </p>
        <div className="ls-table-wrap">
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Linie</th>
                <th scope="col">Name</th>
                <th scope="col">Bedeutung</th>
              </tr>
            </thead>
            <tbody>
              {linien.map((l) => (
                <tr key={l.art}>
                  <td className="uml-muster-zelle">
                    <LinienMuster art={l.art} label={`Linienart ${l.name}`} />
                  </td>
                  <td className="txt">
                    <strong>{l.name}</strong>
                  </td>
                  <td className="txt">{l.bedeutung}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </LsAbschnitt>

      <LsAbschnitt id="beispiel" titel="Beispiel Schritt für Schritt: Lastenräder">
        <p>
          So sieht eine typische Prüfungsaufgabe aus. Lies den Text einmal ganz, dann gehst du in
          drei Schritten vor.
        </p>
        <div className="uml-szenario">
          <span className="uml-szenario-titel">Ausgangssituation</span>
          <p>
            Die Stadtwerke Mittelstadt planen eine Buchungsplattform für Lastenräder.{" "}
            <mark>Kunden</mark> registrieren sich mit <mark>Name</mark> und{" "}
            <mark>E-Mail-Adresse</mark> und erhalten eine <mark>Kundennummer</mark>; die E-Mail-Adresse
            soll sich später ändern lassen. Jedes <mark>Lastenrad</mark> hat eine{" "}
            <mark>Radnummer</mark>, ein <mark>Modell</mark> und einen <mark>Preis pro Stunde</mark>,
            und es soll abfragbar sein, ob es gerade verfügbar ist. Jedes Lastenrad gehört fest zu
            einer <mark>Station</mark>; eine Station hat eine <mark>Bezeichnung</mark>, eine{" "}
            <mark>Adresse</mark> und mindestens ein Lastenrad. Ein Kunde kann beliebig viele{" "}
            <mark>Buchungen</mark> anlegen. Eine Buchung gilt für genau ein Lastenrad und speichert{" "}
            <mark>Beginn</mark>, <mark>Ende</mark> und <mark>Status</mark>. Die Plattform soll den
            Preis einer Buchung berechnen und Buchungen stornieren können.
          </p>
          <p>
            <strong>Aufgabe:</strong> Erstellen Sie ein Klassendiagramm mit Attributen, Datentypen,
            Methoden, Beziehungen und Multiplizitäten.
          </p>
        </div>

        <h3>Schritt 1: Klassen finden</h3>
        <p>
          Markiere alle Substantive (oben schon erledigt). Klassen sind die Substantive, die{" "}
          <strong>eigene Daten haben und mehrfach vorkommen</strong>: Kunde, Lastenrad, Station,
          Buchung. Die übrigen Substantive sortierst du aus: Name, Radnummer oder Adresse sind
          Eigenschaften, also Attribute. „Plattform“ ist das System selbst und „Stadtwerke“ der
          Auftraggeber; beide werden keine Klasse. Klassennamen schreibst du im Singular und groß.
        </p>
        <LastenradDiagramm stufe="klassen" caption="Schritt 1: die vier Klassen" />

        <h3>Schritt 2: Attribute und Methoden zuordnen</h3>
        <p>
          Jedes aussortierte Substantiv wandert als Attribut in seine Klasse, mit Sichtbarkeit und
          Datentyp. Aus den Verben, die eine Fähigkeit beschreiben, werden Methoden: E-Mail ändern,
          Verfügbarkeit abfragen, Preis berechnen, stornieren. Die Methode kommt in die Klasse, deren
          Daten sie braucht, <code>berechnePreis()</code> also in die Buchung, weil dort Beginn und
          Ende liegen.
        </p>
        <LastenradDiagramm stufe="attribute" caption="Schritt 2: Attribute und Methoden, noch ohne Beziehungen" />
        <p>
          Zwei Details: Die Station hat im Text keine Methode, ihr Methodenfach bleibt leer. Und der
          Status ist hier ein <code>String</code>. Für feste Werte wie offen, aktiv und storniert wäre
          auch eine Aufzählung (enumeration) üblich; in der Prüfung ist ein String als einfache Lösung
          vertretbar.
        </p>

        <h3>Schritt 3: Beziehungen und Multiplizitäten</h3>
        <p>
          Jetzt suchst du die Sätze, die zwei Klassen verbinden, und formulierst jede Beziehung in
          beide Richtungen:
        </p>
        <ul>
          <li>
            Ein Kunde legt beliebig viele Buchungen an, eine Buchung gehört zu genau einem Kunden:{" "}
            <code>1</code> an Kunde, <code>0..*</code> an Buchung.
          </li>
          <li>
            Eine Buchung gilt für genau ein Lastenrad, ein Lastenrad kann beliebig oft gebucht
            werden: <code>1</code> an Lastenrad, <code>0..*</code> an Buchung. Die Buchung muss ihr
            Rad kennen, daher die Pfeilspitze und die Rolle <em>rad</em>.
          </li>
          <li>
            Eine Station hat mindestens ein Lastenrad, jedes Lastenrad gehört fest zu einer Station:{" "}
            <code>1..*</code> an Lastenrad, <code>1</code> an Station.
          </li>
        </ul>
        <LastenradDiagramm caption="Schritt 3: das fertige Klassendiagramm" />
        <LsHinweis titel="Die Probe mit Lesesätzen">
          <p>
            Lies zum Schluss jede Linie laut in beide Richtungen: „Ein … hat … viele …“. Klingt ein
            Satz falsch, ist meist die Multiplizität am falschen Ende gelandet. Diese Probe kostet
            eine Minute und rettet in der Prüfung oft zwei Punkte.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="uebungen" titel="Zeichenaufgaben">
        <p>Zeichne erst selbst, dann klapp die Musterlösung auf und vergleiche Punkt für Punkt.</p>

        <Zeichenaufgabe
          nr="3.1"
          loesung={<BibliothekLoesung />}
          erklaerung={
            <p>
              Die Ausleihe ist eine eigene Klasse, weil sie eigene Daten hat (Ausleih- und
              Rückgabedatum). Leser und Medium hängen deshalb nicht direkt zusammen, sondern über die
              Ausleihe. Die Unterscheidung in Buch, DVD und Zeitschrift ist hier nicht gefordert; sie
              wäre ein Fall für Vererbung (Lektion 4).
            </p>
          }
          bewertung={[
            "3 Punkte: je 1 Punkt für die Klassen Leser, Medium und Ausleihe.",
            "3 Punkte: Attribute vollständig mit Sichtbarkeit und Datentyp, je Klasse 1 Punkt.",
            "1 Punkt: verlaengern(tage: int): void in der Klasse Ausleihe.",
            "1 Punkt: beide Assoziationen zwischen den richtigen Klassen.",
            "2 Punkte: Multiplizitäten, je Beziehung 1 Punkt, nur wenn beide Enden stimmen.",
          ]}
        >
          <div className="uml-szenario">
            <span className="uml-szenario-titel">Stadtbibliothek, 10 Punkte</span>
            <p>
              Die Stadtbibliothek möchte ihre Ausleihe digital verwalten. Leser haben eine
              Lesernummer, einen Namen und ein Geburtsdatum. Jedes Medium hat eine Mediennummer, einen
              Titel und ein Erscheinungsjahr. Bei jeder Ausleihe werden das Ausleihdatum und das
              Rückgabedatum gespeichert. Eine Ausleihe betrifft genau einen Leser und genau ein
              Medium. Ein Leser kann beliebig viele Ausleihen haben, ein Medium wird im Laufe der Zeit
              beliebig oft ausgeliehen. Eine Ausleihe kann um eine Anzahl von Tagen verlängert werden.
            </p>
            <p>
              <strong>Aufgabe:</strong> Modellieren Sie die Klassen Leser, Medium und Ausleihe mit
              Attributen, Datentypen und der Methode zum Verlängern. Tragen Sie die Beziehungen mit
              Multiplizitäten ein.
            </p>
          </div>
        </Zeichenaufgabe>

        <Zeichenaufgabe
          nr="3.2"
          loesung={<TierarztLoesung />}
          erklaerung={
            <p>
              <code>1..*</code> steht am Tier, weil ein Tierhalter mindestens ein Tier hat. Der
              Rollenname <em>besitzer</em> steht am Tierhalter, denn er beschreibt die Rolle, die der
              Tierhalter für das Tier spielt. Chipnummer und Telefonnummer sind Strings: Man rechnet
              nicht mit ihnen, und führende Nullen oder ein Pluszeichen müssen erhalten bleiben. Das
              Alter ist kein Attribut, sondern wird mit <code>berechneAlter()</code> aus dem
              Geburtsdatum berechnet.
            </p>
          }
          bewertung={[
            "3 Punkte: je 1 Punkt für die Klassen Tierhalter, Tier und Termin.",
            "3 Punkte: Attribute mit Sichtbarkeit und passendem Datentyp, chipNr und telefon als String.",
            "2 Punkte: berechneAlter(): int in Tier und absagen(): void in Termin.",
            "2 Punkte: Multiplizitäten 1 zu 1..* und 1 zu 0..*, jeweils am richtigen Ende.",
            "1 Punkt: Rollenname besitzer am Ende der Klasse Tierhalter.",
          ]}
        >
          <div className="uml-szenario">
            <span className="uml-szenario-titel">Tierarztpraxis, 11 Punkte</span>
            <p>
              Eine Tierarztpraxis verwaltet ihre Patienten. Tierhalter werden mit Kundennummer, Name
              und Telefonnummer erfasst, und zwar erst, wenn sie mindestens ein Tier anmelden. Jedes
              Tier hat eine Chipnummer, einen Namen, eine Tierart und ein Geburtsdatum und gehört genau
              einem Tierhalter. Für ein Tier können beliebig viele Termine vereinbart werden; jeder
              Termin gilt für genau ein Tier und hat einen Beginn, eine Dauer in Minuten und einen
              Grund. Termine können abgesagt werden. Aus dem Geburtsdatum soll das Alter eines Tieres
              berechnet werden.
            </p>
            <p>
              <strong>Aufgabe:</strong> Erstellen Sie ein Klassendiagramm mit Attributen, Datentypen,
              Methoden und Multiplizitäten. Vergeben Sie für die Beziehung zwischen Tier und
              Tierhalter am Tierhalter den Rollennamen besitzer.
            </p>
          </div>
        </Zeichenaufgabe>
      </LsAbschnitt>

      <LsAbschnitt id="fehler" titel="Typische Fehler">
        <LsHinweis art="warnung" titel="Darauf achten die Prüfer">
          <ul>
            <li>
              Multiplizität am falschen Ende: „Ein Kunde hat viele Buchungen“ gehört als{" "}
              <code>*</code> an die Buchung, nicht an den Kunden.
            </li>
            <li>
              Datentypen oder Sichtbarkeiten fehlen. <code>radNr</code> allein ist kein vollständiges
              Attribut, <code>- radNr: int</code> schon.
            </li>
            <li>
              Klassen im Plural (Kunden statt Kunde) oder Attribute als eigene Klasse (eine Klasse
              Adresse, obwohl die Adresse nur ein Text ist).
            </li>
            <li>
              Raute am falschen Ende: Sie sitzt immer am Ganzen, nie am Teil.
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
          frage="Zwischen Kunde und Bestellung steht an Kunde eine 1 und an Bestellung ein *. Was bedeutet das?"
          optionen={[
            { text: "Jeder Kunde hat genau eine Bestellung, eine Bestellung kann mehrere Kunden haben.", richtig: false },
            { text: "Ein Kunde hat beliebig viele Bestellungen, auch keine; jede Bestellung gehört zu genau einem Kunden.", richtig: true },
            { text: "Ein Kunde hat mindestens eine Bestellung.", richtig: false },
            { text: "Kunden und Bestellungen stehen im Verhältnis n zu m.", richtig: false },
          ]}
          erklaerung="Die Multiplizität steht an der Klasse, deren Anzahl sie beschreibt: * an Bestellung heißt, ein Kunde hat beliebig viele (0..*) Bestellungen. Die 1 an Kunde heißt, jede Bestellung gehört zu genau einem Kunden."
        />

        <QuizFrage
          nr={2}
          von={5}
          frage="„Jede Station hat mindestens ein Lastenrad.“ An welches Linienende schreibst du 1..*?"
          optionen={[
            { text: "An die Klasse Station", richtig: false },
            { text: "An die Klasse Lastenrad", richtig: true },
            { text: "In die Mitte der Linie", richtig: false },
            { text: "An beide Enden", richtig: false },
          ]}
          erklaerung="1..* beschreibt die Anzahl der Lastenräder pro Station, also steht es an Lastenrad. Von der Station aus gelesen: Eine Station hat 1..* Lastenräder."
        />

        <QuizFrage
          nr={3}
          von={5}
          frage="Was bedeutet das Zeichen # vor einem Attribut?"
          optionen={[
            { text: "Das Attribut ist öffentlich.", richtig: false },
            { text: "Das Attribut ist ein Primärschlüssel.", richtig: false },
            { text: "Das Attribut ist geschützt (protected): sichtbar in der Klasse und ihren Unterklassen.", richtig: true },
            { text: "Das Attribut ist statisch.", richtig: false },
          ]}
          erklaerung="# steht für protected. Öffentlich ist +, privat ist -. Statische Elemente werden in UML unterstrichen, nicht mit einem Zeichen markiert."
        />

        <QuizFrage
          nr={4}
          von={5}
          frage="Welche Methode ist nach UML korrekt notiert?"
          optionen={[
            { text: "+ double berechnePreis(int stunden)", richtig: false },
            { text: "+ berechnePreis(stunden: int): double", richtig: true },
            { text: "berechnePreis: double (stunden)", richtig: false },
            { text: "+ berechnePreis(stunden): double int", richtig: false },
          ]}
          erklaerung="In UML stehen Typen hinter dem Namen, getrennt durch einen Doppelpunkt: Sichtbarkeit name(parameter: Typ): Rückgabetyp. Die erste Variante ist Java-Schreibweise, kein UML."
        />

        <QuizFrage
          nr={5}
          von={5}
          frage="Ein Raum gehört zu genau einem Gebäude und wird mit dem Gebäude abgerissen. Wie modellierst du das?"
          optionen={[
            { text: "Aggregation mit leerer Raute am Raum", richtig: false },
            { text: "Komposition mit gefüllter Raute am Gebäude", richtig: true },
            { text: "Komposition mit gefüllter Raute am Raum", richtig: false },
            { text: "Vererbung, Raum erbt von Gebäude", richtig: false },
          ]}
          erklaerung="Der Raum existiert nur mit dem Gebäude, das ist eine Komposition. Die gefüllte Raute sitzt immer am Ganzen, hier also am Gebäude."
        />
      </LsAbschnitt>
    </LektionLayout>
  );
}
