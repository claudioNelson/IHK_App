import type { Metadata } from "next";
import Link from "next/link";
import LsToc from "./_components/LsToc";
import { LsCta } from "./_components/LsBausteine";
import { MetaIcon, PfeilIcon } from "./_components/LsIcons";

export const metadata: Metadata = {
  title: "Lernthemen: IT-Grundlagen für die IHK-Prüfung üben",
  description:
    "Alle Lernthemen für die Fachinformatiker-Prüfung: Subnetting, RAID, OSI-Modell, SQL, Normalisierung, Sortieralgorithmen und mehr, kostenlos erklärt mit interaktiven Übungsaufgaben.",
  alternates: {
    canonical: "https://lernarena.app/lernen",
  },
  openGraph: {
    type: "website",
    url: "https://lernarena.app/lernen",
    title: "Lernthemen: IT-Grundlagen für die IHK-Prüfung üben",
    description:
      "Subnetting, RAID, OSI-Modell, SQL und mehr: kostenlos erklärt mit interaktiven Übungsaufgaben für Fachinformatiker.",
    images: ["/og-image.png"],
  },
};

type Thema = { href: string; titel: string; desc: string };
type Gruppe = { id: string; titel: string; themen: Thema[] };

const gruppen: Gruppe[] = [
  {
    id: "netzwerk",
    titel: "Netzwerk und Infrastruktur",
    themen: [
      {
        href: "/lernen/subnetting",
        titel: "Subnetting üben",
        desc: "Subnetzmaske, CIDR, Netz- und Broadcast-Adresse Schritt für Schritt berechnen. Mit Rechner und Binär-Rechenweg.",
      },
      {
        href: "/lernen/ip-adressen",
        titel: "IP-Adressen und IPv6",
        desc: "Private Bereiche, APIPA und die IPv6-Kürzungsregeln sicher beherrschen.",
      },
      {
        href: "/lernen/osi-modell",
        titel: "OSI-Modell",
        desc: "Die 7 Schichten mit Protokollen, Geräten und Merksatz.",
      },
      {
        href: "/lernen/raid",
        titel: "RAID-Level",
        desc: "RAID 0, 1, 5, 6 und 10 im Vergleich, mit Kapazitätsberechnung.",
      },
    ],
  },
  {
    id: "datenbanken",
    titel: "Datenbanken",
    themen: [
      {
        href: "/lernen/sql",
        titel: "SQL üben",
        desc: "SELECT, JOIN, GROUP BY und HAVING mit typischen Prüfungsbeispielen.",
      },
      {
        href: "/lernen/er-diagramm",
        titel: "ER-Diagramm",
        desc: "Entitäten, Kardinalitäten und die n:m-Auflösung über Zwischentabellen.",
      },
      {
        href: "/lernen/normalisierung",
        titel: "Normalisierung",
        desc: "1. bis 3. Normalform mit Beispielen, Anomalien und Merksätzen.",
      },
    ],
  },
  {
    id: "grundlagen",
    titel: "Grundlagen und Projektmanagement",
    themen: [
      {
        href: "/lernen/zahlensysteme",
        titel: "Zahlensysteme",
        desc: "Binär, dezimal und hexadezimal umrechnen, die Grundlage für AP1 und Subnetting.",
      },
      {
        href: "/lernen/sortieralgorithmen",
        titel: "Sortieralgorithmen",
        desc: "Bubblesort, Quicksort und Mergesort: Laufzeiten, Stabilität, Durchläufe.",
      },
      {
        href: "/lernen/nutzwertanalyse",
        titel: "Nutzwertanalyse",
        desc: "Kriterien gewichten, Punkte vergeben, Nutzwert berechnen: der AP1-Klassiker.",
      },
    ],
  },
];

const anzahlThemen = gruppen.reduce((n, g) => n + g.themen.length, 0);

export default function LernenUebersicht() {
  return (
    <>
      <div className="wrap">
        <div className="page-head">
          <nav className="crumbs" aria-label="Pfad">
            <Link href="/">Lernarena</Link>
            <span aria-hidden="true">/</span>
            <span aria-current="page">Lernseiten</span>
          </nav>
          <h1>Lernthemen für die IHK-Prüfung</h1>
          <p className="lead">
            Die wichtigsten Themen der Fachinformatiker-Prüfung, kostenlos erklärt: mit
            Tabellen, Rechenwegen und Übungsaufgaben mit sofortigem Feedback. Wähle ein
            Thema und leg los.
          </p>
          <ul className="ls-meta" aria-label="Auf einen Blick">
            <li>
              <MetaIcon name="themen" />
              {anzahlThemen} Themen
            </li>
            <li>
              <MetaIcon name="quiz" />
              Quiz zu jedem Thema
            </li>
            <li>
              <MetaIcon name="offen" />
              Ohne Konto lesbar
            </li>
          </ul>
        </div>
      </div>

      <div className="wrap ls-layout">
        <aside className="ls-side" aria-label="Themenbereiche">
          <LsToc titel="Bereiche" abschnitte={gruppen.map((g) => ({ id: g.id, titel: g.titel }))} />
          <p className="ls-side-note">
            Du weißt nicht, wo du anfangen sollst? Der{" "}
            <Link href="/fachinformatiker-pruefung">Prüfungs-Guide</Link> erklärt Aufbau,
            Zeitplan und Gewichtung von AP1 und AP2.
          </p>
        </aside>

        <div className="ls-main">
          {gruppen.map((g) => (
            <section key={g.id} className="ls-group" id={g.id} aria-labelledby={`h-${g.id}`}>
              <div className="ls-group-head">
                <h2 id={`h-${g.id}`}>{g.titel}</h2>
                <span>
                  {g.themen.length} {g.themen.length === 1 ? "Thema" : "Themen"}
                </span>
              </div>
              <ul className="ls-rows">
                {g.themen.map((t) => (
                  <li key={t.href}>
                    <Link className="ls-row" href={t.href}>
                      <div>
                        <h3>{t.titel}</h3>
                        <p>{t.desc}</p>
                      </div>
                      <PfeilIcon />
                    </Link>
                  </li>
                ))}
              </ul>
            </section>
          ))}

          <LsCta />
        </div>
      </div>
    </>
  );
}
