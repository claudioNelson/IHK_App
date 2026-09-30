// mkdir: Ordner anlegen, mit -p auch alle fehlenden Zwischenordner.

import { finde, neuerOrdner, pruefeEltern, setze } from "../dateisystem";
import { grundHinweis, grundText } from "../hinweise";
import { absolut } from "../pfade";
import type { Befehl, Zustand } from "../typen";
import { fehlenderOperand, zerlegeOptionen } from "../optionen";

export const mkdir: Befehl = {
  name: "mkdir",
  bereich: "Dateien und Ordner",
  hilfe: {
    kurz: "legt einen neuen Ordner an (make directory).",
    aufruf: "mkdir [OPTION] ORDNER …",
    optionen: [
      ["-p", "fehlende Zwischenordner mit anlegen, kein Fehler, wenn es den Ordner schon gibt"],
      ["-v", "jeden angelegten Ordner melden"],
    ],
    beispiele: [
      ["mkdir backup", "Ordner backup im aktuellen Ordner"],
      ["mkdir -p projekte/2026/berichte", "alle drei Ebenen auf einmal"],
      ["mkdir bilder texte", "zwei Ordner auf einmal"],
    ],
  },
  lauf: (k) => {
    const o = zerlegeOptionen("mkdir", k.args, { flags: "pv", lang: { parents: "p", verbose: "v" } });
    if (!o.ok) return o.fehler;
    if (o.rest.length === 0) return fehlenderOperand("mkdir", "Hinweis: mkdir braucht einen Namen, zum Beispiel mkdir backup.");
    let z: Zustand = k.zustand;
    let ausgabe = "";
    let fehler = "";
    let hinweis: string | undefined;
    const eltern = o.flags.has("p");

    const lege = (pfad: string, getippt: string): boolean => {
      const p = pruefeEltern(z, pfad);
      if (!p.ok) {
        fehler += `mkdir: cannot create directory ‘${getippt}’: ${grundText(p.grund)}\n`;
        hinweis ??=
          p.grund === "fehlt"
            ? `Hinweis: Der übergeordnete Ordner fehlt. Mit mkdir -p legst du alle fehlenden Ordner auf einmal an.`
            : grundHinweis(p.grund, getippt);
        return false;
      }
      z = { ...z, wurzel: setze(z.wurzel, pfad, neuerOrdner(z, k.jetzt), k.jetzt) };
      if (o.flags.has("v")) ausgabe += `mkdir: created directory '${getippt}'\n`;
      return true;
    };

    for (const getippt of o.rest) {
      const pfad = absolut(z.cwd, getippt);
      const fund = finde(z, pfad);
      if (fund.ok) {
        if (eltern && fund.knoten.art === "ordner") continue;
        fehler += `mkdir: cannot create directory ‘${getippt}’: File exists\n`;
        hinweis ??= `Hinweis: „${getippt}“ gibt es schon. Mit ls siehst du, was im Ordner liegt.`;
        continue;
      }
      if (!eltern || getippt === "") {
        lege(pfad, getippt);
        continue;
      }
      // -p: jede getippte Ebene der Reihe nach wie GNU mkdir (auch mit .. im Pfad)
      let praefix = getippt.startsWith("/") ? "/" : "";
      for (const teil of getippt.split("/")) {
        if (teil === "") continue;
        praefix = praefix === "" ? teil : praefix.endsWith("/") ? praefix + teil : `${praefix}/${teil}`;
        if (teil === "." || teil === "..") continue;
        const ebene = absolut(z.cwd, praefix);
        const f = finde(z, ebene);
        if (f.ok) {
          if (f.knoten.art === "ordner") continue;
          fehler += `mkdir: cannot create directory ‘${praefix}’: Not a directory\n`;
          hinweis ??= `Hinweis: „${praefix}“ ist eine Datei. In einer Datei kann kein Ordner liegen.`;
          break;
        }
        if (!lege(ebene, praefix)) break;
      }
    }
    return { ausgabe, fehler, hinweis: fehler ? hinweis : undefined, zustand: z, code: fehler ? 1 : 0 };
  },
};
