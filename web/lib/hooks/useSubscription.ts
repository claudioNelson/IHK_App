"use client";

import { useEffect, useState, useCallback } from "react";
import { createClient } from "@/lib/supabase/client";
import type { Profile, PremiumTier, SubscriptionStatus } from "@/lib/supabase/types";

const defaultStatus: SubscriptionStatus = {
    isPremium: false,
    tier: null,
    expiresAt: null,
    expiryLabel: "Free",
    loaded: false,
};

function computeExpiryLabel(isPremium: boolean, tier: PremiumTier | null, expiresAt: Date | null): string {
    if (!isPremium) return "Free";
    if (tier === "lifetime") return "Lifetime";
    if (!expiresAt) return "Aktiv";

    const now = new Date();
    const days = Math.round((expiresAt.getTime() - now.getTime()) / (1000 * 60 * 60 * 24));

    if (days < 0) return "Abgelaufen";
    if (days < 30) return `Läuft in ${days} Tagen ab`;
    const months = Math.round(days / 30);
    return `Läuft in ${months} Monaten ab`;
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

        // Bei Auth-Changes neu laden (Login/Logout)
        const { data: { subscription } } = supabase.auth.onAuthStateChange(() => {
            load();
        });

        return () => subscription.unsubscribe();
    }, [load, supabase]);

    return { ...status, refresh: load };
}