// Seitenrahmen der Rechtsseiten (Impressum, Datenschutz, AGB), Server-Komponente.
// Gleicher Aufbau wie LernSeite (Pfad, Seitenkopf, links Sprungmarken, rechts
// Artikel), aber ohne Meta-Zeile, verwandte Themen und CTA.
// Header, Footer und die ls-Styles kommen aus dem layout.tsx der jeweiligen
// Route (PageShell plus lernen.css).
//
// children sind die Abschnitte, am besten <LsAbschnitt>. Ihre ids muessen zu
// `abschnitte` passen, sonst laufen die Sprungmarken ins Leere.

import type { ReactNode } from "react";
import Link from "next/link";
import LsToc, { type Abschnitt } from "../lernen/_components/LsToc";

export type { Abschnitt };

// Rechtstexte reihen Absaetze und Listen direkt aneinander. lernen.css setzt
// nur p + p auf Abstand (die Lernseiten brauchen mehr nicht), deshalb hier
// die fehlenden Abstaende, beschraenkt auf .ls-recht. React 19 zieht das
// <style> per href/precedence in den <head> und dedupliziert es.
const RECHT_CSS = `
.ls-recht :is(p, ul, .ls-note) + :is(p, ul) { margin-top: 14px; }
.ls-recht > section > h2 + h3 { margin-top: 0; }
`;

export default function RechtSeite({
  titel,
  untertitel,
  pfad,
  abschnitte,
  children,
}: {
  /** h1 der Seite */
  titel: string;
  /** Vorspann unter der h1, z. B. "Zuletzt aktualisiert: ..." */
  untertitel: ReactNode;
  /** Letzter Eintrag im Pfad, Standard: titel */
  pfad?: string;
  /** Sprungmarken in der Seitenleiste, ids der <section>-Elemente */
  abschnitte: Abschnitt[];
  children: ReactNode;
}) {
  return (
    <>
      <style href="ls-recht" precedence="default">
        {RECHT_CSS}
      </style>

      <div className="wrap">
        <div className="page-head">
          <nav className="crumbs" aria-label="Pfad">
            <Link href="/">Lernarena</Link>
            <span aria-hidden="true">/</span>
            <span aria-current="page">{pfad ?? titel}</span>
          </nav>
          <h1>{titel}</h1>
          <p className="lead">{untertitel}</p>
        </div>
      </div>

      <div className="wrap ls-layout">
        <aside className="ls-side" aria-label="Inhalt dieser Seite">
          <LsToc titel="Inhalt" abschnitte={abschnitte} />
        </aside>

        <article className="ls-main ls-article ls-recht">{children}</article>
      </div>
    </>
  );
}
