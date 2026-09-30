// cat: Dateien ausgeben oder aneinanderhaengen (concatenate).

import { finde } from "../dateisystem";
import { grundHinweis, grundText } from "../hinweise";
import { absolutMitEnde } from "../pfade";
import { darf } from "../rechte";
import type { Befehl } from "../typen";
import { zerlegeOptionen } from "../optionen";

export const cat: Befehl = {
  name: "cat",
  bereich: "Lesen und Suchen",
  hilfe: {
    kurz: "gibt den Inhalt von Dateien aus. Ohne Datei liest cat, was über | hereinkommt.",
    aufruf: "cat [OPTION] [DATEI …]",
    optionen: [["-n", "Zeilen nummerieren"]],
    beispiele: [
      ["cat notizen.txt", "Inhalt anzeigen"],
      ["cat a.txt b.txt > beide.txt", "zwei Dateien zu einer zusammenfügen"],
    ],
  },
  lauf: (k) => {
    const o = zerlegeOptionen("cat", k.args, { flags: "n", lang: { number: "n" } });
    if (!o.ok) return o.fehler;
    const z = k.zustand;
    let text = "";
    let fehler = "";
    let hinweis: string | undefined;
    // Kam der erste Fehler vor dem ersten gelesenen Inhalt, zeigt die Anzeige ihn zuerst
    let ersterErfolg = false;
    const operanden = o.rest.length > 0 ? o.rest : ["-"];
    for (const getippt of operanden) {
      if (getippt === "-") {
        if (fehler === "") ersterErfolg = true;
        text += k.eingabe ?? "";
        continue;
      }
      const fund = finde(z, absolutMitEnde(z.cwd, getippt));
      if (!fund.ok) {
        fehler += `cat: ${getippt === "" ? "''" : getippt}: ${grundText(fund.grund)}\n`;
        hinweis ??= grundHinweis(fund.grund, getippt);
        continue;
      }
      if (fund.knoten.art === "ordner") {
        fehler += `cat: ${getippt}: Is a directory\n`;
        hinweis ??= `Hinweis: „${getippt}“ ist ein Ordner. Den Inhalt eines Ordners zeigt ls ${getippt}.`;
        continue;
      }
      if (!darf(fund.knoten, z.benutzer, "r")) {
        fehler += `cat: ${getippt}: Permission denied\n`;
        hinweis ??= grundHinweis("verweigert", getippt);
        continue;
      }
      if (k.ausgabeDatei === fund.pfad && fund.knoten.inhalt !== "") {
        fehler += `cat: ${getippt}: input file is output file\n`;
        hinweis ??= "Hinweis: cat kann nicht in dieselbe Datei schreiben, aus der es gerade liest. Schreib das Ergebnis in eine neue Datei.";
        continue;
      }
      if (text === "" && fehler === "") ersterErfolg = true;
      text += fund.knoten.inhalt;
    }
    if (o.flags.has("n") && text !== "") {
      const zeilen = text.split("\n");
      const letzteLeer = zeilen[zeilen.length - 1] === "";
      if (letzteLeer) zeilen.pop();
      text = zeilen.map((zeile, i) => `${String(i + 1).padStart(6)}\t${zeile}`).join("\n") + (letzteLeer ? "\n" : "");
    }
    return { ausgabe: text, fehler, hinweis: fehler ? hinweis : undefined, code: fehler ? 1 : 0, fehlerZuerst: !ersterErfolg };
  },
};
