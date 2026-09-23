import type { Metadata } from "next";
import ResetBestaetigen from "./ResetBestaetigen";

export const metadata: Metadata = {
    title: "Passwort zurücksetzen",
    robots: { index: false, follow: false },
};

export default function ResetConfirmPage() {
    return <ResetBestaetigen />;
}
