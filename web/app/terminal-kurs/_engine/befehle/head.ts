// head: die ersten Zeilen einer Datei (Standard 10).

import { zerlegeOptionen } from "../optionen";
import type { Befehl, BefehlErgebnis, Kontext } from "../typen";
import { alsText, leseQuellen, wartetAufEingabe, zahlAlsOption, zeilenVon } from "./_lesen";

/** Gemeinsamer Ablauf von head und tail: Optionen, Dateien, Ueberschriften "==> datei <==". */
export function kopfOderEnde(k: Kontext, name: "head" | "tail", schneide: (zeilen: string[], n: number, abStart: boolean) => string[]): BefehlErgebnis {
  const o = zerlegeOptionen(name, zahlAlsOption(k.args), {
    flags: name === "tail" ? "qvf" : "qv",
    mitWert: "n",
    lang: { lines: "n", quiet: "q", silent: "q", verbose: "v", ...(name === "tail" ? { follow: "f" } : {}) },
  });
  if (!o.ok) return o.fehler;
  let n = 10;
  let abStart = false;
  const roh = o.werte.get("n");
  if (roh !== undefined) {
    abStart = name === "tail" && roh.startsWith("+");
    const zahl = Number(roh.replace(/^[+]/, ""));
    if (/^-\d+$/.test(roh)) {
      return {
        fehler: "",
        hinweis: `Hinweis: Eine negative Anzahl wie -n ${roh} (alles außer den letzten Zeilen) kennt das Übungs-Terminal nicht. Probier ${name} -n ${roh.slice(1)}.`,
        code: 1,
      };
    }
    if (!/^[+]?\d+$/.test(roh) || !Number.isFinite(zahl)) {
      return {
        fehler: `${name}: invalid number of lines: '${roh}'\n`,
        hinweis: `Hinweis: Hinter -n gehört eine Anzahl von Zeilen, zum Beispiel ${name} -n 5 datei.txt.`,
        code: 1,
      };
    }
    n = zahl;
  }
  if (o.rest.length === 0 && k.eingabe === null) return wartetAufEingabe(name, `${name} -n 5 /etc/passwd`);
  const g = leseQuellen(k, o.rest, (getippt, text, istOrdner) =>
    istOrdner ? `${name}: error reading '${getippt}': ${text}\n` : `${name}: cannot open '${getippt}' for reading: ${text}\n`,
  );
  const mitKopf = (o.rest.length > 1 || o.flags.has("v")) && !o.flags.has("q");
  let aus = "";
  g.quellen.forEach((q, i) => {
    if (mitKopf) aus += `${i > 0 ? "\n" : ""}==> ${q.stdin ? "standard input" : q.name} <==\n`;
    const zeilen = zeilenVon(q.inhalt);
    const teil = schneide(zeilen, n, abStart);
    // Fehlt am Dateiende das \n, bleibt es auch in der Ausgabe weg (wie echt)
    const letzteZeileOhneUmbruch = q.inhalt !== "" && !q.inhalt.endsWith("\n") && teil.length > 0 && teil[teil.length - 1] === zeilen[zeilen.length - 1] && (name === "tail" || teil.length === zeilen.length);
    aus += letzteZeileOhneUmbruch ? alsText(teil).slice(0, -1) : alsText(teil);
  });
  const hinweisF =
    name === "tail" && o.flags.has("f")
      ? "Hinweis: Auf einem echten Server bleibt tail -f offen und zeigt neue Zeilen, sobald sie dazukommen. Beenden mit Strg+C. Im Übungs-Terminal kommt nichts nach."
      : undefined;
  return {
    ausgabe: aus,
    fehler: g.fehler,
    hinweis: g.fehler ? g.hinweis : hinweisF,
    code: g.fehler ? 1 : 0,
  };
}

export const head: Befehl = {
  name: "head",
  bereich: "Lesen und Suchen",
  hilfe: {
    kurz: "zeigt den Anfang einer Datei, normalerweise die ersten 10 Zeilen.",
    aufruf: "head [OPTION] [DATEI …]",
    optionen: [["-n ZAHL", "so viele Zeilen statt 10 (kurz: -ZAHL, etwa -3)"]],
    beispiele: [
      ["head /etc/passwd", "die ersten 10 Zeilen"],
      ["head -n 3 notizen.txt", "die ersten 3 Zeilen"],
    ],
  },
  lauf: (k) => kopfOderEnde(k, "head", (zeilen, n) => zeilen.slice(0, n)),
};
