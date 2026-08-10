"use client";

// Interaktiver Python-Editor für den Programmierkurs.
// Führt echten Python-Code direkt im Browser aus (Pyodide/WebAssembly),
// komplett clientseitig — kein Server nötig.

import { useRef, useState } from "react";

// Pyodide wird nur EINMAL pro Seite geladen (geteiltes Promise auf window).
declare global {
  interface Window {
    loadPyodide?: (opts: { indexURL: string }) => Promise<any>;
    __pyodidePromise?: Promise<any>;
  }
}

const PYODIDE_VERSION = "0.26.4";
const PYODIDE_BASE = `https://cdn.jsdelivr.net/pyodide/v${PYODIDE_VERSION}/full/`;

function getPyodide(): Promise<any> {
  if (typeof window === "undefined") return Promise.reject();
  if (window.__pyodidePromise) return window.__pyodidePromise;

  window.__pyodidePromise = new Promise((resolve, reject) => {
    const boot = () => {
      window
        .loadPyodide!({ indexURL: PYODIDE_BASE })
        .then(async (py: any) => {
          // input() → Browser-Prompt, damit interaktive Programme laufen
          await py.runPythonAsync(
            `import builtins\nfrom js import window\ndef _input(prompt=""):\n    res = window.prompt(str(prompt))\n    return "" if res is None else str(res)\nbuiltins.input = _input\n`
          );
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
  return window.__pyodidePromise;
}

export default function PythonRunner({
  initialCode,
  rows = 8,
}: {
  initialCode: string;
  rows?: number;
}) {
  const [code, setCode] = useState(initialCode.trimEnd());
  const [output, setOutput] = useState<string | null>(null);
  const [isError, setIsError] = useState(false);
  const [status, setStatus] = useState<"idle" | "loading" | "running">("idle");
  const taRef = useRef<HTMLTextAreaElement>(null);

  async function run() {
    setIsError(false);
    setOutput(null);

    try {
      setStatus("loading");
      const py = await getPyodide();
      setStatus("running");

      let out = "";
      py.setStdout({ batched: (line: string) => (out += line + "\n") });
      py.setStderr({ batched: (line: string) => (out += line + "\n") });

      await py.runPythonAsync(code);
      setOutput(out.trimEnd() === "" ? "(keine Ausgabe)" : out.trimEnd());
    } catch (err: any) {
      // Nur den Python-Fehler zeigen, nicht den JS-Stacktrace
      const msg = String(err?.message ?? err);
      const pyPart = msg.includes("Traceback")
        ? msg.slice(msg.indexOf("Traceback"))
        : msg;
      setOutput(pyPart.trim());
      setIsError(true);
    } finally {
      setStatus("idle");
    }
  }

  // Tab-Taste rückt ein statt das Feld zu verlassen
  function onKeyDown(e: React.KeyboardEvent<HTMLTextAreaElement>) {
    if (e.key === "Tab") {
      e.preventDefault();
      const ta = taRef.current!;
      const { selectionStart: s, selectionEnd: eN } = ta;
      const next = code.slice(0, s) + "    " + code.slice(eN);
      setCode(next);
      requestAnimationFrame(() => {
        ta.selectionStart = ta.selectionEnd = s + 4;
      });
    }
  }

  // Der Editor hat bewusst eine EIGENE dunkle Farbwelt (Terminal-Look,
  // GitHub-Dark-Palette), damit er sich klar vom Seitenhintergrund abhebt —
  // im Dunkel-Modus durch den blauen Unterton + hellere Kopfleiste,
  // im Hell-Modus als dunkler Codeblock.
  return (
    <div
      style={{
        border: "1px solid rgba(139,148,158,0.3)",
        borderRadius: 14,
        overflow: "hidden",
        margin: "18px 0",
        background: "#0D1117",
        boxShadow: "0 6px 24px rgba(0,0,0,0.35)",
      }}
    >
      <div
        style={{
          display: "flex",
          justifyContent: "space-between",
          alignItems: "center",
          padding: "8px 14px",
          background: "#161B26",
          borderBottom: "1px solid rgba(139,148,158,0.25)",
        }}
      >
        <span
          style={{
            fontSize: 12,
            letterSpacing: "0.08em",
            textTransform: "uppercase",
            color: "#8B949E",
            fontFamily: "var(--font-geist-mono), ui-monospace, monospace",
          }}
        >
          Python-Editor
        </span>
        <div style={{ display: "flex", gap: 8 }}>
          <button
            onClick={() => {
              setCode(initialCode.trimEnd());
              setOutput(null);
              setIsError(false);
            }}
            style={{
              padding: "6px 12px",
              borderRadius: 8,
              background: "transparent",
              border: "1px solid rgba(139,148,158,0.4)",
              color: "#8B949E",
              fontSize: 13,
              cursor: "pointer",
              fontFamily: "inherit",
            }}
          >
            Zurücksetzen
          </button>
          <button
            onClick={run}
            disabled={status !== "idle"}
            style={{
              padding: "6px 16px",
              borderRadius: 8,
              background: "#7C6DFF",
              border: "none",
              color: "#fff",
              fontWeight: 600,
              fontSize: 13,
              cursor: status === "idle" ? "pointer" : "wait",
              fontFamily: "inherit",
              opacity: status === "idle" ? 1 : 0.7,
            }}
          >
            {status === "loading"
              ? "Python lädt…"
              : status === "running"
                ? "Läuft…"
                : "▶ Ausführen"}
          </button>
        </div>
      </div>

      <textarea
        ref={taRef}
        value={code}
        onChange={(e) => setCode(e.target.value)}
        onKeyDown={onKeyDown}
        rows={rows}
        spellCheck={false}
        style={{
          display: "block",
          width: "100%",
          resize: "vertical",
          padding: "14px 16px",
          background: "transparent",
          border: "none",
          outline: "none",
          color: "#E6EDF3",
          caretColor: "#7C6DFF",
          fontFamily: "var(--font-geist-mono), ui-monospace, monospace",
          fontSize: 14.5,
          lineHeight: 1.6,
          tabSize: 4,
        }}
      />

      {status === "loading" && (
        <div
          style={{
            padding: "10px 16px",
            borderTop: "1px solid rgba(139,148,158,0.25)",
            color: "#8B949E",
            fontSize: 13.5,
          }}
        >
          Python wird einmalig im Browser geladen (ein paar Sekunden). Danach
          laufen alle Übungen sofort.
        </div>
      )}

      {output !== null && (
        <div
          style={{
            borderTop: "1px solid rgba(139,148,158,0.25)",
            background: "#0A0E14",
          }}
        >
          <div
            style={{
              padding: "8px 16px 0",
              fontSize: 11,
              letterSpacing: "0.08em",
              textTransform: "uppercase",
              color: isError ? "#FF6B63" : "#8B949E",
              fontFamily: "var(--font-geist-mono), ui-monospace, monospace",
            }}
          >
            {isError ? "Fehler" : "Ausgabe"}
          </div>
          <pre
            style={{
              margin: 0,
              padding: "6px 16px 14px",
              color: isError ? "#FFC1BC" : "#E6EDF3",
              fontFamily: "var(--font-geist-mono), ui-monospace, monospace",
              fontSize: 14,
              lineHeight: 1.55,
              whiteSpace: "pre-wrap",
              overflowX: "auto",
            }}
          >
            {output}
          </pre>
        </div>
      )}
    </div>
  );
}
