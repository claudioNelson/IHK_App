// Datenformat fuer Struktogramme (Nassi-Shneiderman, DIN 66261).
//
// Ein Struktogramm ist eine Liste von Bloecken, die von oben nach unten
// gelesen wird. Verzweigungen und Schleifen enthalten wieder Listen von
// Bloecken. Das Format ist bewusst klein gehalten, damit dieselben Daten
// spaeter auch in der App (Flutter-Widget) gezeichnet werden koennen.
//
// Beispiel:
//   [
//     { art: "anweisung", text: "summe = 0" },
//     { art: "zaehlschleife", kopf: "für i = 1 bis n", rumpf: [
//       { art: "anweisung", text: "summe = summe + i" },
//     ] },
//     { art: "anweisung", text: "Ausgabe summe" },
//   ]

export type Block =
  /** Eine Anweisung: Zuweisung, Eingabe, Ausgabe, Aufruf */
  | { art: "anweisung"; text: string }
  /** Zweiseitige Auswahl: Bedingung oben, links "ja", rechts "nein" */
  | {
      art: "verzweigung";
      bedingung: string;
      ja: Block[];
      nein: Block[];
      /** Abweichende Beschriftung, z. B. "wahr" / "falsch" */
      jaText?: string;
      neinText?: string;
    }
  /** Mehrfachauswahl: ein Ausdruck, mehrere Faelle, optional "sonst" */
  | {
      art: "auswahl";
      ausdruck: string;
      faelle: { wert: string; bloecke: Block[] }[];
      sonst?: Block[];
    }
  /** Kopfgesteuerte Schleife: Bedingung wird vor jedem Durchlauf geprueft, gezeichnet als "solange …" */
  | { art: "kopfschleife"; bedingung: string; rumpf: Block[] }
  /**
   * Fussgesteuerte Schleife: Rumpf laeuft mindestens einmal, Bedingung danach.
   * modus "bis" (Standard): Abbruchbedingung, gezeichnet "bis …".
   * modus "solange": Fortsetzungsbedingung wie do-while, gezeichnet "solange …".
   */
  | { art: "fussschleife"; bedingung: string; rumpf: Block[]; modus?: "bis" | "solange" }
  /** Zaehlschleife: "für i = 1 bis n" o. ae. im Kopf */
  | { art: "zaehlschleife"; kopf: string; rumpf: Block[] }
  /** Aufruf eines Unterprogramms: Rechteck mit doppelten Seitenlinien */
  | { art: "aufruf"; text: string }
  /** Luecke fuer Aufgaben "Ergaenzen Sie …": nummerierte Marke, z. B. "1" */
  | { art: "luecke"; marke: string };

/**
 * Ein komplettes Struktogramm mit optionalem Titel. Der Titel ist bei
 * Unterprogrammen die Signatur, z. B. "maximum(zahlen: Feld): Ganzzahl".
 */
export type Struktogramm = {
  titel?: string;
  bloecke: Block[];
};

/** Kurzschreibweisen fuer die Lektionsseiten */
export const anw = (text: string): Block => ({ art: "anweisung", text });
export const wenn = (bedingung: string, ja: Block[], nein: Block[] = []): Block => ({
  art: "verzweigung",
  bedingung,
  ja,
  nein,
});
export const solange = (bedingung: string, rumpf: Block[]): Block => ({
  art: "kopfschleife",
  bedingung,
  rumpf,
});
export const wiederholeBis = (bedingung: string, rumpf: Block[]): Block => ({
  art: "fussschleife",
  bedingung,
  rumpf,
  modus: "bis",
});
export const wiederholeSolange = (bedingung: string, rumpf: Block[]): Block => ({
  art: "fussschleife",
  bedingung,
  rumpf,
  modus: "solange",
});
export const aufruf = (text: string): Block => ({ art: "aufruf", text });
export const luecke = (marke: string): Block => ({ art: "luecke", marke });
export const fuer = (kopf: string, rumpf: Block[]): Block => ({
  art: "zaehlschleife",
  kopf,
  rumpf,
});
export const falls = (
  ausdruck: string,
  faelle: { wert: string; bloecke: Block[] }[],
  sonst?: Block[],
): Block => ({ art: "auswahl", ausdruck, faelle, sonst });
