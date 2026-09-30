// Kurzschreibweise fuer Start-Dateisysteme von Aufgaben und Spielwiese.
//
//   szenario({
//     "/home/azubi/notizen.txt": "Einkaufen\nServer neu starten\n",
//     "/home/azubi/projekte/": {},                                  // leerer Ordner
//     "/var/log/auth.log": { inhalt: LOG, besitzer: "root", rechte: 0o640 },
//   })
//
// Standard: unter /home/<name> gehoert alles <name>:<name>, sonst root:root;
// Dateien 644, Ordner 755. Das Grundsystem (/etc, /home, /root, /tmp, /usr/bin,
// /var/log, /dev/null) ist immer da. Fehlende Zwischenordner entstehen von selbst.

import { BEFEHLE } from "./befehle";
import { groupText, passwdText } from "./benutzer";
import { knotenBei, setze } from "./dateisystem";
import { elternpfad, normalisiere, teile } from "./pfade";
import type { Knoten, Ordner, Zustand } from "./typen";

export type Eintrag =
  | string
  | {
      inhalt?: string;
      /** true: Ordner (auch ohne "/" am Ende des Pfads) */
      ordner?: boolean;
      besitzer?: string;
      gruppe?: string;
      rechte?: number;
      geaendert?: Date;
    };

export type SzenarioOptionen = {
  /** Start-Ordner, Standard Home des Benutzers */
  cwd?: string;
  benutzer?: string;
  /** Zeitstempel aller Eintraege ohne eigenes Datum */
  zeit?: Date;
};

/** Feste Zeit der Szenario-Dateien, damit ls -l immer gleich aussieht. */
export const STANDARDZEIT = new Date("2026-09-28T08:12:00Z");

function standardBesitzer(pfad: string): string {
  const t = teile(pfad);
  return t[0] === "home" && t[1] ? t[1] : "root";
}

function leererOrdner(pfad: string, zeit: Date, rechte = 0o755): Ordner {
  const b = standardBesitzer(pfad);
  return { art: "ordner", kinder: {}, besitzer: b, gruppe: b, rechte, geaendert: zeit };
}

/** Legt fehlende Ordner bis pfad an (mit Standardwerten). */
function sichereOrdner(wurzel: Ordner, pfad: string, zeit: Date): Ordner {
  let w = wurzel;
  let aktuell = "";
  for (const name of teile(pfad)) {
    aktuell += "/" + name;
    const k = knotenBei(w, aktuell);
    if (!k) w = setze(w, aktuell, leererOrdner(aktuell, zeit), zeit);
    else if (k.art !== "ordner") throw new Error(`Szenario: ${aktuell} ist eine Datei`);
  }
  return w;
}

function legeAn(wurzel: Ordner, roherPfad: string, eintrag: Eintrag, zeit: Date): Ordner {
  const pfad = normalisiere(roherPfad);
  const alsOrdner = roherPfad.endsWith("/") || (typeof eintrag === "object" && eintrag.ordner === true);
  const e = typeof eintrag === "string" ? { inhalt: eintrag } : eintrag;
  const besitzer = e.besitzer ?? standardBesitzer(pfad);
  const meta = {
    besitzer,
    gruppe: e.gruppe ?? besitzer,
    geaendert: e.geaendert ?? zeit,
  };
  let w = sichereOrdner(wurzel, elternpfad(pfad), zeit);
  const vorhanden = knotenBei(w, pfad);
  let knoten: Knoten;
  if (alsOrdner) {
    const kinder = vorhanden?.art === "ordner" ? vorhanden.kinder : {};
    knoten = { art: "ordner", kinder, rechte: e.rechte ?? 0o755, ...meta };
  } else {
    knoten = { art: "datei", inhalt: e.inhalt ?? "", rechte: e.rechte ?? 0o644, ...meta };
  }
  // Zeit des Elternordners nicht veraendern: setze() stempelt ihn, deshalb danach zuruecksetzen
  const elternVorher = knotenBei(w, elternpfad(pfad));
  w = setze(w, pfad, knoten, zeit);
  if (elternVorher && elternVorher.art === "ordner" && pfad !== "/") {
    const elternNachher = knotenBei(w, elternpfad(pfad));
    if (elternNachher && elternNachher.art === "ordner") {
      w = setze(w, elternpfad(pfad), { ...elternNachher, geaendert: elternVorher.geaendert }, zeit);
    }
  }
  return w;
}

const OS_RELEASE = `PRETTY_NAME="Ubuntu 24.04.1 LTS"
NAME="Ubuntu"
VERSION_ID="24.04"
VERSION="24.04.1 LTS (Noble Numbat)"
ID=ubuntu
HOME_URL="https://www.ubuntu.com/"
`;

const HOSTS = `127.0.0.1 localhost
127.0.1.1 lernarena
`;

/** Eintraege des Grundsystems, die jedes Szenario hat. */
function grundsystem(): Record<string, Eintrag> {
  const e: Record<string, Eintrag> = {
    "/dev/null": { inhalt: "", rechte: 0o666 },
    "/etc/hostname": "lernarena\n",
    "/etc/hosts": HOSTS,
    "/etc/passwd": passwdText(),
    "/etc/group": groupText(),
    "/etc/os-release": OS_RELEASE,
    "/home/azubi/": { rechte: 0o750 },
    "/home/mia/": { rechte: 0o750 },
    "/root/": { rechte: 0o700 },
    "/tmp/": { rechte: 0o1777 },
    "/var/log/": {},
    "/usr/bin/bash": { inhalt: "", rechte: 0o755 },
  };
  // Unter Ubuntu ist /bin ein Verweis auf /usr/bin; Verweise gibt es hier nicht, deshalb zweimal
  e["/bin/bash"] = { inhalt: "", rechte: 0o755 };
  for (const name of BEFEHLE.keys()) {
    e[`/usr/bin/${name}`] = { inhalt: "", rechte: 0o755 };
    e[`/bin/${name}`] = { inhalt: "", rechte: 0o755 };
  }
  return e;
}

/** Baut einen Start-Zustand aus Grundsystem plus eigenen Eintraegen. */
export function szenario(eintraege: Record<string, Eintrag> = {}, opt: SzenarioOptionen = {}): Zustand {
  const zeit = opt.zeit ?? STANDARDZEIT;
  let wurzel = leererOrdner("/", zeit);
  for (const [pfad, eintrag] of Object.entries(grundsystem())) wurzel = legeAn(wurzel, pfad, eintrag, zeit);
  for (const [pfad, eintrag] of Object.entries(eintraege)) wurzel = legeAn(wurzel, pfad, eintrag, zeit);

  // /dev/null als Geraetedatei markieren
  const devnull = knotenBei(wurzel, "/dev/null");
  if (devnull && devnull.art === "datei") wurzel = setze(wurzel, "/dev/null", { ...devnull, geraet: true }, zeit);

  const benutzer = opt.benutzer ?? "azubi";
  const home = benutzer === "root" ? "/root" : `/home/${benutzer}`;
  return {
    wurzel,
    cwd: normalisiere(opt.cwd ?? home),
    vorher: "",
    benutzer,
    verlauf: [],
    letzterCode: 0,
  };
}
