// web/lib/portal.ts
import { createClient } from "@/lib/supabase/client";

/**
 * Öffnet das Stripe-Kundenportal (Abo verwalten/kündigen).
 * Gibt bei Fehler eine Meldung (string) zurück, sonst null (Weiterleitung läuft).
 */
export async function openCustomerPortal(): Promise<string | null> {
    const supabase = createClient();

    const {
        data: { session },
    } = await supabase.auth.getSession();

    if (!session) {
        window.location.href = "/login?next=/profil";
        return null;
    }

    const url = `${process.env.NEXT_PUBLIC_SUPABASE_URL}/functions/v1/create-portal-session`;

    try {
        const res = await fetch(url, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                Authorization: `Bearer ${session.access_token}`,
            },
        });

        const data = await res.json();

        if (!res.ok || !data.url) {
            return data.error ?? "Portal konnte nicht geöffnet werden.";
        }

        window.location.href = data.url;
        return null;
    } catch {
        return "Netzwerkfehler. Bitte erneut versuchen.";
    }
}