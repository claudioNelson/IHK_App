// Seitenrahmen einer Themenseite unter /lernen (Server-Komponente), nach
// lernen-design/mockup-thema.html: Pfad, Seitenkopf mit Meta-Zeile, links die
// Sprungmarken, rechts der Artikel, am Ende verwandte Themen und Abschluss-CTA.
// Header und Footer kommen aus app/lernen/layout.tsx (PageShell).
//
// children sind die Abschnitte des Artikels, am besten <LsAbschnitt>. Ihre ids
// muessen zu `abschnitte` passen. "Verwandte Themen" haengt LernSeite selbst an.

import type { ReactNode } from "react";
import Link from "next/link";
import LsToc, { type Abschnitt } from "./LsToc";
import { LsCta } from "./LsBausteine";
import { MetaIcon, PfeilIcon, type MetaIconName } from "./LsIcons";

export type { Abschnitt };
export type Verwandt = { href: string; titel: string; untertitel: string };
export type MetaEintrag = { icon: MetaIconName; text: string };

export default function LernSeite({
  titel,
  lead,
  pfad,
  eltern = { href: "/lernen", titel: "Lernseiten" },
  meta = [],
  abschnitte,
  seitenNotiz,
  verwandt = [],
  cta,
  children,
}: {
  /** h1 der Seite */
  titel: string;
  /** Vorspann unter der h1 */
  lead: ReactNode;
  /** Letzter Eintrag im Pfad, z. B. "Subnetting" */
  pfad: string;
  /** Mittlerer Pfad-Eintrag; null blendet ihn aus (z. B. Guide direkt unter Lernarena) */
  eltern?: { href: string; titel: string } | null;
  /** Meta-Zeile, z. B. [{ icon: "zeit", text: "Etwa 10 Minuten" }] */
  meta?: MetaEintrag[];
  /** Sprungmarken in der Seitenleiste, ids der <section>-Elemente */
  abschnitte: Abschnitt[];
  /** Optionaler Hinweis unter den Sprungmarken (nur Desktop) */
  seitenNotiz?: ReactNode;
  /** Kacheln unter "Verwandte Themen", am besten vier */
  verwandt?: Verwandt[];
  /** Abschluss-CTA, Standard: "Mehr als nur Theorie." */
  cta?: { titel?: string; text?: string };
  children: ReactNode;
}) {
  const toc: Abschnitt[] =
    verwandt.length > 0 ? [...abschnitte, { id: "verwandt", titel: "Verwandte Themen" }] : abschnitte;

  return (
    <>
      <div className="wrap">
        <div className="page-head">
          <nav className="crumbs" aria-label="Pfad">
            <Link href="/">Lernarena</Link>
            <span aria-hidden="true">/</span>
            {eltern && (
              <>
                <Link href={eltern.href}>{eltern.titel}</Link>
                <span aria-hidden="true">/</span>
              </>
            )}
            <span aria-current="page">{pfad}</span>
          </nav>
          <h1>{titel}</h1>
          <p className="lead">{lead}</p>
          {meta.length > 0 && (
            <ul className="ls-meta" aria-label="Auf einen Blick">
              {meta.map((m) => (
                <li key={m.text}>
                  <MetaIcon name={m.icon} />
                  {m.text}
                </li>
              ))}
            </ul>
          )}
        </div>
      </div>

      <div className="wrap ls-layout">
        <aside className="ls-side" aria-label="Inhalt dieser Seite">
          <LsToc titel="Auf dieser Seite" abschnitte={toc} />
          {seitenNotiz && <p className="ls-side-note">{seitenNotiz}</p>}
        </aside>

        <article className="ls-main ls-article">
          {children}

          {verwandt.length > 0 && (
            <section id="verwandt" aria-labelledby="h-verwandt">
              <h2 id="h-verwandt">Verwandte Themen</h2>
              <ul className="ls-related">
                {verwandt.map((v) => (
                  <li key={v.href}>
                    <Link href={v.href}>
                      <span>
                        {v.titel}
                        <small>{v.untertitel}</small>
                      </span>
                      <PfeilIcon />
                    </Link>
                  </li>
                ))}
              </ul>
            </section>
          )}

          <LsCta titel={cta?.titel} text={cta?.text} />
        </article>
      </div>
    </>
  );
}
