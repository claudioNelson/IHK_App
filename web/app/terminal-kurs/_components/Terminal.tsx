"use client";

// Uebungs-Terminal fuer den Terminal-Kurs. Die Logik steckt in ../_engine
// (reines TypeScript), diese Komponente zeigt nur an und nimmt Eingaben an.
//
//   <Terminal aufgabe="l1-erster-befehl" titel="Übung 1.1" />
//
// Die Aufgabe (Start-Dateisystem, Ziele, Tipps) kommt per id aus
// aufgaben/index.ts, weil Server-Seiten keine Funktionen an Client-Komponenten
// geben duerfen. Das Terminal ist immer frei bedienbar; Ziele haken sich nach
// jedem Befehl ab und bleiben abgehakt.
//
// Tastatur: Enter fuehrt aus, Pfeil hoch/runter blaettert im Verlauf, Tab
// ergaenzt, Strg+C bricht die Zeile ab, Strg+L leert. Esc gibt Tab frei (das
// naechste Tab verlaesst das Terminal), wie beim Python-Editor.

import { useEffect, useId, useLayoutEffect, useRef, useState, type KeyboardEvent } from "react";
import { HakenIcon } from "../../lernen/_components/LsIcons";
import { ResetIcon, TerminalIcon } from "../../components/kurs/KursIcons";
import { ergaenze } from "../_engine/ergaenzung";
import { ausfuehren, prompt } from "../_engine/shell";
import { szenario } from "../_engine/szenarien";
import type { ProtokollEintrag, Stil, Teil, Zustand } from "../_engine/typen";
import type { Aufgabe } from "../_engine/ziele";
import { AUFGABEN } from "./aufgaben";

type Prompt = ReturnType<typeof prompt>;
type Zeile =
  | { id: number; art: "eingabe"; prompt: Prompt; text: string }
  | { id: number; art: "ausgabe"; teile: Teil[] };

/** Hoechstzahl gemerkter Bildschirmzeilen (aeltere fallen oben heraus). */
const MAX_ZEILEN = 400;

/** Tasten der Leiste fuer Handys: Zeichen, die auf der Bildschirmtastatur schwer zu finden sind. */
const TASTEN: { label: string; aktion: "tab" | "hoch" | "runter" | string; aria?: string }[] = [
  { label: "Tab", aktion: "tab", aria: "Tab, Namen ergänzen" },
  { label: "↑", aktion: "hoch", aria: "Vorheriger Befehl" },
  { label: "↓", aktion: "runter", aria: "Nächster Befehl" },
  { label: "|", aktion: "|", aria: "Senkrechter Strich" },
  { label: "/", aktion: "/", aria: "Schrägstrich" },
  { label: "~", aktion: "~", aria: "Tilde" },
  { label: "-", aktion: "-", aria: "Minus" },
  { label: ">", aktion: ">", aria: "Größer-Zeichen" },
  { label: "*", aktion: "*", aria: "Stern" },
  { label: ".", aktion: ".", aria: "Punkt" },
];

const STIL_KLASSE: Record<Stil, string> = {
  ordner: "tk-s-ordner",
  ausfuehrbar: "tk-s-ausfuehrbar",
  geraet: "tk-s-geraet",
  fehler: "tk-s-fehler",
  hinweis: "tk-s-hinweis",
  fett: "tk-s-fett",
  treffer: "tk-s-treffer",
  dateiname: "tk-s-dateiname",
  zeilennr: "tk-s-zeilennr",
  trenner: "tk-s-trenner",
};

let naechsteId = 1;

const FREI: Aufgabe = { szenario: () => szenario(), ziele: [], tipps: [] };

function begruessungsZeilen(a: Aufgabe): Zeile[] {
  return a.begruessung ? [{ id: naechsteId++, art: "ausgabe", teile: [{ text: a.begruessung.replace(/\n?$/, "\n") }] }] : [];
}

/** Offenes Ziel: leerer Kreis (HakenIcon fuer erledigte Ziele kommt aus LsIcons). */
function OffenIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} aria-hidden="true" focusable="false">
      <circle cx="12" cy="12" r="8" />
    </svg>
  );
}

function PromptText({ p }: { p: Prompt }) {
  return (
    <>
      <span className="tk-p-benutzer">{p.benutzer}</span>:<span className="tk-p-pfad">{p.pfad}</span>
      {p.zeichen}{" "}
    </>
  );
}

export default function Terminal({
  aufgabe: aufgabeId,
  titel = "Übungs-Terminal",
  hoehe = 300,
}: {
  /** id aus aufgaben/index.ts */
  aufgabe: string;
  /** Name fuer Screenreader, z. B. "Übung 1.1" */
  titel?: string;
  /** Hoehe des Bildschirms in Pixeln */
  hoehe?: number;
}) {
  // Unbekannte id: freies Terminal statt Absturz (Tippfehler in einer Lektion faellt im Test auf)
  const aufgabe = AUFGABEN[aufgabeId] ?? FREI;

  const [z, setZ] = useState<Zustand>(() => aufgabe.szenario());
  const [zeilen, setZeilen] = useState<Zeile[]>(() => begruessungsZeilen(aufgabe));
  const [eingabe, setEingabe] = useState("");
  const [protokoll, setProtokoll] = useState<ProtokollEintrag[]>([]);
  const [erreicht, setErreicht] = useState<boolean[]>(() => aufgabe.ziele.map(() => false));
  const [tipps, setTipps] = useState(0);
  const [verlaufPos, setVerlaufPos] = useState<number | null>(null);
  const [entwurf, setEntwurf] = useState("");
  const [tabFrei, setTabFrei] = useState(false);
  const [breite, setBreite] = useState(80);

  const schirmRef = useRef<HTMLDivElement>(null);
  const eingabeRef = useRef<HTMLInputElement>(null);
  const messRef = useRef<HTMLSpanElement>(null);
  const cursorNachher = useRef<number | null>(null);
  const eingabeId = useId();
  const hinweisId = useId();

  const p = prompt(z);
  const mitZielen = aufgabe.ziele.length > 0;
  const fertig = mitZielen && erreicht.every(Boolean);

  // Breite in Zeichen aus der Breite des Bildschirms (fuer die Spalten von ls)
  useEffect(() => {
    const schirm = schirmRef.current;
    const mess = messRef.current;
    if (!schirm || !mess) return;
    const messen = () => {
      const zeichen = mess.getBoundingClientRect().width / 10;
      const stil = getComputedStyle(schirm);
      const innen = schirm.clientWidth - parseFloat(stil.paddingLeft) - parseFloat(stil.paddingRight);
      if (zeichen > 0) setBreite(Math.max(20, Math.floor(innen / zeichen)));
    };
    messen();
    const ro = new ResizeObserver(messen);
    ro.observe(schirm);
    return () => ro.disconnect();
  }, []);

  // Nach jeder Ausgabe ans Ende scrollen
  useLayoutEffect(() => {
    const schirm = schirmRef.current;
    if (schirm) schirm.scrollTop = schirm.scrollHeight;
  }, [zeilen]);

  // Cursor nach Tab-Ergaenzung, Verlauf oder Tastenleiste an die richtige Stelle setzen.
  // Laeuft nach jedem Rendern (auch wenn sich der Text nicht geaendert hat) und leert den Merker.
  useLayoutEffect(() => {
    const pos = cursorNachher.current;
    cursorNachher.current = null;
    if (pos !== null && eingabeRef.current) eingabeRef.current.setSelectionRange(pos, pos);
  });

  function anhaengen(neu: Zeile[], leeren = false) {
    setZeilen((alt) => (leeren ? neu : [...alt, ...neu]).slice(-MAX_ZEILEN));
  }

  function absenden() {
    const text = eingabe;
    const eingabeZeile: Zeile = { id: naechsteId++, art: "eingabe", prompt: p, text };
    setEingabe("");
    setVerlaufPos(null);
    setEntwurf("");
    if (text.trim() === "") {
      anhaengen([eingabeZeile]);
      return;
    }
    const a = ausfuehren(text, z, { breite });
    const ausgabe: Zeile[] = a.teile.length > 0 ? [{ id: naechsteId++, art: "ausgabe", teile: a.teile }] : [];
    if (a.leeren) anhaengen(ausgabe, true);
    else anhaengen([eingabeZeile, ...ausgabe]);

    const neuesProtokoll = [...protokoll, ...a.protokoll];
    setZ(a.zustand);
    setProtokoll(neuesProtokoll);
    if (mitZielen) {
      setErreicht((alt) => aufgabe.ziele.map((ziel, i) => alt[i] || ziel.pruefe(a.zustand, neuesProtokoll)));
    }
  }

  function blaettern(richtung: -1 | 1) {
    const liste = z.verlauf;
    if (liste.length === 0) return;
    if (richtung === 1 && verlaufPos === null) return; // wie Bash: unter der neuesten Zeile geht es nicht weiter
    let pos: number | null;
    if (richtung === -1) pos = verlaufPos === null ? liste.length - 1 : Math.max(0, verlaufPos - 1);
    else pos = verlaufPos === null ? null : verlaufPos + 1 >= liste.length ? null : verlaufPos + 1;
    if (verlaufPos === null && pos !== null) setEntwurf(eingabe);
    const text = pos === null ? entwurf : liste[pos];
    setVerlaufPos(pos);
    cursorNachher.current = text.length;
    setEingabe(text);
  }

  function tab() {
    const feld = eingabeRef.current;
    const cursor = feld?.selectionStart ?? eingabe.length;
    const e = ergaenze(eingabe, cursor, z);
    if (e.vorschlaege.length > 0) {
      anhaengen([
        { id: naechsteId++, art: "eingabe", prompt: p, text: eingabe },
        { id: naechsteId++, art: "ausgabe", teile: [{ text: e.vorschlaege.join("  ") + "\n" }] },
      ]);
      return;
    }
    if (e.zeile !== eingabe) {
      cursorNachher.current = e.cursor;
      setEingabe(e.zeile);
    }
  }

  function einfuegen(zeichen: string) {
    const feld = eingabeRef.current;
    const von = feld?.selectionStart ?? eingabe.length;
    const bis = feld?.selectionEnd ?? eingabe.length;
    cursorNachher.current = von + zeichen.length;
    setEingabe(eingabe.slice(0, von) + zeichen + eingabe.slice(bis));
  }

  function onKeyDown(e: KeyboardEvent<HTMLInputElement>) {
    if (e.key !== "Tab" && e.key !== "Escape") setTabFrei(false);
    if (e.key === "Enter") {
      e.preventDefault();
      absenden();
    } else if (e.key === "ArrowUp") {
      e.preventDefault();
      blaettern(-1);
    } else if (e.key === "ArrowDown") {
      e.preventDefault();
      blaettern(1);
    } else if (e.key === "Tab") {
      if (tabFrei || e.shiftKey) return;
      e.preventDefault();
      tab();
    } else if (e.key === "PageUp" || e.key === "PageDown") {
      e.preventDefault();
      const schirm = schirmRef.current;
      if (schirm) schirm.scrollBy({ top: (e.key === "PageUp" ? -1 : 1) * schirm.clientHeight * 0.85 });
    } else if (e.key === "Escape") {
      setTabFrei(true);
    } else if (e.ctrlKey && !e.metaKey && e.key.toLowerCase() === "c") {
      const feld = e.currentTarget;
      if (feld.selectionStart !== feld.selectionEnd) return; // markierten Text kopieren
      e.preventDefault();
      anhaengen([{ id: naechsteId++, art: "eingabe", prompt: p, text: eingabe + "^C" }]);
      setEingabe("");
      setVerlaufPos(null);
      setEntwurf("");
    } else if (e.ctrlKey && !e.metaKey && e.key.toLowerCase() === "l") {
      e.preventDefault();
      anhaengen([], true);
    }
  }

  function taste(aktion: string) {
    if (aktion === "tab") tab();
    else if (aktion === "hoch") blaettern(-1);
    else if (aktion === "runter") blaettern(1);
    else einfuegen(aktion);
    eingabeRef.current?.focus({ preventScroll: true });
  }

  function zuruecksetzen() {
    setZ(aufgabe.szenario());
    setZeilen(begruessungsZeilen(aufgabe));
    setEingabe("");
    setProtokoll([]);
    setErreicht(aufgabe.ziele.map(() => false));
    setVerlaufPos(null);
    setEntwurf("");
    eingabeRef.current?.focus({ preventScroll: true });
  }

  // Klick in den Bildschirm setzt den Fokus in die Eingabe, ausser beim Markieren von Text
  function onSchirmKlick() {
    if (window.getSelection()?.toString()) return;
    eingabeRef.current?.focus({ preventScroll: true });
  }

  return (
    <div className="tk-block">
      <section className="tk-terminal" aria-label={titel} data-fertig={fertig ? "" : undefined}>
        <div className="tk-bar">
          <span className="tk-titel">
            <TerminalIcon />
            <span>
              {p.benutzer}: {p.pfad}
            </span>
          </span>
          <button type="button" className="tk-knopf" onClick={zuruecksetzen} aria-label={`Zurücksetzen: ${titel}`}>
            <ResetIcon />
            Zurücksetzen
          </button>
        </div>

        <div
          className="tk-schirm"
          ref={schirmRef}
          style={{ height: hoehe }}
          onClick={onSchirmKlick}
        >
          <span className="tk-mess" ref={messRef} aria-hidden="true">
            0000000000
          </span>
          <div role="log" aria-live="polite" aria-label="Ausgabe">
            {zeilen.map((zeile) =>
              zeile.art === "eingabe" ? (
                <div key={zeile.id} className="tk-zeile">
                  <PromptText p={zeile.prompt} />
                  {zeile.text}
                </div>
              ) : (
                <div key={zeile.id} className="tk-aus">
                  {zeile.teile.map((t, i) =>
                    t.stil ? (
                      <span key={i} className={STIL_KLASSE[t.stil]}>
                        {t.text}
                      </span>
                    ) : (
                      <span key={i}>{t.text}</span>
                    ),
                  )}
                </div>
              ),
            )}
          </div>
          <div className="tk-eingabe">
            <label htmlFor={eingabeId}>
              <span className="pk-sr">Befehl eingeben, Prompt: </span>
              <PromptText p={p} />
            </label>
            <input
              id={eingabeId}
              ref={eingabeRef}
              className="tk-input"
              type="text"
              value={eingabe}
              onChange={(e) => {
                setEingabe(e.target.value);
                setVerlaufPos(null);
              }}
              onKeyDown={onKeyDown}
              aria-describedby={hinweisId}
              autoComplete="off"
              autoCorrect="off"
              autoCapitalize="off"
              spellCheck={false}
              enterKeyHint="send"
            />
          </div>
        </div>

        <div className="tk-tasten" role="toolbar" aria-label="Sondertasten">
          {TASTEN.map((t) => (
            <button
              key={t.label}
              type="button"
              aria-label={t.aria ?? t.label}
              onPointerDown={(e) => e.preventDefault()}
              onClick={() => taste(t.aktion)}
            >
              {t.label}
            </button>
          ))}
        </div>
        <p className="tk-hilfe" id={hinweisId}>
          Enter führt aus, Tab ergänzt Namen, Pfeil hoch holt frühere Befehle, Bild hoch blättert zurück. Esc und dann Tab verlässt das Terminal.
        </p>
      </section>

      {mitZielen && (
        <div className="tk-ziele" data-fertig={fertig ? "" : undefined}>
          <p className="tk-ziele-titel">{aufgabe.zielTitel ?? "Ziele"}</p>
          <ul>
            {aufgabe.ziele.map((ziel, i) => (
              <li key={i} data-ok={erreicht[i] ? "" : undefined}>
                {erreicht[i] ? <HakenIcon /> : <OffenIcon />}
                <span>
                  {ziel.text}
                  <span className="pk-sr">{erreicht[i] ? " (erledigt)" : " (offen)"}</span>
                </span>
              </li>
            ))}
          </ul>
          <p className="tk-geschafft" role="status">
            {fertig ? (aufgabe.fertigText ?? "Geschafft, alle Ziele erreicht. Probier ruhig weiter aus, was dir einfällt.") : ""}
          </p>
          {aufgabe.tipps.length > 0 && (
            <div className="tk-tipps">
              {tipps > 0 && (
                <ul className="tk-tipp-liste">
                  {aufgabe.tipps.slice(0, tipps).map((t, i) => (
                    <li key={i}>
                      <strong>Tipp {i + 1}:</strong> {t}
                    </li>
                  ))}
                </ul>
              )}
              {tipps < aufgabe.tipps.length && !fertig && (
                <button type="button" className="tk-tipp-knopf" onClick={() => setTipps((n) => n + 1)}>
                  {tipps === 0 ? "Tipp anzeigen" : "Noch ein Tipp"}
                  <span className="tk-tipp-zahl">
                    {tipps + 1} von {aufgabe.tipps.length}
                  </span>
                </button>
              )}
            </div>
          )}
        </div>
      )}
    </div>
  );
}
