// Tab-Ergaenzung wie in der Bash: am Befehlsanfang Befehlsnamen, sonst
// Pfade. Ein Treffer wird ganz eingesetzt (Ordner mit "/", sonst mit
// Leerzeichen), mehrere bis zum gemeinsamen Anfang; gibt es keinen
// gemeinsamen Rest mehr, liefert die Funktion die Treffer als Vorschlaege.

import { BEFEHLE } from "./befehle";
import { finde, home, sortiereNamen } from "./dateisystem";
import { absolut } from "./pfade";
import { darf } from "./rechte";
import type { Zustand } from "./typen";

export type Ergaenzung = {
  zeile: string;
  cursor: number;
  /** Mehrere Treffer ohne gemeinsamen Rest (die Anzeige listet sie auf) */
  vorschlaege: string[];
};

const TRENNER = new Set([" ", "\t", "|", ";", "&", "<", ">"]);

/** Beginn des Worts vor dem Cursor (ein mit \ maskiertes Leerzeichen gehoert zum Wort). */
function wortAnfang(zeile: string, cursor: number): number {
  let i = cursor;
  while (i > 0) {
    const c = zeile[i - 1];
    if (TRENNER.has(c) && zeile[i - 2] !== "\\") break;
    i--;
  }
  return i;
}

function demaskiere(wort: string): string {
  return wort.replace(/\\(.)/g, "$1").replace(/['"]/g, "");
}

function maskiere(name: string): string {
  return name.replace(/([\s'"\\|;&<>()$`*?!#])/g, "\\$1");
}

function gemeinsamerAnfang(namen: string[]): string {
  if (namen.length === 0) return "";
  let p = namen[0];
  for (const n of namen) while (!n.startsWith(p)) p = p.slice(0, -1);
  return p;
}

/** Steht das Wort an der Stelle eines Befehlsnamens? */
function istBefehlsstelle(davor: string): boolean {
  const t = davor.replace(/\s+$/, "");
  if (t === "") return true;
  if (/(\||;|&&|\|\|)$/.test(t)) return true;
  const letztes = t.split(/\s+/).pop();
  return letztes === "sudo" || letztes === "man";
}

export function ergaenze(zeile: string, cursor: number, z: Zustand): Ergaenzung {
  const anfang = wortAnfang(zeile, cursor);
  const wort = zeile.slice(anfang, cursor);
  const davor = zeile.slice(0, anfang);
  const danach = zeile.slice(cursor);
  const unveraendert: Ergaenzung = { zeile, cursor, vorschlaege: [] };

  const einsetzen = (neu: string): Ergaenzung => ({
    zeile: davor + neu + danach,
    cursor: davor.length + neu.length,
    vorschlaege: [],
  });

  // Befehlsnamen
  if (istBefehlsstelle(davor) && !wort.includes("/")) {
    const namen = [...BEFEHLE.keys()].filter((n) => n.startsWith(wort)).sort();
    if (namen.length === 0) return unveraendert;
    if (namen.length === 1) return einsetzen(namen[0] + " ");
    const gemeinsam = gemeinsamerAnfang(namen);
    if (gemeinsam.length > wort.length) return einsetzen(gemeinsam);
    return { ...unveraendert, vorschlaege: namen };
  }

  // Pfade
  const roh = demaskiere(wort);
  const schnitt = roh.lastIndexOf("/");
  const ordnerTeil = schnitt >= 0 ? roh.slice(0, schnitt + 1) : "";
  const praefix = schnitt >= 0 ? roh.slice(schnitt + 1) : roh;
  let ordnerFuerSuche = ordnerTeil === "" ? "." : ordnerTeil;
  if (ordnerFuerSuche === "~/" || ordnerFuerSuche.startsWith("~/")) ordnerFuerSuche = home(z) + ordnerFuerSuche.slice(1);
  if (roh === "~") return einsetzen("~/");
  if (roh === "." || roh === ".." || roh.endsWith("/..") || roh.endsWith("/.")) return einsetzen(wort + "/");
  const fund = finde(z, absolut(z.cwd, ordnerFuerSuche));
  if (!fund.ok || fund.knoten.art !== "ordner" || !darf(fund.knoten, z.benutzer, "r")) return unveraendert;
  const ordner = fund.knoten;
  const namen = sortiereNamen(
    Object.keys(ordner.kinder).filter((n) => n.startsWith(praefix) && (praefix.startsWith(".") || !n.startsWith("."))),
  );
  if (namen.length === 0) return unveraendert;
  const getipptOrdner = wort.slice(0, wort.lastIndexOf("/") + 1);
  if (namen.length === 1) {
    const kind = ordner.kinder[namen[0]];
    return einsetzen(getipptOrdner + maskiere(namen[0]) + (kind.art === "ordner" ? "/" : " "));
  }
  const gemeinsam = gemeinsamerAnfang(namen);
  if (gemeinsam.length > praefix.length) return einsetzen(getipptOrdner + maskiere(gemeinsam));
  return { ...unveraendert, vorschlaege: namen.map((n) => (ordner.kinder[n].art === "ordner" ? n + "/" : n)) };
}
