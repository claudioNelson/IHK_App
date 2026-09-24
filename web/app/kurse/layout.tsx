// Rahmen fuer die Kursuebersicht /kurse: gemeinsamer Header und Footer
// (PageShell), die ls-Styles der Lernseiten und die Kartenstyles aus kurse.css.

import type { ReactNode } from "react";
import PageShell from "../components/shell/PageShell";
import "../lernen/lernen.css";
import "./kurse.css";

export default function KurseLayout({ children }: { children: ReactNode }) {
  return <PageShell className="ls">{children}</PageShell>;
}
