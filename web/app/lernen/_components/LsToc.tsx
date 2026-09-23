"use client";

// Sprungmarken der Seitenleiste (.ls-toc). Markiert den Abschnitt, der gerade
// oben im Lesebereich steht, per IntersectionObserver (kein Scroll-Listener).
// Ohne JavaScript bleibt es eine normale Linkliste.

import { useEffect, useState } from "react";

export type Abschnitt = { id: string; titel: string };

export default function LsToc({
  titel,
  abschnitte,
}: {
  titel: string;
  abschnitte: Abschnitt[];
}) {
  const [aktiv, setAktiv] = useState<string | null>(null);
  // Stabiler Schluessel, damit der Effekt nicht bei jedem Render neu startet
  const ids = abschnitte.map((a) => a.id).join("|");

  useEffect(() => {
    if (!ids || typeof IntersectionObserver === "undefined") return;
    const reihenfolge = ids.split("|");
    const sichtbar: Record<string, boolean> = {};

    const io = new IntersectionObserver(
      (eintraege) => {
        for (const e of eintraege) sichtbar[e.target.id] = e.isIntersecting;
        const erster = reihenfolge.find((id) => sichtbar[id]);
        if (erster) setAktiv(erster);
      },
      { rootMargin: "-80px 0px -60% 0px", threshold: 0 },
    );

    for (const id of reihenfolge) {
      const el = document.getElementById(id);
      if (el) io.observe(el);
    }
    return () => io.disconnect();
  }, [ids]);

  return (
    <div>
      <p className="ls-toc-title">{titel}</p>
      <ul className="ls-toc">
        {abschnitte.map((a) => (
          <li key={a.id}>
            <a href={`#${a.id}`} aria-current={aktiv === a.id ? "true" : undefined}>
              {a.titel}
            </a>
          </li>
        ))}
      </ul>
    </div>
  );
}
