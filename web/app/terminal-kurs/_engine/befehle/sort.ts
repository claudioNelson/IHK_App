// sort: Zeilen sortieren. Reihenfolge wie unter Ubuntu mit en_US.UTF-8
// (Gross- und Kleinschreibung zaehlt erst bei Gleichstand).

import { zerlegeOptionen } from "../optionen";
import type { Befehl } from "../typen";
import { alsText, leseQuellen, wartetAufEingabe, zeilenVon } from "./_lesen";

// glibc (en_US.UTF-8) ueberspringt Satz- und Leerzeichen beim ersten Vergleich, ICU mit ignorePunctuation ebenso
const vergleicher = new Intl.Collator("en-US", { ignorePunctuation: true });

/** Zahl am Anfang wie sort -n (fehlt sie, zaehlt sie als 0). */
function zahlVon(s: string): number {
  const m = /^\s*(-?\d+(?:\.\d+)?)/.exec(s);
  return m ? Number(m[1]) : 0;
}

type Schluessel = { von: number; bis: number; n: boolean; r: boolean; f: boolean };

export const sort: Befehl = {
  name: "sort",
  bereich: "Verketten",
  hilfe: {
    kurz: "sortiert Zeilen, normalerweise alphabetisch.",
    aufruf: "sort [OPTION] [DATEI …]",
    optionen: [
      ["-n", "nach Zahlenwert (2 vor 10)"],
      ["-r", "umgekehrt (größte oder letzte zuerst)"],
      ["-u", "doppelte Zeilen nur einmal"],
      ["-t ZEICHEN", "Trennzeichen zwischen den Spalten"],
      ["-k NR", "ab Spalte NR sortieren, -k NR,NR nur nach dieser Spalte"],
    ],
    beispiele: [
      ["sort namen.txt", "alphabetisch"],
      ["sort -n -r zahlen.txt", "größte Zahl zuerst"],
      ["sort -t: -k3,3n /etc/passwd", "nach der dritten Spalte (Benutzernummer)"],
    ],
  },
  lauf: (k) => {
    // Mehrere -k sind erlaubt; zerlegeOptionen merkt sich nur den letzten Wert, deshalb vorher einsammeln
    const keys: string[] = [];
    const args = k.args.filter((a, i) => {
      if (a === "-k" || a === "--key") return true;
      if (/^-k./.test(a)) keys.push(a.slice(2));
      else if (a.startsWith("--key=")) keys.push(a.slice(6));
      else if ((k.args[i - 1] === "-k" || k.args[i - 1] === "--key")) keys.push(a);
      return true;
    });
    const o = zerlegeOptionen("sort", args, {
      flags: "nruf",
      mitWert: "tk",
      lang: { "numeric-sort": "n", reverse: "r", unique: "u", "ignore-case": "f", "field-separator": "t", key: "k" },
      fehlerCode: 2,
    });
    if (!o.ok) return o.fehler;
    const trenner = o.werte.get("t");
    if (trenner !== undefined && [...trenner].length !== 1) {
      return { fehler: "sort: multi-character tab '" + trenner + "'\n", hinweis: "Hinweis: Hinter -t gehört genau ein Zeichen, zum Beispiel -t: oder -t,", code: 2 };
    }
    const f = o.flags;
    const schluessel: Schluessel[] = [];
    for (const key of keys) {
      const m = /^(\d+)(?:\.\d+)?([bnrf]*)(?:,(\d+)(?:\.\d+)?([bnrf]*))?$/.exec(key);
      if (!m) {
        return { fehler: `sort: invalid number at field start: invalid count at start of '${key}'\n`, hinweis: "Hinweis: Hinter -k gehört die Nummer der Spalte, zum Beispiel -k2 oder -k2,2n.", code: 2 };
      }
      if (Number(m[1]) === 0) return { fehler: `sort: field number is zero: invalid field specification '${key}'\n`, hinweis: "Hinweis: Spalten zählen ab 1.", code: 2 };
      const mod = (m[2] ?? "") + (m[4] ?? "");
      const eigene = mod.replace(/b/g, "") !== "";
      schluessel.push({
        von: Number(m[1]),
        bis: m[3] ? Number(m[3]) : 0,
        n: eigene ? mod.includes("n") : f.has("n"),
        r: eigene ? mod.includes("r") : f.has("r"),
        f: eigene ? mod.includes("f") : f.has("f"),
      });
    }
    if (schluessel.length === 0) schluessel.push({ von: 1, bis: 0, n: f.has("n"), r: f.has("r"), f: f.has("f") });
    if (o.rest.length === 0 && k.eingabe === null) return wartetAufEingabe("sort", "sort namen.txt");
    const g = leseQuellen(k, o.rest, (getippt, text) => (text === "Is a directory" ? `sort: read failed: ${getippt}: ${text}\n` : `sort: cannot read: ${getippt}: ${text}\n`));
    if (g.fehler) return { fehler: g.fehler, hinweis: g.hinweis, code: 2 };
    const zeilen = g.quellen.flatMap((q) => zeilenVon(q.inhalt));

    const feld = (zeile: string, s: Schluessel): string => {
      if (s.von === 1 && s.bis === 0) return zeile;
      const felder = trenner !== undefined ? zeile.split(trenner) : (zeile.match(/\s*\S+/g) ?? []);
      return felder.slice(s.von - 1, s.bis > 0 ? s.bis : undefined).join(trenner ?? "");
    };
    const vergleicheSchluessel = (a: string, b: string): number => {
      for (const s of schluessel) {
        const ka = feld(a, s);
        const kb = feld(b, s);
        let e = s.n ? zahlVon(ka) - zahlVon(kb) : s.f ? vergleicher.compare(ka.toLowerCase(), kb.toLowerCase()) : vergleicher.compare(ka, kb);
        if (s.r) e = -e;
        if (e !== 0) return e;
      }
      return 0;
    };
    // Letzter Ausweg wie GNU: ganze Zeile vergleichen (nicht bei -u), mit -r ebenfalls umgekehrt
    const letzter = (a: string, b: string) => (vergleicher.compare(a, b) || (a < b ? -1 : a > b ? 1 : 0)) * (f.has("r") ? -1 : 1);
    let sortiert = [...zeilen].sort((a, b) => vergleicheSchluessel(a, b) || (f.has("u") ? 0 : letzter(a, b)));
    if (f.has("u")) sortiert = sortiert.filter((z, i) => i === 0 || vergleicheSchluessel(sortiert[i - 1], z) !== 0);
    return { ausgabe: alsText(sortiert), code: 0 };
  },
};
