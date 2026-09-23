"use client";

// /passwort-vergessen: E-Mail eingeben, Link an /update-password anfordern.
// Keine E-Mail-Aufzaehlung: das Ergebnis sagt immer "Wenn es ... ein Konto gibt".

import { useState } from "react";
import AuthKarte, { KartenKopf } from "@/app/components/konto/AuthKarte";
import { StatusKarte } from "@/app/components/konto/Felder";
import LinkFormular, { linkSenden } from "@/app/components/konto/LinkFormular";

export default function VergessenFormular() {
  const [gesendetAn, setGesendetAn] = useState<string | null>(null);
  const [erneut, setErneut] = useState<"offen" | "laeuft" | "gesendet" | "fehler">("offen");

  async function nochmal() {
    if (!gesendetAn) return;
    setErneut("laeuft");
    const { error } = await linkSenden("passwort", gesendetAn);
    setErneut(error ? "fehler" : "gesendet");
  }

  return (
    <AuthKarte titelId="h-forgot" zurueck={{ href: "/login", label: "Zurück zur Anmeldung" }}>
      {gesendetAn ? (
        <StatusKarte
          icon="mail"
          titel="Schau in dein Postfach"
          titelId="h-forgot"
          hinweis={
            erneut === "gesendet" ? (
              "Wir haben den Link noch einmal geschickt. Schau auch im Spam-Ordner nach."
            ) : erneut === "fehler" ? (
              "Das erneute Senden hat nicht geklappt. Warte bitte eine Minute und versuch es dann noch einmal."
            ) : (
              <>
                Nichts angekommen? Schau im Spam-Ordner nach oder{" "}
                <button className="kt-link" type="button" onClick={nochmal} disabled={erneut === "laeuft"}>
                  {erneut === "laeuft" ? "Link wird gesendet" : "schick den Link noch einmal"}
                </button>
                .
              </>
            )
          }
        >
          <p>
            Wenn es zu <strong>{gesendetAn}</strong> ein Konto gibt, ist der Link jetzt unterwegs. Er gilt eine Stunde.
          </p>
        </StatusKarte>
      ) : (
        <>
          <KartenKopf titel="Passwort vergessen?" titelId="h-forgot">
            Gib die E-Mail-Adresse deines Kontos ein. Wir schicken dir einen Link, mit dem du ein neues Passwort setzt.
          </KartenKopf>
          <LinkFormular art="passwort" idPrefix="fg" knopf="Link senden" onGesendet={setGesendetAn} />
        </>
      )}
    </AuthKarte>
  );
}
