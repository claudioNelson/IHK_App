// Zentrale Lektionsliste des Struktogramm-Kurses: Kursplan der Uebersicht,
// Seitenleiste, Fortschritt und Vor/Zurueck-Navigation (ueber struktogrammKurs).

import type { Kurs, Lektion } from "../../components/kurs/kurs-typen";

export const lektionen: Lektion[] = [
  { nr: 1, slug: "lektion-1", titel: "Struktogramm und Pseudocode in der Prüfung", untertitel: "Was die Prüfung erwartet, welche Schreibweise der Kurs nutzt und wie du ein Struktogramm liest.", dauer: 15, projekt: false },
  { nr: 2, slug: "lektion-2", titel: "Sequenz, Verzweigung und Operatoren", untertitel: "Anweisungen der Reihe nach, ein- und zweiseitige Auswahl, Vergleiche, UND/ODER, DIV und MOD.", dauer: 30, projekt: false },
  { nr: 3, slug: "lektion-3", titel: "Schleifen", untertitel: "Kopfgesteuert, fußgesteuert, Zählschleife: wann welche, und wie du Durchläufe zählst.", dauer: 25, projekt: false },
  { nr: 4, slug: "lektion-4", titel: "Mehrfachauswahl, Verschachtelung, Schreibtischtest", untertitel: "Mehrfachauswahl, Blöcke in Blöcken und der Schreibtischtest bei verschachtelten Abläufen.", dauer: 30, projekt: false },
  { nr: 5, slug: "lektion-5", titel: "Felder und die Grundmuster", untertitel: "Summe, Durchschnitt, Maximum mit Index, Zählen und lineare Suche über ein Feld.", dauer: 35, projekt: false },
  { nr: 6, slug: "lektion-6", titel: "Tauschen, Sortieren, Unterprogramme", untertitel: "Zwei Werte tauschen, Bubblesort, Funktionen mit Parametern und Rückgabe, Lücken ergänzen.", dauer: 40, projekt: false },
  { nr: 7, slug: "lektion-7", titel: "Pseudocode und Python", untertitel: "Zusatz: Struktogramme in Python übersetzen und im Browser laufen lassen.", dauer: 20, projekt: false },
  { nr: 8, slug: "lektion-8", titel: "Prüfungstraining", untertitel: "Drei Aufgaben im Prüfungsstil: Schreibtischtest, Ergänzen, Entwerfen. Mit Musterlösungen und typischer Bewertung.", dauer: 75, projekt: true, marke: "Prüfung" },
];

export const struktogrammKurs: Kurs = {
  slug: "struktogramm-kurs",
  titel: "Struktogramm-Kurs",
  lektionen,
  lernort: { text: "Papier und Stift genügen", icon: "stift" },
  seitenNotiz:
    "Zeichne jedes Struktogramm selbst, bevor du die Lösung aufklappst. Die Form muss stimmen: Verzweigung mit Dreieck, Schleife mit Balken, Schlüsselwort solange oder bis an der Bedingung.",
};
