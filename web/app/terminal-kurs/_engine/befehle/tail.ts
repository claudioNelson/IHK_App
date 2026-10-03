// tail: die letzten Zeilen einer Datei (Standard 10). Bei Logdateien das
// wichtigste Werkzeug, weil das Neueste unten steht.

import type { Befehl } from "../typen";
import { kopfOderEnde } from "./head";

export const tail: Befehl = {
  name: "tail",
  bereich: "Lesen und Suchen",
  hilfe: {
    kurz: "zeigt das Ende einer Datei, normalerweise die letzten 10 Zeilen. Bei Logdateien steht dort das Neueste.",
    aufruf: "tail [OPTION] [DATEI …]",
    optionen: [
      ["-n ZAHL", "so viele Zeilen statt 10 (kurz: -ZAHL, etwa -3)"],
      ["-n +ZAHL", "ab dieser Zeile bis zum Ende"],
      ["-f", "offen bleiben und neue Zeilen zeigen (follow)"],
    ],
    beispiele: [
      ["tail /var/log/syslog", "die letzten 10 Zeilen"],
      ["tail -n 3 notizen.txt", "die letzten 3 Zeilen"],
    ],
  },
  lauf: (k) => kopfOderEnde(k, "tail", (zeilen, n, abStart) => (abStart ? zeilen.slice(Math.max(0, n - 1)) : n === 0 ? [] : zeilen.slice(-n))),
};
