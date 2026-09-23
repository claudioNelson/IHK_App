// Supabase-Fehlercodes (error.code) auf deutsche Texte abbilden, dazu der
// Ort der Anzeige: Kasten ueber dem Formular, Feldfehler am E-Mail- oder
// Passwortfeld oder die Status-Karte "Link abgelaufen".
// Tabelle: DESIGN-NOTIZEN.md im Mockup-Ordner (auth-design).

export type FehlerOrt = "kasten" | "email" | "passwort" | "abgelaufen";

export type Fehler = {
  code: string;
  ort: FehlerOrt;
  // Kasten: gelb statt rot (Wartezeit, keine falsche Eingabe)
  warn?: boolean;
  titel: string;
  text?: string;
};

export const FALLBACK = "Das hat nicht geklappt. Bitte versuch es noch einmal.";

export function fehlerFuer(code: string | null | undefined, reasons?: string[] | null): Fehler {
  const c = code ?? "unbekannt";
  switch (c) {
    case "invalid_credentials":
      return {
        code: c,
        ort: "kasten",
        titel: "E-Mail oder Passwort stimmt nicht.",
        text: "Prüf die Schreibweise oder setz dein Passwort zurück.",
      };
    case "email_not_confirmed":
      return {
        code: c,
        ort: "kasten",
        warn: true,
        titel: "Bitte bestätige zuerst deine E-Mail-Adresse.",
        text: "Den Link haben wir dir bei der Registrierung geschickt.",
      };
    case "user_already_exists":
    case "email_exists":
      return {
        code: "user_already_exists",
        ort: "email",
        titel: "Zu dieser E-Mail gibt es schon ein Konto.",
      };
    case "weak_password":
      return reasons?.includes("pwned")
        ? { code: c, ort: "passwort", titel: "Dieses Passwort taucht in bekannten Datenlecks auf. Nimm ein anderes." }
        : { code: c, ort: "passwort", titel: "Zu kurz. Nimm mindestens 8 Zeichen, am besten mit Zahl oder Sonderzeichen." };
    case "over_email_send_rate_limit":
      return {
        code: c,
        ort: "kasten",
        warn: true,
        titel: "Du hast gerade schon einen Link angefordert.",
        text: "Warte bitte eine Minute und versuch es dann noch einmal.",
      };
    case "same_password":
      return { code: c, ort: "passwort", titel: "Das ist dein bisheriges Passwort. Wähle ein neues." };
    case "otp_expired":
    case "flow_state_expired":
    case "flow_state_not_found":
    case "bad_code_verifier":
    case "session_not_found":
    case "session_expired":
      return {
        code: "otp_expired",
        ort: "abgelaufen",
        titel: "Link abgelaufen",
        text: "Dieser Link ist abgelaufen oder wurde schon benutzt. Wir schicken dir gern einen neuen.",
      };
    case "email_address_invalid":
    case "validation_failed":
      return { code: c, ort: "email", titel: "Diese E-Mail-Adresse sieht nicht gültig aus." };
    case "over_request_rate_limit":
      return {
        code: c,
        ort: "kasten",
        warn: true,
        titel: "Zu viele Versuche.",
        text: "Warte kurz und versuch es noch einmal.",
      };
    default:
      return { code: c, ort: "kasten", titel: FALLBACK };
  }
}

// Supabase-Fehler (AuthError) auf Code und Gruende reduzieren. Aeltere
// Fehler ohne code bekommen einen Code aus dem Status.
export function codeAus(err: unknown): { code: string; reasons?: string[] } {
  if (!err || typeof err !== "object") return { code: "unbekannt" };
  const e = err as { code?: string; status?: number; reasons?: string[] };
  if (e.code) return { code: e.code, reasons: e.reasons };
  if (e.status === 429) return { code: "over_request_rate_limit" };
  return { code: "unbekannt" };
}

// Nur relative Pfade innerhalb der Seite zulassen ("/..." aber nicht "//..."
// oder "/\..."), sonst Standardziel.
export function sichererPfad(next: string | null | undefined, standard = "/profil"): string {
  if (!next || typeof next !== "string") return standard;
  if (!next.startsWith("/") || next.startsWith("//") || next.startsWith("/\\")) return standard;
  return next;
}

export const EMAIL_MUSTER = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
