// Laedt die Styles der Pruefungsseiten (Praefix ex-) fuer Intro, laufende
// Pruefung und Ergebnis. Die Datei liegt bei der Uebersicht.
import "../../pruefungen/pruefung.css";
import type { ReactNode } from "react";

export default function PruefungLayout({ children }: { children: ReactNode }) {
  return children;
}
