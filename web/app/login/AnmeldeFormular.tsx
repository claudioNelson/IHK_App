"use client";

// /login: Formular (E-Mail, Passwort), danach "oder" und Google.
// Serverfehler als Kasten ueber dem Formular, Feldfehler unter dem Feld.

import { useState, useTransition, type FormEvent } from "react";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";
import { login } from "./actions";
import AuthKarte, { KartenKopf } from "@/app/components/konto/AuthKarte";
import {
  FeldFehler,
  GoogleKnopf,
  Kasten,
  Oder,
  PasswortFeld,
  SendenKnopf,
  beschreibung,
  fokusAuf,
} from "@/app/components/konto/Felder";
import { EMAIL_MUSTER, FALLBACK, fehlerFuer, type Fehler } from "@/app/components/konto/fehler";

type FeldFehlerStand = { email?: string; password?: string };

export default function AnmeldeFormular({ next, startFehler }: { next: string; startFehler?: string | null }) {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [kasten, setKasten] = useState<Fehler | null>(startFehler ? fehlerFuer(startFehler) : null);
  const [felder, setFelder] = useState<FeldFehlerStand>({});
  const [pending, startTransition] = useTransition();
  const [erneut, setErneut] = useState<"offen" | "laeuft" | "gesendet" | "fehler">("offen");

  const mitNext = next !== "/profil" ? `?next=${encodeURIComponent(next)}` : "";
  const beideUngueltig = kasten?.code === "invalid_credentials";

  function onSubmit(e: FormEvent<HTMLFormElement>) {
    e.preventDefault();
    const neu: FeldFehlerStand = {};
    if (!email.trim()) neu.email = "Bitte gib deine E-Mail-Adresse ein.";
    else if (!EMAIL_MUSTER.test(email.trim())) neu.email = "Diese E-Mail-Adresse sieht nicht gültig aus.";
    if (!password) neu.password = "Bitte gib dein Passwort ein.";
    setFelder(neu);
    setKasten(null);
    if (neu.email || neu.password) {
      fokusAuf(neu.email ? "login-email" : "login-password");
      return;
    }

    const fd = new FormData(e.currentTarget);
    startTransition(async () => {
      const r = await login(fd);
      // Erfolg leitet serverseitig weiter, hier kommt nur der Fehlerfall an.
      if (r && !r.ok) {
        const f = fehlerFuer(r.code);
        if (f.ort === "email") {
          setFelder({ email: f.titel });
          fokusAuf("login-email");
        } else {
          setKasten(f.ort === "kasten" ? f : { code: r.code, ort: "kasten", titel: FALLBACK });
          setErneut("offen");
          fokusAuf("login-err");
        }
      }
    });
  }

  async function linkErneut() {
    setErneut("laeuft");
    const supabase = createClient();
    const { error } = await supabase.auth.resend({
      type: "signup",
      email: email.trim(),
      options: { emailRedirectTo: `${window.location.origin}/auth/callback?next=${encodeURIComponent(next)}` },
    });
    setErneut(error ? "fehler" : "gesendet");
  }

  const kastenId = kasten ? "login-err" : undefined;

  return (
    <AuthKarte
      titelId="h-login"
      fuss={
        <>
          Neu hier?
          <Link className="kt-link" href={`/signup${mitNext}`}>Registrieren</Link>
        </>
      }
    >
      <KartenKopf titel="Anmelden" titelId="h-login">
        Willkommen zurück. Dein Lernstand aus der App wartet hier auf dich.
      </KartenKopf>

      {kasten && (
        <Kasten id="login-err" fehler={kasten}>
          {kasten.code === "invalid_credentials" ? (
            <p>
              Prüf die Schreibweise oder{" "}
              <Link className="kt-link" href="/passwort-vergessen">setz dein Passwort zurück</Link>.
            </p>
          ) : kasten.code === "email_not_confirmed" ? (
            <p>
              {kasten.text}{" "}
              {erneut === "gesendet" ? (
                "Wir haben ihn dir noch einmal geschickt."
              ) : erneut === "fehler" ? (
                "Das erneute Senden hat nicht geklappt. Warte kurz und versuch es noch einmal."
              ) : (
                <button className="kt-link" type="button" onClick={linkErneut} disabled={erneut === "laeuft"}>
                  {erneut === "laeuft" ? "Wird gesendet" : "Link erneut senden"}
                </button>
              )}
            </p>
          ) : undefined}
        </Kasten>
      )}

      <form className="kt-form" noValidate onSubmit={onSubmit}>
        <input type="hidden" name="next" value={next} />
        <div className="kt-field">
          <label className="kt-label" htmlFor="login-email">E-Mail</label>
          <input
            className="kt-input"
            id="login-email"
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
            aria-invalid={felder.email || beideUngueltig ? true : undefined}
            aria-describedby={beschreibung(felder.email && "login-email-err", beideUngueltig && kastenId)}
          />
          {felder.email && <FeldFehler id="login-email-err">{felder.email}</FeldFehler>}
        </div>
        <PasswortFeld
          id="login-password"
          label="Passwort"
          value={password}
          onChange={setPassword}
          autoComplete="current-password"
          readOnly={pending}
          invalid={!!felder.password || beideUngueltig}
          describedBy={beschreibung(felder.password && "login-password-err", beideUngueltig && kastenId)}
          labelZusatz={<Link className="kt-link" href="/passwort-vergessen">Passwort vergessen?</Link>}
          fehler={felder.password && <FeldFehler id="login-password-err">{felder.password}</FeldFehler>}
        />
        <SendenKnopf busy={pending} busyText="Wird angemeldet">Anmelden</SendenKnopf>
      </form>

      <Oder />
      <GoogleKnopf
        next={next}
        label="Mit Google anmelden"
        gesperrt={pending}
        onFehler={(t) => {
          setKasten({ code: "google", ort: "kasten", titel: t });
          fokusAuf("login-err");
        }}
      />
    </AuthKarte>
  );
}
