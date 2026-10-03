// Gemeinsame Dateiinhalte fuer die Lektionen 4 bis 6 (und spaeter die
// Spielwiese): Logdateien mit einem "Einbruchsversuch", Projekte mit TODOs.
// Die IP-Adressen 203.0.113.x und 198.51.100.x sind Dokumentationsadressen
// (RFC 5737) und gehoeren niemandem.

import { logZeit, vorTagen } from "./_hilfen";

/** Fremde IP mit den meisten Fehlversuchen (Knobelaufgaben 4.4 und 6.4). */
export const ANGREIFER = "203.0.113.45";
/** Fehlversuche von ANGREIFER in auth.log */
export const ANGREIFER_VERSUCHE = 9;
/** Alle Zeilen mit "Failed password" in auth.log */
export const FEHLVERSUCHE = 13;

type Ereignis = [prozess: string, text: string];

const s = (text: string): Ereignis => ["sshd", text];

/** Reihenfolge der Ereignisse in auth.log (aelteste zuerst). */
const AUTH: Ereignis[] = [
  ["CRON", "pam_unix(cron:session): session opened for user root(uid=0) by (uid=0)"],
  ["CRON", "pam_unix(cron:session): session closed for user root"],
  s("Accepted publickey for azubi from 10.0.0.15 port 51522 ssh2: ED25519 SHA256:q3Zk8uTnV0xLr4"),
  s("pam_unix(sshd:session): session opened for user azubi(uid=1000) by (uid=0)"),
  ["sudo", "   azubi : TTY=pts/0 ; PWD=/home/azubi ; USER=root ; COMMAND=/usr/bin/apt update"],
  s("pam_unix(sshd:session): session closed for user azubi"),
  s("Failed password for invalid user test from 198.51.100.7 port 40112 ssh2"),
  s("Failed password for invalid user test from 198.51.100.7 port 40118 ssh2"),
  s("Connection closed by invalid user test 198.51.100.7 port 40118 [preauth]"),
  s("Failed password for root from 203.0.113.45 port 52011 ssh2"),
  s("Failed password for root from 203.0.113.45 port 52013 ssh2"),
  s("Failed password for root from 203.0.113.45 port 52019 ssh2"),
  s("Failed password for invalid user admin from 203.0.113.45 port 52030 ssh2"),
  s("Failed password for invalid user admin from 203.0.113.45 port 52034 ssh2"),
  s("Failed password for root from 203.0.113.45 port 52041 ssh2"),
  s("Failed password for invalid user oracle from 203.0.113.45 port 52047 ssh2"),
  s("Failed password for root from 203.0.113.45 port 52055 ssh2"),
  s("Failed password for root from 203.0.113.45 port 52060 ssh2"),
  s("Disconnecting authenticating user root 203.0.113.45 port 52060: Too many authentication failures [preauth]"),
  s("Failed password for azubi from 10.0.0.15 port 51630 ssh2"),
  s("Accepted password for azubi from 10.0.0.15 port 51630 ssh2"),
  s("pam_unix(sshd:session): session opened for user azubi(uid=1000) by (uid=0)"),
  s("Failed password for invalid user test from 198.51.100.7 port 40377 ssh2"),
  ["sudo", "   azubi : TTY=pts/0 ; PWD=/var/log ; USER=root ; COMMAND=/usr/bin/tail -n 50 /var/log/syslog"],
  s("pam_unix(sshd:session): session closed for user azubi"),
];

/** auth.log mit Zeitstempeln der letzten Stunden, Prozessnummern fest. */
export function authLog(): string {
  const ende = vorTagen(0, 6, 40).getTime();
  return AUTH.map(([prozess, text], i) => {
    const t = new Date(ende - (AUTH.length - i) * 4 * 60_000 - (i % 7) * 13_000);
    const pid = prozess === "sudo" ? "" : `[${2100 + i * 17}]`;
    return `${logZeit(t)} lernarena ${prozess}${pid}: ${text}`;
  }).join("\n") + "\n";
}

const SYSLOG: Ereignis[] = [
  ["systemd[1]", "Started cron.service - Regular background program processing daemon."],
  ["systemd[1]", "Starting nginx.service - A high performance web server and a reverse proxy server..."],
  ["nginx[812]", "[error] 812#812: *14 open() \"/var/www/html/favicon.ico\" failed (2: No such file or directory)"],
  ["systemd[1]", "Started nginx.service - A high performance web server and a reverse proxy server."],
  ["CRON[1904]", "(root) CMD (test -x /usr/sbin/anacron || run-parts --report /etc/cron.daily)"],
  ["backup.sh[1922]", "ERROR: Ziel /mnt/backup nicht erreichbar"],
  ["systemd[1]", "backup.service: Main process exited, code=exited, status=1/FAILURE"],
  ["systemd[1]", "backup.service: Failed with result 'exit-code'."],
  ["systemd[1]", "Failed to start backup.service - Nächtliche Sicherung."],
  ["systemd-timesyncd[540]", "Contacted time server 185.125.190.57:123 (ntp.ubuntu.com)."],
  ["kernel", "[ 8123.441002] EXT4-fs (sdb1): error count since last fsck: 2"],
  ["systemd[1]", "Starting apt-daily.service - Daily apt download activities..."],
  ["systemd[1]", "apt-daily.service: Deactivated successfully."],
  ["nginx[812]", "[error] 812#812: *31 connect() failed (111: Connection refused) while connecting to upstream"],
  ["systemd[1]", "Started session-14.scope - Session 14 of User azubi."],
];

/** syslog mit Fehlern in verschiedener Schreibweise (error, ERROR, Error). */
export function sysLog(): string {
  const ende = vorTagen(0, 6, 30).getTime();
  return SYSLOG.map(([prozess, text], i) => `${logZeit(new Date(ende - (SYSLOG.length - i) * 9 * 60_000))} lernarena ${prozess}: ${text}`).join("\n") + "\n";
}

/** Projekte mit TODO-Kommentaren fuer grep -r. */
export const PROJEKT_DATEIEN: Record<string, string> = {
  "/home/azubi/projekte/webshop/index.html": "<!doctype html>\n<h1>Shop</h1>\n<!-- TODO: Impressum verlinken -->\n",
  "/home/azubi/projekte/webshop/app.js": "const warenkorb = [];\n// TODO: Warenkorb im Browser speichern\nfunction preis(netto) {\n  return netto * 1.19;\n}\n",
  "/home/azubi/projekte/webshop/style.css": "body { font-family: sans-serif; }\n",
  "/home/azubi/projekte/intranet/index.html": "<!doctype html>\n<h1>Intranet</h1>\n",
  "/home/azubi/projekte/intranet/doku/anleitung.txt": "So richtest du einen Arbeitsplatz ein:\n1. Benutzer anlegen\n2. Drucker verbinden\nTODO: Bilder ergänzen\n",
};
