"use client";

// /signup: Nutzername, E-Mail, Passwort (mit Staerke), AGB, dann Google.
// Nach dem Absenden die Status-Karte "Bestaetige deine E-Mail".

import { useState, useTransition, type FormEvent } from "react";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";
import { signup } from "../login/actions";
import AuthKarte, { KartenKopf } from "@/app/components/konto/AuthKarte";
import {
  FeldFehler,
  GoogleKnopf,
  Kasten,
  Oder,
  PasswortFeld,
  SendenKnopf,
  StatusKarte,
  beschreibung,
  fokusAuf,
} from "@/app/components/konto/Felder";
import { EMAIL_MUSTER, fehlerFuer, type Fehler } from "@/app/components/konto/fehler";

type Felder = { username?: string; email?: string; emailVorhanden?: boolean; password?: string; agb?: string };

const REIHENFOLGE: [keyof Felder, string][] = [
  ["username", "su-name"],
  ["email", "su-email"],
  ["password", "su-password"],
  ["agb", "su-agb"],
];

export default function SignupFormular({ next }: { next: string }) {
  const [username, setUsername] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [agb, setAgb] = useState(false);
  const [felder, setFelder] = useState<Felder>({});
  const [kasten, setKasten] = useState<Fehler | null>(null);
  const [gesendetAn, setGesendetAn] = useState<string | null>(null);
  const [erneut, setErneut] = useState<"offen" | "laeuft" | "gesendet" | "fehler">("offen");
  const [pending, startTransition] = useTransition();

  const mitNext = next !== "/profil" ? `?next=${encodeURIComponent(next)}` : "";

  function zeigeFeldfehler(neu: Felder) {
    setFelder(neu);
    const erstes = REIHENFOLGE.find(([k]) => neu[k]);
    if (erstes) fokusAuf(erstes[1]);
  }

  function onSubmit(e: FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setKasten(null);
    const neu: Felder = {};
    if (username.trim().length < 3) neu.username = "Der Nutzername braucht mindestens 3 Zeichen.";
    if (!email.trim()) neu.email = "Bitte gib deine E-Mail-Adresse ein.";
    else if (!EMAIL_MUSTER.test(email.trim())) neu.email = "Diese E-Mail-Adresse sieht nicht gültig aus.";
    if (password.length < 8) neu.password = fehlerFuer("weak_password").titel;
    if (!agb) neu.agb = "Bitte stimme den AGB zu, damit wir dein Konto anlegen können.";
    if (Object.keys(neu).length > 0) {
      zeigeFeldfehler(neu);
      return;
    }
    setFelder({});

    const fd = new FormData(e.currentTarget);
    startTransition(async () => {
      const r = await signup(fd);
      if (!r) return;
      if (r.ok) {
        setGesendetAn(r.email);
        return;
      }
      if (r.code === "username_too_short") return zeigeFeldfehler({ username: "Der Nutzername braucht mindestens 3 Zeichen." });
      if (r.code === "agb_missing") return zeigeFeldfehler({ agb: "Bitte stimme den AGB zu, damit wir dein Konto anlegen können." });
      const f = fehlerFuer(r.code, r.reasons);
      if (f.code === "user_already_exists") return zeigeFeldfehler({ email: f.titel, emailVorhanden: true });
      if (f.ort === "email") return zeigeFeldfehler({ email: f.titel });
      if (f.ort === "passwort") return zeigeFeldfehler({ password: f.titel });
      setKasten(f.ort === "kasten" ? f : fehlerFuer("unbekannt"));
      fokusAuf("su-err");
    });
  }

  async function linkErneut() {
    if (!gesendetAn) return;
    setErneut("laeuft");
    const supabase = createClient();
    const { error } = await supabase.auth.resend({
      type: "signup",
      email: gesendetAn,
      options: { emailRedirectTo: `${window.location.origin}/auth/callback?next=${encodeURIComponent(next)}` },
    });
    setErneut(error ? "fehler" : "gesendet");
  }

  if (gesendetAn) {
    return (
      <AuthKarte titelId="h-signup">
        <StatusKarte
          icon="mail"
          titel="Bestätige deine E-Mail"
          titelId="h-signup"
          aktionen={<Link className="btn btn-ghost" href={`/login${mitNext}`}>Zur Anmeldung</Link>}
          hinweis={
            erneut === "gesendet" ? (
              "Wir haben den Link noch einmal geschickt. Schau auch im Spam-Ordner nach."
            ) : erneut === "fehler" ? (
              "Das erneute Senden hat nicht geklappt. Warte bitte eine Minute und versuch es dann noch einmal."
            ) : (
              <>
                Nichts angekommen? Schau im Spam-Ordner nach oder{" "}
                <button className="kt-link" type="button" onClick={linkErneut} disabled={erneut === "laeuft"}>
                  {erneut === "laeuft" ? "Link wird gesendet" : "schick den Link noch einmal"}
                </button>
                .
              </>
            )
          }
        >
          <p>
            Wir haben einen Link an <strong>{gesendetAn}</strong> geschickt. Sobald du ihn öffnest, ist dein Konto bereit.
          </p>
        </StatusKarte>
      </AuthKarte>
    );
  }

  return (
    <AuthKarte
      titelId="h-signup"
      fuss={
        <>
          Schon ein Konto?
          <Link className="kt-link" href={`/login${mitNext}`}>Anmelden</Link>
        </>
      }
    >
      <KartenKopf titel="Konto anlegen" titelId="h-signup">
        Kostenlos. Ein Konto für App und Web, dein Fortschritt ist überall derselbe.
      </KartenKopf>

      {kasten && <Kasten id="su-err" fehler={kasten} />}

      <form className="kt-form" noValidate onSubmit={onSubmit}>
        <input type="hidden" name="next" value={next} />
        <div className="kt-field">
          <label className="kt-label" htmlFor="su-name">Nutzername</label>
          <input
            className="kt-input"
            id="su-name"
            name="username"
            type="text"
            autoComplete="username"
            autoCapitalize="none"
            spellCheck={false}
            minLength={3}
            required
            value={username}
            onChange={(e) => setUsername(e.target.value)}
            readOnly={pending}
            aria-invalid={felder.username ? true : undefined}
            aria-describedby={beschreibung("su-name-hint", felder.username && "su-name-err")}
          />
          <p className="kt-hint" id="su-name-hint">So heißt du in der Arena. Mindestens 3 Zeichen.</p>
          {felder.username && <FeldFehler id="su-name-err">{felder.username}</FeldFehler>}
        </div>

        <div className="kt-field">
          <label className="kt-label" htmlFor="su-email">E-Mail</label>
          <input
            className="kt-input"
            id="su-email"
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
            aria-invalid={felder.email ? true : undefined}
            aria-describedby={beschreibung(felder.email && "su-email-err")}
          />
          {felder.email && (
            <FeldFehler id="su-email-err">
              {felder.email}
              {felder.emailVorhanden && (
                <>
                  {" "}
                  <Link className="kt-link" href={`/login${mitNext}`}>Melde dich an</Link> oder{" "}
                  <Link className="kt-link" href="/passwort-vergessen">setz dein Passwort zurück</Link>.
                </>
              )}
            </FeldFehler>
          )}
        </div>

        <PasswortFeld
          id="su-password"
          label="Passwort"
          value={password}
          onChange={setPassword}
          autoComplete="new-password"
          mitStaerke
          readOnly={pending}
          invalid={!!felder.password}
          describedBy={beschreibung(felder.password && "su-pw-err")}
          fehler={felder.password && <FeldFehler id="su-pw-err">{felder.password}</FeldFehler>}
        />

        <div className="kt-field">
          <label className="kt-check">
            <input
              type="checkbox"
              name="agb"
              id="su-agb"
              required
              checked={agb}
              onChange={(e) => setAgb(e.target.checked)}
              disabled={pending}
              aria-invalid={felder.agb ? true : undefined}
              aria-describedby={beschreibung(felder.agb && "su-agb-err")}
            />
            <span>
              Ich stimme den <Link className="kt-link" href="/agb">AGB</Link> zu und habe die{" "}
              <Link className="kt-link" href="/datenschutz">Datenschutzerklärung</Link> gelesen.
            </span>
            {felder.agb && (
              <FeldFehler id="su-agb-err" as="span">{felder.agb}</FeldFehler>
            )}
          </label>
        </div>

        <SendenKnopf busy={pending} busyText="Konto wird angelegt">Konto anlegen</SendenKnopf>
      </form>

      <Oder />
      <GoogleKnopf
        next={next}
        label="Mit Google registrieren"
        gesperrt={pending}
        onFehler={(t) => {
          setKasten({ code: "google", ort: "kasten", titel: t });
          fokusAuf("su-err");
        }}
      />
    </AuthKarte>
  );
}
