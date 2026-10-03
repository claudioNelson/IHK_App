// Aufgaben fuer das Uebungs-Terminal: Start-Dateisystem plus Ziele, die das
// Ergebnis pruefen (nicht den genauen Befehl), damit mehrere Wege richtig sind.
//
//   const aufgabe: Aufgabe = {
//     szenario: () => szenario({ "/home/azubi/notizen.txt": "..." }),
//     ziele: [
//       istOrdner("/home/azubi/backup", "Lege den Ordner backup an"),
//       istDatei("/home/azubi/backup/notizen.txt", "Kopiere notizen.txt hinein"),
//     ],
//     tipps: ["Ordner legst du mit mkdir an.", "Kopieren geht mit cp QUELLE ZIEL."],
//   };

import { knotenBei } from "./dateisystem";
import { normalisiere } from "./pfade";
import type { ProtokollEintrag, Zustand } from "./typen";

/** Alle bisher ausgefuehrten Befehle dieses Terminals (seit dem letzten Zuruecksetzen). */
export type Verlauf = readonly ProtokollEintrag[];

export type Ziel = {
  /** Was zu tun ist, kurz und als Aufforderung („Lass dir … anzeigen“) */
  text: string;
  pruefe: (z: Zustand, verlauf: Verlauf) => boolean;
};

export type Aufgabe = {
  /** Start-Zustand, bei jedem Zuruecksetzen neu erzeugt */
  szenario: () => Zustand;
  /** Leer: freies Terminal ohne Pruefung */
  ziele: Ziel[];
  /** Hilfen, die der Knopf „Tipp“ nacheinander aufdeckt */
  tipps: string[];
  /** Text vor der ersten Eingabe (wie die Begruessung beim Anmelden) */
  begruessung?: string;
  /** Ueberschrift der Zielliste, Standard „Ziele“ (Spielwiese: „Entdecken“) */
  zielTitel?: string;
  /** Erfolgszeile, wenn alle Ziele erreicht sind */
  fertigText?: string;
};

/* ---------- Zustand des Dateisystems ---------- */

export function existiert(pfad: string, text: string): Ziel {
  return { text, pruefe: (z) => knotenBei(z.wurzel, pfad) !== undefined };
}

export function istOrdner(pfad: string, text: string): Ziel {
  return { text, pruefe: (z) => knotenBei(z.wurzel, pfad)?.art === "ordner" };
}

export function istDatei(pfad: string, text: string): Ziel {
  return { text, pruefe: (z) => knotenBei(z.wurzel, pfad)?.art === "datei" };
}

export function fehlt(pfad: string, text: string): Ziel {
  return { text, pruefe: (z) => knotenBei(z.wurzel, pfad) === undefined };
}

export function inhaltEnthaelt(pfad: string, gesucht: string, text: string): Ziel {
  return {
    text,
    pruefe: (z) => {
      const k = knotenBei(z.wurzel, pfad);
      return k?.art === "datei" && k.inhalt.includes(gesucht);
    },
  };
}

export function rechteSind(pfad: string, rechte: number, text: string): Ziel {
  return { text, pruefe: (z) => (knotenBei(z.wurzel, pfad)?.rechte ?? -1) % 0o1000 === rechte };
}

export function besitzerIst(pfad: string, besitzer: string, text: string): Ziel {
  return { text, pruefe: (z) => knotenBei(z.wurzel, pfad)?.besitzer === besitzer };
}

/** Der aktuelle Ordner ist pfad. */
export function imOrdner(pfad: string, text: string): Ziel {
  const ziel = normalisiere(pfad);
  return { text, pruefe: (z) => z.cwd === ziel };
}

/* ---------- Verlauf der Befehle ---------- */

/** Irgendein erfolgreicher Befehl hat text ausgegeben. */
export function ausgabeEnthaelt(gesucht: string, text: string): Ziel {
  return { text, pruefe: (_z, v) => v.some((e) => e.code === 0 && e.ausgabe.includes(gesucht)) };
}

/**
 * Der Befehl name lief erfolgreich, optional mit einer Bedingung an die
 * Argumente. Sparsam einsetzen: nur, wenn die Lektion genau diesen Befehl übt.
 */
export function benutzt(name: string, text: string, argumente?: (args: string[]) => boolean): Ziel {
  return {
    text,
    pruefe: (_z, v) => v.some((e) => e.name === name && e.code === 0 && (!argumente || argumente(e.args))),
  };
}

/** true, wenn unter den Argumenten eine Kurzoption mit dem Buchstaben steht (-a, -la, -al) oder die Langform. */
export function hatOption(args: string[], buchstabe: string, lang?: string): boolean {
  return args.some((a) => (/^-[A-Za-z0-9]+$/.test(a) && a.includes(buchstabe)) || (lang !== undefined && a === `--${lang}`));
}

/** Freie Pruefung fuer Sonderfaelle. */
export function eigenes(text: string, pruefe: Ziel["pruefe"]): Ziel {
  return { text, pruefe };
}
