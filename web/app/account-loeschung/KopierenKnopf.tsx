"use client";

// "Text kopieren" fuer die Loesch-Mail, mit kurzer Rueckmeldung darunter.

import { useState } from "react";
import Icon from "@/app/components/konto/Icon";

export default function KopierenKnopf({ text }: { text: string }) {
  const [meldung, setMeldung] = useState("");

  async function kopieren() {
    try {
      await navigator.clipboard.writeText(text);
      setMeldung("Text kopiert.");
    } catch {
      setMeldung("Kopieren ging nicht. Markier den Text und kopier ihn von Hand.");
    }
    setTimeout(() => setMeldung(""), 2500);
  }

  return (
    <>
      <button className="btn btn-ghost" type="button" onClick={kopieren}>
        <Icon name="copy" size={18} />
        Text kopieren
      </button>
      <p className="kt-copied" role="status" aria-live="polite">
        {meldung}
      </p>
    </>
  );
}
