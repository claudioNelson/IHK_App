// Pfade zerlegen, zusammensetzen und normalisieren (ohne Dateisystem-Zugriff).

/** Zerlegt einen absoluten Pfad in Namen: "/home/azubi" -> ["home", "azubi"]. */
export function teile(pfad: string): string[] {
  return pfad.split("/").filter((t) => t !== "");
}

/** Normalisiert einen absoluten Pfad: "//a/./b/../c/" -> "/a/c". Ueber "/" hinaus geht es nicht. */
export function normalisiere(pfad: string): string {
  const stapel: string[] = [];
  for (const t of teile(pfad)) {
    if (t === ".") continue;
    if (t === "..") stapel.pop();
    else stapel.push(t);
  }
  return "/" + stapel.join("/");
}

/**
 * Macht aus einem (evtl. relativen) Pfad einen absoluten, normalisierten Pfad.
 * Ein leerer Pfad bleibt leer (Linux: "No such file or directory", nicht der aktuelle Ordner).
 */
export function absolut(cwd: string, pfad: string): string {
  if (pfad === "") return "";
  if (pfad.startsWith("/")) return normalisiere(pfad);
  return normalisiere(cwd + "/" + pfad);
}

/**
 * Wie absolut(), behaelt aber einen Schraegstrich am Ende, damit finde() dort
 * einen Ordner verlangt ("notizen.txt/" -> Not a directory).
 */
export function absolutMitEnde(cwd: string, pfad: string): string {
  const a = absolut(cwd, pfad);
  return pfad.endsWith("/") && a !== "/" && a !== "" ? a + "/" : a;
}

/** true, wenn der getippte Pfad mit "/" endet (verlangt einen Ordner). */
export function endetMitSchraegstrich(pfad: string): boolean {
  return pfad.length > 1 && pfad.endsWith("/");
}

/** Letzter Namensteil: "/a/b.txt" -> "b.txt", "/" -> "/". Endschraegstriche zaehlen nicht. */
export function basisname(pfad: string): string {
  const t = teile(pfad);
  return t.length === 0 ? "/" : t[t.length - 1];
}

/** Uebergeordneter Ordner eines absoluten Pfads: "/a/b" -> "/a", "/a" -> "/". */
export function elternpfad(pfad: string): string {
  const t = teile(normalisiere(pfad));
  t.pop();
  return "/" + t.join("/");
}

/** Pfad fuer die Anzeige im Prompt: Home wird zu "~". */
export function kurzpfad(pfad: string, home: string): string {
  if (pfad === home) return "~";
  if (home !== "/" && pfad.startsWith(home + "/")) return "~" + pfad.slice(home.length);
  return pfad;
}

/** true, wenn kind gleich eltern ist oder darin liegt. */
export function liegtIn(kind: string, eltern: string): boolean {
  return kind === eltern || eltern === "/" || kind.startsWith(eltern + "/");
}
