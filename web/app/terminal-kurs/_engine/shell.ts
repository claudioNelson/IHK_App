// Fuehrt eine Eingabezeile aus: zerlegen, Variablen/~/Platzhalter ersetzen,
// Umleitungen oeffnen, Befehle der Pipeline nacheinander ausfuehren und die
// Ausgaben auf Bildschirm, Pipe oder Datei verteilen.
//
//   const { zustand, teile } = ausfuehren("ls -l | sort", zustand);

import { BEFEHLE } from "./befehle";
import { benutzer as findeBenutzer, gruppenVon, homeVon } from "./benutzer";
import { finde, neueDatei, pruefeEltern, setze, sortiereNamen } from "./dateisystem";
import { grundHinweis, grundText } from "./hinweise";
import { kurzhilfe } from "./kurzhilfe";
import { absolut, absolutMitEnde, endetMitSchraegstrich, teile as pfadTeile } from "./pfade";
import { darf } from "./rechte";
import type { BefehlErgebnis, Kontext, ProtokollEintrag, Teil, Zustand } from "./typen";
import { zerlege, type EinfacherBefehl, type Wort } from "./zerleger";

export type AusfuehrOptionen = {
  /** Uhrzeit fuer neue Dateien und date (Tests: feste Uhr) */
  jetzt?: Date;
  /** Breite des Terminals in Zeichen, Standard 80 */
  breite?: number;
};

export type Ausfuehrung = {
  zustand: Zustand;
  /** Was auf dem Bildschirm erscheint (ohne die Eingabezeile selbst) */
  teile: Teil[];
  /** true, wenn clear lief: vorherige Anzeige loeschen */
  leeren: boolean;
  /** Je ausgefuehrtem Befehl Name, Argumente, stdout und Rueckgabewert (fuer Aufgabenpruefung) */
  protokoll: ProtokollEintrag[];
};

/* ---------- Ersetzungen: Variablen, ~, Platzhalter ---------- */

function variable(name: string, z: Zustand): string {
  switch (name) {
    case "HOME":
      return homeVon(z.benutzer);
    case "USER":
    case "LOGNAME":
      return z.benutzer;
    case "PWD":
      return z.cwd;
    case "OLDPWD":
      return z.vorher;
    case "HOSTNAME":
      return "lernarena";
    case "SHELL":
      return "/bin/bash";
    case "PATH":
      return "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin";
    case "LANG":
      return "en_US.UTF-8";
    case "?":
      return String(z.letzterCode);
    case "$":
      return "4242";
    case "#":
      return "0";
    case "-":
      return "himBHs";
    default:
      return "";
  }
}

type Ersetzt = { text: string; wild: boolean[]; nurLeereVariable: boolean };

/** Ersetzt Variablen und ~; merkt sich, welche Zeichen echte Platzhalter sind. */
function ersetze(wort: Wort, z: Zustand): Ersetzt {
  let text = "";
  const wild: boolean[] = [];
  let nurLeereVariable = true;
  for (const t of wort) {
    let stueck: string;
    let platzhalterErlaubt = false;
    if (t.art === "text") {
      stueck = t.text;
      platzhalterErlaubt = t.quote === "keins";
      nurLeereVariable = false;
    } else if (t.art === "variable") {
      stueck = variable(t.name, z);
      if (t.quote !== "keins" || stueck !== "") nurLeereVariable = false;
    } else {
      nurLeereVariable = false;
      stueck = t.benutzer === "" ? homeVon(z.benutzer) : findeBenutzer(t.benutzer) ? homeVon(t.benutzer) : "~" + t.benutzer;
    }
    for (let i = 0; i < stueck.length; i++) {
      const c = stueck[i];
      text += c;
      wild.push(platzhalterErlaubt && (c === "*" || c === "?"));
    }
  }
  return { text, wild, nurLeereVariable };
}

/**
 * Passt name auf das Muster? Platzhalter nur dort, wo wild[i] gesetzt ist.
 * Linearer Vergleich mit Ruecksetzpunkt fuer * (kein RegExp, damit Muster wie
 * *a*a*a*b nicht exponentiell lange brauchen).
 */
function passt(name: string, muster: string, wild: boolean[]): boolean {
  let n = 0;
  let m = 0;
  let sternM = -1;
  let sternN = 0;
  while (n < name.length) {
    if (m < muster.length && wild[m] && muster[m] === "*") {
      sternM = m++;
      sternN = n;
    } else if (m < muster.length && ((wild[m] && muster[m] === "?") || (!wild[m] && muster[m] === name[n]))) {
      m++;
      n++;
    } else if (sternM >= 0) {
      m = sternM + 1;
      n = ++sternN;
    } else return false;
  }
  while (m < muster.length && wild[m] && muster[m] === "*") m++;
  return m === muster.length;
}

/** Platzhalter * und ? gegen das Dateisystem aufloesen (wie Bash, ohne Treffer bleibt das Wort). */
function platzhalter(e: Ersetzt, z: Zustand): string[] {
  if (!e.wild.some(Boolean)) return [e.text];
  const absolutGetippt = e.text.startsWith("/");
  // Segmente mit ihren Platzhalter-Markierungen
  const segmente: { text: string; wild: boolean[] }[] = [];
  let akt = { text: "", wild: [] as boolean[] };
  e.text.split("").forEach((c, i) => {
    if (c === "/") {
      segmente.push(akt);
      akt = { text: "", wild: [] };
    } else {
      akt.text += c;
      akt.wild.push(e.wild[i]);
    }
  });
  segmente.push(akt);

  let kandidaten: string[] = [absolutGetippt ? "/" : ""];
  let warWild = false;
  const start = absolutGetippt ? 1 : 0;
  for (let s = start; s < segmente.length; s++) {
    const seg = segmente[s];
    const istLetztes = s === segmente.length - 1;
    if (seg.text === "" && istLetztes) {
      // Schraegstrich am Ende: nur Ordner behalten
      kandidaten = kandidaten
        .filter((k) => {
          const f = finde(z, absolut(z.cwd, k || "."));
          return f.ok && f.knoten.art === "ordner";
        })
        .map((k) => (k.endsWith("/") ? k : k + "/"));
      continue;
    }
    if (seg.text === "") continue;
    const verbinde = (basis: string, name: string) => (basis === "" ? name : basis.endsWith("/") ? basis + name : basis + "/" + name);
    if (!seg.wild.some(Boolean)) {
      kandidaten = kandidaten.map((k) => verbinde(k, seg.text));
      if (warWild) kandidaten = kandidaten.filter((k) => finde(z, absolut(z.cwd, k)).ok);
      continue;
    }
    warWild = true;
    const zeigtVersteckte = seg.text.startsWith(".");
    const neu: string[] = [];
    for (const k of kandidaten) {
      const f = finde(z, absolut(z.cwd, k || "."));
      if (!f.ok || f.knoten.art !== "ordner" || !darf(f.knoten, z.benutzer, "r")) continue;
      const namen = sortiereNamen(Object.keys(f.knoten.kinder)).filter(
        (n) => passt(n, seg.text, seg.wild) && (zeigtVersteckte || !n.startsWith(".")),
      );
      for (const n of namen) {
        const pfad = verbinde(k, n);
        if (istLetztes) neu.push(pfad);
        else {
          const kind = f.knoten.kinder[n];
          if (kind.art === "ordner") neu.push(pfad);
        }
      }
    }
    kandidaten = neu;
  }
  return kandidaten.length > 0 ? kandidaten : [e.text];
}

/* ---------- Ausgabeziele ---------- */

type Ziel = { art: "bildschirm" } | { art: "pipe" } | { art: "null" } | { art: "datei"; pfad: string };

type Sammler = {
  zustand: Zustand;
  teile: Teil[];
  jetzt: Date;
};

/** Oeffnet eine Datei zum Schreiben (> leert, >> haengt an). Liefert Ziel oder Fehlermeldung. */
function oeffne(s: Sammler, getippt: string, anhaengen: boolean): { ok: true; ziel: Ziel } | { ok: false; fehler: string; hinweis: string } {
  const z = s.zustand;
  if (getippt === "") {
    return { ok: false, fehler: "bash: : No such file or directory\n", hinweis: "Hinweis: Nach > fehlt der Dateiname." };
  }
  const pfad = absolut(z.cwd, getippt);
  if (pfad === "/dev/null") return { ok: true, ziel: { art: "null" } };
  if (endetMitSchraegstrich(getippt)) {
    return { ok: false, fehler: `bash: ${getippt}: Is a directory\n`, hinweis: "Hinweis: Mit / am Ende ist ein Ordner gemeint. Umleiten geht nur in eine Datei." };
  }
  const fund = finde(z, pfad);
  if (fund.ok) {
    if (fund.knoten.art === "ordner") {
      return { ok: false, fehler: `bash: ${getippt}: Is a directory\n`, hinweis: `Hinweis: „${getippt}“ ist ein Ordner. Umleiten geht nur in eine Datei.` };
    }
    if (!darf(fund.knoten, z.benutzer, "w")) {
      return { ok: false, fehler: `bash: ${getippt}: Permission denied\n`, hinweis: grundHinweis("verweigert", getippt) };
    }
    if (!anhaengen) s.zustand = { ...z, wurzel: setze(z.wurzel, pfad, { ...fund.knoten, inhalt: "", geaendert: s.jetzt }, s.jetzt) };
    return { ok: true, ziel: { art: "datei", pfad } };
  }
  if (fund.grund !== "fehlt") {
    return { ok: false, fehler: `bash: ${getippt}: ${grundText(fund.grund)}\n`, hinweis: grundHinweis(fund.grund, getippt) };
  }
  const eltern = pruefeEltern(z, pfad);
  if (!eltern.ok) {
    return { ok: false, fehler: `bash: ${getippt}: ${grundText(eltern.grund)}\n`, hinweis: grundHinweis(eltern.grund, getippt) };
  }
  s.zustand = { ...z, wurzel: setze(z.wurzel, pfad, neueDatei(z, "", s.jetzt), s.jetzt) };
  return { ok: true, ziel: { art: "datei", pfad } };
}

/** Haengt Text an eine (zuvor geoeffnete) Datei an. */
function schreibe(s: Sammler, pfad: string, text: string) {
  if (text === "") return;
  const z = s.zustand;
  const k = finde({ ...z, benutzer: "root" }, pfad);
  if (!k.ok || k.knoten.art !== "datei") return;
  s.zustand = { ...z, wurzel: setze(z.wurzel, pfad, { ...k.knoten, inhalt: k.knoten.inhalt + text, geaendert: s.jetzt }, s.jetzt) };
}

/* ---------- Sonderfaelle, die kein eigener Befehl sind ---------- */

/**
 * Erkennt ein vergessenes Leerzeichen zwischen Befehl und Argument
 * ("cd..", "cd../www", "ls-la", "cd/var") und liefert den passenden Hinweis.
 */
function fehlendesLeerzeichen(name: string): string | null {
  const m = /^([a-z]+)([.\/~-].*)$/.exec(name);
  if (!m || !BEFEHLE.has(m[1])) return null;
  const gemeint = `${m[1]} ${m[2]}`;
  const windows = m[1] === "cd" && m[2].startsWith("..") ? " In der Windows-cmd geht cd.. auch ohne, unter Linux nicht." : "";
  return `Hinweis: Zwischen Befehl und Argument fehlt ein Leerzeichen. Gemeint war wohl: ${gemeint}.${windows}`;
}

const EDITOREN = new Set(["nano", "vim", "vi", "emacs", "pico", "gedit"]);

function sonderfall(name: string): BefehlErgebnis | null {
  if (EDITOREN.has(name)) {
    return {
      fehler: `bash: ${name}: command not found\n`,
      hinweis: `Hinweis: Texteditoren wie ${name} gibt es im Übungs-Terminal nicht. Text in eine Datei schreibst du mit echo "Text" > datei.txt, anhängen mit >>.`,
      code: 127,
    };
  }
  if (name === "exit" || name === "logout") {
    return {
      ausgabe: "logout\n",
      fehler: "",
      hinweis: "Hinweis: Das Übungs-Terminal bleibt offen. Mit „Zurücksetzen“ fängst du von vorn an.",
      code: 0,
    };
  }
  return null;
}

/** Aehnlichster bekannter Befehl (Tippfehler), sonst null. */
function vorschlag(name: string): string | null {
  const abstand = (a: string, b: string) => {
    const d = Array.from({ length: a.length + 1 }, (_, i) => [i, ...Array(b.length).fill(0)]);
    for (let j = 1; j <= b.length; j++) d[0][j] = j;
    for (let i = 1; i <= a.length; i++)
      for (let j = 1; j <= b.length; j++)
        d[i][j] = Math.min(d[i - 1][j] + 1, d[i][j - 1] + 1, d[i - 1][j - 1] + (a[i - 1] === b[j - 1] ? 0 : 1));
    return d[a.length][b.length];
  };
  let bester: string | null = null;
  let besterAbstand = 3;
  for (const b of BEFEHLE.keys()) {
    const a = abstand(name.toLowerCase(), b);
    if (a < besterAbstand && a <= Math.max(1, Math.floor(b.length / 2))) {
      bester = b;
      besterAbstand = a;
    }
  }
  return bester;
}

/* ---------- Einen Befehl (ohne Umleitungen) ausfuehren ---------- */

/** In die Bash eingebaut: laufen nicht mit sudo (sudo startet nur Programme). */
const EINGEBAUT = new Set(["cd", "history", "help", "exit", "logout"]);

type Umgebung = {
  eingabe: string | null;
  z: Zustand;
  jetzt: Date;
  breite: number;
  tty: boolean;
  ausgabeDatei: string | null;
  /** true, wenn der Befehl ueber sudo gestartet wurde */
  sudo?: boolean;
};

type Gestartet = BefehlErgebnis & {
  /** Name fuer das Protokoll (eigentlicher Befehl) */
  name: string;
  /** Argumente des eigentlichen Befehls (bei sudo ohne "sudo") */
  protokollArgs: string[];
  sudo?: boolean;
};

function starteBefehl(args: string[], u: Umgebung): Gestartet {
  return { protokollArgs: args.slice(1), ...starteEinzeln(args, u) };
}

function starteEinzeln(args: string[], u: Umgebung): BefehlErgebnis & { name: string; protokollArgs?: string[]; sudo?: boolean } {
  const { eingabe, z, jetzt, breite, tty, ausgabeDatei } = u;
  const name = args[0];
  const rest = args.slice(1);

  if (name === "sudo") {
    if (rest.length === 0) {
      return { name, fehler: "usage: sudo command\n", hinweis: "Hinweis: Hinter sudo gehört der Befehl, der mit Administratorrechten laufen soll, zum Beispiel sudo ls /root.", code: 1 };
    }
    if (rest[0].startsWith("-")) {
      return {
        name,
        fehler: "",
        hinweis: `Hinweis: Optionen für sudo wie ${rest[0]} kennt das Übungs-Terminal noch nicht. Schreib den Befehl direkt hinter sudo, zum Beispiel sudo ls /root.`,
        code: 1,
      };
    }
    if (z.benutzer !== "root" && !gruppenVon(z.benutzer).includes("sudo")) {
      return { name, fehler: `${z.benutzer} is not in the sudoers file.\n`, hinweis: "Hinweis: Nur Mitglieder der Gruppe sudo dürfen sudo benutzen.", code: 1 };
    }
    const erg = starteBefehl(rest, { ...u, z: { ...z, benutzer: "root" }, sudo: true });
    // Zustand uebernehmen (Dateisystem), aber Benutzer und Ordner bleiben die des Aufrufers
    const neu = erg.zustand ? { ...erg.zustand, benutzer: z.benutzer, cwd: z.cwd, vorher: z.vorher } : undefined;
    return { ...erg, zustand: neu, sudo: true };
  }

  if (u.sudo && (EINGEBAUT.has(name) || EDITOREN.has(name) || (!name.includes("/") && !BEFEHLE.has(name)))) {
    const eingebaut = EINGEBAUT.has(name);
    return {
      name,
      fehler: `sudo: ${name}: command not found\n`,
      hinweis: eingebaut
        ? `Hinweis: ${name} ist in die Bash eingebaut und läuft deshalb nicht mit sudo.${name === "cd" ? " In Ordner, die nur root lesen darf, schaust du mit sudo ls ORDNER." : ""}`
        : "Hinweis: Diesen Befehl kennt das Übungs-Terminal nicht. Tippe help für alle Befehle.",
      code: 1,
    };
  }

  const sonder = sonderfall(name);
  if (sonder) return { ...sonder, name };

  // Aufruf mit Pfad (z. B. /usr/bin/ls): nur Befehle aus /usr/bin und /bin
  let befehlsName = name;
  if (name.includes("/")) {
    const pfad = absolut(z.cwd, name);
    const t = pfadTeile(pfad);
    const fund = finde(z, pfad);
    if (fund.ok && t.length >= 2 && (pfad.startsWith("/usr/bin/") || pfad.startsWith("/bin/")) && BEFEHLE.has(t[t.length - 1])) {
      befehlsName = t[t.length - 1];
    } else if (fund.ok) {
      if (fund.knoten.art === "ordner") {
        return { name, fehler: `bash: ${name}: Is a directory\n`, hinweis: `Hinweis: „${name}“ ist ein Ordner. Hineinwechseln geht mit cd ${name}.`, code: 126 };
      }
      if (!darf(fund.knoten, z.benutzer, "x")) {
        return { name, fehler: `bash: ${name}: Permission denied\n`, hinweis: `Hinweis: Die Datei ist nicht ausführbar. Das x-Recht setzt du mit chmod +x ${name}.`, code: 126 };
      }
      return { name, fehler: "", hinweis: "Hinweis: Eigene Skripte ausführen kann das Übungs-Terminal noch nicht. Das kommt mit der Lektion zu Skripten.", code: 0 };
    } else {
      return { name, fehler: `bash: ${name}: ${grundText(fund.grund)}\n`, hinweis: fehlendesLeerzeichen(name) ?? grundHinweis(fund.grund, name), code: 127 };
    }
  }

  const befehl = BEFEHLE.get(befehlsName);
  if (!befehl) {
    const v = vorschlag(befehlsName);
    return {
      name,
      fehler: `bash: ${name}: command not found\n`,
      hinweis: fehlendesLeerzeichen(name) ?? (v
        ? `Hinweis: Diesen Befehl kennt das Übungs-Terminal nicht. Meintest du ${v}? Tippe help für alle Befehle.`
        : "Hinweis: Diesen Befehl kennt das Übungs-Terminal nicht. Tippe help für alle Befehle."),
      code: 127,
    };
  }

  const endeOptionen = rest.indexOf("--");
  const vorEnde = endeOptionen < 0 ? rest : rest.slice(0, endeOptionen);
  if (vorEnde.includes("--help") && befehlsName !== "echo") {
    return { name: befehlsName, ausgabe: kurzhilfe(befehl), code: 0 };
  }

  const kontext: Kontext = { name: befehlsName, args: rest, eingabe, zustand: z, jetzt, breite, tty, ausgabeDatei, befehle: BEFEHLE };
  return { ...befehl.lauf(kontext), name: befehlsName };
}

/* ---------- Eine Pipeline ---------- */

function fuehrePipelineAus(
  pipeline: EinfacherBefehl[],
  s: Sammler,
  breite: number,
  protokoll: Ausfuehrung["protokoll"],
): { code: number; leeren: boolean } {
  let eingabe: string | null = null;
  let code = 0;
  let leeren = false;

  pipeline.forEach((befehl, index) => {
    const istLetzter = index === pipeline.length - 1;
    const z0 = s.zustand;

    // Woerter ersetzen
    const args: string[] = [];
    for (const w of befehl.woerter) {
      const e = ersetze(w, z0);
      if (e.nurLeereVariable) continue;
      args.push(...platzhalter(e, z0));
    }

    // Umleitungen der Reihe nach oeffnen
    let fd1: Ziel = istLetzter ? { art: "bildschirm" } : { art: "pipe" };
    let fd2: Ziel = { art: "bildschirm" };
    let eigeneEingabe: string | null = eingabe;
    let umleitungsFehler: { fehler: string; hinweis: string } | null = null;

    for (const u of befehl.umleitungen) {
      if (!("ziel" in u)) {
        if (u.art === "2>&1") fd2 = fd1;
        else fd1 = fd2;
        continue;
      }
      const ziel = ersetze(u.ziel, s.zustand).text;
      if (u.art === "<") {
        const fund = finde(s.zustand, absolutMitEnde(s.zustand.cwd, ziel));
        if (!fund.ok) {
          umleitungsFehler = { fehler: `bash: ${ziel}: ${grundText(fund.grund)}\n`, hinweis: grundHinweis(fund.grund, ziel) };
          break;
        }
        if (fund.knoten.art === "ordner") {
          umleitungsFehler = { fehler: `bash: ${ziel}: Is a directory\n`, hinweis: `Hinweis: „${ziel}“ ist ein Ordner, lesen geht nur aus einer Datei.` };
          break;
        }
        if (!darf(fund.knoten, s.zustand.benutzer, "r")) {
          umleitungsFehler = { fehler: `bash: ${ziel}: Permission denied\n`, hinweis: grundHinweis("verweigert", ziel) };
          break;
        }
        eigeneEingabe = fund.knoten.inhalt;
        continue;
      }
      const anhaengen = u.art === ">>" || u.art === "2>>" || u.art === "&>>";
      const geoeffnet = oeffne(s, ziel, anhaengen);
      if (!geoeffnet.ok) {
        umleitungsFehler = geoeffnet;
        break;
      }
      if (u.art === ">" || u.art === ">>") fd1 = geoeffnet.ziel;
      else if (u.art === "2>" || u.art === "2>>") fd2 = geoeffnet.ziel;
      else {
        fd1 = geoeffnet.ziel;
        fd2 = geoeffnet.ziel;
      }
    }

    if (umleitungsFehler) {
      // Wie Bash: Befehl laeuft nicht, Meldung immer auf den Bildschirm
      s.teile.push({ text: umleitungsFehler.fehler, stil: "fehler" }, { text: umleitungsFehler.hinweis + "\n", stil: "hinweis" });
      eingabe = istLetzter ? null : "";
      code = 1;
      return;
    }
    if (args.length === 0) {
      // Nur Umleitungen (z. B. "> leer.txt"): Datei ist angelegt, sonst nichts
      eingabe = istLetzter ? null : "";
      code = 0;
      return;
    }

    const ergebnis = starteBefehl(args, {
      eingabe: eigeneEingabe,
      z: s.zustand,
      jetzt: s.jetzt,
      breite,
      tty: fd1.art === "bildschirm",
      ausgabeDatei: fd1.art === "datei" ? fd1.pfad : null,
    });
    if (ergebnis.zustand) {
      // In einer Pipeline mit mehreren Befehlen laeuft jeder Teil in einer eigenen Unter-Shell:
      // Aenderungen am Dateisystem bleiben, Ordnerwechsel und Verlauf nicht (wie Bash)
      s.zustand = pipeline.length > 1 ? { ...s.zustand, wurzel: ergebnis.zustand.wurzel } : ergebnis.zustand;
    }
    if (ergebnis.leeren && fd1.art === "bildschirm") {
      leeren = true;
      s.teile = [];
    }
    const ausgabe = ergebnis.ausgabe ?? "";
    const fehler = ergebnis.fehler ?? "";
    code = ergebnis.code ?? 0;
    protokoll.push({ name: ergebnis.name, args: ergebnis.protokollArgs, ausgabe, code, cwd: z0.cwd, sudo: ergebnis.sudo === true });

    let naechsteEingabe = "";
    const verteile = (text: string, ziel: Ziel, istFehler: boolean) => {
      if (ziel.art === "bildschirm") {
        if (istFehler) {
          if (text) s.teile.push({ text, stil: "fehler" });
          if (ergebnis.hinweis) s.teile.push({ text: ergebnis.hinweis + "\n", stil: "hinweis" });
        } else if (text) {
          if (ergebnis.anzeige && fd1.art === "bildschirm") s.teile.push(...ergebnis.anzeige);
          else s.teile.push({ text });
        }
      } else if (ziel.art === "pipe") naechsteEingabe += text;
      else if (ziel.art === "datei") schreibe(s, ziel.pfad, text);
    };
    if (ergebnis.fehlerZuerst && (fehler || ergebnis.hinweis)) {
      verteile(fehler, fd2, true);
      verteile(ausgabe, fd1, false);
    } else {
      verteile(ausgabe, fd1, false);
      if (fehler || ergebnis.hinweis) verteile(fehler, fd2, true);
    }
    eingabe = istLetzter ? null : naechsteEingabe;
  });

  return { code, leeren };
}

/* ---------- Oeffentliche Einstiege ---------- */

/**
 * Fuehrt eine ganze Eingabezeile aus und liefert neuen Zustand plus Bildschirmausgabe.
 * Wirft nie: ein unerwarteter Fehler laesst den Zustand unveraendert und meldet sich freundlich.
 */
export function ausfuehren(zeile: string, zustand: Zustand, opt: AusfuehrOptionen = {}): Ausfuehrung {
  try {
    return ausfuehrenIntern(zeile, zustand, opt);
  } catch {
    return {
      zustand: { ...zustand, letzterCode: 1 },
      teile: [{ text: "Hinweis: Das Übungs-Terminal ist hier an seine Grenze gekommen. Probier es mit einem kürzeren oder einfacheren Befehl.\n", stil: "hinweis" }],
      leeren: false,
      protokoll: [],
    };
  }
}

function ausfuehrenIntern(zeile: string, zustand: Zustand, opt: AusfuehrOptionen): Ausfuehrung {
  const jetzt = opt.jetzt ?? new Date();
  const breite = opt.breite ?? 80;
  let z = zustand;

  // Verlauf wie Ubuntu (HISTCONTROL=ignoreboth): keine Zeilen mit Leerzeichen am Anfang, keine direkten Wiederholungen
  if (zeile.trim() !== "" && !/^\s/.test(zeile) && z.verlauf[z.verlauf.length - 1] !== zeile) {
    z = { ...z, verlauf: [...z.verlauf, zeile] };
  }

  const zerlegt = zerlege(zeile);
  if (!zerlegt.ok) {
    return {
      zustand: { ...z, letzterCode: 2 },
      teile: [
        { text: zerlegt.fehler, stil: "fehler" },
        { text: zerlegt.hinweis + "\n", stil: "hinweis" },
      ],
      leeren: false,
      protokoll: [],
    };
  }

  const s: Sammler = { zustand: z, teile: [], jetzt };
  const protokoll: Ausfuehrung["protokoll"] = [];
  let leeren = false;
  let code = z.letzterCode;

  zerlegt.kette.forEach((glied, i) => {
    const bedingung = i > 0 ? zerlegt.kette[i - 1].danach : null;
    if (bedingung === "&&" && code !== 0) return;
    if (bedingung === "||" && code === 0) return;
    s.zustand = { ...s.zustand, letzterCode: code };
    const erg = fuehrePipelineAus(glied.pipeline, s, breite, protokoll);
    code = erg.code;
    if (erg.leeren) leeren = true;
  });

  return { zustand: { ...s.zustand, letzterCode: code }, teile: s.teile, leeren, protokoll };
}

/** Prompt in Teilen fuer die Anzeige: benutzer@lernarena:~/pfad$ */
export function prompt(z: Zustand): { benutzer: string; pfad: string; zeichen: "$" | "#" } {
  const home = homeVon(z.benutzer);
  const pfad = z.cwd === home ? "~" : z.cwd.startsWith(home + "/") ? "~" + z.cwd.slice(home.length) : z.cwd;
  return { benutzer: `${z.benutzer}@lernarena`, pfad, zeichen: z.benutzer === "root" ? "#" : "$" };
}
