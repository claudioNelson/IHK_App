// chmod: Rechte aendern, als Zahl (755, 644) oder mit Buchstaben (u+x, g-w, o=r).
// Nur der Besitzer oder root darf das.

import { finde, setze, sortiereNamen } from "../dateisystem";
import { grundHinweis, grundText } from "../hinweise";
import { absolutMitEnde } from "../pfade";
import { rechteText } from "../rechte";
import type { Befehl, Knoten, Ordner, Zustand } from "../typen";

const KLAUSEL = "[ugoa]*(?:[-+=](?:[rwxXst]*|[ugo]))+";
const SYMBOLISCH = new RegExp(`^${KLAUSEL}(?:,${KLAUSEL})*$`);

/** Rechnet einen Modus (Zahl oder Buchstaben) auf alte Rechte an. umask gilt, wenn kein ugoa davorsteht. */
export function neueRechte(modus: string, alt: number, istOrdner: boolean, umask: number): number {
  if (/^[0-7]{1,4}$/.test(modus)) {
    const n = parseInt(modus, 8);
    // Wie GNU: bei Ordnern bleiben setuid/setgid erhalten, wenn nur drei Ziffern angegeben sind
    return modus.length <= 3 && istOrdner ? (alt & 0o6000) | n : n;
  }
  let r = alt;
  for (const klausel of modus.split(",")) {
    const m = /^([ugoa]*)(.*)$/.exec(klausel) as RegExpExecArray;
    let wer = m[1];
    const ohneWer = wer === "";
    if (ohneWer || wer.includes("a")) wer = "ugo";
    const maske = ohneWer ? ~umask & 0o7777 : 0o7777;
    for (const op of m[2].match(/[-+=][^-+=]*/g) ?? []) {
      const zeichen = op[0];
      const rechte = op.slice(1);
      let bits = 0;
      if (/^[ugo]$/.test(rechte)) {
        const quelle = rechte === "u" ? (r >> 6) & 7 : rechte === "g" ? (r >> 3) & 7 : r & 7;
        for (const w of wer) bits |= quelle << (w === "u" ? 6 : w === "g" ? 3 : 0);
      } else {
        for (const c of rechte) {
          for (const w of wer) {
            const schiebe = w === "u" ? 6 : w === "g" ? 3 : 0;
            if (c === "r") bits |= 4 << schiebe;
            if (c === "w") bits |= 2 << schiebe;
            if (c === "x") bits |= 1 << schiebe;
            if (c === "X" && (istOrdner || (alt & 0o111) !== 0)) bits |= 1 << schiebe;
            if (c === "s" && w === "u") bits |= 0o4000;
            if (c === "s" && w === "g") bits |= 0o2000;
            if (c === "t" && w === "o") bits |= 0o1000;
          }
        }
      }
      bits &= maske;
      if (zeichen === "+") r |= bits;
      else if (zeichen === "-") r &= ~bits;
      else {
        // "=" loescht alle Bits der genannten Klassen (auch setuid/setgid/sticky), dann gilt nur noch bits
        let loesche = 0;
        for (const w of wer) loesche |= w === "u" ? 0o4700 : w === "g" ? 0o2070 : 0o1007;
        r = (r & ~loesche) | bits;
      }
    }
  }
  return r & 0o7777;
}

const oktal = (n: number) => n.toString(8).padStart(4, "0");
const ohneTyp = (k: Knoten) => rechteText(k).slice(1);

export const chmod: Befehl = {
  name: "chmod",
  bereich: "Rechte",
  hilfe: {
    kurz: "ändert die Rechte einer Datei oder eines Ordners (change mode). Nur der Besitzer oder root darf das.",
    aufruf: "chmod [OPTION] MODUS DATEI …",
    optionen: [
      ["-R", "auch alles in Unterordnern (rekursiv)"],
      ["-v", "jede Änderung anzeigen"],
    ],
    beispiele: [
      ["chmod 755 skript.sh", "rwxr-xr-x: alle dürfen lesen und ausführen"],
      ["chmod 640 geheim.txt", "rw-r-----: Gruppe liest, andere nichts"],
      ["chmod u+x skript.sh", "Besitzer darf ausführen"],
      ["chmod o-r notizen.txt", "andere dürfen nicht mehr lesen"],
    ],
  },
  lauf: (k) => {
    let rekursiv = false;
    let gespraechig = false;
    let modus: string | undefined;
    const dateien: string[] = [];
    let nurOperanden = false;
    for (const a of k.args) {
      if (nurOperanden) dateien.push(a);
      else if (a === "--") nurOperanden = true;
      else if (a === "--recursive") rekursiv = true;
      else if (a === "--verbose") gespraechig = true;
      else if (modus === undefined && (SYMBOLISCH.test(a) || /^[0-7]{1,4}$/.test(a))) modus = a;
      else if (/^-[Rv]+$/.test(a)) {
        if (a.includes("R")) rekursiv = true;
        if (a.includes("v")) gespraechig = true;
      } else if (a.startsWith("-") && a.length > 1) {
        const c = a.startsWith("--") ? a : a[1];
        return {
          fehler: a.startsWith("--") ? `chmod: unrecognized option '${a}'\nTry 'chmod --help' for more information.\n` : `chmod: invalid option -- '${c}'\nTry 'chmod --help' for more information.\n`,
          hinweis: "Hinweis: chmod kennt hier -R und -v. Danach kommt der Modus, etwa 755 oder u+x, und dann die Datei.",
          code: 1,
        };
      } else if (modus === undefined) modus = a;
      else dateien.push(a);
    }
    if (modus === undefined) {
      return { fehler: "chmod: missing operand\nTry 'chmod --help' for more information.\n", hinweis: "Hinweis: chmod braucht den neuen Modus und eine Datei, zum Beispiel chmod 644 notizen.txt.", code: 1 };
    }
    if (!SYMBOLISCH.test(modus) && !/^[0-7]{1,4}$/.test(modus)) {
      return {
        fehler: `chmod: invalid mode: '${modus}'\nTry 'chmod --help' for more information.\n`,
        hinweis: "Hinweis: Der Modus ist eine Zahl aus drei Ziffern von 0 bis 7 (etwa 755) oder Buchstaben wie u+x, g-w, o=r.",
        code: 1,
      };
    }
    if (dateien.length === 0) {
      return { fehler: `chmod: missing operand after '${modus}'\nTry 'chmod --help' for more information.\n`, hinweis: `Hinweis: Hinter dem Modus fehlt die Datei, zum Beispiel chmod ${modus} notizen.txt.`, code: 1 };
    }
    let z: Zustand = k.zustand;
    const umask = z.benutzer === "root" ? 0o022 : 0o002;
    let aus = "";
    let fehler = "";
    let hinweis: string | undefined;

    const bearbeite = (pfad: string, anzeige: string, knoten: Knoten) => {
      const verboten = z.benutzer !== "root" && knoten.besitzer !== z.benutzer;
      if (verboten) {
        fehler += `chmod: changing permissions of '${anzeige}': Operation not permitted\n`;
        hinweis ??=
          knoten.besitzer === "root"
            ? "Hinweis: Die Datei gehört root, also darf nur root ihre Rechte ändern. Mit sudo davor läuft der Befehl als root."
            : `Hinweis: Rechte ändern darf nur der Besitzer (hier ${knoten.besitzer}) oder root. Mit sudo davor läuft der Befehl als root.`;
      }
      const neu = verboten ? knoten.rechte : neueRechte(modus as string, knoten.rechte, knoten.art === "ordner", umask);
      let ergebnis: Knoten = verboten ? knoten : { ...knoten, rechte: neu };
      if (gespraechig && !verboten) {
        aus +=
          neu === knoten.rechte
            ? `mode of '${anzeige}' retained as ${oktal(neu)} (${ohneTyp(knoten)})\n`
            : `mode of '${anzeige}' changed from ${oktal(knoten.rechte)} (${ohneTyp(knoten)}) to ${oktal(neu)} (${ohneTyp(ergebnis)})\n`;
      }
      if (rekursiv && ergebnis.art === "ordner") {
        const kinder: Record<string, Knoten> = {};
        for (const name of sortiereNamen(Object.keys(ergebnis.kinder))) {
          kinder[name] = bearbeite(`${pfad}/${name}`, `${anzeige.replace(/\/$/, "")}/${name}`, (ergebnis as Ordner).kinder[name]);
        }
        ergebnis = { ...ergebnis, kinder };
      }
      return ergebnis;
    };

    for (const getippt of dateien) {
      const fund = finde(z, absolutMitEnde(z.cwd, getippt));
      if (!fund.ok) {
        fehler += `chmod: cannot access '${getippt}': ${grundText(fund.grund)}\n`;
        hinweis ??= grundHinweis(fund.grund, getippt);
        continue;
      }
      const neu = bearbeite(fund.pfad, getippt, fund.knoten);
      if (neu !== fund.knoten) z = { ...z, wurzel: setze(z.wurzel, fund.pfad, neu, k.jetzt, false) };
    }
    return { ausgabe: aus, fehler, hinweis: fehler ? hinweis : undefined, zustand: z, code: fehler ? 1 : 0 };
  },
};
