// supabase/functions/verify-purchase/index.ts
//
// Serverseitige Belegprüfung für Google-Play-Käufe.
// Die App schickt nach einem Kauf den purchaseToken hierher.
// Diese Function fragt DIREKT bei Google nach, ob der Kauf echt und
// aktiv ist, und schaltet erst dann Premium frei. Damit kann niemand
// mehr Premium ohne echten Kauf freischalten.
//
// Request  (POST, mit User-JWT im Authorization-Header):
//   { "purchaseToken": "..." }
// Response:
//   { ok: true, tier: "yearly", premiumUntil: "2027-08-02T..." }
//   oder { ok: false, error: "..." }
//
// Benötigte Secrets (Supabase → Edge Functions → Secrets):
//   GOOGLE_PLAY_SERVICE_ACCOUNT  – kompletter JSON-Inhalt des Dienstkontos
//   (SUPABASE_URL / SUPABASE_SERVICE_ROLE_KEY sind automatisch gesetzt)

// deno-lint-ignore-file no-explicit-any
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const PACKAGE_NAME = 'app.lernarena'
const SUBSCRIPTION_ID = 'lernarena_premium'

const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!
const SUPABASE_ANON_KEY = Deno.env.get('SUPABASE_ANON_KEY')!
const SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
const SERVICE_ACCOUNT_JSON = Deno.env.get('GOOGLE_PLAY_SERVICE_ACCOUNT')

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
}

// ─── Base Plan → Tier-Zuordnung ─────────────────────────────
// Muss zu den Base Plans in der Play Console passen.
const PLAN_MAP: Record<string, { tier: string }> = {
  'monthly': { tier: 'monthly' },
  'half-year': { tier: 'half-year' },
  'annual': { tier: 'yearly' },
  // alter (deaktivierter) Base Plan, nur zur Sicherheit:
  'yearly': { tier: 'yearly' },
}

function b64url(input: string | Uint8Array): string {
  const str =
    typeof input === 'string'
      ? btoa(input)
      : btoa(String.fromCharCode(...input))
  return str.replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '')
}

// ─── Google-Zugriffstoken über das Dienstkonto holen ────────
async function getGoogleAccessToken(sa: {
  client_email: string
  private_key: string
}): Promise<string> {
  const now = Math.floor(Date.now() / 1000)
  const header = b64url(JSON.stringify({ alg: 'RS256', typ: 'JWT' }))
  const claims = b64url(
    JSON.stringify({
      iss: sa.client_email,
      scope: 'https://www.googleapis.com/auth/androidpublisher',
      aud: 'https://oauth2.googleapis.com/token',
      iat: now,
      exp: now + 3600,
    }),
  )
  const unsigned = `${header}.${claims}`

  // PEM → CryptoKey
  const pem = sa.private_key
    .replace('-----BEGIN PRIVATE KEY-----', '')
    .replace('-----END PRIVATE KEY-----', '')
    .replace(/\s/g, '')
  const keyBytes = Uint8Array.from(atob(pem), (c) => c.charCodeAt(0))
  const key = await crypto.subtle.importKey(
    'pkcs8',
    keyBytes,
    { name: 'RSASSA-PKCS1-v1_5', hash: 'SHA-256' },
    false,
    ['sign'],
  )
  const sig = new Uint8Array(
    await crypto.subtle.sign(
      'RSASSA-PKCS1-v1_5',
      key,
      new TextEncoder().encode(unsigned),
    ),
  )
  const jwt = `${unsigned}.${b64url(sig)}`

  const res = await fetch('https://oauth2.googleapis.com/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
      assertion: jwt,
    }),
  })
  if (!res.ok) {
    throw new Error(`Google OAuth Fehler ${res.status}: ${await res.text()}`)
  }
  const data = await res.json()
  return data.access_token
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
    if (!SERVICE_ACCOUNT_JSON) {
      return json({ ok: false, error: 'Service-Account nicht konfiguriert' }, 500)
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

    // ─── 2. purchaseToken entgegennehmen ────────────────────
    const { purchaseToken } = await req.json()
    if (!purchaseToken || typeof purchaseToken !== 'string') {
      return json({ ok: false, error: 'purchaseToken fehlt' }, 400)
    }

    // ─── 3. Kauf bei Google verifizieren ────────────────────
    const sa = JSON.parse(SERVICE_ACCOUNT_JSON)
    const accessToken = await getGoogleAccessToken(sa)

    const url =
      `https://androidpublisher.googleapis.com/androidpublisher/v3/applications/` +
      `${PACKAGE_NAME}/purchases/subscriptionsv2/tokens/${encodeURIComponent(purchaseToken)}`
    const gRes = await fetch(url, {
      headers: { Authorization: `Bearer ${accessToken}` },
    })
    if (!gRes.ok) {
      console.warn(`Google-Verifikation fehlgeschlagen: ${gRes.status}`)
      return json(
        { ok: false, error: 'Kauf konnte nicht verifiziert werden' },
        402,
      )
    }
    const purchase = await gRes.json()

    // ─── 4. Kauf validieren ─────────────────────────────────
    const lineItem = purchase.lineItems?.[0]
    if (!lineItem) {
      return json({ ok: false, error: 'Kein Abo-Posten im Kauf' }, 402)
    }

    // Produkt muss unser Abo sein
    if (lineItem.productId && lineItem.productId !== SUBSCRIPTION_ID) {
      return json({ ok: false, error: 'Unbekanntes Produkt' }, 402)
    }

    // Ablaufdatum muss in der Zukunft liegen (deckt aktiv, Grace,
    // gekündigt-aber-noch-laufend ab; abgelaufene Käufe fallen durch)
    const expiry = lineItem.expiryTime ? new Date(lineItem.expiryTime) : null
    if (!expiry || expiry.getTime() <= Date.now()) {
      return json({ ok: false, error: 'Abo ist abgelaufen' }, 402)
    }

    // Base Plan → Tier
    const basePlanId: string = lineItem.offerDetails?.basePlanId ?? ''
    const plan = PLAN_MAP[basePlanId]
    if (!plan) {
      return json({ ok: false, error: `Unbekannter Plan: ${basePlanId}` }, 402)
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

    return json({
      ok: true,
      tier: plan.tier,
      premiumUntil: expiry.toISOString(),
    })
  } catch (err) {
    console.error('verify-purchase Fehler:', err)
    return json({ ok: false, error: 'Interner Fehler' }, 500)
  }
})
