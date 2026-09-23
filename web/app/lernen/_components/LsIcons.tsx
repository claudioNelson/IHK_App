// SVG-Icons der Lernseiten (aus den Mockups, 24er-Raster, Strich in currentColor).
// Reine Darstellung ohne State, nutzbar in Server- und Client-Komponenten.
// Alle Icons sind dekorativ (aria-hidden); die Bedeutung steht immer im Text.

import type { ReactNode } from "react";

function Svg({ children, strich = 2 }: { children: ReactNode; strich?: number }) {
  return (
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth={strich}
      strokeLinecap="round"
      strokeLinejoin="round"
      aria-hidden="true"
      focusable="false"
    >
      {children}
    </svg>
  );
}

/* ---- Navigation und Listen ---- */

export function PfeilIcon() {
  return (
    <Svg>
      <path d="M5 12h14M13 6l6 6-6 6" />
    </Svg>
  );
}

export function PlusIcon() {
  return (
    <Svg>
      <path d="M12 5v14M5 12h14" />
    </Svg>
  );
}

/* ---- Quiz ---- */

export function HakenIcon() {
  return (
    <Svg strich={2.2}>
      <path d="M5 12l4 4L19 6" />
    </Svg>
  );
}

export function KreuzIcon() {
  return (
    <Svg strich={2.2}>
      <path d="M6 6l12 12M18 6L6 18" />
    </Svg>
  );
}

/** Leeres Icon: haelt in nicht markierten Antworten den Platz frei. */
export function LeerIcon() {
  return <Svg strich={2.2}>{null}</Svg>;
}

/* ---- Hinweisboxen (.ls-note) ---- */

export type NoteIconName = "idee" | "haus" | "buch" | "stapel" | "warnung";

export function NoteIcon({ name }: { name: NoteIconName }) {
  switch (name) {
    case "haus":
      return (
        <Svg>
          <path d="M3 21h18" />
          <path d="M5 21V7l7-4 7 4v14" />
          <path d="M9 21v-5h6v5" />
          <path d="M9 10h.01M15 10h.01M9 14h.01M15 14h.01" />
        </Svg>
      );
    case "buch":
      return (
        <Svg>
          <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
          <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" />
        </Svg>
      );
    case "stapel":
      return (
        <Svg>
          <ellipse cx="12" cy="5" rx="8" ry="3" />
          <path d="M4 5v14c0 1.7 3.6 3 8 3s8-1.3 8-3V5" />
          <path d="M4 12c0 1.7 3.6 3 8 3s8-1.3 8-3" />
        </Svg>
      );
    case "warnung":
      return (
        <Svg>
          <path d="M10.3 3.9 1.8 18a2 2 0 0 0 1.7 3h17a2 2 0 0 0 1.7-3L13.7 3.9a2 2 0 0 0-3.4 0z" />
          <path d="M12 9v4M12 17h.01" />
        </Svg>
      );
    case "idee":
    default:
      return (
        <Svg>
          <path d="M9 18h6" />
          <path d="M10 22h4" />
          <path d="M12 2a7 7 0 0 0-4 12.7c.6.5 1 1.3 1 2.1V17h6v-.2c0-.8.4-1.6 1-2.1A7 7 0 0 0 12 2z" />
        </Svg>
      );
  }
}

/* ---- Meta-Zeile im Seitenkopf (.ls-meta) ---- */

export type MetaIconName = "zeit" | "rechner" | "quiz" | "pruefung" | "themen" | "offen";

export function MetaIcon({ name }: { name: MetaIconName }) {
  switch (name) {
    case "zeit":
      return (
        <Svg>
          <circle cx="12" cy="12" r="9" />
          <path d="M12 7v5l3 2" />
        </Svg>
      );
    case "rechner":
      return (
        <Svg>
          <rect x="4" y="3" width="16" height="18" rx="2" />
          <path d="M8 7h8M8 11h8M8 15h5" />
        </Svg>
      );
    case "quiz":
      return (
        <Svg>
          <path d="M9 11l3 3L22 4" />
          <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11" />
        </Svg>
      );
    case "pruefung":
      return (
        <Svg>
          <path d="M4 19h16M6 19V9m6 10V5m6 14v-7" />
        </Svg>
      );
    case "themen":
      return (
        <Svg>
          <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
          <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" />
        </Svg>
      );
    case "offen":
    default:
      return (
        <Svg>
          <rect x="3" y="11" width="18" height="10" rx="2" />
          <path d="M7 11V7a5 5 0 0 1 10 0v4" />
        </Svg>
      );
  }
}
