"use client";

// Eine Quizfrage mit sofortigem Feedback (.ls-quiz, nach mockup-thema.html).
// Buchstaben-Marker A bis D, SVG-Haken bzw. -Kreuz, nicht gewaehlte Antworten
// werden abgeblendet, Feedback per aria-live. "Nochmal versuchen" setzt den
// Fokus auf die erste Antwort.
//
// Props frage/optionen/erklaerung bleiben wie bisher (rund 50 Aufrufe).
// Neu und optional: nr und von fuer den Zaehler "1 / 5".

import { useEffect, useRef, useState } from "react";
import { HakenIcon, KreuzIcon, LeerIcon } from "./LsIcons";

type Option = { text: string; richtig: boolean };

const BUCHSTABEN = "ABCDEFGH";

export default function QuizFrage({
  frage,
  optionen,
  erklaerung,
  nr,
  von,
}: {
  frage: string;
  optionen: Option[];
  erklaerung: string;
  nr?: number;
  von?: number;
}) {
  const [gewaehlt, setGewaehlt] = useState<number | null>(null);
  const ersteOption = useRef<HTMLButtonElement>(null);
  const fokusNachReset = useRef(false);

  const beantwortet = gewaehlt !== null;
  const istRichtig = beantwortet && optionen[gewaehlt].richtig;

  // Fokus erst setzen, wenn die Buttons wieder aktiv sind (disabled ist nicht fokussierbar)
  useEffect(() => {
    if (!beantwortet && fokusNachReset.current) {
      fokusNachReset.current = false;
      ersteOption.current?.focus();
    }
  }, [beantwortet]);

  function zustand(i: number): "ok" | "err" | "off" | undefined {
    if (!beantwortet) return undefined;
    if (optionen[i].richtig) return "ok";
    if (i === gewaehlt) return "err";
    return "off";
  }

  return (
    <div className="ls-quiz">
      <div className="ls-quiz-head">
        {nr !== undefined && (
          <span>
            {nr}
            {von !== undefined ? ` / ${von}` : ""}
          </span>
        )}
        <p className="ls-quiz-q">{frage}</p>
      </div>

      <ul className="ls-quiz-opts" role="group" aria-label="Antworten">
        {optionen.map((o, i) => {
          const z = zustand(i);
          return (
            <li key={i}>
              <button
                ref={i === 0 ? ersteOption : undefined}
                className="ls-opt"
                type="button"
                disabled={beantwortet}
                data-state={z}
                onClick={() => {
                  if (!beantwortet) setGewaehlt(i);
                }}
              >
                <b>{BUCHSTABEN[i] ?? i + 1}</b>
                <span>{o.text}</span>
                {z === "ok" ? <HakenIcon /> : z === "err" ? <KreuzIcon /> : <LeerIcon />}
              </button>
            </li>
          );
        })}
      </ul>

      {/* Live-Region bleibt immer im DOM, sonst wird das Feedback nicht sicher vorgelesen */}
      <div aria-live="polite">
        {beantwortet && (
          <div className="ls-quiz-fb in" data-result={istRichtig ? "ok" : "err"}>
            <p className="ls-quiz-verdict">
              {istRichtig ? "Richtig." : "Nicht ganz. Die richtige Antwort ist markiert."}
            </p>
            <p className="ls-quiz-expl">{erklaerung}</p>
            <button
              className="btn btn-ghost btn-sm"
              type="button"
              onClick={() => {
                fokusNachReset.current = true;
                setGewaehlt(null);
              }}
            >
              Nochmal versuchen
            </button>
          </div>
        )}
      </div>
    </div>
  );
}
