// cp: Dateien kopieren, mit -r auch Ordner samt Inhalt.

import { finde, kopie, pruefeEltern, setze } from "../dateisystem";
import { grundHinweis, grundText } from "../hinweise";
import { absolut, absolutMitEnde, basisname, endetMitSchraegstrich, liegtIn } from "../pfade";
import { darf } from "../rechte";
import type { Befehl, Knoten, Zustand } from "../typen";
import { zerlegeOptionen } from "../optionen";

/** Verbindet einen getippten Zielordner mit einem Namen: "backup" + "a.txt" -> "backup/a.txt". */
export function verbinde(getippt: string, name: string): string {
  return getippt.endsWith("/") ? getippt + name : `${getippt}/${name}`;
}

export const cp: Befehl = {
  name: "cp",
  bereich: "Dateien und Ordner",
  hilfe: {
    kurz: "kopiert Dateien und Ordner (copy). Das Original bleibt erhalten.",
    aufruf: "cp [OPTION] QUELLE ZIEL  oder  cp [OPTION] QUELLE … ORDNER",
    optionen: [
      ["-r", "Ordner mit allem Inhalt kopieren"],
      ["-v", "jede Kopie melden"],
    ],
    beispiele: [
      ["cp notizen.txt notizen.bak", "Kopie unter neuem Namen"],
      ["cp notizen.txt backup/", "Kopie in den Ordner backup"],
      ["cp -r projekte projekte-alt", "ganzen Ordner kopieren"],
    ],
  },
  lauf: (k) => {
    const o = zerlegeOptionen("cp", k.args, { flags: "rRv", lang: { recursive: "r", verbose: "v" } });
    if (!o.ok) return o.fehler;
    const rekursiv = o.flags.has("r") || o.flags.has("R");
    const rest = o.rest;
    if (rest.length === 0) {
      return { fehler: "cp: missing file operand\nTry 'cp --help' for more information.\n", hinweis: "Hinweis: cp braucht Quelle und Ziel, zum Beispiel cp notizen.txt kopie.txt.", code: 1 };
    }
    if (rest.length === 1) {
      return {
        fehler: `cp: missing destination file operand after '${rest[0]}'\nTry 'cp --help' for more information.\n`,
        hinweis: `Hinweis: Es fehlt das Ziel. Zum Beispiel cp ${rest[0]} kopie oder cp ${rest[0]} ordner/.`,
        code: 1,
      };
    }
    let z: Zustand = k.zustand;
    let ausgabe = "";
    let fehler = "";
    let hinweis: string | undefined;
    const melde = (text: string, h?: string) => {
      fehler += text + "\n";
      hinweis ??= h;
    };

    const quellen = rest.slice(0, -1);
    const zielGetippt = rest[rest.length - 1];
    const zielPfad = absolut(z.cwd, zielGetippt);
    const zf = finde(z, zielPfad);
    const zielIstOrdner = zf.ok && zf.knoten.art === "ordner";
    const zielMitEnde = endetMitSchraegstrich(zielGetippt);
    if (zielMitEnde && zf.ok && !zielIstOrdner) {
      melde(`cp: cannot stat '${zielGetippt}': Not a directory`, grundHinweis("keinOrdner", zielGetippt));
      return { fehler, hinweis, code: 1 };
    }
    if (quellen.length > 1 && !zielIstOrdner) {
      if (zf.ok) melde(`cp: target '${zielGetippt}' is not a directory`, "Hinweis: Mehrere Dateien kopierst du nur in einen Ordner.");
      else melde(`cp: target '${zielGetippt}': No such file or directory`, `Hinweis: Den Zielordner „${zielGetippt}“ gibt es nicht. Lege ihn zuerst mit mkdir an.`);
      return { fehler, hinweis, code: 1 };
    }

    /** Kopiert quelle nach ziel (legt an, ueberschreibt Dateien, fuehrt Ordner zusammen). */
    const kopiere = (quelle: Knoten, qAnzeige: string, ziel: string, zAnzeige: string): void => {
      const df = finde(z, ziel);
      if (df.ok) {
        if (quelle.art === "datei") {
          if (df.knoten.art === "ordner") {
            melde(`cp: cannot overwrite directory '${zAnzeige}' with non-directory`);
            return;
          }
          if (!darf(df.knoten, z.benutzer, "w")) {
            melde(`cp: cannot create regular file '${zAnzeige}': Permission denied`, grundHinweis("verweigert", zAnzeige));
            return;
          }
          z = { ...z, wurzel: setze(z.wurzel, df.pfad, { ...df.knoten, inhalt: quelle.inhalt, geaendert: k.jetzt }, k.jetzt) };
          if (o.flags.has("v")) ausgabe += `'${qAnzeige}' -> '${zAnzeige}'\n`;
          return;
        }
        if (df.knoten.art !== "ordner") {
          melde(`cp: cannot overwrite non-directory '${zAnzeige}' with directory '${qAnzeige}'`);
          return;
        }
        if (!darf(quelle, z.benutzer, "r") || !darf(quelle, z.benutzer, "x")) {
          melde(`cp: cannot access '${qAnzeige}': Permission denied`, grundHinweis("verweigert", qAnzeige));
          return;
        }
        for (const [name, kind] of Object.entries(quelle.kinder)) {
          kopiere(kind, verbinde(qAnzeige, name), `${ziel}/${name}`, verbinde(zAnzeige, name));
        }
        return;
      }
      if (df.grund !== "fehlt") {
        melde(`cp: cannot create ${quelle.art === "datei" ? "regular file" : "directory"} '${zAnzeige}': ${grundText(df.grund)}`, grundHinweis(df.grund, zAnzeige));
        return;
      }
      const p = pruefeEltern(z, ziel);
      if (!p.ok) {
        melde(
          `cp: cannot create ${quelle.art === "datei" ? "regular file" : "directory"} '${zAnzeige}': ${grundText(p.grund)}`,
          p.grund === "fehlt" ? `Hinweis: Den Zielordner für „${zAnzeige}“ gibt es nicht. Lege ihn zuerst mit mkdir an.` : grundHinweis(p.grund, zAnzeige),
        );
        return;
      }
      if (quelle.art === "ordner" && (!darf(quelle, z.benutzer, "r") || !darf(quelle, z.benutzer, "x"))) {
        melde(`cp: cannot access '${qAnzeige}': Permission denied`, grundHinweis("verweigert", qAnzeige));
        return;
      }
      if (quelle.art === "datei") {
        z = { ...z, wurzel: setze(z.wurzel, ziel, kopie(quelle, z, k.jetzt), k.jetzt) };
        if (o.flags.has("v")) ausgabe += `'${qAnzeige}' -> '${zAnzeige}'\n`;
        return;
      }
      // Ordner: erst leer anlegen, dann Eintrag fuer Eintrag (so meldet -v jede Datei wie GNU cp)
      z = { ...z, wurzel: setze(z.wurzel, ziel, kopie({ ...quelle, kinder: {} }, z, k.jetzt), k.jetzt) };
      if (o.flags.has("v")) ausgabe += `'${qAnzeige}' -> '${zAnzeige}'\n`;
      for (const [name, kind] of Object.entries(quelle.kinder)) {
        kopiere(kind, verbinde(qAnzeige, name), `${ziel}/${name}`, verbinde(zAnzeige, name));
      }
    };

    for (const qGetippt of quellen) {
      const qPfad = absolut(z.cwd, qGetippt);
      const qf = finde(z, absolutMitEnde(z.cwd, qGetippt));
      if (!qf.ok) {
        melde(`cp: cannot stat '${qGetippt}': ${grundText(qf.grund)}`, grundHinweis(qf.grund, qGetippt));
        continue;
      }
      if (qf.knoten.art === "ordner" && !rekursiv) {
        melde(`cp: -r not specified; omitting directory '${qGetippt}'`, "Hinweis: Ordner kopierst du mit cp -r, dann kommt der ganze Inhalt mit.");
        continue;
      }
      if (qf.knoten.art === "datei" && zielMitEnde && !zielIstOrdner) {
        melde(`cp: cannot create regular file '${zielGetippt}': Not a directory`, `Hinweis: Den Ordner „${zielGetippt}“ gibt es nicht. Lege ihn zuerst mit mkdir an oder lass den / am Ende weg.`);
        continue;
      }
      if (qf.knoten.art === "datei" && !darf(qf.knoten, z.benutzer, "r")) {
        melde(`cp: cannot open '${qGetippt}' for reading: Permission denied`, grundHinweis("verweigert", qGetippt));
        continue;
      }
      const name = basisname(qPfad);
      // "cp -r ordner/. ziel" kopiert den Inhalt in ein vorhandenes Ziel, nicht den Ordner selbst
      const nurInhalt = qGetippt === "." || qGetippt.endsWith("/.");
      const ziel = zielIstOrdner && !nurInhalt ? (zielPfad === "/" ? `/${name}` : `${zielPfad}/${name}`) : zielPfad;
      const zAnzeige = zielIstOrdner && !nurInhalt ? verbinde(zielGetippt, name) : zielGetippt;
      if (ziel === qf.pfad) {
        melde(`cp: '${qGetippt}' and '${zAnzeige}' are the same file`, "Hinweis: Quelle und Ziel sind dieselbe Datei. Gib der Kopie einen anderen Namen oder Ordner.");
        continue;
      }
      if (qf.knoten.art === "ordner" && liegtIn(ziel, qf.pfad)) {
        melde(`cp: cannot copy a directory, '${qGetippt}', into itself, '${zAnzeige}'`, "Hinweis: Ein Ordner lässt sich nicht in sich selbst kopieren.");
        continue;
      }
      kopiere(qf.knoten, qGetippt, ziel, zAnzeige);
    }
    return { ausgabe, fehler, hinweis: fehler ? hinweis : undefined, zustand: z, code: fehler ? 1 : 0 };
  },
};
