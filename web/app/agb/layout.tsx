// Rahmen fuer die Rechtsseite: gemeinsamer Header und Footer (PageShell)
// plus die ls-Styles, weil die Seite mit RechtSeite gebaut ist.
// Das Theme setzt bereits app/layout.tsx.

import type { ReactNode } from "react";
import PageShell from "../components/shell/PageShell";
import "../lernen/lernen.css";

export default function AgbLayout({ children }: { children: ReactNode }) {
  return <PageShell className="ls">{children}</PageShell>;
}
