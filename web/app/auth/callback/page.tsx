"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

export default function AuthCallbackPage() {
    const router = useRouter();
    const [error, setError] = useState<string | null>(null);

    useEffect(() => {
        const run = async () => {
            const supabase = createClient();

            // Tokens kommen im Hash-Fragment (#access_token=...&refresh_token=...)
            const raw = window.location.hash.replace(/^#/, "");
            const hashParams = new URLSearchParams(raw);
            const accessToken = hashParams.get("access_token");
            const refreshToken = hashParams.get("refresh_token");
            const hashError = hashParams.get("error_description");

            if (hashError) {
                setError(decodeURIComponent(hashError));
                return;
            }

            if (accessToken && refreshToken) {
                const { error } = await supabase.auth.setSession({
                    access_token: accessToken,
                    refresh_token: refreshToken,
                });
                if (error) {
                    setError(error.message);
                    return;
                }
                router.replace("/pruefungen");
                return;
            }

            // Bestätigung per token_hash (geräteunabhängig, kein PKCE nötig)
            const query = new URLSearchParams(window.location.search);
            const tokenHash = query.get("token_hash");
            const type = query.get("type");

            if (tokenHash) {
                const { error } = await supabase.auth.verifyOtp({
                    token_hash: tokenHash,
                    type: (type ?? "signup") as "signup" | "email",
                });
                if (error) {
                    setError(error.message);
                    return;
                }
                router.replace("/pruefungen");
                return;
            }

            setError("Kein gültiger Bestätigungslink.");
        };

        run();
    }, [router]);

    return (
        <div style={{ display: "flex", minHeight: "60vh", alignItems: "center", justifyContent: "center", padding: "2rem" }}>
            {error ? (
                <div style={{ textAlign: "center" }}>
                    <p>Bestätigung fehlgeschlagen: {error}</p>
                    <a href="/login">Zum Login</a>
                </div>
            ) : (
                <p>E-Mail wird bestätigt …</p>
            )}
        </div>
    );
}