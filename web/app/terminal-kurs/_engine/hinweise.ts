// Englische Fehlertexte (wie GNU/Linux) und die deutschen Hinweise dazu.
// Regeln fuer die deutschen Texte: keine Gedankenstriche, keine Anglizismen,
// deutsche Anfuehrungszeichen.

import type { Grund } from "./dateisystem";

/** Englischer Text wie in strerror(): "No such file or directory" usw. */
export function grundText(grund: Grund): string {
  switch (grund) {
    case "fehlt":
      return "No such file or directory";
    case "keinOrdner":
      return "Not a directory";
    case "verweigert":
      return "Permission denied";
    case "zuLang":
      return "File name too long";
  }
}

/** Deutscher Hinweis passend zum Grund. */
export function grundHinweis(grund: Grund, pfad: string): string {
  switch (grund) {
    case "fehlt":
      return `Hinweis: „${pfad}“ gibt es hier nicht. Mit ls siehst du, was im Ordner liegt, mit pwd, wo du gerade bist.`;
    case "keinOrdner":
      return `Hinweis: In „${pfad}“ wird eine Datei wie ein Ordner behandelt. Ein / am Ende oder in der Mitte passt nur zu Ordnern.`;
    case "verweigert":
      return `Hinweis: Dafür fehlt dir das Recht. Mit ls -l siehst du Besitzer und Rechte.`;
    case "zuLang":
      return "Hinweis: Der Name ist zu lang. Linux erlaubt höchstens 255 Zeichen je Name.";
  }
}
