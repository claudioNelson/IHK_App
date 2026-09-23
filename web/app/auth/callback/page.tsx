import type { Metadata } from "next";
import Callback from "./Callback";

export const metadata: Metadata = {
    title: "E-Mail bestätigen",
    robots: { index: false, follow: false },
};

export default function AuthCallbackPage() {
    return <Callback />;
}
