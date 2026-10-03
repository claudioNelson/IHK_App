// grep: Zeilen finden, die ein Muster enthalten. Muster wie GNU grep als
// einfacher regulaerer Ausdruck (BRE), mit -E erweitert, mit -F woertlich.
// Auf dem Bildschirm farbig wie unter Ubuntu (alias grep='grep --color=auto').

import { finde, sortiereNamen } from "../dateisystem";
import { grundHinweis, grundText } from "../hinweise";
import { absolutMitEnde } from "../pfade";
import { darf } from "../rechte";
import type { Befehl, Knoten } from "../typen";
import { zerlegeOptionen } from "../optionen";
import { Ausgabe } from "./_gemeinsam";
import { zeilenVon } from "./_lesen";

const KLASSEN: Record<string, string> = {
  digit: "0-9",
  alpha: "A-Za-z",
  alnum: "A-Za-z0-9",
  upper: "A-Z",
  lower: "a-z",
  space: "\\s",
  blank: " \\t",
  punct: "!-\\/:-@\\[-`{-~",
  xdigit: "0-9A-Fa-f",
};

/** Uebersetzt ein grep-Muster in einen JavaScript-Ausdruck. */
export function musterNachJs(muster: string, erweitert: boolean): string {
  let out = "";
  let i = 0;
  const SONDER_BRE = "+?|(){}";
  while (i < muster.length) {
    const c = muster[i];
    if (c === "[") {
      // Klammerausdruck bis zur schliessenden ] uebernehmen, POSIX-Klassen umsetzen
      let j = i + 1;
      let inhalt = "";
      if (muster[j] === "^") {
        inhalt += "^";
        j++;
      }
      if (muster[j] === "]") {
        inhalt += "\\]";
        j++;
      }
      while (j < muster.length && muster[j] !== "]") {
        const klasse = /^\[:([a-z]+):\]/.exec(muster.slice(j));
        if (klasse) {
          inhalt += KLASSEN[klasse[1]] ?? "";
          j += klasse[0].length;
          continue;
        }
        inhalt += muster[j] === "\\" ? "\\\\" : muster[j];
        j++;
      }
      if (j >= muster.length) throw new Error("Unmatched [");
      out += `[${inhalt}]`;
      i = j + 1;
      continue;
    }
    if (c === "\\" && i + 1 < muster.length) {
      const d = muster[i + 1];
      i += 2;
      if (d === "<" || d === ">") out += "\\b";
      else if (!erweitert && SONDER_BRE.includes(d)) out += d;
      else if ("wWsSbB".includes(d)) out += "\\" + d;
      else if (/[0-9]/.test(d)) out += "\\" + d;
      else out += "\\" + d;
      continue;
    }
    if (!erweitert && SONDER_BRE.includes(c)) {
      out += "\\" + c;
      i++;
      continue;
    }
    if (c === "*" && (out === "" || out.endsWith("^"))) {
      out += "\\*";
      i++;
      continue;
    }
    if ("/".includes(c)) out += "\\" + c;
    else out += c;
    i++;
  }
  return out;
}

type Datei = { name: string; inhalt: string };

export const grep: Befehl = {
  name: "grep",
  bereich: "Lesen und Suchen",
  hilfe: {
    kurz: "zeigt alle Zeilen, die ein Suchwort (Muster) enthalten.",
    aufruf: "grep [OPTION] MUSTER [DATEI …]",
    optionen: [
      ["-i", "Groß- und Kleinschreibung egal (ignore case)"],
      ["-n", "Zeilennummern davor"],
      ["-v", "nur Zeilen OHNE das Muster"],
      ["-c", "nur zählen, wie viele Zeilen passen"],
      ["-r", "alle Dateien in einem Ordner und seinen Unterordnern"],
      ["-l", "nur die Namen der Dateien mit Treffern"],
      ["-w", "nur ganze Wörter"],
      ["-o", "nur den passenden Teil statt der ganzen Zeile"],
      ["-E", "erweiterte Muster wie a|b oder [0-9]+"],
    ],
    beispiele: [
      ["grep Failed auth.log", "Zeilen mit „Failed“"],
      ["grep -i error syslog", "error, Error, ERROR …"],
      ["grep -c Failed auth.log", "wie viele Zeilen?"],
      ["grep -r TODO projekte", "in allen Dateien unter projekte"],
    ],
  },
  lauf: (k) => {
    // Mehrere -e MUSTER sind erlaubt (Alternativen); zerlegeOptionen merkt sich nur das letzte
    const eMuster: string[] = [];
    k.args.forEach((a, i) => {
      if ((a === "-e" || a === "--regexp") && k.args[i + 1] !== undefined) eMuster.push(k.args[i + 1]);
      else if (a.startsWith("--regexp=")) eMuster.push(a.slice(9));
      else if (/^-e./.test(a)) eMuster.push(a.slice(2));
    });
    const o = zerlegeOptionen("grep", k.args, {
      flags: "invcrRlwEFoHh",
      mitWert: "e",
      lang: {
        "ignore-case": "i",
        "invert-match": "v",
        "line-number": "n",
        count: "c",
        recursive: "r",
        "files-with-matches": "l",
        "word-regexp": "w",
        "extended-regexp": "E",
        "fixed-strings": "F",
        "only-matching": "o",
        "with-filename": "H",
        "no-filename": "h",
        regexp: "e",
        color: "",
        colour: "",
      },
      fehlerCode: 2,
    });
    if (!o.ok) return o.fehler;
    const f = o.flags;
    const rest = [...o.rest];
    let muster = o.werte.get("e");
    if (muster === undefined) {
      if (rest.length === 0) {
        return {
          fehler: "Usage: grep [OPTION]... PATTERNS [FILE]...\nTry 'grep --help' for more information.\n",
          hinweis: "Hinweis: grep braucht ein Suchwort und meist eine Datei, zum Beispiel grep Failed /var/log/auth.log.",
          code: 2,
        };
      }
      muster = rest.shift() as string;
    }

    const alleMuster = eMuster.length > 1 ? eMuster : [muster];
    let quelle: string;
    try {
      quelle = alleMuster
        .map((m) => (f.has("F") ? m.replace(/[.*+?^${}()|[\]\\/]/g, "\\$&") : musterNachJs(m, f.has("E"))))
        .map((q) => (alleMuster.length > 1 ? `(?:${q})` : q))
        .join("|");
      if (f.has("w")) quelle = `(?<![A-Za-z0-9_])(?:${quelle})(?![A-Za-z0-9_])`;
      new RegExp(quelle);
    } catch {
      return {
        fehler: "grep: Unmatched [, [^, [:, [., or [=\n",
        hinweis: "Hinweis: Das Muster enthält eine eckige Klammer ohne Gegenstück. Für Sonderzeichen hilft grep -F, dann wird das Muster wörtlich gesucht.",
        code: 2,
      };
    }
    const flagsJs = f.has("i") ? "i" : "";
    const test = new RegExp(quelle, flagsJs);
    const alle = new RegExp(quelle, flagsJs + "g");
    const rekursiv = f.has("r") || f.has("R");

    // Dateien sammeln
    const z = k.zustand;
    const dateien: Datei[] = [];
    let fehler = "";
    let hinweis: string | undefined;
    let ordnerGenannt = false;
    const durchlaufe = (anzeige: string, knoten: Knoten) => {
      if (knoten.art === "datei") {
        if (!darf(knoten, z.benutzer, "r")) {
          fehler += `grep: ${anzeige}: Permission denied\n`;
          hinweis ??= grundHinweis("verweigert", anzeige);
        } else dateien.push({ name: anzeige, inhalt: knoten.inhalt });
        return;
      }
      if (!darf(knoten, z.benutzer, "r") || !darf(knoten, z.benutzer, "x")) {
        fehler += `grep: ${anzeige}: Permission denied\n`;
        hinweis ??= grundHinweis("verweigert", anzeige);
        return;
      }
      for (const name of sortiereNamen(Object.keys(knoten.kinder))) {
        durchlaufe(anzeige === "" ? name : `${anzeige.replace(/\/$/, "")}/${name}`, knoten.kinder[name]);
      }
    };

    const operanden = rest.length > 0 ? rest : rekursiv ? [""] : ["-"];
    for (const getippt of operanden) {
      if (getippt === "-") {
        if (k.eingabe === null && rest.length === 0) {
          return {
            hinweis: `Hinweis: grep braucht hier eine Datei, zum Beispiel grep ${muster} datei.txt. Auf einem echten Server würde grep sonst auf Eingabe von der Tastatur warten.`,
            code: 1,
          };
        }
        dateien.push({ name: "(standard input)", inhalt: k.eingabe ?? "" });
        continue;
      }
      const fund = finde(z, absolutMitEnde(z.cwd, getippt === "" ? "." : getippt));
      if (!fund.ok) {
        fehler += `grep: ${getippt}: ${grundText(fund.grund)}\n`;
        hinweis ??= grundHinweis(fund.grund, getippt);
        continue;
      }
      if (fund.knoten.art === "ordner") {
        if (!rekursiv) {
          fehler += `grep: ${getippt}: Is a directory\n`;
          hinweis ??= `Hinweis: „${getippt}“ ist ein Ordner. Alle Dateien darin durchsucht grep -r.`;
          continue;
        }
        ordnerGenannt = true;
      }
      durchlaufe(getippt, fund.knoten);
    }

    const mitName = f.has("H") || (!f.has("h") && (dateien.length > 1 || ordnerGenannt || operanden.length > 1));
    const aus = new Ausgabe();
    const farbe = k.tty;
    const add = (text: string, stil?: "treffer" | "dateiname" | "zeilennr" | "trenner") => aus.add(text, farbe ? stil : undefined);
    let gefunden = false;

    for (const d of dateien) {
      const zeilen = zeilenVon(d.inhalt);
      let anzahl = 0;
      zeilen.forEach((zeile, nr) => {
        const passt = test.test(zeile) !== f.has("v");
        if (!passt) return;
        anzahl++;
        gefunden = true;
        if (f.has("c") || f.has("l")) return;
        const kopf = () => {
          if (mitName) {
            add(d.name, "dateiname");
            add(":", "trenner");
          }
          if (f.has("n")) {
            add(String(nr + 1), "zeilennr");
            add(":", "trenner");
          }
        };
        if (f.has("o")) {
          if (f.has("v")) return;
          for (const m of zeile.matchAll(alle)) {
            if (m[0] === "") continue;
            kopf();
            add(m[0], "treffer");
            add("\n");
          }
          return;
        }
        kopf();
        if (f.has("v") || !farbe) add(zeile);
        else {
          let pos = 0;
          for (const m of zeile.matchAll(alle)) {
            if (m[0] === "") continue;
            add(zeile.slice(pos, m.index));
            add(m[0], "treffer");
            pos = (m.index ?? 0) + m[0].length;
          }
          add(zeile.slice(pos));
        }
        add("\n");
      });
      if (f.has("l")) {
        if (anzahl > 0) {
          add(d.name, "dateiname");
          add("\n");
        }
      } else if (f.has("c")) {
        if (mitName) {
          add(d.name, "dateiname");
          add(":", "trenner");
        }
        add(`${anzahl}\n`);
      }
    }

    return {
      ausgabe: aus.text,
      anzeige: aus.teile,
      fehler,
      hinweis: fehler ? hinweis : undefined,
      code: fehler ? 2 : gefunden ? 0 : 1,
    };
  },
};
