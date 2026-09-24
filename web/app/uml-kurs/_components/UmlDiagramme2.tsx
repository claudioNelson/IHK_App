// Verhaltensdiagramme des UML-Kurses (Lektion 6 und 7) als inline SVG:
// Sequenzdiagramm (Lebenslinie, Aktivierung, Nachrichten, Selbstaufruf,
// Fragment), Zustandsdiagramm (Zustand, Start, Ende, Uebergang) und die
// wenigen Aktivitaetselemente, die das Pruefungstraining braucht (Aktion,
// Raute, Balken). Rahmen, Klasse, Kante, Notiz, Akteur und Use-Case kommen
// aus UmlDiagramme.tsx. Farben nur ueber die Klassen aus uml.css bzw. ueber
// Theme-Variablen, dadurch hell und dunkel ohne Extra-Regeln lesbar.

import type { CSSProperties } from "react";
import {
  Abbildung,
  Akteur,
  Kante,
  Klasse,
  klassenHoehe,
  Notiz,
  UseCase,
  type KlasseSpec,
  type Punkt,
} from "./UmlDiagramme";

/* ================================================================== */
/* Baukasten                                                          */
/* ================================================================== */

const GESTRICHELT: CSSProperties = { strokeDasharray: "6 4" };
const ZEILE_LABEL = 14;

function einheit(a: Punkt, b: Punkt): Punkt {
  const dx = b[0] - a[0];
  const dy = b[1] - a[1];
  const l = Math.hypot(dx, dy) || 1;
  return [dx / l, dy / l];
}

/** Pfeilspitze am Punkt ende, aus Richtung von kommend. */
function Spitze({ ende, von, art }: { ende: Punkt; von: Punkt; art: "voll" | "offen" }) {
  const u = einheit(von, ende);
  const n: Punkt = [-u[1], u[0]];
  const q = (f: number, s: number): string =>
    `${ende[0] - u[0] * f + n[0] * s},${ende[1] - u[1] * f + n[1] * s}`;
  if (art === "voll") {
    return <polygon className="uml-raute-voll" points={`${q(0, 0)} ${q(12, 5)} ${q(12, -5)}`} />;
  }
  return <polyline className="uml-linie" points={`${q(11, 6)} ${q(0, 0)} ${q(11, -6)}`} />;
}

/** Mehrzeilige Beschriftung in Monoschrift (Nachrichten, Uebergaenge, Waechter). */
function Label({
  x,
  y,
  zeilen,
  anker = "middle",
}: {
  x: number;
  y: number;
  zeilen: string[];
  anker?: "start" | "middle" | "end";
}) {
  return (
    <>
      {zeilen.map((z, i) => (
        <text key={z} className="uml-member" x={x} y={y + i * ZEILE_LABEL} textAnchor={anker}>
          {z}
        </text>
      ))}
    </>
  );
}

/* ---- Sequenzdiagramm ---------------------------------------------- */

export const LL_KOPF = 36;
const AKT = 6; // halbe Breite eines Aktivierungsbalkens

/**
 * Lebenslinie: Kopf mit "rolle: Klasse" (unterstrichen, wie in vielen
 * Musterloesungen) oder Strichfigur fuer einen Akteur, darunter die
 * gestrichelte Linie bis bis.
 */
export function Lebenslinie({
  x,
  y,
  name,
  bis,
  b = 140,
  akteur = false,
}: {
  x: number;
  y: number;
  name: string;
  bis: number;
  b?: number;
  akteur?: boolean;
}) {
  if (akteur) {
    return (
      <g>
        <line className="uml-strich" x1={x} y1={y + 86} x2={x} y2={bis} />
        <Akteur x={x} y={y} name={name} />
      </g>
    );
  }
  return (
    <g>
      <line className="uml-strich" x1={x} y1={y + LL_KOPF} x2={x} y2={bis} />
      <rect className="uml-box" x={x - b / 2} y={y} width={b} height={LL_KOPF} rx={2} />
      <rect className="uml-rand" x={x - b / 2} y={y} width={b} height={LL_KOPF} rx={2} />
      <text
        className="uml-name"
        x={x}
        y={y + 23}
        textAnchor="middle"
        style={{ textDecoration: "underline" }}
      >
        {name}
      </text>
    </g>
  );
}

/** Aktivierungsbalken auf der Lebenslinie x, versatz fuer verschachtelte Balken. */
export function Aktivierung({
  x,
  von,
  bis,
  versatz = 0,
}: {
  x: number;
  von: number;
  bis: number;
  versatz?: number;
}) {
  return (
    <g>
      <rect className="uml-kopf" x={x - AKT + versatz} y={von} width={AKT * 2} height={bis - von} />
      <rect className="uml-rand" x={x - AKT + versatz} y={von} width={AKT * 2} height={bis - von} />
    </g>
  );
}

export type NachrichtArt = "synchron" | "asynchron" | "antwort";

/**
 * Nachricht von x1 nach x2 auf Hoehe y. synchron: gefuellte Spitze,
 * asynchron: offene Spitze, antwort: gestrichelt mit offener Spitze.
 * Die x-Werte sind die Kanten der Aktivierungsbalken bzw. die Lebenslinie.
 */
export function Nachricht({
  x1,
  x2,
  y,
  text,
  art = "synchron",
}: {
  x1: number;
  x2: number;
  y: number;
  text?: string;
  art?: NachrichtArt;
}) {
  return (
    <g>
      <line
        className="uml-linie"
        x1={x1}
        y1={y}
        x2={x2}
        y2={y}
        style={art === "antwort" ? GESTRICHELT : undefined}
      />
      <Spitze ende={[x2, y]} von={[x1, y]} art={art === "synchron" ? "voll" : "offen"} />
      {text && <Label x={(x1 + x2) / 2} y={y - 7} zeilen={[text]} />}
    </g>
  );
}

/**
 * Selbstaufruf: x ist die rechte Kante des aeusseren Balkens. Die Nachricht
 * laeuft nach rechts, nach unten und zurueck auf einen verschachtelten
 * Balken (Aktivierung mit versatz=AKT, von y+h).
 */
export function Selbstaufruf({
  x,
  y,
  h = 22,
  text,
  b = 34,
}: {
  x: number;
  y: number;
  h?: number;
  text: string;
  b?: number;
}) {
  const ziel: Punkt = [x + AKT, y + h];
  return (
    <g>
      <polyline className="uml-linie" points={`${x},${y} ${x + b},${y} ${x + b},${y + h} ${ziel[0]},${ziel[1]}`} />
      <Spitze ende={ziel} von={[x + b, y + h]} art="voll" />
      <Label x={x + b + 6} y={y + h / 2 + 4} zeilen={[text]} anker="start" />
    </g>
  );
}

/**
 * Kombiniertes Fragment (alt, opt, loop ...): Rahmen, Operator im
 * Fuenfeck links oben, Bereiche durch gestrichelte Linien getrennt,
 * je Bereich ein Waechter in eckigen Klammern.
 */
export function Fragment({
  x,
  y,
  b,
  h,
  operator,
  bereiche,
}: {
  x: number;
  y: number;
  b: number;
  h: number;
  operator: string;
  /** y: Oberkante des Bereichs (beim ersten = y des Rahmens), wx/wy: Position des Waechters */
  bereiche: { y: number; waechter?: string; wx?: number; wy?: number }[];
}) {
  const w = 22 + operator.length * 8;
  const fuenfeck = `M${x} ${y}H${x + w}V${y + 13}L${x + w - 8} ${y + 21}H${x}Z`;
  return (
    <g>
      <rect className="uml-rand" x={x} y={y} width={b} height={h} />
      <path className="uml-kopf" d={fuenfeck} />
      <path className="uml-rand" d={fuenfeck} />
      <text className="uml-name" x={x + 8} y={y + 15.5} style={{ fontSize: 13 }}>
        {operator}
      </text>
      {bereiche.map((r, i) => (
        <g key={r.y}>
          {i > 0 && <line className="uml-strich" x1={x} y1={r.y} x2={x + b} y2={r.y} />}
          {r.waechter && (
            <Label
              x={r.wx ?? (i === 0 ? x + w + 10 : x + 10)}
              y={r.wy ?? (i === 0 ? r.y + 16 : r.y + 18)}
              zeilen={[r.waechter]}
              anker="start"
            />
          )}
        </g>
      ))}
    </g>
  );
}

/* ---- Zustands- und Aktivitaetsdiagramm ---------------------------- */

/** Zustand: abgerundetes Rechteck, optional mit internen Aktivitaeten (entry, do, exit). */
export function Zustand({
  x,
  cy,
  b,
  name,
  intern,
}: {
  x: number;
  cy: number;
  b: number;
  name: string;
  intern?: string[];
}) {
  const h = intern ? 34 + intern.length * 16 : 44;
  const y = cy - h / 2;
  return (
    <g>
      <rect className="uml-usecase" x={x} y={y} width={b} height={h} rx={12} />
      <text className="uml-usecase-text" x={x + b / 2} y={intern ? y + 20 : cy + 4.5} textAnchor="middle">
        {name}
      </text>
      {intern && (
        <>
          <line className="uml-trenner" x1={x} y1={y + 28} x2={x + b} y2={y + 28} />
          <Label x={x + 10} y={y + 44} zeilen={intern} anker="start" />
        </>
      )}
    </g>
  );
}

/** Aktion im Aktivitaetsdiagramm: abgerundetes Rechteck, Mittelpunkt cx/cy. */
export function Aktion({ cx, cy, b, text }: { cx: number; cy: number; b: number; text: string }) {
  return (
    <g>
      <rect className="uml-box" x={cx - b / 2} y={cy - 20} width={b} height={40} rx={10} />
      <rect className="uml-rand" x={cx - b / 2} y={cy - 20} width={b} height={40} rx={10} />
      <text className="uml-usecase-text" x={cx} y={cy + 4.5} textAnchor="middle">
        {text}
      </text>
    </g>
  );
}

/** Startzustand bzw. Startknoten: gefuellter Kreis. */
export function Startknoten({ x, y }: { x: number; y: number }) {
  return <circle className="uml-raute-voll" cx={x} cy={y} r={9} />;
}

/** Endzustand bzw. Endknoten: Kreis mit gefuelltem Kern. */
export function Endknoten({ x, y }: { x: number; y: number }) {
  return (
    <g>
      <circle className="uml-dreieck" cx={x} cy={y} r={11} />
      <circle className="uml-raute-voll" cx={x} cy={y} r={6} />
    </g>
  );
}

/** Verzweigung oder Zusammenfuehrung: leere Raute. */
export function Raute({ cx, cy, r = 18 }: { cx: number; cy: number; r?: number }) {
  return (
    <polygon
      className="uml-dreieck"
      points={`${cx},${cy - r} ${cx + r},${cy} ${cx},${cy + r} ${cx - r},${cy}`}
    />
  );
}

/** Gabelung oder Vereinigung (fork, join): gefuellter Balken. */
export function Balken({ x1, x2, y }: { x1: number; x2: number; y: number }) {
  return <rect className="uml-raute-voll" x={x1} y={y} width={x2 - x1} height={6} rx={1} />;
}

/**
 * Uebergang (Zustandsdiagramm) bzw. Kontrollfluss (Aktivitaetsdiagramm):
 * Linie mit offener Spitze am Ende, Beschriftung frei positioniert.
 */
export function Uebergang({
  punkte,
  text,
  tx,
  ty,
  anker = "middle",
}: {
  punkte: Punkt[];
  text?: string[];
  tx?: number;
  ty?: number;
  anker?: "start" | "middle" | "end";
}) {
  const ende = punkte[punkte.length - 1];
  const davor = punkte[punkte.length - 2];
  return (
    <g>
      <polyline className="uml-linie" points={punkte.map((p) => p.join(",")).join(" ")} />
      <Spitze ende={ende} von={davor} art="offen" />
      {text && tx !== undefined && ty !== undefined && (
        <Label x={tx} y={ty} zeilen={text} anker={anker} />
      )}
    </g>
  );
}

/** Abhaengigkeit mit Stereotyp, etwa include oder extend: gestrichelt, offene Spitze. */
function Abhaengigkeit({
  von,
  nach,
  stereotyp,
  tx,
  ty,
}: {
  von: Punkt;
  nach: Punkt;
  stereotyp: string;
  tx: number;
  ty: number;
}) {
  return (
    <g>
      <line className="uml-linie" x1={von[0]} y1={von[1]} x2={nach[0]} y2={nach[1]} style={GESTRICHELT} />
      <Spitze ende={nach} von={von} art="offen" />
      <text className="uml-assoz-name" x={tx} y={ty}>
        {`«${stereotyp}»`}
      </text>
    </g>
  );
}

/** Nummer im Akzentkreis fuer beschriftete Aufbau-Abbildungen. */
function Marke({ x, y, nr }: { x: number; y: number; nr: number }) {
  return (
    <g>
      <circle className="uml-punkt" cx={x} cy={y} r={9} />
      <text
        x={x}
        y={y + 4}
        textAnchor="middle"
        style={{ fill: "var(--surface)", fontFamily: "var(--uml-sans)", fontSize: 11.5, fontWeight: 700 }}
      >
        {nr}
      </text>
    </g>
  );
}

/* ================================================================== */
/* Lektion 6: Sequenzdiagramm                                         */
/* ================================================================== */

/** Nachrichtenart als kleines Muster fuer die Notationstabelle. */
export function NachrichtMuster({ art, label }: { art: NachrichtArt; label: string }) {
  return (
    <svg className="uml-muster" viewBox="0 0 120 24" role="img" aria-label={label}>
      <Nachricht x1={6} x2={114} y={12} art={art} />
    </svg>
  );
}

/** Aufbau eines Sequenzdiagramms mit nummerierten Erklaerungen. */
export function SequenzAufbau() {
  const a = 110;
  const b = 330;
  const lx = 478;
  const erklaerungen = [
    { titel: "Lebenslinie", text: "rolle: Klasse, darunter gestrichelt" },
    { titel: "Aktivierungsbalken", text: "Objekt arbeitet gerade" },
    { titel: "Synchrone Nachricht", text: "gefüllte Spitze, Sender wartet" },
    { titel: "Antwort", text: "gestrichelt, offene Spitze" },
    { titel: "Zeitachse", text: "Zeit läuft von oben nach unten" },
  ];
  return (
    <Abbildung
      breite={760}
      hoehe={300}
      min={600}
      label="Aufbau eines Sequenzdiagramms: zwei Lebenslinien, Doppelpunkt WebApp und Doppelpunkt Buchungsservice. Die WebApp schickt die synchrone Nachricht istFrei an den Buchungsservice, dessen Aktivierungsbalken beginnt. Der Buchungsservice antwortet gestrichelt mit frei. Die Zeit läuft von oben nach unten."
    >
      <line className="uml-fuehrung" x1={30} y1={84} x2={30} y2={270} />
      <polyline className="uml-fuehrung" style={{ fill: "none" }} points="24,262 30,272 36,262" />
      <Lebenslinie x={a} y={20} name=":WebApp" b={130} bis={280} />
      <Lebenslinie x={b} y={20} name=":Buchungsservice" b={160} bis={280} />
      <Aktivierung x={a} von={80} bis={230} />
      <Aktivierung x={b} von={115} bis={185} />
      <Nachricht x1={a + AKT} x2={b - AKT} y={115} text="istFrei(radNr, zeit)" />
      <Nachricht x1={b - AKT} x2={a + AKT} y={185} text="frei" art="antwort" />
      <Marke x={b + 80 + 16} y={38} nr={1} />
      <Marke x={b + AKT + 16} y={150} nr={2} />
      <Marke x={(a + b) / 2} y={134} nr={3} />
      <Marke x={(a + b) / 2} y={204} nr={4} />
      <Marke x={30} y={68} nr={5} />
      {erklaerungen.map((e, i) => (
        <g key={e.titel}>
          <Marke x={lx} y={40 + i * 52} nr={i + 1} />
          <text className="uml-hinweis-titel" x={lx + 18} y={44 + i * 52}>
            {e.titel}
          </text>
          <text className="uml-hinweis" x={lx + 18} y={62 + i * 52}>
            {e.text}
          </text>
        </g>
      ))}
    </Abbildung>
  );
}

/** Lastenrad buchen: Kunde, WebApp, Buchungsservice, Zahlungsanbieter mit alt-Fragment. */
export function LastenradSequenz({ caption }: { caption?: string }) {
  const k = 80;
  const w = 280;
  const bs = 480;
  const z = 680;
  const bis = 575;
  return (
    <Abbildung
      breite={790}
      hoehe={590}
      min={640}
      caption={caption}
      label="Sequenzdiagramm Lastenrad buchen. Der Kunde schickt buche mit Radnummer und Zeitraum an die WebApp. Die WebApp fragt synchron istFrei beim Buchungsservice an, der sich selbst mit ladeBelegung aufruft und frei zurückgibt. Im alt-Fragment, Fall frei: Die WebApp ruft bucheRad beim Buchungsservice auf, dieser ruft reserviere mit dem Betrag beim Zahlungsanbieter auf und erhält eine zahlungsId. Der Buchungsservice antwortet mit der buchungsNr, die WebApp zeigt dem Kunden die Bestätigung. Später meldet der Zahlungsanbieter asynchron bestaetigt mit der zahlungsId. Fall else: Die WebApp antwortet dem Kunden mit dem Hinweis belegt."
    >
      <Lebenslinie x={k} y={14} name="Kunde" akteur bis={bis} />
      <Lebenslinie x={w} y={58} name=":WebApp" b={130} bis={bis} />
      <Lebenslinie x={bs} y={58} name=":Buchungsservice" b={160} bis={bis} />
      <Lebenslinie x={z} y={58} name=":Zahlungsanbieter" b={170} bis={bis} />

      <Fragment
        x={34}
        y={262}
        b={722}
        h={285}
        operator="alt"
        bereiche={[
          { y: 262, waechter: "[frei]", wx: k + 30, wy: 292 },
          { y: 480, waechter: "[else]", wx: k + 30, wy: 500 },
        ]}
      />

      <Aktivierung x={w} von={130} bis={525} />
      <Aktivierung x={bs} von={165} bis={242} />
      <Aktivierung x={bs} von={210} bis={230} versatz={AKT} />
      <Aktivierung x={bs} von={305} bis={378} />
      <Aktivierung x={z} von={330} bis={352} />
      <Aktivierung x={z} von={432} bis={452} />
      <Aktivierung x={bs} von={445} bis={466} />

      <Nachricht x1={k} x2={w - AKT} y={130} text="buche(radNr, zeitraum)" />
      <Nachricht x1={w + AKT} x2={bs - AKT} y={165} text="istFrei(radNr, zeitraum)" />
      <Selbstaufruf x={bs + AKT} y={188} text="ladeBelegung(radNr)" />
      <Nachricht x1={bs - AKT} x2={w + AKT} y={242} text="frei" art="antwort" />

      <Nachricht x1={w + AKT} x2={bs - AKT} y={305} text="bucheRad(kundeNr, radNr)" />
      <Nachricht x1={bs + AKT} x2={z - AKT} y={330} text="reserviere(betrag)" />
      <Nachricht x1={z - AKT} x2={bs + AKT} y={352} text="zahlungsId" art="antwort" />
      <Nachricht x1={bs - AKT} x2={w + AKT} y={378} text="buchungsNr" art="antwort" />
      <Nachricht x1={w - AKT} x2={k} y={408} text="Bestätigung" art="antwort" />
      <Nachricht x1={z - AKT} x2={bs + AKT} y={445} text="bestaetigt(zahlungsId)" art="asynchron" />

      <Nachricht x1={w - AKT} x2={k} y={525} text="Hinweis: belegt" art="antwort" />
    </Abbildung>
  );
}

/** Musterloesung Zeichenaufgabe 6.1: Anmeldung mit Passwortpruefung. */
export function AnmeldungLoesung() {
  const n = 80;
  const l = 280;
  const bv = 480;
  const bis = 455;
  return (
    <Abbildung
      breite={740}
      hoehe={470}
      min={600}
      label="Musterlösung Anmeldung: Der Nutzer schickt anmelden mit Name und Passwort an die LoginSeite. Die LoginSeite ruft synchron pruefe mit Name und Passwort bei der Benutzerverwaltung auf, die sich selbst mit berechneHash aufruft und ok zurückgibt. Im alt-Fragment, Fall ok: Die LoginSeite ruft sich selbst mit starteSitzung auf und antwortet dem Nutzer mit der Startseite. Fall else: Die LoginSeite antwortet mit einer Fehlermeldung."
    >
      <Lebenslinie x={n} y={14} name="Nutzer" akteur bis={bis} />
      <Lebenslinie x={l} y={58} name=":LoginSeite" b={140} bis={bis} />
      <Lebenslinie x={bv} y={58} name=":Benutzerverwaltung" b={180} bis={bis} />

      <Fragment
        x={34}
        y={262}
        b={600}
        h={170}
        operator="alt"
        bereiche={[
          { y: 262, waechter: "[ok]", wx: l + 14, wy: 290 },
          { y: 372, waechter: "[else]", wx: l + 14, wy: 392 },
        ]}
      />

      <Aktivierung x={l} von={130} bis={412} />
      <Aktivierung x={bv} von={165} bis={240} />
      <Aktivierung x={bv} von={208} bis={228} versatz={AKT} />
      <Aktivierung x={l} von={322} bis={340} versatz={AKT} />

      <Nachricht x1={n} x2={l - AKT} y={130} text="anmelden(name, passwort)" />
      <Nachricht x1={l + AKT} x2={bv - AKT} y={165} text="pruefe(name, passwort)" />
      <Selbstaufruf x={bv + AKT} y={186} text="berechneHash(passwort)" />
      <Nachricht x1={bv - AKT} x2={l + AKT} y={240} text="ok" art="antwort" />

      <Selbstaufruf x={l + AKT} y={300} text="starteSitzung()" />
      <Nachricht x1={l - AKT} x2={n} y={354} text="Startseite" art="antwort" />
      <Nachricht x1={l - AKT} x2={n} y={412} text="Fehlermeldung" art="antwort" />
    </Abbildung>
  );
}

/* ================================================================== */
/* Lektion 6: Zustandsdiagramm                                        */
/* ================================================================== */

/** Bestellstatus: Neu, Bezahlt, Versandt, Zugestellt, Storniert. */
export function BestellungZustaende({ caption }: { caption?: string }) {
  const r1 = 100;
  const r2 = 250;
  return (
    <Abbildung
      breite={800}
      hoehe={360}
      min={620}
      caption={caption}
      label="Zustandsdiagramm Bestellung. Vom Startzustand geht es in Neu. Von Neu nach Bezahlt mit dem Ereignis zahlungEingang, der Bedingung vollständig und der Aktion rechnungSenden. Von Bezahlt nach Versandt mit versenden und der Aktion sendungsNrMailen. Von Versandt nach Zugestellt mit zustellungGemeldet, danach Endzustand. Aus Neu und aus Bezahlt führt stornieren nach Storniert, aus Bezahlt mit der Aktion betragErstatten. Von Storniert geht es in den Endzustand."
    >
      <Startknoten x={24} y={r1} />
      <Uebergang punkte={[[33, r1], [60, r1]]} />
      <Uebergang
        punkte={[[190, r1], [350, r1]]}
        text={["zahlungEingang", "[vollständig]", "/ rechnungSenden"]}
        tx={270}
        ty={r1 - 38}
      />
      <Uebergang
        punkte={[[480, r1], [640, r1]]}
        text={["versenden", "/ sendungsNrMailen"]}
        tx={560}
        ty={r1 - 24}
      />
      <Uebergang punkte={[[705, r1 + 22], [705, r2 - 22]]} text={["zustellungGemeldet"]} tx={697} ty={r1 + 70} anker="end" />
      <Uebergang punkte={[[125, r1 + 22], [125, r2], [200, r2]]} text={["stornieren"]} tx={117} ty={r1 + 88} anker="end" />
      <Uebergang
        punkte={[[415, r1 + 22], [415, r2], [330, r2]]}
        text={["stornieren", "/ betragErstatten"]}
        tx={423}
        ty={r1 + 86}
        anker="start"
      />
      <Uebergang punkte={[[705, r2 + 22], [705, 318]]} />
      <Uebergang punkte={[[265, r2 + 22], [265, 318]]} />

      <Zustand x={60} cy={r1} b={130} name="Neu" />
      <Zustand x={350} cy={r1} b={130} name="Bezahlt" />
      <Zustand x={640} cy={r1} b={130} name="Versandt" />
      <Zustand x={640} cy={r2} b={130} name="Zugestellt" />
      <Zustand x={200} cy={r2} b={130} name="Storniert" />
      <Endknoten x={705} y={330} />
      <Endknoten x={265} y={330} />
    </Abbildung>
  );
}

/** Ampel: Rot, Rot-Gelb, Gruen, Gelb mit Zeitereignissen, ohne Endzustand. */
export function AmpelZustaende({ caption }: { caption?: string }) {
  const r1 = 70;
  const r2 = 220;
  return (
    <Abbildung
      breite={560}
      hoehe={270}
      min={480}
      caption={caption}
      label="Zustandsdiagramm Ampel. Vom Startzustand in Rot. Nach 30 Sekunden nach Rot-Gelb, nach 2 Sekunden nach Grün, nach 20 Sekunden nach Gelb und nach 3 Sekunden wieder nach Rot. Es gibt keinen Endzustand."
    >
      <Startknoten x={40} y={r1} />
      <Uebergang punkte={[[49, r1], [90, r1]]} />
      <Uebergang punkte={[[220, r1], [360, r1]]} text={["after(30 s)"]} tx={290} ty={r1 - 8} />
      <Uebergang punkte={[[425, r1 + 22], [425, r2 - 22]]} text={["after(2 s)"]} tx={433} ty={(r1 + r2) / 2 + 4} anker="start" />
      <Uebergang punkte={[[360, r2], [220, r2]]} text={["after(20 s)"]} tx={290} ty={r2 + 20} />
      <Uebergang punkte={[[155, r2 - 22], [155, r1 + 22]]} text={["after(3 s)"]} tx={147} ty={(r1 + r2) / 2 + 4} anker="end" />
      <Zustand x={90} cy={r1} b={130} name="Rot" />
      <Zustand x={360} cy={r1} b={130} name="Rot-Gelb" />
      <Zustand x={360} cy={r2} b={130} name="Grün" />
      <Zustand x={90} cy={r2} b={130} name="Gelb" />
    </Abbildung>
  );
}

/** Musterloesung Zeichenaufgabe 6.2: Stoerungsticket. */
export function TicketLoesung() {
  const r1 = 90;
  const r2 = 260;
  return (
    <Abbildung
      breite={830}
      hoehe={360}
      min={640}
      label="Musterlösung Störungsticket. Vom Startzustand in Offen. Von Offen nach In Bearbeitung mit zuweisen und der Aktion technikerMailen. Von In Bearbeitung nach Gelöst mit loesungEintragen, zurück mit problemBesteht. Von In Bearbeitung nach Wartet auf Kunde mit rueckfrageStellen, zurück mit kundeAntwortet. Von Wartet auf Kunde nach Geschlossen mit after 14 Tage. Von Gelöst nach Geschlossen mit kundeBestaetigt oder after 7 Tage. Von Geschlossen in den Endzustand."
    >
      <Startknoten x={24} y={r1} />
      <Uebergang punkte={[[33, r1], [60, r1]]} />
      <Uebergang
        punkte={[[190, r1], [350, r1]]}
        text={["zuweisen", "/ technikerMailen"]}
        tx={270}
        ty={r1 - 24}
      />
      <Uebergang punkte={[[510, r1 - 10], [670, r1 - 10]]} text={["loesungEintragen"]} tx={590} ty={r1 - 18} />
      <Uebergang punkte={[[670, r1 + 10], [510, r1 + 10]]} text={["problemBesteht"]} tx={590} ty={r1 + 28} />
      <Uebergang punkte={[[400, r1 + 22], [400, r2 - 22]]} text={["rueckfrageStellen"]} tx={392} ty={(r1 + r2) / 2 + 4} anker="end" />
      <Uebergang punkte={[[460, r2 - 22], [460, r1 + 22]]} text={["kundeAntwortet"]} tx={468} ty={(r1 + r2) / 2 + 4} anker="start" />
      <Uebergang punkte={[[510, r2], [670, r2]]} text={["after(14 Tage)"]} tx={590} ty={r2 - 8} />
      <Uebergang
        punkte={[[735, r1 + 22], [735, r2 - 22]]}
        text={["kundeBestaetigt,", "after(7 Tage)"]}
        tx={727}
        ty={(r1 + r2) / 2 - 4}
        anker="end"
      />
      <Uebergang punkte={[[735, r2 + 22], [735, 318]]} />

      <Zustand x={60} cy={r1} b={130} name="Offen" />
      <Zustand x={350} cy={r1} b={160} name="In Bearbeitung" />
      <Zustand x={670} cy={r1} b={130} name="Gelöst" />
      <Zustand x={350} cy={r2} b={160} name="Wartet auf Kunde" />
      <Zustand x={670} cy={r2} b={130} name="Geschlossen" />
      <Endknoten x={735} y={330} />
    </Abbildung>
  );
}

/* ================================================================== */
/* Lektion 7: Pruefungstraining                                       */
/* ================================================================== */

/** Aufgabe 1a: Use-Case-Diagramm Terminverwaltung der Fahrradwerkstatt. */
export function WerkstattUseCase() {
  const links = 260;
  const rechts = 480;
  const kunde: Punkt = [88, 150];
  const mech: Punkt = [652, 150];
  return (
    <Abbildung
      breite={740}
      hoehe={310}
      min={600}
      label="Musterlösung Use-Case-Diagramm Werkstatt-Terminverwaltung. Der Akteur Kunde ist mit Termin buchen und Termin absagen verbunden. Ersatzrad reservieren erweitert Termin buchen per extend. Der Akteur Mechaniker ist mit Auftrag abschließen verbunden, das per include Rechnung erstellen einbindet."
    >
      <rect className="uml-system" x={150} y={16} width={440} height={282} rx={4} />
      <text className="uml-system-name" x={162} y={36}>
        Werkstatt-Terminverwaltung
      </text>
      <line className="uml-linie" x1={kunde[0]} y1={kunde[1]} x2={links - 92} y2={85} />
      <line className="uml-linie" x1={kunde[0]} y1={kunde[1]} x2={links - 90} y2={242} />
      <line className="uml-linie" x1={mech[0]} y1={mech[1]} x2={rechts + 92} y2={130} />
      <Abhaengigkeit von={[links, 150]} nach={[links, 110]} stereotyp="extend" tx={links + 8} ty={134} />
      <Abhaengigkeit von={[rechts, 155]} nach={[rechts, 195]} stereotyp="include" tx={rechts + 8} ty={179} />
      <UseCase cx={links} cy={85} text="Termin buchen" />
      <UseCase cx={links} cy={175} text="Ersatzrad reservieren" />
      <UseCase cx={links} cy={250} text="Termin absagen" />
      <UseCase cx={rechts} cy={130} text="Auftrag abschließen" />
      <UseCase cx={rechts} cy={220} text="Rechnung erstellen" />
      <Akteur x={70} y={122} name="Kunde" />
      <Akteur x={670} y={122} name="Mechaniker" />
    </Abbildung>
  );
}

/** Aufgabe 1b: Klassendiagramm Werkstatt (Kunde, Fahrrad, Termin, Mechaniker). */
export function WerkstattKlassen() {
  const bk = 260;
  const xL = 20;
  const xR = 420;
  const kunde: Omit<KlasseSpec, "x" | "y" | "b"> = {
    name: "Kunde",
    attribute: ["- kundenNr: int", "- name: String", "- telefon: String"],
    methoden: [],
  };
  const fahrrad: Omit<KlasseSpec, "x" | "y" | "b"> = {
    name: "Fahrrad",
    attribute: ["- rahmenNr: String", "- marke: String", "- typ: String"],
    methoden: [],
  };
  const termin: Omit<KlasseSpec, "x" | "y" | "b"> = {
    name: "Termin",
    attribute: ["- beginn: DateTime", "- dauerMin: int", "- status: String"],
    methoden: ["+ absagen(): void", "+ verschieben(neu: DateTime): void"],
  };
  const mechaniker: Omit<KlasseSpec, "x" | "y" | "b"> = {
    name: "Mechaniker",
    attribute: ["- personalNr: int", "- name: String"],
    methoden: ["+ istFrei(am: DateTime): boolean"],
  };
  const oben = 20;
  const hOben = Math.max(klassenHoehe(kunde), klassenHoehe(fahrrad));
  const unten = oben + hOben + 90;
  const hoehe = unten + Math.max(klassenHoehe(termin), klassenHoehe(mechaniker)) + 20;
  const yOben = oben + Math.min(klassenHoehe(kunde), klassenHoehe(fahrrad)) / 2;
  const yUnten = unten + Math.min(klassenHoehe(termin), klassenHoehe(mechaniker)) / 2;
  const xMitteR = xR + bk / 2;
  return (
    <Abbildung
      breite={700}
      hoehe={hoehe}
      label="Musterlösung Klassendiagramm Werkstatt. Ein Kunde besitzt mindestens ein Fahrrad, jedes Fahrrad gehört genau einem Kunden. Für ein Fahrrad gibt es 0 bis beliebig viele Termine, jeder Termin gilt für genau ein Fahrrad. Ein Mechaniker führt 0 bis beliebig viele Termine aus, einem Termin ist höchstens ein Mechaniker zugeordnet."
    >
      <Kante punkte={[[xL + bk, yOben], [xR, yOben]]} von="1" nach="1..*" name="besitzt" />
      <Kante punkte={[[xMitteR, oben + klassenHoehe(fahrrad)], [xMitteR, unten]]} von="1" nach="0..*" />
      <Kante punkte={[[xL + bk, yUnten], [xR, yUnten]]} von="0..1" nach="0..*" name="führt aus" />
      <Klasse {...kunde} x={xL} y={oben} b={bk} />
      <Klasse {...fahrrad} x={xR} y={oben} b={bk} />
      <Klasse {...termin} x={xR} y={unten} b={bk} />
      <Klasse {...mechaniker} x={xL} y={unten} b={bk} />
    </Abbildung>
  );
}

/** Aufgabe 2a: Carsharing mit abstrakter Oberklasse Fahrzeug. */
export function CarsharingKlassen() {
  const bk = 290;
  const xL = 20;
  const xR = 410;
  const kunde: Omit<KlasseSpec, "x" | "y" | "b"> = {
    name: "Kunde",
    attribute: ["- kundenNr: int", "- name: String"],
    methoden: [],
  };
  const fahrt: Omit<KlasseSpec, "x" | "y" | "b"> = {
    name: "Fahrt",
    attribute: ["- start: DateTime", "- ende: DateTime", "- km: int"],
    methoden: ["+ berechneKosten(): double"],
  };
  const fahrzeug: Omit<KlasseSpec, "x" | "y" | "b"> = {
    name: "Fahrzeug {abstract}",
    attribute: ["- kennzeichen: String", "- modell: String", "# preisProMinute: double"],
    methoden: ["+ berechnePreis(minuten: int): double"],
  };
  const eauto: Omit<KlasseSpec, "x" | "y" | "b"> = {
    name: "EAuto",
    attribute: ["- akkustand: int", "- reichweiteKm: int"],
    methoden: ["+ mussLaden(): boolean"],
  };
  const transporter: Omit<KlasseSpec, "x" | "y" | "b"> = {
    name: "Transporter",
    attribute: ["- ladevolumen: double"],
    methoden: ["+ berechnePreis(minuten: int): double"],
  };
  const y1 = 20;
  const hFahrt = klassenHoehe(fahrt);
  const y2 = y1 + hFahrt + 80;
  const hFz = klassenHoehe(fahrzeug);
  const y3 = y2 + hFz + 90;
  const hoehe = y3 + Math.max(klassenHoehe(eauto), klassenHoehe(transporter)) + 20;
  const yKF = y1 + Math.min(klassenHoehe(kunde), hFahrt) / 2;
  const xMR = xR + bk / 2;
  const xML = xL + bk / 2;
  const ySammel = y2 + hFz + 45;
  const notizY = y2 + 16;
  return (
    <Abbildung
      breite={720}
      hoehe={hoehe}
      label="Musterlösung Klassendiagramm Carsharing. Ein Kunde hat 0 bis beliebig viele Fahrten, jede Fahrt gehört zu genau einem Kunden. Jede Fahrt kennt genau ein Fahrzeug, gerichtete Assoziation von Fahrt zu Fahrzeug. Fahrzeug ist abstrakt mit kennzeichen, modell, dem geschützten Attribut preisProMinute und der Methode berechnePreis. EAuto und Transporter erben von Fahrzeug, Transporter überschreibt berechnePreis."
    >
      <Kante punkte={[[xL + bk, yKF], [xR, yKF]]} von="1" nach="0..*" />
      <Kante punkte={[[xMR, y1 + hFahrt], [xMR, y2]]} art="gerichtet" von="0..*" nach="1" />
      <Kante punkte={[[xMR, y3], [xMR, y2 + hFz]]} art="vererbung" />
      <Kante punkte={[[xML, y3], [xML, ySammel], [xMR, ySammel], [xMR, y2 + hFz]]} art="vererbung" />
      <Notiz
        x={xL}
        y={notizY}
        b={bk - 20}
        zeilen={["Abstrakt: Es gibt nur E-Autos", "und Transporter. Von Hand:", "Name kursiv oder {abstract}."]}
        anker={{ von: [xL + bk - 20, notizY + 34], nach: [xR, notizY + 34] }}
      />
      <Klasse {...kunde} x={xL} y={y1} b={bk} />
      <Klasse {...fahrt} x={xR} y={y1} b={bk} />
      <Klasse {...fahrzeug} x={xR} y={y2} b={bk} />
      <Klasse {...eauto} x={xL} y={y3} b={bk} />
      <Klasse {...transporter} x={xR} y={y3} b={bk} />
    </Abbildung>
  );
}

/** Aufgabe 3a: Aktivitaetsdiagramm Onboarding mit Verzweigung und Parallelitaet. */
export function OnboardingAktivitaet() {
  return (
    <Abbildung
      breite={720}
      hoehe={640}
      min={600}
      label="Musterlösung Aktivitätsdiagramm Onboarding. Nach dem Start wird das Onboarding-Ticket geprüft. Danach teilt eine Gabelung in zwei parallele Stränge. Links: Verzweigung, bei Notebook auf Lager wird das Notebook reserviert, sonst wird es bestellt und die Lieferung abgewartet, danach führt eine Raute beide Wege zusammen. Rechts nacheinander: Benutzerkonto anlegen, Postfach einrichten, Berechtigungen vergeben. Eine Vereinigung wartet auf beide Stränge. Danach Notebook einrichten, Übergabe mit Protokoll und Ende."
    >
      <Startknoten x={360} y={28} />
      <Uebergang punkte={[[360, 37], [360, 60]]} />
      <Uebergang punkte={[[360, 100], [360, 128]]} />
      {/* linker Strang: Hardware */}
      <Uebergang punkte={[[210, 134], [210, 160]]} />
      <Uebergang punkte={[[192, 178], [110, 178], [110, 230]]} text={["[auf Lager]"]} tx={150} ty={170} />
      <Uebergang punkte={[[228, 178], [310, 178], [310, 230]]} text={["[nicht auf Lager]"]} tx={234} ty={170} anker="start" />
      <Uebergang punkte={[[310, 270], [310, 300]]} />
      <Uebergang punkte={[[110, 270], [110, 380], [192, 380]]} />
      <Uebergang punkte={[[310, 340], [310, 380], [228, 380]]} />
      <Uebergang punkte={[[210, 398], [210, 430]]} />
      {/* rechter Strang: Konten */}
      <Uebergang punkte={[[560, 134], [560, 160]]} />
      <Uebergang punkte={[[560, 200], [560, 230]]} />
      <Uebergang punkte={[[560, 270], [560, 300]]} />
      <Uebergang punkte={[[560, 340], [560, 430]]} />
      {/* nach der Vereinigung */}
      <Uebergang punkte={[[360, 436], [360, 465]]} />
      <Uebergang punkte={[[360, 505], [360, 535]]} />
      <Uebergang punkte={[[360, 575], [360, 601]]} />

      <Aktion cx={360} cy={80} b={230} text="Onboarding-Ticket prüfen" />
      <Balken x1={130} x2={590} y={128} />
      <Raute cx={210} cy={178} />
      <Aktion cx={110} cy={250} b={170} text="Notebook reservieren" />
      <Aktion cx={310} cy={250} b={170} text="Notebook bestellen" />
      <Aktion cx={310} cy={320} b={170} text="Lieferung abwarten" />
      <Raute cx={210} cy={380} />
      <Aktion cx={560} cy={180} b={200} text="Benutzerkonto anlegen" />
      <Aktion cx={560} cy={250} b={200} text="Postfach einrichten" />
      <Aktion cx={560} cy={320} b={200} text="Berechtigungen vergeben" />
      <Balken x1={130} x2={590} y={430} />
      <Aktion cx={360} cy={485} b={210} text="Notebook einrichten" />
      <Aktion cx={360} cy={555} b={230} text="Übergabe mit Protokoll" />
      <Endknoten x={360} y={612} />
    </Abbildung>
  );
}
