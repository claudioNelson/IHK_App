"use client";

import { useEffect, useState, useCallback } from "react";
import { createClient } from "@/lib/supabase/client";
import type { Profile, PremiumTier, SubscriptionStatus } from "@/lib/supabase/types";

const defaultStatus: SubscriptionStatus = {
    isPremium: false,
    tier: null,
    expiresAt: null,
    expiryLabel: "Kostenlos",
    loaded: false,
};

function datumDe(d: Date): string {
    return d.toLocaleDateString("de-DE", { day: "2-digit", month: "2-digit", year: "numeric" });
}

// Kurztext zur Laufzeit, z. B. "Läuft noch 1 Tag, bis 14.03.2027" oder
// "Läuft noch 5 Monate, bis 14.03.2027".
function computeExpiryLabel(isPremium: boolean, tier: PremiumTier | null, expiresAt: Date | null): string {
    if (tier === "lifetime" && isPremium) return "Dauerhaft";
    if (!isPremium) return expiresAt && expiresAt < new Date() ? "Abgelaufen" : "Kostenlos";
    if (!expiresAt) return "Aktiv";

    const days = Math.floor((expiresAt.getTime() - Date.now()) / (1000 * 60 * 60 * 24));
    const bis = `bis ${datumDe(expiresAt)}`;

    if (days < 0) return "Abgelaufen";
    if (days === 0) return `Läuft heute ab, ${bis}`;
    if (days < 30) return `Läuft noch ${days} ${days === 1 ? "Tag" : "Tage"}, ${bis}`;
    const months = Math.round(days / 30);
    return `Läuft noch ${months} ${months === 1 ? "Monat" : "Monate"}, ${bis}`;
}

export function useSubscription() {
    const [status, setStatus] = useState<SubscriptionStatus>(defaultStatus);
    const supabase = createClient();

    const load = useCallback(async () => {
        const { data: { user } } = await supabase.auth.getUser();
        if (!user) {
            setStatus({ ...defaultStatus, loaded: true });
            return;
        }

        const { data: profile, error } = await supabase
            .from("profiles")
            .select("is_premium, premium_until, premium_tier")
            .eq("id", user.id)
            .maybeSingle<Pick<Profile, "is_premium" | "premium_until" | "premium_tier">>();

        if (error || !profile) {
            setStatus({ ...defaultStatus, loaded: true });
            return;
        }

        const isPremiumDb = profile.is_premium === true;
        const untilStr = profile.premium_until;
        const tier = profile.premium_tier;

        let expiresAt: Date | null = null;
        if (untilStr) {
            const parsed = new Date(untilStr);
            if (!isNaN(parsed.getTime())) expiresAt = parsed;
        }

        // Auto-Expire: wenn Abo abgelaufen, DB updaten + lokalen Status anpassen
        let stillPremium = isPremiumDb;
        if (isPremiumDb && tier !== "lifetime" && expiresAt && expiresAt < new Date()) {
            stillPremium = false;
            await supabase
                .from("profiles")
                .update({ is_premium: false })
                .eq("id", user.id);
        }

        setStatus({
            isPremium: stillPremium,
            tier,
            expiresAt,
            expiryLabel: computeExpiryLabel(stillPremium, tier, expiresAt),
            loaded: true,
        });
    }, [supabase]);

    useEffect(() => {
        load();

        // Bei Anmelden oder Abmelden neu laden
        const { data: { subscription } } = supabase.auth.onAuthStateChange(() => {
            load();
        });

        return () => subscription.unsubscribe();
    }, [load, supabase]);

    return { ...status, refresh: load };
}