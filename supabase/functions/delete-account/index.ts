// supabase/functions/delete-account/index.ts
//
// Löscht das Konto des aufrufenden Nutzers samt aller personenbezogenen
// Daten. Aufruf aus der App über supabase.functions.invoke('delete-account').
//
// WARUM ES DIESE FUNKTION GIBT
// Apple verlangt seit 2022 (Guideline 5.1.1(v)), dass Apps mit
// Kontoerstellung die Löschung IN DER APP anbieten. Ein Verweis auf E-Mail
// oder eine Webseite reicht nicht und führt zur Ablehnung.
//
// WARUM SERVERSEITIG
// Einen Auth-Nutzer zu löschen erfordert den Service-Role-Key. Der darf
// niemals in die App — jeder könnte ihn aus dem Binary ziehen und damit die
// gesamte Datenbank übernehmen. Deshalb prüft diese Funktion das JWT des
// Aufrufers und löscht ausschliesslich dessen eigenes Konto.
//
// WARUM MANUELL AUFGERÄUMT WIRD
// Geprüft am 02.09.2026: Es existiert KEIN Fremdschlüssel von public auf
// auth.users. Ein DELETE auf den Auth-Nutzer laesst also ueberall verwaiste
// Zeilen zurueck. Solange sich das nicht aendert, muss hier jede Tabelle
// einzeln stehen. Neue Tabelle mit user_id? Dann auch hier eintragen.

// deno-lint-ignore-file no-explicit-any
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!
const SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
const ANON_KEY = Deno.env.get('SUPABASE_ANON_KEY')!

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
}

// Tabellen mit einer user_id-Spalte, in Reihenfolge.
// profiles kommt zuletzt, weil andere Abfragen darauf verweisen koennen.
const TABELLEN_MIT_USER_ID = [
  'usage_tracking',
  'spaced_repetition',
  'flashcards',
  'kurs_fortschritt',
  'thema_scores',
  'level_progress',
  'user_progress',
  'user_badges',
  'user_certificates',
  'question_reports',
  'player_stats',
]

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // ─── 1. Wer ruft an? ─────────────────────────
    const authHeader = req.headers.get('Authorization')
    if (!authHeader) {
      return json({ error: 'Missing authorization header' }, 401)
    }

    // Bewusst mit dem ANON-Key: dieser Client dient nur dazu, das JWT des
    // Aufrufers zu pruefen. Er bekommt keine erhoehten Rechte.
    const alsNutzer = createClient(SUPABASE_URL, ANON_KEY, {
      global: { headers: { Authorization: authHeader } },
    })

    const {
      data: { user },
      error: userError,
    } = await alsNutzer.auth.getUser()

    if (userError || !user) {
      return json({ error: 'Unauthorized' }, 401)
    }

    const uid = user.id

    // ─── 2. Absichtserklaerung pruefen ───────────
    // Schutz vor versehentlichen Aufrufen: Die App muss ausdruecklich
    // { bestaetigung: "LOESCHEN" } senden.
    let body: any = {}
    try {
      body = await req.json()
    } catch {
      body = {}
    }
    if (body?.bestaetigung !== 'LOESCHEN') {
      return json(
        { error: 'Bestaetigung fehlt', code: 'CONFIRMATION_REQUIRED' },
        400,
      )
    }

    // ─── 3. Aufraeumen mit Service-Role ──────────
    const admin = createClient(SUPABASE_URL, SERVICE_ROLE_KEY)
    const geloescht: string[] = []
    const fehler: string[] = []

    for (const tabelle of TABELLEN_MIT_USER_ID) {
      const { error } = await admin.from(tabelle).delete().eq('user_id', uid)
      if (error) {
        console.warn(`${tabelle}: ${error.message}`)
        fehler.push(tabelle)
      } else {
        geloescht.push(tabelle)
      }
    }

    // Pruefungsversuche: die Antworten haengen am Versuch, nicht am Nutzer.
    const { data: versuche } = await admin
      .from('user_exam_attempts')
      .select('id')
      .eq('user_id', uid)

    if (versuche && versuche.length > 0) {
      const versuchIds = versuche.map((v: any) => v.id)
      await admin.from('user_exam_answers').delete().in('attempt_id', versuchIds)
      await admin.from('user_exam_attempts').delete().eq('user_id', uid)
      geloescht.push('user_exam_attempts')
    }

    // Matches: der Nutzer kann Spieler 1 oder Spieler 2 sein. Fragen,
    // Antworten und Punktestaende haengen an der Match-ID.
    const { data: matches } = await admin
      .from('matches')
      .select('id')
      .or(`player1_id.eq.${uid},player2_id.eq.${uid}`)

    if (matches && matches.length > 0) {
      const matchIds = matches.map((m: any) => m.id)
      await admin.from('match_answers').delete().in('match_id', matchIds)
      await admin.from('match_questions').delete().in('match_id', matchIds)
      await admin.from('match_scores').delete().in('match_id', matchIds)
      await admin.from('matches').delete().in('id', matchIds)
      geloescht.push(`matches (${matchIds.length})`)
    }

    // Profil zuletzt.
    const { error: profilFehler } = await admin
      .from('profiles')
      .delete()
      .eq('id', uid)
    if (profilFehler) {
      console.warn(`profiles: ${profilFehler.message}`)
      fehler.push('profiles')
    } else {
      geloescht.push('profiles')
    }

    // ─── 4. Auth-Nutzer loeschen ─────────────────
    // Zuletzt, damit die Daten nicht verwaisen, falls hier etwas schiefgeht.
    const { error: authFehler } = await admin.auth.admin.deleteUser(uid)
    if (authFehler) {
      console.error(`auth.deleteUser: ${authFehler.message}`)
      return json(
        {
          error: 'Konto konnte nicht vollstaendig geloescht werden',
          code: 'AUTH_DELETE_FAILED',
          details: authFehler.message,
          geloescht,
        },
        500,
      )
    }

    console.log(`Konto ${uid} geloescht. Tabellen: ${geloescht.join(', ')}`)
    if (fehler.length > 0) {
      console.warn(`Mit Fehlern in: ${fehler.join(', ')}`)
    }

    return json({ ok: true, geloescht, fehler })
  } catch (e: any) {
    console.error('Unhandled error:', e)
    return json({ error: 'Internal server error' }, 500)
  }
})

function json(data: unknown, status = 200): Response {
  return new Response(JSON.stringify(data), {
    status,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
  })
}
