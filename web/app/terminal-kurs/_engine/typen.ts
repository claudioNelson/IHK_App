// Grundtypen der Terminal-Engine (reines TypeScript, kein React, kein DOM).
//
// Das Dateisystem ist unveraenderlich: jeder Befehl bekommt einen Zustand und
// liefert einen neuen zurueck. Dadurch sind "Zuruecksetzen", Tests und die
// Pruefung von Aufgaben einfach.

export type Meta = {
  besitzer: string;
  gruppe: string;
  /** Rechte als Zahl, z. B. 0o755; 0o1000 ist das Sticky-Bit (/tmp) */
  rechte: number;
  geaendert: Date;
};

export type Datei = Meta & {
  art: "datei";
  inhalt: string;
  /** Geraetedatei wie /dev/null (ls -l zeigt "c") */
  geraet?: boolean;
};

export type Ordner = Meta & {
  art: "ordner";
  kinder: Readonly<Record<string, Knoten>>;
};

export type Knoten = Datei | Ordner;

export type Zustand = {
  wurzel: Ordner;
  /** Aktueller Ordner, immer absolut und normalisiert */
  cwd: string;
  /** Vorheriger Ordner fuer "cd -" (leer, solange es keinen gibt) */
  vorher: string;
  benutzer: string;
  /** Eingegebene Zeilen (history, Pfeil hoch) */
  verlauf: readonly string[];
  /** Rueckgabewert des letzten Befehls ($?) */
  letzterCode: number;
};

/** Ein Stueck Bildschirmausgabe mit optionaler Farbe. */
export type Stil = "ordner" | "ausfuehrbar" | "geraet" | "fehler" | "hinweis" | "fett";
export type Teil = { text: string; stil?: Stil };

/**
 * Je ausgefuehrtem Befehl (fuer die Aufgabenpruefung): Name des eigentlichen
 * Befehls (bei "sudo ls" also "ls", bei "/usr/bin/ls" ebenfalls "ls"),
 * seine Argumente, stdout, Rueckgabewert, der Ordner beim Aufruf und ob er
 * ueber sudo lief.
 */
export type ProtokollEintrag = { name: string; args: string[]; ausgabe: string; code: number; cwd: string; sudo: boolean };

/** Ergebnis eines einzelnen Befehls. */
export type BefehlErgebnis = {
  /** Standardausgabe (stdout), geht in Pipes und Umleitungen */
  ausgabe?: string;
  /** Fehlerausgabe (stderr), englisch wie auf einem echten Server */
  fehler?: string;
  /** Deutsche Hilfe zum Fehler, erscheint nur, wenn stderr auf dem Bildschirm landet */
  hinweis?: string;
  /** Farbige Fassung von ausgabe, nur fuer die direkte Anzeige (wie ls auf einem Terminal) */
  anzeige?: Teil[];
  code?: number;
  zustand?: Zustand;
  /** Bildschirm leeren (clear) */
  leeren?: boolean;
  /** Fehler vor der Ausgabe zeigen (z. B. ls: fehlende Pfade meldet GNU ls zuerst) */
  fehlerZuerst?: boolean;
};

export type Hilfe = {
  /** Ein Satz, was der Befehl tut */
  kurz: string;
  /** Aufrufform, z. B. "ls [OPTION] [ORDNER]" */
  aufruf: string;
  optionen?: [string, string][];
  beispiele?: [string, string][];
};

export type Kontext = {
  name: string;
  args: string[];
  /** stdin: Text aus einer Pipe oder Umleitung, sonst null */
  eingabe: string | null;
  zustand: Zustand;
  jetzt: Date;
  /** Breite des Terminals in Zeichen (fuer ls-Spalten) */
  breite: number;
  /** true, wenn stdout direkt auf dem Bildschirm landet */
  tty: boolean;
  /** Absoluter Pfad, wenn stdout in eine Datei umgeleitet ist (cat: "input file is output file") */
  ausgabeDatei: string | null;
  befehle: ReadonlyMap<string, Befehl>;
};

export type Bereich = "Orientierung" | "Dateien und Ordner" | "Lesen und Suchen" | "Rechte" | "Verketten" | "Allgemein";

export type Befehl = {
  name: string;
  /** Gruppe in der Uebersicht von help */
  bereich: Bereich;
  hilfe: Hilfe;
  lauf: (k: Kontext) => BefehlErgebnis;
};
