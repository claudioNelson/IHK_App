// Aufgaben zu Lektion 4 (Dateien lesen und durchsuchen). Befehle dieser
// Lektion: cat (-n), less, head, tail (-n, -f), grep (-i, -n, -v, -c, -r), wc -l.

import { szenario } from "../../_engine/szenarien";
import type { ProtokollEintrag } from "../../_engine/typen";
import { knotenBei } from "../../_engine/dateisystem";
import type { Zustand } from "../../_engine/typen";
import { eigenes, hatOption, type Aufgabe } from "../../_engine/ziele";
import { ANGREIFER, ANGREIFER_VERSUCHE, FEHLVERSUCHE, PROJEKT_DATEIEN, authLog, sysLog } from "./_daten";
import { HOME, pfade, vorTagen } from "./_hilfen";

/** Server mit Logdateien, Notizen und Projekten. azubi ist (wie unter Ubuntu ueblich) in der Gruppe adm und darf Logs lesen. */
export const logServer = () =>
  szenario({
    "/home/azubi/notizen.txt": {
      inhalt: "Server web01 neu starten\nBackup prüfen\nZertifikat erneuern\nDrucker im Büro einrichten\nNeuen Kollegen anlegen\n",
      geaendert: vorTagen(5),
    },
    ...Object.fromEntries(Object.entries(PROJEKT_DATEIEN).map(([p, inhalt]) => [p, { inhalt, geaendert: vorTagen(8) }])),
    "/var/log/auth.log": { inhalt: authLog(), besitzer: "syslog", gruppe: "adm", rechte: 0o640, geaendert: vorTagen(0, 6, 40) },
    "/var/log/syslog": { inhalt: sysLog(), besitzer: "syslog", gruppe: "adm", rechte: 0o640, geaendert: vorTagen(0, 6, 30) },
    "/var/log/nginx/error.log": { inhalt: "", besitzer: "www-data", gruppe: "adm", rechte: 0o640, geaendert: vorTagen(1) },
    "/var/log/nginx/access.log": {
      inhalt: '10.0.0.15 - - "GET / HTTP/1.1" 200 612 "-" "Mozilla/5.0"\n10.0.0.22 - - "GET /favicon.ico HTTP/1.1" 404 162 "-" "Mozilla/5.0"\n',
      besitzer: "www-data",
      gruppe: "adm",
      rechte: 0o640,
      geaendert: vorTagen(0, 6, 10),
    },
  });

const BEGRUESSUNG = `Willkommen im Übungs-Terminal von Lernarena.
Probier: cat notizen.txt, tail /var/log/syslog, grep Failed /var/log/auth.log
`;

const SYSLOG = "/var/log/syslog";

/** Befehl bezog sich auf genau diese Datei (absolut oder relativ getippt). */
const aufDatei = (e: ProtokollEintrag, datei: string) => pfade(e).includes(datei);

/** Die letzten n Zeilen einer Datei im aktuellen Zustand (zum Vergleich mit der Ausgabe von tail). */
const letzteZeilen = (z: Zustand, pfad: string, n: number) => {
  const k = knotenBei(z.wurzel, pfad);
  if (k?.art !== "datei") return undefined;
  return k.inhalt.split("\n").filter((x, i, a) => i < a.length - 1 || x !== "").slice(-n).map((x) => x + "\n").join("");
};

/** Nicht leere Ausgabezeilen. */
const zeilen = (text: string) => text.split("\n").filter((x) => x !== "");

/** Zahl am Anfang der Ausgabe (grep -c, wc -l). */
const zahlAm = (text: string) => /^\s*(\d+)(\s|$)/.exec(text)?.[1];

/** Argument ohne Rueckstriche (fuer Muster wie 203\.0\.113\.45). */
const ohneRueck = (a: string) => a.replace(/\\/g, "");

export const lektion4: Record<string, Aufgabe> = {
  "l4-frei": { szenario: logServer, ziele: [], tipps: [], begruessung: BEGRUESSUNG },

  "l4-lesen": {
    szenario: logServer,
    ziele: [
      eigenes("Zeige notizen.txt mit Zeilennummern an", (_z, v) =>
        v.some((e) => e.name === "cat" && e.code === 0 && hatOption(e.args, "n", "number") && aufDatei(e, `${HOME}/notizen.txt`)),
      ),
      eigenes("Zeige die letzten 5 Zeilen von /var/log/syslog", (z, v) =>
        v.some((e) => e.name === "tail" && e.code === 0 && e.ausgabe === letzteZeilen(z, SYSLOG, 5)),
      ),
    ],
    tipps: [
      "Die Option für Zeilennummern bei cat ist -n: cat -n notizen.txt",
      "Das Ende einer Datei zeigt tail, die Anzahl kommt hinter -n: tail -n 5 /var/log/syslog",
    ],
  },

  "l4-grep": {
    szenario: logServer,
    ziele: [
      // Genau die 13 Zeilen mit Failed, keine anderen (auch ueber eine Pipe)
      eigenes("Zeige alle Zeilen aus /var/log/auth.log, in denen Failed vorkommt", (_z, v) =>
        v.some((e) => e.name === "grep" && e.code === 0 && zeilen(e.ausgabe).length === FEHLVERSUCHE && zeilen(e.ausgabe).every((x) => x.includes("Failed password"))),
      ),
      eigenes("Lass grep zählen, wie viele Zeilen das sind", (_z, v) =>
        v.some((e) => ((e.name === "grep" && hatOption(e.args, "c", "count")) || e.name === "wc") && zahlAm(e.ausgabe) === String(FEHLVERSUCHE)),
      ),
    ],
    tipps: [
      "Erst das Suchwort, dann die Datei: grep Failed /var/log/auth.log",
      "Mit der Option -c zählt grep nur: grep -c Failed /var/log/auth.log",
    ],
  },

  "l4-suchen": {
    szenario: logServer,
    ziele: [
      eigenes("Suche in /var/log/syslog nach error, egal ob groß oder klein geschrieben, mit Zeilennummern", (_z, v) =>
        v.some((e) => e.name === "grep" && e.code === 0 && hatOption(e.args, "i", "ignore-case") && hatOption(e.args, "n", "line-number") && /ERROR/.test(e.ausgabe) && /\berror\b/.test(e.ausgabe)),
      ),
      eigenes("Finde alle TODO-Notizen in allen Dateien unter projekte", (_z, v) =>
        v.some((e) => e.name === "grep" && e.code === 0 && (hatOption(e.args, "r", "recursive") || hatOption(e.args, "R")) && (e.ausgabe.match(/TODO/g) ?? []).length >= 3),
      ),
    ],
    tipps: [
      "-i schaltet Groß- und Kleinschreibung aus, -n zeigt Zeilennummern. Zusammen: grep -in error /var/log/syslog",
      "Ganze Ordner durchsucht grep mit -r: grep -r TODO projekte",
    ],
  },

  "l4-knobel": {
    szenario: logServer,
    ziele: [
      eigenes("Finde die fremde IP-Adresse, von der die meisten Fehlversuche kommen", (_z, v) =>
        v.some((e) => ["grep", "cat", "less", "head", "tail"].includes(e.name) && e.ausgabe.includes(ANGREIFER)),
      ),
      eigenes("Zähle mit grep, wie viele Fehlversuche von dieser Adresse kamen", (_z, v) =>
        v.some(
          (e) =>
            ((e.name === "grep" && hatOption(e.args, "c", "count") && e.args.some((a) => ohneRueck(a).includes(ANGREIFER))) || e.name === "wc") &&
            zahlAm(e.ausgabe) === String(ANGREIFER_VERSUCHE),
        ),
      ),
    ],
    tipps: [
      "Lass dir alle Zeilen mit Failed aus /var/log/auth.log zeigen und schau, welche Adresse hinter from am häufigsten steht.",
      `Die Adresse ist ${ANGREIFER}. Jetzt suchst du nach Zeilen, die Failed UND diese Adresse enthalten. Ein Suchwort darf Leerzeichen haben, wenn es in Anführungszeichen steht.`,
      `grep -c "from ${ANGREIFER}" /var/log/auth.log zählt alle Zeilen mit dieser Adresse. Prüfe mit grep "from ${ANGREIFER}" /var/log/auth.log, ob das alles Fehlversuche sind.`,
    ],
  },
};
