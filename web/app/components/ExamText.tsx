// Texte aus den Pruefungsdaten (Szenario, Aufgabenstellung) darstellen.
// Die Daten sind Klartext mit Zeilenumbruechen. Absaetze werden an
// Leerzeilen getrennt. Bloecke, die nach Code, SQL oder einer Texttabelle
// aussehen, stehen in <pre> mit eigenem seitlichem Scrollen, damit auf
// 360px nichts ueber den Rand laeuft.

const BOX = /[─-╿]/;            // Rahmenzeichen von Texttabellen
const CODE_START = /^\s*(SELECT|FROM|WHERE|INSERT|UPDATE|DELETE|CREATE|ALTER|DROP|JOIN|LEFT JOIN|INNER JOIN|GROUP BY|ORDER BY|HAVING|VALUES|def |class |public |private |protected |function |return |for |while |if |else|import |#include|#!\/|\$ |PS>|>>> )/i;

function isPreformatted(block: string): boolean {
  const lines = block.split("\n");
  if (lines.some((l) => /^( {2,}|\t)\S/.test(l))) return true;
  if (BOX.test(block)) return true;
  if (lines.filter((l) => l.includes("|")).length >= 2) return true;
  if (/^\s*[+][-=+]{3,}/m.test(block)) return true;
  const codeLike = lines.filter((l) => CODE_START.test(l) || /[;{}]\s*$/.test(l)).length;
  return lines.length >= 2 && codeLike >= Math.ceil(lines.length / 2);
}

function splitBlocks(text: string): string[] {
  return text
    .replace(/\r\n?/g, "\n")
    .split(/\n[ \t]*\n/)
    .map((b) => b.replace(/^\n+|\s+$/g, ""))
    .filter((b) => b.trim() !== "");
}

/** Fliesstext in Absaetzen (Szenario, Einleitungen). */
export function TextBlocks({ text, className }: { text: string; className?: string }) {
  return (
    <>
      {splitBlocks(text).map((b, i) => (
        <p key={i} className={className ? `ex-lines ${className}` : "ex-lines"}>
          {b}
        </p>
      ))}
    </>
  );
}

/** Aufgabenstellung: Absaetze und vorformatierte Bloecke gemischt. */
export function QuestionText({ text }: { text: string }) {
  return (
    <>
      {splitBlocks(text).map((b, i) =>
        isPreformatted(b) ? (
          <pre key={i} className="ex-pre" tabIndex={0}>
            {b}
          </pre>
        ) : (
          <p key={i} className="ex-lines">
            {b}
          </p>
        )
      )}
    </>
  );
}
