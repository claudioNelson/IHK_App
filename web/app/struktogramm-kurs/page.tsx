import type { Metadata } from "next";
import Link from "next/link";
import LsToc, { type Abschnitt } from "../lernen/_components/LsToc";
import { LsAbschnitt, LsCta, LsFaq, LsHinweis, type FaqEintrag } from "../lernen/_components/LsBausteine";
import { MetaIcon, PfeilIcon } from "../lernen/_components/LsIcons";
import { ListeIcon, StiftIcon, ZielIcon } from "../components/kurs/KursIcons";
import { markeText, nrText } from "../components/kurs/kurs-typen";
import Struktogramm from "./_components/Struktogramm";
import { anw, fuer, wenn } from "./_components/struktogramm-typen";
import { lektionen } from "./_components/lektionen";

export const metadata: Metadata = {
  title: "Struktogramme und Pseudocode für die IHK-Prüfung: kostenloser Kurs",
  description:
    "Struktogramme lesen, zeichnen und in Pseudocode übersetzen, so wie es die AP1 der Fachinformatiker verlangt. Mit Schreibtischtests, Übungsaufgaben, Musterlösungen und Bewertungshinweisen. Kostenlos, ohne Anmeldung.",
  alternates: {
    canonical: "https://lernarena.app/struktogramm-kurs",
  },
  openGraph: {
    type: "article",
    locale: "de_DE",
    url: "https://lernarena.app/struktogramm-kurs",
    siteName: "Lernarena",
    title: "Struktogramme und Pseudocode für die IHK-Prüfung: kostenloser Kurs",
    description:
      "Struktogramme lesen, zeichnen und in Pseudocode übersetzen, mit Übungsaufgaben und Musterlösungen für die AP1.",
    images: ["/og-image.png"],
  },
};

const abschnitte: Abschnitt[] = [
  { id: "kursplan", titel: "Kursplan" },
  { id: "ablauf", titel: "So funktioniert der Kurs" },
  { id: "faq", titel: "Häufige Fragen" },
];

const faq: FaqEintrag[] = [
  {
    q: "Muss ich programmieren können?",
    a: "Nein. Struktogramme sind gerade dafür da, Abläufe ohne Programmiersprache aufzuschreiben. Der Kurs startet bei null. Nur Lektion 7 übersetzt Struktogramme in Python, damit du sie im Browser laufen lassen kannst; sie ist als Zusatz gekennzeichnet, wer will, überspringt sie.",
  },
  {
    q: "Welche Pseudocode-Schreibweise ist die richtige?",
    a: "Es gibt keine amtliche Norm. Die Aufgaben erlauben in der Regel „eine Programmiersprache Ihrer Wahl oder Pseudocode“; in der AP2 ist oft auch ein UML-Aktivitätsdiagramm zugelassen (siehe UML-Kurs). Der Kurs nutzt eine deutsche Schreibweise, wie sie in Lehrbüchern und vielen Lösungshinweisen vorkommt (WENN, SONST, SOLANGE, WIEDERHOLE BIS, FÜR). Wichtig ist nicht das Wort, sondern dass die Struktur eindeutig ist und du sie durchgehend gleich schreibst.",
  },
  {
    q: "Ist der Kurs für Anwendungsentwickler oder Systemintegratoren?",
    a: "Für beide. Struktogramme und Pseudocode gehören zur AP1, die alle IT-Berufe gemeinsam schreiben. Anwendungsentwickler treffen sie in der AP2 erneut, meist zusammen mit Klassendiagrammen.",
  },
  {
    q: "Brauche ich eine Software zum Zeichnen?",
    a: "Nein. Papier, Kugelschreiber und Lineal reichen, mehr hast du in der Prüfung auch nicht; vorzeichnen kannst du auf Konzeptpapier. Ein Struktogramm besteht nur aus Rechtecken, Dreiecken und Balken.",
  },
];

// Beispiel im Kopf der Seite: Maximum einer Liste
const heroBloecke = [
  anw("Eingabe Feld zahlen mit n Werten (erstes Element: zahlen[1])"),
  anw("max = zahlen[1]"),
  fuer("für i = 2 bis n", [wenn("zahlen[i] > max", [anw("max = zahlen[i]")])]),
  anw("Ausgabe max"),
];

// Gesamtdauer auf halbe Stunden gerundet, z. B. "Etwa 3,5 Stunden"
const minuten = lektionen.reduce((summe, l) => summe + l.dauer, 0);
const stunden = (Math.round((minuten / 60) * 2) / 2).toLocaleString("de-DE");

export default function StruktogrammKursSeite() {
  return (
    <>
      <div className="wrap">
        <div className="page-head pk-head">
          <div>
            <nav className="crumbs" aria-label="Pfad">
              <Link href="/">Lernarena</Link>
              <span aria-hidden="true">/</span>
              <Link href="/kurse">Kurse</Link>
              <span aria-hidden="true">/</span>
              <span aria-current="page">Struktogramm-Kurs</span>
            </nav>
            <h1>Struktogramme und Pseudocode für die AP1</h1>
            <p className="lead">
              Der kostenlose Kurs für angehende Fachinformatiker. Du lernst, Struktogramme zu lesen,
              Schritt für Schritt nachzuvollziehen, selbst zu zeichnen und in Pseudocode zu
              übersetzen, mit Aufgaben im Stil der IHK-Prüfung.
            </p>
            <ul className="ls-meta" aria-label="Auf einen Blick">
              <li>
                <ListeIcon />
                {lektionen.length} Lektionen
              </li>
              <li>
                <MetaIcon name="zeit" />
                Etwa {stunden} Stunden
              </li>
              <li>
                <StiftIcon />
                Papier und Stift genügen
              </li>
              <li>
                <MetaIcon name="offen" />
                Kostenlos
              </li>
            </ul>
            <div className="pk-head-actions">
              <Link className="btn btn-primary" href={`/struktogramm-kurs/${lektionen[0].slug}`}>
                Mit Lektion 1 starten
                <PfeilIcon />
              </Link>
              <a className="btn btn-ghost" href="#kursplan">
                Kursplan ansehen
              </a>
            </div>
          </div>
          <div className="sg-hero">
            <Struktogramm titel="Maximum bestimmen" bloecke={heroBloecke} breite={380} />
          </div>
        </div>
      </div>

      <div className="wrap ls-layout">
        <aside className="ls-side" aria-label="Inhalt dieser Seite">
          <LsToc titel="Auf dieser Seite" abschnitte={abschnitte} />
          <p className="ls-side-note">
            Klassen und Abläufe als Diagramm? Das ist der <Link href="/uml-kurs">UML-Kurs</Link>.
            Programmieren von null? Der <Link href="/python-kurs">Python-Kurs</Link>.
          </p>
        </aside>

        <article className="ls-main ls-article">
          <LsAbschnitt id="kursplan" titel="Der Kursplan">
            <p>
              Acht Lektionen: erst die Bausteine, dann das Nachvollziehen mit dem Schreibtischtest,
              dann Felder, Muster und Unterprogramme, zum Schluss komplette Prüfungsaufgaben mit
              Bewertung. Lektion 7 (Python) ist ein Zusatz.
            </p>
            <ol className="pk-lessons">
              {lektionen.map((l) => (
                <li key={l.slug}>
                  <Link
                    className="pk-lesson"
                    href={`/struktogramm-kurs/${l.slug}`}
                    data-projekt={l.projekt ? "" : undefined}
                  >
                    <span className="pk-lesson-nr">{nrText(l.nr)}</span>
                    <div>
                      <h3>
                        {l.titel}
                        {l.projekt && (
                          <span className="pk-tag">
                            <ZielIcon />
                            {markeText(l)}
                          </span>
                        )}
                      </h3>
                      <p>{l.untertitel}</p>
                    </div>
                    <span className="pk-lesson-time">
                      <span className="pk-sr">Dauer: </span>
                      {l.dauer} Min.
                    </span>
                    <PfeilIcon />
                  </Link>
                </li>
              ))}
            </ol>
          </LsAbschnitt>

          <LsAbschnitt id="ablauf" titel="So funktioniert der Kurs">
            <ol className="ls-steps">
              <li className="ls-step">
                <div>
                  <h3>Lesen</h3>
                  <p>
                    Jede Lektion erklärt einen Baustein an kleinen Beispielen und zeigt daneben den
                    Pseudocode, damit du beide Schreibweisen zusammen lernst.
                  </p>
                </div>
              </li>
              <li className="ls-step">
                <div>
                  <h3>Nachvollziehen und zeichnen</h3>
                  <p>
                    Du führst Schreibtischtests durch, ergänzt Lücken in Struktogrammen und zeichnest
                    eigene. Zu jeder Aufgabe gibt es eine Musterlösung und eine typische
                    Punkteverteilung.
                  </p>
                </div>
              </li>
              <li className="ls-step">
                <div>
                  <h3>Quiz</h3>
                  <p>
                    Kurze Quizfragen am Ende jeder Lektion prüfen, ob die Regeln sitzen: Welche
                    Schleife läuft mindestens einmal? Wie viele Durchläufe hat diese Zählschleife?
                  </p>
                </div>
              </li>
            </ol>
            <LsHinweis titel="Punkte gibt es in Teilen" icon="buch" label="Prüfungsbezug">
              <p>
                Die Lösungshinweise vergeben Teilpunkte: für die passende Schleifenart, die
                Bedingung, die Startwerte, die Ausgabe an der richtigen Stelle. Andere richtige
                Lösungen werden in der Regel anerkannt. Wer die Form beherrscht, sichert sich diese
                Teilpunkte auch dann, wenn ein Detail des Algorithmus nicht stimmt. Deshalb übt der
                Kurs die Form so lange, bis sie automatisch kommt.
              </p>
            </LsHinweis>
          </LsAbschnitt>

          <LsAbschnitt id="faq" titel="Häufige Fragen">
            <LsFaq eintraege={faq} />
          </LsAbschnitt>

          <LsCta
            titel="Übe Abläufe an echten Prüfungsaufgaben."
            text="In den Übungsprüfungen der Lernarena bekommst du Aufgaben im IHK-Stil mit Bewertung durch die KI-Tutorin Ada."
          />
        </article>
      </div>
    </>
  );
}
