// Alle Aufgaben des Terminal-Kurses, per id abrufbar. Die Lektionsseiten
// schreiben nur <Terminal aufgabe="id" />; Szenario und Pruefungen liegen hier,
// weil Server-Seiten keine Funktionen an Client-Komponenten geben duerfen.
// Neue Lektion = neue Datei lektionN.ts + Eintrag hier.

import type { Aufgabe } from "../../_engine/ziele";
import { lektion1 } from "./lektion1";
import { lektion2 } from "./lektion2";
import { lektion3 } from "./lektion3";
import { lektion4 } from "./lektion4";
import { lektion5 } from "./lektion5";
import { lektion6 } from "./lektion6";
import { spielwieseAufgaben } from "./spielwiese";

export const AUFGABEN: Record<string, Aufgabe> = {
  ...lektion1,
  ...lektion2,
  ...lektion3,
  ...lektion4,
  ...lektion5,
  ...lektion6,
  ...spielwieseAufgaben,
};
