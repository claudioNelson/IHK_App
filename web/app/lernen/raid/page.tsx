import type { Metadata } from "next";
import Link from "next/link";
import LernSeite, { type Abschnitt, type MetaEintrag, type Verwandt } from "../_components/LernSeite";
import { LsAbschnitt, LsFaq, LsHinweis, type FaqEintrag } from "../_components/LsBausteine";
import QuizFrage from "../_components/QuizFrage";

export const metadata: Metadata = {
  title: "RAID-Level erklärt: 0, 1, 5, 6, 10 im Vergleich (IHK)",
  description:
    "RAID einfach erklärt: RAID 0, 1, 5, 6 und 10 im Vergleich mit Nutzkapazität, Ausfallsicherheit und Rechenbeispielen für die IHK-Prüfung als Fachinformatiker Systemintegration.",
  alternates: {
    canonical: "https://lernarena.app/lernen/raid",
  },
  openGraph: {
    type: "article",
    url: "https://lernarena.app/lernen/raid",
    title: "RAID-Level erklärt: 0, 1, 5, 6, 10 im Vergleich (IHK)",
    description:
      "RAID-Level im Vergleich: Nutzkapazität, Ausfallsicherheit und Rechenbeispiele für die Fachinformatiker-Prüfung.",
    images: ["/og-image.png"],
  },
};

const abschnitte: Abschnitt[] = [
  { id: "was-ist-raid", titel: "Was ist ein RAID?" },
  { id: "vergleich", titel: "RAID-Level im Vergleich" },
  { id: "paritaet", titel: "Was ist Parität?" },
  { id: "beispiel", titel: "Rechenbeispiel" },
  { id: "fehler", titel: "Häufige Fehler" },
  { id: "quiz", titel: "Selbst testen" },
  { id: "faq", titel: "Häufige Fragen" },
];

const meta: MetaEintrag[] = [
  { icon: "zeit", text: "Etwa 8 Minuten" },
  { icon: "rechner", text: "Vergleichstabelle und Rechenbeispiel" },
  { icon: "quiz", text: "5 Quizfragen" },
  { icon: "pruefung", text: "AP1 und AP2 Systemintegration" },
];

const verwandt: Verwandt[] = [
  { href: "/lernen/subnetting", titel: "Subnetting üben", untertitel: "Maske, Blockgröße, Broadcast" },
  { href: "/lernen/osi-modell", titel: "OSI-Modell", untertitel: "7 Schichten mit Protokollen und Geräten" },
  { href: "/lernen", titel: "Alle Lernthemen", untertitel: "10 Themen für AP1 und AP2" },
  { href: "/pruefungen", titel: "Übungsprüfungen", untertitel: "Aufgaben im IHK-Stil mit Korrektur" },
];

const raidTable: {
  level: string;
  min: string;
  cap: string;
  tol: string;
  note: string;
}[] = [
  { level: "RAID 0", min: "2", cap: "100 % (n)", tol: "keine", note: "Striping: maximale Geschwindigkeit, kein Schutz" },
  { level: "RAID 1", min: "2", cap: "50 %", tol: "1 Platte", note: "Spiegelung (Mirroring)" },
  { level: "RAID 5", min: "3", cap: "(n − 1) Platten", tol: "1 Platte", note: "Striping und Parität, guter Kompromiss" },
  { level: "RAID 6", min: "4", cap: "(n − 2) Platten", tol: "2 Platten", note: "Doppelte Parität" },
  { level: "RAID 10", min: "4", cap: "50 %", tol: "1 pro Spiegel", note: "Gespiegelt und gestriped: Geschwindigkeit und Redundanz" },
];

const faq: FaqEintrag[] = [
  {
    q: "Was ist ein RAID?",
    a: "RAID (Redundant Array of Independent Disks) fasst mehrere Festplatten zu einem logischen Verbund zusammen. Je nach RAID-Level erhöht das die Ausfallsicherheit, die Geschwindigkeit oder beides. Wichtig: Ein RAID ersetzt kein Backup.",
  },
  {
    q: "Welches RAID-Level ist das beste?",
    a: "Es gibt kein pauschal bestes Level, es kommt auf das Ziel an. RAID 1 für einfache Ausfallsicherheit, RAID 5 als Kompromiss aus Kapazität und Sicherheit, RAID 6 für höhere Sicherheit bei vielen Platten, RAID 10 wenn Geschwindigkeit und Redundanz zusammen zählen.",
  },
  {
    q: "Wie berechne ich die Nutzkapazität bei RAID 5?",
    a: "Bei RAID 5 geht der Speicherplatz einer Platte für die Parität verloren. Die Nutzkapazität ist also (Anzahl Platten − 1) × Plattengröße. Beispiel: 4 × 2 TB ergeben (4 − 1) × 2 TB = 6 TB nutzbar.",
  },
  {
    q: "Warum ist ein RAID kein Backup?",
    a: "Ein RAID schützt vor dem Ausfall einzelner Festplatten (Hardware). Es schützt aber nicht vor versehentlichem Löschen, Dateibeschädigung, Viren oder Ransomware. Solche Fehler werden sofort auf alle Platten übernommen. Deshalb braucht man zusätzlich echte Backups.",
  },
  {
    q: "Wie viele Festplatten dürfen bei RAID 5 ausfallen?",
    a: "Bei RAID 5 darf genau eine Festplatte ausfallen, ohne dass Daten verloren gehen. Fällt eine zweite Platte aus, bevor die erste ersetzt und wiederhergestellt ist, sind die Daten verloren. RAID 6 verkraftet dagegen zwei gleichzeitige Ausfälle.",
  },
];

export default function RaidPage() {
  return (
    <LernSeite
      titel="RAID-Level erklärt: RAID 0, 1, 5, 6 und 10 im Vergleich"
      lead="RAID gehört zu den sicheren Punktelieferanten in der IHK-Prüfung für Fachinformatiker Systemintegration. Hier lernst du die wichtigsten RAID-Level und wie du Nutzkapazität und Ausfallsicherheit berechnest, mit Beispielen und Übungsaufgaben."
      pfad="RAID-Level"
      meta={meta}
      abschnitte={abschnitte}
      seitenNotiz={
        <>
          RAID kommt in der Prüfung oft zusammen mit Netzwerkaufgaben dran. Zum Aufwärmen:{" "}
          <Link href="/lernen/subnetting">Subnetting üben</Link>.
        </>
      }
      verwandt={verwandt}
      cta={{
        titel: "RAID interaktiv trainieren.",
        text: "In der Lernarena rechnest du RAID- und Netzwerkaufgaben mit sofortigem Feedback, Aufgaben im IHK-Stil und der KI-Tutorin Ada, die dir jeden Schritt erklärt.",
      }}
    >
      <LsAbschnitt id="was-ist-raid" titel="Was ist ein RAID?">
        <p>
          <strong>RAID</strong> steht für <em>Redundant Array of Independent Disks</em> und
          fasst mehrere Festplatten zu einem logischen Verbund zusammen. Je nach gewähltem
          Level bekommst du mehr <strong>Ausfallsicherheit</strong>, mehr{" "}
          <strong>Geschwindigkeit</strong> oder eine Mischung aus beidem. Ein wichtiger
          Merksatz für die Prüfung: <strong>Ein RAID ersetzt kein Backup</strong>. Es schützt
          vor Hardware-Ausfall, nicht vor versehentlichem Löschen oder Verschlüsselung durch
          Ransomware.
        </p>
        <LsHinweis titel="Merkhilfe: Kopien in Schubladen" icon="stapel" label="Merkhilfe">
          <p>
            <strong>RAID 1</strong> ist wie ein <em>Durchschlag</em>: Von jedem Blatt gibt es
            sofort eine identische Kopie in der zweiten Schublade. Verbrennt eine, hast du
            noch die andere. <strong>RAID 0</strong> zerreißt jedes Blatt in zwei Hälften und
            legt die Hälften auf zwei Schubladen. Das geht doppelt so schnell, aber fehlt eine
            Schublade, ist <em>alles</em> unlesbar. <strong>RAID 5</strong> ist eine
            Lerngruppe: Fällt eine Person aus, lässt sich ihr Wissen aus den Notizen der
            anderen (der „Parität“) rekonstruieren.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="vergleich" titel="Die RAID-Level im Vergleich">
        <p>Diese Tabelle solltest du für die Prüfung sicher beherrschen:</p>
        <div
          className="ls-table-wrap"
          role="region"
          aria-label="RAID-Level im Vergleich, seitlich scrollbar"
          tabIndex={0}
        >
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Level</th>
                <th scope="col" className="num">Min. Platten</th>
                <th scope="col">Nutzkapazität</th>
                <th scope="col">Ausfalltoleranz</th>
                <th scope="col">Merkmal</th>
              </tr>
            </thead>
            <tbody>
              {raidTable.map((r) => (
                <tr key={r.level}>
                  <td>{r.level}</td>
                  <td className="num">{r.min}</td>
                  <td>{r.cap}</td>
                  <td>{r.tol}</td>
                  <td className="txt">{r.note}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        <p>
          <em>n</em> steht dabei für die Anzahl der Festplatten. Bei RAID 5 verlierst du die
          Kapazität <strong>einer</strong> Platte an die Parität, bei RAID 6 die von{" "}
          <strong>zwei</strong> Platten.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="paritaet" titel="Was ist „Parität“?">
        <p>
          Die <strong>Parität</strong> ist eine clevere Prüfsumme. Vereinfacht: Aus den
          Datenblöcken der übrigen Platten wird ein Wert berechnet, mit dem sich ein fehlender
          Block wieder ausrechnen lässt, wie in der Gleichung <code>3 + 4 + ? = 12</code>:
          Fehlt eine Zahl, kannst du sie aus den anderen zurückrechnen (hier 5). Genau so
          stellt RAID 5 die Daten einer ausgefallenen Platte wieder her. Deshalb kostet die
          Parität immer den Platz <strong>einer</strong> Platte (RAID 5) bzw.{" "}
          <strong>zweier</strong> Platten (RAID 6).
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="beispiel" titel="Rechenbeispiel Nutzkapazität">
        <p className="ls-task">
          <strong>Aufgabe:</strong> Ein Server hat <code>4 Festplatten à 2 TB</code> im
          Verbund <code>RAID 5</code>. Wie viel Speicher steht nutzbar zur Verfügung?
        </p>
        <ol className="ls-steps">
          <li className="ls-step">
            <div>
              <h3>Formel wählen</h3>
              <p>
                Bei RAID 5 gilt: Nutzkapazität = (n − 1) × Plattengröße.
              </p>
            </div>
          </li>
          <li className="ls-step">
            <div>
              <h3>Einsetzen</h3>
              <p>
                <code>(4 − 1) × 2 TB = 6 TB</code> nutzbar.
              </p>
            </div>
          </li>
          <li className="ls-step">
            <div>
              <h3>Einordnen</h3>
              <p>
                Die Kapazität einer Platte (2 TB) geht für die verteilte Parität verloren.
                Dafür darf eine beliebige Platte ausfallen, ohne dass Daten verloren gehen.
              </p>
            </div>
          </li>
        </ol>
        <LsHinweis titel="Prüfungstipp: So bleiben die Formeln im Kopf">
          <p>
            <code>RAID 0 = n</code> (alles), <code>RAID 1 = 50 %</code>,{" "}
            <code>RAID 5 = (n − 1)</code>, <code>RAID 6 = (n − 2)</code>,{" "}
            <code>RAID 10 = 50 %</code>. Rechne die Nutzkapazität immer in Platten und
            multipliziere erst am Ende mit der Plattengröße. So vermeidest du Rechenfehler.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="fehler" titel="Häufige Fehler in der Prüfung">
        <LsHinweis art="warnung" titel="Vier Stolperfallen, die regelmäßig Punkte kosten">
          <ul>
            <li>
              „RAID ist ein Backup“ ankreuzen. <strong>Ist es nicht.</strong> Es schützt nur
              vor Plattenausfall, nicht vor Löschen oder Ransomware.
            </li>
            <li>
              Bei RAID 5 die volle Kapazität rechnen. Es geht immer eine Platte an die
              Parität verloren: <code>(n − 1)</code>.
            </li>
            <li>
              RAID 6 mit RAID 5 verwechseln: RAID 6 verträgt <strong>zwei</strong> Ausfälle,
              RAID 5 nur einen.
            </li>
            <li>
              Die Mindest-Plattenzahl vergessen: RAID 5 braucht mindestens{" "}
              <strong>3</strong>, RAID 6 und RAID 10 mindestens <strong>4</strong>.
            </li>
          </ul>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="quiz" titel="Jetzt selbst testen">
        <p style={{ marginBottom: 18 }}>
          Beantworte die Fragen und bekomme sofort Feedback. Du hast so viele Versuche, wie
          du willst.
        </p>

        <QuizFrage
          nr={1}
          von={5}
          frage="Wie viele Festplatten braucht RAID 5 mindestens?"
          optionen={[
            { text: "2", richtig: false },
            { text: "3", richtig: true },
            { text: "4", richtig: false },
            { text: "5", richtig: false },
          ]}
          erklaerung="RAID 5 braucht mindestens 3 Platten: Die Daten werden gestriped und die Parität verteilt über alle Platten gespeichert."
        />

        <QuizFrage
          nr={2}
          von={5}
          frage="Wie groß ist die Nutzkapazität von 5 × 4 TB im RAID 5?"
          optionen={[
            { text: "20 TB", richtig: false },
            { text: "16 TB", richtig: true },
            { text: "12 TB", richtig: false },
            { text: "10 TB", richtig: false },
          ]}
          erklaerung="(n − 1) × Plattengröße = (5 − 1) × 4 TB = 16 TB. Eine Platte (4 TB) geht für die Parität verloren."
        />

        <QuizFrage
          nr={3}
          von={5}
          frage="Welches RAID-Level bietet KEINE Ausfallsicherheit?"
          optionen={[
            { text: "RAID 0", richtig: true },
            { text: "RAID 1", richtig: false },
            { text: "RAID 5", richtig: false },
            { text: "RAID 6", richtig: false },
          ]}
          erklaerung="RAID 0 verteilt die Daten nur über die Platten (Striping) ohne jede Redundanz. Fällt eine Platte aus, ist der gesamte Verbund verloren."
        />

        <QuizFrage
          nr={4}
          von={5}
          frage="Wie viele Festplatten dürfen bei RAID 6 gleichzeitig ausfallen?"
          optionen={[
            { text: "Keine", richtig: false },
            { text: "1", richtig: false },
            { text: "2", richtig: true },
            { text: "Beliebig viele", richtig: false },
          ]}
          erklaerung="RAID 6 nutzt doppelte Parität und verträgt damit den gleichzeitigen Ausfall von zwei Platten. Deshalb braucht es auch mindestens 4 Platten."
        />

        <QuizFrage
          nr={5}
          von={5}
          frage="Ein Kunde will maximale Schreibgeschwindigkeit UND Ausfallsicherheit. Welches Level passt am besten?"
          optionen={[
            { text: "RAID 0", richtig: false },
            { text: "RAID 1", richtig: false },
            { text: "RAID 10", richtig: true },
            { text: "RAID 6", richtig: false },
          ]}
          erklaerung="RAID 10 kombiniert Spiegelung (Sicherheit) und Striping (Geschwindigkeit). Es kostet zwar 50 % Kapazität, liefert aber beides zusammen, anders als RAID 0 (kein Schutz) oder RAID 1 (kein Geschwindigkeitsgewinn durch Striping)."
        />
      </LsAbschnitt>

      <LsAbschnitt id="faq" titel="Häufige Fragen">
        <LsFaq eintraege={faq} />
      </LsAbschnitt>
    </LernSeite>
  );
}
