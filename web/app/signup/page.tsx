import type { Metadata } from "next";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { sichererPfad } from "@/app/components/konto/fehler";
import SignupFormular from "./SignupFormular";

export const metadata: Metadata = {
    title: "Konto anlegen",
    robots: { index: false, follow: true },
};

export default async function SignupPage({
    searchParams,
}: {
    searchParams: Promise<{ next?: string }>;
}) {
    const params = await searchParams;
    const next = sichererPfad(params.next);

    // Bereits angemeldet: direkt zum Ziel
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (user) {
        redirect(next);
    }

    return <SignupFormular next={next} />;
}
