// Alle Befehle des Uebungs-Terminals. Ein neuer Befehl = neue Datei + Eintrag hier.

import type { Befehl } from "../typen";
import { cat } from "./cat";
import { cd } from "./cd";
import { clear } from "./clear";
import { cp } from "./cp";
import { date } from "./date";
import { echo } from "./echo";
import { help } from "./help";
import { history } from "./history";
import { ls } from "./ls";
import { man } from "./man";
import { mkdir } from "./mkdir";
import { mv } from "./mv";
import { pwd } from "./pwd";
import { rm } from "./rm";
import { rmdir } from "./rmdir";
import { sudo } from "./sudo";
import { touch } from "./touch";
import { tree } from "./tree";
import { whoami } from "./whoami";

const LISTE: Befehl[] = [pwd, ls, cd, tree, mkdir, touch, cp, mv, rm, rmdir, cat, sudo, echo, whoami, date, clear, history, help, man];

export const BEFEHLE: ReadonlyMap<string, Befehl> = new Map(LISTE.map((b) => [b.name, b]));
