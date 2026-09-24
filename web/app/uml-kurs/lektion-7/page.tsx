import type { Metadata } from "next";
import type { ReactNode } from "react";
import Link from "next/link";
import { LsAbschnitt, LsCta, LsHinweis } from "../../lernen/_components/LsBausteine";
import { MetaIcon } from "../../lernen/_components/LsIcons";
import LektionLayout from "../../components/kurs/LektionLayout";
import { Aufgabe, CodeBlock } from "../../components/kurs/KursBausteine";
import { DiagrammIcon, LoesungPlusIcon, UhrIcon } from "../../components/kurs/KursIcons";
import {
  CarsharingKlassen,
  OnboardingAktivitaet,
  WerkstattKlassen,
  WerkstattUseCase,
} from "../_components/UmlDiagramme2";
import { umlKurs } from "../_components/lektionen";

export const metadata: Metadata = {
  title: "UML Lektion 7: Prüfungstraining mit IHK-Aufgaben",
  description:
    "Drei komplette UML-Prüfungsaufgaben im IHK-Stil: Use-Case- und Klassendiagramm für die AP1, Vererbung mit Pseudocode für die AP2 Anwendungsentwicklung und ein Aktivitätsdiagramm für Systemintegration. Mit Musterlösung, Bewertungsschema und typischen Punktabzügen.",
  alternates: { canonical: "https://lernarena.app/uml-kurs/lektion-7" },
};

/* ---- lokale Bausteine: Pruefungsaufgabe und Bewertungstabelle ---- */

function Pruefungsaufgabe({
  nr,
  zeit,
  loesung,
  children,
}: {
  nr: number;
  /** Zeitempfehlung als Text, z. B. "etwa 25 Minuten" */
  zeit: string;
  loesung: ReactNode;
  children: ReactNode;
}) {
  return (
    <Aufgabe nr={`7.${nr}`} label={`Prüfungsaufgabe ${nr}`}>
      {children}
      <p className="pk-tool-hinweis">
        <UhrIcon />
        <span>
          <strong>Zeitempfehlung:</strong> {zeit}. Stell dir einen Timer und schau erst danach in
          die Lösung.
        </span>
      </p>
      <p className="pk-tool-hinweis">
        <DiagrammIcon />
        <span>
          Zeichne auf Papier oder{" "}
          <Link href="/pruefungen">im Diagramm-Tool nachzeichnen</Link>: Es steckt in den
          Übungsprüfungen und öffnet sich dort bei jeder Zeichenaufgabe.
        </span>
      </p>
      <details className="pk-loesung">
        <summary>
          <MetaIcon name="quiz" />
          Musterlösung und Bewertung anzeigen
          <LoesungPlusIcon />
        </summary>
        <div className="pk-loesung-inhalt">{loesung}</div>
      </details>
    </Aufgabe>
  );
}

function Bewertung({ titel, zeilen }: { titel: string; zeilen: [string, number][] }) {
  const summe = zeilen.reduce((s, [, p]) => s + p, 0);
  const zahl = (p: number) => p.toLocaleString("de-DE");
  return (
    <>
      <p className="pk-bewertung-titel">{titel}</p>
      <div className="ls-table-wrap">
        <table className="ls-table">
          <thead>
            <tr>
              <th scope="col">Bewertet wird</th>
              <th scope="col" className="num">
                Punkte
              </th>
            </tr>
          </thead>
          <tbody>
            {zeilen.map(([k, p]) => (
              <tr key={k}>
                <td className="txt">{k}</td>
                <td className="num">{zahl(p)}</td>
              </tr>
            ))}
            <tr>
              <td className="txt">
                <strong>Summe</strong>
              </td>
              <td className="num">
                <strong>{zahl(summe)}</strong>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </>
  );
}

function Abzuege({ punkte }: { punkte: ReactNode[] }) {
  return (
    <>
      <p className="pk-bewertung-titel">Typische Punktabzüge</p>
      <ul className="pk-bewertung">
        {punkte.map((p, i) => (
          <li key={i}>{p}</li>
        ))}
      </ul>
    </>
  );
}

const PSEUDOCODE_KOSTEN = `METHODE berechneKosten(): double
    minuten = minutenZwischen(start, ende)
    kosten = fahrzeug.berechnePreis(minuten)
    WENN kosten > 79.00 DANN
        kosten = 79.00
    ENDE WENN
    WENN km > 100 DANN
        kosten = kosten + (km - 100) * 0.30
    ENDE WENN
    RUECKGABE kosten
ENDE METHODE`;

const PSEUDOCODE_TRANSPORTER = `// in der Klasse Transporter
METHODE berechnePreis(minuten: int): double
    RUECKGABE minuten * preisProMinute + 5.00
ENDE METHODE`;

export default function Lektion7() {
  return (
    <LektionLayout
      kurs={umlKurs}
      nr={7}
      lead="Drei komplette Aufgaben wie in der Abschlussprüfung: erst ein Szenario, dann Teilaufgaben mit Punkten. Du bearbeitest sie unter Zeitdruck, vergleichst mit der Musterlösung und bewertest dich selbst nach dem Schema der Prüfer."
      uebungen={3}
      aufgabenText="3 Prüfungsaufgaben mit Bewertungsschema"
    >
      <LsAbschnitt id="einstieg" titel="So nutzt du das Training">
        <p>
          Jede Aufgabe ist aufgebaut wie ein Handlungsschritt der IHK: Ein Unternehmen, eine
          Situation, mehrere Teilaufgaben. Rechne mit etwa einer Minute pro Punkt, das entspricht
          dem Tempo der schriftlichen Prüfung. Bearbeite eine Aufgabe am Stück, ohne in frühere
          Lektionen zu schauen, und bewerte dich danach ehrlich nach der Tabelle.
        </p>
        <ul>
          <li>
            <strong>Aufgabe 1</strong> (AP1): Use-Case- und Klassendiagramm zu einem kleinen
            System. Grundlage sind <Link href="/uml-kurs/lektion-2">Lektion 2</Link> und{" "}
            <Link href="/uml-kurs/lektion-3">Lektion 3</Link>.
          </li>
          <li>
            <strong>Aufgabe 2</strong> (AP2 Anwendungsentwicklung): Klassendiagramm mit Vererbung
            aus einem Text ableiten und eine Methode in Pseudocode schreiben. Grundlage ist{" "}
            <Link href="/uml-kurs/lektion-4">Lektion 4</Link>.
          </li>
          <li>
            <strong>Aufgabe 3</strong> (AP2, auch für Systemintegration): Aktivitätsdiagramm mit
            Verzweigung und Parallelität. Grundlage ist{" "}
            <Link href="/uml-kurs/lektion-5">Lektion 5</Link>.
          </li>
        </ul>
        <LsHinweis titel="Die Bewertung ist ein Richtwert" icon="buch" label="Prüfungsbezug">
          <p>
            Die Punkteverteilung in den Lösungen ist so aufgebaut, wie IHK-Musterlösungen
            üblicherweise bewerten: Element für Element, mit Teilpunkten. Die genauen Punkte legt
            aber jeder Prüfungsausschuss selbst fest. Nimm die Zahlen deshalb als Richtwerte, nicht
            als amtlichen Schlüssel. Abweichende, fachlich richtige Lösungen bekommen in der
            Prüfung ebenfalls Punkte.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      {/* ============================================================ */}
      <LsAbschnitt id="aufgabe-1" titel="Aufgabe 1: Terminverwaltung einer Fahrradwerkstatt">
        <Pruefungsaufgabe
          nr={1}
          zeit="etwa 25 Minuten für 25 Punkte"
          loesung={
            <>
              <p className="pk-bewertung-titel">Lösung a) Use-Case-Diagramm</p>
              <WerkstattUseCase />
              <p>
                Das Ersatzrad ist ein Zusatz, den der Kunde nur manchmal wählt: <code>«extend»</code>,
                der Pfeil zeigt auf den erweiterten Fall „Termin buchen“. Die Rechnung entsteht bei
                jedem Abschluss: <code>«include»</code>, der Pfeil zeigt auf den eingebundenen Fall
                „Rechnung erstellen“. Das System selbst und die Datenbank sind keine Akteure.
              </p>
              <Bewertung
                titel="So wird bewertet, a) (Richtwerte)"
                zeilen={[
                  ["Systemgrenze als Rechteck mit Namen", 1],
                  ["Akteure Kunde und Mechaniker außerhalb der Systemgrenze, je 1 Punkt", 2],
                  ["Anwendungsfälle Termin buchen, Termin absagen, Auftrag abschließen mit Assoziationen zum richtigen Akteur, je 1 Punkt", 3],
                  ["Ersatzrad reservieren mit «extend», Pfeil zu Termin buchen", 2],
                  ["Rechnung erstellen mit «include», Pfeil von Auftrag abschließen", 2],
                ]}
              />

              <p className="pk-bewertung-titel">Lösung b) Klassendiagramm</p>
              <WerkstattKlassen />
              <p>
                Am Mechaniker steht <code>0..1</code>, weil ein Termin bei der Buchung noch keinen
                Mechaniker hat. Die Rahmennummer ist ein <code>String</code>, weil Rahmennummern
                meist Buchstaben enthalten. Der Termin hängt am Fahrrad und nicht direkt am Kunden: Über das Fahrrad
                ist der Kunde eindeutig. Eine zusätzliche Assoziation Kunde zu Termin ist ebenfalls
                vertretbar, wenn du sie begründest.
              </p>
              <Bewertung
                titel="So wird bewertet, b) (Richtwerte)"
                zeilen={[
                  ["Klassen Kunde, Fahrrad, Termin, Mechaniker, je 0,5 Punkte", 2],
                  ["Attribute vollständig mit Sichtbarkeit und passendem Datentyp", 3],
                  ["Methoden absagen(), verschieben(neu: DateTime) und istFrei(am: DateTime): boolean mit Parametern und Rückgabetyp", 3],
                  ["Assoziationen zwischen den richtigen Klassen", 1],
                  ["Multiplizitäten an beiden Enden, je Beziehung 1 Punkt", 3],
                ]}
              />

              <p className="pk-bewertung-titel">Lösung c) include und extend</p>
              <p>
                Mögliche Antwort: „Ein mit «include» eingebundener Anwendungsfall wird{" "}
                <strong>immer</strong> mit ausgeführt: Jeder Abschluss eines Auftrags erstellt eine
                Rechnung. Ein mit «extend» angebundener Anwendungsfall ergänzt den Basisfall nur{" "}
                <strong>unter einer Bedingung</strong>: Ein Ersatzrad wird nur reserviert, wenn der
                Kunde es bei der Buchung wünscht.“
              </p>
              <Bewertung
                titel="So wird bewertet, c) (Richtwerte)"
                zeilen={[
                  ["include als Pflichtbestandteil erklärt, mit Beispiel aus dem Szenario", 1.5],
                  ["extend als optionale Erweiterung erklärt, mit Beispiel aus dem Szenario", 1.5],
                ]}
              />

              <Abzuege
                punkte={[
                  "Pfeilrichtung bei «include» oder «extend» vertauscht. Merksatz: Der Pfeil zeigt immer auf den Fall, der eingebunden oder erweitert wird, bei extend also auf den Basisfall.",
                  "Einzelne Bedienschritte als Anwendungsfall, etwa „Button Buchen klicken“. Ein Anwendungsfall ist ein Ziel des Akteurs.",
                  "Fahrrad als Attribut im Kunden statt als eigene Klasse, obwohl es eigene Daten hat.",
                  "Am Mechaniker eine 1 statt 0..1, obwohl der Text sagt, dass bei der Buchung noch keiner zugeordnet ist.",
                ]}
              />
            </>
          }
        >
          <div className="uml-szenario">
            <span className="uml-szenario-titel">Ausgangssituation</span>
            <p>
              Die Radwerk Brandt GmbH in Kassel betreibt eine Fahrradwerkstatt mit sechs
              Mechanikern. Reparaturtermine werden bisher telefonisch vergeben und in einen
              Papierkalender eingetragen. Ihr Ausbildungsbetrieb, die NordIT Solutions GmbH, soll
              dafür eine Terminverwaltung entwickeln, und Sie übernehmen die Modellierung.
            </p>
            <p>
              Kunden sollen online einen Termin buchen und ihn auch wieder absagen können. Bei der
              Buchung kann der Kunde auf Wunsch zusätzlich ein Ersatzrad für die Dauer der
              Reparatur reservieren. Ein Mechaniker schließt nach der Reparatur den Auftrag ab;
              dabei wird jedes Mal eine Rechnung erstellt. Gespeichert werden Kunden mit
              Kundennummer, Name und Telefonnummer. Jeder Kunde meldet mindestens ein Fahrrad mit
              Rahmennummer, Marke und Typ an. Ein Termin gilt für genau ein Fahrrad und hat einen
              Beginn, eine Dauer in Minuten und einen Status; er kann abgesagt und auf einen neuen
              Zeitpunkt verschoben werden. Mechaniker haben eine Personalnummer und einen Namen,
              und es soll prüfbar sein, ob ein Mechaniker zu einem Zeitpunkt frei ist. Einem Termin
              wird höchstens ein Mechaniker zugeordnet, bei der Buchung noch keiner.
            </p>
            <p>
              <strong>a)</strong> Erstellen Sie ein Use-Case-Diagramm für die Terminverwaltung.
              Berücksichtigen Sie die Beziehungen «include» und «extend». (10 Punkte)
            </p>
            <p>
              <strong>b)</strong> Erstellen Sie ein Klassendiagramm für die Klassen Kunde,
              Fahrrad, Termin und Mechaniker mit Attributen, Datentypen, Methoden, Beziehungen und
              Multiplizitäten. (12 Punkte)
            </p>
            <p>
              <strong>c)</strong> Erläutern Sie an diesem Szenario den Unterschied zwischen
              «include» und «extend». (3 Punkte)
            </p>
          </div>
        </Pruefungsaufgabe>
      </LsAbschnitt>

      {/* ============================================================ */}
      <LsAbschnitt id="aufgabe-2" titel="Aufgabe 2: Carsharing mit Vererbung und Pseudocode">
        <Pruefungsaufgabe
          nr={2}
          zeit="etwa 25 bis 30 Minuten für 25 Punkte"
          loesung={
            <>
              <p className="pk-bewertung-titel">Lösung a) Klassendiagramm</p>
              <CarsharingKlassen />
              <p>
                „Immer entweder ein E-Auto oder ein Transporter“ heißt: Von Fahrzeug selbst gibt es
                keine Objekte, die Klasse ist abstrakt. Die Unterklassen wiederholen die geerbten
                Attribute nicht. Transporter überschreibt <code>berechnePreis()</code>, weil die
                Pauschale dazukommt, und braucht dafür Zugriff auf den Minutenpreis; deshalb ist{" "}
                <code>preisProMinute</code> geschützt (<code>#</code>). Privat mit einem Getter
                wäre ebenso richtig. Der Pfeil von Fahrt zu Fahrzeug folgt aus „die Fahrt muss ihr
                Fahrzeug kennen, umgekehrt nicht“.
              </p>
              <Bewertung
                titel="So wird bewertet, a) (Richtwerte)"
                zeilen={[
                  ["Klassen Kunde, Fahrt, Fahrzeug, EAuto, Transporter", 2],
                  ["Fahrzeug als abstrakt gekennzeichnet (kursiv oder {abstract})", 1],
                  ["Vererbung mit leerem Dreieck an Fahrzeug, geerbte Attribute nicht wiederholt", 2],
                  ["Attribute mit Sichtbarkeit und Datentyp, Zugriff der Unterklasse auf den Minutenpreis gelöst", 3],
                  ["Methoden berechnePreis() in Fahrzeug und Transporter, mussLaden(), berechneKosten()", 2],
                  ["Assoziationen mit Multiplizitäten, Navigierbarkeit von Fahrt zu Fahrzeug", 2],
                ]}
              />

              <p className="pk-bewertung-titel">Lösung b) Pseudocode</p>
              <CodeBlock code={PSEUDOCODE_KOSTEN} />
              <p>
                Der entscheidende Punkt ist die zweite Zeile: Die Fahrt rechnet den Zeitpreis nicht
                selbst aus, sondern fragt ihr Fahrzeug. Ob dabei die Pauschale dazukommt, entscheidet
                das Fahrzeug. Zur Kontrolle ein Rechenbeispiel: Transporter mit 0,25 Euro pro
                Minute, 300 Minuten, 180 km. Zeitpreis 75,00 plus 5,00 Pauschale ergibt 80,00,
                gedeckelt auf 79,00. Dazu 80 km mal 0,30 gleich 24,00, zusammen 103,00 Euro. Die
                überschriebene Methode im Transporter sieht so aus (nicht gefordert, aber
                hilfreich zum Verständnis):
              </p>
              <CodeBlock code={PSEUDOCODE_TRANSPORTER} />
              <Bewertung
                titel="So wird bewertet, b) (Richtwerte)"
                zeilen={[
                  ["Minuten mit minutenZwischen(start, ende) ermittelt", 1],
                  ["Zeitpreis über fahrzeug.berechnePreis(minuten), nicht selbst berechnet", 2],
                  ["Deckelung auf 79,00 Euro korrekt und vor dem Kilometerzuschlag", 2],
                  ["Zuschlag nur für die Kilometer über 100, richtig berechnet", 2],
                  ["Rückgabe des Ergebnisses, Methode vollständig und lesbar strukturiert", 1],
                ]}
              />

              <p className="pk-bewertung-titel">Lösung c) Abstrakte Klasse und Polymorphie</p>
              <p>
                Mögliche Antwort: „Fahrzeug ist abstrakt, weil es kein Fahrzeug gibt, das weder
                E-Auto noch Transporter ist. Die Klasse bündelt nur die gemeinsamen Attribute und
                Methoden, damit sie nicht doppelt gepflegt werden. Beim Aufruf{" "}
                <code>fahrzeug.berechnePreis(minuten)</code> wird zur Laufzeit geprüft, welches
                Objekt tatsächlich dahintersteht. Ist es ein Transporter, läuft dessen
                überschriebene Methode mit Pauschale, bei einem E-Auto die geerbte aus Fahrzeug.
                Die Klasse Fahrt muss den genauen Typ dafür nicht kennen (Polymorphie).“
              </p>
              <Bewertung
                titel="So wird bewertet, c) (Richtwerte)"
                zeilen={[
                  ["Abstrakt: keine eigenen Objekte, gemeinsame Eigenschaften zentral", 2],
                  ["Überschriebene Methode des Transporters wird zur Laufzeit gewählt", 2],
                  ["Begriff Polymorphie oder dynamische Bindung sinnvoll verwendet", 1],
                ]}
              />

              <Abzuege
                punkte={[
                  "Vererbungspfeil mit offener Spitze oder am falschen Ende: Das leere Dreieck sitzt an der Oberklasse.",
                  "kennzeichen, modell und preisProMinute in EAuto und Transporter wiederholt.",
                  "In berechneKosten() eine Fallunterscheidung nach dem Fahrzeugtyp statt des polymorphen Aufrufs. Das rechnet richtig, verfehlt aber den Kern der Aufgabe und bringt meist nur Teilpunkte.",
                  "Deckel erst nach dem Kilometerzuschlag angewendet oder Zuschlag auf alle Kilometer statt nur auf die über 100.",
                ]}
              />
            </>
          }
        >
          <div className="uml-szenario">
            <span className="uml-szenario-titel">Ausgangssituation</span>
            <p>
              Die Weserland Mobil GmbH in Bremen betreibt ein Carsharing mit E-Autos und
              Transportern. Sie arbeiten im Entwicklungsteam an einer neuen Abrechnungssoftware,
              die objektorientiert umgesetzt wird.
            </p>
            <p>
              Jedes Fahrzeug hat ein Kennzeichen, ein Modell und einen Preis pro Minute. Ein
              Fahrzeug ist immer entweder ein E-Auto oder ein Transporter. Bei E-Autos werden der
              Akkustand in Prozent und die Reichweite in Kilometern gespeichert, und es soll
              abfragbar sein, ob das Auto geladen werden muss. Bei Transportern wird das
              Ladevolumen in Kubikmetern gespeichert. Der Preis eines Fahrzeugs für eine Anzahl
              Minuten ergibt sich aus Minuten mal Minutenpreis; bei Transportern kommt eine
              Reinigungspauschale von 5,00 Euro hinzu. Kunden mit Kundennummer und Namen können
              beliebig viele Fahrten machen. Eine Fahrt speichert Start, Ende und die gefahrenen
              Kilometer und bezieht sich auf genau ein Fahrzeug; die Fahrt muss ihr Fahrzeug
              kennen, umgekehrt nicht. Die Kosten einer Fahrt sind der Preis des Fahrzeugs,
              höchstens aber 79,00 Euro; zusätzlich kostet jeder Kilometer über 100 km 0,30 Euro.
            </p>
            <p>
              <strong>a)</strong> Erstellen Sie ein Klassendiagramm mit Attributen, Datentypen,
              Methoden, Beziehungen und Multiplizitäten. Nutzen Sie Vererbung. (12 Punkte)
            </p>
            <p>
              <strong>b)</strong> Implementieren Sie die Methode <code>berechneKosten(): double</code>{" "}
              der Klasse Fahrt in Pseudocode. Die Funktion{" "}
              <code className="uml-lang">minutenZwischen(von: DateTime, bis: DateTime): int</code> steht
              zur Verfügung. (8 Punkte)
            </p>
            <p>
              <strong>c)</strong> Erläutern Sie, warum die Klasse Fahrzeug abstrakt ist und was
              beim Aufruf von <code>berechnePreis()</code> passiert, wenn die Fahrt mit einem
              Transporter stattfand. (5 Punkte)
            </p>
          </div>
        </Pruefungsaufgabe>
      </LsAbschnitt>

      {/* ============================================================ */}
      <LsAbschnitt id="aufgabe-3" titel="Aufgabe 3: Onboarding neuer Mitarbeiter">
        <Pruefungsaufgabe
          nr={3}
          zeit="etwa 25 Minuten für 25 Punkte"
          loesung={
            <>
              <p className="pk-bewertung-titel">Lösung a) Aktivitätsdiagramm</p>
              <OnboardingAktivitaet />
              <p>
                „Gleichzeitig“ im Text ist das Signal für eine Gabelung (Balken). Innerhalb des
                Hardware-Strangs steckt eine Entscheidung (Raute mit zwei Wächtern), die vor der
                Vereinigung wieder zusammengeführt wird. „Erst wenn beides erledigt ist“ ist die
                Vereinigung: Sie wartet, bis beide Stränge angekommen sind. Schwimmbahnen für
                Personalabteilung und IT wären möglich, sind hier aber nicht gefordert.
              </p>
              <Bewertung
                titel="So wird bewertet, a) (Richtwerte)"
                zeilen={[
                  ["Startknoten und Endknoten", 1],
                  ["Aktionen vollständig, als Tätigkeit formuliert und in sinnvoller Reihenfolge", 5],
                  ["Gabelung und Vereinigung als Balken an der richtigen Stelle", 3],
                  ["Verzweigung mit Wächtern [auf Lager] und [nicht auf Lager]", 2],
                  ["Zusammenführung der beiden Hardware-Wege vor der Vereinigung", 2],
                  ["Kontrollflüsse mit Pfeilrichtung, keine offenen Enden", 2],
                ]}
              />

              <p className="pk-bewertung-titel">Lösung b) Verzweigung und Gabelung</p>
              <p>
                Mögliche Antwort: „An einer Verzweigung (Raute) wird genau <strong>ein</strong>{" "}
                Weg gewählt, abhängig vom Wächter: Das Notebook wird entweder reserviert oder
                bestellt. An einer Gabelung (Balken) laufen <strong>alle</strong> ausgehenden Wege
                gleichzeitig los: Hardware und Konten werden parallel vorbereitet. Die zugehörige
                Vereinigung wartet, bis alle Wege fertig sind.“
              </p>
              <Bewertung
                titel="So wird bewertet, b) (Richtwerte)"
                zeilen={[
                  ["Verzweigung: genau ein Weg nach Bedingung, mit Beispiel", 2],
                  ["Gabelung: alle Wege parallel, Vereinigung wartet auf alle, mit Beispiel", 2],
                ]}
              />

              <p className="pk-bewertung-titel">Lösung c) Sichere Vergabe der Berechtigungen</p>
              <p>Mögliche Maßnahmen, drei davon sind gefordert:</p>
              <ul>
                <li>
                  Minimalprinzip (least privilege): nur die Rechte, die für die Aufgabe nötig sind.
                </li>
                <li>
                  Rollenbasierte Vergabe über Gruppen der Abteilung statt Einzelrechte pro Person.
                </li>
                <li>Initialpasswort, das bei der ersten Anmeldung geändert werden muss.</li>
                <li>Mehr-Faktor-Authentifizierung für Fernzugriff und Postfach.</li>
                <li>Freigabe durch die Führungskraft und Dokumentation der vergebenen Rechte.</li>
                <li>Befristung der Konten bei befristeten Verträgen.</li>
              </ul>
              <p>
                Beispiel für eine Erläuterung: „Nach dem Minimalprinzip bekommt ein neuer
                Mitarbeiter im Lager nur Zugriff auf die Lagerverwaltung, nicht auf
                Personaldaten. Wird sein Konto kompromittiert, bleibt der Schaden auf diesen
                Bereich begrenzt, und personenbezogene Daten sind nach DSGVO nur für Berechtigte
                zugänglich.“
              </p>
              <Bewertung
                titel="So wird bewertet, c) (Richtwerte)"
                zeilen={[
                  ["Drei passende Maßnahmen, je 1 Punkt", 3],
                  ["Eine Maßnahme nachvollziehbar erläutert, mit Bezug zum Szenario", 3],
                ]}
              />

              <Abzuege
                punkte={[
                  "Parallelität mit einer Raute statt mit einem Balken gezeichnet. Damit ist die Aussage falsch, dieser Teil bringt meist keine Punkte.",
                  "Beide Wege der Verzweigung direkt in die Vereinigung geführt. Die Vereinigung wartet dann auf beide, obwohl nur einer kommt: Der Ablauf bleibt hängen. Erst mit einer Raute zusammenführen.",
                  "Wächter ohne eckige Klammern oder nur an einem Ausgang der Raute.",
                  "Aktionen als Zustand formuliert, etwa „Notebook bestellt“ statt „Notebook bestellen“.",
                ]}
              />
            </>
          }
        >
          <div className="uml-szenario">
            <span className="uml-szenario-titel">Ausgangssituation</span>
            <p>
              Die Hanse Logistik AG in Hamburg stellt jeden Monat mehrere neue Mitarbeiter ein.
              Bisher läuft die Vorbereitung ihrer Arbeitsplätze in der IT uneinheitlich, oft fehlt
              am ersten Arbeitstag das Notebook oder das Konto. Sie sind in der IT-Abteilung
              beauftragt, den Onboarding-Prozess zu dokumentieren.
            </p>
            <p>
              Die Personalabteilung legt für jeden neuen Mitarbeiter ein Onboarding-Ticket an, das
              die IT zuerst prüft. Danach laufen zwei Arbeiten gleichzeitig. Für die Hardware
              prüft die IT, ob ein passendes Notebook auf Lager ist. Ist eines vorhanden, wird es
              reserviert; andernfalls wird es beim Lieferanten bestellt, und die IT wartet auf die
              Lieferung. Parallel dazu wird das Benutzerkonto angelegt, das Postfach eingerichtet
              und anschließend werden die Berechtigungen für die Abteilung vergeben. Erst wenn
              beides erledigt ist, wird das Notebook eingerichtet und dem Mitarbeiter mit einem
              Übergabeprotokoll übergeben.
            </p>
            <p>
              <strong>a)</strong> Stellen Sie den beschriebenen Ablauf als UML-Aktivitätsdiagramm
              dar. (15 Punkte)
            </p>
            <p>
              <strong>b)</strong> Erläutern Sie an diesem Ablauf den Unterschied zwischen einer
              Verzweigung und einer Gabelung. (4 Punkte)
            </p>
            <p>
              <strong>c)</strong> Nennen Sie drei Maßnahmen, mit denen die IT bei der Vergabe der
              Berechtigungen die Informationssicherheit berücksichtigt, und erläutern Sie eine
              davon. (6 Punkte)
            </p>
          </div>
        </Pruefungsaufgabe>
      </LsAbschnitt>

      {/* ============================================================ */}
      <LsAbschnitt id="vorgehen" titel="So gehst du in der Prüfung vor">
        <p>
          Egal welches Diagramm gefragt ist, dieser Ablauf funktioniert immer. Er kostet am Anfang
          zwei Minuten und spart dir am Ende die hektische Suche nach vergessenen Details.
        </p>
        <ol className="ls-steps">
          <li className="ls-step">
            <div>
              <h3>Lesen</h3>
              <p>
                Lies die Aufgabe zweimal: einmal ganz, einmal langsam mit Stift. Markiere das
                Signalwort für den Diagrammtyp und die Punktzahl jeder Teilaufgabe. Die Punkte
                sagen dir, wie viel Zeit und Detail erwartet wird.
              </p>
            </div>
          </li>
          <li className="ls-step">
            <div>
              <h3>Nomen markieren</h3>
              <p>
                Nomen werden zu Klassen, Akteuren oder Attributen. Was eigene Daten hat und mehrfach
                vorkommt, ist eine Klasse; was von außen mit dem System arbeitet, ein Akteur; eine
                einfache Eigenschaft ist ein Attribut.
              </p>
            </div>
          </li>
          <li className="ls-step">
            <div>
              <h3>Verben markieren</h3>
              <p>
                Verben werden zu Methoden, Anwendungsfällen oder Aktionen. Achte auf „immer“ und
                „auf Wunsch“ (include oder extend), „wenn, sonst“ (Raute), „gleichzeitig“ (Balken)
                und „mindestens“ oder „beliebig viele“ (Multiplizitäten).
              </p>
            </div>
          </li>
          <li className="ls-step">
            <div>
              <h3>Zeichnen</h3>
              <p>
                Erst das Gerüst mit Bleistift und viel Platz: Klassen oder Aktionen, dann die
                Linien. Danach die Details, also Datentypen, Multiplizitäten, Wächter und
                Beschriftungen. So hast du Teilpunkte sicher, auch wenn die Zeit knapp wird.
              </p>
            </div>
          </li>
          <li className="ls-step">
            <div>
              <h3>Kontrollieren</h3>
              <p>
                Geh den Aufgabentext Satz für Satz durch und hake ab, was im Diagramm steht. Lies
                jede Beziehung in beide Richtungen und prüf jede Pfeilspitze. Was nicht im Text
                steht, streichst du wieder.
              </p>
            </div>
          </li>
        </ol>
      </LsAbschnitt>

      <LsAbschnitt id="checkliste" titel="Deine Selbst-Checkliste">
        <p>Bevor du den Kurs abhakst, prüf ehrlich, ob du das hier ohne Nachschlagen kannst:</p>
        <ul>
          <li>Ich erkenne am Aufgabentext, welches Diagramm gefragt ist.</li>
          <li>Ich schreibe Attribute und Methoden mit Sichtbarkeit, Parametern und Datentyp.</li>
          <li>Ich setze Multiplizitäten an das richtige Ende und prüfe sie mit Lesesätzen.</li>
          <li>Ich unterscheide Assoziation, Aggregation, Komposition und Vererbung am Symbol.</li>
          <li>Ich weiß, wohin die Pfeile bei «include» und «extend» zeigen.</li>
          <li>Ich setze Raute und Balken im Aktivitätsdiagramm richtig ein, mit Wächtern.</li>
          <li>Ich unterscheide synchrone, asynchrone und Antwortnachrichten.</li>
          <li>Ich beschrifte Übergänge nach dem Muster Ereignis [Bedingung] / Aktion.</li>
          <li>Ich schaffe eine 25-Punkte-Aufgabe in etwa 25 Minuten.</li>
        </ul>
        <p style={{ marginTop: 14 }}>
          Wo du noch zögerst, geh zurück in die passende Lektion. Danach übst du am besten unter
          echten Bedingungen: In den <Link href="/pruefungen">Übungsprüfungen</Link> warten
          weitere UML-Aufgaben mit Diagramm-Tool und Bewertung. Und wenn du sehen willst, wie aus
          einem Klassendiagramm lauffähiger Code wird, schau in{" "}
          <Link href="/python-kurs/lektion-10">Lektion 10 des Python-Kurses</Link> zu Klassen und
          Vererbung.
        </p>
      </LsAbschnitt>

      <LsCta
        titel="Jetzt unter Prüfungsbedingungen üben."
        text="In der Lernarena bearbeitest du komplette Prüfungen im IHK-Stil mit Zeitlimit, zeichnest UML-Diagramme direkt im Browser und bekommst von der KI-Tutorin Ada Feedback zu jeder Lösung."
      />
    </LektionLayout>
  );
}
