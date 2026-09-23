"use client";

// Bausteine fuer die Auth-Formulare: Hinweis-Kasten, Feldfehler,
// Passwortfeld (Anzeigen-Knopf und Staerke), Absende-Knopf mit Ladezustand,
// Trenner "oder" und der Google-Knopf. Styles in konto.css (kt-).

import { useState, type ReactNode } from "react";
import { createClient } from "@/lib/supabase/client";
import Icon, { GoogleLogo } from "./Icon";
import { FALLBACK, type Fehler } from "./fehler";

// Fokus nach dem naechsten Rendern setzen (Fehlerkasten oder erstes
// ungueltiges Feld), damit Screenreader den Fehler sofort vorlesen.
export function fokusAuf(id: string) {
  requestAnimationFrame(() => document.getElementById(id)?.focus());
}

// aria-describedby aus mehreren (optionalen) IDs zusammensetzen
export function beschreibung(...ids: (string | false | null | undefined)[]) {
  const s = ids.filter(Boolean).join(" ");
  return s || undefined;
}

export function Kasten({
  id,
  fehler,
  children,
}: {
  id: string;
  fehler: Pick<Fehler, "titel" | "text" | "warn">;
  children?: ReactNode;
}) {
  return (
    <div className={fehler.warn ? "kt-alert kt-alert-warn" : "kt-alert"} id={id} role="alert" tabIndex={-1}>
      <Icon name="alert" />
      <p>{fehler.titel}</p>
      {children ?? (fehler.text ? <p>{fehler.text}</p> : null)}
    </div>
  );
}

export function FeldFehler({ id, children, as = "p" }: { id: string; children: ReactNode; as?: "p" | "span" }) {
  const Tag = as;
  return (
    <Tag className="kt-error" id={id}>
      <Icon name="alert" />
      <span>{children}</span>
    </Tag>
  );
}

// Grobe Staerke 0..4, die eigentliche Pruefung macht Supabase (weak_password).
const WORTE = ["noch leer", "zu kurz", "geht so", "gut", "stark"];
export function staerke(v: string) {
  if (!v) return 0;
  if (v.length < 8) return 1;
  const arten = [/[a-z]/, /[A-Z]/, /[0-9]/, /[^A-Za-z0-9]/].filter((r) => r.test(v)).length;
  let stufe = 2;
  if (arten >= 3) stufe++;
  if (v.length >= 12 && arten >= 2) stufe++;
  return Math.min(stufe, 4);
}

export function PasswortFeld({
  id,
  label,
  value,
  onChange,
  autoComplete,
  mitStaerke = false,
  invalid = false,
  describedBy,
  readOnly = false,
  labelZusatz,
  fehler,
}: {
  id: string;
  label: string;
  value: string;
  onChange: (v: string) => void;
  autoComplete: "current-password" | "new-password";
  mitStaerke?: boolean;
  invalid?: boolean;
  describedBy?: string;
  readOnly?: boolean;
  labelZusatz?: ReactNode;
  fehler?: ReactNode;
}) {
  const [zeigen, setZeigen] = useState(false);
  const stufe = staerke(value);
  const meterId = `${id}-meter`;

  return (
    <div className="kt-field">
      {labelZusatz ? (
        <div className="kt-label-row">
          <label className="kt-label" htmlFor={id}>{label}</label>
          {labelZusatz}
        </div>
      ) : (
        <label className="kt-label" htmlFor={id}>{label}</label>
      )}
      <div className="kt-pass">
        <input
          className="kt-input"
          id={id}
          name="password"
          type={zeigen ? "text" : "password"}
          autoComplete={autoComplete}
          minLength={mitStaerke ? 8 : undefined}
          required
          value={value}
          onChange={(e) => onChange(e.target.value)}
          readOnly={readOnly}
          aria-invalid={invalid ? true : undefined}
          aria-describedby={beschreibung(mitStaerke && meterId, describedBy)}
        />
        <button
          className="kt-reveal"
          type="button"
          aria-pressed={zeigen}
          aria-controls={id}
          aria-label={zeigen ? "Passwort verbergen" : "Passwort anzeigen"}
          onClick={() => setZeigen((z) => !z)}
        >
          <Icon name="eye" className="i-eye" />
          <Icon name="eye-off" className="i-eye-off" />
        </button>
      </div>
      {mitStaerke && (
        <>
          <div className="kt-meter" data-level={stufe} aria-hidden="true">
            <span />
            <span />
            <span />
            <span />
          </div>
          <p className="kt-meter-text" id={meterId} aria-live="polite">
            <span>Mindestens 8 Zeichen</span>
            <span>
              Stärke: <b>{WORTE[stufe]}</b>
            </span>
          </p>
        </>
      )}
      {fehler}
    </div>
  );
}

export function SendenKnopf({
  busy,
  busyText,
  children,
  type = "submit",
  onClick,
  className = "btn btn-primary kt-submit",
}: {
  busy: boolean;
  busyText: string;
  children: ReactNode;
  type?: "submit" | "button";
  onClick?: () => void;
  className?: string;
}) {
  return (
    <button className={className} type={type} disabled={busy} aria-busy={busy || undefined} onClick={onClick}>
      {busy ? (
        <>
          <span className="kt-spin" aria-hidden="true" />
          {busyText}
        </>
      ) : (
        children
      )}
    </button>
  );
}

export function Oder() {
  return (
    <div className="kt-or" role="separator" aria-label="oder">
      oder
    </div>
  );
}

// Google-Anmeldung (OAuth mit PKCE). Supabase leitet danach auf
// /auth/callback?next=...&via=google, dort wird der Code eingeloest.
export function GoogleKnopf({
  next,
  label,
  gesperrt,
  onFehler,
}: {
  next: string;
  label: string;
  gesperrt: boolean;
  onFehler: (text: string) => void;
}) {
  const [busy, setBusy] = useState(false);

  async function start() {
    setBusy(true);
    const supabase = createClient();
    const ziel = `${window.location.origin}/auth/callback?via=google&next=${encodeURIComponent(next)}`;
    const { error } = await supabase.auth.signInWithOAuth({
      provider: "google",
      options: { redirectTo: ziel },
    });
    if (error) {
      setBusy(false);
      onFehler(FALLBACK);
    }
    // Erfolg: der Browser wechselt zu Google, kein Zuruecksetzen noetig
  }

  return (
    <button
      className="btn btn-ghost kt-google"
      type="button"
      disabled={gesperrt || busy}
      aria-busy={busy || undefined}
      onClick={start}
    >
      {busy ? <span className="kt-spin" aria-hidden="true" /> : <GoogleLogo />}
      {label}
    </button>
  );
}

// Status-Karte (Ergebnis-Zustaende): Symbol, Titel, Text, Aktionen, Hinweis.
export function StatusKarte({
  icon,
  ton,
  titel,
  titelId,
  children,
  aktionen,
  hinweis,
  rolle = "status",
  animiert = true,
}: {
  icon: "mail" | "check" | "x" | "lock" | "warten";
  ton?: "err" | "wait";
  titel: string;
  titelId?: string;
  children?: ReactNode;
  aktionen?: ReactNode;
  hinweis?: ReactNode;
  rolle?: "status" | "alert" | null;
  animiert?: boolean;
}) {
  return (
    <div
      className={animiert ? "kt-status kt-swap" : "kt-status"}
      role={rolle ?? undefined}
      aria-live={ton === "wait" ? "polite" : undefined}
    >
      <div className="kt-status-icon" data-tone={ton} aria-hidden="true">
        {icon === "warten" ? <span className="kt-spin" /> : <Icon name={icon} />}
      </div>
      <h1 id={titelId}>{titel}</h1>
      {children}
      {aktionen && <div className="kt-status-actions">{aktionen}</div>}
      {hinweis && <p className="kt-status-note">{hinweis}</p>}
    </div>
  );
}
