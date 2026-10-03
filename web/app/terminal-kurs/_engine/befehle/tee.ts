// tee: liest aus der Pipe und schreibt gleichzeitig auf den Bildschirm und in
// Dateien (wie ein T-Stueck in einer Wasserleitung).

import { finde, neueDatei, pruefeEltern, setze } from "../dateisystem";
import { grundHinweis, grundText } from "../hinweise";
import { absolut, endetMitSchraegstrich } from "../pfade";
import { darf } from "../rechte";
import type { Befehl, Zustand } from "../typen";
import { zerlegeOptionen } from "../optionen";

export const tee: Befehl = {
  name: "tee",
  bereich: "Verketten",
  hilfe: {
    kurz: "schreibt, was über | hereinkommt, auf den Bildschirm und zugleich in Dateien.",
    aufruf: "tee [OPTION] [DATEI …]",
    optionen: [["-a", "an die Datei anhängen statt sie zu überschreiben (append)"]],
    beispiele: [
      ["ls -l | tee liste.txt", "Liste ansehen und speichern"],
      ["echo Neu | tee -a log.txt", "Zeile anhängen und anzeigen"],
    ],
  },
  lauf: (k) => {
    const o = zerlegeOptionen("tee", k.args, { flags: "a", lang: { append: "a" } });
    if (!o.ok) return o.fehler;
    if (k.eingabe === null) {
      return {
        hinweis: "Hinweis: tee liest, was über | hereinkommt, zum Beispiel ls | tee liste.txt. Auf einem echten Server würde tee jetzt auf Eingabe von der Tastatur warten.",
        code: 0,
      };
    }
    const text = k.eingabe;
    let z: Zustand = k.zustand;
    let fehler = "";
    let hinweis: string | undefined;
    for (const getippt of o.rest) {
      const pfad = absolut(z.cwd, getippt);
      if (pfad === "/dev/null") continue;
      const fund = finde(z, pfad);
      if (fund.ok) {
        if (fund.knoten.art === "ordner") {
          fehler += `tee: ${getippt}: Is a directory\n`;
          hinweis ??= `Hinweis: „${getippt}“ ist ein Ordner. tee schreibt nur in Dateien.`;
          continue;
        }
        if (!darf(fund.knoten, z.benutzer, "w")) {
          fehler += `tee: ${getippt}: Permission denied\n`;
          hinweis ??= grundHinweis("verweigert", getippt);
          continue;
        }
        const inhalt = o.flags.has("a") ? fund.knoten.inhalt + text : text;
        z = { ...z, wurzel: setze(z.wurzel, pfad, { ...fund.knoten, inhalt, geaendert: k.jetzt }, k.jetzt, false) };
        continue;
      }
      if (fund.grund !== "fehlt" || endetMitSchraegstrich(getippt)) {
        fehler += `tee: ${getippt}: ${endetMitSchraegstrich(getippt) && fund.grund === "fehlt" ? "Is a directory" : grundText(fund.grund)}\n`;
        hinweis ??= grundHinweis(fund.grund, getippt);
        continue;
      }
      const p = pruefeEltern(z, pfad);
      if (!p.ok) {
        fehler += `tee: ${getippt}: ${grundText(p.grund)}\n`;
        hinweis ??= grundHinweis(p.grund, getippt);
        continue;
      }
      z = { ...z, wurzel: setze(z.wurzel, pfad, neueDatei(z, text, k.jetzt), k.jetzt) };
    }
    return { ausgabe: text, fehler, hinweis: fehler ? hinweis : undefined, zustand: z, code: fehler ? 1 : 0, fehlerZuerst: fehler !== "" };
  },
};
