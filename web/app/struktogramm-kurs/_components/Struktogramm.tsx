// Zeichnet ein Struktogramm (Nassi-Shneiderman) aus dem Datenformat in
// struktogramm-typen.ts als HTML. Server-Komponente, keine Interaktion.
// Styles in struktogramm.css (Praefix sg-).
//
//   <Struktogramm titel="Summe" bloecke={[...]} caption="..." />
//
// Verzweigung: Kopf mit zwei Diagonalen (SVG, wird in der Breite gestreckt),
// darunter zwei Spalten. Schleifen: Kopf- oder Fusszeile, der Rumpf ist
// nach rechts eingerueckt, links bleibt der Schleifenbalken stehen.

import type { CSSProperties, ReactNode } from "react";
import type { Block, Struktogramm as StruktogrammDaten } from "./struktogramm-typen";

function Bloecke({ bloecke }: { bloecke: Block[] }) {
  if (bloecke.length === 0) {
    return (
      <div className="sg-leer" aria-label="leer">
        <span aria-hidden="true">∅</span>
      </div>
    );
  }
  return (
    <>
      {bloecke.map((b, i) => (
        <BlockAnsicht key={i} block={b} />
      ))}
    </>
  );
}

function BlockAnsicht({ block }: { block: Block }) {
  switch (block.art) {
    case "anweisung":
      return <div className="sg-anw">{block.text}</div>;

    case "aufruf":
      return (
        <div className="sg-aufruf" role="group" aria-label={`Aufruf ${block.text}`}>
          <span>{block.text}</span>
        </div>
      );

    case "luecke":
      return (
        <div className="sg-luecke" aria-label={`Lücke ${block.marke}`}>
          <span>({block.marke})</span>
        </div>
      );

    case "verzweigung":
      return (
        <div className="sg-verz" role="group" aria-label={`Verzweigung: ${block.bedingung}`}>
          <div className="sg-verz-kopf">
            <svg viewBox="0 0 100 40" preserveAspectRatio="none" aria-hidden="true" focusable="false">
              <path d="M0 0 L50 40 L100 0" />
            </svg>
            <span className="sg-verz-bed">{block.bedingung}</span>
            <span className="sg-verz-ja">{block.jaText ?? "ja"}</span>
            <span className="sg-verz-nein">{block.neinText ?? "nein"}</span>
          </div>
          <div className="sg-verz-zweige">
            <div className="sg-zweig" role="group" aria-label={`${block.jaText ?? "ja"}-Zweig`}>
              <Bloecke bloecke={block.ja} />
            </div>
            <div className="sg-zweig" role="group" aria-label={`${block.neinText ?? "nein"}-Zweig`}>
              <Bloecke bloecke={block.nein} />
            </div>
          </div>
        </div>
      );

    case "auswahl": {
      const spalten = block.faelle.length + (block.sonst ? 1 : 0);
      // Die Diagonale endet ueber dem Beginn der Sonst-Spalte; ohne sonst in der rechten Ecke
      const knick = block.sonst ? (100 * block.faelle.length) / spalten : 100;
      const pfad = block.sonst ? `M0 0 L${knick} 40 L100 0` : "M0 0 L100 40";
      return (
        <div
          className="sg-auswahl"
          role="group"
          aria-label={`Mehrfachauswahl: ${block.ausdruck}`}
          style={{ ["--sg-spalten" as string]: spalten }}
        >
          <div className="sg-auswahl-kopf">
            <svg viewBox="0 0 100 40" preserveAspectRatio="none" aria-hidden="true" focusable="false">
              <path d={pfad} />
            </svg>
            <span className="sg-auswahl-ausdruck">{block.ausdruck}</span>
            <div className="sg-auswahl-werte">
              {block.faelle.map((f, i) => (
                <span key={i}>{f.wert}</span>
              ))}
              {block.sonst && <span>sonst</span>}
            </div>
          </div>
          <div className="sg-auswahl-faelle">
            {block.faelle.map((f, i) => (
              <div key={i} className="sg-fall" role="group" aria-label={`Fall ${f.wert}`}>
                <Bloecke bloecke={f.bloecke} />
              </div>
            ))}
            {block.sonst && (
              <div className="sg-fall" role="group" aria-label="Fall sonst">
                <Bloecke bloecke={block.sonst} />
              </div>
            )}
          </div>
        </div>
      );
    }

    case "kopfschleife":
      return (
        <div className="sg-schleife sg-kopf" role="group" aria-label={`Schleife solange ${block.bedingung}`}>
          <div className="sg-schleife-zeile">
            <span className="sg-wort">solange</span> {block.bedingung}
          </div>
          <div className="sg-rumpf">
            <Bloecke bloecke={block.rumpf} />
          </div>
        </div>
      );

    case "fussschleife": {
      const wort = block.modus === "solange" ? "solange" : "bis";
      return (
        <div className="sg-schleife sg-fuss" role="group" aria-label={`Schleife, danach ${wort} ${block.bedingung}`}>
          <div className="sg-rumpf">
            <Bloecke bloecke={block.rumpf} />
          </div>
          <div className="sg-schleife-zeile">
            <span className="sg-wort">{wort}</span> {block.bedingung}
          </div>
        </div>
      );
    }

    case "zaehlschleife":
      return (
        <div className="sg-schleife sg-kopf" role="group" aria-label={`Zählschleife ${block.kopf}`}>
          <div className="sg-schleife-zeile">{block.kopf}</div>
          <div className="sg-rumpf">
            <Bloecke bloecke={block.rumpf} />
          </div>
        </div>
      );
  }
}

export default function Struktogramm({
  titel,
  bloecke,
  caption,
  breite,
  klein,
}: StruktogrammDaten & {
  /** Bildunterschrift */
  caption?: ReactNode;
  /** Mindestbreite in px (Standard 460); bei tiefer Verschachtelung wird das Struktogramm breiter und scrollt auf dem Handy */
  breite?: number;
  /** Kompakte Darstellung, z. B. in Tabellen oder nebeneinander */
  klein?: boolean;
}) {
  return (
    <figure className={`sg-fig${klein ? " sg-klein" : ""}`}>
      <div className="sg" style={breite ? ({ ["--sg-breite" as string]: `${breite}px` } as CSSProperties) : undefined}>
        {titel && <div className="sg-titel">{titel}</div>}
        <Bloecke bloecke={bloecke} />
      </div>
      {caption && <figcaption>{caption}</figcaption>}
    </figure>
  );
}

/* ---- Trace-Tabelle: Werte der Variablen je Schritt ---- */

export function TraceTabelle({
  spalten,
  zeilen,
  caption,
}: {
  /** Spaltenueberschriften, z. B. ["Schritt", "i", "summe", "Ausgabe"] */
  spalten: string[];
  /** Zeilen mit denselben Spalten; "" fuer leere Zellen */
  zeilen: (string | number)[][];
  caption?: ReactNode;
}) {
  return (
    <figure className="sg-trace">
      <div className="ls-table-wrap">
        <table className="ls-table sg-trace-tabelle">
          <thead>
            <tr>
              {spalten.map((s) => (
                <th key={s} scope="col">
                  {s}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {zeilen.map((z, i) => (
              <tr key={i}>
                {z.map((wert, j) => (
                  <td key={j}>{wert === "" ? <span className="sg-trace-leer">·</span> : wert}</td>
                ))}
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      {caption && <figcaption>{caption}</figcaption>}
    </figure>
  );
}
