// cut: Spalten aus Zeilen ausschneiden, z. B. Benutzernamen aus /etc/passwd.

import { zerlegeOptionen } from "../optionen";
import type { Befehl } from "../typen";
import { leseQuellen, wartetAufEingabe, zeilenVon } from "./_lesen";

/** Liste wie "1,3" oder "2-4" oder "3-" in eine Pruef-Funktion umsetzen. */
function liste(text: string): ((n: number) => boolean) | string {
  const teile = text.split(",");
  const bereiche: [number, number][] = [];
  for (const t of teile) {
    const m = /^(\d*)(-?)(\d*)$/.exec(t);
    if (!m || t === "" || t === "-") return `invalid field range`;
    const a = m[1] === "" ? 1 : Number(m[1]);
    const b = m[2] === "" ? a : m[3] === "" ? Infinity : Number(m[3]);
    if (a < 1 || b < 1) return "fields are numbered from 1";
    if (b < a) return "invalid decreasing range";
    bereiche.push([a, b]);
  }
  return (n) => bereiche.some(([a, b]) => n >= a && n <= b);
}

export const cut: Befehl = {
  name: "cut",
  bereich: "Verketten",
  hilfe: {
    kurz: "schneidet Spalten aus jeder Zeile aus.",
    aufruf: "cut OPTION [DATEI …]",
    optionen: [
      ["-d ZEICHEN", "Trennzeichen zwischen den Spalten (Standard: Tabulator)"],
      ["-f LISTE", "diese Spalten (fields), z. B. 1 oder 1,3 oder 2-4"],
      ["-c LISTE", "diese Zeichen, z. B. 1-8"],
    ],
    beispiele: [
      ["cut -d: -f1 /etc/passwd", "nur die Benutzernamen"],
      ["cut -d, -f2,3 liste.csv", "Spalte 2 und 3 einer CSV-Datei"],
    ],
  },
  lauf: (k) => {
    const o = zerlegeOptionen("cut", k.args, { flags: "s", mitWert: "dfcb", lang: { delimiter: "d", fields: "f", characters: "c", bytes: "b", "only-delimited": "s" } });
    if (!o.ok) return o.fehler;
    const feld = o.werte.get("f");
    const zeichen = o.werte.get("c") ?? o.werte.get("b");
    if (feld === undefined && zeichen === undefined) {
      return {
        fehler: "cut: you must specify a list of bytes, characters, or fields\nTry 'cut --help' for more information.\n",
        hinweis: "Hinweis: cut braucht -f mit der Spaltennummer (und meist -d mit dem Trennzeichen), zum Beispiel cut -d: -f1 /etc/passwd.",
        code: 1,
      };
    }
    const trenner = o.werte.get("d") ?? "\t";
    if ([...trenner].length !== 1) {
      return { fehler: "cut: the delimiter must be a single character\nTry 'cut --help' for more information.\n", hinweis: "Hinweis: Hinter -d gehört genau ein Zeichen, zum Beispiel -d: oder -d,", code: 1 };
    }
    const auswahl = liste(feld ?? (zeichen as string));
    if (typeof auswahl === "string") {
      return { fehler: `cut: ${auswahl}\nTry 'cut --help' for more information.\n`, hinweis: "Hinweis: Spalten zählen ab 1. Erlaubt sind etwa 1, 1,3 oder 2-4.", code: 1 };
    }
    if (o.rest.length === 0 && k.eingabe === null) return wartetAufEingabe("cut", "cut -d: -f1 /etc/passwd");
    const g = leseQuellen(k, o.rest, (getippt, text) => `cut: ${getippt}: ${text}\n`);
    const aus = g.quellen
      .flatMap((q) => zeilenVon(q.inhalt))
      .flatMap((zeile) => {
        if (feld === undefined) return [[...zeile].filter((_, i) => auswahl(i + 1)).join("")];
        if (!zeile.includes(trenner)) return o.flags.has("s") ? [] : [zeile];
        return [zeile.split(trenner).filter((_, i) => auswahl(i + 1)).join(trenner)];
      })
      .map((z) => z + "\n")
      .join("");
    return { ausgabe: aus, fehler: g.fehler, hinweis: g.fehler ? g.hinweis : undefined, code: g.fehler ? 1 : 0 };
  },
};
