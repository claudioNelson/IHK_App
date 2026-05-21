import { createServerClient } from "@supabase/ssr";
import { NextResponse, type NextRequest } from "next/server";

export async function middleware(request: NextRequest) {
    let supabaseResponse = NextResponse.next({ request });

    const supabase = createServerClient(
        process.env.NEXT_PUBLIC_SUPABASE_URL!,
        process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
        {
            cookies: {
                getAll() {
                    return request.cookies.getAll();
                },
                setAll(cookiesToSet) {
                    cookiesToSet.forEach(({ name, value }) =>
                        request.cookies.set(name, value),
                    );
                    supabaseResponse = NextResponse.next({ request });
                    cookiesToSet.forEach(({ name, value, options }) =>
                        supabaseResponse.cookies.set(name, value, options),
                    );
                },
            },
        },
    );

    // WICHTIG: getUser() muss aufgerufen werden, damit die Session refreshed wird
    await supabase.auth.getUser();

    return supabaseResponse;
}

export const config = {
    matcher: [
        /*
         * Alle Routen außer:
         * - _next/static (statische Assets)
         * - _next/image (Bild-Optimierung)
         * - favicon.ico
         * - images/ (eigene Bilder)
         */
        "/((?!_next/static|_next/image|favicon.ico|images/).*)",
    ],
};