// Zentrale Lektionsliste: gefuettert werden damit der Kursplan der
// Uebersichtsseite, die Kursplan-Seitenleiste, der Fortschritt und die
// Vor/Zurueck-Navigation der Lektionsseiten.

import { anzeigeTitel, nrText, type Kurs, type Lektion } from "../../components/kurs/kurs-typen";

// Typ und Helfer liegen seit dem UML-Kurs in app/components/kurs/kurs-typen.ts;
// hier weiter exportiert, damit bestehende Importe gleich bleiben.
export { anzeigeTitel, nrText };
export type { Lektion };

export const lektionen: Lektion[] = [
  { nr: 1, slug: "lektion-1", titel: "Start und erster Code", untertitel: "print(), Strings und deine ersten Rechnungen.", dauer: 10, projekt: false },
  { nr: 2, slug: "lektion-2", titel: "Variablen und Datentypen", untertitel: "str, int, float, bool und Eingaben mit input().", dauer: 15, projekt: false },
  { nr: 3, slug: "lektion-3", titel: "Rechnen und Strings", untertitel: "Division, Ganzzahl-Division, Modulo und f-Strings.", dauer: 15, projekt: false },
  { nr: 4, slug: "lektion-4", titel: "Entscheidungen (if/else)", untertitel: "if, elif, else und Vergleiche, am IHK-Notenschlüssel erklärt.", dauer: 20, projekt: false },
  { nr: 5, slug: "lektion-5", titel: "Schleifen", untertitel: "for mit range(), while und break.", dauer: 20, projekt: false },
  { nr: 6, slug: "lektion-6", titel: "Zahlenraten", untertitel: "Dein erstes Spiel mit random, while und break, direkt im Browser spielbar.", dauer: 25, projekt: true },
  { nr: 7, slug: "lektion-7", titel: "Listen und Dictionaries", untertitel: "Anlegen, durchlaufen und ändern.", dauer: 20, projekt: false },
  { nr: 8, slug: "lektion-8", titel: "Funktionen", untertitel: "def, Parameter, return und warum Funktionen Code besser machen.", dauer: 20, projekt: false },
  { nr: 9, slug: "lektion-9", titel: "Fehler und Debugging", untertitel: "Tracebacks lesen, typische Fehler verstehen, try und except.", dauer: 15, projekt: false },
  { nr: 10, slug: "lektion-10", titel: "Klassen-Basics (OOP)", untertitel: "Klassen, Objekte, Methoden und Vererbung, mit Bezug zum UML-Klassendiagramm.", dauer: 25, projekt: false },
  { nr: 11, slug: "lektion-11", titel: "Snake", untertitel: "Python auf deinem Rechner installieren und ein komplettes Snake-Spiel bauen.", dauer: 60, projekt: true },
  { nr: 12, slug: "lektion-12", titel: "Abschluss und IHK-Pseudocode", untertitel: "Vom Python-Code zum Pseudocode der Prüfung, plus dein Fahrplan danach.", dauer: 20, projekt: false },
];

export const pythonKurs: Kurs = {
  slug: "python-kurs",
  titel: "Python-Kurs",
  lektionen,
  lernort: { text: "Läuft im Browser", icon: "browser" },
  seitenNotiz:
    "Der Kurs läuft komplett im Browser. Nur für das Snake-Projekt installierst du Python auf deinem Rechner.",
};
