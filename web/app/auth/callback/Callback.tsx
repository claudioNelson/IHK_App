"use client";

// /auth/callback: E-Mail bestaetigen und Google-Anmeldung abschliessen.
// Drei Zustaende: pruefen, ok, fehler. Erfolg leitet nach 1,5 s auf next
// weiter (Google sofort), der Knopf ist die Abkuerzung.
//
// Unterstuetzt: ?code=... (PKCE, Google und neue Bestaetigungslinks),
// ?token_hash=...&type=... (geraeteunabhaengig), #access_token=... (alt).

import { useEffect, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import type { EmailOtpType } from "@supabase/supabase-js";
import { createClient } from "@/lib/supabase/client";
import AuthKarte from "@/app/components/konto/AuthKarte";
import { StatusKarte } from "@/app/components/konto/Felder";
import { AbgelaufenKarte } from "@/app/components/konto/LinkFormular";
import { FALLBACK, sichererPfad } from "@/app/components/konto/fehler";

type Zustand = "pruefen" | "ok" | "fehler";

export default function Callback() {
  const router = useRouter();
  const [zustand, setZustand] = useState<Zustand>("pruefen");
  const [next, setNext] = useState("/profil");
  const [viaGoogle, setViaGoogle] = useState(false);

  useEffect(() => {
    let alive = true;
    let timer: ReturnType<typeof setTimeout> | undefined;

    async function run() {
      const supabase = createClient();
      const url = new URL(window.location.href);
      const q = url.searchParams;
      const hash = new URLSearchParams(url.hash.replace(/^#/, ""));
      const ziel = sichererPfad(q.get("next"));
      const google = q.get("via") === "google";
      const type = q.get("type");
      setNext(ziel);
      setViaGoogle(google);

      const fertig = (ok: boolean) => {
        if (!alive) return;
        window.history.replaceState(null, "", url.pathname);
        if (!ok) {
          setZustand("fehler");
          return;
        }
        if (type === "recovery") {
          router.replace("/update-password");
          return;
        }
        if (google) {
          router.replace(ziel);
          router.refresh();
          return;
        }
        setZustand("ok");
        timer = setTimeout(() => {
          router.replace(ziel);
          router.refresh();
        }, 1500);
      };

      try {
        if (q.get("error") || q.get("error_code") || hash.get("error") || hash.get("error_code")) {
          return fertig(false);
        }

        // getSession wartet, bis der Client ?code= bzw. #access_token selbst
        // eingeloest hat. Erst wenn danach keine Sitzung da ist, selbst probieren.
        const { data } = await supabase.auth.getSession();
        if (data.session && !q.get("token_hash")) return fertig(true);

        const code = q.get("code");
        if (code) {
          const { data: d, error } = await supabase.auth.exchangeCodeForSession(code);
          return fertig(!error && !!d.session);
        }

        const at = hash.get("access_token");
        const rt = hash.get("refresh_token");
        if (at && rt) {
          const { error } = await supabase.auth.setSession({ access_token: at, refresh_token: rt });
          return fertig(!error);
        }

        const tokenHash = q.get("token_hash");
        if (tokenHash) {
          const { error } = await supabase.auth.verifyOtp({
            token_hash: tokenHash,
            type: (type ?? "signup") as EmailOtpType,
          });
          return fertig(!error);
        }

        fertig(!!data.session);
      } catch {
        fertig(false);
      }
    }

    run();
    return () => {
      alive = false;
      if (timer) clearTimeout(timer);
    };
  }, [router]);

  const weiterLabel = next === "/profil" ? "Weiter zu deinem Profil" : "Weiter";
  const loginHref = next !== "/profil" ? `/login?next=${encodeURIComponent(next)}` : "/login";

  return (
    <AuthKarte titelId="h-confirm">
      {zustand === "pruefen" ? (
        <StatusKarte icon="warten" ton="wait" titel="Wird geprüft" titelId="h-confirm" animiert={false}>
          <p>{viaGoogle ? "Einen Moment, wir melden dich an." : "Einen Moment, wir bestätigen deine E-Mail-Adresse."}</p>
        </StatusKarte>
      ) : zustand === "ok" ? (
        <StatusKarte
          icon="check"
          titel="E-Mail bestätigt"
          titelId="h-confirm"
          aktionen={<Link className="btn btn-primary" href={next}>{weiterLabel}</Link>}
        >
          <p>Dein Konto ist bereit. Wir leiten dich gleich weiter.</p>
        </StatusKarte>
      ) : viaGoogle ? (
        <StatusKarte
          icon="x"
          ton="err"
          titel="Anmeldung nicht abgeschlossen"
          titelId="h-confirm"
          rolle={null}
          aktionen={<Link className="btn btn-primary" href={loginHref}>Zur Anmeldung</Link>}
        >
          <p role="alert">{FALLBACK}</p>
        </StatusKarte>
      ) : (
        <AbgelaufenKarte
          art="bestaetigung"
          titelId="h-confirm"
          next={next}
          text="Dieser Bestätigungslink ist abgelaufen oder wurde schon benutzt. Wir schicken dir gern einen neuen."
          hinweis={
            <>
              Schon bestätigt? Dann kannst du dich einfach <Link className="kt-link" href={loginHref}>anmelden</Link>.
            </>
          }
        />
      )}
    </AuthKarte>
  );
}
