"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";

export async function login(formData: FormData) {
    const supabase = await createClient();

    const email = formData.get("email") as string;
    const password = formData.get("password") as string;

    console.log("🔍 [LOGIN] Attempt:", {
        email,
        passwordLength: password?.length,
        supabaseUrl: process.env.NEXT_PUBLIC_SUPABASE_URL,
        anonKeyPrefix: process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY?.slice(0, 20) + "...",
    });

    const { data, error } = await supabase.auth.signInWithPassword({ email, password });

    if (error) {
        console.error("❌ [LOGIN] Supabase error:", {
            message: error.message,
            status: error.status,
            code: error.code,
            name: error.name,
        });
        redirect(`/login?error=${encodeURIComponent(error.message)}`);
    }

    console.log("✅ [LOGIN] Success:", {
        userId: data.user?.id,
        email: data.user?.email,
    });

    revalidatePath("/", "layout");
    redirect("/pruefungen");
}

export async function signup(formData: FormData) {
    const supabase = await createClient();

    const email = formData.get("email") as string;
    const password = formData.get("password") as string;
    const passwordConfirm = formData.get("passwordConfirm") as string;
    const username = (formData.get("username") as string)?.trim();

    // Validierung: Username
    if (!username || username.length < 3) {
        redirect(`/signup?error=${encodeURIComponent("Benutzername muss mindestens 3 Zeichen lang sein.")}`);
    }

    // Validierung: Passwörter müssen übereinstimmen
    if (password !== passwordConfirm) {
        redirect(`/signup?error=${encodeURIComponent("Passwörter stimmen nicht überein.")}`);
    }

    // Validierung: Mindestlänge
    if (password.length < 6) {
        redirect(`/signup?error=${encodeURIComponent("Das Passwort muss mindestens 6 Zeichen lang sein.")}`);
    }

    const { data, error } = await supabase.auth.signUp({
        email,
        password,
        options: {
            emailRedirectTo: `${process.env.NEXT_PUBLIC_SITE_URL ?? "http://localhost:3000"}/auth/callback`,
            data: { username },  // → wird in user_metadata gespeichert, Trigger erstellt profiles-Eintrag
        },
    });

    if (error) {
        redirect(`/signup?error=${encodeURIComponent(error.message)}`);
    }

    // Bereits registrierte E-Mail: Supabase liefert einen User mit leerem
    // identities-Array (kein Error, um E-Mail-Enumeration zu verhindern).
    if (data.user && data.user.identities && data.user.identities.length === 0) {
        redirect(
            `/signup?error=${encodeURIComponent("Diese E-Mail-Adresse ist bereits registriert. Bitte melde dich an.")}`,
        );
    }

    redirect("/signup?success=1");
}

export async function logout() {
    const supabase = await createClient();
    await supabase.auth.signOut();
    revalidatePath("/", "layout");
    redirect("/");
}