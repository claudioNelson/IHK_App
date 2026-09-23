"use client";

// /reset-confirm?token_hash=...&type=recovery
// Zwischenschritt fuer Passwort-Links: Das Token wird erst beim Klick
// eingeloest, damit ein Mail-Scanner, der die Seite vorab oeffnet, es nicht
// verbraucht. Danach weiter zu /update-password.

import { useEffect, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import AuthKarte from "@/app/components/konto/AuthKarte";
import { SendenKnopf, StatusKarte } from "@/app/components/konto/Felder";
import { AbgelaufenKarte } from "@/app/components/konto/LinkFormular";

type Zustand = "lesen" | "bereit" | "abgelaufen";

export default function ResetBestaetigen() {
  const router = useRouter();
  const [zustand, setZustand] = useState<Zustand>("lesen");
  const [tokenHash, setTokenHash] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);

  // Nur auslesen, nichts einloesen
  useEffect(() => {
    const th = new URLSearchParams(window.location.search).get("token_hash");
    setTokenHash(th);
    setZustand(th ? "bereit" : "abgelaufen");
  }, []);

  async function weiter() {
    if (!tokenHash) return;
    setBusy(true);
    const supabase = createClient();
    const { error } = await supabase.auth.verifyOtp({ token_hash: tokenHash, type: "recovery" });
    if (error) {
      setBusy(false);
      setZustand("abgelaufen");
      return;
    }
    router.push("/update-password");
  }

  return (
    <AuthKarte titelId="h-rc">
      {zustand === "lesen" ? (
        <StatusKarte icon="warten" ton="wait" titel="Wird geprüft" titelId="h-rc" animiert={false}>
          <p>Einen Moment, wir prüfen deinen Link.</p>
        </StatusKarte>
      ) : zustand === "abgelaufen" ? (
        <AbgelaufenKarte
          art="passwort"
          titelId="h-rc"
          text="Dieser Link ist abgelaufen oder wurde schon benutzt. Wir schicken dir gern einen neuen."
          hinweis={
            <>
              Schon geändert? Dann kannst du dich einfach <Link className="kt-link" href="/login">anmelden</Link>.
            </>
          }
        />
      ) : (
        <StatusKarte
          icon="lock"
          ton="wait"
          titel="Passwort zurücksetzen"
          titelId="h-rc"
          animiert={false}
          rolle={null}
          aktionen={
            <SendenKnopf type="button" busy={busy} busyText="Wird geprüft" onClick={weiter} className="btn btn-primary">
              Neues Passwort setzen
            </SendenKnopf>
          }
        >
          <p>Tipp auf den Knopf, dann vergibst du ein neues Passwort für dein Konto.</p>
        </StatusKarte>
      )}
    </AuthKarte>
  );
}
