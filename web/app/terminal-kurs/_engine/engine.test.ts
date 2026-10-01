// Tests der Terminal-Engine. Ausfuehren im Ordner web/:
//   npx tsx app/terminal-kurs/_engine/engine.test.ts
// Keine Abhaengigkeit im Projekt noetig (tsx laedt npx bei Bedarf).

import assert from "node:assert/strict";
import { knotenBei } from "./dateisystem";
import { ergaenze } from "./ergaenzung";
import { benutzt, hatOption, imOrdner, istOrdner } from "./ziele";
import { ausfuehren, prompt } from "./shell";
import { szenario } from "./szenarien";
import type { Teil, Zustand } from "./typen";

const JETZT = new Date("2026-09-30T10:00:00Z");

function text(teile: Teil[]): string {
  return teile.map((t) => t.text).join("");
}

function lauf(z: Zustand, zeile: string, breite = 80) {
  const a = ausfuehren(zeile, z, { jetzt: JETZT, breite });
  const fehler = a.teile.filter((t) => t.stil === "fehler").map((t) => t.text).join("");
  const hinweis = a.teile.filter((t) => t.stil === "hinweis").map((t) => t.text).join("");
  const aus = a.teile.filter((t) => t.stil !== "fehler" && t.stil !== "hinweis").map((t) => t.text).join("");
  return { ...a, z: a.zustand, t: text(a.teile), aus, fehler, hinweis, code: a.zustand.letzterCode };
}

/** Mehrere Zeilen nacheinander, liefert das Ergebnis der letzten. */
function kette(z: Zustand, ...zeilen: string[]) {
  let e = lauf(z, zeilen[0]);
  for (const zeile of zeilen.slice(1)) e = lauf(e.z, zeile);
  return e;
}

function inhalt(z: Zustand, pfad: string): string | undefined {
  const k = knotenBei(z.wurzel, pfad);
  return k && k.art === "datei" ? k.inhalt : undefined;
}

function start(): Zustand {
  return szenario({
    "/home/azubi/notizen.txt": "Einkaufen\nServer neu starten\n",
    "/home/azubi/todo.txt": "Backup prüfen\n",
    "/home/azubi/.geheim": "Du hast mich gefunden!\n",
    "/home/azubi/projekte/webshop/index.html": "<h1>Shop</h1>\n",
    "/home/azubi/projekte/webshop/style.css": "body {}\n",
    "/home/azubi/bilder/": {},
    "/home/azubi/skript.sh": { inhalt: "#!/bin/bash\necho hallo\n", rechte: 0o755 },
    "/root/geheim.txt": "nur für root\n",
  });
}

let bestanden = 0;
let gescheitert = 0;
function test(name: string, fn: () => void) {
  try {
    fn();
    bestanden++;
  } catch (e) {
    gescheitert++;
    console.log(`FEHLER: ${name}\n  ${(e as Error).message.split("\n").join("\n  ")}`);
  }
}

/* ---------------- Zerleger und Shell ---------------- */

test("Anfuehrungszeichen und Variablen", () => {
  const e = lauf(start(), `echo "a  b" 'c $HOME' $HOME "$USER ist da"`);
  assert.equal(e.aus, "a  b c $HOME /home/azubi azubi ist da\n");
});

test("leere Variable faellt weg, Maskierung, Kommentar", () => {
  assert.equal(lauf(start(), "echo $NIX x").aus, "x\n");
  assert.equal(lauf(start(), "echo a\\ b").aus, "a b\n");
  assert.equal(lauf(start(), "echo hi # kommentar").aus, "hi\n");
  assert.equal(lauf(start(), `echo ""`).aus, "\n");
});

test("Syntaxfehler mit Code 2 und Hinweis", () => {
  for (const zeile of ["| ls", "ls |", "ls >", 'echo "offen', "echo 'offen", "ls &&", "ls &"]) {
    const e = lauf(start(), zeile);
    assert.equal(e.code, 2, zeile);
    assert.ok(e.fehler.startsWith("bash: "), zeile);
    assert.ok(e.hinweis.startsWith("Hinweis: "), zeile);
  }
  assert.equal(lauf(start(), "| ls").fehler, "bash: syntax error near unexpected token `|'\n");
  assert.equal(lauf(start(), "ls >").fehler, "bash: syntax error near unexpected token `newline'\n");
});

test("&&, || und ;", () => {
  assert.equal(lauf(start(), "cd nix && echo ja").aus, "");
  assert.equal(lauf(start(), "cd nix || echo nein").aus, "nein\n");
  assert.equal(lauf(start(), "echo a; echo b").aus, "a\nb\n");
  assert.equal(lauf(start(), "cd nix && echo ja || echo sonst").aus, "sonst\n");
});

test("$? und $PWD werden beim Ausfuehren ersetzt", () => {
  assert.equal(lauf(start(), "cd nix; echo $?").aus, "1\n");
  assert.equal(lauf(start(), "cd /tmp && echo $PWD").aus, "/tmp\n");
  assert.equal(lauf(start(), "lss; echo $?").aus, "127\n");
});

test("Verlauf: keine Wiederholung, kein fuehrendes Leerzeichen", () => {
  const e = kette(start(), "ls", "ls", " pwd", "history");
  assert.deepEqual(e.z.verlauf, ["ls", "history"]);
  assert.equal(e.aus, "    1  ls\n    2  history\n");
});

test("unbekannter Befehl mit Vorschlag", () => {
  const e = lauf(start(), "lss -l");
  assert.equal(e.fehler, "bash: lss: command not found\n");
  assert.ok(e.hinweis.includes("Meintest du ls?"));
  assert.equal(e.code, 127);
  assert.ok(lauf(start(), "nano notizen.txt").hinweis.includes("echo"));
});

test("Zustand bleibt unveraendert (unveraenderlich)", () => {
  const z = start();
  lauf(z, "rm notizen.txt");
  lauf(z, "mkdir neu");
  assert.ok(knotenBei(z.wurzel, "/home/azubi/notizen.txt"));
  assert.equal(knotenBei(z.wurzel, "/home/azubi/neu"), undefined);
});

test("Prompt", () => {
  const z = start();
  assert.deepEqual(prompt(z), { benutzer: "azubi@lernarena", pfad: "~", zeichen: "$" });
  assert.equal(prompt(lauf(z, "cd projekte/webshop").z).pfad, "~/projekte/webshop");
  assert.equal(prompt(lauf(z, "cd /var/log").z).pfad, "/var/log");
});

/* ---------------- Platzhalter ---------------- */

test("Platzhalter", () => {
  assert.equal(lauf(start(), "echo *.txt").aus, "notizen.txt todo.txt\n");
  assert.equal(lauf(start(), "echo *.nix").aus, "*.nix\n");
  assert.equal(lauf(start(), "echo projekte/*/*.css").aus, "projekte/webshop/style.css\n");
  assert.equal(lauf(start(), "echo ?odo.txt").aus, "todo.txt\n");
  assert.equal(lauf(start(), "echo '*.txt'").aus, "*.txt\n");
  assert.equal(lauf(start(), "echo .g*").aus, ".geheim\n");
  assert.ok(!lauf(start(), "echo *").aus.includes(".geheim"));
  assert.equal(lauf(start(), "echo /etc/host*").aus, "/etc/hostname /etc/hosts\n");
  assert.equal(lauf(start(), "echo */").aus, "bilder/ projekte/\n");
});

/* ---------------- ls ---------------- */

test("ls in Spalten und in Pipes", () => {
  assert.equal(lauf(start(), "ls").aus, "bilder  notizen.txt  projekte  skript.sh  todo.txt\n");
  assert.equal(lauf(start(), "ls | cat").aus, "bilder\nnotizen.txt\nprojekte\nskript.sh\ntodo.txt\n");
  assert.equal(lauf(start(), "ls", 30).aus, "bilder       skript.sh\nnotizen.txt  todo.txt\nprojekte\n");
});

test("ls Farben nur auf dem Bildschirm", () => {
  const e = lauf(start(), "ls");
  assert.deepEqual(
    e.teile.filter((t) => t.stil).map((t) => [t.text, t.stil]),
    [
      ["bilder", "ordner"],
      ["projekte", "ordner"],
      ["skript.sh", "ausfuehrbar"],
    ],
  );
});

test("ls -a und -A", () => {
  assert.equal(lauf(start(), "ls -a").aus, ".  ..  bilder  .geheim  notizen.txt  projekte  skript.sh  todo.txt\n");
  assert.equal(lauf(start(), "ls -A | cat").aus, "bilder\n.geheim\nnotizen.txt\nprojekte\nskript.sh\ntodo.txt\n");
});

test("ls -l", () => {
  const e = lauf(start(), "ls -l");
  assert.equal(
    e.aus,
    [
      "total 20",
      "drwxr-xr-x 2 azubi azubi 4096 Sep 28 08:12 bilder",
      "-rw-r--r-- 1 azubi azubi   29 Sep 28 08:12 notizen.txt",
      "drwxr-xr-x 3 azubi azubi 4096 Sep 28 08:12 projekte",
      "-rwxr-xr-x 1 azubi azubi   23 Sep 28 08:12 skript.sh",
      "-rw-r--r-- 1 azubi azubi   15 Sep 28 08:12 todo.txt",
      "",
    ].join("\n"),
  );
});

test("ls setzt Namen mit Leerzeichen nur auf dem Bildschirm in Anfuehrungszeichen", () => {
  const z = lauf(start(), "mkdir 'mein ordner'").z;
  assert.equal(lauf(z, "ls").aus, "bilder  'mein ordner'  notizen.txt  projekte  skript.sh  todo.txt\n");
  assert.ok(lauf(z, "ls | cat").aus.includes("\nmein ordner\n"));
  assert.ok(lauf(z, "ls -l | cat").aus.includes(" mein ordner\n"));
});

test("ls -lh, ls -ld, ls -l /dev/null", () => {
  assert.ok(lauf(start(), "ls -lh").aus.includes(" 4.0K Sep 28 08:12 bilder"));
  assert.equal(lauf(start(), "ls -ld projekte").aus, "drwxr-xr-x 3 azubi azubi 4096 Sep 28 08:12 projekte\n");
  assert.equal(lauf(start(), "ls -l /dev/null").aus, "crw-rw-rw- 1 root root 1, 3 Sep 28 08:12 /dev/null\n");
});

test("ls Fehler", () => {
  const e = lauf(start(), "ls nix");
  assert.equal(e.fehler, "ls: cannot access 'nix': No such file or directory\n");
  assert.equal(e.code, 2);
  assert.ok(e.hinweis.includes("„nix“"));
  assert.equal(lauf(start(), "ls -z").fehler, "ls: invalid option -- 'z'\nTry 'ls --help' for more information.\n");
  assert.equal(lauf(start(), "ls --foo").fehler, "ls: unrecognized option '--foo'\nTry 'ls --help' for more information.\n");
  assert.equal(lauf(start(), "ls /root").fehler, "ls: cannot open directory '/root': Permission denied\n");
  assert.equal(lauf(start(), "ls /home/mia").fehler, "ls: cannot open directory '/home/mia': Permission denied\n");
  assert.equal(lauf(start(), "sudo ls /root").aus, "geheim.txt\n");
});

test("ls mit mehreren Operanden und -R", () => {
  assert.equal(lauf(start(), "ls todo.txt projekte bilder").aus, "todo.txt\n\nbilder:\n\nprojekte:\nwebshop\n");
  assert.equal(lauf(start(), "ls -R projekte").aus, "projekte:\nwebshop\n\nprojekte/webshop:\nindex.html  style.css\n");
  const e = lauf(start(), "ls nix todo.txt");
  assert.equal(e.t.indexOf("cannot access") < e.t.indexOf("todo.txt"), true);
});

/* ---------------- cd, pwd ---------------- */

test("cd und pwd", () => {
  const z = start();
  assert.equal(lauf(z, "pwd").aus, "/home/azubi\n");
  assert.equal(kette(z, "cd projekte", "pwd").aus, "/home/azubi/projekte\n");
  assert.equal(kette(z, "cd projekte/webshop", "cd ../..", "pwd").aus, "/home/azubi\n");
  assert.equal(kette(z, "cd /tmp", "cd", "pwd").aus, "/home/azubi\n");
  assert.equal(kette(z, "cd /tmp", "cd ~/bilder", "pwd").aus, "/home/azubi/bilder\n");
  assert.equal(kette(z, "cd /etc", "cd /tmp", "cd -").aus, "/etc\n");
  assert.equal(kette(z, "cd /", "cd ..", "pwd").aus, "/\n");
});

test("cd Fehler", () => {
  assert.equal(lauf(start(), "cd nix").fehler, "bash: cd: nix: No such file or directory\n");
  assert.equal(lauf(start(), "cd notizen.txt").fehler, "bash: cd: notizen.txt: Not a directory\n");
  assert.equal(lauf(start(), "cd /root").fehler, "bash: cd: /root: Permission denied\n");
  assert.equal(lauf(start(), "cd a b").fehler, "bash: cd: too many arguments\n");
  assert.equal(lauf(start(), "cd -").fehler, "bash: cd: OLDPWD not set\n");
  assert.equal(lauf(start(), "cd nix").z.cwd, "/home/azubi");
});

/* ---------------- mkdir, touch ---------------- */

test("mkdir", () => {
  const z = start();
  const e = lauf(z, "mkdir backup");
  const k = knotenBei(e.z.wurzel, "/home/azubi/backup");
  assert.equal(k?.art, "ordner");
  assert.equal(k?.rechte, 0o775);
  assert.equal(k?.besitzer, "azubi");
  assert.equal(lauf(e.z, "mkdir backup").fehler, "mkdir: cannot create directory ‘backup’: File exists\n");
  assert.equal(lauf(z, "mkdir x/y").fehler, "mkdir: cannot create directory ‘x/y’: No such file or directory\n");
  assert.ok(lauf(z, "mkdir x/y").hinweis.includes("mkdir -p"));
  assert.equal(lauf(z, "mkdir -pv x/y/z").aus, "mkdir: created directory 'x'\nmkdir: created directory 'x/y'\nmkdir: created directory 'x/y/z'\n");
  assert.equal(lauf(z, "mkdir -p projekte").code, 0);
  assert.equal(lauf(z, "mkdir /etc/test").fehler, "mkdir: cannot create directory ‘/etc/test’: Permission denied\n");
  assert.equal(knotenBei(lauf(z, "sudo mkdir /etc/test").z.wurzel, "/etc/test")?.besitzer, "root");
  assert.equal(lauf(z, "mkdir").fehler, "mkdir: missing operand\nTry 'mkdir --help' for more information.\n");
});

test("touch", () => {
  const z = start();
  const e = lauf(z, "touch neu.txt");
  const k = knotenBei(e.z.wurzel, "/home/azubi/neu.txt");
  assert.equal(k?.art, "datei");
  assert.equal(k?.rechte, 0o664);
  assert.equal(knotenBei(lauf(z, "touch notizen.txt").z.wurzel, "/home/azubi/notizen.txt")?.geaendert.getTime(), JETZT.getTime());
  assert.equal(inhalt(lauf(z, "touch notizen.txt").z, "/home/azubi/notizen.txt"), "Einkaufen\nServer neu starten\n");
  assert.equal(lauf(z, "touch nix/a").fehler, "touch: cannot touch 'nix/a': No such file or directory\n");
  assert.equal(lauf(z, "touch").fehler, "touch: missing file operand\nTry 'touch --help' for more information.\n");
});

/* ---------------- cp, mv ---------------- */

test("cp Dateien", () => {
  const z = start();
  assert.equal(inhalt(lauf(z, "cp notizen.txt kopie.txt").z, "/home/azubi/kopie.txt"), "Einkaufen\nServer neu starten\n");
  assert.ok(inhalt(lauf(z, "cp notizen.txt bilder").z, "/home/azubi/bilder/notizen.txt"));
  assert.ok(inhalt(lauf(z, "cp notizen.txt todo.txt bilder/").z, "/home/azubi/bilder/todo.txt"));
  assert.equal(inhalt(lauf(z, "cp notizen.txt todo.txt").z, "/home/azubi/todo.txt"), "Einkaufen\nServer neu starten\n");
  assert.equal(inhalt(lauf(z, "cp /etc/hostname .").z, "/home/azubi/hostname"), "lernarena\n");
  assert.equal(knotenBei(lauf(z, "cp /etc/hostname .").z.wurzel, "/home/azubi/hostname")?.besitzer, "azubi");
});

test("cp Ordner und Fehler", () => {
  const z = start();
  assert.equal(lauf(z, "cp projekte alt").fehler, "cp: -r not specified; omitting directory 'projekte'\n");
  const r = lauf(z, "cp -r projekte alt");
  assert.ok(inhalt(r.z, "/home/azubi/alt/webshop/index.html"));
  assert.ok(inhalt(lauf(r.z, "cp -r projekte alt").z, "/home/azubi/alt/projekte/webshop/style.css"));
  assert.equal(lauf(z, "cp notizen.txt notizen.txt").fehler, "cp: 'notizen.txt' and 'notizen.txt' are the same file\n");
  assert.equal(lauf(z, "cp -r projekte projekte/webshop").fehler, "cp: cannot copy a directory, 'projekte', into itself, 'projekte/webshop/projekte'\n");
  assert.equal(lauf(z, "cp nix x").fehler, "cp: cannot stat 'nix': No such file or directory\n");
  assert.equal(lauf(z, "cp notizen.txt todo.txt ziel").fehler, "cp: target 'ziel': No such file or directory\n");
  assert.equal(lauf(z, "cp notizen.txt todo.txt skript.sh").fehler, "cp: target 'skript.sh' is not a directory\n");
  assert.equal(lauf(z, "cp").fehler, "cp: missing file operand\nTry 'cp --help' for more information.\n");
  assert.equal(lauf(z, "cp a").fehler, "cp: missing destination file operand after 'a'\nTry 'cp --help' for more information.\n");
  assert.equal(lauf(z, "cp /root/geheim.txt .").fehler, "cp: cannot stat '/root/geheim.txt': Permission denied\n");
  assert.equal(lauf(z, "cp notizen.txt /etc/").fehler, "cp: cannot create regular file '/etc/notizen.txt': Permission denied\n");
  assert.equal(lauf(z, "cp -v notizen.txt n2.txt").aus, "'notizen.txt' -> 'n2.txt'\n");
});

test("mv", () => {
  const z = start();
  const e = lauf(z, "mv notizen.txt ideen.txt");
  assert.equal(knotenBei(e.z.wurzel, "/home/azubi/notizen.txt"), undefined);
  assert.ok(inhalt(e.z, "/home/azubi/ideen.txt"));
  assert.ok(inhalt(lauf(z, "mv *.txt bilder").z, "/home/azubi/bilder/todo.txt"));
  assert.equal(lauf(z, "mv projekte projekte/webshop").fehler, "mv: cannot move 'projekte' to a subdirectory of itself, 'projekte/webshop/projekte'\n");
  assert.equal(lauf(z, "mv nix x").fehler, "mv: cannot stat 'nix': No such file or directory\n");
  assert.equal(inhalt(lauf(z, "mv notizen.txt todo.txt").z, "/home/azubi/todo.txt"), "Einkaufen\nServer neu starten\n");
  assert.equal(kette(z, "cd projekte/webshop", "mv ~/projekte ~/arbeit", "pwd").aus, "/home/azubi/arbeit/webshop\n");
  assert.equal(lauf(z, "mv /etc/hostname .").fehler, "mv: cannot move '/etc/hostname' to './hostname': Permission denied\n");
  assert.equal(lauf(z, "mv -v todo.txt t.txt").aus, "renamed 'todo.txt' -> 't.txt'\n");
});

/* ---------------- rm, rmdir ---------------- */

test("rm", () => {
  const z = start();
  assert.equal(knotenBei(lauf(z, "rm notizen.txt").z.wurzel, "/home/azubi/notizen.txt"), undefined);
  assert.equal(lauf(z, "rm nix").fehler, "rm: cannot remove 'nix': No such file or directory\n");
  assert.equal(lauf(z, "rm -f nix").t, "");
  assert.equal(lauf(z, "rm projekte").fehler, "rm: cannot remove 'projekte': Is a directory\n");
  assert.ok(lauf(z, "rm projekte").hinweis.includes("rm -r"));
  assert.ok(lauf(z, "rm bilder").hinweis.includes("rmdir"));
  assert.equal(knotenBei(lauf(z, "rm -r projekte").z.wurzel, "/home/azubi/projekte"), undefined);
  assert.equal(knotenBei(lauf(z, "rm -d bilder").z.wurzel, "/home/azubi/bilder"), undefined);
  assert.equal(lauf(z, "rm -r .").fehler, "rm: refusing to remove '.' or '..' directory: skipping '.'\n");
  assert.equal(lauf(z, "rm .").fehler, "rm: cannot remove '.': Is a directory\n");
  assert.equal(lauf(z, "rm /etc/hostname").fehler, "rm: cannot remove '/etc/hostname': Permission denied\n");
  assert.equal(lauf(z, "rm -v todo.txt").aus, "removed 'todo.txt'\n");
  assert.equal(lauf(z, "rm").fehler, "rm: missing operand\nTry 'rm --help' for more information.\n");
});

test("rm -rf / und sudo rm -rf /*", () => {
  const z = start();
  const e = lauf(z, "rm -rf /");
  assert.equal(e.fehler, "rm: it is dangerous to operate recursively on '/'\nrm: use --no-preserve-root to override this failsafe\n");
  assert.ok(e.hinweis.includes("echten Server"));
  const s = lauf(z, "sudo rm -rf /*");
  assert.equal(knotenBei(s.z.wurzel, "/etc"), undefined);
  assert.ok(s.hinweis.includes("Zurücksetzen"));
  // als azubi bleibt das System stehen, nur Eigenes ist weg
  const a = lauf(z, "rm -rf /*");
  assert.ok(knotenBei(a.z.wurzel, "/etc/hostname"));
  assert.equal(knotenBei(a.z.wurzel, "/home/azubi/notizen.txt"), undefined);
  assert.ok(knotenBei(a.z.wurzel, "/home/azubi"));
});

test("rmdir", () => {
  const z = start();
  assert.equal(knotenBei(lauf(z, "rmdir bilder").z.wurzel, "/home/azubi/bilder"), undefined);
  assert.equal(lauf(z, "rmdir projekte").fehler, "rmdir: failed to remove 'projekte': Directory not empty\n");
  assert.equal(lauf(z, "rmdir notizen.txt").fehler, "rmdir: failed to remove 'notizen.txt': Not a directory\n");
  assert.equal(lauf(z, "rmdir nix").fehler, "rmdir: failed to remove 'nix': No such file or directory\n");
  const p = kette(z, "mkdir -p a/b/c", "rmdir -pv a/b/c");
  assert.equal(p.aus, "rmdir: removing directory, 'a/b/c'\nrmdir: removing directory, 'a/b'\nrmdir: removing directory, 'a'\n");
  assert.equal(knotenBei(p.z.wurzel, "/home/azubi/a"), undefined);
});

/* ---------------- Umleitungen und Pipes ---------------- */

test("> und >>", () => {
  const z = start();
  const e = kette(z, "echo Hallo > gruss.txt", "echo Welt >> gruss.txt");
  assert.equal(inhalt(e.z, "/home/azubi/gruss.txt"), "Hallo\nWelt\n");
  assert.equal(e.t, "");
  assert.equal(inhalt(lauf(e.z, "echo neu > gruss.txt").z, "/home/azubi/gruss.txt"), "neu\n");
  assert.equal(inhalt(lauf(z, "> leer.txt").z, "/home/azubi/leer.txt"), "");
});

test("ls > liste.txt enthaelt die neue Datei selbst", () => {
  assert.equal(inhalt(lauf(start(), "ls > liste.txt").z, "/home/azubi/liste.txt"), "bilder\nliste.txt\nnotizen.txt\nprojekte\nskript.sh\ntodo.txt\n");
});

test("2>, 2>/dev/null, 2>&1 und Reihenfolge", () => {
  const z = start();
  const a = lauf(z, "ls nix 2> fehler.txt");
  assert.equal(a.t, "");
  assert.equal(inhalt(a.z, "/home/azubi/fehler.txt"), "ls: cannot access 'nix': No such file or directory\n");
  assert.equal(lauf(z, "ls nix 2>/dev/null").t, "");
  assert.equal(inhalt(lauf(z, "ls nix > alles.txt 2>&1").z, "/home/azubi/alles.txt"), "ls: cannot access 'nix': No such file or directory\n");
  const b = lauf(z, "ls nix 2>&1 > nur.txt");
  assert.equal(b.fehler, "ls: cannot access 'nix': No such file or directory\n");
  assert.equal(inhalt(b.z, "/home/azubi/nur.txt"), "");
  assert.equal(lauf(z, "ls nix 2>&1 | cat").aus, "ls: cannot access 'nix': No such file or directory\n");
  assert.equal(lauf(z, "ls nix | cat").fehler, "ls: cannot access 'nix': No such file or directory\n");
  assert.equal(lauf(z, "cat < notizen.txt").aus, "Einkaufen\nServer neu starten\n");
});

test("Umleitung Fehler", () => {
  const z = start();
  const e = lauf(z, "echo x > /etc/x");
  assert.equal(e.fehler, "bash: /etc/x: Permission denied\n");
  assert.equal(e.code, 1);
  assert.equal(lauf(z, "echo x > nix/x").fehler, "bash: nix/x: No such file or directory\n");
  assert.equal(lauf(z, "echo x > bilder").fehler, "bash: bilder: Is a directory\n");
  assert.equal(lauf(z, "cat < nix").fehler, "bash: nix: No such file or directory\n");
});

test("Pipe und cat -n", () => {
  assert.equal(lauf(start(), "cat notizen.txt | cat -n").aus, "     1\tEinkaufen\n     2\tServer neu starten\n");
  assert.equal(lauf(start(), "echo eins | cat - todo.txt").aus, "eins\nBackup prüfen\n");
});

/* ---------------- kleine Befehle ---------------- */

test("echo, whoami, sudo, date", () => {
  assert.equal(lauf(start(), "echo -n Hallo").aus, "Hallo");
  assert.equal(lauf(start(), "echo -e 'a\\tb\\nc'").aus, "a\tb\nc\n");
  assert.equal(lauf(start(), "echo --help").aus, "--help\n");
  assert.equal(lauf(start(), "whoami").aus, "azubi\n");
  const s = lauf(start(), "sudo whoami");
  assert.equal(s.aus, "root\n");
  assert.equal(s.z.benutzer, "azubi");
  assert.equal(lauf(start(), "whoami x").fehler, "whoami: extra operand ‘x’\nTry 'whoami --help' for more information.\n");
  assert.equal(lauf(start(), "date").aus, "Wed Sep 30 10:00:00 UTC 2026\n");
  assert.equal(lauf(start(), "date +%F").aus, "2026-09-30\n");
});

test("help, man, --help", () => {
  const h = lauf(start(), "help").aus;
  assert.ok(h.includes("Orientierung") && h.includes("pwd  ls  cd  tree"));
  assert.ok(lauf(start(), "man ls").aus.includes("Wichtige Optionen"));
  assert.ok(lauf(start(), "ls --help").aus.startsWith("ls: zeigt"));
  assert.equal(lauf(start(), "man xyz").fehler, "No manual entry for xyz\n");
  assert.equal(lauf(start(), "man xyz").code, 16);
});

test("clear", () => {
  const e = lauf(start(), "echo vorher; clear");
  assert.equal(e.leeren, true);
  assert.equal(e.t, "");
});

test("tree", () => {
  assert.equal(
    lauf(start(), "tree").aus,
    [".", "├── bilder", "├── notizen.txt", "├── projekte", "│   └── webshop", "│       ├── index.html", "│       └── style.css", "├── skript.sh", "└── todo.txt", "", "4 directories, 5 files", ""].join("\n"),
  );
  assert.equal(lauf(start(), "tree -L 1 projekte").aus, "projekte\n└── webshop\n\n2 directories, 0 files\n");
  assert.equal(lauf(start(), "tree nix").code, 2);
  assert.equal(lauf(start(), "tree /root").aus, "/root  [error opening dir]\n\n0 directories, 1 file\n");
});

test("exit und Aufruf mit Pfad", () => {
  assert.ok(lauf(start(), "exit").hinweis.includes("Zurücksetzen"));
  assert.equal(lauf(start(), "/usr/bin/whoami").aus, "azubi\n");
  assert.equal(lauf(start(), "./nix.sh").fehler, "bash: ./nix.sh: No such file or directory\n");
  assert.equal(lauf(start(), "./notizen.txt").fehler, "bash: ./notizen.txt: Permission denied\n");
});

test("/usr/bin enthaelt alle Befehle", () => {
  const e = lauf(start(), "ls /usr/bin | cat");
  for (const n of ["ls", "cd", "mkdir", "sudo", "bash"]) assert.ok(e.aus.split("\n").includes(n), n);
});

/* ---------------- Befunde aus dem Gutachten (30.09.) ---------------- */

test("A1: Schraegstrich am Ende verlangt einen Ordner", () => {
  const z = start();
  assert.equal(lauf(z, "mv notizen.txt todo.txt/").fehler, "mv: cannot stat 'todo.txt/': Not a directory\n");
  assert.equal(lauf(z, "mv notizen.txt nix/").fehler, "mv: cannot move 'notizen.txt' to 'nix/': Not a directory\n");
  assert.equal(lauf(z, "cp notizen.txt nix/").fehler, "cp: cannot create regular file 'nix/': Not a directory\n");
  assert.equal(lauf(z, "cp notizen.txt todo.txt/").fehler, "cp: cannot stat 'todo.txt/': Not a directory\n");
  assert.equal(lauf(z, "rm notizen.txt/").fehler, "rm: cannot remove 'notizen.txt/': Not a directory\n");
  assert.equal(lauf(z, "touch nix/").fehler, "touch: setting times of 'nix/': No such file or directory\n");
  assert.equal(lauf(z, "cat notizen.txt/").fehler, "cat: notizen.txt/: Not a directory\n");
  assert.equal(lauf(z, "echo x > notizen.txt/").fehler, "bash: notizen.txt/: Is a directory\n");
  assert.equal(lauf(z, "echo x > nix2/").fehler, "bash: nix2/: Is a directory\n");
  assert.equal(lauf(z, "cat < notizen.txt/").fehler, "bash: notizen.txt/: Not a directory\n");
  assert.equal(lauf(z, "rmdir notizen.txt/").fehler, "rmdir: failed to remove 'notizen.txt/': Not a directory\n");
  assert.equal(lauf(z, "mkdir notizen.txt/").fehler, "mkdir: cannot create directory ‘notizen.txt/’: File exists\n");
  // Ordner mit / am Ende bleiben erlaubt
  assert.ok(inhalt(lauf(z, "cp -r projekte neu/").z, "/home/azubi/neu/webshop/index.html"));
  assert.ok(knotenBei(lauf(z, "mv projekte neu/").z.wurzel, "/home/azubi/neu/webshop"));
  assert.equal(inhalt(z, "/home/azubi/todo.txt"), "Backup prüfen\n");
});

test("A2: leerer Pfad ist nicht der aktuelle Ordner", () => {
  const z = start();
  const e = lauf(z, "rm -r ''");
  assert.equal(e.fehler, "rm: cannot remove '': No such file or directory\n");
  assert.ok(knotenBei(e.z.wurzel, "/home/azubi/notizen.txt"));
  assert.ok(knotenBei(lauf(z, 'rm -r "$NIX"').z.wurzel, "/home/azubi/notizen.txt"));
  assert.equal(lauf(z, "ls ''").fehler, "ls: cannot access '': No such file or directory\n");
  assert.equal(lauf(z, "cat ''").fehler, "cat: '': No such file or directory\n");
  assert.equal(lauf(z, "mkdir ''").fehler, "mkdir: cannot create directory ‘’: No such file or directory\n");
  assert.equal(lauf(z, "mkdir -p ''").fehler, "mkdir: cannot create directory ‘’: No such file or directory\n");
  assert.equal(lauf(z, "touch ''").fehler, "touch: cannot touch '': No such file or directory\n");
  assert.equal(lauf(z, "cd ''").code, 0);
});

test("A3: Platzhalter ohne exponentielle Laufzeit", () => {
  const z = lauf(start(), "touch " + "a".repeat(40)).z;
  const t0 = Date.now();
  assert.equal(lauf(z, "echo " + "*a".repeat(25) + "*b").aus, "*a".repeat(25) + "*b\n");
  assert.ok(Date.now() - t0 < 500);
  assert.equal(lauf(z, "echo *a*a*").aus, "a".repeat(40) + "\n");
});

test("A4: zu lange Namen, kein Absturz", () => {
  const z = start();
  assert.equal(lauf(z, "mkdir " + "x".repeat(300)).fehler, `mkdir: cannot create directory ‘${"x".repeat(300)}’: File name too long\n`);
  const tief = lauf(z, "mkdir -p " + "b/".repeat(3000));
  assert.ok(tief.t.length > 0);
  assert.ok(lauf(tief.z, "tree").t.length > 0);
  assert.ok(lauf(tief.z, "rm -r b").t !== undefined);
});

test("A5: sudo mit eingebauten Befehlen", () => {
  const z = start();
  const e = lauf(z, "sudo cd /root");
  assert.equal(e.fehler, "sudo: cd: command not found\n");
  assert.equal(e.z.cwd, "/home/azubi");
  assert.equal(lauf(z, "sudo history").fehler, "sudo: history: command not found\n");
  assert.equal(lauf(z, "sudo nixbefehl").fehler, "sudo: nixbefehl: command not found\n");
  assert.ok(lauf(z, "sudo -u mia whoami").hinweis.includes("-u"));
  assert.equal(lauf(z, "sudo echo hi").aus, "hi\n");
});

test("B1/B2: cat Reihenfolge und gleiche Ein- und Ausgabedatei", () => {
  const z = start();
  const e = lauf(z, "cat nix todo.txt");
  assert.ok(e.t.indexOf("No such file") < e.t.indexOf("Backup"));
  const f = lauf(z, "cat notizen.txt >> notizen.txt");
  assert.equal(f.fehler, "cat: notizen.txt: input file is output file\n");
  assert.equal(inhalt(f.z, "/home/azubi/notizen.txt"), "Einkaufen\nServer neu starten\n");
  assert.equal(inhalt(lauf(z, "cat notizen.txt > notizen.txt").z, "/home/azubi/notizen.txt"), "");
});

test("B3: mkdir -p mit .. im Pfad", () => {
  const e = lauf(start(), "mkdir -pv a/b/../c");
  assert.equal(e.aus, "mkdir: created directory 'a'\nmkdir: created directory 'a/b'\nmkdir: created directory 'a/b/../c'\n");
  assert.ok(knotenBei(e.z.wurzel, "/home/azubi/a/b") && knotenBei(e.z.wurzel, "/home/azubi/a/c"));
  assert.equal(lauf(start(), "mkdir -p notizen.txt/x").fehler, "mkdir: cannot create directory ‘notizen.txt’: Not a directory\n");
});

test("B5/B6/B7: date, /bin, Spaltenbreite", () => {
  assert.equal(lauf(start(), "date foo").fehler, "date: invalid date ‘foo’\n");
  assert.equal(lauf(start(), "date +%F +%T").fehler, "date: extra operand ‘+%T’\nTry 'date --help' for more information.\n");
  assert.equal(lauf(start(), "/bin/whoami").aus, "azubi\n");
  const namen = ["a".repeat(20), "b".repeat(10), "cc", "d".repeat(28), "e", "f".repeat(6), "g".repeat(14), "hhh", "i".repeat(34), "j".repeat(7), "k", "l".repeat(12)];
  const z = lauf(szenario(), "touch " + namen.join(" ")).z;
  assert.equal(lauf(z, "ls").aus.split("\n")[0].trim().split(/\s+/).length, 2);
});

test("C: kleinere Befunde", () => {
  const z = start();
  assert.equal(lauf(z, "mv . x").fehler, "mv: cannot move '.' to 'x': Device or resource busy\n");
  assert.equal(lauf(z, "rmdir .").fehler, "rmdir: failed to remove '.': Invalid argument\n");
  assert.equal(kette(z, "cd bilder", "rmdir ~/bilder").code, 0);
  assert.equal(lauf(z, "echo hi >&1").aus, "hi\n");
  assert.equal(inhalt(lauf(z, "echo a 1>> todo.txt").z, "/home/azubi/todo.txt"), "Backup prüfen\na\n");
  assert.equal(lauf(z, "echo ${}").fehler, "bash: ${}: bad substitution\n");
  assert.equal(lauf(z, "echo ${HOME").fehler, "bash: unexpected EOF while looking for matching `}'\n");
  assert.ok(lauf(z, "echo $(pwd)").hinweis.includes("$( )"));
  assert.ok(lauf(z, "echo `pwd`").hinweis.includes("$( )"));
  assert.equal(lauf(z, "echo $1$@x").aus, "x\n");
  assert.equal(lauf(z, "echo a | cd projekte").z.cwd, "/home/azubi");
  assert.ok(knotenBei(lauf(z, "echo a | mkdir neu").z.wurzel, "/home/azubi/neu"));
  assert.equal(lauf(z, "history -5").code, 2);
  assert.equal(lauf(z, "cp -rv projekte pk").aus, "'projekte' -> 'pk'\n'projekte/webshop' -> 'pk/webshop'\n'projekte/webshop/index.html' -> 'pk/webshop/index.html'\n'projekte/webshop/style.css' -> 'pk/webshop/style.css'\n");
});

/* ---------------- Tab-Ergaenzung ---------------- */

test("Tab ergaenzt Befehle", () => {
  const z = start();
  assert.equal(ergaenze("who", 3, z).zeile, "whoami ");
  assert.deepEqual(ergaenze("c", 1, z).vorschlaege, ["cat", "cd", "clear", "cp"]);
  assert.equal(ergaenze("m", 1, z).zeile, "m");
  assert.deepEqual(ergaenze("m", 1, z).vorschlaege, ["man", "mkdir", "mv"]);
  assert.equal(ergaenze("sudo wh", 7, z).zeile, "sudo whoami ");
  assert.equal(ergaenze("ls | ca", 7, z).zeile, "ls | cat ");
});

test("Tab ergaenzt Pfade", () => {
  const z = start();
  assert.equal(ergaenze("cd pro", 6, z).zeile, "cd projekte/");
  assert.equal(ergaenze("cd projekte/w", 13, z).zeile, "cd projekte/webshop/");
  assert.equal(ergaenze("cat no", 6, z).zeile, "cat notizen.txt ");
  assert.equal(ergaenze("cat projekte/webshop/i", 22, z).zeile, "cat projekte/webshop/index.html ");
  assert.equal(ergaenze("ls /et", 6, z).zeile, "ls /etc/");
  assert.equal(ergaenze("ls ~/bi", 7, z).zeile, "ls ~/bilder/");
  assert.equal(ergaenze("cat .g", 6, z).zeile, "cat .geheim ");
  assert.deepEqual(ergaenze("ls ", 3, z).vorschlaege, ["bilder/", "notizen.txt", "projekte/", "skript.sh", "todo.txt"]);
  assert.equal(ergaenze("ls /root/", 9, z).zeile, "ls /root/");
  const mitLeer = lauf(z, "mkdir 'mein ordner'").z;
  assert.equal(ergaenze("cd me", 5, mitLeer).zeile, "cd mein\\ ordner/");
  // Cursor in der Mitte: Rest bleibt stehen
  const e = ergaenze("cd pro && ls", 6, z);
  assert.equal(e.zeile, "cd projekte/ && ls");
  assert.equal(e.cursor, 12);
});

/* ---------------- Ziele ---------------- */

test("Ziele pruefen Zustand und Verlauf", () => {
  let z = start();
  const verlauf: import("./typen").ProtokollEintrag[] = [];
  for (const zeile of ["ls -la", "mkdir backup", "cd backup"]) {
    const a = lauf(z, zeile);
    verlauf.push(...a.protokoll);
    z = a.z;
  }
  assert.ok(istOrdner("/home/azubi/backup", "").pruefe(z, verlauf));
  assert.ok(imOrdner("/home/azubi/backup", "").pruefe(z, verlauf));
  assert.ok(benutzt("ls", "", (a) => hatOption(a, "a", "all")).pruefe(z, verlauf));
  assert.ok(!benutzt("ls", "", (a) => hatOption(a, "R")).pruefe(z, verlauf));
  assert.ok(!benutzt("cd", "", (a) => a[0] === "nix").pruefe(z, verlauf));
});

test("Protokoll: eigentlicher Befehl, Ordner, sudo", () => {
  const z = start();
  const a = lauf(z, "sudo ls -la /root");
  assert.deepEqual(a.protokoll.map((e) => [e.name, e.args, e.sudo, e.cwd]), [["ls", ["-la", "/root"], true, "/home/azubi"]]);
  const b = lauf(z, "/usr/bin/ls -a");
  assert.equal(b.protokoll[0].name, "ls");
  const c = kette(z, "cd /etc", "ls");
  assert.equal(c.protokoll[0].cwd, "/etc");
  assert.equal(lauf(z, "cd /tmp").protokoll[0].cwd, "/home/azubi");
  assert.equal(lauf(z, "date -u").code, 0);
  assert.ok(lauf(z, "ls -l-a").hinweis.includes("Leerzeichen"));
});

test("Tab: man BEFEHL und ..", () => {
  const z = start();
  assert.equal(ergaenze("man mk", 6, z).zeile, "man mkdir ");
  assert.equal(ergaenze("cd ..", 5, z).zeile, "cd ../");
  assert.equal(ergaenze("cd ../..", 8, z).zeile, "cd ../../");
});

test("vergessenes Leerzeichen zwischen Befehl und Argument", () => {
  const z = start();
  const a = lauf(z, "cd../www/html");
  assert.equal(a.fehler, "bash: cd../www/html: No such file or directory\n");
  assert.ok(a.hinweis.includes("cd ../www/html") && a.hinweis.includes("Windows"));
  const b = lauf(z, "cd..");
  assert.equal(b.fehler, "bash: cd..: command not found\n");
  assert.ok(b.hinweis.includes("cd .."));
  assert.ok(lauf(z, "ls-la").hinweis.includes("ls -la"));
  assert.ok(lauf(z, "cd/var").hinweis.includes("cd /var"));
  assert.ok(!lauf(z, "lss").hinweis.includes("Leerzeichen"));
});

console.log(`\n${bestanden} bestanden, ${gescheitert} gescheitert`);
if (gescheitert > 0) process.exit(1);
