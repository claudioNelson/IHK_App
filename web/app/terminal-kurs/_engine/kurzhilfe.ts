// Deutsche Kurzhilfe eines Befehls (fuer man und --help).

import type { Befehl } from "./typen";

/** Deutsche Kurzhilfe (man und --help). */
export function kurzhilfe(b: Befehl): string {
  const h = b.hilfe;
  let t = `${b.name}: ${h.kurz}\n\nAufruf: ${h.aufruf}\n`;
  if (h.optionen?.length) {
    const breite = Math.max(...h.optionen.map(([o]) => o.length));
    t += "\nWichtige Optionen:\n" + h.optionen.map(([o, text]) => `  ${o.padEnd(breite)}  ${text}`).join("\n") + "\n";
  }
  if (h.beispiele?.length) {
    const breite = Math.max(...h.beispiele.map(([o]) => o.length));
    t += "\nBeispiele:\n" + h.beispiele.map(([o, text]) => `  ${o.padEnd(breite)}  ${text}`).join("\n") + "\n";
  }
  t += "\n(Kurzhilfe des Übungs-Terminals. Auf einem echten Linux zeigt man die vollständige Anleitung auf Englisch.)\n";
  return t;
}
