// Gemeinsame Helfer fuer die Aufgaben aller Lektionen.

import { absolut } from "../../_engine/pfade";
import type { ProtokollEintrag } from "../../_engine/typen";

export const HOME = "/home/azubi";

/**
 * Zeitpunkt vor einigen Tagen, 09:30 UTC. Relativ zu heute, damit ls -l immer
 * Datum und Uhrzeit zeigt (Dateien aelter als ein halbes Jahr zeigen das Jahr).
 */
export const vorTagen = (tage: number, stunde = 9, minute = 30) => {
  const jetzt = Date.now();
  const d = new Date(jetzt - tage * 86_400_000);
  d.setUTCHours(stunde, minute, 0, 0);
  // Nie in der Zukunft (frueh am Morgen waere 06:00 heute noch nicht erreicht)
  return d.getTime() > jetzt - 300_000 ? new Date(jetzt - 300_000) : d;
};

/** Optionen, hinter denen ein Wert steht (kein Pfad): tree -L 2 */
const MIT_WERT: Record<string, string[]> = { tree: ["-L"] };

/** Argumente ohne Optionen (und ohne deren Werte), als absolute Pfade vom Ordner beim Aufruf aus. */
export const pfade = (e: ProtokollEintrag) => {
  const mitWert = MIT_WERT[e.name] ?? [];
  return e.args
    .filter((a, i) => !a.startsWith("-") && !mitWert.includes(e.args[i - 1] ?? ""))
    .map((a) => absolut(e.cwd, a));
};

/**
 * Ordner, in dem ein erfolgreiches cd gelandet ist, sonst undefined.
 * ~ ist im Protokoll schon ersetzt, "cd -" gibt den Zielordner aus.
 */
export const landetIn = (e: ProtokollEintrag): string | undefined => {
  if (e.name !== "cd" || e.code !== 0) return undefined;
  if (e.args.length === 0) return HOME;
  if (e.args[0] === "-") return e.ausgabe.trim();
  return absolut(e.cwd, e.args[0]);
};

/** Der Befehl hat sich auf genau diesen Ordner bezogen: als Argument oder ohne Argument darin aufgerufen. */
export const betrifftOrdner = (e: ProtokollEintrag, ordner: string) => {
  const p = pfade(e);
  return p.length === 0 ? e.cwd === ordner : p.every((x) => x === ordner);
};

/** Englische Kurznamen der Monate wie in Logdateien. */
const MONAT = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

/** Zeitstempel im Format von syslog: "Sep 30 06:25:01". */
export const logZeit = (d: Date) =>
  `${MONAT[d.getUTCMonth()]} ${String(d.getUTCDate()).padStart(2, " ")} ${[d.getUTCHours(), d.getUTCMinutes(), d.getUTCSeconds()]
    .map((n) => String(n).padStart(2, "0"))
    .join(":")}`;

/**
 * Erzeugt eine Logdatei aus wiederkehrenden Zeilen, damit ls -lh glaubwuerdige
 * Groessen zeigt. Die Zeilen laufen ueber die letzten Tage, alle paar Minuten eine.
 */
export const logDatei = (zeilen: string[], anzahl: number, abstandMinuten = 7) => {
  const ende = vorTagen(0, 6, 0).getTime();
  const teile: string[] = [];
  for (let i = 0; i < anzahl; i++) {
    const t = new Date(ende - (anzahl - i) * abstandMinuten * 60_000 + (i % 50) * 1000);
    teile.push(`${logZeit(t)} lernarena ${zeilen[i % zeilen.length].replace("{pid}", String(800 + ((i * 37) % 9000)))}`);
  }
  return teile.join("\n") + "\n";
};
