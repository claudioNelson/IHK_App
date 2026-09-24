// UML-Diagramme des UML-Kurses als inline SVG (Server-Komponenten, keine
// Bilder, keine Libs). Farben kommen ausschliesslich ueber die Klassen aus
// app/uml-kurs/uml.css (var(--text), var(--surface), var(--accent) ...),
// dadurch passen die Diagramme automatisch zum hellen und dunklen Theme.
//
// Aufbau: ein kleiner Baukasten (Klasse, Kante, Notiz, Figur) und darauf die
// konkreten Diagramme der Lektionen. Die viewBox skaliert mit, max-width ist
// die natuerliche Breite; unter 640px behaelt jedes Diagramm eine
// Mindestbreite und scrollt innerhalb der Abbildung (nicht die Seite).

import type { CSSProperties, ReactNode } from "react";

/* ================================================================== */
/* Baukasten                                                          */
/* ================================================================== */

const KOPF = 30; // Hoehe des Namensfachs
const ZEILE = 18; // Zeilenabstand in Attribut- und Methodenfach

export type Punkt = [number, number];

export type KlasseSpec = {
  name: string;
  x: number;
  y: number;
  b: number;
  /** undefined: Fach wird nicht gezeichnet, []: leeres Fach */
  attribute?: string[];
  methoden?: string[];
};

function fachHoehe(n: number): number {
  return n === 0 ? 12 : 10 + n * ZEILE;
}

export function klassenHoehe(k: Omit<KlasseSpec, "x" | "y" | "b">): number {
  let h = KOPF;
  if (k.attribute) h += fachHoehe(k.attribute.length);
  if (k.methoden) h += fachHoehe(k.methoden.length);
  return h;
}

export function Klasse({ name, x, y, b, attribute, methoden }: KlasseSpec) {
  const h = klassenHoehe({ name, attribute, methoden });
  const faecher: { top: number; zeilen: string[] }[] = [];
  let top = y + KOPF;
  for (const zeilen of [attribute, methoden]) {
    if (!zeilen) continue;
    faecher.push({ top, zeilen });
    top += fachHoehe(zeilen.length);
  }
  return (
    <g>
      <rect className="uml-box" x={x} y={y} width={b} height={h} rx={2} />
      <rect className="uml-kopf" x={x} y={y} width={b} height={KOPF} rx={2} />
      <text className="uml-name" x={x + b / 2} y={y + 20} textAnchor="middle">
        {name}
      </text>
      {faecher.map((f) => (
        <g key={f.top}>
          <line className="uml-trenner" x1={x} y1={f.top} x2={x + b} y2={f.top} />
          {f.zeilen.map((z, i) => (
            <text key={z} className="uml-member" x={x + 10} y={f.top + 18 + i * ZEILE}>
              {z}
            </text>
          ))}
        </g>
      ))}
      <rect className="uml-rand" x={x} y={y} width={b} height={h} rx={2} />
    </g>
  );
}

export type KantenArt = "assoziation" | "gerichtet" | "abhaengigkeit" | "aggregation" | "komposition" | "vererbung";

type KanteSpec = {
  /** Achsenparallele Punkte, Start zuerst. Rauten sitzen am Start (Ganzes),
      Pfeil und Dreieck am Ende. */
  punkte: Punkt[];
  art?: KantenArt;
  /** Multiplizitaet am Start bzw. am Ende */
  von?: string;
  nach?: string;
  rolleVon?: string;
  rolleNach?: string;
  name?: string;
};

function einheit(a: Punkt, b: Punkt): Punkt {
  const dx = b[0] - a[0];
  const dy = b[1] - a[1];
  const l = Math.hypot(dx, dy) || 1;
  return [dx / l, dy / l];
}

/** Beschriftung an einem Kantenende: Multiplizitaet oben/rechts, Rolle unten/links. */
function EndLabels({
  ende,
  nachbar,
  mult,
  rolle,
  abstand,
}: {
  ende: Punkt;
  nachbar: Punkt;
  mult?: string;
  rolle?: string;
  abstand: number;
}) {
  const [dx, dy] = einheit(ende, nachbar);
  const waagerecht = Math.abs(dx) > Math.abs(dy);
  if (waagerecht) {
    const x = ende[0] + dx * abstand;
    const anker = dx > 0 ? "start" : "end";
    return (
      <>
        {mult && (
          <text className="uml-mult" x={x} y={ende[1] - 7} textAnchor={anker}>
            {mult}
          </text>
        )}
        {rolle && (
          <text className="uml-rolle" x={x} y={ende[1] + 17} textAnchor={anker}>
            {rolle}
          </text>
        )}
      </>
    );
  }
  const y = ende[1] + dy * abstand + (dy > 0 ? 10 : -2);
  return (
    <>
      {mult && (
        <text className="uml-mult" x={ende[0] + 8} y={y} textAnchor="start">
          {mult}
        </text>
      )}
      {rolle && (
        <text className="uml-rolle" x={ende[0] - 8} y={y} textAnchor="end">
          {rolle}
        </text>
      )}
    </>
  );
}

export function Kante({ punkte, art = "assoziation", von, nach, rolleVon, rolleNach, name }: KanteSpec) {
  const start = punkte[0];
  const ende = punkte[punkte.length - 1];
  const d = einheit(start, punkte[1]); // vom Start in die Linie hinein
  const u = einheit(punkte[punkte.length - 2], ende); // Richtung ins Ende
  const nd: Punkt = [-d[1], d[0]];
  const nu: Punkt = [-u[1], u[0]];

  let startSymbol: ReactNode = null;
  if (art === "aggregation" || art === "komposition") {
    const p = (f: number, s: number): string =>
      `${start[0] + d[0] * f + nd[0] * s},${start[1] + d[1] * f + nd[1] * s}`;
    startSymbol = (
      <polygon
        className={art === "komposition" ? "uml-raute-voll" : "uml-raute-leer"}
        points={`${p(0, 0)} ${p(10, 6)} ${p(20, 0)} ${p(10, -6)}`}
      />
    );
  }

  let endSymbol: ReactNode = null;
  const q = (f: number, s: number): string =>
    `${ende[0] - u[0] * f + nu[0] * s},${ende[1] - u[1] * f + nu[1] * s}`;
  if (art === "gerichtet" || art === "abhaengigkeit") {
    endSymbol = <polyline className="uml-linie" points={`${q(12, 6)} ${q(0, 0)} ${q(12, -6)}`} />;
  } else if (art === "vererbung") {
    endSymbol = <polygon className="uml-dreieck" points={`${q(0, 0)} ${q(15, 8)} ${q(15, -8)}`} />;
  }

  // Name an der Mitte des mittleren Segments
  let nameLabel: ReactNode = null;
  if (name) {
    const i = Math.floor((punkte.length - 1) / 2);
    const a = punkte[i];
    const b = punkte[i + 1];
    const mx = (a[0] + b[0]) / 2;
    const my = (a[1] + b[1]) / 2;
    const waagerecht = a[1] === b[1];
    nameLabel = (
      <text
        className="uml-assoz-name"
        x={waagerecht ? mx : mx + 8}
        y={waagerecht ? my - 7 : my + 4}
        textAnchor={waagerecht ? "middle" : "start"}
      >
        {name}
      </text>
    );
  }

  return (
    <g>
      <polyline
        className="uml-linie"
        points={punkte.map((p) => p.join(",")).join(" ")}
        style={art === "abhaengigkeit" ? { strokeDasharray: "6 4" } : undefined}
      />
      {startSymbol}
      {endSymbol}
      <EndLabels
        ende={start}
        nachbar={punkte[1]}
        mult={von}
        rolle={rolleVon}
        abstand={startSymbol ? 26 : 8}
      />
      <EndLabels
        ende={ende}
        nachbar={punkte[punkte.length - 2]}
        mult={nach}
        rolle={rolleNach}
        abstand={endSymbol ? 20 : 8}
      />
      {nameLabel}
    </g>
  );
}

/** UML-Notiz (Rechteck mit Eselsohr), optional mit gestrichelter Verbindung. */
export function Notiz({
  x,
  y,
  b,
  zeilen,
  anker,
}: {
  x: number;
  y: number;
  b: number;
  zeilen: string[];
  /** Punkt, zu dem die gestrichelte Linie fuehrt */
  anker?: { von: Punkt; nach: Punkt };
}) {
  const h = 16 + zeilen.length * 17;
  const e = 12;
  return (
    <g>
      {anker && (
        <line
          className="uml-strich"
          x1={anker.von[0]}
          y1={anker.von[1]}
          x2={anker.nach[0]}
          y2={anker.nach[1]}
        />
      )}
      <path
        className="uml-notiz"
        d={`M${x} ${y}H${x + b - e}L${x + b} ${y + e}V${y + h}H${x}Z M${x + b - e} ${y}V${y + e}H${x + b}`}
      />
      {zeilen.map((z, i) => (
        <text key={z} className="uml-notiz-text" x={x + 10} y={y + 22 + i * 17}>
          {z}
        </text>
      ))}
    </g>
  );
}

/** Rahmen: <figure> mit skalierbarem SVG und Bildunterschrift. */
export function Abbildung({
  breite,
  hoehe,
  min = 520,
  label,
  caption,
  className,
  children,
}: {
  breite: number;
  hoehe: number;
  /** Mindestbreite in px unter 640px Viewport, darunter scrollt die Abbildung */
  min?: number;
  label: string;
  caption?: ReactNode;
  className?: string;
  children: ReactNode;
}) {
  const stil = { maxWidth: `${breite}px`, "--uml-min": `${min}px` } as CSSProperties;
  return (
    <figure className={className ? `uml-fig ${className}` : "uml-fig"}>
      <div className="uml-scroll">
        <svg viewBox={`0 0 ${breite} ${hoehe}`} role="img" aria-label={label} style={stil}>
          {children}
        </svg>
      </div>
      {caption && <figcaption>{caption}</figcaption>}
    </figure>
  );
}

/* ================================================================== */
/* L-Anordnung: A oben links, B oben rechts, C unter B, D unter A      */
/* ================================================================== */

const B_STD = 260;
const LUECKE = 140;
const RAND = 20;
const ZEILENABSTAND = 90;

type Inhalt = Omit<KlasseSpec, "x" | "y" | "b">;

function lAnordnung(
  a: Inhalt,
  b: Inhalt,
  c: Inhalt,
  d?: Inhalt,
  masse: { breite?: number; luecke?: number; rand?: number; abstand?: number } = {},
) {
  const bk = masse.breite ?? B_STD;
  const luecke = masse.luecke ?? LUECKE;
  const rand = masse.rand ?? RAND;
  const abstand = masse.abstand ?? ZEILENABSTAND;
  const xL = rand;
  const xR = rand + bk + luecke;
  const hA = klassenHoehe(a);
  const hB = klassenHoehe(b);
  const hC = klassenHoehe(c);
  const hD = d ? klassenHoehe(d) : 0;
  const oben = rand;
  const unten = oben + Math.max(hA, hB) + abstand;
  const breite = xR + bk + rand;
  const hoehe = unten + Math.max(hC, hD) + rand;

  const yAB = oben + Math.min(hA, hB) / 2;
  const yDC = unten + (d ? Math.min(hC, hD) / 2 : hC / 2);
  const xBC = xR + bk / 2;

  return {
    breite,
    hoehe,
    klassen: {
      a: { ...a, x: xL, y: oben, b: bk },
      b: { ...b, x: xR, y: oben, b: bk },
      c: { ...c, x: xR, y: unten, b: bk },
      d: d ? { ...d, x: xL, y: unten, b: bk } : undefined,
    },
    /** A rechts nach B links */
    ab: [
      [xL + bk, yAB],
      [xR, yAB],
    ] as Punkt[],
    /** B unten nach C oben */
    bc: [
      [xBC, oben + hB],
      [xBC, unten],
    ] as Punkt[],
    /** D rechts nach C links */
    dc: [
      [xL + bk, yDC],
      [xR, yDC],
    ] as Punkt[],
  };
}

/* ================================================================== */
/* Lastenrad-Beispiel (Uebersicht und Lektion 3)                      */
/* ================================================================== */

const KUNDE: Inhalt = {
  name: "Kunde",
  attribute: ["- kundenNr: int", "- name: String", "- email: String"],
  methoden: ["+ aendereEmail(neu: String): void"],
};
const BUCHUNG: Inhalt = {
  name: "Buchung",
  attribute: ["- beginn: DateTime", "- ende: DateTime", "- status: String"],
  methoden: ["+ berechnePreis(): double", "+ stornieren(): void"],
};
const LASTENRAD: Inhalt = {
  name: "Lastenrad",
  attribute: ["- radNr: int", "- modell: String", "- preisProStunde: double"],
  methoden: ["+ istVerfuegbar(): boolean"],
};
const STATION: Inhalt = {
  name: "Station",
  attribute: ["- bezeichnung: String", "- adresse: String"],
  methoden: [],
};

/**
 * Buchungsplattform fuer Lastenraeder.
 * "klassen": nur die vier Klassennamen (Schritt 1),
 * "attribute": Klassen mit Attributen und Methoden, noch ohne Beziehungen (Schritt 2),
 * "komplett": mit Assoziationen, Multiplizitaeten, Rolle und Navigierbarkeit (Schritt 3).
 */
export function LastenradDiagramm({
  stufe = "komplett",
  caption,
}: {
  stufe?: "klassen" | "attribute" | "komplett";
  caption?: ReactNode;
}) {
  const nurName = (k: Inhalt): Inhalt => ({ name: k.name });
  const [a, b, c, d] =
    stufe === "klassen"
      ? [KUNDE, BUCHUNG, LASTENRAD, STATION].map(nurName)
      : [KUNDE, BUCHUNG, LASTENRAD, STATION];
  const l = lAnordnung(a, b, c, d, stufe === "klassen" ? { abstand: 70 } : {});
  const label =
    stufe === "klassen"
      ? "Klassendiagramm, Schritt 1: die Klassen Kunde, Buchung, Lastenrad und Station ohne Details."
      : stufe === "attribute"
        ? "Klassendiagramm, Schritt 2: Kunde, Buchung, Lastenrad und Station mit Attributen, Datentypen und Methoden, noch ohne Beziehungen."
        : "Klassendiagramm der Lastenrad-Plattform: Ein Kunde legt 0 bis beliebig viele Buchungen an. Jede Buchung gilt für genau ein Lastenrad (Rolle rad, navigierbar von Buchung zu Lastenrad), ein Lastenrad kann 0 bis beliebig oft gebucht werden. Jede Station hat mindestens ein Lastenrad, jedes Lastenrad gehört zu genau einer Station.";
  return (
    <Abbildung breite={l.breite} hoehe={l.hoehe} label={label} caption={caption}>
      {stufe === "komplett" && (
        <>
          <Kante punkte={l.ab} von="1" nach="0..*" name="legt an" />
          <Kante punkte={l.bc} art="gerichtet" von="0..*" nach="1" rolleNach="rad" />
          <Kante punkte={l.dc} von="1" nach="1..*" />
        </>
      )}
      <Klasse {...l.klassen.a} />
      <Klasse {...l.klassen.b} />
      <Klasse {...l.klassen.c} />
      {l.klassen.d && <Klasse {...l.klassen.d} />}
    </Abbildung>
  );
}

/** Kompakte Variante fuer den Kopf der Uebersicht: drei Klassen plus Lese-Notiz. */
export function HeroKlassendiagramm() {
  const l = lAnordnung(
    { name: "Kunde", attribute: ["- kundenNr: int", "- name: String"], methoden: ["+ aendereEmail(neu: String): void"] },
    { name: "Buchung", attribute: ["- beginn: DateTime", "- ende: DateTime"], methoden: ["+ stornieren(): void"] },
    { name: "Lastenrad", attribute: ["- radNr: int", "- modell: String"], methoden: ["+ istVerfuegbar(): boolean"] },
    undefined,
    { breite: 200, luecke: 110, rand: 12, abstand: 84 },
  );
  const [s, e] = l.ab;
  const mitte: Punkt = [(s[0] + e[0]) / 2, s[1]];
  const notizY = l.klassen.c.y + 6;
  return (
    <Abbildung
      className="uml-hero"
      breite={l.breite}
      hoehe={l.hoehe}
      min={0}
      label="Beispiel-Klassendiagramm: Ein Kunde legt 0 bis beliebig viele Buchungen an, jede Buchung gilt für genau ein Lastenrad. Eine Notiz erklärt, wie man die Multiplizitäten liest."
      caption="Klassendiagramm: Buchungsplattform für Lastenräder"
    >
      <Kante punkte={l.ab} von="1" nach="0..*" />
      <Kante punkte={l.bc} art="gerichtet" von="0..*" nach="1" rolleNach="rad" />
      <Notiz
        x={l.klassen.a.x}
        y={notizY}
        b={l.klassen.a.b}
        zeilen={["So liest du es: Ein Kunde", "legt 0..* Buchungen an,", "jede Buchung hat 1 Kunden."]}
        anker={{ von: [l.klassen.a.x + l.klassen.a.b - 40, notizY], nach: [mitte[0], mitte[1] + 4] }}
      />
      <Klasse {...l.klassen.a} />
      <Klasse {...l.klassen.b} />
      <Klasse {...l.klassen.c} />
    </Abbildung>
  );
}

/* ================================================================== */
/* Aufbau einer Klasse (Lektion 3)                                    */
/* ================================================================== */

export function KlassenAufbau() {
  const k: KlasseSpec = {
    name: "Lastenrad",
    x: 20,
    y: 20,
    b: 300,
    attribute: ["- radNr: int", "- modell: String", "- preisProStunde: double"],
    methoden: ["+ istVerfuegbar(): boolean", "+ berechnePreis(stunden: int): double"],
  };
  const h = klassenHoehe(k);
  const attrTop = k.y + KOPF;
  const methTop = attrTop + fachHoehe(3);
  const xr = k.x + k.b;
  const lx = xr + 36;
  const hinweise: { y: number; titel: string; text: string }[] = [
    { y: k.y + KOPF / 2, titel: "Klassenname", text: "Substantiv, Singular, groß" },
    { y: attrTop + fachHoehe(3) / 2, titel: "Attribute", text: "Sichtbarkeit Name: Typ" },
    { y: methTop + fachHoehe(2) / 2, titel: "Methoden", text: "Sichtbarkeit Name(Parameter): Rückgabetyp" },
  ];
  return (
    <Abbildung
      breite={690}
      hoehe={h + 40}
      min={560}
      label="Aufbau einer Klasse am Beispiel Lastenrad: oben das Namensfach, darunter das Attributfach mit radNr, modell und preisProStunde, unten das Methodenfach mit istVerfuegbar und berechnePreis."
    >
      <Klasse {...k} />
      {hinweise.map((hw) => (
        <g key={hw.titel}>
          <line className="uml-fuehrung" x1={xr + 6} y1={hw.y} x2={lx - 6} y2={hw.y} />
          <circle className="uml-punkt" cx={xr + 6} cy={hw.y} r={2.5} />
          <text className="uml-hinweis-titel" x={lx} y={hw.y - 3}>
            {hw.titel}
          </text>
          <text className="uml-hinweis" x={lx} y={hw.y + 14}>
            {hw.text}
          </text>
        </g>
      ))}
    </Abbildung>
  );
}

/* ================================================================== */
/* Loesungen der Zeichenaufgaben (Lektion 3)                          */
/* ================================================================== */

export function BibliothekLoesung() {
  const l = lAnordnung(
    {
      name: "Leser",
      attribute: ["- leserNr: int", "- name: String", "- geburtsdatum: Date"],
      methoden: [],
    },
    {
      name: "Ausleihe",
      attribute: ["- ausleihdatum: Date", "- rueckgabedatum: Date"],
      methoden: ["+ verlaengern(tage: int): void"],
    },
    {
      name: "Medium",
      attribute: ["- medienNr: int", "- titel: String", "- erscheinungsjahr: int"],
      methoden: [],
    },
  );
  return (
    <Abbildung
      breite={l.breite}
      hoehe={l.hoehe}
      label="Musterlösung Bibliothek: Ein Leser hat 0 bis beliebig viele Ausleihen, jede Ausleihe gehört zu genau einem Leser. Jede Ausleihe betrifft genau ein Medium, ein Medium kann 0 bis beliebig oft ausgeliehen werden."
    >
      <Kante punkte={l.ab} von="1" nach="0..*" name="tätigt" />
      <Kante punkte={l.bc} von="0..*" nach="1" name="betrifft" />
      <Klasse {...l.klassen.a} />
      <Klasse {...l.klassen.b} />
      <Klasse {...l.klassen.c} />
    </Abbildung>
  );
}

export function TierarztLoesung() {
  const l = lAnordnung(
    {
      name: "Tierhalter",
      attribute: ["- kundenNr: int", "- name: String", "- telefon: String"],
      methoden: [],
    },
    {
      name: "Tier",
      attribute: ["- chipNr: String", "- name: String", "- tierart: String", "- geburtsdatum: Date"],
      methoden: ["+ berechneAlter(): int"],
    },
    {
      name: "Termin",
      attribute: ["- beginn: DateTime", "- dauerMin: int", "- grund: String"],
      methoden: ["+ absagen(): void"],
    },
  );
  return (
    <Abbildung
      breite={l.breite}
      hoehe={l.hoehe}
      label="Musterlösung Tierarztpraxis: Ein Tierhalter (Rolle besitzer) hat mindestens ein Tier, jedes Tier gehört genau einem Tierhalter. Für ein Tier gibt es 0 bis beliebig viele Termine, jeder Termin gilt für genau ein Tier."
    >
      <Kante punkte={l.ab} von="1" nach="1..*" rolleVon="besitzer" />
      <Kante punkte={l.bc} von="1" nach="0..*" />
      <Klasse {...l.klassen.a} />
      <Klasse {...l.klassen.b} />
      <Klasse {...l.klassen.c} />
    </Abbildung>
  );
}

/* ================================================================== */
/* Linienarten fuer die Notationstabelle (Lektion 3)                  */
/* ================================================================== */

export function LinienMuster({ art, label }: { art: KantenArt; label: string }) {
  return (
    <svg className="uml-muster" viewBox="0 0 120 24" role="img" aria-label={label}>
      <rect className="uml-muster-box" x={0.75} y={4} width={10} height={16} />
      <rect className="uml-muster-box" x={109.25} y={4} width={10} height={16} />
      <Kante punkte={[[11, 12], [109, 12]]} art={art} />
    </svg>
  );
}

/* ================================================================== */
/* Use-Case-Mini (Lektion 1)                                          */
/* ================================================================== */

export function Akteur({ x, y, name }: { x: number; y: number; name: string }) {
  return (
    <g>
      <circle className="uml-figur" cx={x} cy={y} r={9} />
      <path className="uml-figur" d={`M${x} ${y + 9}V${y + 38}M${x - 16} ${y + 20}H${x + 16}M${x} ${y + 38}L${x - 13} ${y + 58}M${x} ${y + 38}L${x + 13} ${y + 58}`} />
      <text className="uml-akteur" x={x} y={y + 78} textAnchor="middle">
        {name}
      </text>
    </g>
  );
}

export function UseCase({ cx, cy, text }: { cx: number; cy: number; text: string }) {
  return (
    <g>
      <ellipse className="uml-usecase" cx={cx} cy={cy} rx={92} ry={25} />
      <text className="uml-usecase-text" x={cx} y={cy + 4.5} textAnchor="middle">
        {text}
      </text>
    </g>
  );
}

export function UseCaseMini({ caption }: { caption?: ReactNode }) {
  const faelle = [
    { cy: 72, text: "Lastenrad buchen" },
    { cy: 142, text: "Buchung stornieren" },
    { cy: 212, text: "Rad warten" },
  ];
  const ux = 300;
  return (
    <Abbildung
      breite={600}
      hoehe={270}
      min={500}
      label="Use-Case-Diagramm Lastenrad-Verleih: Der Akteur Kunde ist mit den Anwendungsfällen Lastenrad buchen und Buchung stornieren verbunden, der Akteur Mitarbeiter mit Rad warten. Die Anwendungsfälle liegen in der Systemgrenze Lastenrad-Verleih."
      caption={caption}
    >
      <rect className="uml-system" x={160} y={16} width={280} height={236} rx={4} />
      <text className="uml-system-name" x={172} y={36}>
        Lastenrad-Verleih
      </text>
      <line className="uml-linie" x1={78} y1={112} x2={ux - 92} y2={faelle[0].cy + 4} />
      <line className="uml-linie" x1={78} y1={112} x2={ux - 92} y2={faelle[1].cy} />
      <line className="uml-linie" x1={522} y1={172} x2={ux + 92} y2={faelle[2].cy - 2} />
      {faelle.map((f) => (
        <UseCase key={f.text} cx={ux} cy={f.cy} text={f.text} />
      ))}
      <Akteur x={60} y={84} name="Kunde" />
      <Akteur x={540} y={144} name="Mitarbeiter" />
    </Abbildung>
  );
}

/* ================================================================== */
/* Lektion 2: Use-Case-Diagramm                                       */
/* ================================================================== */

// Eigene Bausteine mit variabler Ellipsenbreite. Beziehungen werden von
// Mittelpunkt zu Mittelpunkt gedacht und am Ellipsenrand abgeschnitten.

const L2_RY = 24;
const L2_STRICH: CSSProperties = { strokeDasharray: "6 4" };

type L2Fall = { cx: number; cy: number; rx: number; text: string };

function L2Ellipse({ f }: { f: L2Fall }) {
  return (
    <g>
      <ellipse className="uml-usecase" cx={f.cx} cy={f.cy} rx={f.rx} ry={L2_RY} />
      <text className="uml-usecase-text" x={f.cx} y={f.cy + 4.5} textAnchor="middle">
        {f.text}
      </text>
    </g>
  );
}

/** Punkt auf dem Ellipsenrand in Richtung ziel */
function l2Rand(f: L2Fall, ziel: Punkt): Punkt {
  const dx = ziel[0] - f.cx;
  const dy = ziel[1] - f.cy;
  const t = 1 / Math.sqrt((dx / f.rx) ** 2 + (dy / L2_RY) ** 2);
  return [f.cx + dx * t, f.cy + dy * t];
}

/** offene Pfeilspitze am Punkt ende, Richtung von start nach ende */
function l2Spitze(start: Punkt, ende: Punkt, laenge = 12, breite = 6): string {
  const [ux, uy] = einheit(start, ende);
  const nx = -uy;
  const ny = ux;
  const p = (f: number, s: number) => `${ende[0] - ux * f + nx * s},${ende[1] - uy * f + ny * s}`;
  return `${p(laenge, breite)} ${p(0, 0)} ${p(laenge, -breite)}`;
}

/** Assoziation Akteur zu Anwendungsfall (Anker am Akteur, Rand der Ellipse) */
function L2Linie({ von, f }: { von: Punkt; f: L2Fall }) {
  const b = l2Rand(f, von);
  return <line className="uml-linie" x1={von[0]} y1={von[1]} x2={b[0]} y2={b[1]} />;
}

/** include oder extend: gestrichelt, offene Spitze am Ziel, Stereotyp als Text */
function L2Abhaengigkeit({
  von,
  nach,
  stereotyp,
  label,
  anker = "middle",
}: {
  von: L2Fall;
  nach: L2Fall;
  stereotyp: "include" | "extend";
  label: Punkt;
  anker?: "start" | "middle" | "end";
}) {
  const a = l2Rand(von, [nach.cx, nach.cy]);
  const b = l2Rand(nach, [von.cx, von.cy]);
  return (
    <g>
      <line className="uml-linie" x1={a[0]} y1={a[1]} x2={b[0]} y2={b[1]} style={L2_STRICH} />
      <polyline className="uml-linie" points={l2Spitze(a, b)} />
      <text className="uml-assoz-name" x={label[0]} y={label[1]} textAnchor={anker}>
        {`«${stereotyp}»`}
      </text>
    </g>
  );
}

/** Systemgrenze mit Namen oben links */
function L2System({ x, y, b, h, name }: { x: number; y: number; b: number; h: number; name: string }) {
  return (
    <>
      <rect className="uml-system" x={x} y={y} width={b} height={h} rx={4} />
      <text className="uml-system-name" x={x + 12} y={y + 20}>
        {name}
      </text>
    </>
  );
}

/** Anker fuer Linien am Akteur: rechts (+1) oder links (-1) auf Hoehe der Arme */
function l2Anker(x: number, y: number, seite: 1 | -1): Punkt {
  return [x + seite * 18, y + 22];
}

const L2_BUCHEN: L2Fall = { cx: 270, cy: 90, rx: 82, text: "Lastenrad buchen" };
const L2_BEZAHLEN: L2Fall = { cx: 505, cy: 90, rx: 60, text: "Bezahlen" };
const L2_ZUBEHOER: L2Fall = { cx: 270, cy: 210, rx: 90, text: "Zubehör hinzubuchen" };
const L2_STORNO: L2Fall = { cx: 270, cy: 320, rx: 88, text: "Buchung stornieren" };
const L2_WARTEN: L2Fall = { cx: 505, cy: 296, rx: 64, text: "Rad warten" };

/**
 * Use-Case-Diagramm der Lastenrad-Buchung (Lektion 2).
 * "akteure": Systemgrenze und Akteure (Schritt 1),
 * "faelle": plus Anwendungsfaelle mit Assoziationen (Schritt 2),
 * "komplett": plus include, extend und Zahlungsanbieter (Schritt 3).
 */
export function L2LastenradUseCase({
  stufe = "komplett",
  caption,
}: {
  stufe?: "akteure" | "faelle" | "komplett";
  caption?: ReactNode;
}) {
  const kunde = l2Anker(70, 130, 1);
  const zahlung = l2Anker(720, 56, -1);
  const mitarbeiter = l2Anker(720, 262, -1);
  const label =
    stufe === "akteure"
      ? "Use-Case-Diagramm, Schritt 1: die Systemgrenze Lastenrad-Verleih, links der Akteur Kunde, rechts die Akteure Zahlungsanbieter und Mitarbeiter, noch ohne Anwendungsfälle."
      : stufe === "faelle"
        ? "Use-Case-Diagramm, Schritt 2: Der Kunde ist mit Lastenrad buchen und Buchung stornieren verbunden, der Mitarbeiter mit Rad warten."
        : "Use-Case-Diagramm Lastenrad-Verleih: Der Kunde ist mit Lastenrad buchen und Buchung stornieren verbunden. Lastenrad buchen bindet Bezahlen per include ein, Bezahlen ist mit dem Akteur Zahlungsanbieter verbunden. Zubehör hinzubuchen erweitert Lastenrad buchen per extend unter der Bedingung, dass der Kunde Zubehör wünscht. Der Mitarbeiter ist mit Rad warten verbunden.";
  return (
    <Abbildung breite={800} hoehe={400} min={600} label={label} caption={caption}>
      <L2System x={150} y={16} b={470} h={368} name="Lastenrad-Verleih" />
      {stufe !== "akteure" && (
        <>
          <L2Linie von={kunde} f={L2_BUCHEN} />
          <L2Linie von={kunde} f={L2_STORNO} />
          <L2Linie von={mitarbeiter} f={L2_WARTEN} />
          <L2Ellipse f={L2_BUCHEN} />
          <L2Ellipse f={L2_STORNO} />
          <L2Ellipse f={L2_WARTEN} />
        </>
      )}
      {stufe === "komplett" && (
        <>
          <L2Linie von={zahlung} f={L2_BEZAHLEN} />
          <L2Abhaengigkeit von={L2_BUCHEN} nach={L2_BEZAHLEN} stereotyp="include" label={[398, 81]} />
          <L2Abhaengigkeit von={L2_ZUBEHOER} nach={L2_BUCHEN} stereotyp="extend" label={[262, 154]} anker="end" />
          <Notiz
            x={372}
            y={140}
            b={170}
            zeilen={["Bedingung: Kunde", "wünscht Zubehör"]}
            anker={{ von: [372, 166], nach: [270, 150] }}
          />
          <L2Ellipse f={L2_BEZAHLEN} />
          <L2Ellipse f={L2_ZUBEHOER} />
        </>
      )}
      <Akteur x={70} y={130} name="Kunde" />
      <Akteur x={720} y={56} name="Zahlungsanbieter" />
      <Akteur x={720} y={262} name="Mitarbeiter" />
    </Abbildung>
  );
}

/** include und extend im direkten Vergleich: Pfeilrichtung und Bedeutung */
export function L2IncludeExtend() {
  const buchen1: L2Fall = { cx: 130, cy: 62, rx: 82, text: "Lastenrad buchen" };
  const bezahlen: L2Fall = { cx: 500, cy: 62, rx: 60, text: "Bezahlen" };
  const zubehoer: L2Fall = { cx: 130, cy: 176, rx: 90, text: "Zubehör hinzubuchen" };
  const buchen2: L2Fall = { cx: 500, cy: 176, rx: 82, text: "Lastenrad buchen" };
  return (
    <Abbildung
      breite={640}
      hoehe={224}
      min={560}
      label="Vergleich include und extend. Oben: Lastenrad buchen zeigt mit einem gestrichelten Pfeil «include» auf Bezahlen, der Basisfall bindet den Fall immer ein. Unten: Zubehör hinzubuchen zeigt mit einem gestrichelten Pfeil «extend» auf Lastenrad buchen, die Erweiterung läuft nur unter einer Bedingung."
      caption="Der Pfeil startet immer beim Fall, der den anderen „kennt“: Der Basisfall kennt den eingebundenen Fall, die Erweiterung kennt ihren Basisfall."
    >
      <text className="uml-rolle" x={130} y={24} textAnchor="middle">Basisfall</text>
      <text className="uml-rolle" x={500} y={24} textAnchor="middle">eingebundener Fall</text>
      <L2Abhaengigkeit von={buchen1} nach={bezahlen} stereotyp="include" label={[326, 53]} />
      <text className="uml-notiz-text" x={326} y={82} textAnchor="middle">läuft immer mit</text>
      <L2Ellipse f={buchen1} />
      <L2Ellipse f={bezahlen} />

      <text className="uml-rolle" x={130} y={138} textAnchor="middle">Erweiterung</text>
      <text className="uml-rolle" x={500} y={138} textAnchor="middle">Basisfall</text>
      <L2Abhaengigkeit von={zubehoer} nach={buchen2} stereotyp="extend" label={[320, 167]} />
      <text className="uml-notiz-text" x={320} y={196} textAnchor="middle">nur unter Bedingung</text>
      <L2Ellipse f={zubehoer} />
      <L2Ellipse f={buchen2} />
    </Abbildung>
  );
}

/** Generalisierung von Akteuren: Stationsleitung erbt alles von Mitarbeiter */
export function L2AkteurGeneralisierung() {
  const warten: L2Fall = { cx: 360, cy: 70, rx: 70, text: "Rad warten" };
  const ausmustern: L2Fall = { cx: 360, cy: 206, rx: 80, text: "Rad ausmustern" };
  return (
    <Abbildung
      breite={540}
      hoehe={280}
      min={460}
      label="Generalisierung von Akteuren: Die Stationsleitung zeigt mit einem Pfeil mit hohler Dreiecksspitze auf Mitarbeiter. Mitarbeiter ist mit Rad warten verbunden, die Stationsleitung zusätzlich mit Rad ausmustern. Die Stationsleitung darf damit beides."
    >
      <L2System x={210} y={16} b={300} h={250} name="Lastenrad-Verleih" />
      <L2Linie von={l2Anker(90, 40, 1)} f={warten} />
      <L2Linie von={l2Anker(90, 176, 1)} f={ausmustern} />
      <Kante punkte={[[90, 164], [90, 126]]} art="vererbung" />
      <L2Ellipse f={warten} />
      <L2Ellipse f={ausmustern} />
      <Akteur x={90} y={40} name="Mitarbeiter" />
      <Akteur x={90} y={176} name="Stationsleitung" />
    </Abbildung>
  );
}

/** Musterloesung Zeichenaufgabe 2.1: Stadtbibliothek */
export function L2BibliothekLoesung() {
  const ausleihen: L2Fall = { cx: 270, cy: 80, rx: 80, text: "Medium ausleihen" };
  const verlaengern: L2Fall = { cx: 270, cy: 200, rx: 88, text: "Ausleihe verlängern" };
  const konto: L2Fall = { cx: 500, cy: 140, rx: 82, text: "Leserkonto prüfen" };
  const rueckgabe: L2Fall = { cx: 495, cy: 290, rx: 100, text: "Rückgabe entgegennehmen" };
  const mahnung: L2Fall = { cx: 240, cy: 290, rx: 80, text: "Mahngebühr erheben" };
  const leser = l2Anker(70, 110, 1);
  const bibliothekar = l2Anker(690, 250, -1);
  return (
    <Abbildung
      breite={760}
      hoehe={410}
      min={600}
      label="Musterlösung Bibliothek: Der Leser ist mit Medium ausleihen und Ausleihe verlängern verbunden. Beide binden Leserkonto prüfen per include ein. Der Bibliothekar ist mit Rückgabe entgegennehmen verbunden. Mahngebühr erheben erweitert Rückgabe entgegennehmen per extend unter der Bedingung, dass die Leihfrist überschritten ist."
    >
      <L2System x={150} y={16} b={460} h={378} name="Bibliothekssystem" />
      <L2Linie von={leser} f={ausleihen} />
      <L2Linie von={leser} f={verlaengern} />
      <L2Linie von={bibliothekar} f={rueckgabe} />
      <L2Abhaengigkeit von={ausleihen} nach={konto} stereotyp="include" label={[392, 96]} anker="start" />
      <L2Abhaengigkeit von={verlaengern} nach={konto} stereotyp="include" label={[396, 196]} anker="start" />
      <L2Abhaengigkeit von={mahnung} nach={rueckgabe} stereotyp="extend" label={[358, 281]} />
      <Notiz
        x={292}
        y={330}
        b={170}
        zeilen={["Bedingung: Leihfrist", "überschritten"]}
        anker={{ von: [360, 330], nach: [358, 292] }}
      />
      <L2Ellipse f={ausleihen} />
      <L2Ellipse f={verlaengern} />
      <L2Ellipse f={konto} />
      <L2Ellipse f={rueckgabe} />
      <L2Ellipse f={mahnung} />
      <Akteur x={70} y={110} name="Leser" />
      <Akteur x={690} y={250} name="Bibliothekar" />
    </Abbildung>
  );
}

/** Musterloesung Zeichenaufgabe 2.2: Tierarztpraxis */
export function L2TierarztLoesung() {
  const buchen: L2Fall = { cx: 270, cy: 78, rx: 72, text: "Termin buchen" };
  const verschieben: L2Fall = { cx: 270, cy: 190, rx: 84, text: "Termin verschieben" };
  const sms: L2Fall = { cx: 480, cy: 130, rx: 94, text: "SMS-Erinnerung senden" };
  const tagesplan: L2Fall = { cx: 470, cy: 262, rx: 86, text: "Tagesplan einsehen" };
  const behandlung: L2Fall = { cx: 420, cy: 372, rx: 110, text: "Behandlung dokumentieren" };
  return (
    <Abbildung
      breite={800}
      hoehe={450}
      min={620}
      label="Musterlösung Tierarztpraxis: Der Tierhalter ist mit Termin buchen und Termin verschieben verbunden. Beide binden SMS-Erinnerung senden per include ein, das mit dem Akteur SMS-Dienst verbunden ist. Der Praxismitarbeiter ist mit Tagesplan einsehen verbunden. Die Tierärztin erbt vom Praxismitarbeiter und ist zusätzlich mit Behandlung dokumentieren verbunden."
    >
      <L2System x={150} y={16} b={450} h={418} name="Terminsystem Tierarztpraxis" />
      <L2Linie von={l2Anker(70, 96, 1)} f={buchen} />
      <L2Linie von={l2Anker(70, 96, 1)} f={verschieben} />
      <L2Linie von={l2Anker(700, 50, -1)} f={sms} />
      <L2Linie von={l2Anker(700, 196, -1)} f={tagesplan} />
      <L2Linie von={l2Anker(700, 334, -1)} f={behandlung} />
      <L2Abhaengigkeit von={buchen} nach={sms} stereotyp="include" label={[384, 94]} anker="start" />
      <L2Abhaengigkeit von={verschieben} nach={sms} stereotyp="include" label={[388, 190]} anker="start" />
      <Kante punkte={[[700, 322], [700, 284]]} art="vererbung" />
      <L2Ellipse f={buchen} />
      <L2Ellipse f={verschieben} />
      <L2Ellipse f={sms} />
      <L2Ellipse f={tagesplan} />
      <L2Ellipse f={behandlung} />
      <Akteur x={70} y={96} name="Tierhalter" />
      <Akteur x={700} y={50} name="SMS-Dienst" />
      <Akteur x={700} y={196} name="Praxismitarbeiter" />
      <Akteur x={700} y={334} name="Tierärztin" />
    </Abbildung>
  );
}

/* ================================================================== */
/* Lektion 4: Klassendiagramm II                                      */
/* ================================================================== */

const L4_KOPF_ZUSATZ = 14; // zweite Zeile im Kopf fuer Stereotyp oder {abstract}

export type L4KlasseSpec = KlasseSpec & {
  /** «interface» ueber dem Namen */
  schnittstelle?: boolean;
  /** kursiver Name plus {abstract} unter dem Namen */
  abstrakt?: boolean;
  /** Methoden, die kursiv (abstrakt) gesetzt werden */
  kursiv?: string[];
};

function l4Kopf(k: Pick<L4KlasseSpec, "schnittstelle" | "abstrakt">): number {
  return k.schnittstelle || k.abstrakt ? KOPF + L4_KOPF_ZUSATZ : KOPF;
}

export function l4Hoehe(k: Omit<L4KlasseSpec, "x" | "y" | "b">): number {
  return klassenHoehe(k) - KOPF + l4Kopf(k);
}

/** Klasse mit optionalem Stereotyp «interface» bzw. {abstract} und kursiven Methoden */
export function L4Klasse(k: L4KlasseSpec) {
  const { name, x, y, b, attribute, methoden, schnittstelle, abstrakt, kursiv = [] } = k;
  const kopf = l4Kopf(k);
  const h = l4Hoehe(k);
  const faecher: { top: number; zeilen: string[] }[] = [];
  let top = y + kopf;
  for (const zeilen of [attribute, methoden]) {
    if (!zeilen) continue;
    faecher.push({ top, zeilen });
    top += fachHoehe(zeilen.length);
  }
  return (
    <g>
      <rect className="uml-box" x={x} y={y} width={b} height={h} rx={2} />
      <rect className="uml-kopf" x={x} y={y} width={b} height={kopf} rx={2} />
      {schnittstelle && (
        <text className="uml-assoz-name" x={x + b / 2} y={y + 16} textAnchor="middle">
          «interface»
        </text>
      )}
      <text
        className="uml-name"
        x={x + b / 2}
        y={schnittstelle ? y + 34 : y + 20}
        textAnchor="middle"
        style={abstrakt ? { fontStyle: "italic" } : undefined}
      >
        {name}
      </text>
      {abstrakt && (
        <text className="uml-assoz-name" x={x + b / 2} y={y + 36} textAnchor="middle">
          {"{abstract}"}
        </text>
      )}
      {faecher.map((f) => (
        <g key={f.top}>
          <line className="uml-trenner" x1={x} y1={f.top} x2={x + b} y2={f.top} />
          {f.zeilen.map((z, i) => (
            <text
              key={z}
              className="uml-member"
              x={x + 10}
              y={f.top + 18 + i * ZEILE}
              style={kursiv.includes(z) ? { fontStyle: "italic" } : undefined}
            >
              {z}
            </text>
          ))}
        </g>
      ))}
      <rect className="uml-rand" x={x} y={y} width={b} height={h} rx={2} />
    </g>
  );
}

/** Realisierung: gestrichelte Linie mit hohlem Dreieck am Interface (Ende) */
function L4Realisierung({ punkte }: { punkte: Punkt[] }) {
  const ende = punkte[punkte.length - 1];
  const vor = punkte[punkte.length - 2];
  const [ux, uy] = einheit(vor, ende);
  const nx = -uy;
  const ny = ux;
  const q = (f: number, s: number) => `${ende[0] - ux * f + nx * s},${ende[1] - uy * f + ny * s}`;
  // Linie endet an der Dreiecksbasis, damit keine Strichelung im Dreieck liegt
  const linie = [...punkte.slice(0, -1), [ende[0] - ux * 15, ende[1] - uy * 15] as Punkt];
  return (
    <g>
      <polyline className="uml-linie" points={linie.map((p) => p.join(",")).join(" ")} style={L2_STRICH} />
      <polygon className="uml-dreieck" points={`${q(0, 0)} ${q(15, 8)} ${q(15, -8)}`} />
    </g>
  );
}

/** Vererbungsbaum: jede Unterklasse laeuft ueber eine gemeinsame Sammelhoehe zur Oberklasse */
function L4Baum({ ober, unter, sammelY }: { ober: Punkt; unter: Punkt[]; sammelY: number }) {
  return (
    <>
      {unter.map((u) => (
        <Kante
          key={u.join()}
          art="vererbung"
          punkte={[u, [u[0], sammelY], [ober[0], sammelY], ober]}
        />
      ))}
    </>
  );
}

/** Lehrbeispiel Vererbung, abstrakte Klasse und Interface: Medium, Buch, DVD, Verlaengerbar */
export function L4MedienVererbung({ caption }: { caption?: ReactNode }) {
  const iface: L4KlasseSpec = {
    name: "Verlaengerbar",
    schnittstelle: true,
    x: 20,
    y: 20,
    b: 250,
    methoden: ["+ verlaengern(tage: int): void"],
  };
  const medium: L4KlasseSpec = {
    name: "Medium",
    abstrakt: true,
    x: 330,
    y: 20,
    b: 260,
    attribute: ["# medienNr: int", "# titel: String"],
    methoden: ["+ berechneLeihfrist(): int"],
    kursiv: ["+ berechneLeihfrist(): int"],
  };
  const buch: L4KlasseSpec = {
    name: "Buch",
    x: 40,
    y: 236,
    b: 280,
    attribute: ["- isbn: String", "- seiten: int"],
    methoden: ["+ berechneLeihfrist(): int", "+ verlaengern(tage: int): void"],
  };
  const dvd: L4KlasseSpec = {
    name: "DVD",
    x: 480,
    y: 236,
    b: 260,
    attribute: ["- laufzeitMin: int", "- fsk: int"],
    methoden: ["+ berechneLeihfrist(): int"],
  };
  const mediumUnten = medium.y + l4Hoehe(medium);
  const ifaceUnten = iface.y + l4Hoehe(iface);
  return (
    <Abbildung
      breite={760}
      hoehe={buch.y + l4Hoehe(buch) + 20}
      min={600}
      label="Klassendiagramm: Die abstrakte Klasse Medium mit den geschützten Attributen medienNr und titel und der abstrakten Methode berechneLeihfrist. Buch und DVD erben von Medium, erkennbar am hohlen Dreieck an Medium. Buch realisiert zusätzlich das Interface Verlaengerbar, gestrichelte Linie mit hohlem Dreieck am Interface."
      caption={caption}
    >
      <L4Baum
        ober={[medium.x + medium.b / 2, mediumUnten]}
        unter={[
          [buch.x + 190, buch.y],
          [dvd.x + dvd.b / 2, dvd.y],
        ]}
        sammelY={196}
      />
      <L4Realisierung punkte={[[buch.x + 80, buch.y], [buch.x + 80, ifaceUnten]]} />
      <L4Klasse {...iface} />
      <L4Klasse {...medium} />
      <L4Klasse {...buch} />
      <L4Klasse {...dvd} />
    </Abbildung>
  );
}

/** Komposition (Bestellung, Bestellposition) und Aggregation (Team, Mitarbeiter) nebeneinander */
export function L4TeilGanzes({ caption }: { caption?: ReactNode }) {
  const bestellung: KlasseSpec = {
    name: "Bestellung",
    x: 20,
    y: 44,
    b: 250,
    attribute: ["- bestellNr: int", "- datum: Date"],
    methoden: ["+ berechneSumme(): double"],
  };
  const position: KlasseSpec = {
    name: "Bestellposition",
    x: 20,
    y: 230,
    b: 250,
    attribute: ["- menge: int", "- einzelpreis: double"],
    methoden: ["+ berechneBetrag(): double"],
  };
  const team: KlasseSpec = {
    name: "Team",
    x: 350,
    y: 44,
    b: 230,
    attribute: ["- name: String"],
    methoden: [],
  };
  const mitarbeiter: KlasseSpec = {
    name: "Mitarbeiter",
    x: 350,
    y: 230,
    b: 230,
    attribute: ["- personalNr: int", "- name: String"],
    methoden: [],
  };
  const xb = bestellung.x + bestellung.b / 2;
  const xt = team.x + team.b / 2;
  return (
    <Abbildung
      breite={600}
      hoehe={position.y + klassenHoehe(position) + 20}
      min={520}
      label="Links Komposition: Bestellung mit gefüllter Raute, eine Bestellung besteht aus 1 bis beliebig vielen Bestellpositionen, jede Position gehört zu genau 1 Bestellung. Rechts Aggregation: Team mit hohler Raute, ein Team hat 1 bis beliebig viele Mitarbeiter, ein Mitarbeiter gehört zu 0 bis beliebig vielen Teams."
      caption={caption}
    >
      <text className="uml-hinweis-titel" x={bestellung.x} y={26}>Komposition</text>
      <text className="uml-hinweis-titel" x={team.x} y={26}>Aggregation</text>
      <Kante
        art="komposition"
        punkte={[[xb, bestellung.y + klassenHoehe(bestellung)], [xb, position.y]]}
        von="1"
        nach="1..*"
      />
      <Kante
        art="aggregation"
        punkte={[[xt, team.y + klassenHoehe(team)], [xt, mitarbeiter.y]]}
        von="0..*"
        nach="1..*"
      />
      <Klasse {...bestellung} />
      <Klasse {...position} />
      <Klasse {...team} />
      <Klasse {...mitarbeiter} />
    </Abbildung>
  );
}

/** Assoziationsklasse: Ausleihe haengt gestrichelt an der Assoziation Leser, Medium */
export function L4Assoziationsklasse() {
  const leser: KlasseSpec = { name: "Leser", x: 20, y: 20, b: 200, attribute: ["- leserNr: int", "- name: String"] };
  const medium: KlasseSpec = { name: "Medium", x: 440, y: 20, b: 200, attribute: ["- medienNr: int", "- titel: String"] };
  const ausleihe: KlasseSpec = {
    name: "Ausleihe",
    x: 205,
    y: 140,
    b: 250,
    attribute: ["- ausleihdatum: Date", "- rueckgabedatum: Date"],
    methoden: ["+ verlaengern(tage: int): void"],
  };
  const y = leser.y + klassenHoehe(leser) / 2;
  const mitte = (leser.x + leser.b + medium.x) / 2;
  return (
    <Abbildung
      breite={660}
      hoehe={ausleihe.y + klassenHoehe(ausleihe) + 20}
      min={520}
      label="Assoziationsklasse: Leser und Medium sind mit 0 bis beliebig vielen auf beiden Seiten verbunden. An der Mitte der Linie hängt gestrichelt die Klasse Ausleihe mit Ausleihdatum, Rückgabedatum und der Methode verlaengern."
    >
      <Kante punkte={[[leser.x + leser.b, y], [medium.x, y]]} von="0..*" nach="0..*" />
      <line className="uml-linie" x1={mitte} y1={y} x2={mitte} y2={ausleihe.y} style={L2_STRICH} />
      <Klasse {...leser} />
      <Klasse {...medium} />
      <Klasse {...ausleihe} />
    </Abbildung>
  );
}

/** Musterloesung Zeichenaufgabe 4.1: Fahrzeugverleih */
export function L4FahrzeugLoesung() {
  const iface: L4KlasseSpec = {
    name: "Versicherbar",
    schnittstelle: true,
    x: 20,
    y: 20,
    b: 250,
    methoden: ["+ berechneBeitrag(): double"],
  };
  const fahrzeug: L4KlasseSpec = {
    name: "Fahrzeug",
    abstrakt: true,
    x: 330,
    y: 20,
    b: 300,
    attribute: ["# kennung: String", "# tagespreis: double"],
    methoden: ["+ berechneMiete(tage: int): double"],
    kursiv: ["+ berechneMiete(tage: int): double"],
  };
  const pkw: L4KlasseSpec = {
    name: "Pkw",
    x: 20,
    y: 236,
    b: 300,
    attribute: ["- kennzeichen: String", "- sitzplaetze: int"],
    methoden: ["+ berechneMiete(tage: int): double", "+ berechneBeitrag(): double"],
  };
  const rad: L4KlasseSpec = {
    name: "Lastenrad",
    x: 460,
    y: 236,
    b: 300,
    attribute: ["- zuladungKg: int", "- elektrisch: boolean"],
    methoden: ["+ berechneMiete(tage: int): double"],
  };
  return (
    <Abbildung
      breite={780}
      hoehe={pkw.y + l4Hoehe(pkw) + 20}
      min={600}
      label="Musterlösung Fahrzeugverleih: abstrakte Klasse Fahrzeug mit kennung, tagespreis und der abstrakten Methode berechneMiete. Pkw und Lastenrad erben von Fahrzeug und überschreiben berechneMiete. Pkw realisiert das Interface Versicherbar mit der Methode berechneBeitrag."
    >
      <L4Baum
        ober={[fahrzeug.x + fahrzeug.b / 2, fahrzeug.y + l4Hoehe(fahrzeug)]}
        unter={[
          [pkw.x + 210, pkw.y],
          [rad.x + rad.b / 2, rad.y],
        ]}
        sammelY={196}
      />
      <L4Realisierung punkte={[[pkw.x + 80, pkw.y], [pkw.x + 80, iface.y + l4Hoehe(iface)]]} />
      <L4Klasse {...iface} />
      <L4Klasse {...fahrzeug} />
      <L4Klasse {...pkw} />
      <L4Klasse {...rad} />
    </Abbildung>
  );
}

/** Musterloesung Zeichenaufgabe 4.2: Rechnung und Rechnungsposition */
export function L4RechnungLoesung() {
  const l = lAnordnung(
    { name: "Kunde", attribute: ["- kundenNr: int", "- name: String"], methoden: [] },
    {
      name: "Rechnung",
      attribute: ["- rechnungsNr: int", "- datum: Date"],
      methoden: ["+ neuePosition(a: Artikel, menge: int): void", "+ berechneSumme(): double"],
    },
    {
      name: "Rechnungsposition",
      attribute: ["- positionNr: int", "- menge: int", "- einzelpreis: double"],
      methoden: ["+ berechneBetrag(): double"],
    },
    {
      name: "Artikel",
      attribute: ["- artikelNr: int", "- bezeichnung: String", "- preis: double"],
      methoden: [],
    },
    { breite: 340, luecke: 130 },
  );
  return (
    <Abbildung
      breite={l.breite}
      hoehe={l.hoehe}
      min={640}
      label="Musterlösung Rechnung: Ein Kunde erhält 0 bis beliebig viele Rechnungen, jede Rechnung gehört zu genau 1 Kunden. Komposition mit gefüllter Raute an Rechnung: Eine Rechnung besteht aus 1 bis beliebig vielen Rechnungspositionen, jede Position gehört zu genau 1 Rechnung. Jede Rechnungsposition bezieht sich auf genau 1 Artikel, ein Artikel kommt in 0 bis beliebig vielen Positionen vor."
    >
      <Kante punkte={l.ab} von="1" nach="0..*" />
      <Kante punkte={l.bc} art="komposition" von="1" nach="1..*" />
      <Kante punkte={l.dc} von="1" nach="0..*" />
      <Klasse {...l.klassen.a} />
      <Klasse {...l.klassen.b} />
      <Klasse {...l.klassen.c} />
      {l.klassen.d && <Klasse {...l.klassen.d} />}
    </Abbildung>
  );
}

/* ================================================================== */
/* Lektion 5: Aktivitaetsdiagramm                                     */
/* ================================================================== */

// Alle Knoten werden ueber ihren Mittelpunkt platziert. Kontrollfluesse sind
// achsenparallele Polylinien mit offener Pfeilspitze am Ziel.

const L5_RAUTE = 18; // halbe Diagonale der Raute
const L5_AKTION_H = 40;

function L5Start({ x, y }: { x: number; y: number }) {
  return <circle className="uml-raute-voll" cx={x} cy={y} r={9} />;
}

function L5Ende({ x, y }: { x: number; y: number }) {
  return (
    <g>
      <circle className="uml-raute-leer" cx={x} cy={y} r={11} />
      <circle className="uml-raute-voll" cx={x} cy={y} r={6} />
    </g>
  );
}

function L5Ablaufende({ x, y }: { x: number; y: number }) {
  const d = 7;
  return (
    <g>
      <circle className="uml-raute-leer" cx={x} cy={y} r={10} />
      <path className="uml-linie" d={`M${x - d} ${y - d}L${x + d} ${y + d}M${x + d} ${y - d}L${x - d} ${y + d}`} />
    </g>
  );
}

/** Aktion: abgerundetes Rechteck, eine oder zwei Zeilen */
function L5Aktion({ x, y, b, zeilen, h = zeilen.length > 1 ? 48 : L5_AKTION_H }: { x: number; y: number; b: number; zeilen: string[]; h?: number }) {
  const start = y + 4.5 - ((zeilen.length - 1) * 16) / 2;
  return (
    <g>
      <rect className="uml-usecase" x={x - b / 2} y={y - h / 2} width={b} height={h} rx={12} />
      {zeilen.map((z, i) => (
        <text key={z} className="uml-usecase-text" x={x} y={start + i * 16} textAnchor="middle">
          {z}
        </text>
      ))}
    </g>
  );
}

/** Entscheidung oder Zusammenfuehrung */
function L5Raute({ x, y }: { x: number; y: number }) {
  const r = L5_RAUTE;
  return <polygon className="uml-raute-leer" points={`${x},${y - r} ${x + r},${y} ${x},${y + r} ${x - r},${y}`} />;
}

/** Gabelung oder Vereinigung: waagerechter Balken */
function L5Balken({ x1, x2, y }: { x1: number; x2: number; y: number }) {
  return <rect className="uml-raute-voll" x={x1} y={y - 3} width={x2 - x1} height={6} rx={1} />;
}

/** Objektknoten: eckiges Rechteck mit Namen, optional Zustand in eckigen Klammern */
function L5Objekt({ x, y, b, name, zustand }: { x: number; y: number; b: number; name: string; zustand?: string }) {
  const h = zustand ? 46 : 34;
  return (
    <g>
      <rect className="uml-box" x={x - b / 2} y={y - h / 2} width={b} height={h} />
      <rect className="uml-rand" x={x - b / 2} y={y - h / 2} width={b} height={h} />
      <text className="uml-name" x={x} y={zustand ? y - 3 : y + 5} textAnchor="middle">
        {name}
      </text>
      {zustand && (
        <text className="uml-assoz-name" x={x} y={y + 14} textAnchor="middle">
          {zustand}
        </text>
      )}
    </g>
  );
}

/** Kontroll- oder Objektfluss mit offener Pfeilspitze, optional mit Bedingung */
function L5Fluss({
  punkte,
  bedingung,
}: {
  punkte: Punkt[];
  bedingung?: { text: string; x: number; y: number; anker?: "start" | "middle" | "end" };
}) {
  const ende = punkte[punkte.length - 1];
  const vor = punkte[punkte.length - 2];
  return (
    <g>
      <polyline className="uml-linie" points={punkte.map((p) => p.join(",")).join(" ")} />
      <polyline className="uml-linie" points={l2Spitze(vor, ende, 10, 5)} />
      {bedingung && (
        <text className="uml-mult" x={bedingung.x} y={bedingung.y} textAnchor={bedingung.anker ?? "middle"}>
          {bedingung.text}
        </text>
      )}
    </g>
  );
}

/** Schwimmbahnen: senkrechte Partitionen mit Kopfzeile */
function L5Bahnen({ x, y, h, bahnen }: { x: number; y: number; h: number; bahnen: { name: string; b: number }[] }) {
  const kopf = 34;
  let links = x;
  const spalten = bahnen.map((bahn) => {
    const s = { ...bahn, x: links };
    links += bahn.b;
    return s;
  });
  return (
    <g>
      {spalten.map((s) => (
        <rect key={s.name} className="uml-kopf" x={s.x} y={y} width={s.b} height={kopf} />
      ))}
      <rect className="uml-system" x={x} y={y} width={links - x} height={h} />
      <line className="uml-system" x1={x} y1={y + kopf} x2={links} y2={y + kopf} />
      {spalten.slice(1).map((s) => (
        <line key={s.name} className="uml-system" x1={s.x} y1={y} x2={s.x} y2={y + h} />
      ))}
      {spalten.map((s) => (
        <text key={s.name} className="uml-system-name" x={s.x + s.b / 2} y={y + 22} textAnchor="middle">
          {s.name}
        </text>
      ))}
    </g>
  );
}

/** Legende der Notationselemente */
export function L5Elemente() {
  const zellen: { titel: string; text: string; symbol: ReactNode }[] = [
    { titel: "Startknoten", text: "initial node", symbol: <L5Start x={0} y={0} /> },
    { titel: "Aktivitätsende", text: "activity final", symbol: <L5Ende x={0} y={0} /> },
    { titel: "Ablaufende", text: "flow final", symbol: <L5Ablaufende x={0} y={0} /> },
    { titel: "Aktion", text: "action", symbol: <L5Aktion x={0} y={0} b={130} zeilen={["Ticket erfassen"]} /> },
    { titel: "Entscheidung", text: "decision / merge", symbol: <L5Raute x={0} y={0} /> },
    { titel: "Gabelung", text: "fork / join", symbol: <L5Balken x1={-60} x2={60} y={0} /> },
    { titel: "Objektknoten", text: "object node", symbol: <L5Objekt x={0} y={0} b={110} name="Rechnung" /> },
    {
      titel: "Kontrollfluss",
      text: "control flow",
      symbol: <L5Fluss punkte={[[-60, 8], [60, 8]]} bedingung={{ text: "[hoch]", x: 0, y: -2 }} />,
    },
  ];
  const sp = 180;
  const zh = 118;
  return (
    <Abbildung
      breite={4 * sp}
      hoehe={2 * zh + 10}
      min={600}
      label="Notationselemente des Aktivitätsdiagramms: Startknoten als gefüllter Kreis, Aktivitätsende als Kreis mit gefülltem Punkt, Ablaufende als Kreis mit Kreuz, Aktion als abgerundetes Rechteck, Entscheidung und Zusammenführung als Raute, Gabelung und Vereinigung als Balken, Objektknoten als eckiges Rechteck, Kontrollfluss als Pfeil mit Bedingung in eckigen Klammern."
    >
      {zellen.map((z, i) => {
        const cx = (i % 4) * sp + sp / 2;
        const top = Math.floor(i / 4) * zh + 10;
        return (
          <g key={z.titel}>
            <g transform={`translate(${cx} ${top + 34})`}>{z.symbol}</g>
            <text className="uml-hinweis-titel" x={cx} y={top + 82} textAnchor="middle">
              {z.titel}
            </text>
            <text className="uml-hinweis" x={cx} y={top + 100} textAnchor="middle">
              {z.text}
            </text>
          </g>
        );
      })}
    </Abbildung>
  );
}

/** Objektfluss: eine Aktion erzeugt ein Objekt, die naechste verarbeitet es */
export function L5Objektfluss() {
  return (
    <Abbildung
      breite={620}
      hoehe={90}
      min={520}
      label="Objektfluss: Die Aktion Rechnung erstellen liefert ein Objekt Rechnung im Zustand erstellt, das die Aktion Rechnung versenden übernimmt."
    >
      <L5Fluss punkte={[[170, 45], [250, 45]]} />
      <L5Fluss punkte={[[370, 45], [450, 45]]} />
      <L5Aktion x={90} y={45} b={160} zeilen={["Rechnung erstellen"]} />
      <L5Objekt x={310} y={45} b={120} name="Rechnung" zustand="[erstellt]" />
      <L5Aktion x={530} y={45} b={160} zeilen={["Rechnung versenden"]} />
    </Abbildung>
  );
}

/**
 * Stoerungsticket im IT-Support (Lektion 5).
 * "ablauf": Ablauf mit Entscheidung und Parallelitaet, ohne Schwimmbahnen,
 * "komplett": zusaetzlich Schwimmbahnen Support und Technik.
 */
export function L5TicketDiagramm({ stufe = "komplett", caption }: { stufe?: "ablauf" | "komplett"; caption?: ReactNode }) {
  const s = 180; // Mitte Support
  const t = 490; // Mitte Technik
  const label =
    stufe === "ablauf"
      ? "Aktivitätsdiagramm Störungsticket ohne Schwimmbahnen: Start, Ticket erfassen, Priorität prüfen, Entscheidung. Bei hoch direkt weiter, bei niedrig In Warteschlange einreihen. Zusammenführung, dann Gabelung in zwei parallele Zweige: Kunde informieren sowie Störung beheben und Lösung dokumentieren. Vereinigung, Ticket schließen, Ende."
      : "Aktivitätsdiagramm Störungsticket mit den Schwimmbahnen Support und Technik. Support: Ticket erfassen, Priorität prüfen, Entscheidung hoch oder niedrig, bei niedrig In Warteschlange einreihen, Zusammenführung, Gabelung. Parallel: Support informiert den Kunden, Technik behebt die Störung und dokumentiert die Lösung. Nach der Vereinigung schließt der Support das Ticket.";
  return (
    <Abbildung breite={660} hoehe={830} min={520} label={label} caption={caption}>
      {stufe === "komplett" && (
        <L5Bahnen x={20} y={20} h={795} bahnen={[{ name: "Support", b: 320 }, { name: "Technik", b: 300 }]} />
      )}
      <L5Fluss punkte={[[s, 89], [s, 110]]} />
      <L5Fluss punkte={[[s, 150], [s, 180]]} />
      <L5Fluss punkte={[[s, 220], [s, 252]]} />
      <L5Fluss
        punkte={[[s - L5_RAUTE, 270], [62, 270], [62, 420], [s - L5_RAUTE, 420]]}
        bedingung={{ text: "[hoch]", x: 110, y: 262 }}
      />
      <L5Fluss punkte={[[s, 288], [s, 316]]} bedingung={{ text: "[niedrig]", x: s + 8, y: 306, anker: "start" }} />
      <L5Fluss punkte={[[s, 364], [s, 402]]} />
      <L5Fluss punkte={[[s, 438], [s, 472]]} />
      <L5Fluss punkte={[[s, 478], [s, 515]]} />
      <L5Fluss punkte={[[t, 478], [t, 515]]} />
      <L5Fluss punkte={[[t, 555], [t, 585]]} />
      <L5Fluss punkte={[[s, 555], [s, 667]]} />
      <L5Fluss punkte={[[t, 625], [t, 667]]} />
      <L5Fluss punkte={[[s, 673], [s, 705]]} />
      <L5Fluss punkte={[[s, 745], [s, 784]]} />

      <L5Start x={s} y={80} />
      <L5Aktion x={s} y={130} b={170} zeilen={["Ticket erfassen"]} />
      <L5Aktion x={s} y={200} b={170} zeilen={["Priorität prüfen"]} />
      <L5Raute x={s} y={270} />
      <L5Aktion x={s} y={340} b={160} zeilen={["In Warteschlange", "einreihen"]} />
      <L5Raute x={s} y={420} />
      <L5Balken x1={110} x2={560} y={475} />
      <L5Aktion x={s} y={535} b={170} zeilen={["Kunde informieren"]} />
      <L5Aktion x={t} y={535} b={170} zeilen={["Störung beheben"]} />
      <L5Aktion x={t} y={605} b={190} zeilen={["Lösung dokumentieren"]} />
      <L5Balken x1={110} x2={560} y={670} />
      <L5Aktion x={s} y={725} b={170} zeilen={["Ticket schließen"]} />
      <L5Ende x={s} y={795} />
    </Abbildung>
  );
}

/** Dieselbe Verzweigung als Aktivitaetsdiagramm, Programmablaufplan und Struktogramm */
export function L5Vergleich() {
  // Panel 1: Aktivitaetsdiagramm
  const a = 115;
  // Panel 2: PAP
  const p = 360;
  // Panel 3: Struktogramm
  const n0 = 490;
  const nb = 210;
  const para = (cx: number, cy: number, b: number, h: number) => {
    const k = 8;
    return `${cx - b / 2 + k},${cy - h / 2} ${cx + b / 2 + k},${cy - h / 2} ${cx + b / 2 - k},${cy + h / 2} ${cx - b / 2 - k},${cy + h / 2}`;
  };
  return (
    <Abbildung
      breite={710}
      hoehe={380}
      min={640}
      label="Dieselbe Logik in drei Notationen. Aktivitätsdiagramm: Startknoten, Aktion Passwort einlesen, Raute mit den Bedingungen korrekt und falsch an den Kanten, Aktionen Anmelden und Fehler melden, Zusammenführung, Endknoten. Programmablaufplan: Terminator Start, Parallelogramm Passwort einlesen, Raute mit der Frage korrekt und den Ausgängen ja und nein, Rechteck Anmelden, Parallelogramm Fehler melden, Terminator Ende. Struktogramm: Block Passwort einlesen, darunter ein Verzweigungsblock korrekt mit den Spalten ja: Anmelden und nein: Fehler melden."
    >
      <text className="uml-hinweis-titel" x={a} y={22} textAnchor="middle">Aktivitätsdiagramm</text>
      <text className="uml-hinweis" x={a} y={40} textAnchor="middle">UML 2.5</text>
      <text className="uml-hinweis-titel" x={p} y={22} textAnchor="middle">Programmablaufplan</text>
      <text className="uml-hinweis" x={p} y={40} textAnchor="middle">DIN 66001</text>
      <text className="uml-hinweis-titel" x={n0 + nb / 2} y={22} textAnchor="middle">Struktogramm</text>
      <text className="uml-hinweis" x={n0 + nb / 2} y={40} textAnchor="middle">DIN 66261</text>

      {/* Aktivitaetsdiagramm */}
      <L5Fluss punkte={[[a, 79], [a, 100]]} />
      <L5Fluss punkte={[[a, 136], [a, 162]]} />
      <L5Fluss punkte={[[a - L5_RAUTE, 180], [58, 180], [58, 232]]} bedingung={{ text: "[korrekt]", x: 56, y: 172, anker: "middle" }} />
      <L5Fluss punkte={[[a + L5_RAUTE, 180], [172, 180], [172, 232]]} bedingung={{ text: "[falsch]", x: 176, y: 172, anker: "middle" }} />
      <L5Fluss punkte={[[58, 268], [58, 300], [a - L5_RAUTE, 300]]} />
      <L5Fluss punkte={[[172, 268], [172, 300], [a + L5_RAUTE, 300]]} />
      <L5Fluss punkte={[[a, 318], [a, 341]]} />
      <L5Start x={a} y={70} />
      <L5Aktion x={a} y={118} b={150} h={36} zeilen={["Passwort einlesen"]} />
      <L5Raute x={a} y={180} />
      <L5Aktion x={58} y={250} b={96} h={36} zeilen={["Anmelden"]} />
      <L5Aktion x={172} y={250} b={100} h={36} zeilen={["Fehler melden"]} />
      <L5Raute x={a} y={300} />
      <L5Ende x={a} y={352} />

      {/* Programmablaufplan */}
      <L5Fluss punkte={[[p, 84], [p, 100]]} />
      <L5Fluss punkte={[[p, 136], [p, 156]]} />
      <L5Fluss punkte={[[p - 46, 180], [p - 60, 180], [p - 60, 232]]} />
      <L5Fluss punkte={[[p + 46, 180], [p + 62, 180], [p + 62, 232]]} />
      <line className="uml-linie" x1={p - 60} y1={268} x2={p - 60} y2={296} />
      <line className="uml-linie" x1={p + 62} y1={268} x2={p + 62} y2={296} />
      <line className="uml-linie" x1={p - 60} y1={296} x2={p + 62} y2={296} />
      <L5Fluss punkte={[[p, 296], [p, 326]]} />
      <text className="uml-mult" x={p - 52} y={172} textAnchor="end">ja</text>
      <text className="uml-mult" x={p + 52} y={172} textAnchor="start">nein</text>
      <rect className="uml-box" x={p - 40} y={56} width={80} height={28} rx={14} />
      <rect className="uml-rand" x={p - 40} y={56} width={80} height={28} rx={14} />
      <text className="uml-usecase-text" x={p} y={74.5} textAnchor="middle">Start</text>
      <polygon className="uml-box" points={para(p, 118, 140, 36)} />
      <polygon className="uml-rand" points={para(p, 118, 140, 36)} />
      <text className="uml-usecase-text" x={p} y={122.5} textAnchor="middle">Passwort einlesen</text>
      <polygon className="uml-box" points={`${p},156 ${p + 46},180 ${p},204 ${p - 46},180`} />
      <polygon className="uml-rand" points={`${p},156 ${p + 46},180 ${p},204 ${p - 46},180`} />
      <text className="uml-usecase-text" x={p} y={184.5} textAnchor="middle">korrekt?</text>
      <rect className="uml-box" x={p - 108} y={232} width={96} height={36} />
      <rect className="uml-rand" x={p - 108} y={232} width={96} height={36} />
      <text className="uml-usecase-text" x={p - 60} y={254.5} textAnchor="middle">Anmelden</text>
      <polygon className="uml-box" points={para(p + 62, 250, 104, 36)} />
      <polygon className="uml-rand" points={para(p + 62, 250, 104, 36)} />
      <text className="uml-usecase-text" x={p + 62} y={254.5} textAnchor="middle">Fehler melden</text>
      <rect className="uml-box" x={p - 40} y={326} width={80} height={28} rx={14} />
      <rect className="uml-rand" x={p - 40} y={326} width={80} height={28} rx={14} />
      <text className="uml-usecase-text" x={p} y={344.5} textAnchor="middle">Ende</text>

      {/* Struktogramm */}
      <rect className="uml-box" x={n0} y={60} width={nb} height={150} />
      <line className="uml-trenner" x1={n0} y1={98} x2={n0 + nb} y2={98} />
      <path className="uml-linie" d={`M${n0} 98L${n0 + nb / 2} 150L${n0 + nb} 98`} />
      <line className="uml-trenner" x1={n0} y1={150} x2={n0 + nb} y2={150} />
      <line className="uml-trenner" x1={n0 + nb / 2} y1={150} x2={n0 + nb / 2} y2={210} />
      <rect className="uml-rand" x={n0} y={60} width={nb} height={150} />
      <text className="uml-usecase-text" x={n0 + nb / 2} y={83.5} textAnchor="middle">Passwort einlesen</text>
      <text className="uml-usecase-text" x={n0 + nb / 2} y={117} textAnchor="middle">korrekt?</text>
      <text className="uml-mult" x={n0 + 10} y={142}>ja</text>
      <text className="uml-mult" x={n0 + nb - 10} y={142} textAnchor="end">nein</text>
      <text className="uml-usecase-text" x={n0 + nb / 4} y={184.5} textAnchor="middle">Anmelden</text>
      <text className="uml-usecase-text" x={n0 + (3 * nb) / 4} y={184.5} textAnchor="middle">Fehler melden</text>
      <text className="uml-notiz-text" x={n0 + nb / 2} y={240} textAnchor="middle">kein Start- und Endsymbol,</text>
      <text className="uml-notiz-text" x={n0 + nb / 2} y={258} textAnchor="middle">keine Pfeile: Blöcke von</text>
      <text className="uml-notiz-text" x={n0 + nb / 2} y={276} textAnchor="middle">oben nach unten lesen</text>
    </Abbildung>
  );
}

/** Musterloesung Zeichenaufgabe 5.1: Online-Bestellung mit Zahlungspruefung */
export function L5BestellungLoesung() {
  const k = 130;
  const s = 360;
  const l = 590;
  return (
    <Abbildung
      breite={720}
      hoehe={720}
      min={600}
      label="Musterlösung Online-Bestellung mit den Schwimmbahnen Kunde, Shop und Lager. Kunde: Start, Bestellung absenden. Shop: Zusammenführung, Zahlung prüfen, Entscheidung. Bei abgelehnt ändert der Kunde die Zahlungsart, der Fluss läuft zurück in die Zusammenführung vor Zahlung prüfen. Bei bestätigt Gabelung: Shop sendet die Rechnung, parallel verpackt und versendet das Lager die Ware. Nach der Vereinigung schließt der Shop die Bestellung ab, Ende."
    >
      <L5Bahnen
        x={20}
        y={20}
        h={680}
        bahnen={[
          { name: "Kunde", b: 220 },
          { name: "Shop", b: 240 },
          { name: "Lager", b: 220 },
        ]}
      />
      <L5Fluss punkte={[[k, 89], [k, 110]]} />
      <L5Fluss punkte={[[k + 85, 130], [s, 130], [s, 182]]} />
      <L5Fluss punkte={[[s, 218], [s, 242]]} />
      <L5Fluss punkte={[[s, 282], [s, 322]]} />
      <L5Fluss
        punkte={[[s - L5_RAUTE, 340], [k + 85, 340]]}
        bedingung={{ text: "[abgelehnt]", x: 280, y: 332 }}
      />
      <L5Fluss punkte={[[k, 320], [k, 200], [s - L5_RAUTE, 200]]} />
      <L5Fluss punkte={[[s, 358], [s, 402]]} bedingung={{ text: "[bestätigt]", x: s + 8, y: 386, anker: "start" }} />
      <L5Fluss punkte={[[s, 408], [s, 450]]} />
      <L5Fluss punkte={[[l, 408], [l, 446]]} />
      <L5Fluss punkte={[[s, 490], [s, 542]]} />
      <L5Fluss punkte={[[l, 494], [l, 542]]} />
      <L5Fluss punkte={[[s, 548], [s, 585]]} />
      <L5Fluss punkte={[[s, 625], [s, 659]]} />

      <L5Start x={k} y={80} />
      <L5Aktion x={k} y={130} b={170} zeilen={["Bestellung absenden"]} />
      <L5Raute x={s} y={200} />
      <L5Aktion x={s} y={262} b={160} zeilen={["Zahlung prüfen"]} />
      <L5Raute x={s} y={340} />
      <L5Aktion x={k} y={340} b={170} zeilen={["Zahlungsart ändern"]} />
      <L5Balken x1={290} x2={660} y={405} />
      <L5Aktion x={s} y={470} b={160} zeilen={["Rechnung senden"]} />
      <L5Aktion x={l} y={470} b={160} zeilen={["Ware verpacken", "und versenden"]} />
      <L5Balken x1={290} x2={660} y={545} />
      <L5Aktion x={s} y={605} b={196} zeilen={["Bestellung abschließen"]} />
      <L5Ende x={s} y={670} />
    </Abbildung>
  );
}

/** Musterloesung Zeichenaufgabe 5.2: Passwort-Reset mit Fehlerpfaden */
export function L5PasswortLoesung() {
  const m = 220;
  const r = 440;
  return (
    <Abbildung
      breite={580}
      hoehe={720}
      min={500}
      label="Musterlösung Passwort-Reset: Start, Zusammenführung, Zurücksetzen anfordern, Link per E-Mail senden, Link öffnen, Entscheidung. Bei abgelaufen Hinweis Link abgelaufen, dann zurück in die erste Zusammenführung. Bei gültig zweite Zusammenführung, Neues Passwort eingeben, Entscheidung. Bei zu schwach Fehlermeldung anzeigen und zurück in die zweite Zusammenführung. Bei stark genug Passwort speichern, Ende."
    >
      <L5Fluss punkte={[[m, 39], [m, 62]]} />
      <L5Fluss punkte={[[m, 98], [m, 120]]} />
      <L5Fluss punkte={[[m, 160], [m, 185]]} />
      <L5Fluss punkte={[[m, 225], [m, 250]]} />
      <L5Fluss punkte={[[m, 290], [m, 322]]} />
      <L5Fluss punkte={[[m + L5_RAUTE, 340], [r - 90, 340]]} bedingung={{ text: "[abgelaufen]", x: 294, y: 332 }} />
      <L5Fluss punkte={[[r, 316], [r, 80], [m + L5_RAUTE, 80]]} />
      <L5Fluss punkte={[[m, 358], [m, 392]]} bedingung={{ text: "[gültig]", x: m + 8, y: 380, anker: "start" }} />
      <L5Fluss punkte={[[m, 428], [m, 450]]} />
      <L5Fluss punkte={[[m, 490], [m, 522]]} />
      <L5Fluss punkte={[[m + L5_RAUTE, 540], [r - 90, 540]]} bedingung={{ text: "[zu schwach]", x: 294, y: 532 }} />
      <L5Fluss punkte={[[r, 516], [r, 410], [m + L5_RAUTE, 410]]} />
      <L5Fluss punkte={[[m, 558], [m, 590]]} bedingung={{ text: "[stark genug]", x: m + 8, y: 580, anker: "start" }} />
      <L5Fluss punkte={[[m, 630], [m, 679]]} />

      <L5Start x={m} y={30} />
      <L5Raute x={m} y={80} />
      <L5Aktion x={m} y={140} b={200} zeilen={["Zurücksetzen anfordern"]} />
      <L5Aktion x={m} y={205} b={200} zeilen={["Link per E-Mail senden"]} />
      <L5Aktion x={m} y={270} b={200} zeilen={["Link öffnen"]} />
      <L5Raute x={m} y={340} />
      <L5Aktion x={r} y={340} b={180} zeilen={["Hinweis: Link", "abgelaufen"]} />
      <L5Raute x={m} y={410} />
      <L5Aktion x={m} y={470} b={200} zeilen={["Neues Passwort eingeben"]} />
      <L5Raute x={m} y={540} />
      <L5Aktion x={r} y={540} b={180} zeilen={["Fehlermeldung", "anzeigen"]} />
      <L5Aktion x={m} y={610} b={200} zeilen={["Passwort speichern"]} />
      <L5Ende x={m} y={690} />
    </Abbildung>
  );
}
