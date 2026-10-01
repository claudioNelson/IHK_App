// Rahmen fuer den Terminal-Kurs (Uebersicht und alle Lektionen): gemeinsamer
// Header und Footer (PageShell), die ls-Styles der Lernseiten, die
// pk-Kursbausteine aus dem Python-Kurs und die tk-Styles aus terminal.css.
//
// Solange der Kurs im Aufbau ist, sollen Suchmaschinen ihn nicht aufnehmen
// (robots noindex). Beim Start des Kurses (Einbindung in /kurse und Sitemap)
// die Zeile mit robots entfernen.

import type { Metadata } from "next";
import type { ReactNode } from "react";
import PageShell from "../components/shell/PageShell";
import "../lernen/lernen.css";
import "../python-kurs/kurs.css";
import "./terminal.css";

export const metadata: Metadata = {
  robots: { index: false, follow: false },
};

export default function TerminalKursLayout({ children }: { children: ReactNode }) {
  return <PageShell className="ls pk tk-kurs">{children}</PageShell>;
}
