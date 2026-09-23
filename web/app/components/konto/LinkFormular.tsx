"use client";

// E-Mail-Formular, das einen Link anfordert: Passwort-Link
// (resetPasswordForEmail, Ziel /update-password) oder einen neuen
// Bestaetigungslink (resend signup, Ziel /auth/callback).
// Benutzt auf /passwort-vergessen und in allen Zustaenden "Link abgelaufen".

import { useState, useTransition, type FormEvent, type ReactNode } from "react";
import { createClient } from "@/lib/supabase/client";
import { FeldFehler, Kasten, SendenKnopf, StatusKarte, beschreibung, fokusAuf } from "./Felder";
import { EMAIL_MUSTER, codeAus, fehlerFuer, type Fehler } from "./fehler";

export type LinkArt = "passwort" | "bestaetigung";

export async function linkSenden(art: LinkArt, email: string, next = "/profil") {
  const supabase = createClient();
  const origin = window.location.origin;
  if (art === "passwort") {
    return supabase.auth.resetPasswordForEmail(email, { redirectTo: `${origin}/update-password` });
  }
  return supabase.auth.resend({
    type: "signup",
    email,
    options: { emailRedirectTo: `${origin}/auth/callback?next=${encodeURIComponent(next)}` },
  });
}

export default function LinkFormular({
  art,
  idPrefix,
  knopf,
  startEmail = "",
  next,
  onGesendet,
  breit = false,
}: {
  art: LinkArt;
  idPrefix: string;
  knopf: string;
  startEmail?: string;
  next?: string;
  onGesendet: (email: string) => void;
  breit?: boolean;
}) {
  const [email, setEmail] = useState(startEmail);
  const [feld, setFeld] = useState<string | null>(null);
  const [kasten, setKasten] = useState<Fehler | null>(null);
  const [pending, startTransition] = useTransition();
  const feldId = `${idPrefix}-email`;
  const errId = `${idPrefix}-err`;

  function onSubmit(e: FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setKasten(null);
    const wert = email.trim();
    if (!wert || !EMAIL_MUSTER.test(wert)) {
      setFeld(wert ? "Diese E-Mail-Adresse sieht nicht gültig aus." : "Bitte gib deine E-Mail-Adresse ein.");
      fokusAuf(feldId);
      return;
    }
    setFeld(null);
    startTransition(async () => {
      const { error } = await linkSenden(art, wert, next);
      if (!error) {
        onGesendet(wert);
        return;
      }
      const f = fehlerFuer(codeAus(error).code);
      if (f.ort === "email") {
        setFeld(f.titel);
        fokusAuf(feldId);
        return;
      }
      setKasten(f.ort === "kasten" ? f : fehlerFuer("unbekannt"));
      fokusAuf(errId);
    });
  }

  return (
    <div style={breit ? { width: "100%" } : undefined}>
      {kasten && (
        <Kasten id={errId} fehler={kasten}>
          {kasten.code === "over_email_send_rate_limit" ? (
            <p>{kasten.text} Der erste Link ist trotzdem gültig.</p>
          ) : undefined}
        </Kasten>
      )}
      <form className="kt-form" noValidate onSubmit={onSubmit}>
        <div className="kt-field">
          <label className="kt-label" htmlFor={feldId}>E-Mail</label>
          <input
            className="kt-input"
            id={feldId}
            name="email"
            type="email"
            autoComplete="email"
            inputMode="email"
            spellCheck={false}
            required
            placeholder="name@beispiel.de"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            readOnly={pending}
            aria-invalid={feld ? true : undefined}
            aria-describedby={beschreibung(feld && `${feldId}-fehler`)}
          />
          {feld && <FeldFehler id={`${feldId}-fehler`}>{feld}</FeldFehler>}
        </div>
        <SendenKnopf busy={pending} busyText="Link wird gesendet">{knopf}</SendenKnopf>
      </form>
    </div>
  );
}

// Status-Karte "Link abgelaufen" mit Formular fuer einen neuen Link. Nach dem
// Senden wechselt sie selbst auf "Schau in dein Postfach".
export function AbgelaufenKarte({
  art,
  titelId,
  text,
  hinweis,
  next,
  startEmail,
}: {
  art: LinkArt;
  titelId: string;
  text: string;
  hinweis: ReactNode;
  next?: string;
  startEmail?: string;
}) {
  const [gesendetAn, setGesendetAn] = useState<string | null>(null);

  if (gesendetAn) {
    return (
      <StatusKarte icon="mail" titel="Schau in dein Postfach" titelId={titelId}>
        {art === "passwort" ? (
          <p>
            Wenn es zu <strong>{gesendetAn}</strong> ein Konto gibt, ist der Link jetzt unterwegs. Er gilt eine Stunde.
          </p>
        ) : (
          <p>
            Wir haben einen neuen Link an <strong>{gesendetAn}</strong> geschickt. Sobald du ihn öffnest, ist dein Konto bereit.
          </p>
        )}
      </StatusKarte>
    );
  }

  return (
    <StatusKarte icon="x" ton="err" titel="Link abgelaufen" titelId={titelId} rolle={null} hinweis={hinweis}>
      <p role="alert">{text}</p>
      <LinkFormular
        art={art}
        idPrefix={`${titelId}-neu`}
        knopf="Neuen Link senden"
        breit
        next={next}
        startEmail={startEmail}
        onGesendet={setGesendetAn}
      />
    </StatusKarte>
  );
}
