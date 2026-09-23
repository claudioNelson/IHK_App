// Bausteine fuer die Lektionsseiten (Server-Komponenten), Markup nach
// kurs-design/mockup-lektion.html:
//
//   <Aufgabe nr="1.1">
//     <p>Aufgabentext</p>
//     <PythonRunner ... />
//     <Loesung code={`print("...")`} />
//   </Aufgabe>
//
//   <Loesung art="erklaerung"><p>...</p></Loesung>

import type { ReactNode } from "react";
import { MetaIcon, NoteIcon } from "../../lernen/_components/LsIcons";
import { LoesungPlusIcon } from "./KursIcons";

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
