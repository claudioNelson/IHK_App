// Rahmen fuer den Python-Kurs (Uebersicht und alle Lektionen): gemeinsamer
// Header und Footer (PageShell) plus die ls-Styles der Lernseiten und die
// pk-Ergaenzungen aus kurs.css. Das Theme setzt bereits app/layout.tsx.

import type { ReactNode } from "react";
import PageShell from "../components/shell/PageShell";
import "../lernen/lernen.css";
import "./kurs.css";

export default function PythonKursLayout({ children }: { children: ReactNode }) {
  return <PageShell className="ls pk">{children}</PageShell>;
}
