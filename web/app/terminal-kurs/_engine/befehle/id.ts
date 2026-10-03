// id und groups: wer bin ich, in welchen Gruppen bin ich?

import { benutzer, gruppe, gruppenVon } from "../benutzer";
import type { Befehl } from "../typen";
import { zerlegeOptionen } from "../optionen";

/** Gruppen eines Benutzers: Hauptgruppe zuerst, dann nach Nummer. */
function gruppenListe(name: string): string[] {
  const alle = gruppenVon(name);
  const haupt = alle.includes(name) ? name : alle[0];
  return [haupt, ...alle.filter((g) => g !== haupt).sort((a, b) => (gruppe(a)?.gid ?? 0) - (gruppe(b)?.gid ?? 0))];
}

export const id: Befehl = {
  name: "id",
  bereich: "Rechte",
  hilfe: {
    kurz: "zeigt Benutzernummer (uid), Hauptgruppe (gid) und alle Gruppen eines Benutzers.",
    aufruf: "id [OPTION] [BENUTZER]",
    optionen: [
      ["-u", "nur die Benutzernummer"],
      ["-g", "nur die Nummer der Hauptgruppe"],
      ["-G", "nur die Nummern aller Gruppen"],
      ["-n", "mit -u, -g oder -G: Namen statt Nummern"],
    ],
    beispiele: [
      ["id", "eigene Angaben"],
      ["id mia", "Angaben zu mia"],
    ],
  },
  lauf: (k) => {
    const o = zerlegeOptionen("id", k.args, { flags: "ugGn", lang: { user: "u", group: "g", groups: "G", name: "n" } });
    if (!o.ok) return o.fehler;
    const name = o.rest[0] ?? k.zustand.benutzer;
    const b = benutzer(name);
    if (!b) return { fehler: `id: '${name}': no such user\n`, hinweis: `Hinweis: Einen Benutzer „${name}“ gibt es nicht. Alle Benutzer stehen in /etc/passwd.`, code: 1 };
    const liste = gruppenListe(name);
    const gid = (g: string) => gruppe(g)?.gid ?? 0;
    const f = o.flags;
    if (f.has("u")) return { ausgabe: (f.has("n") ? name : String(b.uid)) + "\n", code: 0 };
    if (f.has("g")) return { ausgabe: (f.has("n") ? liste[0] : String(gid(liste[0]))) + "\n", code: 0 };
    if (f.has("G")) return { ausgabe: liste.map((g) => (f.has("n") ? g : String(gid(g)))).join(" ") + "\n", code: 0 };
    if (f.has("n")) return { fehler: "id: cannot print only names or real IDs in default format\n", hinweis: "Hinweis: -n geht nur zusammen mit -u, -g oder -G, zum Beispiel id -un.", code: 1 };
    const text = `uid=${b.uid}(${name}) gid=${gid(liste[0])}(${liste[0]}) groups=${liste.map((g) => `${gid(g)}(${g})`).join(",")}\n`;
    return { ausgabe: text, code: 0 };
  },
};

export const groups: Befehl = {
  name: "groups",
  bereich: "Rechte",
  hilfe: {
    kurz: "zeigt, in welchen Gruppen ein Benutzer ist.",
    aufruf: "groups [BENUTZER …]",
    beispiele: [
      ["groups", "eigene Gruppen"],
      ["groups mia", "Gruppen von mia"],
    ],
  },
  lauf: (k) => {
    const namen = k.args.filter((a) => !a.startsWith("-"));
    if (namen.length === 0) return { ausgabe: gruppenListe(k.zustand.benutzer).join(" ") + "\n", code: 0 };
    let aus = "";
    let fehler = "";
    for (const n of namen) {
      if (!benutzer(n)) fehler += `groups: '${n}': no such user\n`;
      else aus += `${n} : ${gruppenListe(n).join(" ")}\n`;
    }
    return { ausgabe: aus, fehler, hinweis: fehler ? "Hinweis: Alle Benutzer stehen in /etc/passwd." : undefined, code: fehler ? 1 : 0 };
  },
};
