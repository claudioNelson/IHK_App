// help: Uebersicht aller Befehle des Uebungs-Terminals (auf Deutsch; das echte
// help der Bash listet nur die eingebauten Befehle auf Englisch).

import type { Befehl, Bereich } from "../typen";

const REIHENFOLGE: Bereich[] = ["Orientierung", "Dateien und Ordner", "Lesen und Suchen", "Rechte", "Verketten", "Allgemein"];

export const help: Befehl = {
  name: "help",
  bereich: "Allgemein",
  hilfe: {
    kurz: "zeigt alle Befehle, die das Übungs-Terminal kennt.",
    aufruf: "help",
  },
  lauf: ({ befehle }) => {
    const breite = Math.max(...REIHENFOLGE.map((b) => b.length));
    let t = "Befehle des Übungs-Terminals:\n\n";
    for (const bereich of REIHENFOLGE) {
      const namen = [...befehle.values()].filter((b) => b.bereich === bereich).map((b) => b.name);
      if (namen.length > 0) t += `  ${bereich.padEnd(breite)}   ${namen.join("  ")}\n`;
    }
    t += "\nMehr zu einem Befehl: man BEFEHL, zum Beispiel man ls\n";
    t += "Tasten: Pfeil hoch holt frühere Befehle zurück, Tab ergänzt Namen.\n";
    return { ausgabe: t, code: 0 };
  },
};
