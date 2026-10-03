// wc: Zeilen, Woerter und Bytes zaehlen (word count). Breite der Spalten wie
// GNU coreutils: nach der Gesamtgroesse der Dateien, bei stdin mindestens 7,
// bei nur einer Zahl und einer Quelle ohne Auffuellen.

import { zerlegeOptionen } from "../optionen";
import type { Befehl } from "../typen";
import { leseQuellen, wartetAufEingabe } from "./_lesen";

const bytes = (s: string) => new TextEncoder().encode(s).length;

export const wc: Befehl = {
  name: "wc",
  bereich: "Lesen und Suchen",
  hilfe: {
    kurz: "zählt Zeilen, Wörter und Bytes (word count).",
    aufruf: "wc [OPTION] [DATEI …]",
    optionen: [
      ["-l", "nur Zeilen zählen (lines)"],
      ["-w", "nur Wörter zählen (words)"],
      ["-c", "nur Bytes zählen"],
      ["-m", "nur Zeichen zählen"],
    ],
    beispiele: [
      ["wc -l /etc/passwd", "wie viele Benutzer gibt es?"],
      ["grep Failed auth.log | wc -l", "wie viele Fehlversuche?"],
    ],
  },
  lauf: (k) => {
    const o = zerlegeOptionen("wc", k.args, { flags: "lwcm", lang: { lines: "l", words: "w", bytes: "c", chars: "m" } });
    if (!o.ok) return o.fehler;
    if (o.rest.length === 0 && k.eingabe === null) return wartetAufEingabe("wc", "wc -l /etc/passwd");
    const g = leseQuellen(k, o.rest, (getippt, text) => `wc: ${getippt}: ${text}\n`);
    const f = o.flags;
    const spalten: ("l" | "w" | "m" | "c")[] = f.size === 0 ? ["l", "w", "c"] : (["l", "w", "m", "c"] as const).filter((s) => f.has(s));
    const zaehle = (t: string) => ({
      l: (t.match(/\n/g) ?? []).length,
      w: t.split(/\s+/).filter((x) => x !== "").length,
      m: [...t].length,
      c: bytes(t),
    });
    const zeilen = g.quellen.map((q) => ({ name: q.name, z: zaehle(q.inhalt), stdin: q.stdin }));
    const summe = { l: 0, w: 0, m: 0, c: 0 };
    for (const { z } of zeilen) for (const s of ["l", "w", "m", "c"] as const) summe[s] += z[s];
    let breite = 1;
    if (!(spalten.length === 1 && zeilen.length === 1)) {
      const mindestens = zeilen.some((x) => x.stdin) ? 7 : 1;
      breite = Math.max(mindestens, String(zeilen.reduce((n, x) => n + (x.stdin ? 0 : x.z.c), 0)).length);
    }
    const zeile = (z: Record<string, number>, name: string) =>
      spalten.map((s) => String(z[s]).padStart(breite)).join(" ") + (name ? ` ${name}` : "") + "\n";
    let aus = zeilen.map((x) => zeile(x.z, x.name)).join("");
    if (zeilen.length > 1) aus += zeile(summe, "total");
    return { ausgabe: aus, fehler: g.fehler, hinweis: g.fehler ? g.hinweis : undefined, code: g.fehler ? 1 : 0 };
  },
};
