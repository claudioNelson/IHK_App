// Gemeinsamer Rahmen fuer alle Lektionsseiten (Server-Komponente), nach
// kurs-design/mockup-lektion.html: Pfad, Fortschritt "Lektion n von 12",
// Seitenkopf mit Meta-Zeile, links der Kursplan, rechts der Artikel und am
// Ende die Vor/Zurueck-Kacheln. Header und Footer kommen aus
// app/python-kurs/layout.tsx (PageShell).
//
// children sind die Abschnitte der Lektion, am besten <LsAbschnitt>.

import type { ReactNode } from "react";
import Link from "next/link";
import { MetaIcon, PfeilIcon } from "../../lernen/_components/LsIcons";
import { BrowserIcon, PfeilLinksIcon } from "./KursIcons";
import KursplanNav from "./KursplanNav";
import { anzeigeTitel, lektionen } from "./lektionen";

export default function LektionLayout({
  nr,
  lead,
  uebungen,
  mitLoesung = true,
  lokal = false,
  children,
}: {
  nr: number;
  /** Vorspann unter der h1 */
  lead: ReactNode;
  /** Anzahl der Uebungen fuer die Meta-Zeile */
  uebungen: number;
  /** false, wenn die Uebungen keine Musterloesung haben */
  mitLoesung?: boolean;
  /** true, wenn die Lektion auf dem eigenen Rechner laeuft (Snake) */
  lokal?: boolean;
  children: ReactNode;
}) {
  const index = lektionen.findIndex((l) => l.nr === nr);
  const lektion = lektionen[index];
  const prev = index > 0 ? lektionen[index - 1] : undefined;
  const next = lektionen[index + 1];
  const gesamt = lektionen.length;

  const uebungenText = `${uebungen} ${uebungen === 1 ? "Übung" : "Übungen"}${mitLoesung ? " mit Lösung" : ""}`;

  return (
    <>
      <div className="wrap">
        <div className="page-head">
          <nav className="crumbs" aria-label="Pfad">
            <Link href="/">Lernarena</Link>
            <span aria-hidden="true">/</span>
            <Link href="/python-kurs">Python-Kurs</Link>
            <span aria-hidden="true">/</span>
            <span aria-current="page">Lektion {nr}</span>
          </nav>
          <div className="pk-progress">
            <span>
              <strong>Lektion {nr}</strong> von {gesamt}
            </span>
            <ol aria-hidden="true">
              {lektionen.map((l) => (
                <li key={l.slug} data-done={l.nr <= nr ? "" : undefined} />
              ))}
            </ol>
          </div>
          <h1>{lektion ? anzeigeTitel(lektion) : `Lektion ${nr}`}</h1>
          <p className="lead">{lead}</p>
          <ul className="ls-meta" aria-label="Auf einen Blick">
            {lektion && (
              <li>
                <MetaIcon name="zeit" />
                Etwa {lektion.dauer} Minuten
              </li>
            )}
            <li>
              <MetaIcon name="quiz" />
              {uebungenText}
            </li>
            <li>
              <BrowserIcon />
              {lokal ? "Läuft auf deinem Rechner" : "Läuft im Browser"}
            </li>
          </ul>
        </div>
      </div>

      <div className="wrap ls-layout">
        <aside className="ls-side" aria-label="Kursplan">
          <KursplanNav aktuell={nr} />
          <p className="ls-side-note">
            Der Kurs läuft komplett im Browser. Nur für das Snake-Projekt installierst du Python
            auf deinem Rechner.
          </p>
        </aside>

        <article className="ls-main ls-article">
          {children}

          <nav className="pk-pager" aria-label="Lektionen blättern">
            {prev ? (
              <Link className="pk-prev" href={`/python-kurs/${prev.slug}`}>
                <PfeilLinksIcon />
                <span>
                  <small>Zurück zu Lektion {prev.nr}</small>
                  <b>{anzeigeTitel(prev)}</b>
                </span>
              </Link>
            ) : (
              <Link className="pk-prev" href="/python-kurs">
                <PfeilLinksIcon />
                <span>
                  <small>Zurück</small>
                  <b>Kurs-Übersicht</b>
                </span>
              </Link>
            )}
            {next ? (
              <Link className="pk-next" href={`/python-kurs/${next.slug}`}>
                <span>
                  <small>Weiter mit Lektion {next.nr}</small>
                  <b>{anzeigeTitel(next)}</b>
                </span>
                <PfeilIcon />
              </Link>
            ) : (
              <Link className="pk-next" href="/python-kurs">
                <span>
                  <small>Kurs geschafft</small>
                  <b>Zur Kurs-Übersicht</b>
                </span>
                <PfeilIcon />
              </Link>
            )}
          </nav>
        </article>
      </div>
    </>
  );
}
