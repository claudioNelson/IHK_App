import type { Metadata } from "next";
import NeuesPasswort from "./NeuesPasswort";

export const metadata: Metadata = {
    title: "Neues Passwort setzen",
    robots: { index: false, follow: false },
};

export default function UpdatePasswordPage() {
    return <NeuesPasswort />;
}
