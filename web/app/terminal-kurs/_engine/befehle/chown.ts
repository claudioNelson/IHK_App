// chown: Besitzer (und Gruppe) aendern. Fremden Besitz verschenken darf nur root,
// deshalb fast immer mit sudo.

import { benutzer, gruppe, gruppenVon } from "../benutzer";
import { finde, setze, sortiereNamen } from "../dateisystem";
import { grundHinweis, grundText } from "../hinweise";
import { absolutMitEnde } from "../pfade";
import type { Befehl, Knoten, Ordner, Zustand } from "../typen";
import { zerlegeOptionen } from "../optionen";

export const chown: Befehl = {
  name: "chown",
  bereich: "Rechte",
  hilfe: {
    kurz: "ändert den Besitzer und die Gruppe (change owner). Braucht meist sudo.",
    aufruf: "chown [OPTION] BESITZER[:GRUPPE] DATEI …",
    optionen: [
      ["-R", "auch alles in Unterordnern (rekursiv)"],
      ["-v", "jede Änderung anzeigen"],
    ],
    beispiele: [
      ["sudo chown mia bericht.txt", "mia wird Besitzerin"],
      ["sudo chown www-data:www-data index.html", "Besitzer und Gruppe"],
      ["sudo chown -R azubi projekte", "ganzer Ordner"],
    ],
  },
  lauf: (k) => {
    const o = zerlegeOptionen("chown", k.args, { flags: "Rv", lang: { recursive: "R", verbose: "v" } });
    if (!o.ok) return o.fehler;
    const [angabe, ...dateien] = o.rest;
    if (angabe === undefined) {
      return { fehler: "chown: missing operand\nTry 'chown --help' for more information.\n", hinweis: "Hinweis: chown braucht den neuen Besitzer und eine Datei, zum Beispiel sudo chown mia bericht.txt.", code: 1 };
    }
    if (dateien.length === 0) {
      return { fehler: `chown: missing operand after '${angabe}'\nTry 'chown --help' for more information.\n`, hinweis: `Hinweis: Hinter ${angabe} fehlt die Datei, zum Beispiel sudo chown ${angabe} bericht.txt.`, code: 1 };
    }
    const doppel = angabe.indexOf(":");
    let neuerBesitzer: string | undefined = doppel < 0 ? angabe : angabe.slice(0, doppel) || undefined;
    let neueGruppe: string | undefined = doppel < 0 ? undefined : angabe.slice(doppel + 1) || undefined;
    if (neuerBesitzer !== undefined && !benutzer(neuerBesitzer)) {
      return { fehler: `chown: invalid user: '${angabe}'\n`, hinweis: `Hinweis: Einen Benutzer „${neuerBesitzer}“ gibt es nicht. Alle Benutzer stehen in /etc/passwd.`, code: 1 };
    }
    // "mia:" bedeutet: Gruppe = Hauptgruppe von mia
    if (doppel >= 0 && neueGruppe === undefined && neuerBesitzer !== undefined) neueGruppe = gruppe(neuerBesitzer) ? neuerBesitzer : undefined;
    if (neueGruppe !== undefined && !gruppe(neueGruppe)) {
      return { fehler: `chown: invalid group: '${angabe}'\n`, hinweis: `Hinweis: Eine Gruppe „${neueGruppe}“ gibt es nicht. Alle Gruppen stehen in /etc/group.`, code: 1 };
    }
    if (neuerBesitzer === undefined && neueGruppe === undefined) neuerBesitzer = undefined;

    let z: Zustand = k.zustand;
    let aus = "";
    let fehler = "";
    let hinweis: string | undefined;
    const ich = z.benutzer;

    const bearbeite = (anzeige: string, knoten: Knoten): Knoten => {
      const erlaubt =
        ich === "root" ||
        ((neuerBesitzer === undefined || (neuerBesitzer === knoten.besitzer && knoten.besitzer === ich)) &&
          (neueGruppe === undefined || (knoten.besitzer === ich && gruppenVon(ich).includes(neueGruppe))));
      if (!erlaubt) {
        fehler += `chown: changing ${neuerBesitzer === undefined ? "group" : "ownership"} of '${anzeige}': Operation not permitted\n`;
        hinweis ??= "Hinweis: Den Besitzer ändern darf nur root. Schreib sudo davor, zum Beispiel sudo chown mia datei.";
      }
      let ergebnis: Knoten = erlaubt ? { ...knoten, besitzer: neuerBesitzer ?? knoten.besitzer, gruppe: neueGruppe ?? knoten.gruppe } : knoten;
      if (o.flags.has("v") && erlaubt) {
        const alt = `${knoten.besitzer}:${knoten.gruppe}`;
        const neu = `${ergebnis.besitzer}:${ergebnis.gruppe}`;
        aus += alt === neu ? `ownership of '${anzeige}' retained as ${neu}\n` : `changed ownership of '${anzeige}' from ${alt} to ${neu}\n`;
      }
      if (o.flags.has("R") && ergebnis.art === "ordner") {
        const kinder: Record<string, Knoten> = {};
        for (const name of sortiereNamen(Object.keys(ergebnis.kinder))) {
          kinder[name] = bearbeite(`${anzeige.replace(/\/$/, "")}/${name}`, (ergebnis as Ordner).kinder[name]);
        }
        ergebnis = { ...ergebnis, kinder };
      }
      return ergebnis;
    };

    for (const getippt of dateien) {
      const fund = finde(z, absolutMitEnde(z.cwd, getippt));
      if (!fund.ok) {
        fehler += `chown: cannot access '${getippt}': ${grundText(fund.grund)}\n`;
        hinweis ??= grundHinweis(fund.grund, getippt);
        continue;
      }
      const neu = bearbeite(getippt, fund.knoten);
      if (neu !== fund.knoten) z = { ...z, wurzel: setze(z.wurzel, fund.pfad, neu, k.jetzt, false) };
    }
    return { ausgabe: aus, fehler, hinweis: fehler ? hinweis : undefined, zustand: z, code: fehler ? 1 : 0 };
  },
};
