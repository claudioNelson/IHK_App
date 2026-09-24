import type { Metadata } from "next";
import Link from "next/link";
import { LsAbschnitt, LsHinweis } from "../../lernen/_components/LsBausteine";
import QuizFrage from "../../lernen/_components/QuizFrage";
import LektionLayout from "../../components/kurs/LektionLayout";
import { CodeBlock, Zeichenaufgabe } from "../../components/kurs/KursBausteine";
import {
  L4Assoziationsklasse,
  L4FahrzeugLoesung,
  L4MedienVererbung,
  L4RechnungLoesung,
  L4TeilGanzes,
} from "../_components/UmlDiagramme";
import { umlKurs } from "../_components/lektionen";

export const metadata: Metadata = {
  title: "UML Lektion 4: Vererbung, Komposition und der Weg zum Code",
  description:
    "Klassendiagramme für die IHK-Prüfung, Teil 2: Vererbung, abstrakte Klassen, Interfaces, Aggregation und Komposition, Assoziationsklassen und die Übersetzung in Python und Java. Mit zwei Zeichenaufgaben.",
  alternates: { canonical: "https://lernarena.app/uml-kurs/lektion-4" },
};

const uebersetzung: { uml: string; python: string; java: string }[] = [
  { uml: "Vererbung, Dreieck zur Oberklasse", python: "class Buch(Medium):", java: "class Buch extends Medium" },
  { uml: "abstrakte Klasse, {abstract}", python: "class Medium(ABC): mit @abstractmethod", java: "abstract class Medium" },
  { uml: "Interface, «interface»", python: "ABC mit nur abstrakten Methoden", java: "interface Verlaengerbar" },
  { uml: "Realisierung, gestrichelt", python: "class Buch(Medium, Verlaengerbar):", java: "implements Verlaengerbar" },
  { uml: "- privat / # geschützt / + öffentlich", python: "__name / _name / name (Konvention)", java: "private / protected / public" },
  { uml: "Multiplizität 1 oder 0..1", python: "einfaches Attribut, ggf. None", java: "einfache Referenz, ggf. null" },
  { uml: "Multiplizität 0..* oder 1..*", python: "list[Bestellposition]", java: "List<Bestellposition>" },
];

const pythonVererbung = `from abc import ABC, abstractmethod

class Verlaengerbar(ABC):              # «interface»: nur abstrakte Methoden
    @abstractmethod
    def verlaengern(self, tage: int) -> None: ...

class Medium(ABC):                     # {abstract}: davon gibt es keine Objekte
    def __init__(self, medien_nr: int, titel: str):
        self._medien_nr = medien_nr    # # geschützt: ein Unterstrich
        self._titel = titel

    @abstractmethod
    def berechne_leihfrist(self) -> int: ...

class Buch(Medium, Verlaengerbar):     # erbt von Medium, realisiert Verlaengerbar
    def __init__(self, medien_nr: int, titel: str, isbn: str, seiten: int):
        super().__init__(medien_nr, titel)
        self.__isbn = isbn             # - privat: zwei Unterstriche
        self.__seiten = seiten

    def berechne_leihfrist(self) -> int:
        return 28

    def verlaengern(self, tage: int) -> None:
        print(f"{self._titel}: {tage} Tage verlängert")

class DVD(Medium):
    def __init__(self, medien_nr: int, titel: str, laufzeit_min: int, fsk: int):
        super().__init__(medien_nr, titel)
        self.__laufzeit_min = laufzeit_min
        self.__fsk = fsk

    def berechne_leihfrist(self) -> int:
        return 7`;

const javaVererbung = `public interface Verlaengerbar {
    void verlaengern(int tage);
}

public abstract class Medium {
    protected int medienNr;
    protected String titel;

    public Medium(int medienNr, String titel) {
        this.medienNr = medienNr;
        this.titel = titel;
    }

    public abstract int berechneLeihfrist();
}

public class Buch extends Medium implements Verlaengerbar {
    private String isbn;
    private int seiten;

    public Buch(int medienNr, String titel, String isbn, int seiten) {
        super(medienNr, titel);
        this.isbn = isbn;
        this.seiten = seiten;
    }

    @Override
    public int berechneLeihfrist() {
        return 28;
    }

    @Override
    public void verlaengern(int tage) {
        // Rückgabedatum um tage verschieben
    }
}`;

const pythonKomposition = `class Bestellposition:
    def __init__(self, menge: int, einzelpreis: float):
        self.__menge = menge
        self.__einzelpreis = einzelpreis

    def berechne_betrag(self) -> float:
        return self.__menge * self.__einzelpreis

class Bestellung:
    def __init__(self, bestell_nr: int):
        self.__bestell_nr = bestell_nr
        self.__positionen: list[Bestellposition] = []   # 1..* Teile

    def neue_position(self, menge: int, einzelpreis: float) -> None:
        # Komposition: das Ganze erzeugt seine Teile selbst
        self.__positionen.append(Bestellposition(menge, einzelpreis))

    def berechne_summe(self) -> float:
        return sum(p.berechne_betrag() for p in self.__positionen)

class Mitarbeiter:
    def __init__(self, personal_nr: int, name: str):
        self.__personal_nr = personal_nr
        self.__name = name

class Team:
    def __init__(self, name: str):
        self.__name = name
        self.__mitglieder: list[Mitarbeiter] = []

    def aufnehmen(self, m: Mitarbeiter) -> None:
        # Aggregation: der Mitarbeiter existiert schon, er wird nur verknüpft
        self.__mitglieder.append(m)`;

const javaKomposition = `public class Bestellung {
    private int bestellNr;
    private List<Bestellposition> positionen = new ArrayList<>();

    public void neuePosition(int menge, double einzelpreis) {
        // Komposition: das Ganze erzeugt seine Teile selbst
        positionen.add(new Bestellposition(menge, einzelpreis));
    }
}

public class Team {
    private String name;
    private List<Mitarbeiter> mitglieder = new ArrayList<>();

    public void aufnehmen(Mitarbeiter m) {
        // Aggregation: das Teil kommt fertig von außen
        mitglieder.add(m);
    }
}`;

export default function Lektion4() {
  return (
    <LektionLayout
      kurs={umlKurs}
      nr={4}
      lead="In Lektion 3 hast du Klassen und Assoziationen gezeichnet. Jetzt kommen die Beziehungen, an denen in der Prüfung die meisten Punkte hängen: Vererbung, abstrakte Klassen, Interfaces, Aggregation und Komposition. Zum Schluss übersetzt du ein Diagramm in Python und Java."
      uebungen={2}
      aufgabenText="2 Zeichenaufgaben, 5 Quizfragen"
    >
      <LsAbschnitt id="vererbung" titel="Vererbung">
        <p>
          Vererbung heißt in UML Generalisierung (generalization). Eine Unterklasse übernimmt alle
          Attribute und Methoden ihrer Oberklasse und ergänzt eigene. Du prüfst sie mit dem Satz{" "}
          <strong>„ist ein“</strong>: Ein Buch ist ein Medium, eine DVD ist ein Medium. Passt der Satz
          nicht, etwa „eine Ausleihe ist ein Leser“, ist es keine Vererbung.
        </p>
        <p>
          Gezeichnet wird eine durchgezogene Linie mit <strong>hohlem Dreieck an der
          Oberklasse</strong>. Mehrere Unterklassen dürfen ihre Linien zu einem gemeinsamen Dreieck
          zusammenführen, das macht das Diagramm ruhiger. In der Unterklasse stehen{" "}
          <strong>nur die neuen Attribute</strong>; geerbte schreibst du nicht noch einmal hin.
          Überschreibt die Unterklasse eine Methode, führst du diese Methode dort erneut auf.
        </p>
        <L4MedienVererbung caption="Medium ist abstrakt, Buch und DVD erben davon. Buch realisiert zusätzlich das Interface Verlaengerbar." />
        <p>
          Die Attribute von Medium sind hier geschützt (<code>#</code>), damit Buch und DVD direkt
          darauf zugreifen können. Private Attribute werden zwar auch vererbt, sind in der
          Unterklasse aber nur über Methoden der Oberklasse erreichbar. Beides ist in der Prüfung
          richtig, solange du es einheitlich machst.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="abstrakt" titel="Abstrakte Klassen und Interfaces">
        <h3>Abstrakte Klasse</h3>
        <p>
          Eine abstrakte Klasse (abstract class) ist ein Bauplan, von dem es selbst keine Objekte
          gibt. In der Bibliothek steht nie „ein Medium“ im Regal, sondern immer ein Buch oder eine
          DVD. Du kennzeichnest sie mit einem <strong>kursiven Namen</strong> oder mit{" "}
          <code>{"{abstract}"}</code> unter dem Namen. Weil Kursivschrift von Hand kaum erkennbar
          ist, schreibst du in der Prüfung auf Papier besser <code>{"{abstract}"}</code>.
        </p>
        <p>
          Eine abstrakte Klasse darf <strong>abstrakte Methoden</strong> haben: Die Signatur steht
          fest, der Inhalt fehlt. Jede Unterklasse, von der es Objekte geben soll, muss sie
          implementieren. Im Beispiel berechnet jede Medienart ihre Leihfrist anders, darum ist{" "}
          <code>berechneLeihfrist()</code> in Medium abstrakt und kursiv gesetzt; von Hand hängst du
          auch hier <code>{"{abstract}"}</code> an.
        </p>
        <h3>Interface</h3>
        <p>
          Ein Interface (Schnittstelle) ist ein reiner Vertrag: eine Liste von Methoden, die eine
          Klasse anbieten muss, ohne eigene Attribute und ohne Umsetzung. Es trägt das Stereotyp{" "}
          <strong>«interface»</strong> über dem Namen. Die Beziehung zur umsetzenden Klasse heißt
          Realisierung (realization): eine <strong>gestrichelte Linie mit hohlem Dreieck am
          Interface</strong>. Im Beispiel lassen sich nur Bücher verlängern, DVDs nicht; deshalb
          realisiert nur Buch das Interface Verlaengerbar.
        </p>
        <LsHinweis titel="Abstrakte Klasse oder Interface?">
          <p>
            Die abstrakte Klasse beantwortet „Was ist es?“ und bringt gemeinsame Attribute mit. Das
            Interface beantwortet „Was kann es?“ und passt auch zu Klassen, die sonst nichts
            miteinander zu tun haben. In Java und C# erbt eine Klasse von höchstens einer
            Oberklasse, kann aber beliebig viele Interfaces realisieren. Diese Regel wird in
            Prüfungen gern als Begründungsfrage gestellt.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="teil-ganzes" titel="Aggregation und Komposition">
        <p>
          Beide sind Sonderformen der Assoziation für Teil-Ganzes-Beziehungen („hat ein“, „besteht
          aus“). Die Raute sitzt immer am <strong>Ganzen</strong>. Der Unterschied liegt in der{" "}
          <strong>Existenzabhängigkeit</strong>: Was passiert mit den Teilen, wenn das Ganze gelöscht
          wird?
        </p>
        <L4TeilGanzes caption="Links Komposition mit gefüllter Raute, rechts Aggregation mit hohler Raute." />
        <ul>
          <li>
            <strong>Komposition</strong> (composition, gefüllte Raute): Eine Bestellposition
            existiert nur als Teil ihrer Bestellung. Wird die Bestellung gelöscht, sind ihre
            Positionen ebenfalls weg; allein ergeben sie keinen Sinn. Ein Teil gehört zu genau einem
            Ganzen, darum steht am Ganzen <code>1</code> (höchstens <code>0..1</code>).
          </li>
          <li>
            <strong>Aggregation</strong> (aggregation, hohle Raute): Ein Team besteht aus
            Mitarbeitern, aber löst sich das Team auf, arbeiten die Mitarbeiter weiter in der
            Firma. Ein Mitarbeiter kann zudem in mehreren Teams sein, am Ganzen darf also{" "}
            <code>0..*</code> stehen.
          </li>
        </ul>
        <p>
          Die Frage aus der Aufgabe lautet also: <strong>Überlebt das Teil das Ganze?</strong> Nein:
          Komposition. Ja: Aggregation. Achte auf Formulierungen wie „wird mit … gelöscht“, „existiert
          nur als Teil von …“ oder „kann auch ohne … bestehen“.
        </p>
        <LsHinweis titel="Prüfungsbezug" icon="buch" label="Prüfungsbezug">
          <p>
            „Begründen Sie, ob es sich um eine Aggregation oder eine Komposition handelt“ ist eine
            der häufigsten Kurzfragen zum Klassendiagramm. Die volle Punktzahl gibt es nur, wenn du
            die Existenzabhängigkeit am konkreten Beispiel nennst, also etwa „Eine Rechnungsposition
            kann ohne ihre Rechnung nicht existieren und wird mit ihr gelöscht“. Die bloße Aussage
            „gefüllte Raute“ reicht nicht.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="assoziationsklasse" titel="Assoziationsklasse in Kürze">
        <p>
          Manchmal hat eine Beziehung selbst Daten. Leser und Medium sind verbunden, aber Ausleih-
          und Rückgabedatum gehören weder zum Leser noch zum Medium, sondern zur Verbindung. Dafür
          gibt es die Assoziationsklasse (association class): eine normale Klasse, die über eine{" "}
          <strong>gestrichelte Linie an der Mitte der Assoziation</strong> hängt.
        </p>
        <L4Assoziationsklasse />
        <p>
          Eine Feinheit: Eine Assoziationsklasse erlaubt standardmäßig nur{" "}
          <strong>eine Verbindung pro Paar</strong>. Ein Leser könnte dasselbe Medium also nicht
          zweimal ausleihen. Deshalb war die Ausleihe in Lektion 3 eine eigene Klasse mit zwei
          Assoziationen; das ist die sichere Lösung, wenn eine Verbindung sich wiederholen kann.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="code" titel="Vom Diagramm zum Code">
        <p>
          Viele Prüfungsaufgaben verlangen den Weg in eine Richtung: „Implementieren Sie die Klasse …
          gemäß dem Klassendiagramm“ oder „Erstellen Sie zum folgenden Code ein Klassendiagramm“. Die
          Aufgaben zeigen meist Java- oder C#-ähnlichen Pseudocode, darum siehst du hier beide
          Fassungen. Die Python-Grundlagen dazu findest du in{" "}
          <Link href="/python-kurs/lektion-10">Lektion 10 des Python-Kurses</Link>.
        </p>
        <div className="ls-table-wrap">
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">UML</th>
                <th scope="col">Python</th>
                <th scope="col">Java</th>
              </tr>
            </thead>
            <tbody>
              {uebersetzung.map((u) => (
                <tr key={u.uml}>
                  <td className="txt">{u.uml}</td>
                  <td className="txt">
                    <code className="uml-lang">{u.python}</code>
                  </td>
                  <td className="txt">
                    <code className="uml-lang">{u.java}</code>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        <h3>Vererbung, abstrakte Klasse und Interface in Python</h3>
        <p>
          Python kennt kein Schlüsselwort für Interfaces. Abstrakte Klassen baust du mit dem Modul{" "}
          <code>abc</code>; eine Klasse, die nur abstrakte Methoden hat, spielt die Rolle des
          Interfaces. Methodennamen schreibt man in Python mit Unterstrichen (
          <code>berechne_leihfrist</code>), im Diagramm im camelCase. Beides ist in Ordnung.
        </p>
        <CodeBlock code={pythonVererbung} />

        <h3>Dasselbe in Java</h3>
        <p>
          Java trennt sauber: <code>extends</code> für die eine Oberklasse,{" "}
          <code>implements</code> für Interfaces. Die Sichtbarkeiten stehen als Schlüsselwort vor
          jedem Attribut, die Typen vor dem Namen, also genau umgekehrt wie in UML.
        </p>
        <CodeBlock code={javaVererbung} />

        <h3>Komposition und Aggregation im Code</h3>
        <p>
          Der Code zeigt den Unterschied oft daran, <strong>wer das Teil erzeugt</strong>. Bei der
          Komposition erzeugt das Ganze seine Teile selbst, niemand sonst hält eine Referenz darauf.
          Bei der Aggregation wird ein bereits vorhandenes Objekt von außen übergeben und nur
          verknüpft.
        </p>
        <CodeBlock code={pythonKomposition} />
        <CodeBlock code={javaKomposition} />
        <LsHinweis titel="Was die Multiplizität im Code bedeutet">
          <p>
            <code>*</code> und <code>1..*</code> werden zu einer Liste, <code>1</code> und{" "}
            <code>0..1</code> zu einem einfachen Attribut. Dass eine Bestellung mindestens eine
            Position hat, erzwingt die Liste allein nicht; das müsste der Konstruktor oder eine
            Prüfung vor dem Speichern sicherstellen. In der Prüfung reicht es meist, die Liste
            korrekt zu deklarieren.
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
          nr="4.1"
          loesung={<L4FahrzeugLoesung />}
          erklaerung={
            <p>
              Fahrzeug ist abstrakt, weil nie „ein Fahrzeug“ vermietet wird, und{" "}
              <code>berechneMiete()</code> ist abstrakt, weil jede Art anders rechnet. Pkw und
              Lastenrad führen die Methode erneut auf, weil sie sie überschreiben. Die Versicherung
              ist ein Interface und kein Attribut in Fahrzeug: Lastenräder brauchen sie nicht, und
              künftig sollen auch Anhänger versichert werden, die keine Fahrzeuge der Vermietung
              sind. Private statt geschützter Attribute in Fahrzeug sind ebenfalls richtig.
            </p>
          }
          bewertung={[
            "2 Punkte: Fahrzeug als abstrakte Klasse ({abstract} oder kursiv) mit kennung und tagespreis.",
            "1 Punkt: berechneMiete(tage: int): double als abstrakte Methode in Fahrzeug.",
            "2 Punkte: Pkw und Lastenrad mit ihren eigenen Attributen, ohne die geerbten zu wiederholen.",
            "2 Punkte: Vererbungspfeile mit hohlem Dreieck an Fahrzeug.",
            "2 Punkte: Interface Versicherbar mit «interface» und berechneBeitrag(): double.",
            "1 Punkt: Realisierung gestrichelt von Pkw zu Versicherbar, nicht von Fahrzeug.",
            "Richtwert gesamt: 10 Punkte.",
          ]}
        >
          <div className="uml-szenario">
            <span className="uml-szenario-titel">Fahrzeugverleih, Richtwert 10 Punkte</span>
            <p>
              Ein Fahrzeugverleih vermietet Pkw und Lastenräder. Jedes Fahrzeug hat eine Kennung und
              einen Tagespreis. Die Miete für eine Anzahl von Tagen wird für jede Fahrzeugart anders
              berechnet; ein allgemeines Fahrzeug ohne Art wird nie vermietet. Pkw haben zusätzlich
              ein Kennzeichen und eine Anzahl Sitzplätze, Lastenräder eine maximale Zuladung in kg
              und die Angabe, ob sie elektrisch unterstützt sind. Pkw sind versicherungspflichtig und
              müssen ihren Versicherungsbeitrag berechnen können. Da später auch Anhänger versichert
              werden sollen, die nicht vermietet werden, soll diese Fähigkeit über eine Schnittstelle
              Versicherbar modelliert werden.
            </p>
            <p>
              <strong>Aufgabe:</strong> Erstellen Sie ein Klassendiagramm mit Attributen, Datentypen
              und Methoden. Stellen Sie Vererbung, abstrakte Elemente und die Schnittstelle in
              UML-Notation dar.
            </p>
          </div>
        </Zeichenaufgabe>

        <Zeichenaufgabe
          nr="4.2"
          loesung={<L4RechnungLoesung />}
          erklaerung={
            <p>
              Nur die Beziehung zwischen Rechnung und Rechnungsposition ist eine Komposition, denn
              die Positionen werden mit der Rechnung gelöscht. Der Artikel bleibt im Sortiment,
              deshalb ist die Beziehung zur Position eine normale Assoziation. Der Einzelpreis steht
              bewusst in der Position: Ändert sich der Artikelpreis später, muss die alte Rechnung
              trotzdem den damaligen Preis zeigen.
            </p>
          }
          bewertung={[
            "2 Punkte: Klassen Kunde, Rechnung, Rechnungsposition und Artikel mit Attributen und Datentypen.",
            "2 Punkte: neuePosition(…) und berechneSumme() in Rechnung, berechneBetrag() in Rechnungsposition.",
            "2 Punkte: Komposition mit gefüllter Raute an Rechnung, nicht an der Position.",
            "2 Punkte: Multiplizitäten 1 zu 1..* an der Komposition und 1 zu 0..* zwischen Kunde und Rechnung.",
            "1 Punkt: normale Assoziation zwischen Rechnungsposition und Artikel mit 0..* zu 1.",
            "1 Punkt: Einzelpreis in der Rechnungsposition.",
            "Richtwert gesamt: 10 Punkte.",
          ]}
        >
          <div className="uml-szenario">
            <span className="uml-szenario-titel">Rechnungen im Onlineshop, Richtwert 10 Punkte</span>
            <p>
              Ein Onlineshop erstellt Rechnungen. Jede Rechnung hat eine Rechnungsnummer und ein
              Datum und gehört zu genau einem Kunden mit Kundennummer und Namen; ein Kunde kann
              beliebig viele Rechnungen erhalten. Eine Rechnung besteht aus mindestens einer
              Rechnungsposition mit Positionsnummer, Menge und dem Einzelpreis zum Zeitpunkt des
              Kaufs. Positionen existieren nur als Teil ihrer Rechnung und werden mit ihr gelöscht.
              Jede Position bezieht sich auf genau einen Artikel mit Artikelnummer, Bezeichnung und
              aktuellem Preis; Artikel bleiben im Sortiment, auch wenn Rechnungen gelöscht werden.
              Eine Rechnung soll neue Positionen anlegen und ihre Summe berechnen können, eine
              Position ihren Betrag.
            </p>
            <p>
              <strong>Aufgabe:</strong> Erstellen Sie ein Klassendiagramm mit Attributen, Datentypen,
              Methoden und Multiplizitäten. Wählen Sie für jede Beziehung die passende Art und
              begründen Sie die Komposition in einem Satz.
            </p>
          </div>
        </Zeichenaufgabe>
      </LsAbschnitt>

      <LsAbschnitt id="fehler" titel="Typische Fehler">
        <LsHinweis art="warnung" titel="Darauf achten die Prüfer">
          <ul>
            <li>
              Dreieck an der Unterklasse: Es sitzt immer an der Oberklasse bzw. am Interface.
            </li>
            <li>
              Geerbte Attribute in der Unterklasse wiederholt. Dort stehen nur die neuen Attribute
              und überschriebene Methoden.
            </li>
            <li>
              Realisierung durchgezogen gezeichnet oder mit offener Pfeilspitze. Richtig ist
              gestrichelt mit hohlem Dreieck.
            </li>
            <li>
              Komposition überall: Nur wenn das Teil ohne das Ganze nicht existieren kann, ist die
              Raute gefüllt. Artikel, Mitarbeiter oder Kunden überleben fast immer.
            </li>
            <li>
              Vererbung für „hat ein“: Ein Auto hat einen Motor, es ist kein Motor. Das ist eine
              Komposition oder Assoziation.
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
          frage="Wie erkennst du im Klassendiagramm, dass Girokonto von Konto erbt?"
          optionen={[
            { text: "Gefüllte Raute an Konto", richtig: false },
            { text: "Durchgezogene Linie mit hohlem Dreieck an Konto", richtig: true },
            { text: "Durchgezogene Linie mit hohlem Dreieck an Girokonto", richtig: false },
            { text: "Gestrichelte Linie mit offener Pfeilspitze an Konto", richtig: false },
          ]}
          erklaerung="Vererbung (Generalisierung) ist eine durchgezogene Linie mit hohlem Dreieck an der Oberklasse. Die Raute steht für Teil-Ganzes, die gestrichelte Linie mit offener Spitze für eine Abhängigkeit."
        />

        <QuizFrage
          nr={2}
          von={5}
          frage="Ein Haus wird abgerissen, seine Zimmer existieren danach nicht mehr. Welche Beziehung liegt zwischen Haus und Zimmer vor?"
          optionen={[
            { text: "Aggregation, hohle Raute am Haus", richtig: false },
            { text: "Komposition, gefüllte Raute am Zimmer", richtig: false },
            { text: "Komposition, gefüllte Raute am Haus", richtig: true },
            { text: "Vererbung, Zimmer erbt von Haus", richtig: false },
          ]}
          erklaerung="Die Zimmer sind existenzabhängig vom Haus, das ist eine Komposition. Die Raute sitzt immer am Ganzen, hier am Haus."
        />

        <QuizFrage
          nr={3}
          von={5}
          frage="Welche Aussage über abstrakte Klassen ist richtig?"
          optionen={[
            { text: "Von einer abstrakten Klasse kann man keine Objekte erzeugen.", richtig: true },
            { text: "Eine abstrakte Klasse darf keine Attribute haben.", richtig: false },
            { text: "Alle Methoden einer abstrakten Klasse müssen abstrakt sein.", richtig: false },
            { text: "Abstrakte Klassen werden mit «interface» gekennzeichnet.", richtig: false },
          ]}
          erklaerung="Eine abstrakte Klasse dient nur als Oberklasse, Objekte gibt es nur von ihren konkreten Unterklassen. Sie darf Attribute und fertige Methoden haben und wird kursiv oder mit {abstract} gekennzeichnet."
        />

        <QuizFrage
          nr={4}
          von={5}
          frage="Welche Java-Zeile passt zu einer gestrichelten Linie mit hohlem Dreieck von Drucker zu «interface» Druckbar?"
          optionen={[
            { text: "public class Drucker extends Druckbar", richtig: false },
            { text: "public class Drucker implements Druckbar", richtig: true },
            { text: "public interface Drucker extends Druckbar", richtig: false },
            { text: "public class Druckbar implements Drucker", richtig: false },
          ]}
          erklaerung="Die gestrichelte Linie mit hohlem Dreieck ist eine Realisierung: Die Klasse Drucker setzt das Interface Druckbar um. In Java heißt das implements."
        />

        <QuizFrage
          nr={5}
          von={5}
          frage="Ein Team besteht aus Mitarbeitern, die auch ohne das Team in der Firma bleiben und mehreren Teams angehören können. Welche Multiplizität steht an der hohlen Raute beim Team?"
          optionen={[
            { text: "Genau 1, weil an der Raute immer 1 steht", richtig: false },
            { text: "0..*, weil ein Mitarbeiter zu beliebig vielen Teams gehören kann", richtig: true },
            { text: "1..*, weil das Team mindestens einen Mitarbeiter hat", richtig: false },
            { text: "Bei Aggregationen gibt es keine Multiplizitäten.", richtig: false },
          ]}
          erklaerung="Die Multiplizität am Team sagt, zu wie vielen Teams ein Mitarbeiter gehört: 0..*. Nur bei der Komposition ist das Ganze auf 1 oder 0..1 begrenzt. 1..* gehört an das andere Ende, zum Mitarbeiter."
        />
      </LsAbschnitt>
    </LektionLayout>
  );
}
