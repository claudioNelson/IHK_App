// Optionen nach GNU-Art zerlegen: -l, -la, --all, -n 5, -n5, "--" beendet
// die Optionen, Optionen duerfen auch nach Argumenten stehen (ls ordner -l).

import type { BefehlErgebnis } from "./typen";

export type OptionSpec = {
  /** Erlaubte Kurzoptionen ohne Wert, z. B. "laRh1" */
  flags: string;
  /** Kurzoptionen mit Wert, z. B. "n" fuer head -n 5 */
  mitWert?: string;
  /** Langformen: "all" -> "a"; Wert "" bedeutet: nur als Langform bekannt */
  lang?: Record<string, string>;
  /** Rueckgabewert bei ungueltiger Option (ls: 2, sonst meist 1) */
  fehlerCode?: number;
};

export type Optionen = {
  flags: Set<string>;
  werte: Map<string, string>;
  /** Langformen ohne Kurzform, z. B. "no-preserve-root" */
  langeFlags: Set<string>;
  rest: string[];
};

export type OptionenErgebnis = ({ ok: true } & Optionen) | { ok: false; fehler: BefehlErgebnis };

function ungueltig(name: string, meldung: string, spec: OptionSpec, hinweis: string): OptionenErgebnis {
  return {
    ok: false,
    fehler: {
      fehler: `${name}: ${meldung}\nTry '${name} --help' for more information.\n`,
      hinweis,
      code: spec.fehlerCode ?? 1,
    },
  };
}

export function zerlegeOptionen(name: string, args: string[], spec: OptionSpec): OptionenErgebnis {
  const flags = new Set<string>();
  const werte = new Map<string, string>();
  const langeFlags = new Set<string>();
  const rest: string[] = [];
  const mitWert = spec.mitWert ?? "";

  for (let i = 0; i < args.length; i++) {
    const a = args[i];
    if (a === "--") {
      rest.push(...args.slice(i + 1));
      break;
    }
    if (a.startsWith("--")) {
      const gleich = a.indexOf("=");
      const lname = gleich < 0 ? a.slice(2) : a.slice(2, gleich);
      const lwert = gleich < 0 ? undefined : a.slice(gleich + 1);
      const kurz = spec.lang?.[lname];
      if (kurz === undefined) {
        return ungueltig(
          name,
          `unrecognized option '${a}'`,
          spec,
          `Hinweis: Die Option „${a}“ kennt ${name} im Übungs-Terminal nicht. Mit man ${name} siehst du die wichtigsten Optionen.`,
        );
      }
      if (kurz === "") langeFlags.add(lname);
      else if (mitWert.includes(kurz)) {
        const wert = lwert ?? args[++i];
        if (wert === undefined) {
          return ungueltig(name, `option '--${lname}' requires an argument`, spec, `Hinweis: Hinter „--${lname}“ fehlt ein Wert.`);
        }
        werte.set(kurz, wert);
      } else flags.add(kurz);
      continue;
    }
    if (a.startsWith("-") && a.length > 1) {
      for (let j = 1; j < a.length; j++) {
        const c = a[j];
        if (mitWert.includes(c)) {
          const wert = j + 1 < a.length ? a.slice(j + 1) : args[++i];
          if (wert === undefined) {
            return ungueltig(name, `option requires an argument -- '${c}'`, spec, `Hinweis: Hinter „-${c}“ fehlt ein Wert, zum Beispiel ${name} -${c} 5.`);
          }
          werte.set(c, wert);
          break;
        }
        if (!spec.flags.includes(c)) {
          return ungueltig(
            name,
            `invalid option -- '${c}'`,
            spec,
            `Hinweis: Die Option „-${c}“ kennt ${name} im Übungs-Terminal nicht. Mit man ${name} siehst du die wichtigsten Optionen.`,
          );
        }
        flags.add(c);
      }
      continue;
    }
    rest.push(a);
  }
  return { ok: true, flags, werte, langeFlags, rest };
}

/** Meldung fuer fehlende Argumente: "mkdir: missing operand". */
export function fehlenderOperand(name: string, hinweis: string): BefehlErgebnis {
  return {
    fehler: `${name}: missing operand\nTry '${name} --help' for more information.\n`,
    hinweis,
    code: 1,
  };
}
