// clear: Bildschirm leeren (die Anzeige macht das, die Engine meldet es nur).

import type { Befehl } from "../typen";

export const clear: Befehl = {
  name: "clear",
  bereich: "Allgemein",
  hilfe: {
    kurz: "leert den Bildschirm. Tastenkürzel: Strg+L.",
    aufruf: "clear",
  },
  lauf: () => ({ leeren: true, code: 0 }),
};
