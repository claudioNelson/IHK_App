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

  "l3-anlegen": {
    loesungen: [["mkdir rechnungen", "touch rechnungen/liste.txt", "mkdir -p archiv/2026/oktober"], ["mkdir -p rechnungen archiv/2026/oktober", "cd rechnungen", "touch liste.txt"]],
    falsch: [["mkdir rechnungen", "touch rechnungen/liste.txt", "mkdir archiv/2026/oktober"], ["mkdir rechnungen", "touch rechnungen/liste.txt", "mkdir archiv", "mkdir archiv/2026", "mkdir archiv/2026/oktober"]],
  },
  "l3-kopieren": {
    loesungen: [["cp notizen.txt backup/", "mv todo.txt aufgaben.txt", "mv bericht-entwurf.txt projekte/"], ["cp notizen.txt backup/notizen.txt", "mv todo.txt aufgaben.txt", "mv bericht-entwurf.txt projekte"]],
    falsch: [["mv notizen.txt backup/", "mv todo.txt aufgaben.txt", "mv bericht-entwurf.txt projekte/"], ["cp notizen.txt backup/", "cp todo.txt aufgaben.txt", "cp bericht-entwurf.txt projekte/"], ["touch backup/notizen.txt", "mv todo.txt aufgaben.txt", "mv bericht-entwurf.txt projekte/"]],
  },
  "l3-loeschen": {
    loesungen: [["rm downloads/*.tmp", "rmdir alt", "rm -r papierkorb"], ["cd downloads", "rm setup.tmp cache.tmp", "cd", "rm -r alt papierkorb"]],
    falsch: [["rm downloads/*", "rmdir alt", "rm -r papierkorb"], ["rm downloads/*.tmp", "rmdir alt", "rmdir papierkorb"]],
  },
  "l3-knobel": {
    loesungen: [["cp -r projekte/webshop webshop-backup", "mkdir bilder", "mv downloads/*.jpg bilder/"], ["mkdir webshop-backup", "cp -r projekte/webshop/. webshop-backup", "mkdir bilder", "mv downloads/foto* bilder/"], ["cp -r projekte/webshop ~/webshop-backup", "mkdir bilder", "mv downloads/foto1.jpg downloads/foto2.jpg bilder"]],
    falsch: [["cp projekte/webshop webshop-backup", "mkdir bilder", "mv downloads/*.jpg bilder/"], ["cp -r projekte/webshop webshop-backup", "mkdir bilder", "mv downloads/foto1.jpg bilder", "mv downloads/foto2.jpg bilder"]],
  },

  "l4-lesen": {
    loesungen: [["cat -n notizen.txt", "tail -n 5 /var/log/syslog"], ["cat -n ~/notizen.txt", "cd /var/log", "tail -5 syslog"], ["cat -n notizen.txt", "cat /var/log/syslog | tail -n 5"], ["cat --number notizen.txt", "tail --lines=5 /var/log/syslog"]],
    falsch: [["cat notizen.txt", "tail -n 5 /var/log/syslog"], ["cat -n notizen.txt", "tail /var/log/syslog"]],
  },
  "l4-grep": {
    loesungen: [["grep Failed /var/log/auth.log", "grep -c Failed /var/log/auth.log"], ["cd /var/log", "grep Failed auth.log", "grep Failed auth.log | wc -l"], ["cat /var/log/auth.log | grep Failed", "grep --count Failed /var/log/auth.log"]],
    falsch: [["grep failed /var/log/auth.log", "grep -c failed /var/log/auth.log"], ["grep -c Failed /var/log/auth.log"], ["grep sshd /var/log/auth.log", "grep -c Failed /var/log/auth.log"]],
  },
  "l4-suchen": {
    loesungen: [["grep -in error /var/log/syslog", "grep -r TODO projekte"], ["grep -i -n error /var/log/syslog", "cd projekte", "grep -rn TODO ."]],
    falsch: [["grep -n error /var/log/syslog", "grep -r TODO projekte"], ["grep -in error /var/log/syslog", "grep TODO projekte/webshop/app.js"]],
  },
  "l4-knobel": {
    loesungen: [["grep Failed /var/log/auth.log", "grep -c 'from 203.0.113.45' /var/log/auth.log"], ["grep Failed /var/log/auth.log", "grep Failed /var/log/auth.log | grep -c 203.0.113.45"], ["cat /var/log/auth.log", "grep -cE 'Failed.*203\\.0\\.113\\.45' /var/log/auth.log"]],
    falsch: [["grep Failed /var/log/auth.log", "grep -c 203.0.113.45 /var/log/auth.log"]],
  },

  "l5-lesen": {
    loesungen: [["id", "ls -l backup.sh"], ["groups", "ls -l"], ["id azubi", "ls -l backup.sh"]],
    falsch: [["id mia", "ls -l backup.sh"], ["id", "ls backup.sh"], ["id -u", "ls -l backup.sh"], ["sudo id", "ls -l backup.sh"]],
  },
  "l5-chmod": {
    loesungen: [["chmod u+x backup.sh", "chmod 600 zugang.txt"], ["chmod 755 backup.sh", "chmod go-r zugang.txt"]],
    falsch: [["chmod g+x backup.sh", "chmod 600 zugang.txt"], ["chmod u+x backup.sh", "chmod 640 zugang.txt"], ["chmod 777 backup.sh", "chmod 600 zugang.txt"]],
  },
  "l5-chown": {
    loesungen: [["sudo chown www-data:www-data /var/www/html/index.html /var/www/html/kontakt.html"], ["cd /var/www/html", "sudo chown -R www-data:www-data ."], ["sudo chown www-data:www-data /var/www/html/*"]],
    falsch: [["chown www-data:www-data /var/www/html/index.html /var/www/html/kontakt.html"], ["sudo chown www-data /var/www/html/index.html /var/www/html/kontakt.html"]],
  },
  "l5-knobel": {
    loesungen: [["mkdir team", "chmod 750 team", "touch team/plan.txt", "chmod 640 team/plan.txt"], ["mkdir team", "touch team/plan.txt", "chmod o-rwx team", "chmod g-w team", "chmod 640 team/plan.txt"]],
    falsch: [["mkdir team", "chmod 755 team", "touch team/plan.txt", "chmod 640 team/plan.txt"], ["mkdir team", "chmod 750 team", "touch team/plan.txt", "chmod 644 team/plan.txt"], ["mkdir -p team/plan.txt", "chmod 750 team", "chmod 640 team/plan.txt"]],
  },

  "l6-umleiten": {
    loesungen: [['echo "Server web01 geprüft" > protokoll.txt', 'echo "Backup ok" >> protokoll.txt', "ls -l > liste.txt"], ["echo Server web01 geprüft > protokoll.txt", "echo Backup ok | tee -a protokoll.txt", "ls -l | tee liste.txt"]],
    falsch: [['echo "Server web01 geprüft" > protokoll.txt', 'echo "Backup ok" > protokoll.txt', "ls -l > liste.txt"], ['echo "Server web01 geprüft" > protokoll.txt', 'echo "Backup ok" >> protokoll.txt', "ls > liste.txt"], ['echo "Server web01 geprüft" > protokoll.txt', 'echo "Backup ok" >> protokoll.txt', "ls -l /etc > liste.txt"]],
  },
  "l6-pipes": {
    loesungen: [["cat /etc/passwd | wc -l", "cut -d: -f1 /etc/passwd | sort"], ["wc -l < /etc/passwd", "cat /etc/passwd | cut -d: -f1 | sort"], ["cat /etc/passwd | wc -l", "sort /etc/passwd | cut -d: -f1"]],
    falsch: [["wc -l /etc/passwd", "cut -d: -f1 /etc/passwd"]],
  },
  "l6-fehler": {
    loesungen: [["ls gibtsnicht 2> fehler.txt", "grep -r PermitRootLogin /etc 2>/dev/null"], ["ls gibtsnicht 2>fehler.txt", "grep -rn PermitRootLogin /etc/ 2> /dev/null"], ["ls gibtsnicht 2> fehler.txt", "grep -r PermitRootLogin /etc 2>'/dev/null'"]],
    falsch: [["ls gibtsnicht > fehler.txt", "grep -r PermitRootLogin /etc 2>/dev/null"], ["ls gibtsnicht 2> fehler.txt", "grep -r PermitRootLogin /etc"], ["ls gibtsnicht 2> fehler.txt", "grep -r PermitRootLogin /etc", "echo grep 2>/dev/null"]],
  },
  "l6-knobel": {
    loesungen: [
      ["grep Failed /var/log/auth.log | grep -o 'from [0-9.]*' | sort | uniq -c | sort -nr > rangliste.txt"],
      ["grep Failed /var/log/auth.log | grep -oE '([0-9]+\\.){3}[0-9]+' | sort | uniq -c | sort -rn | tee rangliste.txt"],
      ["grep Failed /var/log/auth.log | grep -o 'from [0-9.]*' | sort | uniq -c | sort -k1,1nr > rangliste.txt"],
    ],
    falsch: [["grep Failed /var/log/auth.log | grep -o 'from [0-9.]*' | sort | uniq -c > rangliste.txt"], ["grep Failed /var/log/auth.log | grep -o 'from [0-9.]*' | sort | uniq -c | sort -nr | head -1 > rangliste.txt"], ["grep Failed /var/log/auth.log | grep -o 'from [0-9.]*' | uniq -c | sort -nr > rangliste.txt"], ["grep Failed /var/log/auth.log | grep -o 'from [0-9.]*' | sort | uniq -c | sort -n > rangliste.txt"]],
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
