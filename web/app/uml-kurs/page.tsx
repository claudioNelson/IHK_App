import type { Metadata } from "next";
import Link from "next/link";
import LsToc, { type Abschnitt } from "../lernen/_components/LsToc";
import { LsAbschnitt, LsCta, LsFaq, LsHinweis, type FaqEintrag } from "../lernen/_components/LsBausteine";
import { MetaIcon, PfeilIcon } from "../lernen/_components/LsIcons";
import { ListeIcon, StiftIcon, ZielIcon } from "../components/kurs/KursIcons";
import { markeText, nrText } from "../components/kurs/kurs-typen";
import { HeroKlassendiagramm } from "./_components/UmlDiagramme";
import { lektionen } from "./_components/lektionen";

export const metadata: Metadata = {
  title: "UML für die IHK-Prüfung: kostenloser Kurs für Fachinformatiker",
  description:
    "UML so lernen, wie die IHK es abfragt: Use-Case-, Klassen-, Aktivitäts-, Sequenz- und Zustandsdiagramm mit Zeichenaufgaben, Musterlösungen und Bewertungshinweisen. Kostenloser Kurs für AP1 und AP2.",
  alternates: {
    canonical: "https://lernarena.app/uml-kurs",
  },
  openGraph: {
    type: "article",
    locale: "de_DE",
    url: "https://lernarena.app/uml-kurs",
    siteName: "Lernarena",
    title: "UML für die IHK-Prüfung: kostenloser Kurs für Fachinformatiker",
    description:
      "Alle UML-Diagramme der IHK-Prüfung mit Zeichenaufgaben, Musterlösungen und Bewertungshinweisen.",
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
    q: "Brauche ich eine Software, um die Diagramme zu zeichnen?",
    a: "Nein. Papier, Bleistift und ein Lineal reichen völlig. Wer lieber am Bildschirm zeichnet, findet in den Übungsprüfungen der Lernarena ein Diagramm-Tool, das sich bei jeder Zeichenaufgabe öffnet.",
  },
  {
    q: "Nach welcher UML-Version richtet sich der Kurs?",
    a: "Nach UML 2.5, der aktuellen Fassung. Die IHK-Aufgaben nutzen genau diese gängige Notation. Wo es in der Praxis mehrere übliche Schreibweisen gibt, zeigt der Kurs die, die in Prüfungen und Musterlösungen am häufigsten vorkommt.",
  },
  {
    q: "Ist der Kurs für Anwendungsentwickler oder für Systemintegratoren?",
    a: "Für beide. In der AP1 kann UML alle Fachrichtungen treffen. In der AP2 ist UML bei Anwendungsentwicklern ein Dauerbrenner, bei Systemintegratoren kommt vor allem das Aktivitätsdiagramm vor.",
  },
  {
    q: "Muss ich programmieren können?",
    a: "Nein. Die Diagramme verstehst du ohne Programmierkenntnisse. Nur Lektion 4 zeigt, wie aus einem Klassendiagramm Code wird. Wer dafür Grundlagen möchte, findet sie im kostenlosen Python-Kurs der Lernarena.",
  },
];

// Gesamtdauer auf halbe Stunden gerundet, z. B. "Etwa 3 Stunden"
const minuten = lektionen.reduce((summe, l) => summe + l.dauer, 0);
const stunden = (Math.round((minuten / 60) * 2) / 2).toLocaleString("de-DE");

export default function UmlKursSeite() {
  return (
    <>
      <div className="wrap">
        <div className="page-head pk-head">
          <div>
            <nav className="crumbs" aria-label="Pfad">
              <Link href="/">Lernarena</Link>
              <span aria-hidden="true">/</span>
              <span aria-current="page">UML-Kurs</span>
            </nav>
            <h1>UML so, wie die IHK es abfragt</h1>
            <p className="lead">
              Der kostenlose UML-Kurs für angehende Fachinformatiker. Du lernst jeden Diagrammtyp der
              Prüfung, zeichnest echte Aufgaben selbst und siehst an jeder Musterlösung, wofür es
              Punkte gibt.
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
              <Link className="btn btn-primary" href={`/uml-kurs/${lektionen[0].slug}`}>
                Mit Lektion 1 starten
                <PfeilIcon />
              </Link>
              <a className="btn btn-ghost" href="#kursplan">
                Kursplan ansehen
              </a>
            </div>
          </div>
          <HeroKlassendiagramm />
        </div>
      </div>

      <div className="wrap ls-layout">
        <aside className="ls-side" aria-label="Inhalt dieser Seite">
          <LsToc titel="Auf dieser Seite" abschnitte={abschnitte} />
          <p className="ls-side-note">
            Lieber erst programmieren lernen? Der <Link href="/python-kurs">Python-Kurs</Link> startet
            bei null.
          </p>
        </aside>

        <article className="ls-main ls-article">
          <LsAbschnitt id="kursplan" titel="Der Kursplan">
            <p>
              Sieben Lektionen: erst der Überblick, dann jeder Diagrammtyp einzeln, zum Schluss
              komplette Prüfungsaufgaben mit Bewertung.
            </p>
            <ol className="pk-lessons">
              {lektionen.map((l) => (
                <li key={l.slug}>
                  <Link
                    className="pk-lesson"
                    href={`/uml-kurs/${l.slug}`}
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
                    Jede Lektion erklärt einen Diagrammtyp an einem durchgehenden Beispiel, mit der
                    Notation, die in IHK-Aufgaben und Musterlösungen verwendet wird.
                  </p>
                </div>
              </li>
              <li className="ls-step">
                <div>
                  <h3>Selbst zeichnen</h3>
                  <p>
                    Zu jeder Lektion gibt es Zeichenaufgaben mit Szenariotext wie in der Prüfung.
                    Du zeichnest auf Papier oder im Diagramm-Tool der Übungsprüfungen und vergleichst
                    danach mit der Musterlösung.
                  </p>
                </div>
              </li>
              <li className="ls-step">
                <div>
                  <h3>Quiz</h3>
                  <p>
                    Kurze Quizfragen am Ende jeder Lektion prüfen, ob die Notation sitzt:
                    Multiplizitäten lesen, Pfeile unterscheiden, den richtigen Diagrammtyp wählen.
                  </p>
                </div>
              </li>
            </ol>
            <LsHinweis titel="Punkte gibt es für Details" icon="buch" label="Prüfungsbezug">
              <p>
                Bei UML-Aufgaben bewerten die Prüfer jedes Element einzeln: Klasse, Attribut, Pfeil,
                Multiplizität. Deshalb zeigt jede Musterlösung im Kurs, wofür es Punkte gibt und wo
                sie typischerweise verloren gehen.
              </p>
            </LsHinweis>
          </LsAbschnitt>

          <LsAbschnitt id="faq" titel="Häufige Fragen">
            <LsFaq eintraege={faq} />
          </LsAbschnitt>

          <LsCta
            titel="Übe UML an echten Prüfungsaufgaben."
            text="In der Lernarena warten Prüfungssimulationen mit Diagramm-Tool, KI-Korrektur und Lernpfaden für AP1 und AP2 auf dich."
          />
        </article>
      </div>
    </>
  );
}
