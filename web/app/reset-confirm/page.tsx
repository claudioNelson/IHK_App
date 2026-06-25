"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

export default function ResetConfirmPage() {
    const router = useRouter();
    const supabase = createClient();

    const [tokenHash, setTokenHash] = useState<string | null>(null);
    const [checked, setChecked] = useState(false);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState<string | null>(null);

    // Token-Hash aus der URL lesen (?token_hash=...&type=recovery).
    // WICHTIG: Hier wird NICHTS eingeloest – nur ausgelesen. Ein Mail-Scanner,
    // der diese Seite vorab oeffnet, verbraucht das Token also nicht.
    useEffect(() => {
        const params = new URLSearchParams(window.location.search);
        const th = params.get("token_hash");
        setTokenHash(th);
        setChecked(true);
    }, []);

    // Erst beim aktiven Button-Klick wird das Token eingeloest.
    async function handleConfirm() {
        if (!tokenHash) return;
        setLoading(true);
        setError(null);

        const { error } = await supabase.auth.verifyOtp({
            token_hash: tokenHash,
            type: "recovery",
        });

        if (error) {
            setLoading(false);
            setError(
                "Dieser Link ist ungültig oder abgelaufen. Bitte fordere den Passwort-Reset erneut an.",
            );
            return;
        }

        // Session ist jetzt aktiv -> weiter zur Passwort-Seite
        router.push("/update-password");
    }

    return (
        <div className="auth-wrap">
            <style>{`
                .auth-wrap { min-height:100vh; display:flex; align-items:center; justify-content:center; padding:40px 20px; background:#FAFAF9; font-family:'Inter Tight',system-ui,sans-serif; }
                .auth-card { width:100%; max-width:420px; background:#FFF; border:1px solid rgba(10,10,15,0.08); border-radius:16px; padding:36px 32px; box-shadow:0 8px 24px rgba(10,10,15,0.04); }
                .auth-title { font-family:'Instrument Serif',serif; font-style:italic; font-size:32px; color:#0A0A0F; margin:0 0 6px; }
                .auth-sub { font-family:'JetBrains Mono',monospace; font-size:11px; color:#55555F; text-transform:uppercase; letter-spacing:1px; margin-bottom:28px; }
                .auth-text { color:#0A0A0F; font-size:14px; line-height:1.6; margin-bottom:20px; }
                .auth-btn { width:100%; background:#7C6DFF; color:#FFF; border:none; border-radius:10px; padding:12px; font-family:'Inter Tight',system-ui,sans-serif; font-size:14px; font-weight:600; cursor:pointer; }
                .auth-btn:disabled { opacity:0.6; cursor:not-allowed; }
                .auth-error { background:#FEE2E2; border:1px solid #FCA5A5; color:#991B1B; border-radius:8px; padding:10px 14px; font-size:13px; margin-bottom:16px; }
                .auth-muted { color:#55555F; font-size:13px; }
            `}</style>

            <div className="auth-card">
                <h1 className="auth-title">Passwort zurücksetzen</h1>
                <div className="auth-sub">Lernarena · Bestätigung</div>

                {!checked && <p className="auth-muted">Einen Moment …</p>}

                {checked && !tokenHash && (
                    <div className="auth-error">
                        Dieser Link ist ungültig. Bitte fordere den Passwort-Reset
                        erneut an.
                    </div>
                )}

                {checked && tokenHash && (
                    <>
                        {error && <div className="auth-error">{error}</div>}
                        <p className="auth-text">
                            Klicke auf den Button, um fortzufahren und ein neues
                            Passwort zu vergeben.
                        </p>
                        <button
                            className="auth-btn"
                            onClick={handleConfirm}
                            disabled={loading}
                        >
                            {loading ? "Einen Moment …" : "Passwort jetzt zurücksetzen"}
                        </button>
                    </>
                )}
            </div>
        </div>
    );
}