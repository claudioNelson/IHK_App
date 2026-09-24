// Zentrale Lektionsliste des UML-Kurses: gefuettert werden damit der Kursplan
// der Uebersichtsseite, die Kursplan-Seitenleiste, der Fortschritt und die
// Vor/Zurueck-Navigation der Lektionsseiten (ueber umlKurs).

import type { Kurs, Lektion } from "../../components/kurs/kurs-typen";

export const lektionen: Lektion[] = [
  { nr: 1, slug: "lektion-1", titel: "Warum UML in der Prüfung", untertitel: "Welche Diagramme die IHK abfragt und woran du in der Aufgabe erkennst, welches gemeint ist.", dauer: 10, projekt: false },
  { nr: 2, slug: "lektion-2", titel: "Use-Case-Diagramm", untertitel: "Akteure, Anwendungsfälle, Systemgrenze sowie include und extend.", dauer: 25, projekt: false },
  { nr: 3, slug: "lektion-3", titel: "Klassendiagramm I: Klassen und Beziehungen", untertitel: "Attribute, Methoden, Sichtbarkeit, Assoziationen und Multiplizitäten.", dauer: 30, projekt: false },
  { nr: 4, slug: "lektion-4", titel: "Klassendiagramm II: Vererbung, Komposition, Code", untertitel: "Vererbung, Aggregation, Komposition, abstrakte Klassen und der Weg vom Diagramm zum Code.", dauer: 30, projekt: false },
  { nr: 5, slug: "lektion-5", titel: "Aktivitätsdiagramm", untertitel: "Aktionen, Verzweigungen, Parallelität und Schwimmbahnen.", dauer: 25, projekt: false },
  { nr: 6, slug: "lektion-6", titel: "Sequenz- und Zustandsdiagramm", untertitel: "Nachrichten in zeitlicher Abfolge und Zustände mit ihren Übergängen.", dauer: 30, projekt: false },
  { nr: 7, slug: "lektion-7", titel: "Prüfungstraining", untertitel: "Komplette Aufgaben im IHK-Stil mit Musterlösung und Bewertung.", dauer: 85, projekt: true, marke: "Prüfung" },
];

export const umlKurs: Kurs = {
  slug: "uml-kurs",
  titel: "UML-Kurs",
  lektionen,
  lernort: { text: "Papier und Stift genügen", icon: "stift" },
  seitenNotiz:
    "Zeichne jede Aufgabe selbst, auf Papier oder im Diagramm-Tool der Übungsprüfungen. Erst danach klappst du die Lösung auf.",
};
