"use client";

import { useState } from "react";
import { startCheckout, type Tier } from "@/lib/checkout";

export default function CheckoutButton({
    tier,
    label,
    primary = false,
}: {
    tier: Tier;
    label: string;
    primary?: boolean;
}) {
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState<string | null>(null);

    async function handleClick() {
        setLoading(true);
        setError(null);
        const err = await startCheckout(tier);
        if (err) {
            setError(err);
            setLoading(false);
        }
        // bei Erfolg läuft die Weiterleitung zu Stripe -> kein reset nötig
    }

    return (
        <>
            <button
                className={`up-cta ${primary ? "primary" : ""}`}
                onClick={handleClick}
                disabled={loading}
                style={{ cursor: loading ? "wait" : "pointer", opacity: loading ? 0.6 : 1 }}
            >
                {loading ? "Wird geladen…" : label}
            </button>
            {error && (
                <p style={{ color: "#DC2626", fontSize: 12, marginBottom: 12, marginTop: -12 }}>
                    {error}
                </p>
            )}
        </>
    );
}