"use server";

// Server Actions fuer Anmelden und Registrieren. Fehler kommen als
// Supabase-Code zurueck (nicht als englische Meldung), die Formulare
// uebersetzen sie ueber app/components/konto/fehler.ts. Bei Erfolg leitet
// die Action selbst weiter (redirect wirft und beendet die Action).

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { sichererPfad } from "@/app/components/konto/fehler";

export type AuthErgebnis =
    | { ok: false; code: string; reasons?: string[] }
    | { ok: true; email: string };

const PASSWORT_MIN = 8;

function siteUrl() {
    return process.env.NEXT_PUBLIC_SITE_URL ?? "http://localhost:3000";
}

export async function login(formData: FormData): Promise<AuthErgebnis> {
    const supabase = await createClient();

    const email = String(formData.get("email") ?? "").trim();
    const password = String(formData.get("password") ?? "");
    const next = sichererPfad(formData.get("next") as string | null);

    const { error } = await supabase.auth.signInWithPassword({ email, password });

    if (error) {
        return {
            ok: false,
            code: error.code ?? (error.status === 400 ? "invalid_credentials" : "unbekannt"),
        };
    }

    revalidatePath("/", "layout");
    redirect(next);
}

export async function signup(formData: FormData): Promise<AuthErgebnis> {
    const supabase = await createClient();

    const email = String(formData.get("email") ?? "").trim();
    const password = String(formData.get("password") ?? "");
    const username = String(formData.get("username") ?? "").trim();
    const agb = formData.get("agb") === "on";
    const next = sichererPfad(formData.get("next") as string | null);

    // Die Formulare pruefen das schon, hier nur als Absicherung.
    if (username.length < 3) return { ok: false, code: "username_too_short" };
    if (password.length < PASSWORT_MIN) return { ok: false, code: "weak_password" };
    if (!agb) return { ok: false, code: "agb_missing" };

    const { data, error } = await supabase.auth.signUp({
        email,
        password,
        options: {
            emailRedirectTo: `${siteUrl()}/auth/callback?next=${encodeURIComponent(next)}`,
            // user_metadata; Trigger erstellt den profiles-Eintrag und liest
            // 'plattform' fuer die Store-Auswertung (Migration 20260920030000).
            data: { username, plattform: "web" },
        },
    });

    if (error) {
        const reasons = (error as { reasons?: string[] }).reasons;
        return { ok: false, code: error.code ?? "unbekannt", reasons };
    }

    // Bereits registrierte E-Mail: Supabase liefert einen User mit leerem
    // identities-Array (kein Error, um E-Mail-Enumeration zu verhindern).
    if (data.user && data.user.identities && data.user.identities.length === 0) {
        return { ok: false, code: "user_already_exists" };
    }

    // Ohne E-Mail-Bestaetigung (Projekteinstellung) gibt es sofort eine Sitzung.
    if (data.session) {
        revalidatePath("/", "layout");
        redirect(next);
    }

    return { ok: true, email };
}

export async function logout() {
    const supabase = await createClient();
    // Nur diese Sitzung beenden, die App bleibt angemeldet.
    await supabase.auth.signOut({ scope: "local" });
    revalidatePath("/", "layout");
    redirect("/");
}
