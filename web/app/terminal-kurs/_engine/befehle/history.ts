// history: bisher eingegebene Befehle mit Nummer.

import type { Befehl } from "../typen";

export const history: Befehl = {
  name: "history",
  bereich: "Allgemein",
  hilfe: {
    kurz: "zeigt die zuletzt eingegebenen Befehle. Mit Pfeil hoch holst du sie zurück.",
    aufruf: "history [ANZAHL]",
    optionen: [["-c", "Verlauf löschen"]],
    beispiele: [["history 5", "die letzten fünf Befehle"]],
  },
  lauf: ({ args, zustand }) => {
    if (args[0] === "-c") return { zustand: { ...zustand, verlauf: [] }, code: 0 };
    if (args[0]?.startsWith("-") && args[0] !== "--") {
      return {
        fehler: `bash: history: ${args[0]}: invalid option\nhistory: usage: history [-c] [-d offset] [n] or history -anrw [filename] or history -ps arg [arg...]\n`,
        hinweis: "Hinweis: Für die letzten Befehle schreibst du die Zahl ohne Minus, zum Beispiel history 5.",
        code: 2,
      };
    }
    let liste = zustand.verlauf.map((zeile, i) => ({ nr: i + 1, zeile }));
    if (args.length > 0) {
      const n = Number(args[0]);
      if (!/^\d+$/.test(args[0])) {
        return {
          fehler: `bash: history: ${args[0]}: numeric argument required\n`,
          hinweis: "Hinweis: history versteht eine Zahl, zum Beispiel history 5.",
          code: 1,
        };
      }
      liste = n === 0 ? [] : liste.slice(-n);
    }
    return { ausgabe: liste.map(({ nr, zeile }) => `${String(nr).padStart(5)}  ${zeile}\n`).join(""), code: 0 };
  },
};
