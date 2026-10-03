// Aufgaben zu Lektion 6 (Pipes und Umleitung). Befehle dieser Lektion:
// >, >>, 2>, 2>/dev/null, |, sort, uniq, cut, wc, tee.

import { knotenBei } from "../../_engine/dateisystem";
import { szenario } from "../../_engine/szenarien";
import type { Zustand } from "../../_engine/typen";
import { BENUTZER } from "../../_engine/benutzer";
import { eigenes, type Aufgabe } from "../../_engine/ziele";
import { ANGREIFER, ANGREIFER_VERSUCHE, PROJEKT_DATEIEN, authLog, sysLog } from "./_daten";
import { HOME, vorTagen } from "./_hilfen";

const inhaltVon = (z: Zustand, pfad: string) => {
  const k = knotenBei(z.wurzel, pfad);
  return k?.art === "datei" ? k.inhalt : undefined;
};

/** Wie in Lektion 4, dazu /etc/shadow, das nur root lesen darf (fuer Fehlermeldungen bei grep -r). */
const pipeServer = () =>
  szenario({
    "/home/azubi/notizen.txt": { inhalt: "Server web01 neu starten\nBackup prüfen\n", geaendert: vorTagen(5) },
    ...Object.fromEntries(Object.entries(PROJEKT_DATEIEN).map(([p, inhalt]) => [p, { inhalt, geaendert: vorTagen(8) }])),
    "/var/log/auth.log": { inhalt: authLog(), besitzer: "syslog", gruppe: "adm", rechte: 0o640, geaendert: vorTagen(0, 6, 40) },
    "/var/log/syslog": { inhalt: sysLog(), besitzer: "syslog", gruppe: "adm", rechte: 0o640, geaendert: vorTagen(0, 6, 30) },
    "/etc/shadow": { inhalt: "root:*:20000:0:99999:7:::\nazubi:$y$j9T$geheim:20000:0:99999:7:::\n", gruppe: "shadow", rechte: 0o640 },
    "/etc/ssh/sshd_config": "Port 22\nPermitRootLogin no\nPasswordAuthentication no\n",
  });

const BEGRUESSUNG = `Willkommen im Übungs-Terminal von Lernarena.
Probier: ls > liste.txt, cat liste.txt, cut -d: -f1 /etc/passwd | sort
`;

/** Benutzernamen aus /etc/passwd, sortiert wie sort unter en_US.UTF-8 (Bindestrich zaehlt nicht). */
const BENUTZER_SORTIERT =
  BENUTZER.map((b) => b.name)
    .sort((a, b) => new Intl.Collator("en-US", { ignorePunctuation: true }).compare(a, b))
    .join("\n") + "\n";
const ANZAHL_BENUTZER = String(BENUTZER.length);

/** Erwartete Rangliste der Fehlversuche (Anzahl und Adresse, haeufigste oben). */
const RANGLISTE: [number, string][] = [
  [ANGREIFER_VERSUCHE, ANGREIFER],
  [3, "198.51.100.7"],
  [1, "10.0.0.15"],
];

export const lektion6: Record<string, Aufgabe> = {
  "l6-frei": { szenario: pipeServer, ziele: [], tipps: [], begruessung: BEGRUESSUNG },

  "l6-umleiten": {
    szenario: pipeServer,
    ziele: [
      eigenes("Schreib mit echo die Zeile „Server web01 geprüft“ in die neue Datei protokoll.txt", (z) => inhaltVon(z, `${HOME}/protokoll.txt`)?.split("\n")[0] === "Server web01 geprüft"),
      eigenes("Hänge die Zeile „Backup ok“ an, ohne die erste zu verlieren", (z) => inhaltVon(z, `${HOME}/protokoll.txt`) === "Server web01 geprüft\nBackup ok\n"),
      eigenes("Speichere die Ausgabe von ls -l in der Datei liste.txt", (z) => {
        const t = inhaltVon(z, `${HOME}/liste.txt`) ?? "";
        return t.startsWith("total ") && t.includes("notizen.txt");
      }),
    ],
    tipps: [
      'Ein > leitet die Ausgabe in eine Datei: echo "Server web01 geprüft" > protokoll.txt',
      'Zwei >> hängen an: echo "Backup ok" >> protokoll.txt. Mit einem > wäre die erste Zeile weg.',
      "ls -l > liste.txt, danach mit cat liste.txt nachsehen.",
    ],
  },

  "l6-pipes": {
    szenario: pipeServer,
    ziele: [
      eigenes("Zähle mit einer Pipe, wie viele Zeilen /etc/passwd hat", (_z, v) =>
        v.some((e) => e.name === "wc" && e.args.length > 0 && e.args.every((a) => a.startsWith("-")) && e.ausgabe.trim() === ANZAHL_BENUTZER),
      ),
      eigenes("Zeige nur die Benutzernamen aus /etc/passwd, alphabetisch sortiert", (_z, v) =>
        v.some((e) => (e.name === "sort" || e.name === "cut") && e.ausgabe === BENUTZER_SORTIERT),
      ),
    ],
    tipps: [
      "cat /etc/passwd gibt die Datei aus, | reicht sie an wc -l weiter: cat /etc/passwd | wc -l",
      "Der Benutzername ist die erste Spalte, getrennt durch Doppelpunkte: cut -d: -f1 /etc/passwd",
      "Hänge sort mit einer Pipe an: cut -d: -f1 /etc/passwd | sort",
    ],
  },

  "l6-fehler": {
    szenario: pipeServer,
    ziele: [
      eigenes("Leite die Fehlermeldung von ls gibtsnicht in die Datei fehler.txt um", (z) => {
        const t = inhaltVon(z, `${HOME}/fehler.txt`) ?? "";
        return t.includes("gibtsnicht") && t.includes("No such file or directory");
      }),
      eigenes("Suche mit grep -r nach PermitRootLogin in /etc, ohne dass Fehlermeldungen erscheinen", (_z, v) =>
        v.some((e) => e.name === "grep" && e.args.includes("PermitRootLogin") && e.ausgabe.includes("PermitRootLogin") && e.fehlerNach === "null"),
      ),
    ],
    tipps: [
      "Fehlermeldungen laufen über Kanal 2. Umleiten mit 2>: ls gibtsnicht 2> fehler.txt",
      "Probier zuerst grep -r PermitRootLogin /etc und schau dir die Meldung zu /etc/shadow an.",
      "Fehler wegwerfen: 2>/dev/null ans Ende, also grep -r PermitRootLogin /etc 2>/dev/null",
    ],
  },

  "l6-knobel": {
    szenario: pipeServer,
    ziele: [
      // Alle drei Adressen in der richtigen Reihenfolge, jeweils mit der richtigen Anzahl
      eigenes("Erstelle in rangliste.txt eine Rangliste der Adressen mit Fehlversuchen, die häufigste oben", (z) => {
        const zeilen = (inhaltVon(z, `${HOME}/rangliste.txt`) ?? "").split("\n").filter((x) => x.trim() !== "");
        return (
          zeilen.length === RANGLISTE.length &&
          RANGLISTE.every(([anzahl, ip], i) => zeilen[i].includes(ip) && new RegExp(`(^|\\D)${anzahl}(\\D|$)`).test(zeilen[i].replace(ip, "")))
        );
      }),
    ],
    tipps: [
      "Zerlege die Aufgabe: Erst alle Zeilen mit Failed, dann nur die Adresse daraus, dann zählen, dann sortieren.",
      "Die Adresse steht hinter from. grep -o zeigt nur den passenden Teil: grep -o 'from [0-9.]*'",
      "grep Failed /var/log/auth.log | grep -o 'from [0-9.]*' | sort | uniq -c | sort -nr > rangliste.txt",
    ],
  },
};
