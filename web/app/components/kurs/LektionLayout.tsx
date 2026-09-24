// Gemeinsamer Rahmen fuer alle Lektionsseiten der Web-Kurse (Server-Komponente),
// nach kurs-design/mockup-lektion.html: Pfad, Fortschritt "Lektion n von N",
// Seitenkopf mit Meta-Zeile, links der Kursplan, rechts der Artikel und am
// Ende die Vor/Zurueck-Kacheln. Header und Footer kommen aus dem layout.tsx
// des jeweiligen Kurses (PageShell). Pfad-Basis, Pfad-Titel und Lektionen
// kommen aus dem Kurs-Objekt (kurs-typen.ts).
//
// children sind die Abschnitte der Lektion, am besten <LsAbschnitt>.

import type { ReactNode } from "react";
import Link from "next/link";
import { MetaIcon, PfeilIcon } from "../../lernen/_components/LsIcons";
import { BrowserIcon, PfeilLinksIcon, StiftIcon } from "./KursIcons";
import KursplanNav from "./KursplanNav";
import { anzeigeTitel, type Kurs } from "./kurs-typen";

export default function LektionLayout({
  kurs,
  nr,
  lead,
  uebungen,
  mitLoesung = true,
  lokal = false,
  aufgabenText,
  children,
}: {
  kurs: Kurs;
  nr: number;
  /** Vorspann unter der h1 */
  lead: ReactNode;
  /** Anzahl der Uebungen fuer die Meta-Zeile */
  uebungen: number;
  /** false, wenn die Uebungen keine Musterloesung haben */
  mitLoesung?: boolean;
  /** true, wenn die Lektion auf dem eigenen Rechner laeuft (Snake) */
  lokal?: boolean;
  /** Ersetzt den Uebungen-Text der Meta-Zeile, z. B. "4 Quizfragen" */
  aufgabenText?: string;
  children: ReactNode;
}) {
  const { lektionen } = kurs;
  const basis = `/${kurs.slug}`;
  const index = lektionen.findIndex((l) => l.nr === nr);
  const lektion = lektionen[index];
  const prev = index > 0 ? lektionen[index - 1] : undefined;
  const next = lektionen[index + 1];
  const gesamt = lektionen.length;

  const uebungenText =
    aufgabenText ??
    `${uebungen} ${uebungen === 1 ? "Übung" : "Übungen"}${mitLoesung ? " mit Lösung" : ""}`;

  return (
    <>
      <div className="wrap">
        <div className="page-head">
          <nav className="crumbs" aria-label="Pfad">
            <Link href="/">Lernarena</Link>
            <span aria-hidden="true">/</span>
            <Link href={basis}>{kurs.titel}</Link>
            <span aria-hidden="true">/</span>
            <span aria-current="page">Lektion {nr}</span>
          </nav>
          <div className="pk-progress">
            <span>
              <strong>Lektion {nr}</strong> von {gesamt}
            </span>
            <ol aria-hidden="true" style={{ gridTemplateColumns: `repeat(${gesamt}, 1fr)` }}>
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
              {kurs.lernort.icon === "stift" ? <StiftIcon /> : <BrowserIcon />}
              {lokal ? "Läuft auf deinem Rechner" : kurs.lernort.text}
            </li>
          </ul>
        </div>
      </div>

      <div className="wrap ls-layout">
        <aside className="ls-side" aria-label="Kursplan">
          <KursplanNav kurs={kurs} aktuell={nr} />
          <p className="ls-side-note">{kurs.seitenNotiz}</p>
        </aside>

        <article className="ls-main ls-article">
          {children}

          <nav className="pk-pager" aria-label="Lektionen blättern">
            {prev ? (
              <Link className="pk-prev" href={`${basis}/${prev.slug}`}>
                <PfeilLinksIcon />
                <span>
                  <small>Zurück zu Lektion {prev.nr}</small>
                  <b>{anzeigeTitel(prev)}</b>
                </span>
              </Link>
            ) : (
              <Link className="pk-prev" href={basis}>
                <PfeilLinksIcon />
                <span>
                  <small>Zurück</small>
                  <b>Kurs-Übersicht</b>
                </span>
              </Link>
            )}
            {next ? (
              <Link className="pk-next" href={`${basis}/${next.slug}`}>
                <span>
                  <small>Weiter mit Lektion {next.nr}</small>
                  <b>{anzeigeTitel(next)}</b>
                </span>
                <PfeilIcon />
              </Link>
            ) : (
              <Link className="pk-next" href={basis}>
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
