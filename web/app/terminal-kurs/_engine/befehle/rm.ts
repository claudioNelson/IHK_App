// rm: Dateien loeschen, mit -r auch Ordner samt Inhalt. Ohne Papierkorb.

import { entferne, finde, knotenBei, pruefeEltern } from "../dateisystem";
import { grundHinweis, grundText } from "../hinweise";
import { absolut, absolutMitEnde, basisname } from "../pfade";
import { darf } from "../rechte";
import type { Befehl, Zustand } from "../typen";
import { fehlenderOperand, zerlegeOptionen } from "../optionen";

const WURZEL_HINWEIS =
  "Hinweis: Gut, dass du das hier ausprobierst und nicht auf einem echten Server. Linux schützt die Wurzel „/“ mit einer Sicherung. Trotzdem gilt: rm -rf nur mit genau geprüftem Pfad.";

const SYSTEM_WEG_HINWEIS =
  "Hinweis: Du hast gerade große Teile des Systems gelöscht. Auf einem echten Server wäre das jetzt ein sehr schlechter Tag. Hier bringt „Zurücksetzen“ alles zurück.";

export const rm: Befehl = {
  name: "rm",
  bereich: "Dateien und Ordner",
  hilfe: {
    kurz: "löscht Dateien (remove). Es gibt keinen Papierkorb, weg ist weg.",
    aufruf: "rm [OPTION] DATEI …",
    optionen: [
      ["-r", "Ordner mit allem Inhalt löschen"],
      ["-f", "keine Meldung, wenn etwas nicht existiert"],
      ["-d", "leere Ordner löschen"],
      ["-v", "jede Löschung melden"],
    ],
    beispiele: [
      ["rm alt.txt", "eine Datei löschen"],
      ["rm *.tmp", "alle Dateien mit Endung .tmp"],
      ["rm -r altes-projekt", "Ordner samt Inhalt"],
    ],
  },
  lauf: (k) => {
    const o = zerlegeOptionen("rm", k.args, {
      flags: "rRfdv",
      lang: { recursive: "r", force: "f", dir: "d", verbose: "v", "no-preserve-root": "", "preserve-root": "" },
    });
    if (!o.ok) return o.fehler;
    const rekursiv = o.flags.has("r") || o.flags.has("R");
    const still = o.flags.has("f");
    if (o.rest.length === 0) {
      if (still) return { code: 0 };
      return fehlenderOperand("rm", "Hinweis: rm braucht den Namen der Datei, die weg soll, zum Beispiel rm alt.txt.");
    }
    let z: Zustand = k.zustand;
    const vorher = z.wurzel;
    let ausgabe = "";
    let fehler = "";
    let hinweis: string | undefined;
    const melde = (text: string, h?: string) => {
      fehler += text + "\n";
      hinweis ??= h;
    };

    /** Loescht pfad (Ordner rekursiv). Liefert true, wenn er danach weg ist. */
    const loesche = (pfad: string, anzeige: string): boolean => {
      const knoten = knotenBei(z.wurzel, pfad);
      if (!knoten) return true;
      if (knoten.art === "ordner") {
        const namen = Object.keys(knoten.kinder);
        if (namen.length > 0) {
          if (!darf(knoten, z.benutzer, "r") || !darf(knoten, z.benutzer, "x")) {
            melde(`rm: cannot remove '${anzeige}': Permission denied`, grundHinweis("verweigert", anzeige));
            return false;
          }
          let alle = true;
          for (const n of namen) {
            const unter = anzeige.endsWith("/") ? anzeige + n : `${anzeige}/${n}`;
            alle = loesche(pfad === "/" ? `/${n}` : `${pfad}/${n}`, unter) && alle;
          }
          if (!alle) return false;
        }
      }
      const p = pruefeEltern(z, pfad);
      if (!p.ok) {
        melde(`rm: cannot remove '${anzeige}': ${grundText(p.grund)}`, grundHinweis(p.grund, anzeige));
        return false;
      }
      z = { ...z, wurzel: entferne(z.wurzel, pfad, k.jetzt) };
      if (o.flags.has("v")) ausgabe += knoten.art === "ordner" ? `removed directory '${anzeige}'\n` : `removed '${anzeige}'\n`;
      return true;
    };

    for (const getippt of o.rest) {
      const name = basisname(getippt);
      if ((name === "." || name === "..") && rekursiv) {
        melde(`rm: refusing to remove '.' or '..' directory: skipping '${getippt}'`, "Hinweis: Den aktuellen Ordner (.) und den übergeordneten (..) löscht rm aus Sicherheitsgründen nicht.");
        continue;
      }
      const pfad = absolut(z.cwd, getippt);
      if (pfad === "/") {
        if (rekursiv) {
          melde("rm: it is dangerous to operate recursively on '/'\nrm: use --no-preserve-root to override this failsafe", WURZEL_HINWEIS);
        } else {
          melde("rm: cannot remove '/': Is a directory", WURZEL_HINWEIS);
        }
        continue;
      }
      const fund = finde(z, absolutMitEnde(z.cwd, getippt));
      if (!fund.ok) {
        if (fund.grund === "fehlt" && still) continue;
        melde(`rm: cannot remove '${getippt}': ${grundText(fund.grund)}`, grundHinweis(fund.grund, getippt));
        continue;
      }
      if (fund.knoten.art === "ordner" && !rekursiv) {
        const leer = Object.keys(fund.knoten.kinder).length === 0;
        if (!o.flags.has("d")) {
          melde(
            `rm: cannot remove '${getippt}': Is a directory`,
            leer
              ? "Hinweis: Das ist ein Ordner. Leere Ordner löschst du mit rmdir, Ordner mit Inhalt mit rm -r."
              : "Hinweis: Das ist ein Ordner mit Inhalt. Den löschst du mit rm -r (Vorsicht, ohne Papierkorb).",
          );
          continue;
        }
        if (!leer) {
          melde(`rm: cannot remove '${getippt}': Directory not empty`, "Hinweis: rm -d löscht nur leere Ordner. Für Ordner mit Inhalt gibt es rm -r.");
          continue;
        }
      }
      loesche(fund.pfad, getippt);
    }

    // Systemordner weg (z. B. sudo rm -rf /*): augenzwinkernder Hinweis
    const systemWeg = ["/etc", "/usr", "/home"].some((p) => knotenBei(vorher, p) && !knotenBei(z.wurzel, p));
    if (systemWeg) hinweis = SYSTEM_WEG_HINWEIS;

    return {
      ausgabe,
      fehler,
      hinweis: fehler || systemWeg ? hinweis : undefined,
      zustand: z,
      code: fehler ? 1 : 0,
    };
  },
};
