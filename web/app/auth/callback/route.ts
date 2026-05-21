import { NextResponse, type NextRequest } from "next/server";
import { createClient } from "@/lib/supabase/server";

export async function GET(request: NextRequest) {
    const { searchParams, origin } = new URL(request.url);
    const code = searchParams.get("code");
    const next = searchParams.get("next") ?? "/pruefungen";

    if (code) {
        const supabase = await createClient();
        const { error } = await supabase.auth.exchangeCodeForSession(code);

        if (!error) {
            return NextResponse.redirect(`${origin}${next}`);
        }
    }

    // Fehlerfall: zurück zum Login mit Fehlermeldung
    return NextResponse.redirect(
        `${origin}/login?error=${encodeURIComponent("Verifizierung fehlgeschlagen. Bitte erneut versuchen.")}`,
    );
}