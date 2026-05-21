import Link from "next/link";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { signup } from "../login/actions";

export default async function SignupPage({
    searchParams,
}: {
    searchParams: Promise<{ error?: string; success?: string }>;
}) {
    // Wenn bereits eingeloggt → direkt zu Prüfungen weiterleiten
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (user) {
        redirect("/pruefungen");
    }

    const params = await searchParams;
    const error = params.error;
    const success = params.success;

    return (
        <div className="auth-wrap">
            <style>{`
                .auth-wrap {
                    min-height: 100vh;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    padding: 40px 20px;
                    background: #FAFAF9;
                    font-family: 'Inter Tight', system-ui, sans-serif;
                }
                .auth-card {
                    width: 100%;
                    max-width: 420px;
                    background: #FFFFFF;
                    border: 1px solid rgba(10,10,15,0.08);
                    border-radius: 16px;
                    padding: 36px 32px;
                    box-shadow: 0 8px 24px rgba(10,10,15,0.04);
                }
                .auth-title {
                    font-family: 'Instrument Serif', serif;
                    font-style: italic;
                    font-size: 32px;
                    color: #0A0A0F;
                    margin: 0 0 6px;
                }
                .auth-sub {
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 11px;
                    color: #55555F;
                    text-transform: uppercase;
                    letter-spacing: 1px;
                    margin-bottom: 28px;
                }
                .auth-field {
                    display: flex;
                    flex-direction: column;
                    gap: 6px;
                    margin-bottom: 16px;
                }
                .auth-label {
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 11px;
                    color: #55555F;
                    text-transform: uppercase;
                    letter-spacing: 1px;
                }
                .auth-input {
                    border: 1.5px solid rgba(10,10,15,0.12);
                    border-radius: 8px;
                    padding: 11px 14px;
                    font-family: 'Inter Tight', system-ui, sans-serif;
                    font-size: 14px;
                    color: #0A0A0F;
                    background: #FFFFFF;
                    outline: none;
                    transition: border-color 0.15s, box-shadow 0.15s;
                }
                .auth-input:focus {
                    border-color: #7C6DFF;
                    box-shadow: 0 0 0 3px rgba(124,109,255,0.15);
                }
                .auth-hint {
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 11px;
                    color: #55555F;
                    margin-top: 4px;
                }
                .auth-btn {
                    width: 100%;
                    background: #7C6DFF;
                    color: #FFFFFF;
                    border: none;
                    border-radius: 10px;
                    padding: 12px;
                    font-family: 'Inter Tight', system-ui, sans-serif;
                    font-size: 14px;
                    font-weight: 600;
                    cursor: pointer;
                    margin-top: 8px;
                    transition: background 0.15s, transform 0.05s;
                }
                .auth-btn:hover { background: #6856E6; }
                .auth-btn:active { transform: translateY(1px); }
                .auth-error {
                    background: #FEE2E2;
                    border: 1px solid #FCA5A5;
                    color: #991B1B;
                    border-radius: 8px;
                    padding: 10px 14px;
                    font-size: 13px;
                    margin-bottom: 16px;
                }
                .auth-success {
                    background: #DCFCE7;
                    border: 1px solid #86EFAC;
                    color: #14532D;
                    border-radius: 8px;
                    padding: 14px;
                    font-size: 14px;
                    margin-bottom: 16px;
                    line-height: 1.5;
                }
                .auth-foot {
                    margin-top: 22px;
                    text-align: center;
                    font-size: 13px;
                    color: #55555F;
                }
                .auth-link {
                    color: #7C6DFF;
                    text-decoration: none;
                    font-weight: 600;
                }
                .auth-link:hover { text-decoration: underline; }
            `}</style>

            <div className="auth-card">
                <h1 className="auth-title">Konto erstellen</h1>
                <div className="auth-sub">Lernarena · Registrierung</div>

                {error && <div className="auth-error">{error}</div>}
                {success && (
                    <div className="auth-success">
                        <strong>Fast geschafft!</strong> Wir haben dir eine
                        Bestätigungs-E-Mail geschickt. Klick auf den Link in
                        der E-Mail um dein Konto zu aktivieren.
                    </div>
                )}

                {!success && (
                    <form action={signup}>
                        <div className="auth-field">
                            <label className="auth-label" htmlFor="username">Benutzername</label>
                            <input
                                className="auth-input"
                                id="username"
                                name="username"
                                type="text"
                                required
                                minLength={3}
                                autoComplete="username"
                                placeholder="dein_name"
                            />
                            <div className="auth-hint">Mindestens 3 Zeichen</div>
                        </div>
                        <div className="auth-field">
                            <label className="auth-label" htmlFor="email">E-Mail</label>
                            <input
                                className="auth-input"
                                id="email"
                                name="email"
                                type="email"
                                required
                                autoComplete="email"
                            />
                        </div>
                        <div className="auth-field">
                            <label className="auth-label" htmlFor="password">Passwort</label>
                            <input
                                className="auth-input"
                                id="password"
                                name="password"
                                type="password"
                                required
                                minLength={6}
                                autoComplete="new-password"
                            />
                            <div className="auth-hint">Mindestens 6 Zeichen</div>
                        </div>
                        <div className="auth-field">
                            <label className="auth-label" htmlFor="passwordConfirm">Passwort wiederholen</label>
                            <input
                                className="auth-input"
                                id="passwordConfirm"
                                name="passwordConfirm"
                                type="password"
                                required
                                minLength={6}
                                autoComplete="new-password"
                            />
                        </div>
                        <button className="auth-btn" type="submit">Konto erstellen</button>
                    </form>
                )}

                <div className="auth-foot">
                    Schon ein Konto?{" "}
                    <Link className="auth-link" href="/login">Jetzt einloggen</Link>
                </div>
            </div>
        </div>
    );
}