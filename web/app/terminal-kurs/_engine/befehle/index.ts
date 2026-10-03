// Alle Befehle des Uebungs-Terminals. Ein neuer Befehl = neue Datei + Eintrag hier.

import type { Befehl } from "../typen";
import { cat } from "./cat";
import { cd } from "./cd";
import { chmod } from "./chmod";
import { chown } from "./chown";
import { cut } from "./cut";
import { clear } from "./clear";
import { cp } from "./cp";
import { date } from "./date";
import { echo } from "./echo";
import { grep } from "./grep";
import { head } from "./head";
import { help } from "./help";
import { history } from "./history";
import { groups, id } from "./id";
import { less } from "./less";
import { ls } from "./ls";
import { man } from "./man";
import { mkdir } from "./mkdir";
import { mv } from "./mv";
import { pwd } from "./pwd";
import { rm } from "./rm";
import { rmdir } from "./rmdir";
import { sort } from "./sort";
import { sudo } from "./sudo";
import { tail } from "./tail";
import { tee } from "./tee";
import { touch } from "./touch";
import { tree } from "./tree";
import { uniq } from "./uniq";
import { wc } from "./wc";
import { whoami } from "./whoami";

const LISTE: Befehl[] = [
  pwd, ls, cd, tree,
  mkdir, touch, cp, mv, rm, rmdir,
  cat, less, head, tail, grep, wc,
  chmod, chown, id, groups, sudo,
  sort, uniq, cut, tee,
  echo, whoami, date, clear, history, help, man,
];

export const BEFEHLE: ReadonlyMap<string, Befehl> = new Map(LISTE.map((b) => [b.name, b]));
