"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

export default function UpdatePasswordPage() {
    const router = useRouter();
    const supabase = createClient();

    const [ready, setReady] = useState(false);
    const [sessionOk, setSessionOk] = useState(false);
    const [password, setPassword] = useState("");
    const [confirm, setConfirm] = useState("");
    const [error, setError] = useState<string | null>(null);
    const [loading, setLoading] = useState(false);
    const [done, setDone] = useState(false);

    // Recovery-Session herstellen.
    // Wir lesen das Token SELBST aus dem URL-Fragment (#access_token=...)
    // und setzen die Session aktiv per setSession(). Das ist unabhaengig
    // davon, ob der Client die URL automatisch verarbeitet.
    useEffect(() => {
        async function init() {
            try {
                // 1) Vielleicht ist schon eine Session da
                const existing = await supabase.auth.getSession();
                if (existing.data.session) {
                    setSessionOk(true);
                    setReady(true);
                    return;
                }

                // 2) Token aus dem #-Fragment auslesen
                const hash = window.location.hash.startsWith("#")
                    ? window.location.hash.substring(1)
                    : window.location.hash;
                const params = new URLSearchParams(hash);
                const access_token = params.get("access_token");
                const refresh_token = params.get("refresh_token");
                const errorCode = params.get("error_code") || params.get("error");

                if (errorCode) {
                    setSessionOk(false);
                    setReady(true);
                    return;
                }

                if (access_token && refresh_token) {
                    const { data, error } = await supabase.auth.setSession({
                        access_token,
                        refresh_token,
                    });
                    setSessionOk(!!data.session && !error);
                    setReady(true);
                    return;
                }

                // 3) Nichts gefunden
                setSessionOk(false);
                setReady(true);
            } catch {
                setSessionOk(false);
                setReady(true);
            }
        }
        init();
    }, [supabase]);

    async function handleSubmit(e: React.FormEvent) {
        e.preventDefault();
        setError(null);

        if (password.length < 6) {
            setError("Das Passwort muss mindestens 6 Zeichen lang sein.");
            return;
        }
        if (password !== confirm) {
            setError("Passwörter stimmen nicht überein.");
            return;
        }

        setLoading(true);
        const { error } = await supabase.auth.updateUser({ password });
        setLoading(false);

        if (error) {
            const msg = error.message.toLowerCase();
            if (msg.includes("different from the old")) {
                setError("Das neue Passwort muss sich vom alten unterscheiden.");
            } else if (msg.includes("at least") || msg.includes("password")) {
                setError("Das Passwort erfüllt nicht die Anforderungen (mind. 6 Zeichen).");
            } else if (msg.includes("session") || msg.includes("expired") || msg.includes("token")) {
                setError("Deine Sitzung ist abgelaufen. Bitte fordere den Passwort-Reset erneut an.");
            } else {
                setError("Das Passwort konnte nicht geändert werden. Bitte versuche es erneut.");
            }
            return;
        }
        setDone(true);
        setTimeout(() => router.push("/login"), 2500);
    }

    return (
        <div className="auth-wrap">
            <style>{`
                .auth-wrap { min-height:100vh; display:flex; align-items:center; justify-content:center; padding:40px 20px; background:#FAFAF9; font-family:'Inter Tight',system-ui,sans-serif; }
                .auth-card { width:100%; max-width:420px; background:#FFF; border:1px solid rgba(10,10,15,0.08); border-radius:16px; padding:36px 32px; box-shadow:0 8px 24px rgba(10,10,15,0.04); }
                .auth-title { font-family:'Instrument Serif',serif; font-style:italic; font-size:32px; color:#0A0A0F; margin:0 0 6px; }
                .auth-sub { font-family:'JetBrains Mono',monospace; font-size:11px; color:#55555F; text-transform:uppercase; letter-spacing:1px; margin-bottom:28px; }
                .auth-field { display:flex; flex-direction:column; gap:6px; margin-bottom:16px; }
                .auth-label { font-family:'JetBrains Mono',monospace; font-size:11px; color:#55555F; text-transform:uppercase; letter-spacing:1px; }
                .auth-input { border:1.5px solid rgba(10,10,15,0.12); border-radius:8px; padding:11px 14px; font-family:'Inter Tight',system-ui,sans-serif; font-size:14px; color:#0A0A0F; background:#FFF; outline:none; }
                .auth-input:focus { border-color:#7C6DFF; box-shadow:0 0 0 3px rgba(124,109,255,0.15); }
                .auth-btn { width:100%; background:#7C6DFF; color:#FFF; border:none; border-radius:10px; padding:12px; font-family:'Inter Tight',system-ui,sans-serif; font-size:14px; font-weight:600; cursor:pointer; margin-top:8px; }
                .auth-btn:disabled { opacity:0.6; cursor:not-allowed; }
                .auth-error { background:#FEE2E2; border:1px solid #FCA5A5; color:#991B1B; border-radius:8px; padding:10px 14px; font-size:13px; margin-bottom:16px; }
                .auth-success { background:#DCFCE7; border:1px solid #86EFAC; color:#14532D; border-radius:8px; padding:14px; font-size:14px; margin-bottom:16px; line-height:1.5; }
                .auth-muted { color:#55555F; font-size:13px; }
            `}</style>

            <div className="auth-card">
                <h1 className="auth-title">Neues Passwort</h1>
                <div className="auth-sub">Lernarena · Passwort zurücksetzen</div>

                {!ready && <p className="auth-muted">Einen Moment …</p>}

                {ready && !sessionOk && !done && (
                    <div className="auth-error">
                        Dieser Link ist ungültig oder abgelaufen. Bitte fordere den
                        Passwort-Reset erneut an.
                    </div>
                )}

                {done && (
                    <div className="auth-success">
                        <strong>Passwort geändert!</strong> Du wirst zum Login
                        weitergeleitet …
                    </div>
                )}

                {ready && sessionOk && !done && (
                    <form onSubmit={handleSubmit}>
                        {error && <div className="auth-error">{error}</div>}
                        <div className="auth-field">
                            <label className="auth-label" htmlFor="password">Neues Passwort</label>
                            <input
                                className="auth-input"
                                id="password"
                                type="password"
                                value={password}
                                onChange={(e) => setPassword(e.target.value)}
                                required
                                minLength={6}
                                autoComplete="new-password"
                            />
                        </div>
                        <div className="auth-field">
                            <label className="auth-label" htmlFor="confirm">Passwort wiederholen</label>
                            <input
                                className="auth-input"
                                id="confirm"
                                type="password"
                                value={confirm}
                                onChange={(e) => setConfirm(e.target.value)}
                                required
                                minLength={6}
                                autoComplete="new-password"
                            />
                        </div>
                        <button className="auth-btn" type="submit" disabled={loading}>
                            {loading ? "Speichert …" : "Passwort speichern"}
                        </button>
                    </form>
                )}
            </div>
        </div>
    );
}