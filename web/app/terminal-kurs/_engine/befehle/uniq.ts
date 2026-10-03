// uniq: aufeinanderfolgende doppelte Zeilen zusammenfassen. Meist nach sort,
// weil uniq nur direkt untereinander stehende Zeilen vergleicht.

import { zerlegeOptionen } from "../optionen";
import type { Befehl } from "../typen";
import { leseQuellen, wartetAufEingabe, zeilenVon } from "./_lesen";

export const uniq: Befehl = {
  name: "uniq",
  bereich: "Verketten",
  hilfe: {
    kurz: "fasst gleiche Zeilen zusammen, die direkt untereinander stehen. Deshalb meist nach sort.",
    aufruf: "uniq [OPTION] [DATEI]",
    optionen: [
      ["-c", "davor schreiben, wie oft die Zeile vorkam (count)"],
      ["-d", "nur Zeilen, die mehrfach vorkommen"],
      ["-i", "Groß- und Kleinschreibung egal"],
    ],
    beispiele: [["sort ips.txt | uniq -c", "jede Zeile einmal, mit Anzahl"]],
  },
  lauf: (k) => {
    const o = zerlegeOptionen("uniq", k.args, { flags: "cdi", lang: { count: "c", repeated: "d", "ignore-case": "i" } });
    if (!o.ok) return o.fehler;
    if (o.rest.length > 1) {
      return { fehler: `uniq: extra operand '${o.rest[1]}'\nTry 'uniq --help' for more information.\n`, hinweis: "Hinweis: uniq liest nur eine Datei. Ein zweiter Name wäre die Ausgabedatei, das unterstützt das Übungs-Terminal nicht.", code: 1 };
    }
    if (o.rest.length === 0 && k.eingabe === null) return wartetAufEingabe("uniq", "sort namen.txt | uniq");
    const g = leseQuellen(k, o.rest, (getippt, text) => `uniq: ${getippt}: ${text}\n`);
    if (g.fehler) return { fehler: g.fehler, hinweis: g.hinweis, code: 1 };
    const zeilen = g.quellen.flatMap((q) => zeilenVon(q.inhalt));
    const gleich = (a: string, b: string) => (o.flags.has("i") ? a.toLowerCase() === b.toLowerCase() : a === b);
    const gruppen: { zeile: string; n: number }[] = [];
    for (const z of zeilen) {
      const letzte = gruppen[gruppen.length - 1];
      if (letzte && gleich(letzte.zeile, z)) letzte.n++;
      else gruppen.push({ zeile: z, n: 1 });
    }
    const aus = gruppen
      .filter((gr) => !o.flags.has("d") || gr.n > 1)
      .map((gr) => (o.flags.has("c") ? `${String(gr.n).padStart(7)} ${gr.zeile}\n` : `${gr.zeile}\n`))
      .join("");
    return { ausgabe: aus, code: 0 };
  },
};
