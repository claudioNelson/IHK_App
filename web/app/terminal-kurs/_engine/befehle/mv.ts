// mv: verschieben oder umbenennen (move). Besitzer, Rechte und Zeit bleiben.

import { entferne, finde, pruefeEltern, setze } from "../dateisystem";
import { grundHinweis, grundText } from "../hinweise";
import { absolut, absolutMitEnde, basisname, endetMitSchraegstrich, liegtIn } from "../pfade";
import type { Befehl, Zustand } from "../typen";
import { zerlegeOptionen } from "../optionen";
import { verbinde } from "./cp";

export const mv: Befehl = {
  name: "mv",
  bereich: "Dateien und Ordner",
  hilfe: {
    kurz: "verschiebt oder benennt Dateien und Ordner um (move).",
    aufruf: "mv [OPTION] QUELLE ZIEL  oder  mv [OPTION] QUELLE … ORDNER",
    optionen: [["-v", "jede Verschiebung melden"]],
    beispiele: [
      ["mv alt.txt neu.txt", "umbenennen"],
      ["mv bericht.txt archiv/", "in den Ordner archiv verschieben"],
      ["mv *.log logs/", "alle .log-Dateien auf einmal"],
    ],
  },
  lauf: (k) => {
    const o = zerlegeOptionen("mv", k.args, { flags: "v", lang: { verbose: "v" } });
    if (!o.ok) return o.fehler;
    const rest = o.rest;
    if (rest.length === 0) {
      return { fehler: "mv: missing file operand\nTry 'mv --help' for more information.\n", hinweis: "Hinweis: mv braucht Quelle und Ziel, zum Beispiel mv alt.txt neu.txt.", code: 1 };
    }
    if (rest.length === 1) {
      return {
        fehler: `mv: missing destination file operand after '${rest[0]}'\nTry 'mv --help' for more information.\n`,
        hinweis: `Hinweis: Es fehlt das Ziel, also der neue Name oder der Ordner, zum Beispiel mv ${rest[0]} ordner/.`,
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
      melde(`mv: cannot stat '${zielGetippt}': Not a directory`, grundHinweis("keinOrdner", zielGetippt));
      return { fehler, hinweis, code: 1 };
    }
    if (quellen.length > 1 && !zielIstOrdner) {
      if (zf.ok) melde(`mv: target '${zielGetippt}' is not a directory`, "Hinweis: Mehrere Dateien verschiebst du nur in einen Ordner.");
      else melde(`mv: target '${zielGetippt}': No such file or directory`, `Hinweis: Den Zielordner „${zielGetippt}“ gibt es nicht. Lege ihn zuerst mit mkdir an.`);
      return { fehler, hinweis, code: 1 };
    }

    for (const qGetippt of quellen) {
      const qPfad = absolut(z.cwd, qGetippt);
      const qf = finde(z, absolutMitEnde(z.cwd, qGetippt));
      if (!qf.ok) {
        melde(`mv: cannot stat '${qGetippt}': ${grundText(qf.grund)}`, grundHinweis(qf.grund, qGetippt));
        continue;
      }
      if (basisname(qGetippt) === "." || basisname(qGetippt) === ".." || qf.pfad === "/") {
        melde(`mv: cannot move '${qGetippt}' to '${zielGetippt}': Device or resource busy`, "Hinweis: Den aktuellen oder übergeordneten Ordner kannst du so nicht verschieben. Wechsle mit cd .. eine Ebene höher und nimm den Namen des Ordners.");
        continue;
      }
      if (qf.knoten.art === "datei" && zielMitEnde && !zielIstOrdner) {
        melde(`mv: cannot move '${qGetippt}' to '${zielGetippt}': Not a directory`, `Hinweis: Den Ordner „${zielGetippt}“ gibt es nicht. Lege ihn zuerst mit mkdir an oder lass den / am Ende weg.`);
        continue;
      }
      const name = basisname(qPfad);
      const ziel = zielIstOrdner ? (zielPfad === "/" ? `/${name}` : `${zielPfad}/${name}`) : zielPfad;
      const zAnzeige = zielIstOrdner ? verbinde(zielGetippt, name) : zielGetippt;
      if (ziel === qf.pfad) {
        melde(`mv: '${qGetippt}' and '${zAnzeige}' are the same file`, "Hinweis: Quelle und Ziel sind gleich, es gibt nichts zu verschieben.");
        continue;
      }
      if (qf.knoten.art === "ordner" && liegtIn(ziel, qf.pfad)) {
        melde(`mv: cannot move '${qGetippt}' to a subdirectory of itself, '${zAnzeige}'`, "Hinweis: Ein Ordner lässt sich nicht in sich selbst verschieben.");
        continue;
      }
      const pq = pruefeEltern(z, qf.pfad);
      if (!pq.ok) {
        melde(`mv: cannot move '${qGetippt}' to '${zAnzeige}': ${grundText(pq.grund)}`, grundHinweis(pq.grund, qGetippt));
        continue;
      }
      const df = finde(z, ziel);
      if (df.ok) {
        if (qf.knoten.art === "ordner") {
          if (df.knoten.art !== "ordner") {
            melde(`mv: cannot overwrite non-directory '${zAnzeige}' with directory '${qGetippt}'`);
            continue;
          }
          if (Object.keys(df.knoten.kinder).length > 0) {
            melde(`mv: cannot move '${qGetippt}' to '${zAnzeige}': Directory not empty`, `Hinweis: Im Ziel gibt es schon einen Ordner „${name}“ mit Inhalt.`);
            continue;
          }
        } else if (df.knoten.art === "ordner") {
          melde(`mv: cannot overwrite directory '${zAnzeige}' with non-directory`);
          continue;
        }
      } else if (df.grund !== "fehlt") {
        melde(`mv: cannot move '${qGetippt}' to '${zAnzeige}': ${grundText(df.grund)}`, grundHinweis(df.grund, zAnzeige));
        continue;
      }
      const pz = pruefeEltern(z, ziel);
      if (!pz.ok) {
        melde(
          `mv: cannot move '${qGetippt}' to '${zAnzeige}': ${grundText(pz.grund)}`,
          pz.grund === "fehlt" ? `Hinweis: Den Zielordner für „${zAnzeige}“ gibt es nicht. Lege ihn zuerst mit mkdir an.` : grundHinweis(pz.grund, zAnzeige),
        );
        continue;
      }
      let wurzel = entferne(z.wurzel, qf.pfad, k.jetzt);
      wurzel = setze(wurzel, ziel, qf.knoten, k.jetzt);
      const cwd = liegtIn(z.cwd, qf.pfad) ? ziel + z.cwd.slice(qf.pfad.length) : z.cwd;
      z = { ...z, wurzel, cwd };
      if (o.flags.has("v")) ausgabe += `renamed '${qGetippt}' -> '${zAnzeige}'\n`;
    }
    return { ausgabe, fehler, hinweis: fehler ? hinweis : undefined, zustand: z, code: fehler ? 1 : 0 };
  },
};
