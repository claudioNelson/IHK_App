// Inline-SVG-Icons der Pruefungsseiten (Strich wie auf der Startseite).
// Ersetzt die frueheren Emoji- und Textzeichen-Icons. Immer aria-hidden,
// die Bedeutung steht daneben als Text.

import type { CSSProperties, ReactNode } from "react";

export type IconName =
  | "clock" | "list" | "arrow-l" | "arrow-r" | "lock" | "check" | "check-c"
  | "play" | "refresh" | "ban" | "chat" | "bulb" | "zoom" | "alert" | "chev"
  | "x" | "x-c" | "part" | "print" | "trend" | "book" | "sun" | "moon";

const PATHS: Record<IconName, ReactNode> = {
  clock: (<><circle cx="12" cy="12" r="9" /><path d="M12 7v5l3 2" /></>),
  list: <path d="M9 6h11M9 12h11M9 18h11M4.5 6h.01M4.5 12h.01M4.5 18h.01" />,
  "arrow-l": <path d="M19 12H5M11 6l-6 6 6 6" />,
  "arrow-r": <path d="M5 12h14M13 6l6 6-6 6" />,
  lock: (<><rect x="4.5" y="11" width="15" height="10" rx="2" /><path d="M8 11V7.5a4 4 0 0 1 8 0V11" /></>),
  check: <path d="M5 12l4 4L19 6" />,
  "check-c": (<><circle cx="12" cy="12" r="9" /><path d="M8 12.5l2.7 2.7L16 9.8" /></>),
  play: (<><circle cx="12" cy="12" r="9" /><path d="M10 8.5l5 3.5-5 3.5z" /></>),
  refresh: (<><path d="M20.5 12a8.5 8.5 0 1 1-2.8-6.3" /><path d="M20.5 3.5v5h-5" /></>),
  ban: (<><circle cx="12" cy="12" r="9" /><path d="M5.7 5.7l12.6 12.6" /></>),
  chat: <path d="M20 15a2 2 0 0 1-2 2H8l-4 4V6a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2z" />,
  bulb: (<><path d="M9 18h6M10 21.5h4" /><path d="M12 2.5a6.5 6.5 0 0 0-3.8 11.8c.5.4.8 1 .8 1.7h6c0-.7.3-1.3.8-1.7A6.5 6.5 0 0 0 12 2.5z" /></>),
  zoom: (<><circle cx="11" cy="11" r="7" /><path d="M20 20l-3.8-3.8M11 8v6M8 11h6" /></>),
  alert: (<><circle cx="12" cy="12" r="9" /><path d="M12 7.5v5.5M12 16.5h.01" /></>),
  chev: <path d="M6 9l6 6 6-6" />,
  x: <path d="M6 6l12 12M18 6L6 18" />,
  "x-c": (<><circle cx="12" cy="12" r="9" /><path d="M15 9l-6 6M9 9l6 6" /></>),
  part: (<><circle cx="12" cy="12" r="9" /><path d="M12 3a9 9 0 0 1 0 18z" fill="currentColor" stroke="none" /></>),
  print: (<><path d="M7 8V3h10v5" /><rect x="3.5" y="8" width="17" height="9" rx="2" /><path d="M7 14h10v7H7z" /></>),
  trend: (<><path d="M3 17l6-6 4 4 8-8" /><path d="M15 7h6v6" /></>),
  book: (<><path d="M4 19.5V5a2 2 0 0 1 2-2h14v15H6a2 2 0 0 0-2 2z" /><path d="M4 19.5A1.5 1.5 0 0 0 5.5 21H20" /></>),
  sun: (<><circle cx="12" cy="12" r="4" /><path d="M12 2v2M12 20v2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M2 12h2M20 12h2M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4" /></>),
  moon: <path d="M21 12.8A9 9 0 1 1 11.2 3a7 7 0 0 0 9.8 9.8z" />,
};

/**
 * Standard ist die Klasse "ex-icon" (16px, an der Schriftlinie). Fuer SVGs,
 * die ihre Groesse vom Elternelement bekommen (.btn svg, .ex-leave svg, ...),
 * `className={null}` uebergeben.
 */
export default function Icon({
  name,
  className = "ex-icon",
  style,
}: {
  name: IconName;
  className?: string | null;
  style?: CSSProperties;
}) {
  return (
    <svg
      className={className ?? undefined}
      style={style}
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth={name === "check" ? 2.2 : 2}
      strokeLinecap="round"
      strokeLinejoin="round"
      aria-hidden="true"
      focusable="false"
    >
      {PATHS[name]}
    </svg>
  );
}
