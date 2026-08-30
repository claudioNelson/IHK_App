// supabase/functions/ai-tutor/index.ts
//
// AI-Tutor Edge Function mit Failover (Claude → Groq)
// + server-seitiger Usage-Tracking für Free-User
//
// Request:  { messages: [{role, content}], max_tokens?, temperature? }
// Response: { content: string, provider: 'claude'|'groq', remaining: number }
//
// GEMINI WURDE AM 30.08.2026 ENTFERNT — nicht versehentlich, bitte nicht
// zurückholen. In der kostenlosen Stufe der Gemini-API verwendet Google
// Prompts und Antworten zur Verbesserung der eigenen Produkte, inklusive
// menschlicher Sichtung. Für eine App mit deutschen Nutzern und einer
// Datenschutzerklärung, die Zweckbindung zusagt, ist das nicht tragbar.
// Erst wenn ein KOSTENPFLICHTIGER Gemini-Zugang existiert (dort ist die
// Trainingsnutzung ausgeschlossen), darf der Zweig zurück — und dann muss
// Google gleichzeitig in Abschnitt 6 der Datenschutzerklärung stehen.

// deno-lint-ignore-file no-explicit-any
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const ANTHROPIC_API_KEY = Deno.env.get('ANTHROPIC_API_KEY')
const GROQ_API_KEY = Deno.env.get('GROQ_API_KEY')

const CLAUDE_MODEL = 'claude-haiku-4-5'
const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!

const FREE_LIMIT = 5

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
}

interface ChatMessage {
  role: 'system' | 'user' | 'assistant'
  content: string
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // ─── 1. Auth-Check ────────────────────────────
    const authHeader = req.headers.get('Authorization')
    if (!authHeader) {
      return jsonResponse({ error: 'Missing authorization header' }, 401)
    }

    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, {
      global: { headers: { Authorization: authHeader } },
    })

    const {
      data: { user },
      error: userError,
    } = await supabase.auth.getUser()

    if (userError || !user) {
      return jsonResponse({ error: 'Unauthorized' }, 401)
    }

    // ─── 2. Premium-Check ────────────────────────
    const { data: profile } = await supabase
      .from('profiles')
      .select('is_premium, premium_until')
      .eq('id', user.id)
      .single()

    const isPremium =
      profile?.is_premium === true &&
      (!profile.premium_until ||
        new Date(profile.premium_until) > new Date())

    // ─── 3. Limit-Check für Free-User ────────────
    let used = 0
    if (!isPremium) {
      const today = new Date().toISOString().substring(0, 10)
      const { data: usage } = await supabase
        .from('usage_tracking')
        .select('id, count')
        .eq('user_id', user.id)
        .eq('feature', 'ai_tutor')
        .eq('date', today)
        .is('context', null)
        .maybeSingle()

      used = usage?.count ?? 0

      if (used >= FREE_LIMIT) {
        return jsonResponse(
          {
            error: 'Daily limit reached',
            code: 'LIMIT_REACHED',
            limit: FREE_LIMIT,
            used,
          },
          429,
        )
      }
    }

    // ─── 4. Request-Body lesen ───────────────────
    const body = await req.json()
    const messages: ChatMessage[] = body.messages
    const maxTokens: number = body.max_tokens ?? 1000
    const temperature: number = body.temperature ?? 0.7

    if (!Array.isArray(messages) || messages.length === 0) {
      return jsonResponse({ error: 'Missing messages array' }, 400)
    }

    // Längen-Limit für Sicherheit
    const totalChars = messages.reduce((sum, m) => sum + (m.content?.length ?? 0), 0)
    if (totalChars > 20000) {
      return jsonResponse({ error: 'Conversation too long (max 20k chars)' }, 400)
    }

    // ─── 5. Failover: Claude → Groq ──────────────
    let content: string | null = null
    let provider: 'claude' | 'groq' | null = null

    if (ANTHROPIC_API_KEY) {
      try {
        content = await callClaude(messages, maxTokens, temperature)
        provider = 'claude'
      } catch (err: any) {
        console.warn('Claude failed:', err.message)
      }
    }

    if (!content && GROQ_API_KEY) {
      try {
        content = await callGroq(messages, maxTokens, temperature)
        provider = 'groq'
      } catch (err: any) {
        console.warn('Groq failed:', err.message)
      }
    }

    if (!content || !provider) {
      return jsonResponse(
        { error: 'All AI providers unavailable', code: 'PROVIDERS_DOWN' },
        503,
      )
    }

    // ─── 6. Counter inkrementieren (nur Free) ────
    // ─── 6. Counter inkrementieren (nur Free) ────
    if (!isPremium) {
      const today = new Date().toISOString().substring(0, 10)

      // Existierenden Eintrag suchen
      const { data: existing } = await supabase
        .from('usage_tracking')
        .select('id, count')
        .eq('user_id', user.id)
        .eq('feature', 'ai_tutor')
        .eq('date', today)
        .is('context', null)
        .maybeSingle()

      if (existing) {
        // Update
        await supabase
          .from('usage_tracking')
          .update({
            count: (existing.count as number) + 1,
            updated_at: new Date().toISOString(),
          })
          .eq('id', existing.id)
      } else {
        // Insert
        await supabase.from('usage_tracking').insert({
          user_id: user.id,
          feature: 'ai_tutor',
          date: today,
          count: 1,
          context: null,
        })
      }
    }

    // ─── 7. Antwort ──────────────────────────────
    return jsonResponse({
      content,
      provider,
      remaining: isPremium ? -1 : Math.max(0, FREE_LIMIT - used - 1),
    })
  } catch (e: any) {
    console.error('Unhandled error:', e)
    return jsonResponse({ error: 'Internal server error' }, 500)
  }
})

// ─── Provider: Claude (Anthropic) ───────────────
async function callClaude(
  messages: ChatMessage[],
  maxTokens: number,
  temperature: number,
): Promise<string> {
  // Anthropic erwartet system-Prompts als eigenes Top-Level-Feld,
  // die Konversation nur mit user/assistant-Rollen.
  const systemPrompt = messages
    .filter((m) => m.role === 'system')
    .map((m) => m.content)
    .join('\n\n')

  const conversation = messages
    .filter((m) => m.role !== 'system')
    .map((m) => ({ role: m.role, content: m.content }))

  const body: any = {
    model: CLAUDE_MODEL,
    max_tokens: maxTokens,
    temperature,
    messages: conversation,
  }
  if (systemPrompt) {
    body.system = systemPrompt
  }

  const res = await fetch('https://api.anthropic.com/v1/messages', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'x-api-key': ANTHROPIC_API_KEY!,
      'anthropic-version': '2023-06-01',
    },
    body: JSON.stringify(body),
  })

  if (!res.ok) {
    throw new Error(`Claude HTTP ${res.status}: ${await res.text()}`)
  }
  const data = await res.json()
  return data.content?.[0]?.text ?? ''
}

// ─── Provider: Groq ─────────────────────────────
async function callGroq(
  messages: ChatMessage[],
  maxTokens: number,
  temperature: number,
): Promise<string> {
  const res = await fetch('https://api.groq.com/openai/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${GROQ_API_KEY}`,
    },
    body: JSON.stringify({
      model: 'llama-3.3-70b-versatile',
      messages,
      max_tokens: maxTokens,
      temperature,
    }),
  })

  if (!res.ok) {
    throw new Error(`Groq HTTP ${res.status}: ${await res.text()}`)
  }
  const data = await res.json()
  return data.choices?.[0]?.message?.content ?? ''
}

// ─── Helper ────────────────────────────────────
function jsonResponse(data: unknown, status = 200): Response {
  return new Response(JSON.stringify(data), {
    status,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
  })
}