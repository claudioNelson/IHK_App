import { createClient } from "@/lib/supabase/client";

export type Tier = "monthly" | "halfyear" | "yearly";

export async function startCheckout(tier: Tier): Promise<string | null> {
    const supabase = createClient();

    const {
        data: { session },
    } = await supabase.auth.getSession();

    if (!session) {
        window.location.href = "/login?next=/upgrade";
        return null;
    }

    const url = `${process.env.NEXT_PUBLIC_SUPABASE_URL}/functions/v1/create-checkout-session`;

    try {
        const res = await fetch(url, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                Authorization: `Bearer ${session.access_token}`,
            },
            body: JSON.stringify({ tier }),
        });

        const data = await res.json();

        if (!res.ok || !data.url) {
            return data.error ?? "Checkout konnte nicht gestartet werden.";
        }

        window.location.href = data.url;
        return null;
    } catch (e) {
        return "Netzwerkfehler beim Checkout. Bitte erneut versuchen.";
    }
}