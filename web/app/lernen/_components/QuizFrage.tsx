"use client";

import { useState } from "react";

type Option = { text: string; richtig: boolean };

export default function QuizFrage({
  frage,
  optionen,
  erklaerung,
}: {
  frage: string;
  optionen: Option[];
  erklaerung: string;
}) {
  const [gewaehlt, setGewaehlt] = useState<number | null>(null);
  const beantwortet = gewaehlt !== null;
  const richtigIndex = optionen.findIndex((o) => o.richtig);
  const istRichtig = beantwortet && optionen[gewaehlt].richtig;

  return (
    <div
      style={{
        background: "var(--surface, #12121C)",
        border: "1px solid var(--border, rgba(255,255,255,0.08))",
        borderRadius: 16,
        padding: "22px 24px",
        margin: "18px 0",
      }}
    >
      <p
        style={{
          color: "var(--text, #F5F5F7)",
          fontWeight: 600,
          margin: "0 0 16px",
          fontSize: 17,
          lineHeight: 1.5,
        }}
      >
        {frage}
      </p>

      <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>
        {optionen.map((o, i) => {
          let bg = "var(--chip-bg, rgba(255,255,255,0.04))";
          let border = "1px solid var(--chip-border, rgba(255,255,255,0.12))";
          let color = "var(--text-body, #E0E0E8)";
          let mark = "";

          if (beantwortet) {
            if (i === richtigIndex) {
              bg = "var(--ok-bg, rgba(52,199,89,0.16))";
              border = "1px solid var(--ok-border, rgba(52,199,89,0.6))";
              color = "var(--ok-text, #B8F0C4)";
              mark = "  ✓";
            } else if (i === gewaehlt) {
              bg = "var(--err-bg, rgba(255,69,58,0.16))";
              border = "1px solid var(--err-border, rgba(255,69,58,0.6))";
              color = "var(--err-text, #FFC1BC)";
              mark = "  ✗";
            }
          }

          return (
            <button
              key={i}
              onClick={() => {
                if (!beantwortet) setGewaehlt(i);
              }}
              disabled={beantwortet}
              style={{
                textAlign: "left",
                padding: "12px 16px",
                borderRadius: 10,
                background: bg,
                border,
                color,
                fontSize: 15,
                cursor: beantwortet ? "default" : "pointer",
                fontFamily: "inherit",
                transition: "background .12s ease, border-color .12s ease",
              }}
            >
              {o.text}
              {mark}
            </button>
          );
        })}
      </div>

      {beantwortet && (
        <div style={{ marginTop: 16 }}>
          <p
            style={{
              color: istRichtig ? "var(--ok, #5FD98A)" : "var(--err, #FF6B63)",
              fontWeight: 600,
              margin: "0 0 6px",
              fontSize: 16,
            }}
          >
            {istRichtig ? "Richtig!" : "Nicht ganz."}
          </p>
          <p
            style={{
              color: "var(--text-body, #C8C8D2)",
              margin: 0,
              fontSize: 15,
              lineHeight: 1.6,
            }}
          >
            {erklaerung}
          </p>
          <button
            onClick={() => setGewaehlt(null)}
            style={{
              marginTop: 14,
              padding: "8px 16px",
              borderRadius: 8,
              background: "var(--accent-soft, rgba(124,109,255,0.14))",
              border: "1px solid var(--accent, #7C6DFF)",
              color: "var(--accent-text, #C4BBFF)",
              fontSize: 14,
              cursor: "pointer",
              fontFamily: "inherit",
            }}
          >
            Nochmal versuchen
          </button>
        </div>
      )}
    </div>
  );
}
