import type { Metadata } from "next";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { sichererPfad } from "@/app/components/konto/fehler";
import AnmeldeFormular from "./AnmeldeFormular";

export const metadata: Metadata = {
    title: "Anmelden",
    robots: { index: false, follow: true },
};

export default async function LoginPage({
    searchParams,
}: {
    searchParams: Promise<{ next?: string; error?: string }>;
}) {
    const params = await searchParams;
    const next = sichererPfad(params.next);

    // Bereits angemeldet: direkt zum Ziel
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (user) {
        redirect(next);
    }

    // ?error=<code> (z. B. vom Callback), wird im Formular uebersetzt
    return <AnmeldeFormular next={next} startFehler={params.error ?? null} />;
}
