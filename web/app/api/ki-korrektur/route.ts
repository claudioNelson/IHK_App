import { NextRequest, NextResponse } from "next/server";

const GROQ_API_KEY = process.env.GROQ_API_KEY;

export async function POST(request: NextRequest) {
  if (!GROQ_API_KEY) {
    return NextResponse.json({ error: "API Key nicht konfiguriert" }, { status: 500 });
  }

  try {
    const { exam, answers, completed } = await request.json();

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

1. 📝 EINZELBEWERTUNG
   Bewerte JEDE Aufgabe einzeln:
   - Erreichte Punkte / Mögliche Punkte
   - Kurze Begründung

2. 📊 GESAMTERGEBNIS
   - Erreichte Gesamtpunkte: X / ${exam.totalPoints}
   - Prozent: X%
   - Note nach IHK-Schlüssel:
     * 100-92% = 1 (sehr gut)
     * 91-81% = 2 (gut)
     * 80-67% = 3 (befriedigend)
     * 66-50% = 4 (ausreichend) - Bestanden
     * 49-30% = 5 (mangelhaft) - Nicht bestanden
     * 29-0% = 6 (ungenügend) - Nicht bestanden

3. ✅ oder ❌ BESTANDEN / NICHT BESTANDEN
   (Mindestens 50% = bestanden)

4. 💡 VERBESSERUNGSTIPPS
   - Was war gut?
   - Was muss verbessert werden?
   - Konkrete Lernempfehlungen

Sei streng aber fair. Nicht beantwortete Fragen = 0 Punkte.
Antworte auf Deutsch, strukturiert mit Emojis.`;

    const response = await fetch("https://api.groq.com/openai/v1/chat/completions", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${GROQ_API_KEY}`,
      },
      body: JSON.stringify({
        model: "llama-3.3-70b-versatile",
        messages: [{ role: "user", content: prompt }],
        max_tokens: 4000,
        temperature: 0.7,
      }),
    });

    if (!response.ok) {
      const error = await response.text();
      return NextResponse.json({ error: `Groq API Fehler: ${error}` }, { status: 500 });
    }

    const data = await response.json();
    const feedback = data.choices[0]?.message?.content || "Keine Antwort erhalten";

    return NextResponse.json({ feedback });
  } catch (error) {
    console.error("KI-Korrektur Fehler:", error);
    return NextResponse.json({ error: "Interner Serverfehler" }, { status: 500 });
  }
}