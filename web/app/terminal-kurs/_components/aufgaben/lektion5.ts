// Aufgaben zu Lektion 5 (Benutzer und Rechte). Befehle dieser Lektion:
// ls -l, id, groups, chmod (Zahlen und Buchstaben), chown, sudo.

import { knotenBei } from "../../_engine/dateisystem";
import { szenario } from "../../_engine/szenarien";
import type { Zustand } from "../../_engine/typen";
import { eigenes, hatOption, rechteSind, type Aufgabe } from "../../_engine/ziele";
import { authLog } from "./_daten";
import { HOME, pfade, vorTagen } from "./_hilfen";

/** Server mit eigenem Skript, privater Datei, Webseite von root und der Kollegin mia. */
const rechteServer = () =>
  szenario({
    "/home/azubi/backup.sh": { inhalt: "#!/bin/bash\n# Sichert den Ordner projekte\ntar -czf /tmp/projekte.tar.gz ~/projekte\n", geaendert: vorTagen(3) },
    "/home/azubi/zugang.txt": { inhalt: "WLAN-Passwort Büro: Sommer2026!\n", geaendert: vorTagen(10) },
    "/home/azubi/notizen.txt": { inhalt: "Webseite an www-data übergeben\n", geaendert: vorTagen(2) },
    "/home/azubi/projekte/": { ordner: true, geaendert: vorTagen(7) },
    "/home/mia/bericht.txt": { inhalt: "Bericht von Mia\n", rechte: 0o600, geaendert: vorTagen(4) },
    "/var/www/html/index.html": { inhalt: "<!doctype html>\n<h1>Willkommen auf web01</h1>\n", geaendert: vorTagen(20) },
    "/var/www/html/kontakt.html": { inhalt: "<!doctype html>\n<h1>Kontakt</h1>\n", geaendert: vorTagen(20) },
    "/var/log/auth.log": { inhalt: authLog(), besitzer: "syslog", gruppe: "adm", rechte: 0o640, geaendert: vorTagen(0, 6, 40) },
    "/etc/shadow": { inhalt: "root:*:20000:0:99999:7:::\nazubi:$y$j9T$geheim:20000:0:99999:7:::\n", gruppe: "shadow", rechte: 0o640 },
  });

/** Eintrag hat die richtige Art, gehoert azubi und hat genau diese Rechte. */
const passt = (z: Zustand, pfad: string, art: "datei" | "ordner", rechte: number) => {
  const k = knotenBei(z.wurzel, pfad);
  return k?.art === art && k.besitzer === "azubi" && k.rechte % 0o1000 === rechte;
};

const BEGRUESSUNG = `Willkommen im Übungs-Terminal von Lernarena.
Probier: id, ls -l, ls -l /etc/shadow, ls -l /var/log
`;

export const lektion5: Record<string, Aufgabe> = {
  "l5-frei": { szenario: rechteServer, ziele: [], tipps: [], begruessung: BEGRUESSUNG },

  "l5-lesen": {
    szenario: rechteServer,
    ziele: [
      eigenes("Finde heraus, in welchen Gruppen du bist", (_z, v) =>
        v.some((e) => (e.name === "id" || e.name === "groups") && !e.sudo && e.code === 0 && e.ausgabe.includes("adm") && e.ausgabe.includes("sudo")),
      ),
      eigenes("Zeige die Rechte von backup.sh in der langen Form", (_z, v) =>
        v.some((e) => e.name === "ls" && e.code === 0 && hatOption(e.args, "l") && e.ausgabe.includes("backup.sh") && (pfade(e).length === 0 || pfade(e).some((p) => p === `${HOME}/backup.sh` || p === HOME))),
      ),
    ],
    tipps: ["Gruppen zeigt id oder groups.", "Die lange Form ist ls -l. Nur die eine Datei: ls -l backup.sh"],
  },

  "l5-chmod": {
    szenario: rechteServer,
    ziele: [
      // x fuer den Besitzer, aber nicht fuer alle beschreibbar (kein 777)
      eigenes("Mach backup.sh für dich ausführbar", (z) => {
        const r = knotenBei(z.wurzel, `${HOME}/backup.sh`)?.rechte ?? 0;
        return (r & 0o100) !== 0 && (r & 0o002) === 0;
      }),
      rechteSind(`${HOME}/zugang.txt`, 0o600, "Setze zugang.txt so, dass nur du lesen und schreiben darfst (600)"),
    ],
    tipps: [
      "Ausführen ist das Recht x, für dich als Besitzer u: chmod u+x backup.sh",
      "rw------- ist 6 0 0: chmod 600 zugang.txt",
    ],
  },

  "l5-chown": {
    szenario: rechteServer,
    ziele: [
      eigenes("Übergib die beiden Seiten in /var/www/html an www-data (Besitzer und Gruppe)", (z) =>
        ["index.html", "kontakt.html"].every((n) => {
          const k = knotenBei(z.wurzel, `/var/www/html/${n}`);
          return k?.besitzer === "www-data" && k.gruppe === "www-data";
        }),
      ),
      eigenes("Nutze dafür sudo", (_z, v) => v.some((e) => e.sudo && e.name === "chown" && e.code === 0)),
    ],
    tipps: [
      "Den Besitzer ändert chown, aber nur root darf das. Also sudo davor.",
      "Besitzer und Gruppe auf einmal: BESITZER:GRUPPE",
      "sudo chown www-data:www-data /var/www/html/index.html /var/www/html/kontakt.html (oder kürzer mit /var/www/html/*)",
    ],
  },

  "l5-knobel": {
    szenario: rechteServer,
    ziele: [
      eigenes("Lege den Ordner team an: du darfst alles, die Gruppe lesen und hineinwechseln, andere nichts", (z) => passt(z, `${HOME}/team`, "ordner", 0o750)),
      eigenes("Lege darin plan.txt an: du liest und schreibst, die Gruppe liest, andere nichts", (z) => passt(z, `${HOME}/team/plan.txt`, "datei", 0o640)),
    ],
    tipps: [
      "Schreib die Rechte zuerst als Buchstaben auf: Ordner rwxr-x---, Datei rw-r-----.",
      "Rechne jede Dreiergruppe um: r = 4, w = 2, x = 1, dann zusammenzählen.",
      "mkdir team, chmod 750 team, touch team/plan.txt, chmod 640 team/plan.txt",
    ],
  },
};
