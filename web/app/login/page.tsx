import Link from "next/link";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { login } from "./actions";

export default async function LoginPage({
    searchParams,
}: {
    searchParams: Promise<{ error?: string }>;
}) {
    // Wenn bereits eingeloggt → direkt zu Prüfungen weiterleiten
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (user) {
        redirect("/pruefungen");
    }

    const params = await searchParams;
    const error = params.error;

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
                <h1 className="auth-title">Willkommen zurück</h1>
                <div className="auth-sub">Lernarena · Login</div>

                {error && <div className="auth-error">{error}</div>}

                <form action={login}>
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
                            autoComplete="current-password"
                        />
                    </div>
                    <button className="auth-btn" type="submit">Einloggen</button>
                </form>

                <div className="auth-foot">
                    Noch kein Konto?{" "}
                    <Link className="auth-link" href="/signup">Jetzt registrieren</Link>
                </div>
            </div>
        </div>
    );
}