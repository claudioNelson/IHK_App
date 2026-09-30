// tree: Ordner als Baum. Auf echten Servern oft erst mit "apt install tree"
// verfuegbar, zum Lernen aber sehr anschaulich.

import { finde, sortiereNamen } from "../dateisystem";
import { absolutMitEnde } from "../pfade";
import { darf } from "../rechte";
import type { Befehl, Knoten } from "../typen";
import { zerlegeOptionen } from "../optionen";
import { Ausgabe, anzahl, stilVon } from "./_gemeinsam";

export const tree: Befehl = {
  name: "tree",
  bereich: "Orientierung",
  hilfe: {
    kurz: "zeigt Ordner und Dateien als Baum. Auf echten Servern muss tree oft erst installiert werden.",
    aufruf: "tree [OPTION] [ORDNER]",
    optionen: [
      ["-a", "auch versteckte Einträge"],
      ["-d", "nur Ordner"],
      ["-L TIEFE", "nur bis zu dieser Tiefe"],
    ],
    beispiele: [["tree -L 1 /", "nur die oberste Ebene des Systems"]],
  },
  lauf: (k) => {
    const o = zerlegeOptionen("tree", k.args, { flags: "ad", mitWert: "L" });
    if (!o.ok) return o.fehler;
    const alle = o.flags.has("a");
    const nurOrdner = o.flags.has("d");
    let tiefe = Infinity;
    if (o.werte.has("L")) {
      const n = Number(o.werte.get("L"));
      if (!Number.isInteger(n) || n < 1) {
        return { fehler: "tree: Invalid level, must be greater than 0.\n", hinweis: "Hinweis: Hinter -L gehört eine Zahl ab 1, zum Beispiel tree -L 2.", code: 1 };
      }
      tiefe = n;
    }
    const z = k.zustand;
    const aus = new Ausgabe();
    let ordnerZahl = 0;
    let dateiZahl = 0;

    const zweig = (knoten: Knoten, praefix: string, ebene: number) => {
      if (knoten.art !== "ordner" || ebene > tiefe) return;
      if (!darf(knoten, z.benutzer, "r")) {
        aus.add("  [error opening dir]");
        return;
      }
      const namen = sortiereNamen(Object.keys(knoten.kinder)).filter(
        (n) => (alle || !n.startsWith(".")) && (!nurOrdner || knoten.kinder[n].art === "ordner"),
      );
      namen.forEach((name, i) => {
        const kind = knoten.kinder[name];
        const letzter = i === namen.length - 1;
        aus.add("\n" + praefix + (letzter ? "└── " : "├── "));
        aus.add(name, stilVon(kind));
        if (kind.art === "ordner") {
          ordnerZahl++;
          zweig(kind, praefix + (letzter ? "    " : "│   "), ebene + 1);
        } else dateiZahl++;
      });
    };

    // Wie tree 2.x (Ubuntu 24.04): der Startordner zaehlt mit, fehlende Pfade ergeben Code 2
    let code = 0;
    const operanden = o.rest.length > 0 ? o.rest : ["."];
    operanden.forEach((getippt, i) => {
      if (i > 0) aus.add("\n");
      const fund = finde(z, absolutMitEnde(z.cwd, getippt));
      if (!fund.ok) {
        aus.add(`${getippt}  [error opening dir]`);
        code = 2;
        return;
      }
      aus.add(getippt, stilVon(fund.knoten));
      if (fund.knoten.art === "ordner" && !darf(fund.knoten, z.benutzer, "r")) {
        aus.add("  [error opening dir]");
        dateiZahl++;
        return;
      }
      if (fund.knoten.art === "ordner") {
        ordnerZahl++;
        zweig(fund.knoten, "", 1);
      } else dateiZahl++;
    });
    aus.add(
      `\n\n${anzahl(ordnerZahl, "directory", "directories")}` + (nurOrdner ? "" : `, ${anzahl(dateiZahl, "file", "files")}`) + "\n",
    );
    return { ausgabe: aus.text, anzeige: aus.teile, code };
  },
};
