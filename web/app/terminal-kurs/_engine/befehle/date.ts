// date: Datum und Uhrzeit (Server-Zeit in UTC wie auf den meisten Servern).
// Unterstuetzt date +FORMAT mit den gaengigen Platzhaltern.

import type { Befehl } from "../typen";
import { MONATE, TAGE, zwei } from "./_gemeinsam";

const LANGE_TAGE = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
const LANGE_MONATE = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

export function formatiereDatum(d: Date, format: string): string {
  const ersatz: Record<string, () => string> = {
    Y: () => String(d.getUTCFullYear()),
    y: () => zwei(d.getUTCFullYear() % 100),
    m: () => zwei(d.getUTCMonth() + 1),
    d: () => zwei(d.getUTCDate()),
    e: () => String(d.getUTCDate()).padStart(2, " "),
    H: () => zwei(d.getUTCHours()),
    M: () => zwei(d.getUTCMinutes()),
    S: () => zwei(d.getUTCSeconds()),
    a: () => TAGE[d.getUTCDay()],
    A: () => LANGE_TAGE[d.getUTCDay()],
    b: () => MONATE[d.getUTCMonth()],
    B: () => LANGE_MONATE[d.getUTCMonth()],
    Z: () => "UTC",
    F: () => `${d.getUTCFullYear()}-${zwei(d.getUTCMonth() + 1)}-${zwei(d.getUTCDate())}`,
    T: () => `${zwei(d.getUTCHours())}:${zwei(d.getUTCMinutes())}:${zwei(d.getUTCSeconds())}`,
    s: () => String(Math.floor(d.getTime() / 1000)),
    n: () => "\n",
    "%": () => "%",
  };
  let aus = "";
  for (let i = 0; i < format.length; i++) {
    if (format[i] === "%" && i + 1 < format.length && ersatz[format[i + 1]]) {
      aus += ersatz[format[i + 1]]();
      i++;
    } else aus += format[i];
  }
  return aus;
}

export const date: Befehl = {
  name: "date",
  bereich: "Allgemein",
  hilfe: {
    kurz: "zeigt Datum und Uhrzeit des Servers (hier in UTC, wie auf vielen Servern).",
    aufruf: "date [+FORMAT]",
    optionen: [
      ["+%F", "Datum als 2026-09-30"],
      ["+%T", "Uhrzeit als 14:05:09"],
      ["+%Y %m %d", "Jahr, Monat, Tag einzeln"],
    ],
    beispiele: [["date +%F", "gut für Dateinamen, zum Beispiel backup-2026-09-30"]],
  },
  lauf: ({ args, jetzt }) => {
    if (args.length === 0) return { ausgabe: formatiereDatum(jetzt, "%a %b %e %T %Z %Y") + "\n", code: 0 };
    if (args.length === 1 && args[0].startsWith("+")) return { ausgabe: formatiereDatum(jetzt, args[0].slice(1)) + "\n", code: 0 };
    if (args[0].startsWith("+")) {
      return {
        fehler: `date: extra operand ‘${args[1]}’\nTry 'date --help' for more information.\n`,
        hinweis: "Hinweis: date nimmt nur ein Format. Mehrere Platzhalter gehören zusammen, zum Beispiel date \"+%F %T\".",
        code: 1,
      };
    }
    return {
      fehler: `date: invalid date ‘${args.join(" ")}’\n`,
      hinweis: "Hinweis: Das Übungs-Terminal kennt date ohne Angaben oder mit einem Format wie date +%F.",
      code: 1,
    };
  },
};
