import { redirect } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import CheckoutButton from "./CheckoutButton";

export default async function UpgradePage({
    searchParams,
}: {
    searchParams: Promise<{ next?: string }>;
}) {
    const params = await searchParams;
    const next = params.next ?? "/pruefungen";

    // Auth-Check
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();

    // Nicht eingeloggt → Login mit double-redirect (Login → Upgrade → eigentliche Prüfung)
    if (!user) {
        redirect(`/login?next=/upgrade?next=${encodeURIComponent(next)}`);
    }

    // Schon Premium → direkt weiter zum Ziel
    const { data: profile } = await supabase
        .from("profiles")
        .select("is_premium, premium_tier, premium_until")
        .eq("id", user.id)
        .maybeSingle();

    if (profile?.is_premium === true) {
        // Auto-Expire-Check
        const tier = profile.premium_tier;
        const until = profile.premium_until ? new Date(profile.premium_until) : null;
        const isExpired = until && until < new Date();
        if (!isExpired) {
            redirect(next);
        }
    }

    return (
        <div className="up-wrap">
            <style>{`
                .up-wrap {
                    min-height: 100vh;
                    background: #FAFAF9;
                    color: #0A0A0F;
                    font-family: 'Inter Tight', system-ui, sans-serif;
                    padding: 60px 24px 100px;
                }
                .up-inner {
                    max-width: 1100px;
                    margin: 0 auto;
                }
                .up-back {
                    display: inline-flex;
                    align-items: center;
                    gap: 8px;
                    color: #55555F;
                    text-decoration: none;
                    font-size: 13px;
                    font-weight: 500;
                    margin-bottom: 40px;
                    padding: 8px 14px;
                    border-radius: 8px;
                    border: 1px solid rgba(10,10,15,0.08);
                    background: #FFFFFF;
                    transition: all 0.2s;
                }
                .up-back:hover {
                    border-color: rgba(10,10,15,0.16);
                    transform: translateX(-3px);
                }
                .up-header {
                    text-align: center;
                    margin-bottom: 56px;
                }
                .up-eyebrow {
                    display: inline-flex;
                    align-items: center;
                    gap: 8px;
                    padding: 6px 12px;
                    border: 1px solid rgba(10,10,15,0.08);
                    border-radius: 100px;
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 11px;
                    font-weight: 500;
                    color: #55555F;
                    margin-bottom: 24px;
                    background: #FFFFFF;
                }
                .up-eyebrow-dot {
                    width: 6px; height: 6px;
                    border-radius: 50%;
                    background: #7C6DFF;
                    box-shadow: 0 0 8px #7C6DFF;
                }
                .up-title {
                    font-size: clamp(32px, 5vw, 52px);
                    font-weight: 600;
                    line-height: 1.05;
                    letter-spacing: -1.5px;
                    margin-bottom: 16px;
                }
                .up-title em {
                    font-family: 'Instrument Serif', serif;
                    font-style: italic;
                    font-weight: 400;
                    color: #7C6DFF;
                }
                .up-sub {
                    font-size: 16px;
                    line-height: 1.6;
                    color: #55555F;
                    max-width: 540px;
                    margin: 0 auto;
                }

                .up-grid {
                    display: grid;
                    grid-template-columns: repeat(3, 1fr);
                    gap: 20px;
                }
                .up-plan {
                    background: #FFFFFF;
                    border: 1px solid rgba(10,10,15,0.08);
                    border-radius: 18px;
                    padding: 32px 26px;
                    display: flex;
                    flex-direction: column;
                    position: relative;
                    transition: all 0.2s;
                }
                .up-plan:hover {
                    border-color: rgba(10,10,15,0.18);
                    transform: translateY(-3px);
                    box-shadow: 0 12px 32px rgba(10,10,15,0.06);
                }
                .up-plan.featured {
                    border-color: #7C6DFF;
                    box-shadow: 0 0 0 1px #7C6DFF, 0 12px 32px rgba(124,109,255,0.15);
                }
                .up-plan.featured:hover {
                    transform: translateY(-3px);
                    box-shadow: 0 0 0 1px #7C6DFF, 0 16px 40px rgba(124,109,255,0.22);
                }
                .up-badge {
                    position: absolute;
                    top: -12px;
                    left: 50%;
                    transform: translateX(-50%);
                    background: linear-gradient(135deg, #7C6DFF, #22D3EE);
                    color: #FFFFFF;
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 11px;
                    font-weight: 600;
                    letter-spacing: 1px;
                    padding: 5px 12px;
                    border-radius: 6px;
                    text-transform: uppercase;
                }
                .up-plan-name {
                    font-family: 'Instrument Serif', serif;
                    font-style: italic;
                    font-size: 28px;
                    letter-spacing: -0.5px;
                    margin-bottom: 4px;
                }
                .up-plan-tag {
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 11px;
                    color: #8A8A92;
                    letter-spacing: 1px;
                    text-transform: uppercase;
                    margin-bottom: 22px;
                }
                .up-price-row {
                    display: flex;
                    align-items: baseline;
                    gap: 6px;
                    margin-bottom: 4px;
                }
                .up-price {
                    font-size: 38px;
                    font-weight: 700;
                    letter-spacing: -1.5px;
                    color: #0A0A0F;
                }
                .up-period {
                    font-size: 14px;
                    color: #55555F;
                    font-weight: 500;
                }
                .up-note {
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 11px;
                    color: #7C6DFF;
                    letter-spacing: 0.5px;
                    margin-bottom: 22px;
                    min-height: 14px;
                }
                .up-cta {
                    display: block;
                    width: 100%;
                    background: #FFFFFF;
                    color: #0A0A0F;
                    border: 1.5px solid rgba(10,10,15,0.12);
                    padding: 12px;
                    border-radius: 10px;
                    font-family: 'Inter Tight', system-ui, sans-serif;
                    font-size: 14px;
                    font-weight: 600;
                    cursor: not-allowed;
                    margin-bottom: 22px;
                    transition: all 0.15s;
                    text-align: center;
                    opacity: 0.6;
                }
                .up-cta.primary {
                    background: linear-gradient(135deg, #7C6DFF, #6856E6);
                    color: #FFFFFF;
                    border-color: transparent;
                }
                .up-features {
                    list-style: none;
                    padding: 0;
                    margin: 0;
                    border-top: 1px solid rgba(10,10,15,0.06);
                    padding-top: 20px;
                }
                .up-feature {
                    display: flex;
                    align-items: flex-start;
                    gap: 10px;
                    padding: 6px 0;
                    font-size: 13px;
                    color: #0A0A0F;
                    line-height: 1.4;
                }
                .up-feature::before {
                    content: '✓';
                    color: #7C6DFF;
                    font-weight: 600;
                    flex-shrink: 0;
                    margin-top: 1px;
                }

                .up-coming {
                    text-align: center;
                    margin-top: 40px;
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 12px;
                    color: #8A8A92;
                    letter-spacing: 0.5px;
                }

                @media (max-width: 800px) {
                    .up-grid { grid-template-columns: 1fr; }
                    .up-wrap { padding: 32px 16px 64px; }
                }
            `}</style>

            <div className="up-inner">
                <Link href="/pruefungen" className="up-back">← Zurück zu Prüfungen</Link>

                <div className="up-header">
                    <div className="up-eyebrow">
                        <span className="up-eyebrow-dot" />
                        Premium · Lernarena
                    </div>
                    <h1 className="up-title">
                        Schalte alle Prüfungen <em>frei.</em>
                    </h1>
                    <p className="up-sub">
                        Originalgetreue IHK-Prüfungen, KI-Tutor, Lernpfade
                        und Zertifikate. Wähle den Plan, der zu dir passt.
                    </p>
                </div>

                <div className="up-grid">
    {/* MONATLICH */}
    <div className="up-plan">
        <div className="up-plan-name">Monatlich</div>
        <div className="up-plan-tag">Flexibel</div>
        <div className="up-price-row">
            <span className="up-price">9,99€</span>
            <span className="up-period">/ Monat</span>
        </div>
        <div className="up-note">Monatlich kündbar</div>
        <CheckoutButton tier="monthly" label="Monatlich starten" />
                        <ul className="up-features">
                            <li className="up-feature">Alle 937 Prüfungsfragen</li>
            <li className="up-feature">Alle Lernpfade (33 Levels)</li>
            <li className="up-feature">Echte IHK-Prüfungssimulation</li>
            <li className="up-feature">Ada KI-Tutor unbegrenzt</li>
            <li className="up-feature">Jederzeit kündbar</li>
        </ul>
    </div>

    {/* HALBJAHR */}
    <div className="up-plan">
        <div className="up-plan-name">Halbjahr</div>
        <div className="up-plan-tag">Beliebt</div>
        <div className="up-price-row">
            <span className="up-price">39,99€</span>
            <span className="up-period">/ 6 Monate</span>
        </div>
        <div className="up-note">≈ 6,67€/Monat · 20€ gespart</div>
        <CheckoutButton tier="halfyear" label="Halbjahr starten" />
                        <ul className="up-features">
                            <li className="up-feature">Alles aus Monatlich</li>
            <li className="up-feature">6 Monate Vollzugang</li>
            <li className="up-feature">Cloud-Zertifikate inklusive</li>
            <li className="up-feature">Deckt die heiße Prüfungsphase ab</li>
            <li className="up-feature">Auto-Verlängerung, jederzeit kündbar</li>
        </ul>
    </div>

    {/* JÄHRLICH */}
    <div className="up-plan featured">
        <div className="up-badge">Empfohlen · 42% sparen</div>
        <div className="up-plan-name">Jährlich</div>
        <div className="up-plan-tag">Bestpreis</div>
        <div className="up-price-row">
            <span className="up-price">69,99€</span>
            <span className="up-period">/ Jahr</span>
        </div>
        <div className="up-note">≈ 5,83€/Monat · 50€ gespart</div>
        <CheckoutButton tier="yearly" label="Jährlich starten" primary />
                        <ul className="up-features">
                            <li className="up-feature">Alles aus Halbjahr</li>
            <li className="up-feature">12 Monate Vollzugang</li>
            <li className="up-feature">Bevorzugter Support</li>
            <li className="up-feature">Früher Zugang zu neuen Features</li>
            <li className="up-feature">Bester Preis pro Monat</li>
        </ul>
    </div>
</div>

                <p className="up-coming">
                    🔒 Sichere Zahlung über Stripe · jederzeit kündbar
                </p>
            </div>
        </div>
    );
}