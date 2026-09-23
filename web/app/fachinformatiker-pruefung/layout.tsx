// Rahmen fuer den Pruefungs-Guide: gemeinsamer Header und Footer (PageShell)
// plus die ls-Styles der Lernseiten, weil der Guide mit LernSeite gebaut ist.
// Das Theme setzt bereits app/layout.tsx.

import type { ReactNode } from "react";
import PageShell from "../components/shell/PageShell";
import "../lernen/lernen.css";

export default function PruefungsGuideLayout({ children }: { children: ReactNode }) {
  return <PageShell className="ls">{children}</PageShell>;
}
