// Spielwiese „Freies Terminal“ (/terminal-kurs/spielwiese): groesseres
// Uebungs-Linux zum freien Ausprobieren, dazu eine Entdecker-Liste, die sich
// von selbst abhakt. Kein Zwang, nur Anreiz.

import { szenario } from "../../_engine/szenarien";
import type { ProtokollEintrag } from "../../_engine/typen";
import { eigenes, type Aufgabe } from "../../_engine/ziele";
import { ANGREIFER, PROJEKT_DATEIEN, authLog, sysLog } from "./_daten";
import { pfade, vorTagen } from "./_hilfen";

const MOTD = `Willkommen auf lernarena (Ubuntu 24.04.1 LTS)

Das ist das freie Übungs-Terminal. Probier aus, was du im Kurs gelernt
hast, oder schau dich einfach um. Kaputt machen kannst du nichts.

Ein paar Dinge sind versteckt. Die Liste unter dem Terminal verrät, was.
Tippe help für alle Befehle.
`;

/** Erkennungstexte der versteckten Dateien */
const GEHEIM = "Gut gefunden!";
const SCHATZ = "Der Ordner von root";

/** Befehle, mit denen man den Inhalt einer Datei sieht */
const LESEN = ["cat", "less", "head", "tail", "grep"];

const zeigt = (e: ProtokollEintrag, text: string) => LESEN.includes(e.name) && e.ausgabe.includes(text);

const spielwiese = () =>
  szenario({
    "/etc/motd": MOTD,
    "/etc/timezone": "Etc/UTC\n",
    "/etc/crontab": "SHELL=/bin/sh\n# m h dom mon dow user command\n17 * * * * root cd / && run-parts --report /etc/cron.hourly\n30 2 * * * root /usr/local/bin/backup.sh\n",
    "/etc/ssh/sshd_config": "Port 22\nPermitRootLogin no\nPasswordAuthentication no\n",
    "/etc/nginx/nginx.conf": "user www-data;\nworker_processes auto;\n",
    "/etc/shadow": { inhalt: "root:*:20000:0:99999:7:::\nazubi:$y$j9T$geheim:20000:0:99999:7:::\n", gruppe: "shadow", rechte: 0o640 },

    "/home/azubi/notizen.txt": { inhalt: "Server web01 neu starten\nBackup prüfen\nZertifikat erneuern\n", geaendert: vorTagen(5) },
    "/home/azubi/todo.txt": { inhalt: "Drucker im Büro einrichten\nNeuen Kollegen anlegen\nLogdateien durchsehen\n", geaendert: vorTagen(3) },
    "/home/azubi/skript.sh": { inhalt: "#!/bin/bash\necho \"Hallo aus dem Skript\"\n", geaendert: vorTagen(2) },
    "/home/azubi/.bashrc": { inhalt: "# Einstellungen der Bash für azubi\nalias ll='ls -alF'\nalias grep='grep --color=auto'\n", geaendert: vorTagen(40) },
    "/home/azubi/.geheim": {
      inhalt: `${GEHEIM} Versteckte Dateien beginnen mit einem Punkt und erscheinen erst mit ls -a.\n\nNächste Spur: In /var/log/auth.log versucht jemand, sich von außen als root anzumelden.\nVon welcher IP-Adresse kommen die Versuche?\n`,
      rechte: 0o600,
      geaendert: vorTagen(12),
    },
    ...Object.fromEntries(Object.entries(PROJEKT_DATEIEN).map(([p, inhalt]) => [p, { inhalt, geaendert: vorTagen(8) }])),
    "/home/azubi/downloads/rechnung.pdf": { inhalt: "%PDF".padEnd(5300, "."), geaendert: vorTagen(4) },
    "/home/azubi/downloads/setup.tmp": { inhalt: "x".repeat(300), geaendert: vorTagen(2) },
    "/home/azubi/backup/": { ordner: true, geaendert: vorTagen(20) },

    "/home/mia/bericht.txt": { inhalt: "Bericht von Mia\n", rechte: 0o600, geaendert: vorTagen(4) },

    "/root/schatz.txt": {
      inhalt: `${SCHATZ} ist für normale Benutzer gesperrt. Mit sudo kommst du trotzdem hinein,\ndenn root darf alles. Genau deshalb arbeiten Administratoren als normaler Benutzer und\nnehmen sudo nur, wenn sie es wirklich brauchen. Jeder sudo-Aufruf steht übrigens in\n/var/log/auth.log.\n`,
      rechte: 0o600,
      geaendert: vorTagen(30),
    },

    "/var/log/auth.log": { inhalt: authLog(), besitzer: "syslog", gruppe: "adm", rechte: 0o640, geaendert: vorTagen(0, 6, 40) },
    "/var/log/syslog": { inhalt: sysLog(), besitzer: "syslog", gruppe: "adm", rechte: 0o640, geaendert: vorTagen(0, 6, 30) },
    "/var/www/html/index.html": { inhalt: "<!doctype html>\n<h1>Willkommen auf web01</h1>\n", geaendert: vorTagen(20) },
    "/opt/": {},
    "/mnt/": {},
  });

export const spielwieseAufgaben: Record<string, Aufgabe> = {
  "spielwiese": {
    szenario: spielwiese,
    begruessung: MOTD,
    zielTitel: "Entdecken (freiwillig)",
    fertigText: "Alles entdeckt! Damit kennst du die wichtigsten Werkzeuge eines Administrators. Probier ruhig weiter aus, was dir einfällt.",
    tipps: [],
    ziele: [
      eigenes("Finde die versteckte Datei in deinem Home-Ordner", (_z, v) => v.some((e) => e.name === "ls" && e.code === 0 && e.ausgabe.includes(".geheim"))),
      eigenes("Lies, was in ihr steht", (_z, v) => v.some((e) => zeigt(e, GEHEIM))),
      eigenes("Finde die IP-Adresse, von der jemand als root einbrechen will", (_z, v) => v.some((e) => zeigt(e, ANGREIFER))),
      eigenes("Schau mit sudo in den Ordner von root", (_z, v) =>
        v.some((e) => e.name === "ls" && e.code === 0 && (pfade(e).includes("/root") || e.cwd === "/root")),
      ),
      eigenes("Lies die Datei, die dort liegt", (_z, v) => v.some((e) => zeigt(e, SCHATZ))),
      eigenes("Finde mit einem einzigen Befehl alle TODO-Notizen in deinen Projekten", (_z, v) =>
        v.some((e) => e.name === "grep" && (e.ausgabe.match(/TODO/g) ?? []).length >= 3),
      ),
      eigenes("Lege mit echo und > eine eigene Datei an", (z) => z.verlauf.some((zeile) => /\becho\b[^|]*>/.test(zeile))),
    ],
  },
};
