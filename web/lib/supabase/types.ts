export type PremiumTier = "monthly" | "yearly" | "lifetime";

export interface Profile {
    id: string;
    username: string | null;
    is_premium: boolean;
    premium_tier: PremiumTier | null;
    premium_until: string | null;  // ISO-Date
    avatar_url?: string | null;
}

export interface SubscriptionStatus {
    isPremium: boolean;
    tier: PremiumTier | null;
    expiresAt: Date | null;
    expiryLabel: string;
    loaded: boolean;
}