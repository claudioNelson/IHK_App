// Gemeinsames Einlesen von Dateien fuer head, tail, grep, wc, sort, uniq, cut:
// Fehlermeldungen wie GNU coreutils, "-" oder keine Datei liest stdin.

import { finde } from "../dateisystem";
import { grundHinweis, grundText } from "../hinweise";
import { absolutMitEnde } from "../pfade";
import { darf } from "../rechte";
import type { Kontext } from "../typen";

export type Quelle = { name: string; inhalt: string; stdin: boolean };

export type Gelesen = { quellen: Quelle[]; fehler: string; hinweis?: string };

/**
 * Liest die genannten Dateien (oder stdin, wenn keine genannt ist).
 * meldung(getippt, grund) erzeugt die Fehlerzeile des Befehls.
 */
export function leseQuellen(
  k: Kontext,
  operanden: string[],
  meldung: (getippt: string, text: string, istOrdner?: boolean) => string,
): Gelesen {
  const z = k.zustand;
  const quellen: Quelle[] = [];
  let fehler = "";
  let hinweis: string | undefined;
  const liste = operanden.length > 0 ? operanden : ["-"];
  for (const getippt of liste) {
    if (getippt === "-") {
      quellen.push({ name: operanden.length > 0 ? "-" : "", inhalt: k.eingabe ?? "", stdin: true });
      continue;
    }
    const fund = finde(z, absolutMitEnde(z.cwd, getippt));
    if (!fund.ok) {
      fehler += meldung(getippt, grundText(fund.grund));
      hinweis ??= grundHinweis(fund.grund, getippt);
      continue;
    }
    if (fund.knoten.art === "ordner") {
      fehler += meldung(getippt, "Is a directory", true);
      hinweis ??= `Hinweis: „${getippt}“ ist ein Ordner. Lesen geht nur aus Dateien, den Inhalt eines Ordners zeigt ls.`;
      continue;
    }
    if (!darf(fund.knoten, z.benutzer, "r")) {
      fehler += meldung(getippt, "Permission denied");
      hinweis ??= grundHinweis("verweigert", getippt);
      continue;
    }
    quellen.push({ name: getippt, inhalt: fund.knoten.inhalt, stdin: false });
  }
  return { quellen, fehler, hinweis };
}

/** Zerlegt Text in Zeilen ohne das letzte leere Stueck nach dem abschliessenden \n. */
export function zeilenVon(text: string): string[] {
  if (text === "") return [];
  const z = text.split("\n");
  if (z[z.length - 1] === "") z.pop();
  return z;
}

/** Fuegt Zeilen wieder zusammen, jede mit \n am Ende. */
export function alsText(zeilen: string[]): string {
  return zeilen.map((z) => z + "\n").join("");
}

/** Hinweis, wenn ein Befehl auf stdin wartet, aber nichts hereinkommt (kein echtes Tippen moeglich). */
export function wartetAufEingabe(name: string, beispiel: string): { hinweis: string; code: number } {
  return {
    hinweis: `Hinweis: Ohne Datei liest ${name}, was über | hereinkommt. Auf einem echten Server würde ${name} jetzt auf Eingabe von der Tastatur warten. Gib eine Datei an, zum Beispiel ${beispiel}.`,
    code: 0,
  };
}

/** Wandelt alte Kurzform "-5" in "-n 5" um (head -5, tail -5). */
export function zahlAlsOption(args: string[]): string[] {
  return args.flatMap((a, i) => (/^-\d+$/.test(a) && args[i - 1] !== "-n" ? ["-n", a.slice(1)] : [a]));
}
