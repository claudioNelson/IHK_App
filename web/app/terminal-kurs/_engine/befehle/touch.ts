// touch: leere Datei anlegen oder Aenderungszeit auffrischen.

import { finde, neueDatei, pruefeEltern, setze } from "../dateisystem";
import { grundHinweis, grundText } from "../hinweise";
import { absolut, absolutMitEnde, endetMitSchraegstrich } from "../pfade";
import { darf } from "../rechte";
import type { Befehl, Zustand } from "../typen";
import { zerlegeOptionen } from "../optionen";

export const touch: Befehl = {
  name: "touch",
  bereich: "Dateien und Ordner",
  hilfe: {
    kurz: "legt eine leere Datei an. Gibt es die Datei schon, bekommt sie die aktuelle Uhrzeit.",
    aufruf: "touch [OPTION] DATEI …",
    optionen: [["-c", "keine neue Datei anlegen, nur die Zeit auffrischen"]],
    beispiele: [
      ["touch notizen.txt", "leere Datei notizen.txt"],
      ["touch a.txt b.txt", "zwei Dateien auf einmal"],
    ],
  },
  lauf: (k) => {
    const o = zerlegeOptionen("touch", k.args, { flags: "c", lang: { "no-create": "c" } });
    if (!o.ok) return o.fehler;
    if (o.rest.length === 0) {
      return {
        fehler: "touch: missing file operand\nTry 'touch --help' for more information.\n",
        hinweis: "Hinweis: touch braucht einen Dateinamen, zum Beispiel touch notizen.txt.",
        code: 1,
      };
    }
    let z: Zustand = k.zustand;
    let fehler = "";
    let hinweis: string | undefined;
    for (const getippt of o.rest) {
      const pfad = absolut(z.cwd, getippt);
      const fund = finde(z, absolutMitEnde(z.cwd, getippt));
      if (fund.ok) {
        if (!darf(fund.knoten, z.benutzer, "w")) {
          fehler += `touch: cannot touch '${getippt}': Permission denied\n`;
          hinweis ??= grundHinweis("verweigert", getippt);
          continue;
        }
        z = { ...z, wurzel: setze(z.wurzel, fund.pfad, { ...fund.knoten, geaendert: k.jetzt }, k.jetzt, false) };
        continue;
      }
      if (endetMitSchraegstrich(getippt) && (fund.grund === "fehlt" || fund.grund === "keinOrdner")) {
        // "touch nix/": Linux sucht einen Ordner und legt keine Datei an
        fehler += `touch: setting times of '${getippt}': ${grundText(fund.grund)}\n`;
        hinweis ??= `Hinweis: Der / am Ende steht für einen Ordner. Ordner legst du mit mkdir an, Dateien mit touch ohne / am Ende.`;
        continue;
      }
      if (fund.grund !== "fehlt") {
        fehler += `touch: cannot touch '${getippt}': ${grundText(fund.grund)}\n`;
        hinweis ??= grundHinweis(fund.grund, getippt);
        continue;
      }
      if (o.flags.has("c")) continue;
      const p = pruefeEltern(z, pfad);
      if (!p.ok) {
        fehler += `touch: cannot touch '${getippt}': ${grundText(p.grund)}\n`;
        hinweis ??=
          p.grund === "fehlt" ? `Hinweis: Den Ordner für „${getippt}“ gibt es nicht. Lege ihn zuerst mit mkdir an.` : grundHinweis(p.grund, getippt);
        continue;
      }
      z = { ...z, wurzel: setze(z.wurzel, pfad, neueDatei(z, "", k.jetzt), k.jetzt) };
    }
    return { fehler, hinweis: fehler ? hinweis : undefined, zustand: z, code: fehler ? 1 : 0 };
  },
};
