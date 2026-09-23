// Bausteine fuer den Artikelbereich der Lernseiten (Server-Komponenten).
// Markup und Klassen 1:1 nach lernen-design/mockup-thema.html.
//
//   <LsAbschnitt id="beispiel" titel="Beispiel Schritt für Schritt">...</LsAbschnitt>
//   <LsHinweis titel="Der schnellste Trick ist die Blockgröße"><p>...</p></LsHinweis>
//   <LsHinweis art="warnung" titel="Vier Stolperfallen"><ul>...</ul></LsHinweis>
//   <LsFaq eintraege={faq} />   (rendert auch das FAQPage-JSON-LD)
//   <LsCta titel="..." text="..." />

import type { ReactNode } from "react";
import Link from "next/link";
import { NoteIcon, PlusIcon, type NoteIconName } from "./LsIcons";

/* ---- Abschnitt mit h2 und Sprungmarken-Ziel ---- */

export function LsAbschnitt({
  id,
  titel,
  children,
}: {
  id: string;
  titel: ReactNode;
  children: ReactNode;
}) {
  return (
    <section id={id} aria-labelledby={`h-${id}`}>
      <h2 id={`h-${id}`}>{titel}</h2>
      {children}
    </section>
  );
}

/* ---- Hinweisbox: Tipp (Akzent) oder Warnung ---- */

export function LsHinweis({
  titel,
  art = "tipp",
  icon,
  label,
  children,
}: {
  titel: ReactNode;
  art?: "tipp" | "warnung";
  /** Standard: "idee" beim Tipp, "warnung" bei der Warnung */
  icon?: NoteIconName;
  /** aria-label der Box, Standard: "Tipp" bzw. "Warnung" */
  label?: string;
  /** Inhalt als <p> oder <ul>, wird in .ls-note-body gesetzt */
  children: ReactNode;
}) {
  const warn = art === "warnung";
  return (
    <aside
      className={warn ? "ls-note ls-note-warn" : "ls-note"}
      aria-label={label ?? (warn ? "Warnung" : "Tipp")}
    >
      <NoteIcon name={icon ?? (warn ? "warnung" : "idee")} />
      <p className="ls-note-title">{titel}</p>
      <div className="ls-note-body">{children}</div>
    </aside>
  );
}

/* ---- FAQ als Linienliste plus strukturierte Daten ---- */

export type FaqEintrag = { q: string; a: string };

export function LsFaq({ eintraege }: { eintraege: FaqEintrag[] }) {
  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    mainEntity: eintraege.map((f) => ({
      "@type": "Question",
      name: f.q,
      acceptedAnswer: { "@type": "Answer", text: f.a },
    })),
  };

  return (
    <>
      <script
        type="application/ld+json"
        // "<" maskieren, damit kein Text das Script-Tag beenden kann
        dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd).replace(/</g, "\\u003c") }}
      />
      <div className="ls-faq">
        {eintraege.map((f) => (
          <details key={f.q}>
            <summary>
              {f.q}
              <PlusIcon />
            </summary>
            <p>{f.a}</p>
          </details>
        ))}
      </div>
    </>
  );
}

/* ---- Abschluss-CTA ---- */

export const CTA_STANDARD = {
  titel: "Mehr als nur Theorie.",
  text: "In der Lernarena übst du alle Themen mit Aufgaben im IHK-Stil, sofortigem Feedback und der KI-Tutorin Ada, die dir jeden Schritt erklärt.",
};

export function LsCta({
  titel = CTA_STANDARD.titel,
  text = CTA_STANDARD.text,
}: {
  titel?: string;
  text?: string;
}) {
  return (
    <section className="ls-cta" aria-labelledby="h-cta">
      <div>
        <h2 id="h-cta">{titel}</h2>
        <p>{text}</p>
      </div>
      <div className="ls-cta-actions">
        <Link className="btn btn-primary" href="/signup">
          Jetzt kostenlos starten
        </Link>
        <Link className="btn btn-ghost" href="/pruefungen">
          Übungsprüfungen ansehen
        </Link>
      </div>
    </section>
  );
}
