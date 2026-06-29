"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import { useSubscription } from "@/lib/hooks/useSubscription";
import { openCustomerPortal } from "@/lib/portal";

export default function ProfilPage() {
    const router = useRouter();
    const supabase = createClient();
    const sub = useSubscription();

    const [email, setEmail] = useState<string | null>(null);
    const [username, setUsername] = useState<string | null>(null);
    const [authLoaded, setAuthLoaded] = useState(false);

    const [portalLoading, setPortalLoading] = useState(false);
    const [portalError, setPortalError] = useState<string | null>(null);

    useEffect(() => {
        const load = async () => {
            const { data: { user } } = await supabase.auth.getUser();
            if (!user) {
                router.replace("/login?next=/profil");
                return;
            }
            setEmail(user.email ?? null);
            setUsername((user.user_metadata?.username as string) ?? null);
            setAuthLoaded(true);
        };
        load();
    }, [supabase, router]);

    const handleLogout = async () => {
        await supabase.auth.signOut();
        router.push("/");
    };

    const handlePortal = async () => {
        setPortalLoading(true);
        setPortalError(null);
        const err = await openCustomerPortal();
        if (err) {
            setPortalError(err);
            setPortalLoading(false);
        }
        // bei Erfolg: Weiterleitung zu Stripe läuft
    };

    if (!authLoaded) {
        return (
            <div style={{ minHeight: "100vh", background: "#FAFAF9" }} />
        );
    }

    const isPremium = sub.loaded && sub.isPremium;

    return (
        <div className="pf-wrap">
            <style>{`
                .pf-wrap {
                    min-height: 100vh;
                    background: #FAFAF9;
                    color: #0A0A0F;
                    font-family: 'Inter Tight', system-ui, sans-serif;
                    padding: 60px 24px 100px;
                }
                .pf-inner { max-width: 640px; margin: 0 auto; }
                .pf-back {
                    display: inline-flex; align-items: center; gap: 8px;
                    color: #55555F; text-decoration: none;
                    font-size: 13px; font-weight: 500;
                    margin-bottom: 32px;
                    padding: 8px 14px; border-radius: 8px;
                    border: 1px solid rgba(10,10,15,0.08); background: #FFFFFF;
                    transition: all 0.2s;
                }
                .pf-back:hover { border-color: rgba(10,10,15,0.16); transform: translateX(-3px); }
                .pf-title {
                    font-family: 'Instrument Serif', serif;
                    font-size: 42px; letter-spacing: -1px;
                    margin-bottom: 32px;
                }
                .pf-card {
                    background: #FFFFFF;
                    border: 1px solid rgba(10,10,15,0.08);
                    border-radius: 16px;
                    padding: 28px;
                    margin-bottom: 20px;
                }
                .pf-label {
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 11px; letter-spacing: 1px;
                    color: #8A8A92; text-transform: uppercase;
                    margin-bottom: 6px;
                }
                .pf-value { font-size: 16px; font-weight: 500; margin-bottom: 20px; }
                .pf-value:last-child { margin-bottom: 0; }
                .pf-badge {
                    display: inline-flex; align-items: center; gap: 8px;
                    padding: 6px 14px; border-radius: 100px;
                    font-size: 13px; font-weight: 600;
                }
                .pf-badge.premium {
                    background: linear-gradient(135deg, #7C6DFF, #22D3EE);
                    color: #FFFFFF;
                }
                .pf-badge.free {
                    background: rgba(10,10,15,0.06); color: #55555F;
                }
                .pf-sub-info {
                    font-size: 13px; color: #55555F; margin-top: 10px;
                }
                .pf-btn {
                    display: block; width: 100%; text-align: center;
                    padding: 13px; border-radius: 10px;
                    font-size: 14px; font-weight: 600;
                    cursor: pointer; border: none;
                    text-decoration: none;
                    transition: all 0.15s;
                }
                .pf-btn.primary { background: #0A0A0F; color: #FFFFFF; }
                .pf-btn.primary:hover { opacity: 0.85; }
                .pf-btn.outline {
                    background: #FFFFFF; color: #0A0A0F;
                    border: 1px solid rgba(10,10,15,0.16);
                }
                .pf-btn.outline:hover { background: #F4F4F1; }
                .pf-btn-row { display: flex; flex-direction: column; gap: 12px; margin-top: 8px; }
                .pf-error { color: #DC2626; font-size: 13px; margin-top: 12px; }
            `}</style>

            <div className="pf-inner">
                <Link href="/" className="pf-back">← Zur Startseite</Link>
                <h1 className="pf-title">Dein Konto</h1>

                {/* Konto-Infos */}
                <div className="pf-card">
                    {username && (
                        <>
                            <div className="pf-label">Benutzername</div>
                            <div className="pf-value">{username}</div>
                        </>
                    )}
                    <div className="pf-label">E-Mail</div>
                    <div className="pf-value">{email}</div>
                </div>

                {/* Abo-Status */}
                <div className="pf-card">
                    <div className="pf-label">Mitgliedschaft</div>
                    <div className="pf-value" style={{ marginBottom: 0 }}>
                        <span className={`pf-badge ${isPremium ? "premium" : "free"}`}>
                            {isPremium ? "Premium" : "Free"}
                        </span>
                    </div>

                    {isPremium && (
                        <div className="pf-sub-info">{sub.expiryLabel}</div>
                    )}

                    <div className="pf-btn-row">
                        {isPremium ? (
                            <button
                                className="pf-btn outline"
                                onClick={handlePortal}
                                disabled={portalLoading}
                                style={{ cursor: portalLoading ? "wait" : "pointer", opacity: portalLoading ? 0.6 : 1 }}
                            >
                                {portalLoading ? "Wird geladen…" : "Abo verwalten / kündigen"}
                            </button>
                        ) : (
                            <Link href="/upgrade" className="pf-btn primary">
                                Premium freischalten
                            </Link>
                        )}
                        {portalError && <p className="pf-error">{portalError}</p>}
                    </div>
                </div>

                {/* Logout */}
                <div className="pf-card">
                    <button className="pf-btn outline" onClick={handleLogout}>
                        Abmelden
                    </button>
                </div>
            </div>
        </div>
    );
}