// less: Datei zum Blaettern oeffnen. Das Uebungs-Terminal hat keinen
// Vollbild-Modus, deshalb zeigt less den Inhalt direkt und erklaert die Tasten.

import { zerlegeOptionen } from "../optionen";
import type { Befehl } from "../typen";
import { leseQuellen } from "./_lesen";

export const less: Befehl = {
  name: "less",
  bereich: "Lesen und Suchen",
  hilfe: {
    kurz: "öffnet eine Datei zum Blättern. Leertaste blättert weiter, b zurück, /wort sucht, q beendet.",
    aufruf: "less [OPTION] DATEI",
    optionen: [["-N", "Zeilennummern anzeigen"]],
    beispiele: [["less /var/log/syslog", "lange Logdatei in Ruhe lesen"]],
  },
  lauf: (k) => {
    const o = zerlegeOptionen("less", k.args, { flags: "N", lang: { "LINE-NUMBERS": "N" } });
    if (!o.ok) return o.fehler;
    if (o.rest.length === 0 && k.eingabe === null) {
      return { fehler: "Missing filename (\"less --help\" for help)\n", hinweis: "Hinweis: less braucht eine Datei, zum Beispiel less /etc/passwd.", code: 1 };
    }
    const g = leseQuellen(k, o.rest, (getippt, text, istOrdner) => (istOrdner ? `${getippt} is a directory\n` : `${getippt}: ${text}\n`));
    let text = g.quellen.map((q) => q.inhalt).join("");
    if (o.flags.has("N")) {
      const zeilen = text.split("\n");
      if (zeilen[zeilen.length - 1] === "") zeilen.pop();
      text = zeilen.map((z, i) => `${String(i + 1).padStart(7)} ${z}\n`).join("");
    }
    const hinweis = k.tty
      ? "Hinweis: Auf einem echten Server öffnet less die Datei bildschirmfüllend: Leertaste blättert weiter, b zurück, /wort sucht, q beendet. Im Übungs-Terminal siehst du den Inhalt direkt."
      : undefined;
    return { ausgabe: text, fehler: g.fehler, hinweis: g.fehler ? g.hinweis : hinweis, code: g.fehler ? 1 : 0, fehlerZuerst: false };
  },
};
