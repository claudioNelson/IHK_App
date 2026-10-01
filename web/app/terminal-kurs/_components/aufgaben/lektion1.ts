// Aufgaben zu Lektion 1 (Was ist ein Terminal?) und das Terminal im Kopf der
// Kursuebersicht. Befehle dieser Lektion: whoami, date, echo, pwd, ls, help,
// man, history, clear.

import { absolut } from "../../_engine/pfade";
import { szenario } from "../../_engine/szenarien";
import type { ProtokollEintrag } from "../../_engine/typen";
import { benutzt, eigenes, hatOption, type Aufgabe } from "../../_engine/ziele";

/**
 * Zeitpunkt vor einigen Tagen, 09:30 UTC. Relativ zu heute, damit ls -l immer
 * Datum und Uhrzeit zeigt (Dateien aelter als ein halbes Jahr zeigen das Jahr).
 */
const vorTagen = (tage: number) => {
  const d = new Date(Date.now() - tage * 86_400_000);
  d.setUTCHours(9, 30, 0, 0);
  return d;
};

const HOME = "/home/azubi";

/** Home-Ordner der Lektion: sichtbare und versteckte Eintraege mit verschiedenen Zeiten (fuer ls -t). */
const heim = () =>
  szenario({
    "/home/azubi/notizen.txt": { inhalt: "Server web01 neu starten\nBackup prüfen\n", geaendert: vorTagen(16) },
    "/home/azubi/todo.txt": { inhalt: "Drucker im Büro einrichten\n", geaendert: vorTagen(8) },
    "/home/azubi/bericht.txt": { inhalt: "Wochenbericht KW 39\n", geaendert: vorTagen(2) },
    "/home/azubi/projekte/webshop/index.html": { inhalt: "<h1>Shop</h1>\n", geaendert: vorTagen(12) },
    "/home/azubi/projekte/": { ordner: true, geaendert: vorTagen(12) },
    "/home/azubi/bilder/": { ordner: true, geaendert: vorTagen(28) },
    "/home/azubi/.geheimtipp": { inhalt: "Gut gefunden! Versteckte Dateien beginnen mit einem Punkt.\n", geaendert: vorTagen(29) },
    "/home/azubi/.bashrc": { inhalt: "# Einstellungen der Bash für azubi\n# wird bei jedem neuen Terminal gelesen\n", geaendert: vorTagen(31) },
    "/home/azubi/.profile": { inhalt: "# wird beim Anmelden gelesen\n", geaendert: vorTagen(31) },
    // ein paar typische Einstellungsdateien, damit /etc nach einem echten System aussieht
    "/etc/timezone": "Etc/UTC\n",
    "/etc/fstab": "# <file system> <mount point> <type> <options> <dump> <pass>\nLABEL=cloudimg-rootfs / ext4 discard,errors=remount-ro 0 1\n",
    "/etc/crontab": "SHELL=/bin/sh\n# m h dom mon dow user command\n17 * * * * root cd / && run-parts --report /etc/cron.hourly\n",
    "/etc/ssh/sshd_config": "Port 22\nPermitRootLogin no\nPasswordAuthentication no\n",
    "/etc/apt/sources.list": "deb http://archive.ubuntu.com/ubuntu noble main restricted universe\n",
  });

const BEGRUESSUNG_START = `Willkommen im Übungs-Terminal von Lernarena.
Hier tippst du echte Linux-Befehle. Kaputt machen kannst du nichts.

Probier zum Start: ls, dann ls -la, dann help
`;

const BEGRUESSUNG_FREI = `Willkommen im Übungs-Terminal von Lernarena.
Tippe help und drücke Enter, um alle Befehle zu sehen.
`;

/** Argumente ohne Optionen, als absolute Pfade vom Ordner beim Aufruf aus. */
const pfade = (e: ProtokollEintrag) => e.args.filter((a) => !a.startsWith("-")).map((a) => absolut(e.cwd, a));

/** ls lief ohne Ordnerwechsel auf /etc: der Ordner stand als Argument da. */
const listetEtc = (e: ProtokollEintrag) =>
  e.name === "ls" && e.code === 0 && e.cwd !== "/etc" && pfade(e).includes("/etc") && e.ausgabe.includes("os-release");

/** ls -l zeigte genau eine Zeile, und zwar die von /etc/hostname (egal wie der Pfad getippt war). */
const zeigtHostnameLang = (e: ProtokollEintrag) => {
  if (e.name !== "ls" || e.code !== 0 || !hatOption(e.args, "l")) return false;
  const p = pfade(e);
  return p.length === 1 && p[0] === "/etc/hostname" && e.ausgabe.trim().split("\n").length === 1;
};

/** ls mit -t (ohne -r, sonst waere das Aelteste oben) auf den Home-Ordner. */
const neuesteImHome = (e: ProtokollEintrag) => {
  if (e.name !== "ls" || e.code !== 0 || !hatOption(e.args, "t") || hatOption(e.args, "r")) return false;
  const p = pfade(e);
  return p.length === 0 ? e.cwd === HOME : p.every((x) => x === HOME);
};

export const lektion1: Record<string, Aufgabe> = {
  "l0-start": { szenario: heim, ziele: [], tipps: [], begruessung: BEGRUESSUNG_START },

  "l1-frei": { szenario: heim, ziele: [], tipps: [], begruessung: BEGRUESSUNG_FREI },

  "l1-erster-befehl": {
    szenario: heim,
    ziele: [
      benutzt("whoami", "Finde heraus, als welcher Benutzer du angemeldet bist"),
      benutzt("date", "Lass dir Datum und Uhrzeit des Servers anzeigen"),
    ],
    tipps: [
      "„Wer bin ich?“ heißt auf Englisch „who am I“. Genau so heißt der Befehl, nur zusammengeschrieben und klein.",
      "Datum heißt auf Englisch „date“.",
    ],
  },

  "l1-option": {
    szenario: heim,
    ziele: [
      benutzt("ls", "Zeige mit ls auch die versteckten Dateien an", (a) => hatOption(a, "a", "all") || hatOption(a, "A", "almost-all")),
      benutzt(
        "ls",
        "Zeige alle Dateien in der langen Form mit Details",
        (a) => hatOption(a, "l") && (hatOption(a, "a", "all") || hatOption(a, "A", "almost-all")),
      ),
    ],
    tipps: [
      "Tippe ls -a und drücke Enter. Die Namen mit Punkt am Anfang sind die versteckten Dateien.",
      "Optionen lassen sich zusammenfassen: ls -la ist dasselbe wie ls -l -a.",
    ],
  },

  "l1-argument": {
    szenario: heim,
    ziele: [
      eigenes("Liste den Inhalt des Ordners /etc auf, ohne dorthin zu wechseln", (_z, v) => v.some(listetEtc)),
      eigenes("Zeige nur die Datei /etc/hostname in der langen Form", (_z, v) => v.some(zeigtHostnameLang)),
    ],
    tipps: [
      "Der Ordner ist das Argument, es steht hinter dem Befehl: ls /etc",
      "Ein Argument kann auch eine einzelne Datei sein. Mit der Option für die lange Form: ls -l /etc/hostname",
    ],
  },

  "l1-hilfe": {
    szenario: heim,
    ziele: [
      eigenes("Rufe die Anleitung zu ls auf", (_z, v) =>
        v.some((e) => e.code === 0 && ((e.name === "man" && e.args.includes("ls")) || (e.name === "ls" && e.args.includes("--help")))),
      ),
      eigenes("Liste deinen Home-Ordner so auf, dass das Neueste oben steht", (_z, v) => v.some(neuesteImHome)),
      benutzt("history", "Lass dir die Befehle anzeigen, die du bisher getippt hast", (a) => !a.includes("-c")),
    ],
    tipps: [
      "Die Anleitung zu einem Befehl zeigt man BEFEHL, hier also man ls.",
      "In der Anleitung steht die Option -t: neueste zuerst. Probier ls -t oder mit Details ls -lt.",
      "Die bisherigen Befehle zeigt history.",
    ],
  },
};
