import type { Metadata } from "next";
import Link from "next/link";
import LsToc, { type Abschnitt } from "../../lernen/_components/LsToc";
import { LsAbschnitt, LsHinweis } from "../../lernen/_components/LsBausteine";
import Terminal from "../_components/Terminal";
import { lektionen } from "../_components/lektionen";

export const metadata: Metadata = {
  title: "Freies Terminal: Linux-Befehle im Browser ausprobieren",
  description:
    "Ein Übungs-Linux im Browser zum freien Ausprobieren: Ordner, Dateien, Rechte, Protokolle mit einem Einbruchsversuch und ein paar versteckte Überraschungen. Kostenlos, ohne Installation.",
  alternates: { canonical: "https://lernarena.app/terminal-kurs/spielwiese" },
};

const abschnitte: Abschnitt[] = [
  { id: "umsehen", titel: "Wo du dich umsehen kannst" },
  { id: "spickzettel", titel: "Spickzettel" },
];

/** Die wichtigsten Befehle mit der Lektion, in der sie erklärt werden. */
const SPICKZETTEL: [befehl: string, wofuer: string, lektion: number][] = [
  ["pwd, ls -la, cd", "Wo bin ich, was liegt hier, Ordner wechseln", 2],
  ["tree", "Ordner als Baum anzeigen", 2],
  ["mkdir, touch", "Ordner und leere Dateien anlegen", 3],
  ["cp -r, mv, rm -r", "Kopieren, verschieben oder umbenennen, löschen", 3],
  ["cat, less", "Dateien anzeigen", 4],
  ["head, tail", "Anfang oder Ende einer Datei", 4],
  ["grep -i -r", "Zeilen mit einem Suchwort finden", 4],
  ["id, ls -l", "Wer bin ich, wer darf was", 5],
  ["chmod, chown", "Rechte und Besitzer ändern", 5],
  ["sudo", "Einen Befehl als root ausführen", 5],
  ["> >> 2>", "Ausgaben und Fehler in Dateien umleiten", 6],
  ["| sort | uniq -c", "Befehle verketten und auswerten", 6],
];

const slug = (nr: number) => lektionen.find((l) => l.nr === nr)?.slug ?? "";

export default function Spielwiese() {
  return (
    <>
      <div className="wrap">
        <div className="page-head">
          <nav className="crumbs" aria-label="Pfad">
            <Link href="/">Lernarena</Link>
            <span aria-hidden="true">/</span>
            <Link href="/kurse">Kurse</Link>
            <span aria-hidden="true">/</span>
            <Link href="/terminal-kurs">Terminal-Kurs</Link>
            <span aria-hidden="true">/</span>
            <span aria-current="page">Freies Terminal</span>
          </nav>
          <h1>Freies Terminal</h1>
          <p className="lead">
            Ein ganzes Übungs-Linux nur für dich: Ordner, Dateien, Benutzer, Rechte und echte
            Protokolle. Probier aus, was du im Kurs gelernt hast, oder geh auf Entdeckungsreise. Ein
            paar Dinge sind versteckt.
          </p>
        </div>
        <Terminal aufgabe="spielwiese" titel="Freies Terminal" hoehe={460} />
      </div>

      <div className="wrap ls-layout">
        <aside className="ls-side" aria-label="Inhalt dieser Seite">
          <LsToc titel="Auf dieser Seite" abschnitte={abschnitte} />
          <p className="ls-side-note">
            Noch neu im Terminal? Fang mit <Link href="/terminal-kurs/lektion-1">Lektion 1</Link> an.
          </p>
        </aside>

        <article className="ls-main ls-article">
          <LsAbschnitt id="umsehen" titel="Wo du dich umsehen kannst">
            <p>Der Rechner heißt <code>lernarena</code> und ist wie ein kleiner Ubuntu-Server eingerichtet:</p>
            <ul>
              <li>
                <code>/home/azubi</code>: dein Home-Ordner mit Notizen, Projekten, Downloads und
                mindestens einer Datei, die sich versteckt.
              </li>
              <li>
                <code>/etc</code>: die Einstellungen, etwa <code>passwd</code>, <code>hosts</code> und
                die Begrüßung in <code>motd</code>.
              </li>
              <li>
                <code>/var/log</code>: die Protokolle. In <code>auth.log</code> versucht gerade jemand
                einzubrechen.
              </li>
              <li>
                <code>/root</code> und <code>/home/mia</code>: gesperrt. Mit <code>sudo</code> kommst du
                in einen davon hinein.
              </li>
            </ul>
            <LsHinweis titel="Hier wird nichts gespeichert">
              <p>
                Alles, was du anlegst oder löschst, gilt nur bis zum Neuladen der Seite. „Zurücksetzen“
                stellt den Anfang sofort wieder her. Selbst <code>rm -rf /</code> richtet hier keinen
                Schaden an.
              </p>
            </LsHinweis>
          </LsAbschnitt>

          <LsAbschnitt id="spickzettel" titel="Spickzettel">
            <p>Die wichtigsten Befehle auf einen Blick, mit der Lektion, in der sie erklärt werden:</p>
            <div className="ls-table-wrap">
              <table className="ls-table">
                <thead>
                  <tr>
                    <th scope="col">Befehl</th>
                    <th scope="col">Wofür</th>
                    <th scope="col">Lektion</th>
                  </tr>
                </thead>
                <tbody>
                  {SPICKZETTEL.map(([befehl, wofuer, nr]) => (
                    <tr key={befehl}>
                      <td>{befehl}</td>
                      <td className="txt">{wofuer}</td>
                      <td>
                        <Link href={`/terminal-kurs/${slug(nr)}`}>{nr}</Link>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
            <p>
              Mehr zu jedem Befehl zeigt dir <code>man BEFEHL</code> direkt im Terminal, alle Befehle
              listet <code>help</code>.
            </p>
          </LsAbschnitt>
        </article>
      </div>
    </>
  );
}
