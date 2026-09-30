// Kleine Helfer fuer mehrere Befehle.

import { istAusfuehrbar } from "../rechte";
import type { Knoten, Stil, Teil } from "../typen";

/** Sammelt Text und farbige Teile gleichzeitig (Text fuer Pipes, Teile fuer den Bildschirm). */
export class Ausgabe {
  text = "";
  teile: Teil[] = [];

  add(text: string, stil?: Stil) {
    if (text === "") return;
    this.text += text;
    const letzter = this.teile[this.teile.length - 1];
    if (letzter && letzter.stil === stil) letzter.text += text;
    else this.teile.push(stil ? { text, stil } : { text });
  }
}

/** Farbe eines Namens wie ls unter Ubuntu: Ordner blau, ausfuehrbar gruen, Geraete gelb. */
export function stilVon(knoten: Knoten): Stil | undefined {
  if (knoten.art === "ordner") return "ordner";
  if (knoten.geraet) return "geraet";
  if (istAusfuehrbar(knoten)) return "ausfuehrbar";
  return undefined;
}

/** Name in einfachen Anfuehrungszeichen, wenn er Leer- oder Sonderzeichen enthaelt (wie ls auf dem Terminal). */
export function shellName(name: string): string {
  const sonder = /[\s!"$&'()*;<>?[\\`|^=]/;
  if (!sonder.test(name) && !/^[~#]/.test(name)) return name;
  if (!name.includes("'")) return `'${name}'`;
  // Wie GNU ls: mit Apostroph in doppelte Anfuehrungszeichen ("it's here"),
  // ausser es stecken Zeichen drin, die dort noch wirken ($ ` \ " !)
  if (!/[$`\\"!]/.test(name)) return `"${name}"`;
  return `'${name.replace(/'/g, "'\\''")}'`;
}

/** Englischer Monatsname in Kurzform. */
export const MONATE = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
export const TAGE = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

export function zwei(n: number): string {
  return String(n).padStart(2, "0");
}

/** Anzahl + Wort mit Mehrzahl: 1 file, 2 files. */
export function anzahl(n: number, einzahl: string, mehrzahl: string): string {
  return `${n} ${n === 1 ? einzahl : mehrzahl}`;
}
