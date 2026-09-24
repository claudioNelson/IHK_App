"use client";

// Interaktiver Python-Editor fuer den Programmierkurs. Markup, Zustaende und
// Tastatur nach kurs-design/mockup-lektion.html und runner.js; die Farben kommen
// aus kurs.css (--pk-run-*, in beiden Themes dunkel).
// Fuehrt echten Python-Code direkt im Browser aus (Pyodide/WebAssembly),
// komplett clientseitig, kein Server noetig.
//
// Zustaende (data-state): idle, loading (Pyodide wird geladen), running, done,
// error. Die Ausgabe ist eine Live-Region (role="status", aria-live="polite").
// Tastatur: Tab rueckt ein, Umschalt+Tab rueckt aus, Esc gibt Tab frei (das
// naechste Tab verlaesst den Editor), Strg/Cmd+Enter fuehrt aus.

import { useEffect, useId, useRef, useState, type KeyboardEvent } from "react";
import { DateiIcon, FehlerIcon, PlayIcon, ResetIcon, TerminalIcon, UhrIcon } from "../../components/kurs/KursIcons";

// Pyodide wird nur EINMAL pro Seite geladen (geteiltes Promise auf window).
declare global {
  interface Window {
    loadPyodide?: (opts: { indexURL: string }) => Promise<any>;
    __pyodidePromise?: Promise<any>;
  }
}

const PYODIDE_VERSION = "0.26.4";
const PYODIDE_BASE = `https://cdn.jsdelivr.net/pyodide/v${PYODIDE_VERSION}/full/`;
const EINRUECKUNG = "    ";

// Merkt sich, ob Pyodide schon bereitsteht (dann ohne Ladezustand ausfuehren).
let pyodideBereit = false;

function getPyodide(): Promise<any> {
  if (typeof window === "undefined") return Promise.reject();
  if (window.__pyodidePromise) return window.__pyodidePromise;

  const promise = new Promise<any>((resolve, reject) => {
    const boot = () => {
      window
        .loadPyodide!({ indexURL: PYODIDE_BASE })
        .then(async (py: any) => {
          // input() ruft den Browser-Prompt auf, damit interaktive Programme laufen
          await py.runPythonAsync(
            `import builtins\nfrom js import window\ndef _input(prompt=""):\n    res = window.prompt(str(prompt))\n    return "" if res is None else str(res)\nbuiltins.input = _input\n`
          );
          pyodideBereit = true;
          resolve(py);
        })
        .catch(reject);
    };

    if (window.loadPyodide) {
      boot();
    } else {
      const s = document.createElement("script");
      s.src = `${PYODIDE_BASE}pyodide.js`;
      s.onload = boot;
      s.onerror = () => reject(new Error("Pyodide konnte nicht geladen werden"));
      document.head.appendChild(s);
    }
  });

  // Nach einem Ladefehler beim naechsten Klick neu versuchen
  promise.catch(() => {
    if (window.__pyodidePromise === promise) window.__pyodidePromise = undefined;
  });

  window.__pyodidePromise = promise;
  return promise;
}

/** Wartet, bis der Browser einmal gezeichnet hat (damit "Läuft" sichtbar wird,
    bevor synchroner Python-Code den Hauptthread belegt). */
function nachZeichnen(): Promise<void> {
  return new Promise((r) => requestAnimationFrame(() => setTimeout(r, 0)));
}

/** Startcode: Leerraum am Ende weg, eine abschliessende Leerzeile bleibt
    (damit man bei "# Dein Code:" direkt in der naechsten Zeile tippt). */
function startCode(code: string): string {
  return code.replace(/\s+$/, (rest) => (rest.includes("\n") ? "\n" : ""));
}

type Zustand = "idle" | "loading" | "running" | "done" | "error";

const KOPF: Record<Exclude<Zustand, "idle">, string> = {
  loading: "Python lädt",
  running: "Läuft",
  done: "Ausgabe",
  error: "Fehler",
};

export default function PythonRunner({
  initialCode,
  rows = 8,
  dateiname = "main.py",
  label,
}: {
  initialCode: string;
  rows?: number;
  /** Name in der Werkzeugleiste, z. B. "uebung_1_1.py" */
  dateiname?: string;
  /** aria-label des Editors, z. B. "Python-Code: Übung 1.1" */
  label?: string;
}) {
  const start = startCode(initialCode);
  const taRef = useRef<HTMLTextAreaElement>(null);
  const outRef = useRef<HTMLDivElement>(null);
  const laeuftRef = useRef(false);
  const [zustand, setZustand] = useState<Zustand>("idle");
  const [ausgabe, setAusgabe] = useState("");
  const [wechsel, setWechsel] = useState(0);
  const [esc, setEsc] = useState(false);
  const hinweisId = useId();

  const beschaeftigt = zustand === "loading" || zustand === "running";

  function setze(z: Zustand, text?: string) {
    setZustand(z);
    if (text !== undefined) setAusgabe(text);
    setWechsel((n) => n + 1);
  }

  // Ausgabe bei jedem Zustandswechsel kurz einblenden (.in, 180ms). Dieselbe
  // Live-Region bleibt dabei im DOM, damit Screenreader die Aenderung ansagen.
  useEffect(() => {
    const el = outRef.current;
    if (!el || zustand === "idle") return;
    el.classList.remove("in");
    void el.offsetWidth;
    el.classList.add("in");
  }, [wechsel, zustand]);

  async function ausfuehren() {
    if (laeuftRef.current) return;
    laeuftRef.current = true;
    const code = taRef.current?.value ?? "";

    let py: any;
    try {
      if (!pyodideBereit) setze("loading");
      py = await getPyodide();
    } catch {
      setze(
        "error",
        "Python konnte nicht geladen werden. Prüf deine Internetverbindung und versuch es noch einmal."
      );
      laeuftRef.current = false;
      return;
    }

    setze("running");
    await nachZeichnen();

    let out = "";
    py.setStdout({ batched: (line: string) => (out += line + "\n") });
    py.setStderr({ batched: (line: string) => (out += line + "\n") });

    try {
      await py.runPythonAsync(code);
      setze("done", out.trimEnd() === "" ? "(keine Ausgabe)" : out.trimEnd());
    } catch (err: any) {
      // Nur den Python-Fehler zeigen, nicht den JS-Stacktrace
      const msg = String(err?.message ?? err);
      const pyPart = msg.includes("Traceback") ? msg.slice(msg.indexOf("Traceback")) : msg;
      setze("error", pyPart.trim());
    } finally {
      laeuftRef.current = false;
    }
  }

  function zuruecksetzen() {
    const ta = taRef.current;
    if (ta) {
      ta.value = start;
      ta.focus();
    }
    setze("idle");
  }

  function onKeyDown(e: KeyboardEvent<HTMLTextAreaElement>) {
    const ta = e.currentTarget;

    if ((e.ctrlKey || e.metaKey) && e.key === "Enter") {
      e.preventDefault();
      void ausfuehren();
      return;
    }
    if (e.key === "Escape") {
      setEsc(true);
      return;
    }
    if (e.key === "Tab" && !esc) {
      e.preventDefault();
      const s = ta.selectionStart;
      const en = ta.selectionEnd;
      const v = ta.value;
      const zeilenStart = v.lastIndexOf("\n", s - 1) + 1;
      if (e.shiftKey) {
        // Ausruecken: bis zu 4 Leerzeichen am Zeilenanfang entfernen
        let n = 0;
        while (n < 4 && v.charAt(zeilenStart + n) === " ") n++;
        if (!n) return;
        ta.setRangeText("", zeilenStart, zeilenStart + n, "preserve");
        ta.selectionStart = ta.selectionEnd = Math.max(zeilenStart, s - n);
      } else {
        ta.setRangeText(EINRUECKUNG, s, en, "end");
      }
      return;
    }
    if (e.key !== "Tab" && e.key !== "Shift" && esc) setEsc(false);
  }

  const KopfIcon =
    zustand === "error" ? FehlerIcon : zustand === "loading" || zustand === "running" ? UhrIcon : TerminalIcon;

  return (
    <div className="pk-runner" data-state={zustand} aria-busy={beschaeftigt}>
      <div className="pk-runner-bar">
        <span className="pk-runner-name">
          <DateiIcon />
          {dateiname}
        </span>
        <div className="pk-runner-actions">
          <button
            type="button"
            className="pk-runner-btn pk-runner-reset"
            aria-label="Code zurücksetzen"
            onClick={zuruecksetzen}
          >
            <ResetIcon />
            <span className="pk-hide-sm" aria-hidden="true">
              Zurücksetzen
            </span>
          </button>
          <button
            type="button"
            className="pk-runner-btn pk-runner-run"
            onClick={() => void ausfuehren()}
            disabled={beschaeftigt}
          >
            <PlayIcon />
            <span className="pk-run-label">
              {zustand === "loading" ? "Python lädt" : zustand === "running" ? "Läuft" : "Ausführen"}
            </span>
          </button>
        </div>
        <span className="pk-runner-load" aria-hidden="true" />
      </div>

      <textarea
        ref={taRef}
        className="pk-runner-code"
        defaultValue={start}
        rows={rows}
        spellCheck={false}
        autoCapitalize="off"
        autoComplete="off"
        autoCorrect="off"
        aria-label={label ?? `Python-Code: ${dateiname}`}
        aria-describedby={hinweisId}
        onKeyDown={onKeyDown}
        onFocus={() => setEsc(false)}
      />
      <p className="pk-runner-hint" id={hinweisId}>
        {esc ? (
          <span className="pk-runner-hint-text">
            <kbd>Tab</kbd> springt jetzt zum nächsten Element.
          </span>
        ) : (
          <span className="pk-runner-hint-text">
            <kbd>Tab</kbd> rückt ein. <kbd>Esc</kbd>, dann <kbd>Tab</kbd> verlässt den Editor.{" "}
            <kbd>Strg</kbd> + <kbd>Enter</kbd> führt aus.
          </span>
        )}
      </p>

      <div
        ref={outRef}
        className="pk-runner-out"
        role="status"
        aria-live="polite"
        hidden={zustand === "idle"}
      >
        <div className="pk-runner-out-head">
          <KopfIcon />
          <span>{zustand === "idle" ? "Ausgabe" : KOPF[zustand]}</span>
        </div>
        <p hidden={zustand !== "loading"}>
          Python wird einmalig im Browser geladen (ein paar Sekunden). Danach laufen alle Übungen
          sofort.
        </p>
        <pre hidden={zustand === "idle" || zustand === "loading" || zustand === "running"}>{ausgabe}</pre>
      </div>
    </div>
  );
}
