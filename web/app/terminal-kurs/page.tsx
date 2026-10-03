import type { Metadata } from "next";
import Link from "next/link";
import LsToc, { type Abschnitt } from "../lernen/_components/LsToc";
import { LsAbschnitt, LsCta, LsFaq, LsHinweis, type FaqEintrag } from "../lernen/_components/LsBausteine";
import { MetaIcon, PfeilIcon } from "../lernen/_components/LsIcons";
import { ListeIcon, TerminalIcon } from "../components/kurs/KursIcons";
import { nrText } from "../components/kurs/kurs-typen";
import Terminal from "./_components/Terminal";
import { geplant, lektionen } from "./_components/lektionen";

export const metadata: Metadata = {
  title: "Terminal-Kurs: Linux-Befehle im Browser lernen, kostenlos",
  description:
    "Linux-Befehle lernen, ohne Linux zu installieren: Das Übungs-Terminal läuft direkt im Browser, mit echten Ausgaben und Aufgaben, die dein Ergebnis prüfen. Für angehende Fachinformatiker und alle, die Server verwalten wollen. Kostenlos.",
  alternates: {
    canonical: "https://lernarena.app/terminal-kurs",
  },
  openGraph: {
    type: "article",
    locale: "de_DE",
    url: "https://lernarena.app/terminal-kurs",
    siteName: "Lernarena",
    title: "Terminal-Kurs: Linux-Befehle im Browser lernen",
    description: "Ein echtes Terminal zum Ausprobieren, direkt im Browser. Mit Aufgaben, die dein Ergebnis prüfen.",
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
    q: "Brauche ich einen Linux-Rechner?",
    a: "Nein. Das Übungs-Terminal läuft komplett in deinem Browser, auch auf dem Handy. Es ist ein nachgebautes Linux mit eigenen Ordnern und Dateien. Du installierst nichts und kannst nichts kaputt machen: „Zurücksetzen“ stellt jederzeit den Anfangszustand her.",
  },
  {
    q: "Wie echt ist das Übungs-Terminal?",
    a: "Die Befehle antworten wie auf einem Ubuntu-Server: gleiche Ausgaben, gleiche englische Fehlermeldungen, gleiche Rechte. Damit du die Meldungen verstehst, steht bei Fehlern zusätzlich ein Hinweis auf Deutsch darunter. Nur die Hilfen (help, man, --help) sind deutsche Kurzfassungen. Das Übungs-Terminal kennt die Befehle, die der Kurs behandelt; help zeigt dir die Liste.",
  },
  {
    q: "Ist der Kurs prüfungsrelevant?",
    a: "Die IHK-Prüfung fragt Linux-Befehle eher selten direkt ab. Im Betrieb brauchst du sie dafür ständig, vor allem in der Systemintegration: Server einrichten, Logdateien lesen, Rechte setzen. Der Kurs ist deshalb auf Praxis ausgelegt, nicht auf Prüfungsfragen.",
  },
  {
    q: "Kommt Windows auch dran?",
    a: "Ja. Jede Linux-Lektion endet mit einem kurzen Kasten, wie dasselbe in der PowerShell oder der Eingabeaufforderung (cmd) geht. Eigene Windows-Lektionen mit PowerShell im Übungs-Terminal folgen nach dem Linux-Teil.",
  },
];

// Gesamtdauer der Linux-Grundlagen (Lektion 1 bis 6), aus den Lektionsdauern
const stundenGeplant = (lektionen.reduce((s, l) => s + l.dauer, 0) / 60).toLocaleString("de-DE", { maximumFractionDigits: 1 });

export default function TerminalKursSeite() {
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
              <span aria-current="page">Terminal-Kurs</span>
            </nav>
            <h1>Linux-Befehle lernen, direkt im Browser</h1>
            <p className="lead">
              Der kostenlose Terminal-Kurs für angehende Fachinformatiker und alle, die Server
              verwalten wollen. Du tippst echte Befehle in ein Übungs-Terminal, bekommst echte
              Ausgaben und löst Aufgaben, die prüfen, ob dein Ergebnis stimmt.
            </p>
            <ul className="ls-meta" aria-label="Auf einen Blick">
              <li>
                <ListeIcon />
                {lektionen.length + geplant.length} Lektionen
              </li>
              <li>
                <MetaIcon name="zeit" />
                Etwa {stundenGeplant} Stunden
              </li>
              <li>
                <TerminalIcon />
                Terminal im Browser
              </li>
              <li>
                <MetaIcon name="offen" />
                Kostenlos
              </li>
            </ul>
            <div className="pk-head-actions">
              <Link className="btn btn-primary" href={`/terminal-kurs/${lektionen[0].slug}`}>
                Mit Lektion 1 starten
                <PfeilIcon />
              </Link>
              <a className="btn btn-ghost" href="#kursplan">
                Kursplan ansehen
              </a>
            </div>
          </div>
          <Terminal aufgabe="l0-start" titel="Übungs-Terminal zum Ausprobieren" hoehe={280} />
        </div>
      </div>

      <div className="wrap ls-layout">
        <aside className="ls-side" aria-label="Inhalt dieser Seite">
          <LsToc titel="Auf dieser Seite" abschnitte={abschnitte} />
          <p className="ls-side-note">
            Lieber Programmieren? Der <Link href="/python-kurs">Python-Kurs</Link> startet ebenfalls
            bei null und läuft im Browser.
          </p>
        </aside>

        <article className="ls-main ls-article">
          <LsAbschnitt id="kursplan" titel="Der Kursplan">
            <p>
              Sechs Lektionen zu den Linux-Grundlagen: erst die Bedienung, dann Ordner und Dateien,
              Lesen und Suchen, Rechte und zum Schluss das Verketten von Befehlen. Danach kannst du
              im freien Terminal alles kombinieren.
            </p>
            <ol className="pk-lessons">
              {lektionen.map((l) => (
                <li key={l.slug}>
                  <Link className="pk-lesson" href={`/terminal-kurs/${l.slug}`}>
                    <span className="pk-lesson-nr">{nrText(l.nr)}</span>
                    <div>
                      <h3>{l.titel}</h3>
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
            {geplant.length > 0 && (
            <ol className="tk-geplant" aria-label="Geplante Lektionen">
              {geplant.map((l) => (
                <li key={l.nr}>
                  <span className="pk-lesson-nr">{nrText(l.nr)}</span>
                  <div>
                    <h3>{l.titel}</h3>
                    <p>{l.untertitel}</p>
                  </div>
                  <span className="tk-bald">In Arbeit</span>
                </li>
              ))}
            </ol>
            )}
          </LsAbschnitt>

          <LsAbschnitt id="ablauf" titel="So funktioniert der Kurs">
            <ol className="ls-steps">
              <li className="ls-step">
                <div>
                  <h3>Lesen</h3>
                  <p>
                    Jede Lektion erklärt ein paar Befehle an kleinen Beispielen: was sie tun, welche
                    Optionen du wirklich brauchst und welche Fehler typisch sind.
                  </p>
                </div>
              </li>
              <li className="ls-step">
                <div>
                  <h3>Tippen</h3>
                  <p>
                    Zu jeder Übung gehört ein eigenes Terminal. Die Ziele darunter haken sich ab,
                    sobald dein Ergebnis stimmt. Welchen Weg du nimmst, ist egal. Wenn du nicht
                    weiterkommst, helfen Tipps und eine Musterlösung.
                  </p>
                </div>
              </li>
              <li className="ls-step">
                <div>
                  <h3>Ausprobieren</h3>
                  <p>
                    Jedes Terminal lässt sich frei bedienen. Tippe, was dir einfällt, auch Befehle,
                    die du auf einem echten Server nie tippen würdest. „Zurücksetzen“ macht alles
                    wieder heil.
                  </p>
                </div>
              </li>
            </ol>
            <LsHinweis titel="Englisch wie auf einem echten Server" icon="buch" label="Gut zu wissen">
              <p>
                Die Ausgaben sind englisch, genau wie auf den Servern, mit denen du später arbeitest.
                So lernst du die Meldungen, die du im Beruf wiedererkennen musst. Bei jedem Fehler
                erklärt eine zusätzliche Zeile auf Deutsch, was los ist und wie es weitergeht.
              </p>
            </LsHinweis>
          </LsAbschnitt>

          <LsAbschnitt id="faq" titel="Häufige Fragen">
            <LsFaq eintraege={faq} />
          </LsAbschnitt>

          <LsCta
            titel="Lerne auch den Rest für die Prüfung."
            text="In der Lernarena übst du alle Themen der Fachinformatiker-Prüfung mit Aufgaben im IHK-Stil, sofortigem Feedback und der KI-Tutorin Ada."
          />
        </article>
      </div>
    </>
  );
}
