// Aufgaben zu Lektion 3 (Dateien und Ordner). Befehle dieser Lektion:
// mkdir (-p), touch, cp (-r), mv, rm (-r), rmdir und der Platzhalter *.

import { knotenBei } from "../../_engine/dateisystem";
import { szenario } from "../../_engine/szenarien";
import type { Zustand } from "../../_engine/typen";
import { eigenes, fehlt, hatOption, istDatei, istOrdner, type Aufgabe } from "../../_engine/ziele";
import { HOME, vorTagen } from "./_hilfen";

const da = (z: Zustand, pfad: string) => knotenBei(z.wurzel, pfad) !== undefined;

/** Datei existiert und enthaelt den Text (damit ein leeres touch nicht als Kopie zaehlt). */
const mitInhalt = (z: Zustand, pfad: string, text: string) => {
  const k = knotenBei(z.wurzel, pfad);
  return k?.art === "datei" && k.inhalt.includes(text);
};

/** Home-Ordner mit etwas Unordnung: Downloads mit Fotos und temporaeren Dateien, alte Ordner. */
const unordnung = () =>
  szenario({
    "/home/azubi/notizen.txt": { inhalt: "Server web01 neu starten\nBackup prüfen\n", geaendert: vorTagen(6) },
    "/home/azubi/todo.txt": { inhalt: "Drucker im Büro einrichten\nNeuen Kollegen anlegen\n", geaendert: vorTagen(4) },
    "/home/azubi/bericht-entwurf.txt": { inhalt: "Wochenbericht KW 40 (Entwurf)\n", geaendert: vorTagen(1) },
    "/home/azubi/backup/": { ordner: true, geaendert: vorTagen(20) },
    "/home/azubi/projekte/webshop/index.html": { inhalt: "<!doctype html>\n<h1>Shop</h1>\n", geaendert: vorTagen(12) },
    "/home/azubi/projekte/webshop/style.css": { inhalt: "body { font-family: sans-serif; }\n", geaendert: vorTagen(12) },
    "/home/azubi/projekte/webshop/bilder/logo.png": { inhalt: "PNG".padEnd(2400, "."), geaendert: vorTagen(15) },
    "/home/azubi/projekte/": { ordner: true, geaendert: vorTagen(12) },
    "/home/azubi/downloads/rechnung.pdf": { inhalt: "%PDF".padEnd(5300, "."), geaendert: vorTagen(3) },
    "/home/azubi/downloads/foto1.jpg": { inhalt: "JPG".padEnd(81_000, "."), geaendert: vorTagen(9) },
    "/home/azubi/downloads/foto2.jpg": { inhalt: "JPG".padEnd(76_500, "."), geaendert: vorTagen(9) },
    "/home/azubi/downloads/setup.tmp": { inhalt: "x".repeat(300), geaendert: vorTagen(2) },
    "/home/azubi/downloads/cache.tmp": { inhalt: "x".repeat(120), geaendert: vorTagen(2) },
    "/home/azubi/downloads/": { ordner: true, geaendert: vorTagen(2) },
    "/home/azubi/alt/": { ordner: true, geaendert: vorTagen(40) },
    "/home/azubi/papierkorb/kram.txt": { inhalt: "kann weg\n", geaendert: vorTagen(30) },
    "/home/azubi/papierkorb/notizen-alt.txt": { inhalt: "alte Notizen\n", geaendert: vorTagen(30) },
    "/home/azubi/papierkorb/": { ordner: true, geaendert: vorTagen(30) },
  });

const BEGRUESSUNG = `Willkommen im Übungs-Terminal von Lernarena.
Probier: mkdir test, touch test/datei.txt, ls test, rm -r test
`;

const D = `${HOME}/downloads`;

export const lektion3: Record<string, Aufgabe> = {
  "l3-frei": { szenario: unordnung, ziele: [], tipps: [], begruessung: BEGRUESSUNG },

  "l3-anlegen": {
    szenario: unordnung,
    ziele: [
      istOrdner(`${HOME}/rechnungen`, "Lege im Home-Ordner den Ordner rechnungen an"),
      istDatei(`${HOME}/rechnungen/liste.txt`, "Lege darin die leere Datei liste.txt an"),
      eigenes("Lege mit einem Befehl die Ordner archiv/2026/oktober an", (z, v) =>
        da(z, `${HOME}/archiv/2026/oktober`) && v.some((e) => e.name === "mkdir" && e.code === 0 && hatOption(e.args, "p", "parents")),
      ),
    ],
    tipps: [
      "Einen Ordner legst du mit mkdir an: mkdir rechnungen",
      "Eine leere Datei legt touch an. Der Pfad darf einen Ordner enthalten: touch rechnungen/liste.txt",
      "Mehrere Ebenen auf einmal schafft mkdir nur mit der Option -p: mkdir -p archiv/2026/oktober",
    ],
  },

  "l3-kopieren": {
    szenario: unordnung,
    ziele: [
      eigenes("Kopiere notizen.txt in den Ordner backup", (z) => mitInhalt(z, `${HOME}/backup/notizen.txt`, "web01") && da(z, `${HOME}/notizen.txt`)),
      eigenes("Benenne todo.txt in aufgaben.txt um", (z) => mitInhalt(z, `${HOME}/aufgaben.txt`, "Drucker") && !da(z, `${HOME}/todo.txt`)),
      eigenes("Verschiebe bericht-entwurf.txt in den Ordner projekte", (z) => mitInhalt(z, `${HOME}/projekte/bericht-entwurf.txt`, "Wochenbericht") && !da(z, `${HOME}/bericht-entwurf.txt`)),
    ],
    tipps: [
      "Kopieren: cp QUELLE ZIEL, hier cp notizen.txt backup/",
      "Umbenennen ist unter Linux dasselbe wie Verschieben: mv todo.txt aufgaben.txt",
      "Verschieben in einen Ordner: mv bericht-entwurf.txt projekte/",
    ],
  },

  "l3-loeschen": {
    szenario: unordnung,
    ziele: [
      eigenes(
        "Lösche in downloads alle Dateien mit der Endung .tmp, die anderen bleiben",
        (z) => !da(z, `${D}/setup.tmp`) && !da(z, `${D}/cache.tmp`) && ["rechnung.pdf", "foto1.jpg", "foto2.jpg"].every((n) => da(z, `${D}/${n}`)),
      ),
      fehlt(`${HOME}/alt`, "Lösche den leeren Ordner alt"),
      fehlt(`${HOME}/papierkorb`, "Lösche den Ordner papierkorb samt Inhalt"),
    ],
    tipps: [
      "Der Platzhalter * steht für beliebig viele Zeichen: rm downloads/*.tmp",
      "Einen leeren Ordner entfernt rmdir alt.",
      "Ordner mit Inhalt löscht nur rm -r, also rm -r papierkorb. Vorher mit ls papierkorb nachsehen, was drin ist.",
    ],
  },

  "l3-knobel": {
    szenario: unordnung,
    ziele: [
      eigenes(
        "Sichere den ganzen Ordner projekte/webshop als webshop-backup im Home-Ordner",
        (z) => da(z, `${HOME}/webshop-backup/index.html`) && da(z, `${HOME}/webshop-backup/bilder/logo.png`) && da(z, `${HOME}/projekte/webshop/index.html`),
      ),
      eigenes(
        "Verschiebe beide Fotos aus downloads mit einem einzigen mv in den neuen Ordner bilder",
        (z, v) =>
          da(z, `${HOME}/bilder/foto1.jpg`) &&
          da(z, `${HOME}/bilder/foto2.jpg`) &&
          v.some((e) => e.name === "mv" && e.code === 0 && e.args.filter((a) => a.endsWith(".jpg")).length >= 2),
      ),
    ],
    tipps: [
      "Ein Ordner mit Inhalt lässt sich nur mit cp -r kopieren. Gibt es das Ziel noch nicht, bekommt die Kopie diesen Namen. Gibt es den Ordner schon, landet die Kopie darin als Unterordner, dann vorher mit rm -r wegräumen oder Zurücksetzen.",
      "cp -r projekte/webshop webshop-backup",
      "Für die Fotos: erst mkdir bilder, dann mv mit dem Platzhalter *.jpg, zum Beispiel mv downloads/*.jpg bilder/",
    ],
  },
};
