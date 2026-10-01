// Aufgaben zu Lektion 2 (Im Dateisystem bewegen). Befehle dieser Lektion:
// pwd, cd, ls (-h, -R) und tree.

import { szenario } from "../../_engine/szenarien";
import type { ProtokollEintrag } from "../../_engine/typen";
import { benutzt, eigenes, hatOption, imOrdner, type Aufgabe } from "../../_engine/ziele";
import { HOME, betrifftOrdner, landetIn, logDatei, vorTagen } from "./_hilfen";

const PROJEKTE = `${HOME}/projekte`;
const WEBSHOP = `${PROJEKTE}/webshop`;
/** Ziel der Knobelaufgabe: drei Ebenen unter projekte */
const NETZWERK = `${PROJEKTE}/intranet/doku/netzwerk`;

const SYSLOG = [
  "systemd[1]: Started session-{pid}.scope - Session {pid} of User azubi.",
  "CRON[{pid}]: (root) CMD (test -x /usr/sbin/anacron || run-parts --report /etc/cron.daily)",
  "systemd[1]: Starting apt-daily.service - Daily apt download activities...",
  "systemd[1]: apt-daily.service: Deactivated successfully.",
  "systemd-timesyncd[{pid}]: Contacted time server 185.125.190.57:123 (ntp.ubuntu.com).",
  "nginx[{pid}]: 2026/09/30 worker process started",
];
const AUTHLOG = [
  "sshd[{pid}]: Accepted publickey for azubi from 10.0.0.15 port 51522 ssh2",
  "sshd[{pid}]: pam_unix(sshd:session): session opened for user azubi(uid=1000) by azubi(uid=0)",
  "sudo:    azubi : TTY=pts/0 ; PWD=/home/azubi ; USER=root ; COMMAND=/usr/bin/apt update",
  "sshd[{pid}]: pam_unix(sshd:session): session closed for user azubi",
];
const KERNLOG = ["kernel: [    0.000000] Linux version 6.8.0-45-generic (buildd@lcy02-amd64-075)", "kernel: [    1.204311] EXT4-fs (sda1): mounted filesystem"];
const DPKGLOG = [
  "status installed nginx:amd64 1.24.0-2ubuntu7",
  "status unpacked libssl3t64:amd64 3.0.13-0ubuntu3.4",
  "configure openssh-server:amd64 1:9.6p1-3ubuntu13.5 <none>",
  "status half-configured tree:amd64 2.1.1-2ubuntu3",
];
const ACCESS = [
  'nginx: 10.0.0.15 - - "GET / HTTP/1.1" 200 612 "-" "Mozilla/5.0"',
  'nginx: 10.0.0.22 - - "GET /bilder/logo.png HTTP/1.1" 200 4821 "-" "Mozilla/5.0"',
  'nginx: 10.0.0.15 - - "GET /favicon.ico HTTP/1.1" 404 162 "-" "Mozilla/5.0"',
];

/**
 * Szenario der Lektion: verschachtelter Ordner projekte im Home-Ordner, dazu
 * ein glaubwuerdiges /var mit Logdateien verschiedener Groesse (fuer ls -lh)
 * und einer Webseite unter /var/www/html.
 */
const system = () =>
  szenario({
    // Home-Ordner
    "/home/azubi/notizen.txt": { inhalt: "Server web01 neu starten\nBackup prüfen\n", geaendert: vorTagen(16) },
    "/home/azubi/todo.txt": { inhalt: "Drucker im Büro einrichten\n", geaendert: vorTagen(8) },
    "/home/azubi/downloads/": { ordner: true, geaendert: vorTagen(5) },
    "/home/azubi/.bashrc": { inhalt: "# Einstellungen der Bash für azubi\n", geaendert: vorTagen(31) },
    // projekte: webshop, intranet (mit tief versteckter serverliste.txt), archiv
    "/home/azubi/projekte/webshop/index.html": { inhalt: "<!doctype html>\n<h1>Shop</h1>\n", geaendert: vorTagen(12) },
    "/home/azubi/projekte/webshop/css/style.css": { inhalt: "body { font-family: sans-serif; }\n", geaendert: vorTagen(12) },
    "/home/azubi/projekte/webshop/bilder/logo.png": { inhalt: "PNG".padEnd(4821, "."), geaendert: vorTagen(20) },
    "/home/azubi/projekte/webshop/bilder/banner.png": { inhalt: "PNG".padEnd(18_204, "."), geaendert: vorTagen(20) },
    "/home/azubi/projekte/intranet/index.html": { inhalt: "<!doctype html>\n<h1>Intranet</h1>\n", geaendert: vorTagen(9) },
    "/home/azubi/projekte/intranet/doku/anleitung.txt": { inhalt: "So richtest du einen neuen Arbeitsplatz ein:\n1. Benutzer anlegen\n", geaendert: vorTagen(9) },
    "/home/azubi/projekte/intranet/doku/netzwerk/netzplan.txt": { inhalt: "Netz 10.0.0.0/24, Gateway 10.0.0.1\n", geaendert: vorTagen(7) },
    "/home/azubi/projekte/intranet/doku/netzwerk/serverliste.txt": {
      inhalt: "web01   10.0.0.10   Webserver\ndb01    10.0.0.11   Datenbank\nbackup  10.0.0.12   Sicherung\n",
      geaendert: vorTagen(7),
    },
    "/home/azubi/projekte/archiv/2025/webshop-alt.txt": { inhalt: "Alte Version des Webshops\n", geaendert: vorTagen(60) },
    "/home/azubi/projekte/archiv/2025/": { ordner: true, geaendert: vorTagen(60) },
    "/home/azubi/projekte/": { ordner: true, geaendert: vorTagen(7) },
    // Einstellungen
    "/etc/timezone": "Etc/UTC\n",
    "/etc/ssh/sshd_config": "Port 22\nPermitRootLogin no\nPasswordAuthentication no\n",
    "/etc/nginx/nginx.conf": "user www-data;\nworker_processes auto;\n",
    // Logdateien in verschiedenen Groessen
    "/var/log/syslog": { inhalt: logDatei(SYSLOG, 620), gruppe: "adm", rechte: 0o640, geaendert: vorTagen(0, 6, 0) },
    "/var/log/auth.log": { inhalt: logDatei(AUTHLOG, 95, 40), gruppe: "adm", rechte: 0o640, geaendert: vorTagen(0, 5, 48) },
    "/var/log/kern.log": { inhalt: logDatei(KERNLOG, 34, 300), gruppe: "adm", rechte: 0o640, geaendert: vorTagen(1, 22, 14) },
    "/var/log/dpkg.log": { inhalt: logDatei(DPKGLOG, 410, 30), geaendert: vorTagen(3, 14, 2) },
    "/var/log/boot.log": { inhalt: "[  OK  ] Started ssh.service - OpenBSD Secure Shell server.\n".repeat(14), geaendert: vorTagen(4, 7, 1) },
    "/var/log/nginx/access.log": { inhalt: logDatei(ACCESS, 160, 15), besitzer: "www-data", gruppe: "adm", rechte: 0o640, geaendert: vorTagen(0, 5, 59) },
    "/var/log/nginx/error.log": { inhalt: "", besitzer: "www-data", gruppe: "adm", rechte: 0o640, geaendert: vorTagen(4, 7, 1) },
    "/var/log/apt/history.log": { inhalt: "Start-Date: 2026-09-26  14:02:11\nCommandline: apt install tree\nEnd-Date: 2026-09-26  14:02:15\n", geaendert: vorTagen(3, 14, 2) },
    // Webseite
    "/var/www/html/index.html": { inhalt: "<!doctype html>\n<h1>Willkommen auf web01</h1>\n", geaendert: vorTagen(20) },
    "/opt/": {},
    "/mnt/": {},
    "/media/": {},
  });

const BEGRUESSUNG = `Willkommen im Übungs-Terminal von Lernarena.
Probier: pwd, dann tree -L 1 /, dann cd /var/log und ls
`;

/** ls (lang, lesbare Groessen) auf /var/log. */
const zeigtLogsLesbar = (e: ProtokollEintrag) =>
  e.name === "ls" && e.code === 0 && hatOption(e.args, "l") && hatOption(e.args, "h", "human-readable") && betrifftOrdner(e, "/var/log");

/** tree oder ls -R, also eine Ausgabe mit allen Unterordnern. */
const zeigtAlles = (e: ProtokollEintrag) => e.code === 0 && (e.name === "tree" || (e.name === "ls" && hatOption(e.args, "R", "recursive")));

/** projekte mit allen Unterordnern (bis hinunter zu netzwerk, auch mit tree -d). */
const zeigtProjekteKomplett = (e: ProtokollEintrag) => zeigtAlles(e) && betrifftOrdner(e, PROJEKTE) && e.ausgabe.includes("netzwerk");

export const lektion2: Record<string, Aufgabe> = {
  "l2-frei": { szenario: system, ziele: [], tipps: [], begruessung: BEGRUESSUNG },

  "l2-cd": {
    szenario: system,
    ziele: [
      benutzt("pwd", "Zeige mit pwd an, in welchem Ordner du gerade bist"),
      imOrdner(WEBSHOP, "Wechsle in den Ordner projekte und von dort in webshop"),
      eigenes("Geh von webshop aus eine Ebene nach oben", (_z, v) => v.some((e) => e.cwd === WEBSHOP && landetIn(e) === PROJEKTE)),
      eigenes("Kehre in deinen Home-Ordner zurück", (_z, v) => v.some((e) => e.cwd !== HOME && landetIn(e) === HOME)),
    ],
    tipps: [
      "Tippe pwd und drücke Enter. Die Antwort ist dein Home-Ordner.",
      "Erst cd projekte, dann cd webshop. Mit pwd prüfst du jeweils, wo du bist.",
      "Eine Ebene nach oben geht mit cd .. (zwei Punkte), zurück nach Hause mit cd ohne Ziel.",
    ],
  },

  "l2-pfade": {
    szenario: system,
    ziele: [
      eigenes("Wechsle mit einem absoluten Pfad nach /var/log", (_z, v) =>
        v.some((e) => e.cwd !== "/var/log" && e.args[0]?.startsWith("/") === true && landetIn(e) === "/var/log"),
      ),
      eigenes("Lass dir anzeigen, was in /var/log liegt", (_z, v) => v.some((e) => e.name === "ls" && e.code === 0 && betrifftOrdner(e, "/var/log"))),
      // relativ von /var/log aus, auch in zwei Schritten (cd .. und cd www/html)
      eigenes("Wechsle von dort mit einem relativen Pfad nach /var/www/html", (_z, v) =>
        v.some((e) => e.cwd.startsWith("/var") && e.args[0] !== undefined && !e.args[0].startsWith("/") && landetIn(e) === "/var/www/html"),
      ),
    ],
    tipps: [
      "Ein absoluter Pfad beginnt mit /. Also: cd /var/log",
      "Danach zeigt ls ohne Argument, was im aktuellen Ordner liegt.",
      "Von /var/log aus führt .. nach /var. Hänge den Rest an: cd ../www/html",
    ],
  },

  "l2-ueberblick": {
    szenario: system,
    ziele: [
      eigenes("Zeige /var/log in der langen Form mit lesbaren Größen", (_z, v) => v.some(zeigtLogsLesbar)),
      eigenes("Zeige den Ordner projekte mit allen Unterordnern", (_z, v) => v.some(zeigtProjekteKomplett)),
    ],
    tipps: [
      "Die lange Form ist -l, lesbare Größen sind -h. Zusammen: ls -lh /var/log",
      "Als Baum: tree projekte. Ohne tree geht es mit ls -R projekte.",
    ],
  },

  "l2-knobel": {
    szenario: system,
    ziele: [
      eigenes("Finde heraus, in welchem Ordner serverliste.txt liegt", (_z, v) => v.some((e) => zeigtAlles(e) && e.ausgabe.includes("serverliste.txt"))),
      eigenes("Wechsle mit einem einzigen cd direkt in diesen Ordner", (_z, v) =>
        v.some((e) => landetIn(e) === NETZWERK && e.cwd !== `${PROJEKTE}/intranet` && e.cwd !== `${PROJEKTE}/intranet/doku`),
      ),
    ],
    tipps: [
      "Statt jeden Ordner einzeln zu öffnen: Lass dir projekte mit allen Unterordnern zeigen, mit tree oder ls -R.",
      "Die Datei liegt in projekte/intranet/doku/netzwerk. Den ganzen Pfad kannst du cd auf einmal mitgeben.",
      "cd projekte/intranet/doku/netzwerk (oder von überall: cd ~/projekte/intranet/doku/netzwerk). Tab spart dabei Tipparbeit.",
    ],
  },
};
