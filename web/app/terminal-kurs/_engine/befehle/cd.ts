// cd: Ordner wechseln (eingebauter Befehl der Bash, deshalb "bash: cd: ..." in Fehlern).

import { finde, home } from "../dateisystem";
import { grundHinweis, grundText } from "../hinweise";
import { absolut } from "../pfade";
import { darf } from "../rechte";
import type { Befehl } from "../typen";

export const cd: Befehl = {
  name: "cd",
  bereich: "Orientierung",
  hilfe: {
    kurz: "wechselt in einen anderen Ordner (change directory).",
    aufruf: "cd [ORDNER]",
    beispiele: [
      ["cd projekte", "in den Unterordner projekte"],
      ["cd ..", "eine Ebene nach oben"],
      ["cd /var/log", "absoluter Pfad, egal wo du gerade bist"],
      ["cd", "zurück in deinen Home-Ordner (auch cd ~)"],
      ["cd -", "zurück in den vorherigen Ordner"],
    ],
  },
  lauf: ({ args, zustand: z }) => {
    if (args.length > 1) {
      return { fehler: "bash: cd: too many arguments\n", hinweis: "Hinweis: cd wechselt in genau einen Ordner. Enthält der Name Leerzeichen, setze ihn in Anführungszeichen.", code: 1 };
    }
    let getippt = args[0] ?? home(z);
    let ausgabe = "";
    if (getippt === "-") {
      if (!z.vorher) {
        return { fehler: "bash: cd: OLDPWD not set\n", hinweis: "Hinweis: Es gibt noch keinen vorherigen Ordner. Wechsle zuerst einmal mit cd woandershin.", code: 1 };
      }
      getippt = z.vorher;
      ausgabe = z.vorher + "\n";
    }
    if (getippt === "") return { code: 0 };
    const ziel = absolut(z.cwd, getippt);
    const fund = finde(z, ziel);
    if (!fund.ok) {
      return { fehler: `bash: cd: ${getippt}: ${grundText(fund.grund)}\n`, hinweis: grundHinweis(fund.grund, getippt), code: 1 };
    }
    if (fund.knoten.art !== "ordner") {
      return {
        fehler: `bash: cd: ${getippt}: Not a directory\n`,
        hinweis: `Hinweis: „${getippt}“ ist eine Datei, kein Ordner. Mit cd wechselst du nur in Ordner.`,
        code: 1,
      };
    }
    if (!darf(fund.knoten, z.benutzer, "x")) {
      return { fehler: `bash: cd: ${getippt}: Permission denied\n`, hinweis: grundHinweis("verweigert", getippt), code: 1 };
    }
    return { ausgabe, zustand: { ...z, cwd: fund.pfad, vorher: z.cwd }, code: 0 };
  },
};
