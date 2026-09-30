// sudo: Befehl als root ausfuehren. Die eigentliche Arbeit macht shell.ts
// (sudo startet einen anderen Befehl); dieser Eintrag liefert Hilfe und den
// Eintrag in help und /usr/bin.

import type { Befehl } from "../typen";

export const sudo: Befehl = {
  name: "sudo",
  bereich: "Rechte",
  hilfe: {
    kurz: "führt einen Befehl mit Administratorrechten (als root) aus. Im Übungs-Terminal ohne Passwortabfrage.",
    aufruf: "sudo BEFEHL",
    beispiele: [
      ["sudo ls /root", "den Ordner des Administrators ansehen"],
      ["sudo whoami", "zeigt root"],
    ],
  },
  lauf: () => ({ fehler: "usage: sudo command\n", code: 1 }),
};
