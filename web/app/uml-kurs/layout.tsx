// Rahmen fuer den UML-Kurs (Uebersicht und alle Lektionen): gemeinsamer
// Header und Footer (PageShell), die ls-Styles der Lernseiten, die
// pk-Kursbausteine aus dem Python-Kurs und die Diagramm-Styles aus uml.css.

import type { ReactNode } from "react";
import PageShell from "../components/shell/PageShell";
import "../lernen/lernen.css";
import "../python-kurs/kurs.css";
import "./uml.css";

export default function UmlKursLayout({ children }: { children: ReactNode }) {
  return <PageShell className="ls pk">{children}</PageShell>;
}
