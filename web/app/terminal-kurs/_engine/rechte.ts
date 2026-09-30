// Rechte pruefen und anzeigen (r/w/x fuer Besitzer, Gruppe, Andere).

import { gruppenVon } from "./benutzer";
import type { Knoten } from "./typen";

export type Recht = "r" | "w" | "x";

const BIT: Record<Recht, number> = { r: 4, w: 2, x: 1 };

/**
 * Darf benutzer das Recht auf knoten ausueben? root darf alles (Ausfuehren
 * von Dateien nur, wenn irgendein x-Bit gesetzt ist, wie unter Linux).
 */
export function darf(knoten: Knoten, benutzer: string, recht: Recht): boolean {
  if (benutzer === "root") {
    if (recht === "x" && knoten.art === "datei") return (knoten.rechte & 0o111) !== 0;
    return true;
  }
  let dreier: number;
  if (knoten.besitzer === benutzer) dreier = (knoten.rechte >> 6) & 7;
  else if (gruppenVon(benutzer).includes(knoten.gruppe)) dreier = (knoten.rechte >> 3) & 7;
  else dreier = knoten.rechte & 7;
  return (dreier & BIT[recht]) !== 0;
}

/** Rechte als Text wie in ls -l: "drwxr-xr-x", "-rw-r--r--", "drwxrwxrwt". */
export function rechteText(knoten: Knoten): string {
  const typ = knoten.art === "ordner" ? "d" : knoten.geraet ? "c" : "-";
  const r = knoten.rechte;
  const drei = (wert: number, sonder: boolean, sonderZeichen: string) => {
    const x = (wert & 1) !== 0;
    let s = (wert & 4 ? "r" : "-") + (wert & 2 ? "w" : "-");
    if (sonder) s += x ? sonderZeichen : sonderZeichen.toUpperCase();
    else s += x ? "x" : "-";
    return s;
  };
  return (
    typ +
    drei((r >> 6) & 7, (r & 0o4000) !== 0, "s") +
    drei((r >> 3) & 7, (r & 0o2000) !== 0, "s") +
    drei(r & 7, (r & 0o1000) !== 0, "t")
  );
}

/** true, wenn eine Datei ausfuehrbar ist (fuer die gruene Farbe in ls). */
export function istAusfuehrbar(knoten: Knoten): boolean {
  return knoten.art === "datei" && !knoten.geraet && (knoten.rechte & 0o111) !== 0;
}
