// ls: Ordnerinhalt anzeigen. Ausgabe wie GNU ls unter Ubuntu: auf dem
// Bildschirm farbig in Spalten, in Pipes und Dateien ein Name pro Zeile.

import { finde, knotenBei, sortiereNamen } from "../dateisystem";
import { grundHinweis, grundText } from "../hinweise";
import { absolut, elternpfad } from "../pfade";
import { darf, rechteText } from "../rechte";
import type { Befehl, BefehlErgebnis, Knoten, Ordner, Teil } from "../typen";
import { zerlegeOptionen } from "../optionen";
import { Ausgabe, MONATE, shellName, stilVon, zwei } from "./_gemeinsam";

type Eintrag = { name: string; knoten: Knoten };

const HALBES_JAHR_MS = 15778476 * 1000;

/** Groesse fuer -h wie GNU: unter 1024 als Zahl, sonst 4.0K, 12K, 1.5M (aufgerundet). */
export function menschlich(bytes: number): string {
  if (bytes < 1024) return String(bytes);
  const einheiten = ["K", "M", "G", "T"];
  let wert = bytes;
  let i = -1;
  do {
    wert /= 1024;
    i++;
  } while (wert >= 1024 && i < einheiten.length - 1);
  if (wert < 10) {
    const gerundet = Math.ceil(wert * 10) / 10;
    return gerundet >= 10 ? `${Math.ceil(gerundet)}${einheiten[i]}` : `${gerundet.toFixed(1)}${einheiten[i]}`;
  }
  return `${Math.ceil(wert)}${einheiten[i]}`;
}

function groesse(k: Knoten): number {
  if (k.art === "ordner") return 4096;
  if (k.geraet) return 0;
  return new TextEncoder().encode(k.inhalt).length;
}

function bloecke(k: Knoten): number {
  if (k.art === "ordner") return 4;
  if (k.geraet) return 0;
  return Math.ceil(groesse(k) / 4096) * 4;
}

function links(k: Knoten): number {
  if (k.art !== "ordner") return 1;
  return 2 + Object.values(k.kinder).filter((c) => c.art === "ordner").length;
}

function zeitText(d: Date, jetzt: Date): string {
  const tag = String(d.getUTCDate()).padStart(2, " ");
  const alt = jetzt.getTime() - d.getTime() > HALBES_JAHR_MS || d.getTime() > jetzt.getTime() + 60_000;
  const ende = alt ? ` ${d.getUTCFullYear()}` : `${zwei(d.getUTCHours())}:${zwei(d.getUTCMinutes())}`;
  return `${MONATE[d.getUTCMonth()]} ${tag} ${ende}`;
}

function sortiere(eintraege: Eintrag[], nachZeit: boolean, umgekehrt: boolean): Eintrag[] {
  let liste: Eintrag[];
  if (nachZeit) {
    const namen = sortiereNamen(eintraege.map((e) => e.name));
    liste = [...eintraege].sort(
      (a, b) => b.knoten.geaendert.getTime() - a.knoten.geaendert.getTime() || namen.indexOf(a.name) - namen.indexOf(b.name),
    );
  } else {
    const reihenfolge = sortiereNamen(eintraege.map((e) => e.name));
    liste = reihenfolge.map((n) => eintraege.find((e) => e.name === n)!);
  }
  return umgekehrt ? liste.reverse() : liste;
}

/** Namen in Spalten (spaltenweise gefuellt wie GNU ls) oder einer pro Zeile. */
function kurzform(aus: Ausgabe, eintraege: Eintrag[], breite: number, spalten: boolean) {
  const namen = eintraege.map((e) => ({ text: spalten ? shellName(e.name) : e.name, stil: stilVon(e.knoten) }));
  if (namen.length === 0) return;
  if (!spalten) {
    for (const n of namen) {
      aus.add(n.text, n.stil);
      aus.add("\n");
    }
    return;
  }
  let zeilen = namen.length;
  let breiten: number[] = [Math.max(...namen.map((n) => n.text.length))];
  for (let anzahlSpalten = namen.length; anzahlSpalten >= 1; anzahlSpalten--) {
    const z = Math.ceil(namen.length / anzahlSpalten);
    const echteSpalten = Math.ceil(namen.length / z);
    const b: number[] = [];
    for (let s = 0; s < echteSpalten; s++) {
      b.push(Math.max(...namen.slice(s * z, s * z + z).map((n) => n.text.length)));
    }
    const gesamt = b.reduce((x, y) => x + y, 0) + 2 * (echteSpalten - 1);
    if (gesamt < breite || anzahlSpalten === 1) {
      zeilen = z;
      breiten = b;
      break;
    }
  }
  for (let r = 0; r < zeilen; r++) {
    for (let s = 0; s < breiten.length; s++) {
      const n = namen[s * zeilen + r];
      if (!n) continue;
      aus.add(n.text, n.stil);
      const hatNachfolger = namen[(s + 1) * zeilen + r] !== undefined;
      if (hatNachfolger) aus.add(" ".repeat(breiten[s] - n.text.length + 2));
    }
    aus.add("\n");
  }
}

/** Langform (-l): Rechte, Links, Besitzer, Gruppe, Groesse, Datum, Name. */
function langform(aus: Ausgabe, eintraege: Eintrag[], jetzt: Date, human: boolean, mitSumme: boolean, tty: boolean) {
  if (mitSumme) {
    const summe = eintraege.reduce((s, e) => s + bloecke(e.knoten), 0);
    aus.add(`total ${human ? menschlich(summe * 1024) : summe}\n`);
  }
  const zeilen = eintraege.map((e) => ({
    e,
    rechte: rechteText(e.knoten),
    links: String(links(e.knoten)),
    besitzer: e.knoten.besitzer,
    gruppe: e.knoten.gruppe,
    groesse: e.knoten.art === "datei" && e.knoten.geraet ? "1, 3" : human ? menschlich(groesse(e.knoten)) : String(groesse(e.knoten)),
    zeit: zeitText(e.knoten.geaendert, jetzt),
  }));
  const w = (f: (z: (typeof zeilen)[number]) => string) => Math.max(0, ...zeilen.map((z) => f(z).length));
  const wl = w((z) => z.links);
  const wb = w((z) => z.besitzer);
  const wg = w((z) => z.gruppe);
  const ws = w((z) => z.groesse);
  for (const z of zeilen) {
    aus.add(`${z.rechte} ${z.links.padStart(wl)} ${z.besitzer.padEnd(wb)} ${z.gruppe.padEnd(wg)} ${z.groesse.padStart(ws)} ${z.zeit} `);
    aus.add(tty ? shellName(z.e.name) : z.e.name, stilVon(z.e.knoten));
    aus.add("\n");
  }
}

export const ls: Befehl = {
  name: "ls",
  bereich: "Orientierung",
  hilfe: {
    kurz: "zeigt, was in einem Ordner liegt (list).",
    aufruf: "ls [OPTION] [ORDNER oder DATEI]",
    optionen: [
      ["-l", "lange Form mit Rechten, Besitzer, Größe und Datum"],
      ["-a", "auch versteckte Einträge (Name beginnt mit Punkt)"],
      ["-h", "mit -l: Größen lesbar (4.0K statt 4096)"],
      ["-R", "alle Unterordner mit anzeigen"],
      ["-t", "neueste zuerst"],
      ["-r", "Reihenfolge umdrehen"],
      ["-d", "Ordner selbst zeigen statt seines Inhalts"],
      ["-1", "ein Eintrag pro Zeile"],
    ],
    beispiele: [
      ["ls", "Inhalt des aktuellen Ordners"],
      ["ls -la", "alles, auch Verstecktes, in langer Form"],
      ["ls /etc", "Inhalt eines anderen Ordners"],
    ],
  },
  lauf: (k): BefehlErgebnis => {
    const o = zerlegeOptionen("ls", k.args, {
      flags: "aAlhRtrd1",
      lang: { all: "a", "almost-all": "A", "human-readable": "h", recursive: "R", reverse: "r", directory: "d" },
      fehlerCode: 2,
    });
    if (!o.ok) return o.fehler;
    const f = o.flags;
    const z = k.zustand;
    const lang = f.has("l");
    const alle = f.has("a");
    const fastAlle = f.has("A") && !alle;
    const spalten = k.tty && !f.has("1") && !lang;
    const aus = new Ausgabe();
    let fehler = "";
    let hinweis: string | undefined;
    let code = 0;

    const operanden = o.rest.length > 0 ? o.rest : ["."];
    const dateien: Eintrag[] = [];
    const ordner: { getippt: string; pfad: string; knoten: Ordner }[] = [];

    for (const getippt of operanden) {
      const pfad = absolut(z.cwd, getippt);
      const fund = finde(z, getippt.endsWith("/") ? pfad + "/" : pfad);
      if (!fund.ok) {
        fehler += `ls: cannot access '${getippt}': ${grundText(fund.grund)}\n`;
        hinweis ??= grundHinweis(fund.grund, getippt);
        code = 2;
        continue;
      }
      if (fund.knoten.art === "ordner" && !f.has("d")) ordner.push({ getippt, pfad: fund.pfad, knoten: fund.knoten });
      else dateien.push({ name: getippt, knoten: fund.knoten });
    }

    const zeige = (liste: Eintrag[], mitSumme: boolean) => {
      if (lang) langform(aus, liste, k.jetzt, f.has("h"), mitSumme, k.tty);
      else kurzform(aus, liste, k.breite, spalten);
    };

    if (dateien.length > 0) zeige(sortiere(dateien, f.has("t"), f.has("r")), false);

    const mitUeberschrift = operanden.length > 1 || f.has("R");
    let erster = dateien.length === 0;

    const listeOrdner = (getippt: string, pfad: string, knoten: Ordner) => {
      if (mitUeberschrift) {
        if (!erster) aus.add("\n");
        aus.add(`${getippt}:\n`);
      }
      erster = false;
      if (!darf(knoten, z.benutzer, "r")) {
        fehler += `ls: cannot open directory '${getippt}': Permission denied\n`;
        hinweis ??= grundHinweis("verweigert", getippt);
        code = 2;
        return;
      }
      let eintraege: Eintrag[] = Object.entries(knoten.kinder)
        .filter(([n]) => alle || fastAlle || !n.startsWith("."))
        .map(([name, kn]) => ({ name, knoten: kn }));
      eintraege = sortiere(eintraege, f.has("t"), f.has("r"));
      if (alle) {
        const eltern = knotenBei(z.wurzel, elternpfad(pfad)) ?? knoten;
        const punkte: Eintrag[] = [
          { name: ".", knoten },
          { name: "..", knoten: eltern },
        ];
        eintraege = f.has("r") ? [...eintraege, ...punkte.reverse()] : [...punkte, ...eintraege];
      }
      zeige(eintraege, true);
      if (f.has("R")) {
        for (const e of eintraege) {
          if (e.name === "." || e.name === ".." || e.knoten.art !== "ordner") continue;
          const unterGetippt = getippt.endsWith("/") ? getippt + e.name : `${getippt}/${e.name}`;
          const unterPfad = pfad === "/" ? `/${e.name}` : `${pfad}/${e.name}`;
          listeOrdner(unterGetippt, unterPfad, e.knoten);
        }
      }
    };

    for (const o2 of sortiere(
      ordner.map((x) => ({ name: x.getippt, knoten: x.knoten })),
      f.has("t"),
      f.has("r"),
    )) {
      const eintrag = ordner.find((x) => x.getippt === o2.name)!;
      listeOrdner(eintrag.getippt, eintrag.pfad, eintrag.knoten);
    }

    const anzeige: Teil[] = aus.teile;
    return { ausgabe: aus.text, anzeige, fehler, hinweis: fehler ? hinweis : undefined, code, fehlerZuerst: true };
  },
};
