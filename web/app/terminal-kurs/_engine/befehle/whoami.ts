// whoami: Name des aktuellen Benutzers.

import type { Befehl } from "../typen";

export const whoami: Befehl = {
  name: "whoami",
  bereich: "Allgemein",
  hilfe: {
    kurz: "zeigt, als welcher Benutzer du angemeldet bist.",
    aufruf: "whoami",
    beispiele: [["sudo whoami", "zeigt root: sudo führt Befehle als Administrator aus"]],
  },
  lauf: ({ args, zustand }) => {
    if (args.length > 0) {
      return {
        fehler: `whoami: extra operand ‘${args[0]}’\nTry 'whoami --help' for more information.\n`,
        hinweis: "Hinweis: whoami braucht keine Angaben, tippe einfach whoami.",
        code: 1,
      };
    }
    return { ausgabe: zustand.benutzer + "\n", code: 0 };
  },
};
