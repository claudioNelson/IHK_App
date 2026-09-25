// Bausteine fuer die Lektionsseiten der Web-Kurse (Server-Komponenten),
// Markup nach kurs-design/mockup-lektion.html:
//
//   <Aufgabe nr="1.1">
//     <p>Aufgabentext</p>
//     <PythonRunner ... />
//     <Loesung code={`print("...")`} />
//   </Aufgabe>
//
//   <Loesung art="erklaerung"><p>...</p></Loesung>
//
//   <Zeichenaufgabe nr="3.1" loesung={<Diagramm />} bewertung={["...", "..."]}>
//     <p>Aufgabentext</p>
//   </Zeichenaufgabe>

import type { ReactNode } from "react";
import Link from "next/link";
import { MetaIcon, NoteIcon } from "../../lernen/_components/LsIcons";
import { DiagrammIcon, LoesungPlusIcon } from "./KursIcons";

/* ---- Uebung: Label, Aufgabentext, Runner und Loesung als Einheit ---- */

export function Aufgabe({
  nr,
  label,
  children,
}: {
  /** z. B. "1.1", ergibt Label "Übung 1.1" und die id fuer aria-labelledby */
  nr: string;
  /** Abweichendes Label, z. B. "Abschluss-Übung" */
  label?: string;
  children: ReactNode;
}) {
  const id = `uebung-${nr.replace(/\W+/g, "-")}`;
  return (
    <div className="pk-aufgabe" role="group" aria-labelledby={id}>
      <span className="pk-aufgabe-label" id={id}>
        {label ?? `Übung ${nr}`}
      </span>
      {children}
    </div>
  );
}

/* ---- Einklappbare Musterloesung oder Erklaerung ---- */

export function Loesung({
  art = "loesung",
  code,
  children,
}: {
  /** "loesung": Musterlösung (Code), "erklaerung": Erklärung (Text) */
  art?: "loesung" | "erklaerung";
  /** Loesungscode, wird als .ls-pre gesetzt */
  code?: string;
  /** Alternativ freier Inhalt, z. B. ein <p> */
  children?: ReactNode;
}) {
  const erklaerung = art === "erklaerung";
  return (
    <details className="pk-loesung">
      <summary>
        {erklaerung ? <NoteIcon name="idee" /> : <MetaIcon name="quiz" />}
        {erklaerung ? "Erklärung anzeigen" : "Musterlösung anzeigen"}
        <LoesungPlusIcon />
      </summary>
      {code !== undefined && (
        <pre className="ls-pre">
          <code>{code}</code>
        </pre>
      )}
      {children}
    </details>
  );
}

/* ---- Codeblock ohne Ausfuehren (z. B. Kommandozeile, Pseudocode) ---- */

export function CodeBlock({ code }: { code: string }) {
  return (
    <pre className="ls-pre">
      <code>{code}</code>
    </pre>
  );
}

/* ---- Zeichenaufgabe: auf Papier oder im Diagramm-Tool, Loesung mit Bewertung ---- */

export function Zeichenaufgabe({
  nr,
  loesung,
  erklaerung,
  bewertung,
  toolHinweis = true,
  children,
}: {
  /** z. B. "3.1", ergibt Label "Zeichenaufgabe 3.1" */
  nr: string;
  /** Musterloesung als Diagramm, z. B. eine SVG-Komponente */
  loesung: ReactNode;
  /** Optionaler Text zwischen Diagramm und Bewertung */
  erklaerung?: ReactNode;
  /** Stichpunkte "So wird typischerweise bewertet": wofuer es Punkte gibt */
  bewertung: ReactNode[];
  /** Hinweis mit Link auf das Diagramm-Tool in den Uebungspruefungen */
  toolHinweis?: boolean;
  /** Aufgabentext, am besten <p> */
  children: ReactNode;
}) {
  return (
    <Aufgabe nr={nr} label={`Zeichenaufgabe ${nr}`}>
      {children}
      {toolHinweis && (
        <p className="pk-tool-hinweis">
          <DiagrammIcon />
          <span>
            Zeichne auf Papier oder{" "}
            <Link href="/pruefungen">im Diagramm-Tool nachzeichnen</Link>: Es steckt in den
            Übungsprüfungen und öffnet sich dort bei jeder Zeichenaufgabe.
          </span>
        </p>
      )}
      <details className="pk-loesung">
        <summary>
          <MetaIcon name="quiz" />
          Musterlösung anzeigen
          <LoesungPlusIcon />
        </summary>
        <div className="pk-loesung-inhalt">
          {loesung}
          {erklaerung}
          <p className="pk-bewertung-titel">So wird typischerweise bewertet</p>
          <ul className="pk-bewertung">
            {bewertung.map((punkt, i) => (
              <li key={i}>{punkt}</li>
            ))}
          </ul>
        </div>
      </details>
    </Aufgabe>
  );
}
