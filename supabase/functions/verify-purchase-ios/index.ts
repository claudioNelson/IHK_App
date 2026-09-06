// supabase/functions/verify-purchase-ios/index.ts
//
// Serverseitige Belegprüfung für App-Store-Käufe (StoreKit 2).
// Gegenstück zu `verify-purchase` (Google Play).
//
// Die App schickt nach einem Kauf die signierte StoreKit-2-Transaktion
// (JWS aus `PurchaseDetails.verificationData.serverVerificationData`).
// Diese Function
//   1. liest transactionId + Umgebung (Sandbox/Production) aus dem JWS,
//   2. fragt DIREKT bei Apple über die App Store Server API nach dieser
//      Transaktion (damit zählt nur, was Apple bestätigt — nicht, was die
//      App behauptet),
//   3. prüft Bundle-ID, Produkt, Ablaufdatum,
//   4. schaltet Premium über `grant_premium_from_server` frei.
//
// Request  (POST, mit User-JWT im Authorization-Header):
//   { "transactionJws": "<JWS>", "productId": "lernarena_premium_annual" }
// Response:
//   { ok: true, tier: "yearly", premiumUntil: "2027-09-05T..." }
//   oder { ok: false, error: "..." }
//
// Benötigte Secrets (Supabase → Edge Functions → Secrets):
//   APPLE_IAP_ISSUER_ID    – Issuer ID (App Store Connect → Integrationen → In-App-Kauf)
//   APPLE_IAP_KEY_ID       – Schlüssel-ID des In-App-Kauf-Schlüssels
//   APPLE_IAP_PRIVATE_KEY  – Inhalt der .p8-Datei (inkl. BEGIN/END-Zeilen)
//   (SUPABASE_URL / SUPABASE_SERVICE_ROLE_KEY sind automatisch gesetzt)
//
// Deploy: supabase functions deploy verify-purchase-ios

// deno-lint-ignore-file no-explicit-any
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const BUNDLE_ID = 'app.lernarena'

const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!
const SUPABASE_ANON_KEY = Deno.env.get('SUPABASE_ANON_KEY')!
const SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
const APPLE_ISSUER_ID = Deno.env.get('APPLE_IAP_ISSUER_ID')
const APPLE_KEY_ID = Deno.env.get('APPLE_IAP_KEY_ID')
const APPLE_PRIVATE_KEY = Deno.env.get('APPLE_IAP_PRIVATE_KEY')

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
}

// ─── Produkt-ID → Tier ──────────────────────────────────────
// Muss zu den Abos in App Store Connect (Gruppe "Lernarena Premium")
// und zu den Tier-Namen passen, die grant_premium_from_server kennt.
const PRODUCT_MAP: Record<string, { tier: string }> = {
  lernarena_premium_monthly: { tier: 'monthly' },
  lernarena_premium_halfyear: { tier: 'half-year' },
  lernarena_premium_annual: { tier: 'yearly' },
}

const HOST_PRODUCTION = 'https://api.storekit.itunes.apple.com'
const HOST_SANDBOX = 'https://api.storekit-sandbox.itunes.apple.com'

// ─── Helfer ─────────────────────────────────────────────────
function b64url(input: string | Uint8Array): string {
  const str =
    typeof input === 'string'
      ? btoa(input)
      : btoa(String.fromCharCode(...input))
  return str.replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '')
}

function b64urlDecode(s: string): string {
  const pad = s.length % 4 === 0 ? '' : '='.repeat(4 - (s.length % 4))
  const b64 = s.replace(/-/g, '+').replace(/_/g, '/') + pad
  return new TextDecoder().decode(
    Uint8Array.from(atob(b64), (c) => c.charCodeAt(0)),
  )
}

/// Payload eines JWS (header.payload.signature) als Objekt.
/// Die Signatur wird hier NICHT geprüft — die Wahrheit holen wir uns
/// direkt bei Apple (Schritt 3). Der Payload dient nur, um transactionId
/// und Umgebung zu kennen.
function decodeJwsPayload(jws: string): any {
  const parts = jws.split('.')
  if (parts.length !== 3) throw new Error('Kein gültiges JWS')
  return JSON.parse(b64urlDecode(parts[1]))
}

// ─── JWT für die App Store Server API (ES256) ───────────────
async function appleApiToken(): Promise<string> {
  const now = Math.floor(Date.now() / 1000)
  const header = b64url(
    JSON.stringify({ alg: 'ES256', kid: APPLE_KEY_ID, typ: 'JWT' }),
  )
  const claims = b64url(
    JSON.stringify({
      iss: APPLE_ISSUER_ID,
      iat: now,
      exp: now + 600, // Apple erlaubt max. 60 min
      aud: 'appstoreconnect-v1',
      bid: BUNDLE_ID,
    }),
  )
  const unsigned = `${header}.${claims}`

  const pem = APPLE_PRIVATE_KEY!
    .replace('-----BEGIN PRIVATE KEY-----', '')
    .replace('-----END PRIVATE KEY-----', '')
    .replace(/\s/g, '')
  const keyBytes = Uint8Array.from(atob(pem), (c) => c.charCodeAt(0))
  const key = await crypto.subtle.importKey(
    'pkcs8',
    keyBytes,
    { name: 'ECDSA', namedCurve: 'P-256' },
    false,
    ['sign'],
  )
  // WebCrypto liefert die ECDSA-Signatur bereits als r||s (64 Byte) —
  // genau das Format, das JWS für ES256 erwartet.
  const sig = new Uint8Array(
    await crypto.subtle.sign(
      { name: 'ECDSA', hash: 'SHA-256' },
      key,
      new TextEncoder().encode(unsigned),
    ),
  )
  return `${unsigned}.${b64url(sig)}`
}

/// Transaktion bei Apple nachschlagen. Liefert den Payload der von Apple
/// signierten Transaktion oder null, wenn Apple sie nicht kennt.
async function fetchTransaction(
  host: string,
  transactionId: string,
  token: string,
): Promise<any | null> {
  const res = await fetch(
    `${host}/inApps/v1/transactions/${encodeURIComponent(transactionId)}`,
    { headers: { Authorization: `Bearer ${token}` } },
  )
  if (res.status === 404) return null
  if (!res.ok) {
    throw new Error(`Apple API ${res.status}: ${await res.text()}`)
  }
  const data = await res.json()
  if (!data.signedTransactionInfo) return null
  return decodeJwsPayload(data.signedTransactionInfo)
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  const json = (body: unknown, status = 200) =>
    new Response(JSON.stringify(body), {
      status,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })

  try {
    if (!APPLE_ISSUER_ID || !APPLE_KEY_ID || !APPLE_PRIVATE_KEY) {
      return json({ ok: false, error: 'Apple-Schlüssel nicht konfiguriert' }, 500)
    }

    // ─── 1. Eingeloggten User ermitteln ─────────────────────
    const authHeader = req.headers.get('Authorization') ?? ''
    const userClient = createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {
      global: { headers: { Authorization: authHeader } },
    })
    const {
      data: { user },
    } = await userClient.auth.getUser()
    if (!user) {
      return json({ ok: false, error: 'Nicht eingeloggt' }, 401)
    }

    // ─── 2. Transaktion entgegennehmen ──────────────────────
    const { transactionJws } = await req.json()
    if (!transactionJws || typeof transactionJws !== 'string') {
      return json({ ok: false, error: 'transactionJws fehlt' }, 400)
    }

    let claimed: any
    try {
      claimed = decodeJwsPayload(transactionJws)
    } catch {
      return json({ ok: false, error: 'Kaufnachweis unlesbar' }, 400)
    }
    const transactionId: string | undefined =
      claimed.transactionId ?? claimed.originalTransactionId
    if (!transactionId) {
      return json({ ok: false, error: 'Keine Transaktions-ID' }, 400)
    }

    // ─── 3. Bei Apple nachfragen ────────────────────────────
    // Umgebung aus dem Nachweis; bei Production zusätzlich Sandbox
    // probieren (Apples Empfehlung: Prüfer-Käufe laufen in der Sandbox,
    // auch wenn die App aus dem Store kommt).
    const token = await appleApiToken()
    const sandboxFirst = claimed.environment === 'Sandbox'
    let tx = await fetchTransaction(
      sandboxFirst ? HOST_SANDBOX : HOST_PRODUCTION,
      transactionId,
      token,
    )
    if (!tx && !sandboxFirst) {
      tx = await fetchTransaction(HOST_SANDBOX, transactionId, token)
    }
    if (!tx) {
      console.warn(`Apple kennt Transaktion nicht: ${transactionId}`)
      return json(
        { ok: false, error: 'Kauf konnte nicht verifiziert werden' },
        402,
      )
    }

    // ─── 4. Kauf validieren (nur mit Apples Daten) ──────────
    if (tx.bundleId !== BUNDLE_ID) {
      return json({ ok: false, error: 'Falsche App' }, 402)
    }
    const plan = PRODUCT_MAP[tx.productId]
    if (!plan) {
      return json({ ok: false, error: `Unbekanntes Produkt: ${tx.productId}` }, 402)
    }
    if (tx.revocationDate) {
      return json({ ok: false, error: 'Kauf wurde widerrufen' }, 402)
    }
    // expiresDate: Millisekunden seit Epoch. Deckt aktiv, Grace Period und
    // gekündigt-aber-noch-laufend ab; abgelaufene Abos fallen durch.
    const expiry = tx.expiresDate ? new Date(Number(tx.expiresDate)) : null
    if (!expiry || Number.isNaN(expiry.getTime()) || expiry.getTime() <= Date.now()) {
      return json({ ok: false, error: 'Abo ist abgelaufen' }, 402)
    }

    // ─── 5. Premium serverseitig freischalten ───────────────
    const admin = createClient(SUPABASE_URL, SERVICE_ROLE_KEY)
    const { error: rpcError } = await admin.rpc('grant_premium_from_server', {
      p_user_id: user.id,
      p_tier: plan.tier,
      p_until: expiry.toISOString(),
    })
    if (rpcError) {
      console.error('Grant fehlgeschlagen:', rpcError)
      return json({ ok: false, error: 'Freischaltung fehlgeschlagen' }, 500)
    }

    console.log(
      `Premium (${tx.environment}) für ${user.id}: ${tx.productId} bis ${expiry.toISOString()}`,
    )
    return json({
      ok: true,
      tier: plan.tier,
      premiumUntil: expiry.toISOString(),
      environment: tx.environment,
    })
  } catch (err) {
    console.error('verify-purchase-ios Fehler:', err)
    return json({ ok: false, error: 'Interner Fehler' }, 500)
  }
})
