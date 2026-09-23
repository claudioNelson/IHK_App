import type { Metadata } from "next";
import Link from "next/link";
import LsToc, { type Abschnitt } from "../lernen/_components/LsToc";
import { LsAbschnitt, LsCta, LsFaq, LsHinweis, type FaqEintrag } from "../lernen/_components/LsBausteine";
import { MetaIcon, PfeilIcon } from "../lernen/_components/LsIcons";
import PythonRunner from "./_components/PythonRunner";
import { BrowserIcon, GamepadIcon, ListeIcon } from "./_components/KursIcons";
import { lektionen, nrText } from "./_components/lektionen";

export const metadata: Metadata = {
  title: "Python lernen für Fachinformatiker: kostenloser Kurs im Browser",
  description:
    "Python von null lernen, direkt im Browser programmieren, ohne Installation. Kostenloser Kurs für angehende Fachinformatiker (Anwendungsentwicklung), von der ersten Zeile Code bis zum eigenen Spiel.",
  alternates: {
    canonical: "https://lernarena.app/python-kurs",
  },
  openGraph: {
    type: "article",
    locale: "de_DE",
    url: "https://lernarena.app/python-kurs",
    siteName: "Lernarena",
    title: "Python lernen für Fachinformatiker: kostenloser Kurs im Browser",
    description:
      "Python von null lernen, direkt im Browser programmieren. Vom ersten print() bis zum eigenen Spiel.",
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
    q: "Muss ich etwas installieren, um den Kurs zu machen?",
    a: "Nein. Der Code läuft direkt in deinem Browser (per WebAssembly). Erst beim großen Abschlussprojekt installierst du Python auf deinem eigenen Rechner, mit Schritt-für-Schritt-Anleitung.",
  },
  {
    q: "Ist der Kurs für komplette Anfänger geeignet?",
    a: "Ja. Der Kurs startet bei null, jede Lektion baut auf der vorherigen auf. Vorkenntnisse brauchst du keine, nur einen Browser.",
  },
  {
    q: "Warum Python und nicht Java oder Pseudocode?",
    a: "Python hat die einsteigerfreundlichste Syntax und du siehst am schnellsten Ergebnisse. Die Konzepte (Variablen, Schleifen, Funktionen, OOP) sind in jeder Sprache gleich und genau die werden in der IHK-Prüfung abgefragt. Die letzte Lektion schlägt die Brücke zum IHK-Pseudocode.",
  },
  {
    q: "Brauche ich den Kurs als Systemintegrator (FISI)?",
    a: "Schaden kann er nicht: Grundlegendes Programmierverständnis wird in der AP1 von allen verlangt, und Skripting hilft dir auch als Admin. Der Kurs richtet sich aber vor allem an angehende Anwendungsentwickler.",
  },
];

// Gesamtdauer auf halbe Stunden gerundet, z. B. "Etwa 4,5 Stunden"
const minuten = lektionen.reduce((summe, l) => summe + l.dauer, 0);
const stunden = (Math.round((minuten / 60) * 2) / 2).toLocaleString("de-DE");

export default function PythonKursSeite() {
  return (
    <>
      <div className="wrap">
        <div className="page-head pk-head">
          <div>
            <nav className="crumbs" aria-label="Pfad">
              <Link href="/">Lernarena</Link>
              <span aria-hidden="true">/</span>
              <span aria-current="page">Python-Kurs</span>
            </nav>
            <h1>Python lernen: vom ersten Befehl zum eigenen Spiel</h1>
            <p className="lead">
              Der kostenlose Programmierkurs für angehende Anwendungsentwickler. Du schreibst echten
              Code direkt im Browser, ohne Installation.
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
                <BrowserIcon />
                Läuft im Browser
              </li>
              <li>
                <MetaIcon name="offen" />
                Kostenlos
              </li>
            </ul>
            <div className="pk-head-actions">
              <Link className="btn btn-primary" href={`/python-kurs/${lektionen[0].slug}`}>
                Mit Lektion 1 starten
                <PfeilIcon />
              </Link>
              <a className="btn btn-ghost" href="#kursplan">
                Kursplan ansehen
              </a>
            </div>
          </div>
          <PythonRunner
            rows={4}
            dateiname="hallo.py"
            label="Python-Code: Probier es aus"
            initialCode={`print("Hallo Welt!")
print("Ich lerne programmieren.")
print(3 + 4)`}
          />
        </div>
      </div>

      <div className="wrap ls-layout">
        <aside className="ls-side" aria-label="Inhalt dieser Seite">
          <LsToc titel="Auf dieser Seite" abschnitte={abschnitte} />
          <p className="ls-side-note">
            Lieber Theorie für die Prüfung? Alle Themen mit Aufgaben findest du in den{" "}
            <Link href="/lernen">Lernseiten</Link>.
          </p>
        </aside>

        <article className="ls-main ls-article">
          <LsAbschnitt id="kursplan" titel="Der Kursplan">
            <p>
              Zwölf Lektionen, jede baut auf der vorherigen auf. Zwei davon sind Spiele-Projekte, bei
              denen du alles Gelernte zusammensetzt.
            </p>
            <ol className="pk-lessons">
              {lektionen.map((l) => (
                <li key={l.slug}>
                  <Link
                    className="pk-lesson"
                    href={`/python-kurs/${l.slug}`}
                    data-projekt={l.projekt ? "" : undefined}
                  >
                    <span className="pk-lesson-nr">{nrText(l.nr)}</span>
                    <div>
                      <h3>
                        {l.titel}
                        {l.projekt && (
                          <span className="pk-tag">
                            <GamepadIcon />
                            Projekt
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
                  <h3>Kurz lesen</h3>
                  <p>
                    Jede Lektion erklärt ein Konzept in wenigen Absätzen, mit Beispielen aus dem
                    Ausbildungsalltag.
                  </p>
                </div>
              </li>
              <li className="ls-step">
                <div>
                  <h3>Code direkt ausführen</h3>
                  <p>
                    Unter jeder Erklärung steht ein echter Python-Editor. Du änderst den Code und
                    siehst sofort, was passiert.
                  </p>
                </div>
              </li>
              <li className="ls-step">
                <div>
                  <h3>Übungen lösen</h3>
                  <p>
                    Danach löst du kleine Übungen. Die Musterlösung klappst du erst auf, wenn du es
                    selbst versucht hast.
                  </p>
                </div>
              </li>
            </ol>
            <LsHinweis titel="Genau das fragt die AP1 ab" icon="buch" label="Prüfungsbezug">
              <p>
                Variablen, Bedingungen, Schleifen, Funktionen und Objektorientierung werden in der
                IHK-Abschlussprüfung im Pseudocode geprüft. Lektion 12 übersetzt alles in diese
                Schreibweise.
              </p>
            </LsHinweis>
          </LsAbschnitt>

          <LsAbschnitt id="faq" titel="Häufige Fragen">
            <LsFaq eintraege={faq} />
          </LsAbschnitt>

          <LsCta
            titel="Übe parallel für deine IHK-Prüfung."
            text="In der Lernarena warten Prüfungssimulationen mit KI-Korrektur, Karteikarten und Lernpfade für AP1 und AP2 auf dich."
          />
        </article>
      </div>
    </>
  );
}
