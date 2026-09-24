import type { Metadata } from "next";
import { LsAbschnitt, LsHinweis } from "../../lernen/_components/LsBausteine";
import QuizFrage from "../../lernen/_components/QuizFrage";
import LektionLayout from "../../components/kurs/LektionLayout";
import { UseCaseMini } from "../_components/UmlDiagramme";
import { umlKurs } from "../_components/lektionen";

export const metadata: Metadata = {
  title: "UML Lektion 1: Warum UML in der IHK-Prüfung zählt",
  description:
    "Welche UML-Diagramme die IHK abfragt, an welchen Formulierungen du in der Aufgabe erkennst, welches gemeint ist, und wie die Punkte verteilt werden. Lektion 1 des kostenlosen UML-Kurses.",
  alternates: { canonical: "https://lernarena.app/uml-kurs/lektion-1" },
};

// Signalwoerter der Aufgabenstellung und das passende Diagramm
const signale: { formulierung: string; diagramm: string; zeigt: string }[] = [
  {
    formulierung: "„Modellieren Sie die Klassen …“, „mit Attributen und Methoden“",
    diagramm: "Klassendiagramm",
    zeigt: "Welche Klassen es gibt, was sie speichern und wie sie zusammenhängen.",
  },
  {
    formulierung: "„Stellen Sie den Ablauf … dar“, „inklusive aller Verzweigungen“",
    diagramm: "Aktivitätsdiagramm",
    zeigt: "Schritte eines Prozesses mit Entscheidungen und Parallelität.",
  },
  {
    formulierung: "„Welche Akteure …“, „Welche Funktionen soll das System bieten?“",
    diagramm: "Use-Case-Diagramm",
    zeigt: "Wer das System nutzt und wofür, ohne das Wie.",
  },
  {
    formulierung: "„zeitliche Abfolge der Nachrichten“, „Methodenaufrufe zwischen …“",
    diagramm: "Sequenzdiagramm",
    zeigt: "Welches Objekt wem wann welche Nachricht schickt.",
  },
  {
    formulierung: "„Zustände“, „Welche Zustände durchläuft eine Bestellung?“",
    diagramm: "Zustandsdiagramm",
    zeigt: "Zustände eines Objekts und die Ereignisse, die sie wechseln.",
  },
];

export default function Lektion1() {
  return (
    <LektionLayout
      kurs={umlKurs}
      nr={1}
      lead="Welche Diagramme die IHK abfragt, woran du in der Aufgabe erkennst, welches gemeint ist, und wo die meisten Punkte verloren gehen."
      uebungen={4}
      aufgabenText="4 Quizfragen"
    >
      <LsAbschnitt id="warum" titel="Warum es UML gibt">
        <p>
          UML steht für <strong>Unified Modeling Language</strong>, eine einheitliche grafische
          Sprache, um Software zu beschreiben, bevor sie gebaut wird. Der Vorteil: Entwickler,
          Auftraggeber und Tester schauen auf dasselbe Bild und verstehen dasselbe darunter. Ein
          Rechteck mit drei Fächern ist überall eine Klasse, eine gefüllte Raute überall eine
          Komposition, egal ob in Hamburg, München oder im Prüfungsraum.
        </p>
        <p>
          Genau deshalb mag die IHK UML: Mit einem Diagramm lässt sich in wenigen Minuten prüfen, ob
          du einen Sachverhalt verstanden und sauber strukturiert hast. In der <strong>AP1</strong>{" "}
          kann UML alle Fachrichtungen treffen. In der <strong>AP2</strong> ist es bei
          Anwendungsentwicklern ein Dauerbrenner, bei Systemintegratoren taucht vor allem das
          Aktivitätsdiagramm auf, etwa für Abläufe bei der Einrichtung oder im Störungsfall.
        </p>
        <p>So sieht ein kleines UML-Diagramm aus, hier ein Use-Case-Diagramm (Anwendungsfalldiagramm):</p>

        <UseCaseMini caption="Use-Case-Diagramm: Wer nutzt den Lastenrad-Verleih wofür?" />

        <p>
          Auch ohne Vorwissen liest du heraus: Kunden buchen und stornieren, eine Servicekraft wartet
          die Räder. Diese Lesbarkeit ist der Sinn der Sache, und sie ist auch das, was die Prüfer
          sehen wollen.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="diagrammtypen" titel="Die Diagramme der Prüfung">
        <p>
          UML 2.5 kennt vierzehn Diagrammtypen. Für die Prüfung brauchst du davon nur einen Bruchteil.
          Vier tauchen immer wieder auf, ein fünfter gelegentlich:
        </p>
        <ul>
          <li>
            <strong>Use-Case-Diagramm</strong> (Anwendungsfalldiagramm): Wer benutzt das System
            wofür? Lektion 2.
          </li>
          <li>
            <strong>Klassendiagramm</strong>: Welche Klassen gibt es, was speichern sie, wie hängen
            sie zusammen? Lektionen 3 und 4, in der Prüfung der häufigste Typ.
          </li>
          <li>
            <strong>Aktivitätsdiagramm</strong>: In welcher Reihenfolge laufen die Schritte eines
            Prozesses ab? Lektion 5.
          </li>
          <li>
            <strong>Sequenzdiagramm</strong>: Welches Objekt schickt wann welche Nachricht an welches
            andere? Lektion 6.
          </li>
          <li>
            Gelegentlich das <strong>Zustandsdiagramm</strong> (Zustandsautomat): Welche Zustände
            durchläuft ein Objekt? Ebenfalls Lektion 6.
          </li>
        </ul>
        <p>
          Das Klassendiagramm beschreibt die <strong>Struktur</strong> eines Systems, also was es
          gibt. Die anderen vier beschreiben <strong>Verhalten</strong>, also was passiert. Diese
          Unterscheidung hilft dir, wenn du in einer Aufgabe unsicher bist.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="erkennen" titel="Das richtige Diagramm erkennen">
        <p>
          Oft nennt die Aufgabe den Diagrammtyp direkt. Manchmal steht aber nur, was dargestellt
          werden soll, und du musst selbst entscheiden. Dann helfen dir diese Signalwörter:
        </p>
        <div className="ls-table-wrap">
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Formulierung in der Aufgabe</th>
                <th scope="col">Diagramm</th>
                <th scope="col">Zeigt</th>
              </tr>
            </thead>
            <tbody>
              {signale.map((s) => (
                <tr key={s.diagramm}>
                  <td className="txt">{s.formulierung}</td>
                  <td className="txt">
                    <strong>{s.diagramm}</strong>
                  </td>
                  <td className="txt">{s.zeigt}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        <LsHinweis titel="Ablauf oder Nachrichten?">
          <p>
            Die häufigste Verwechslung: Aktivitäts- und Sequenzdiagramm. Geht es um die{" "}
            <strong>Schritte eines Prozesses</strong> mit Entscheidungen, zeichnest du ein
            Aktivitätsdiagramm. Geht es darum, <strong>wer mit wem kommuniziert</strong> (Client,
            Server, Datenbank) und in welcher Reihenfolge, ist es ein Sequenzdiagramm.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="punkte" titel="So werden die Punkte verteilt">
        <p>
          Eine UML-Aufgabe ist in der Regel Teil eines größeren Handlungsschritts. Je nachdem, ob du
          nur ein vorgegebenes Diagramm ergänzt oder ein ganzes Diagramm selbst zeichnest, bringt sie
          erfahrungsgemäß zwischen etwa 6 und 25 Punkten. Bewertet wird dabei fast immer{" "}
          <strong>Element für Element</strong>. Ein Beispiel, wie sich 12 Punkte für ein
          Klassendiagramm typischerweise aufteilen (Richtwert, jede Musterlösung legt es selbst fest):
        </p>
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
              <tr>
                <td className="txt">Alle geforderten Klassen mit passendem Namen</td>
                <td className="num">3</td>
              </tr>
              <tr>
                <td className="txt">Attribute mit Sichtbarkeit und Datentyp</td>
                <td className="num">3</td>
              </tr>
              <tr>
                <td className="txt">Methoden mit Parametern und Rückgabetyp</td>
                <td className="num">2</td>
              </tr>
              <tr>
                <td className="txt">Beziehungen zwischen den richtigen Klassen</td>
                <td className="num">2</td>
              </tr>
              <tr>
                <td className="txt">Multiplizitäten an beiden Enden</td>
                <td className="num">2</td>
              </tr>
            </tbody>
          </table>
        </div>
        <p>
          Die gute Nachricht daraus: Auch ein unvollständiges Diagramm bringt Teilpunkte. Lass eine
          UML-Aufgabe deshalb nie leer, selbst wenn du nur die Klassen findest.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="fehler" titel="Die drei häufigsten Fehler">
        <LsHinweis art="warnung" titel="Hier gehen die meisten Punkte verloren">
          <ol className="uml-ol">
            <li>
              <strong>Falscher Diagrammtyp.</strong> Wer statt des geforderten Aktivitätsdiagramms
              ein Sequenzdiagramm zeichnet, bekommt oft gar keine Punkte, auch wenn der Inhalt
              stimmt. Lies die Aufgabe zweimal und markiere das Signalwort.
            </li>
            <li>
              <strong>Unsaubere Notation.</strong> Fehlende Multiplizitäten, eine leere statt einer
              gefüllten Raute, eine durchgezogene statt einer gestrichelten Linie. In UML hat jedes
              Zeichen eine Bedeutung, und die Prüfer bewerten genau diese Bedeutung.
            </li>
            <li>
              <strong>Am Szenario vorbei modelliert.</strong> Die Musterlösung richtet sich nach dem
              Aufgabentext. Was dort steht, muss ins Diagramm, was dort nicht steht, bringt keine
              Punkte. Eigene Ideen kosten nur Zeit.
            </li>
          </ol>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="quiz" titel="Jetzt selbst testen">
        <p style={{ marginBottom: 18 }}>
          Vier Fragen zum Einstieg. Du hast so viele Versuche, wie du willst.
        </p>

        <QuizFrage
          nr={1}
          von={4}
          frage="„Stellen Sie den Ablauf der Bestellabwicklung inklusive aller Verzweigungen dar.“ Welches Diagramm ist gefragt?"
          optionen={[
            { text: "Klassendiagramm", richtig: false },
            { text: "Aktivitätsdiagramm", richtig: true },
            { text: "Use-Case-Diagramm", richtig: false },
            { text: "Sequenzdiagramm", richtig: false },
          ]}
          erklaerung="„Ablauf“ und „Verzweigungen“ sind die Signalwörter für das Aktivitätsdiagramm. Es zeigt die Schritte eines Prozesses mit Entscheidungen."
        />

        <QuizFrage
          nr={2}
          von={4}
          frage="Die Aufgabe verlangt die zeitliche Abfolge der Nachrichten zwischen App, Server und Datenbank beim Login. Welches Diagramm zeichnest du?"
          optionen={[
            { text: "Aktivitätsdiagramm", richtig: false },
            { text: "Zustandsdiagramm", richtig: false },
            { text: "Sequenzdiagramm", richtig: true },
            { text: "Klassendiagramm", richtig: false },
          ]}
          erklaerung="Wer schickt wem wann welche Nachricht: Das ist genau die Frage, die ein Sequenzdiagramm beantwortet. Die Beteiligten stehen oben nebeneinander, die Zeit läuft nach unten."
        />

        <QuizFrage
          nr={3}
          von={4}
          frage="Welche Frage beantwortet ein Use-Case-Diagramm?"
          optionen={[
            { text: "Wer nutzt das System wofür?", richtig: true },
            { text: "In welcher Reihenfolge laufen die Programmschritte ab?", richtig: false },
            { text: "Welche Attribute hat eine Klasse?", richtig: false },
            { text: "Wie ist die Datenbank aufgebaut?", richtig: false },
          ]}
          erklaerung="Ein Use-Case-Diagramm zeigt Akteure und die Anwendungsfälle, die sie mit dem System ausführen. Wie das intern abläuft, zeigt es bewusst nicht."
        />

        <QuizFrage
          nr={4}
          von={4}
          frage="„Welche Zustände kann eine Bestellung annehmen und wodurch wechselt sie in den nächsten?“ Welches Diagramm passt?"
          optionen={[
            { text: "Aktivitätsdiagramm", richtig: false },
            { text: "Zustandsdiagramm", richtig: true },
            { text: "Sequenzdiagramm", richtig: false },
            { text: "Use-Case-Diagramm", richtig: false },
          ]}
          erklaerung="Zustände eines einzelnen Objekts (offen, bezahlt, versendet) und die Ereignisse, die sie wechseln, sind der Fall für das Zustandsdiagramm."
        />
      </LsAbschnitt>
    </LektionLayout>
  );
}
