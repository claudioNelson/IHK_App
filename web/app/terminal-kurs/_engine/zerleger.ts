// Zerlegt eine Eingabezeile wie Bash in eine Kette von Pipelines:
//
//   cd /tmp && ls -l *.txt | sort > liste.txt 2>&1 ; echo "fertig: $?"
//
// Unterstuetzt: Woerter, 'einfache' und "doppelte" Anfuehrungszeichen, \ als
// Maskierung, Variablen ($HOME, ${USER}, $?), ~ am Wortanfang, Platzhalter
// * und ?, Kommentare (#), Verknuepfungen | && || ; und Umleitungen
// > >> < 2> 2>> &> 2>&1 1>&2 >&2.
//
// Variablen, ~ und Platzhalter werden erst beim Ausfuehren ersetzt (siehe
// shell.ts), damit "cd /tmp && echo $PWD" wie in Bash /tmp ausgibt.

/** Baustein eines Worts. quote: wie der Text geschrieben war. */
export type WortTeil =
  | { art: "text"; text: string; quote: "keins" | "einfach" | "doppelt" }
  | { art: "variable"; name: string; quote: "keins" | "doppelt" }
  | { art: "tilde"; benutzer: string };

export type Wort = WortTeil[];

export type Umleitung =
  | { art: ">" | ">>" | "<" | "2>" | "2>>" | "&>" | "&>>"; ziel: Wort }
  | { art: "2>&1" | "1>&2" };

export type EinfacherBefehl = { woerter: Wort[]; umleitungen: Umleitung[] };
export type Pipeline = EinfacherBefehl[];
export type Glied = { pipeline: Pipeline; danach: "&&" | "||" | ";" | null };

export type ZerlegErgebnis = { ok: true; kette: Glied[] } | { ok: false; fehler: string; hinweis: string };

type Token = { typ: "wort"; wort: Wort } | { typ: "op"; op: string };

const OPERATOREN = ["2>&1", "1>&2", "1>>", "&>>", "2>>", ">&2", ">&1", "&&", "||", ">>", "&>", "2>", "1>", ">", "<", "|", ";", "&"];

const NAME_ZEICHEN = /[A-Za-z0-9_]/;

function syntaxfehler(token: string): ZerlegErgebnis {
  return {
    ok: false,
    fehler: `bash: syntax error near unexpected token \`${token}'\n`,
    hinweis:
      token === "newline"
        ? "Hinweis: Nach dem Zeichen am Ende fehlt noch etwas, zum Beispiel ein Dateiname nach > oder ein Befehl nach |."
        : `Hinweis: „${token}“ steht an einer Stelle, an der ein Befehl erwartet wird.`,
  };
}

function variablenFehler(art: number, schlecht: string, befehlsersetzung: boolean): { ok: false; fehler: string; hinweis: string } {
  if (befehlsersetzung) {
    return {
      ok: false,
      fehler: "",
      hinweis: "Hinweis: Befehle in $( ) oder `…` einsetzen kann das Übungs-Terminal noch nicht. Tippe die Befehle einzeln nacheinander.",
    };
  }
  if (art === -1) {
    return { ok: false, fehler: "bash: unexpected EOF while looking for matching `}'\n", hinweis: "Hinweis: Nach ${ fehlt die schließende }." };
  }
  return { ok: false, fehler: `bash: ${schlecht}: bad substitution\n`, hinweis: "Hinweis: Zwischen ${ und } gehört ein Variablenname, zum Beispiel ${HOME}." };
}

/** Zerlegt die Zeile in Woerter und Operatoren. */
function tokenisiere(zeile: string): { ok: true; tokens: Token[] } | { ok: false; fehler: string; hinweis: string } {
  const tokens: Token[] = [];
  let wort: Wort | null = null;
  let i = 0;
  let schlecht = "";
  let befehlsersetzung = false;

  const text = (t: string, quote: "keins" | "einfach" | "doppelt") => {
    if (!wort) wort = [];
    const letzter = wort[wort.length - 1];
    if (letzter && letzter.art === "text" && letzter.quote === quote) letzter.text += t;
    else wort.push({ art: "text", text: t, quote });
  };
  const wortEnde = () => {
    if (wort) tokens.push({ typ: "wort", wort });
    wort = null;
  };
  /** Liest $NAME, ${NAME} oder $? ab Position i (zeigt auf "$"). Liefert neue Position oder -1. */
  const variable = (quote: "keins" | "doppelt"): number => {
    const n = zeile[i + 1];
    if (n !== undefined && "?$#@*-!0123456789".includes(n)) {
      if (!wort) wort = [];
      wort.push({ art: "variable", name: n, quote });
      return i + 2;
    }
    if (n === "{") {
      const ende = zeile.indexOf("}", i + 2);
      if (ende < 0) return -1;
      const name = zeile.slice(i + 2, ende);
      if (!/^([A-Za-z_][A-Za-z0-9_]*|[?$#@*!0-9-])$/.test(name)) {
        schlecht = "${" + name + "}";
        return -2;
      }
      if (!wort) wort = [];
      wort.push({ art: "variable", name, quote });
      return ende + 1;
    }
    if (n === "(") {
      befehlsersetzung = true;
      return -2;
    }
    if (n !== undefined && NAME_ZEICHEN.test(n) && !/[0-9]/.test(n)) {
      let j = i + 1;
      while (j < zeile.length && NAME_ZEICHEN.test(zeile[j])) j++;
      if (!wort) wort = [];
      wort.push({ art: "variable", name: zeile.slice(i + 1, j), quote });
      return j;
    }
    text("$", quote);
    return i + 1;
  };

  while (i < zeile.length) {
    const c = zeile[i];

    if (c === " " || c === "\t") {
      wortEnde();
      i++;
      continue;
    }
    if (c === "#" && wort === null) break; // Kommentar bis Zeilenende

    // Operatoren nur ausserhalb eines Worts, 1>/2> nur als eigenes Wort
    if (wort === null || !/[12]/.test(c)) {
      const op = OPERATOREN.find((o) => zeile.startsWith(o, i) && (wort === null || !/^[12]/.test(o)));
      if (op) {
        wortEnde();
        tokens.push({ typ: "op", op });
        i += op.length;
        continue;
      }
    }

    if (c === "\\") {
      if (i + 1 < zeile.length) text(zeile[i + 1], "einfach");
      i += 2;
      continue;
    }
    if (c === "'") {
      const ende = zeile.indexOf("'", i + 1);
      if (ende < 0) {
        return { ok: false, fehler: "bash: unexpected EOF while looking for matching `''\n", hinweis: "Hinweis: Ein einfaches Anführungszeichen ist nicht geschlossen." };
      }
      text(zeile.slice(i + 1, ende), "einfach");
      if (ende === i + 1 && !wort) wort = [];
      i = ende + 1;
      continue;
    }
    if (c === '"') {
      let j = i + 1;
      if (!wort) wort = [];
      text("", "doppelt");
      while (j < zeile.length && zeile[j] !== '"') {
        if (zeile[j] === "\\" && j + 1 < zeile.length && '"\\$`'.includes(zeile[j + 1])) {
          text(zeile[j + 1], "doppelt");
          j += 2;
        } else if (zeile[j] === "$") {
          i = j;
          const neu = variable("doppelt");
          if (neu < 0) return variablenFehler(neu, schlecht, befehlsersetzung);
          j = neu;
        } else {
          text(zeile[j], "doppelt");
          j++;
        }
      }
      if (j >= zeile.length) {
        return { ok: false, fehler: 'bash: unexpected EOF while looking for matching `"\'\n', hinweis: "Hinweis: Ein doppeltes Anführungszeichen ist nicht geschlossen." };
      }
      i = j + 1;
      continue;
    }
    if (c === "$") {
      const neu = variable("keins");
      if (neu < 0) return variablenFehler(neu, schlecht, befehlsersetzung);
      i = neu;
      continue;
    }
    if (c === "`") return variablenFehler(-2, "", true);
    if (c === "~" && wort === null) {
      let j = i + 1;
      while (j < zeile.length && /[a-z0-9_-]/.test(zeile[j])) j++;
      const naechstes = zeile[j];
      if (naechstes === undefined || naechstes === "/" || naechstes === " " || naechstes === "\t" || OPERATOREN.some((o) => zeile.startsWith(o, j))) {
        wort = [{ art: "tilde", benutzer: zeile.slice(i + 1, j) }];
        i = j;
        continue;
      }
    }
    text(c, "keins");
    i++;
  }
  wortEnde();
  return { ok: true, tokens };
}

/** Zerlegt eine ganze Eingabezeile. Eine leere Zeile ergibt eine leere Kette. */
export function zerlege(zeile: string): ZerlegErgebnis {
  const t = tokenisiere(zeile);
  if (!t.ok) return t;
  const tokens = t.tokens;
  const kette: Glied[] = [];
  let pipeline: Pipeline = [];
  let befehl: EinfacherBefehl = { woerter: [], umleitungen: [] };
  const befehlLeer = () => befehl.woerter.length === 0 && befehl.umleitungen.length === 0;
  // true nach | && ||: dann muss noch ein Befehl folgen
  let offen = false;

  for (let i = 0; i < tokens.length; i++) {
    const tok = tokens[i];
    if (tok.typ === "wort") {
      befehl.woerter.push(tok.wort);
      offen = false;
      continue;
    }
    const op = tok.op;
    if (op === "&") {
      return {
        ok: false,
        fehler: "bash: syntax error near unexpected token `&'\n",
        hinweis: "Hinweis: Befehle im Hintergrund (mit &) gibt es im Übungs-Terminal nicht. Für zwei Befehle nacheinander nimm && oder ;.",
      };
    }
    if (op === "|" || op === "&&" || op === "||" || op === ";") {
      if (befehlLeer()) return syntaxfehler(op);
      pipeline.push(befehl);
      befehl = { woerter: [], umleitungen: [] };
      if (op !== "|") {
        kette.push({ pipeline, danach: op });
        pipeline = [];
      }
      offen = op !== ";";
      continue;
    }
    if (op === ">&1") {
      offen = false;
      continue; // stdout nach stdout: aendert nichts
    }
    if (op === "2>&1" || op === "1>&2" || op === ">&2") {
      befehl.umleitungen.push({ art: op === "2>&1" ? "2>&1" : "1>&2" });
      offen = false;
      continue;
    }
    // Umleitung mit Ziel
    const naechstes = tokens[i + 1];
    if (!naechstes) return syntaxfehler("newline");
    if (naechstes.typ !== "wort") return syntaxfehler(naechstes.op);
    const art = op === "1>" ? ">" : op === "1>>" ? ">>" : (op as ">" | ">>" | "<" | "2>" | "2>>" | "&>" | "&>>");
    befehl.umleitungen.push({ art, ziel: naechstes.wort });
    offen = false;
    i++;
  }

  if (offen) {
    // Zeile endet mit | && oder || (Bash wuerde auf weitere Eingabe warten)
    return syntaxfehler("newline");
  }
  if (!befehlLeer()) {
    pipeline.push(befehl);
    kette.push({ pipeline, danach: null });
  }
  return { ok: true, kette };
}
