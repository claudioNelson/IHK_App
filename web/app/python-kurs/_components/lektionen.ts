// Zentrale Lektionsliste: gefüttert werden damit die Übersichtsseite
// (Kursplan-Kacheln) und die Vor/Zurück-Navigation der Lektionsseiten.

export type Lektion = {
  nr: number;
  slug: string;
  titel: string;
  status: "live" | "bald";
};

export const lektionen: Lektion[] = [
  { nr: 1, slug: "lektion-1", titel: "Start & erster Code", status: "live" },
  { nr: 2, slug: "lektion-2", titel: "Variablen & Datentypen", status: "live" },
  { nr: 3, slug: "lektion-3", titel: "Rechnen & Strings", status: "live" },
  { nr: 4, slug: "lektion-4", titel: "Entscheidungen (if/else)", status: "live" },
  { nr: 5, slug: "lektion-5", titel: "Schleifen", status: "live" },
  { nr: 6, slug: "lektion-6", titel: "🎮 Projekt: Zahlenraten", status: "live" },
  { nr: 7, slug: "lektion-7", titel: "Listen & Dictionaries", status: "bald" },
  { nr: 8, slug: "lektion-8", titel: "Funktionen", status: "bald" },
  { nr: 9, slug: "lektion-9", titel: "Fehler & Debugging", status: "bald" },
  { nr: 10, slug: "lektion-10", titel: "Klassen-Basics (OOP)", status: "bald" },
  { nr: 11, slug: "lektion-11", titel: "🎮 Projekt: Snake", status: "bald" },
  { nr: 12, slug: "lektion-12", titel: "Abschluss & IHK-Pseudocode", status: "bald" },
];
