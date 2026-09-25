// Rahmen fuer den Struktogramm-Kurs (Uebersicht und alle Lektionen):
// gemeinsamer Header und Footer (PageShell), die ls-Styles der Lernseiten,
// die pk-Kursbausteine aus dem Python-Kurs und die sg-Styles aus
// struktogramm.css.

import type { ReactNode } from "react";
import PageShell from "../components/shell/PageShell";
import "../lernen/lernen.css";
import "../python-kurs/kurs.css";
import "./struktogramm.css";

export default function StruktogrammKursLayout({ children }: { children: ReactNode }) {
  return <PageShell className="ls pk">{children}</PageShell>;
}
