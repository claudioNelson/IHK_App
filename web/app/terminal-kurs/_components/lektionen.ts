// Zentrale Lektionsliste des Terminal-Kurses: Kursplan der Uebersicht,
// Seitenleiste, Fortschritt und Vor/Zurueck-Navigation (ueber terminalKurs).
// In "lektionen" stehen nur Lektionen, die es schon gibt; die geplanten
// zeigt die Uebersicht separat, damit keine Links ins Leere fuehren.

import type { Kurs, Lektion } from "../../components/kurs/kurs-typen";

export const lektionen: Lektion[] = [
  { nr: 1, slug: "lektion-1", titel: "Was ist ein Terminal?", untertitel: "Die Eingabeaufforderung lesen, erste Befehle, Befehl, Option und Argument, Hilfe holen.", dauer: 25, projekt: false },
  { nr: 2, slug: "lektion-2", titel: "Im Dateisystem bewegen", untertitel: "pwd, cd, ls und tree, absolute und relative Pfade, der Home-Ordner und die wichtigsten Linux-Ordner.", dauer: 30, projekt: false },
];

/** Geplante Lektionen des ersten Wurfs (Linux-Grundlagen), noch ohne Seite. */
export const geplant: { nr: number; titel: string; untertitel: string }[] = [
  { nr: 3, titel: "Dateien und Ordner", untertitel: "Anlegen, kopieren, verschieben, umbenennen und löschen mit mkdir, touch, cp, mv und rm." },
  { nr: 4, titel: "Dateien lesen und durchsuchen", untertitel: "cat, less, head, tail und grep: Logdateien lesen und Fehler finden." },
  { nr: 5, titel: "Benutzer und Rechte", untertitel: "ls -l lesen, chmod mit 755 und 644, chown und sudo." },
  { nr: 6, titel: "Pipes und Umleitung", untertitel: "Befehle verketten mit |, Ausgaben in Dateien schreiben mit > und >>, Fehler umleiten mit 2>." },
];

export const terminalKurs: Kurs = {
  slug: "terminal-kurs",
  titel: "Terminal-Kurs",
  lektionen,
  lernort: { text: "Terminal im Browser", icon: "browser" },
  seitenNotiz:
    "Tippe jeden Befehl selbst ins Übungs-Terminal, auch wenn du ihn schon kennst. Kaputt machen kannst du nichts: „Zurücksetzen“ stellt alles wieder her.",
};
