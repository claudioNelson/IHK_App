"use client";

// Kursplan in der Seitenleiste einer Lektion (.ls-toc mit Nummern), aktuelle
// Lektion mit aria-current="page". Unter 1024px wird daraus die scrollbare
// Chip-Reihe aus lernen.css; dort wird die aktive Lektion beim Laden in die
// Mitte der Reihe geschoben (nur waagerecht, die Seite springt nicht).

import { useEffect, useRef } from "react";
import Link from "next/link";
import { anzeigeTitel, lektionen, nrText } from "./lektionen";

export default function KursplanNav({ aktuell }: { aktuell: number }) {
  const listeRef = useRef<HTMLOListElement>(null);

  useEffect(() => {
    const liste = listeRef.current;
    const aktiv = liste?.querySelector<HTMLElement>('a[aria-current="page"]');
    if (!liste || !aktiv) return;
    // Nur in der Chip-Reihe (waagerecht scrollbar), nicht in der Desktop-Leiste
    if (liste.scrollWidth <= liste.clientWidth) return;
    const chip = aktiv.getBoundingClientRect();
    const reihe = liste.getBoundingClientRect();
    liste.scrollLeft += chip.left + chip.width / 2 - (reihe.left + reihe.width / 2);
  }, [aktuell]);

  return (
    <nav aria-label="Lektionen">
      <p className="ls-toc-title">Kursplan</p>
      <ol className="ls-toc" ref={listeRef}>
        {lektionen.map((l) => (
          <li key={l.slug}>
            <Link
              href={`/python-kurs/${l.slug}`}
              aria-current={l.nr === aktuell ? "page" : undefined}
            >
              <span className="pk-toc-nr">{nrText(l.nr)}</span>
              {anzeigeTitel(l)}
            </Link>
          </li>
        ))}
      </ol>
    </nav>
  );
}
