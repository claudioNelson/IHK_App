import { NextRequest, NextResponse } from "next/server";
import { exams } from "@/data/exams";
import { createClient } from "@/lib/supabase/server";

// KI-Prüfungskorrektur: Claude Haiku (primär) mit Groq-Fallback.
//
// Zugriff: nur eingeloggte Premium-Nutzer. Die Prüfung wird über ihre ID
// serverseitig geladen, der Client schickt nur { examId, answers }. Damit
// kann niemand mit beliebigem Inhalt die KI auf unsere Kosten aufrufen.
// Keys kommen aus den Vercel-Umgebungsvariablen:
//   ANTHROPIC_API_KEY  (primär)
//   GROQ_API_KEY       (Fallback)
const ANTHROPIC_API_KEY = process.env.ANTHROPIC_API_KEY;
const GROQ_API_KEY = process.env.GROQ_API_KEY;

const CLAUDE_MODEL = "claude-haiku-4-5";
// llama-3.3-70b-versatile wurde von Groq am 16.08.2026 abgeschaltet.
// Empfohlener Ersatz laut Groq-Deprecation-Seite: openai/gpt-oss-120b.
const GROQ_MODEL = "openai/gpt-oss-120b";

// Versucht, die KI-Antwort als strukturiertes Ergebnis zu parsen.
// Liefert null, wenn kein gültiges JSON erkannt wird (dann zeigt das
// Frontend den Text als Fallback an).
function tryParseResult(text: string): unknown | null {
  try {
    const first = text.indexOf("{");
    const last = text.lastIndexOf("}");
    if (first === -1 || last === -1 || last <= first) return null;
    const parsed = JSON.parse(text.slice(first, last + 1));
    if (
      parsed &&
      typeof parsed === "object" &&
      "gesamt" in parsed &&
      Array.isArray((parsed as { aufgaben?: unknown }).aufgaben)
    ) {
      return parsed;
    }
    return null;
  } catch {
    return null;
  }
}

// Erzwingt konsistente Zahlen, egal was die KI liefert:
// - Teilaufgaben-Punkte werden auf [0, maxPunkte] begrenzt
// - Aufgaben- und Gesamtpunkte werden aus den Teilaufgaben neu summiert
// - Prozent, Note und Bestanden werden serverseitig neu berechnet
type TeilaufgabeResult = { punkte?: number; maxPunkte?: number; [k: string]: unknown };
type AufgabeResult = { punkte?: number; maxPunkte?: number; teilaufgaben?: TeilaufgabeResult[]; [k: string]: unknown };
type KorrekturResult = {
  gesamt?: { punkte?: number; maxPunkte?: number; prozent?: number; note?: number; noteText?: string; bestanden?: boolean; [k: string]: unknown };
  aufgaben?: AufgabeResult[];
  [k: string]: unknown;
};

function normalizeResult(raw: unknown, examTotalPoints: number): unknown {
  const result = raw as KorrekturResult;
  if (!result || !Array.isArray(result.aufgaben)) return raw;

  let gesamtPunkte = 0;
  let gesamtMax = 0;

  for (const aufgabe of result.aufgaben) {
    let aufgabePunkte = 0;
    let aufgabeMax = 0;
    if (Array.isArray(aufgabe.teilaufgaben)) {
      for (const teil of aufgabe.teilaufgaben) {
        const max = Math.max(0, Number(teil.maxPunkte) || 0);
        const punkte = Math.min(max, Math.max(0, Number(teil.punkte) || 0));
        teil.maxPunkte = max;
        teil.punkte = punkte;
        aufgabePunkte += punkte;
        aufgabeMax += max;
      }
      aufgabe.punkte = aufgabePunkte;
      aufgabe.maxPunkte = aufgabeMax;
    } else {
      aufgabeMax = Math.max(0, Number(aufgabe.maxPunkte) || 0);
      aufgabePunkte = Math.min(aufgabeMax, Math.max(0, Number(aufgabe.punkte) || 0));
      aufgabe.punkte = aufgabePunkte;
      aufgabe.maxPunkte = aufgabeMax;
    }
    gesamtPunkte += aufgabePunkte;
    gesamtMax += aufgabeMax;
  }

  const maxPunkte = examTotalPoints > 0 ? examTotalPoints : gesamtMax;
  gesamtPunkte = Math.min(gesamtPunkte, maxPunkte);
  const prozent = maxPunkte > 0 ? Math.round((gesamtPunkte / maxPunkte) * 100) : 0;

  let note = 6;
  let noteText = "ungenügend";
  if (prozent >= 92) { note = 1; noteText = "sehr gut"; }
  else if (prozent >= 81) { note = 2; noteText = "gut"; }
  else if (prozent >= 67) { note = 3; noteText = "befriedigend"; }
  else if (prozent >= 50) { note = 4; noteText = "ausreichend"; }
  else if (prozent >= 30) { note = 5; noteText = "mangelhaft"; }

  result.gesamt = {
    ...(result.gesamt ?? {}),
    punkte: gesamtPunkte,
    maxPunkte,
    prozent,
    note,
    noteText,
    bestanden: prozent >= 50,
  };

  return result;
}

// Einfaches Rate-Limit pro Nutzer. Lebt nur im Speicher der jeweiligen
// Serverless-Instanz, ist also keine harte Grenze, faengt aber Doppelklicks
// und Skripte ab. Eine Korrektur kostet uns Geld, mehr als ein paar pro
// Stunde braucht niemand.
const LIMIT_ANFRAGEN = 6;
const LIMIT_FENSTER_MS = 60 * 60 * 1000;
const anfragen = new Map<string, number[]>();

function rateLimitErreicht(userId: string): boolean {
  const jetzt = Date.now();
  const liste = (anfragen.get(userId) ?? []).filter((t) => jetzt - t < LIMIT_FENSTER_MS);
  if (liste.length >= LIMIT_ANFRAGEN) {
    anfragen.set(userId, liste);
    return true;
  }
  liste.push(jetzt);
  anfragen.set(userId, liste);
  return false;
}

// Antworten auf ein Objekt aus Strings reduzieren und pro Antwort begrenzen,
// damit der Prompt nicht beliebig gross wird.
const MAX_ANTWORT_ZEICHEN = 8000;

function antwortenBereinigen(raw: unknown): Record<string, string> {
  const out: Record<string, string> = {};
  if (!raw || typeof raw !== "object") return out;
  for (const [key, value] of Object.entries(raw as Record<string, unknown>)) {
    if (typeof value !== "string") continue;
    out[key] = value.slice(0, MAX_ANTWORT_ZEICHEN);
  }
  return out;
}

export async function POST(request: NextRequest) {
  if (!ANTHROPIC_API_KEY && !GROQ_API_KEY) {
    return NextResponse.json({ error: "API Key nicht konfiguriert" }, { status: 500 });
  }

  try {
    // ─── Zugriff: eingeloggt und Premium ─────────────────────
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) {
      return NextResponse.json({ error: "Bitte melde dich an." }, { status: 401 });
    }

    const { data: profile } = await supabase
      .from("profiles")
      .select("is_premium, premium_tier, premium_until")
      .eq("id", user.id)
      .maybeSingle();

    let isPremium = profile?.is_premium === true;
    if (isPremium && profile?.premium_tier !== "lifetime" && profile?.premium_until) {
      const until = new Date(profile.premium_until);
      if (!isNaN(until.getTime()) && until < new Date()) isPremium = false;
    }
    if (!isPremium) {
      return NextResponse.json({ error: "Die KI-Korrektur ist Teil von Premium." }, { status: 403 });
    }

    if (rateLimitErreicht(user.id)) {
      return NextResponse.json(
        { error: "Zu viele Korrekturen in kurzer Zeit. Bitte versuche es später noch einmal." },
        { status: 429 },
      );
    }

    // ─── Eingabe: nur ID und Antworten ───────────────────────
    const body = await request.json();
    const examId = typeof body?.examId === "string" ? body.examId : "";
    const exam = exams[examId];
    if (!exam) {
      return NextResponse.json({ error: "Prüfung nicht gefunden." }, { status: 404 });
    }
    const answers = antwortenBereinigen(body?.answers);

    // Prompt bauen
    let prompt = `Du bist ein strenger aber fairer IHK-Prüfer für Fachinformatiker.
Bewerte diese Prüfung und vergib Punkte für jede Antwort.

=== PRÜFUNGSDATEN ===
Prüfung: ${exam.title}
Unternehmen: ${exam.company}
Gesamtpunkte: ${exam.totalPoints}

`;

    if (exam.scenario) {
      prompt += `Szenario: ${exam.scenario}\n\n`;
    }

    prompt += `=== ANTWORTEN DES PRÜFLINGS ===\n`;

    for (const section of exam.sections) {
      prompt += `\n--- ${section.title} ---\n`;
      for (const question of section.questions) {
        if (question.type === "info") continue;
        prompt += `\nAufgabe (${question.points} Punkte): ${question.title}\n`;
        prompt += `Aufgabenstellung: ${question.description}\n`;
        prompt += `Antwort des Prüflings: ${answers[question.id] || "NICHT BEANTWORTET"}\n`;
      }
    }

    prompt += `
=== DEINE AUFGABE ===
Bewerte die Prüfung streng aber fair. Nicht beantwortete Aufgaben = 0 Punkte.
Notenschlüssel: 100-92% = 1 (sehr gut), 91-81% = 2 (gut), 80-67% = 3 (befriedigend),
66-50% = 4 (ausreichend), 49-30% = 5 (mangelhaft), 29-0% = 6 (ungenügend).
Bestanden ab 50%.

Antworte AUSSCHLIESSLICH mit gültigem JSON in exakt dieser Struktur —
kein Markdown, keine Code-Fences, kein Text davor oder danach:

{
  "gesamt": {
    "punkte": 0,
    "maxPunkte": ${exam.totalPoints},
    "prozent": 0,
    "note": 6,
    "noteText": "ungenügend",
    "bestanden": false,
    "kommentar": "1-2 Sätze Gesamteindruck, motivierend formuliert"
  },
  "aufgaben": [
    {
      "titel": "Titel der Aufgabe",
      "punkte": 0,
      "maxPunkte": 0,
      "teilaufgaben": [
        {
          "titel": "Kurztitel der Teilaufgabe",
          "punkte": 0,
          "maxPunkte": 0,
          "beantwortet": true,
          "kommentar": "kurze Begründung, max. 15 Wörter"
        }
      ]
    }
  ],
  "staerken": ["Was war gut (nur wenn wirklich etwas gut war)"],
  "verbesserungen": ["Was muss besser werden"],
  "lernempfehlungen": ["Konkrete Lernempfehlung mit Thema"]
}

Alle Texte auf Deutsch.

WICHTIGE KONSISTENZ-REGELN:
- "gesamt.punkte" MUSS exakt die Summe aller "aufgaben[].punkte" sein.
- Eine Aufgabe mit Antworttext gilt als beantwortet und wird inhaltlich
  bewertet, auch wenn andere Aufgaben unbeantwortet sind.
- Der Gesamtkommentar darf den Einzelbewertungen nicht widersprechen
  (also NICHT "keine Aufgaben beantwortet" schreiben, wenn Teilaufgaben
  Punkte bekommen haben).`;

    // Warum Claude nicht geantwortet hat, landet im Fehlertext des
    // Fallbacks, damit man es im Browser sieht und nicht nur im Vercel-Log.
    let claudeFehler = "";

    // ─── 1) Primär: Claude Haiku ─────────────────────────────
    if (ANTHROPIC_API_KEY) {
      try {
        const res = await fetch("https://api.anthropic.com/v1/messages", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "x-api-key": ANTHROPIC_API_KEY,
            "anthropic-version": "2023-06-01",
          },
          body: JSON.stringify({
            model: CLAUDE_MODEL,
            max_tokens: 4000,
            messages: [{ role: "user", content: prompt }],
          }),
        });

        if (res.ok) {
          const data = await res.json();
          const feedback = data.content?.[0]?.text;
          if (feedback) {
            const result = tryParseResult(feedback);
            return NextResponse.json(
              result
                ? { result: normalizeResult(result, exam.totalPoints), provider: "claude" }
                : { feedback, provider: "claude" }
            );
          }
        } else {
          claudeFehler = `Claude HTTP ${res.status}: ${(await res.text()).slice(0, 300)}`;
          console.warn(claudeFehler);
        }
      } catch (err) {
        claudeFehler = `Claude nicht erreichbar: ${err instanceof Error ? err.message : String(err)}`;
        console.warn(claudeFehler);
      }
    } else {
      claudeFehler = "ANTHROPIC_API_KEY nicht gesetzt";
    }

    // ─── 2) Fallback: Groq ───────────────────────────────────
    if (GROQ_API_KEY) {
      const response = await fetch("https://api.groq.com/openai/v1/chat/completions", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${GROQ_API_KEY}`,
        },
        body: JSON.stringify({
          model: GROQ_MODEL,
          messages: [{ role: "user", content: prompt }],
          max_tokens: 4000,
          temperature: 0.7,
        }),
      });

      if (!response.ok) {
        const error = await response.text();
        return NextResponse.json(
          { error: `Groq API Fehler: ${error}${claudeFehler ? ` | Zuvor ${claudeFehler}` : ""}` },
          { status: 500 },
        );
      }

      const data = await response.json();
      const feedback = data.choices[0]?.message?.content || "Keine Antwort erhalten";
      const result = tryParseResult(feedback);

      return NextResponse.json(
        result
          ? { result: normalizeResult(result, exam.totalPoints), provider: "groq" }
          : { feedback, provider: "groq" }
      );
    }

    return NextResponse.json(
      { error: `Kein KI-Anbieter erreichbar${claudeFehler ? ` (${claudeFehler})` : ""}` },
      { status: 503 }
    );
  } catch (error) {
    console.error("KI-Korrektur Fehler:", error);
    return NextResponse.json({ error: "Interner Serverfehler" }, { status: 500 });
  }
}
