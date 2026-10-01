// Prueft jede Aufgabe des Terminal-Kurses: Die Musterloesung erfuellt alle
// Ziele, ein falscher Weg nicht alle. Ausfuehren im Ordner web/:
//   npx tsx app/terminal-kurs/_components/aufgaben/aufgaben.test.ts

import assert from "node:assert/strict";
import { ausfuehren } from "../../_engine/shell";
import type { ProtokollEintrag } from "../../_engine/typen";
import type { Aufgabe } from "../../_engine/ziele";
import { AUFGABEN } from "./index";

/** Fuehrt die Zeilen aus und liefert, welche Ziele erreicht sind (abgehakt bleibt abgehakt, wie im Terminal). */
function spiele(aufgabe: Aufgabe, zeilen: string[]): boolean[] {
  let z = aufgabe.szenario();
  const verlauf: ProtokollEintrag[] = [];
  const erreicht = aufgabe.ziele.map(() => false);
  for (const zeile of zeilen) {
    const a = ausfuehren(zeile, z, { breite: 80 });
    z = a.zustand;
    verlauf.push(...a.protokoll);
    aufgabe.ziele.forEach((ziel, i) => (erreicht[i] = erreicht[i] || ziel.pruefe(z, verlauf)));
  }
  return erreicht;
}

/** Musterloesungen (wie auf den Lektionsseiten) und Wege, die nicht reichen duerfen. */
const FAELLE: Record<string, { loesungen: string[][]; falsch?: string[][] }> = {
  "l1-erster-befehl": { loesungen: [["whoami", "date"]], falsch: [["whoami"]] },
  "l1-option": { loesungen: [["ls -a", "ls -la"], ["ls -l --all"]], falsch: [["ls -l"]] },
  "l1-argument": { loesungen: [["ls /etc", "ls -l /etc/hostname"], ["ls ../../etc", "ls -l /etc/../etc/hostname"]], falsch: [["cd /etc", "ls", "ls -l hostname"]] },
  "l1-hilfe": { loesungen: [["man ls", "ls -lt", "history"], ["ls --help", "ls -t ~", "history"]], falsch: [["man ls", "ls -ltr", "history"]] },

  "l2-cd": {
    loesungen: [
      ["pwd", "cd projekte", "cd webshop", "cd ..", "cd"],
      ["pwd", "cd projekte/webshop", "cd ..", "cd ~"],
      ["pwd", "cd ~/projekte/webshop", "cd ../", "cd -", "cd /home/azubi"],
    ],
    falsch: [["pwd", "cd projekte", "cd ..", "cd"], ["pwd", "cd projekte/webshop", "cd ../.."]],
  },
  "l2-pfade": {
    loesungen: [
      ["cd /var/log", "ls", "cd ../www/html"],
      ["cd /var/log/", "ls -l", "cd ../www/html/"],
      ["cd /var/log", "ls /var/log", "cd ../../var/www/html"],
      ["cd /var/log", "ls", "cd ..", "cd www/html"],
    ],
    falsch: [["cd /var/log", "ls", "cd /var/www/html"], ["cd ../../var/log", "ls", "cd ../www/html"]],
  },
  "l2-ueberblick": {
    loesungen: [
      ["ls -lh /var/log", "tree projekte"],
      ["cd /var/log", "ls -l -h", "cd", "ls -R projekte"],
      ["ls -lh /var/log/", "cd projekte", "tree"],
      ["ls -lh /var/log", "tree -d projekte"],
      ["ls -lh /var/log", "tree -L 5 projekte"],
    ],
    falsch: [["ls -l /var/log", "tree projekte"], ["ls -lh /var/log", "ls projekte"], ["ls -lh /var/log", "tree -L 1 projekte"]],
  },
  "l2-knobel": {
    loesungen: [["tree projekte", "cd projekte/intranet/doku/netzwerk"], ["ls -R", "cd /var", "cd ~/projekte/intranet/doku/netzwerk"]],
    falsch: [["tree projekte", "cd projekte/intranet", "cd doku", "cd netzwerk"], ["echo serverliste.txt", "cd projekte/intranet/doku/netzwerk"]],
  },
};

let bestanden = 0;
let gescheitert = 0;

for (const [id, aufgabe] of Object.entries(AUFGABEN)) {
  if (aufgabe.ziele.length === 0) continue;
  const fall = FAELLE[id];
  try {
    assert.ok(fall, `keine Musterlösung für ${id} im Test`);
    for (const zeilen of fall.loesungen) {
      const e = spiele(aufgabe, zeilen);
      assert.ok(e.every(Boolean), `${id}: ${JSON.stringify(zeilen)} erfüllt nicht alle Ziele (${e.join(", ")})`);
    }
    for (const zeilen of fall.falsch ?? []) {
      const e = spiele(aufgabe, zeilen);
      assert.ok(!e.every(Boolean), `${id}: ${JSON.stringify(zeilen)} dürfte nicht alle Ziele erfüllen`);
    }
    bestanden++;
    console.log(`  ok   ${id}`);
  } catch (err) {
    gescheitert++;
    console.log(`  FEHL ${id}\n       ${(err as Error).message}`);
  }
}

console.log(`\n${bestanden} bestanden, ${gescheitert} gescheitert`);
if (gescheitert > 0) process.exit(1);
