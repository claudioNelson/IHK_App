// Zusaetzliche SVG-Icons fuer den Python-Kurs (Pfade aus dem Sprite der
// Kurs-Mockups, 24er-Raster, Strich in currentColor). Ergaenzt LsIcons um das,
// was die Lernseiten nicht brauchen. Alle Icons sind dekorativ (aria-hidden).

import type { ReactNode } from "react";

function Svg({
  children,
  className,
  gefuellt = false,
}: {
  children: ReactNode;
  className?: string;
  gefuellt?: boolean;
}) {
  return (
    <svg
      className={className}
      viewBox="0 0 24 24"
      fill={gefuellt ? "currentColor" : "none"}
      stroke="currentColor"
      strokeWidth={2}
      strokeLinecap="round"
      strokeLinejoin="round"
      aria-hidden="true"
      focusable="false"
    >
      {children}
    </svg>
  );
}

export function PfeilLinksIcon() {
  return (
    <Svg>
      <path d="M19 12H5M11 6l-6 6 6 6" />
    </Svg>
  );
}

export function PlayIcon() {
  return (
    <Svg gefuellt>
      <path d="M7 5.5v13l11-6.5z" />
    </Svg>
  );
}

export function ResetIcon() {
  return (
    <Svg>
      <path d="M3 12a9 9 0 1 0 3-6.7" />
      <path d="M3 4v5h5" />
    </Svg>
  );
}

export function DateiIcon() {
  return (
    <Svg>
      <path d="M14 3H7a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V8z" />
      <path d="M14 3v5h5" />
      <path d="M10 13l-2 2 2 2M14 13l2 2-2 2" />
    </Svg>
  );
}

export function TerminalIcon() {
  return (
    <Svg>
      <path d="M5 7l5 5-5 5M12 19h7" />
    </Svg>
  );
}

export function FehlerIcon() {
  return (
    <Svg>
      <circle cx="12" cy="12" r="9" />
      <path d="M12 7.5v5M12 16h.01" />
    </Svg>
  );
}

export function UhrIcon() {
  return (
    <Svg>
      <circle cx="12" cy="12" r="9" />
      <path d="M12 7v5l3 2" />
    </Svg>
  );
}

export function GamepadIcon() {
  return (
    <Svg>
      <path d="M7.5 8h9a5 5 0 0 1 4.9 6l-.5 2.6a2.4 2.4 0 0 1-4.2 1L15 16H9l-1.7 1.6a2.4 2.4 0 0 1-4.2-1L2.6 14a5 5 0 0 1 4.9-6z" />
      <path d="M7 11v3M5.5 12.5h3M15.5 12h.01M17.5 13.5h.01" />
    </Svg>
  );
}

export function BrowserIcon() {
  return (
    <Svg>
      <rect x="3" y="4" width="18" height="16" rx="2" />
      <path d="M3 9h18M7 6.5h.01M10 6.5h.01" />
    </Svg>
  );
}

export function ListeIcon() {
  return (
    <Svg>
      <path d="M9 6h11M9 12h11M9 18h11M4.5 6h.01M4.5 12h.01M4.5 18h.01" />
    </Svg>
  );
}

/** Plus am Ende der Loesungs-Zeile, dreht sich per CSS zum Kreuz.
    Eigene Variante, weil PlusIcon aus LsIcons keine Klasse annimmt. */
export function LoesungPlusIcon() {
  return (
    <Svg className="pk-loesung-plus">
      <path d="M12 5v14M5 12h14" />
    </Svg>
  );
}
