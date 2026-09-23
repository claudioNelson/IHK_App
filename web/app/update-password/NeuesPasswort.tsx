"use client";

// /update-password: neues Passwort setzen. Die Sitzung kommt aus dem Link
// (PKCE ?code=..., altes #access_token=... oder schon vorhanden, z. B. nach
// /reset-confirm). Ohne Sitzung direkt "Link abgelaufen" mit neuem Formular.

import { useEffect, useMemo, useState, useTransition, type FormEvent } from "react";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";
import AuthKarte, { KartenKopf } from "@/app/components/konto/AuthKarte";
import { FeldFehler, Kasten, PasswortFeld, SendenKnopf, StatusKarte, fokusAuf } from "@/app/components/konto/Felder";
import { AbgelaufenKarte } from "@/app/components/konto/LinkFormular";
import { codeAus, fehlerFuer, type Fehler } from "@/app/components/konto/fehler";

type Zustand = "pruefen" | "formular" | "abgelaufen" | "fertig";

export default function NeuesPasswort() {
  const supabase = useMemo(() => createClient(), []);
  const [zustand, setZustand] = useState<Zustand>("pruefen");
  const [email, setEmail] = useState<string | null>(null);
  const [password, setPassword] = useState("");
  const [feld, setFeld] = useState<string | null>(null);
  const [kasten, setKasten] = useState<Fehler | null>(null);
  const [pending, startTransition] = useTransition();

  useEffect(() => {
    let alive = true;
    async function init() {
      try {
        const url = new URL(window.location.href);
        const hash = new URLSearchParams(url.hash.replace(/^#/, ""));
        const code = url.searchParams.get("code");

        // Fehler direkt aus dem Link (z. B. otp_expired)
        const linkFehler = hash.get("error_code") || url.searchParams.get("error_code");

        // getSession wartet, bis der Client die URL selbst ausgewertet hat
        let { data: { session } } = await supabase.auth.getSession();

        if (!session && !linkFehler && code) {
          const r = await supabase.auth.exchangeCodeForSession(code);
          session = r.data.session;
        }
        if (!session && !linkFehler && hash.get("access_token") && hash.get("refresh_token")) {
          const r = await supabase.auth.setSession({
            access_token: hash.get("access_token")!,
            refresh_token: hash.get("refresh_token")!,
          });
          session = r.data.session;
        }

        // Token nicht in der Adresszeile stehen lassen
        if (code || url.hash) window.history.replaceState(null, "", url.pathname);

        if (!alive) return;
        if (session) {
          setEmail(session.user.email ?? null);
          setZustand("formular");
        } else {
          setZustand("abgelaufen");
        }
      } catch {
        if (alive) setZustand("abgelaufen");
      }
    }
    init();
    return () => {
      alive = false;
    };
  }, [supabase]);

  function onSubmit(e: FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setKasten(null);
    if (password.length < 8) {
      setFeld(fehlerFuer("weak_password").titel);
      fokusAuf("rs-password");
      return;
    }
    setFeld(null);
    startTransition(async () => {
      const { error } = await supabase.auth.updateUser({ password });
      if (!error) {
        setZustand("fertig");
        return;
      }
      const { code, reasons } = codeAus(error);
      const f = fehlerFuer(code, reasons);
      if (f.ort === "passwort") {
        setFeld(f.titel);
        fokusAuf("rs-password");
      } else if (f.ort === "abgelaufen") {
        setZustand("abgelaufen");
      } else {
        setKasten(f.ort === "kasten" ? f : fehlerFuer("unbekannt"));
        fokusAuf("rs-err");
      }
    });
  }

  if (zustand === "pruefen") {
    return (
      <AuthKarte titelId="h-reset">
        <StatusKarte icon="warten" ton="wait" titel="Wird geprüft" titelId="h-reset" animiert={false}>
          <p>Einen Moment, wir prüfen deinen Link.</p>
        </StatusKarte>
      </AuthKarte>
    );
  }

  if (zustand === "abgelaufen") {
    return (
      <AuthKarte titelId="h-reset">
        <AbgelaufenKarte
          art="passwort"
          titelId="h-reset"
          text="Dieser Link ist abgelaufen oder wurde schon benutzt. Wir schicken dir gern einen neuen."
          hinweis={
            <>
              Schon geändert? Dann kannst du dich einfach <Link className="kt-link" href="/login">anmelden</Link>.
            </>
          }
        />
      </AuthKarte>
    );
  }

  if (zustand === "fertig") {
    return (
      <AuthKarte titelId="h-reset">
        <StatusKarte
          icon="check"
          titel="Passwort geändert"
          titelId="h-reset"
          aktionen={<Link className="btn btn-primary" href="/profil">Weiter zu deinem Profil</Link>}
        >
          <p>Ab jetzt meldest du dich mit dem neuen Passwort an, auch in der App. Du bist schon angemeldet.</p>
        </StatusKarte>
      </AuthKarte>
    );
  }

  return (
    <AuthKarte titelId="h-reset">
      <KartenKopf titel="Neues Passwort setzen" titelId="h-reset">
        {email ? (
          <>
            Für dein Konto <strong>{email}</strong>.
          </>
        ) : (
          "Für dein Konto."
        )}
      </KartenKopf>
      {kasten && <Kasten id="rs-err" fehler={kasten} />}
      <form className="kt-form" noValidate onSubmit={onSubmit}>
        <input type="text" name="username" autoComplete="username" value={email ?? ""} readOnly hidden />
        <PasswortFeld
          id="rs-password"
          label="Neues Passwort"
          value={password}
          onChange={setPassword}
          autoComplete="new-password"
          mitStaerke
          readOnly={pending}
          invalid={!!feld}
          describedBy={feld ? "rs-pw-err" : undefined}
          fehler={feld && <FeldFehler id="rs-pw-err">{feld}</FeldFehler>}
        />
        <SendenKnopf busy={pending} busyText="Wird gespeichert">Passwort speichern</SendenKnopf>
      </form>
    </AuthKarte>
  );
}
