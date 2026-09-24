import type { Metadata } from "next";
import Link from "next/link";
import LsToc from "../lernen/_components/LsToc";
import { LsCta } from "../lernen/_components/LsBausteine";
import { MetaIcon, PfeilIcon } from "../lernen/_components/LsIcons";
import { BrowserIcon, DiagrammIcon, ListeIcon, StiftIcon, TerminalIcon, UhrIcon } from "../components/kurs/KursIcons";
import type { Kurs } from "../components/kurs/kurs-typen";
import { pythonKurs } from "../python-kurs/_components/lektionen";
import { umlKurs } from "../uml-kurs/_components/lektionen";

export const metadata: Metadata = {
  title: "Kurse für Fachinformatiker: Python und UML kostenlos lernen",
  description:
    "Kostenlose Kurse für die Ausbildung zum Fachinformatiker: Python im Browser programmieren und UML-Diagramme für die IHK-Prüfung zeichnen. Ohne Anmeldung, Schritt für Schritt.",
  alternates: {
    canonical: "https://lernarena.app/kurse",
  },
  openGraph: {
    type: "website",
    url: "https://lernarena.app/kurse",
    title: "Kurse für Fachinformatiker: Python und UML kostenlos lernen",
    description:
      "Python im Browser programmieren und UML-Diagramme für die IHK-Prüfung zeichnen. Kostenlos, ohne Anmeldung.",
    images: ["/og-image.png"],
  },
};

type Eintrag = {
  kurs: Kurs;
  kicker: string;
  titel: string;
  beschreibung: string;
  icon: "terminal" | "diagramm";
};

const kurse: Eintrag[] = [
  {
    kurs: pythonKurs,
    kicker: "Programmieren",
    titel: "Python-Kurs: vom ersten print() bis zum eigenen Spiel",
    beschreibung:
      "Programmieren von null lernen, direkt im Browser und ohne Installation. Variablen, Schleifen, Funktionen und Objekte, also genau die Konzepte, die in der AP1 abgefragt werden.",
    icon: "terminal",
  },
  {
    kurs: umlKurs,
    kicker: "Modellieren",
    titel: "UML-Kurs: Diagramme lesen und zeichnen wie in der Prüfung",
    beschreibung:
      "Use-Case-, Klassen-, Aktivitäts-, Sequenz- und Zustandsdiagramm mit den Regeln, die die IHK bewertet. Zum Schluss komplette Aufgaben im Prüfungsstil mit Musterlösung.",
    icon: "diagramm",
  },
];

// Gesamtdauer eines Kurses auf halbe Stunden gerundet, z. B. "4,5 Stunden"
function dauerText(kurs: Kurs): string {
  const minuten = kurs.lektionen.reduce((summe, l) => summe + l.dauer, 0);
  const stunden = Math.round((minuten / 60) * 2) / 2;
  return stunden < 1 ? `${minuten} Minuten` : `Etwa ${stunden.toLocaleString("de-DE")} Stunden`;
}

const anzahlLektionen = kurse.reduce((n, e) => n + e.kurs.lektionen.length, 0);

export default function KurseUebersicht() {
  return (
    <>
      <div className="wrap">
        <div className="page-head">
          <nav className="crumbs" aria-label="Pfad">
            <Link href="/">Lernarena</Link>
            <span aria-hidden="true">/</span>
            <span aria-current="page">Kurse</span>
          </nav>
          <h1>Kurse für Fachinformatiker</h1>
          <p className="lead">
            Längere Lernpfade mit aufeinander aufbauenden Lektionen: einmal von vorn bis
            hinten durcharbeiten und ein Thema wirklich beherrschen. Kostenlos und ohne
            Anmeldung.
          </p>
          <ul className="ls-meta" aria-label="Auf einen Blick">
            <li>
              <MetaIcon name="themen" />
              {kurse.length} Kurse, {anzahlLektionen} Lektionen
            </li>
            <li>
              <MetaIcon name="quiz" />
              Aufgaben mit Lösung in jeder Lektion
            </li>
            <li>
              <MetaIcon name="offen" />
              Ohne Konto nutzbar
            </li>
          </ul>
        </div>
      </div>

      <div className="wrap ls-layout">
        <aside className="ls-side" aria-label="Kurse">
          <LsToc titel="Kurse" abschnitte={kurse.map((e) => ({ id: e.kurs.slug, titel: e.kurs.titel }))} />
          <p className="ls-side-note">
            Lieber kurz und gezielt? Die <Link href="/lernen">Lernseiten</Link> erklären
            einzelne Prüfungsthemen wie Subnetting oder Normalisierung auf einer Seite.
          </p>
        </aside>

        <div className="ls-main">
          <ul className="ks-list">
            {kurse.map((e) => (
              <li key={e.kurs.slug} id={e.kurs.slug}>
                <Link className="ks-card" href={`/${e.kurs.slug}`}>
                  <span className="ks-icon" aria-hidden="true">
                    {e.icon === "terminal" ? <TerminalIcon /> : <DiagrammIcon />}
                  </span>
                  <div className="ks-body">
                    <span className="ks-kicker">{e.kicker}</span>
                    <h2>{e.titel}</h2>
                    <p>{e.beschreibung}</p>
                    <ul className="ks-meta" aria-label="Eckdaten">
                      <li>
                        <ListeIcon />
                        {e.kurs.lektionen.length} Lektionen
                      </li>
                      <li>
                        <UhrIcon />
                        {dauerText(e.kurs)}
                      </li>
                      <li>
                        {e.kurs.lernort.icon === "browser" ? <BrowserIcon /> : <StiftIcon />}
                        {e.kurs.lernort.text}
                      </li>
                    </ul>
                  </div>
                  <span className="ks-arrow" aria-hidden="true">
                    <PfeilIcon />
                  </span>
                </Link>
              </li>
            ))}
          </ul>

          <p className="ks-hint">
            <strong>Weitere Kurse sind in Arbeit.</strong> Als Nächstes geplant: Struktogramme
            und Pseudocode für die AP1. In der App findest du außerdem den SQL-Kurs mit
            echter Datenbank und den Python-Kurs mit Fortschritt.
          </p>

          <LsCta />
        </div>
      </div>
    </>
  );
}
