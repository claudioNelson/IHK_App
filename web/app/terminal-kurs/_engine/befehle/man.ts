// man: deutsche Kurzhilfe eines Befehls.

import { kurzhilfe } from "../kurzhilfe";
import type { Befehl } from "../typen";

export const man: Befehl = {
  name: "man",
  bereich: "Allgemein",
  hilfe: {
    kurz: "zeigt die Anleitung zu einem Befehl.",
    aufruf: "man BEFEHL",
    beispiele: [["man ls", "Anleitung zu ls"]],
  },
  lauf: ({ args, befehle }) => {
    if (args.length === 0) {
      return {
        fehler: "What manual page do you want?\nFor example, try 'man man'.\n",
        hinweis: "Hinweis: Hinter man gehört der Name eines Befehls, zum Beispiel man ls.",
        code: 1,
      };
    }
    let ausgabe = "";
    let fehler = "";
    for (const name of args) {
      const b = befehle.get(name);
      if (b) ausgabe += (ausgabe ? "\n" : "") + kurzhilfe(b);
      else fehler += `No manual entry for ${name}\n`;
    }
    return {
      ausgabe,
      fehler,
      hinweis: fehler ? "Hinweis: Zu diesem Namen gibt es im Übungs-Terminal keine Anleitung. Tippe help für alle Befehle." : undefined,
      code: fehler ? 16 : 0,
    };
  },
};
