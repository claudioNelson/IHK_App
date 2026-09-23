// Rahmen fuer alle Lernseiten unter /lernen: gemeinsamer Header und Footer
// (PageShell) plus die ls-Styles. Das Theme setzt bereits app/layout.tsx vor
// dem ersten Paint, deshalb hier kein eigenes Theme-Script mehr.

import type { ReactNode } from "react";
import PageShell from "../components/shell/PageShell";
import "./lernen.css";

export default function LernenLayout({ children }: { children: ReactNode }) {
  return <PageShell className="ls">{children}</PageShell>;
}
