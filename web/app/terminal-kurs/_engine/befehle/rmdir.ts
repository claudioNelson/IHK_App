// rmdir: leere Ordner loeschen.

import { entferne, finde, pruefeEltern } from "../dateisystem";
import { grundHinweis, grundText } from "../hinweise";
import { absolut, absolutMitEnde, elternpfad } from "../pfade";
import type { Befehl, Zustand } from "../typen";
import { fehlenderOperand, zerlegeOptionen } from "../optionen";

export const rmdir: Befehl = {
  name: "rmdir",
  bereich: "Dateien und Ordner",
  hilfe: {
    kurz: "löscht leere Ordner (remove directory). Ordner mit Inhalt bleiben stehen.",
    aufruf: "rmdir [OPTION] ORDNER …",
    optionen: [
      ["-p", "danach auch die leeren übergeordneten Ordner aus dem Pfad löschen"],
      ["-v", "jede Löschung melden"],
    ],
    beispiele: [["rmdir leer", "den leeren Ordner leer löschen"]],
  },
  lauf: (k) => {
    const o = zerlegeOptionen("rmdir", k.args, { flags: "pv", lang: { parents: "p", verbose: "v" } });
    if (!o.ok) return o.fehler;
    if (o.rest.length === 0) return fehlenderOperand("rmdir", "Hinweis: rmdir braucht den Namen eines leeren Ordners, zum Beispiel rmdir alt.");
    let z: Zustand = k.zustand;
    let ausgabe = "";
    let fehler = "";
    let hinweis: string | undefined;

    const entferneEinen = (getippt: string): boolean => {
      const pfad = absolut(z.cwd, getippt);
      const fund = finde(z, absolutMitEnde(z.cwd, getippt));
      if (!fund.ok) {
        fehler += `rmdir: failed to remove '${getippt}': ${grundText(fund.grund)}\n`;
        hinweis ??= grundHinweis(fund.grund, getippt);
        return false;
      }
      if (fund.knoten.art !== "ordner") {
        fehler += `rmdir: failed to remove '${getippt}': Not a directory\n`;
        hinweis ??= `Hinweis: „${getippt}“ ist eine Datei. Dateien löschst du mit rm.`;
        return false;
      }
      const letzter = getippt.replace(/\/+$/, "").split("/").pop();
      if (letzter === "." || letzter === "..") {
        fehler += `rmdir: failed to remove '${getippt}': Invalid argument\n`;
        hinweis ??= "Hinweis: „.“ und „..“ sind nur Verweise. Nenne den Ordner beim Namen, zum Beispiel nach cd .. mit rmdir ordnername.";
        return false;
      }
      if (Object.keys(fund.knoten.kinder).length > 0) {
        fehler += `rmdir: failed to remove '${getippt}': Directory not empty\n`;
        hinweis ??= "Hinweis: rmdir löscht nur leere Ordner. Für Ordner mit Inhalt gibt es rm -r (Vorsicht, ohne Papierkorb).";
        return false;
      }
      if (pfad === "/") {
        fehler += `rmdir: failed to remove '${getippt}': Device or resource busy\n`;
        hinweis ??= "Hinweis: Die Wurzel „/“ lässt sich nicht löschen.";
        return false;
      }
      const p = pruefeEltern(z, pfad);
      if (!p.ok) {
        fehler += `rmdir: failed to remove '${getippt}': ${grundText(p.grund)}\n`;
        hinweis ??= grundHinweis(p.grund, getippt);
        return false;
      }
      z = { ...z, wurzel: entferne(z.wurzel, pfad, k.jetzt) };
      if (o.flags.has("v")) ausgabe += `rmdir: removing directory, '${getippt}'\n`;
      return true;
    };

    for (const getippt of o.rest) {
      if (!entferneEinen(getippt) || !o.flags.has("p")) continue;
      // -p: getippte Elternteile von hinten nach vorn
      let rest = getippt.replace(/\/+$/, "");
      while (rest.includes("/")) {
        rest = rest.slice(0, rest.lastIndexOf("/"));
        if (rest === "" || elternpfad(absolut(z.cwd, rest)) === absolut(z.cwd, rest)) break;
        if (!entferneEinen(rest)) break;
      }
    }
    return { ausgabe, fehler, hinweis: fehler ? hinweis : undefined, zustand: z, code: fehler ? 1 : 0 };
  },
};
