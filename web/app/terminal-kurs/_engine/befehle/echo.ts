// echo: Text ausgeben. Optionen nur, wenn das Wort genau -n, -e, -E oder eine
// Kombination davon ist (wie das eingebaute echo der Bash).

import type { Befehl } from "../typen";

function maskierungen(text: string): { text: string; stopp: boolean } {
  let aus = "";
  for (let i = 0; i < text.length; i++) {
    const c = text[i];
    if (c !== "\\" || i + 1 >= text.length) {
      aus += c;
      continue;
    }
    const n = text[++i];
    if (n === "n") aus += "\n";
    else if (n === "t") aus += "\t";
    else if (n === "\\") aus += "\\";
    else if (n === "c") return { text: aus, stopp: true };
    else aus += "\\" + n;
  }
  return { text: aus, stopp: false };
}

export const echo: Befehl = {
  name: "echo",
  bereich: "Allgemein",
  hilfe: {
    kurz: "gibt Text aus.",
    aufruf: "echo [OPTION] [TEXT]",
    optionen: [
      ["-n", "keinen Zeilenumbruch am Ende"],
      ["-e", "\\n (neue Zeile) und \\t (Tabulator) auswerten"],
    ],
    beispiele: [
      ["echo Hallo Welt", "gibt „Hallo Welt“ aus"],
      ["echo $HOME", "zeigt deinen Home-Ordner"],
      ['echo "Text" > datei.txt', "schreibt Text in eine Datei"],
    ],
  },
  lauf: ({ args }) => {
    let umbruch = true;
    let auswerten = false;
    let i = 0;
    while (i < args.length && /^-[neE]+$/.test(args[i])) {
      for (const c of args[i].slice(1)) {
        if (c === "n") umbruch = false;
        else if (c === "e") auswerten = true;
        else auswerten = false;
      }
      i++;
    }
    let text = args.slice(i).join(" ");
    if (auswerten) {
      const m = maskierungen(text);
      text = m.text;
      if (m.stopp) umbruch = false;
    }
    return { ausgabe: text + (umbruch ? "\n" : ""), code: 0 };
  },
};
