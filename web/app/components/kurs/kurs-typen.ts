// Gemeinsame Typen und Helfer fuer die Web-Kurse (Python-Kurs, UML-Kurs).
// Jeder Kurs beschreibt sich mit einem Kurs-Objekt; LektionLayout,
// KursplanNav und die Uebersichtsseiten lesen daraus Pfad-Basis, Titel und
// Lektionsliste.

export type Lektion = {
  nr: number;
  slug: string;
  /** Kurztitel ohne "Lektion n", bei Projekten ohne "Projekt:" */
  titel: string;
  /** Eine Zeile fuer den Kursplan */
  untertitel: string;
  /** Geschaetzte Dauer in Minuten */
  dauer: number;
  /** Hervorgehobene Lektion im Kursplan (Akzentflaeche plus Marke) */
  projekt: boolean;
  /**
   * Text der Marke im Kursplan, Standard "Projekt". Ist marke gesetzt,
   * bleibt der Titel ohne Praefix (z. B. "Prüfungstraining" mit Marke
   * "Prüfung"); ohne marke wird ein Projekt als "Projekt: titel" angezeigt.
   */
  marke?: string;
};

export type Kurs = {
  /** Pfad-Basis, die Lektionen liegen unter /{slug}/{lektion.slug} */
  slug: "python-kurs" | "uml-kurs" | "struktogramm-kurs";
  /** Kurzname fuer den Pfad (Breadcrumb), z. B. "Python-Kurs" */
  titel: string;
  lektionen: Lektion[];
  /** Meta-Zeile der Lektionen: wo bzw. womit gearbeitet wird */
  lernort: { text: string; icon: "browser" | "stift" };
  /** Hinweis unter dem Kursplan in der Seitenleiste der Lektionen */
  seitenNotiz: string;
};

/** Titel fuer Seitenleiste, h1 und Vor/Zurueck: Projekte mit "Projekt:" davor. */
export function anzeigeTitel(l: Lektion): string {
  return l.projekt && !l.marke ? `Projekt: ${l.titel}` : l.titel;
}

/** Text der Kursplan-Marke einer hervorgehobenen Lektion. */
export function markeText(l: Lektion): string {
  return l.marke ?? "Projekt";
}

/** Zweistellige Nummer fuer Kursplan und Seitenleiste, z. B. "01". */
export function nrText(nr: number): string {
  return String(nr).padStart(2, "0");
}
