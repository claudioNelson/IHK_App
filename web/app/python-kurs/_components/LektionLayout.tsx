// Gemeinsamer Rahmen für alle Lektionsseiten: Theme, Breadcrumb,
// Überschrift und die Vor/Zurück-Navigation am Seitenende.

import Link from "next/link";
import { kursCss } from "./kursTheme";
import { lektionen } from "./lektionen";

export default function LektionLayout({
  nr,
  children,
}: {
  nr: number;
  children: React.ReactNode;
}) {
  const lektion = lektionen.find((l) => l.nr === nr);
  const prev = lektionen.find((l) => l.nr === nr - 1);
  const next = lektionen.find((l) => l.nr === nr + 1);

  const titelOhneEmoji = (t: string) => t.replace("🎮 ", "");

  return (
    <main className="lp-wrap">
      <style>{kursCss}</style>
      <div className="lp-container">
        <nav className="lp-crumb">
          <Link href="/">Lernarena</Link> ·{" "}
          <Link href="/lernen">Lernen</Link> ·{" "}
          <Link href="/python-kurs">Python-Kurs</Link> · Lektion {nr}
        </nav>

        <h1>
          Lektion {nr}: {lektion ? titelOhneEmoji(lektion.titel) : ""}
        </h1>

        {children}

        <div className="pk-nav">
          {prev ? (
            <Link className="lp-btn lp-btn-ghost" href={`/python-kurs/${prev.slug}`}>
              ← Lektion {prev.nr}
            </Link>
          ) : (
            <Link className="lp-btn lp-btn-ghost" href="/python-kurs">
              ← Zur Übersicht
            </Link>
          )}
          {next && next.status === "live" ? (
            <Link className="lp-btn lp-btn-primary" href={`/python-kurs/${next.slug}`}>
              Weiter: {titelOhneEmoji(next.titel)} →
            </Link>
          ) : next ? (
            <span className="pk-nav-soon">
              Lektion {next.nr} ({titelOhneEmoji(next.titel)}) erscheint bald
            </span>
          ) : (
            <Link className="lp-btn lp-btn-primary" href="/python-kurs">
              Zur Kurs-Übersicht →
            </Link>
          )}
        </div>
      </div>
    </main>
  );
}
