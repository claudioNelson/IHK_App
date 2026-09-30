// pwd: aktuellen Ordner ausgeben (print working directory).

import type { Befehl } from "../typen";

export const pwd: Befehl = {
  name: "pwd",
  bereich: "Orientierung",
  hilfe: {
    kurz: "zeigt, in welchem Ordner du gerade bist (print working directory).",
    aufruf: "pwd",
  },
  lauf: ({ zustand }) => ({ ausgabe: zustand.cwd + "\n", code: 0 }),
};
