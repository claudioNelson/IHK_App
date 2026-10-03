// lib/services/gemini_service.dart
//
// AI-Tutor Client. Spricht NICHT direkt mit einem KI-Anbieter, sondern mit
// unserer Supabase Edge Function "ai-tutor".
//
// Der Klassenname ist historisch — Gemini ist seit 30.08.2026 nicht mehr im
// Spiel (Trainingsnutzung in der kostenlosen Stufe, siehe Kommentar in
// supabase/functions/ai-tutor/index.ts). Im Backend laeuft jetzt
// Claude (claude-haiku-4-5) mit Groq als Rueckfallebene.
//
// Vorteile:
// - API-Keys nicht mehr in der App (sicher)
// - Failover im Backend, ohne App-Update aenderbar
// - Server-seitiger Limit-Check (kann nicht umgangen werden)

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GeminiService {
  static final GeminiService _instance = GeminiService._internal();
  factory GeminiService() => _instance;
  GeminiService._internal();

  final _supabase = Supabase.instance.client;

  // ─── PUBLIC API ──────────────────────────────

  /// Einfacher One-Shot Prompt (für explainMistake/getHint).
  /// Fuer lange Antworten (Pruefungskorrektur) [maxTokens] hoeher setzen,
  /// sonst bricht die Antwort mitten im Text ab (Befund 30.09.2026).
  Future<String> generateContent(
    String prompt, {
    int maxTokens = 1000,
    double temperature = 0.7,
  }) async {
    return await _callEdgeFunction(
      messages: [
        {'role': 'user', 'content': prompt},
      ],
      maxTokens: maxTokens,
      temperature: temperature,
    );
  }

  /// Fehler-Erklärung mit fertig formatiertem Prompt.
  Future<String> explainMistake({
    required String question,
    required String userAnswer,
    required String correctAnswer,
    required String topic,
  }) async {
    final prompt =
        '''Du bist ein geduldiger IHK-Prüfungs-Tutor für IT-Berufe.

**Aufgabe:** Erkläre dem Azubi seinen Fehler.

**Frage:**
$question

**Antwort des Azubis:**
$userAnswer

**Richtige Antwort:**
$correctAnswer

**Thema:** $topic

Gib eine kurze, verständliche Erklärung:
1. Was war der Fehler?
2. Wie kommt man auf die richtige Lösung?
3. Ein Tipp zum Merken

Max. 150 Wörter, motivierend!''';

    return await generateContent(prompt);
  }

  /// Hint geben ohne die Lösung zu verraten.
  Future<String> getHint({
    required String question,
    required String topic,
    String? currentAttempt,
  }) async {
    final attemptText = currentAttempt != null && currentAttempt.isNotEmpty
        ? '\n**Bisheriger Versuch des Azubis:**\n$currentAttempt\n'
        : '';

    final prompt =
        '''Du bist ein geduldiger IHK-Prüfungs-Tutor für IT-Berufe.

**Aufgabe:** Gib dem Azubi einen Hinweis, OHNE die Lösung direkt zu verraten.

**Frage:**
$question
$attemptText
**Thema:** $topic

Gib einen hilfreichen Tipp:
- Erkläre den Lösungsweg Schritt für Schritt
- Gib Formeln oder Methoden an
- KEINE direkte Lösung nennen!
- Ermutige zum Weiterdenken

Max. 120 Wörter, motivierend!''';

    return await generateContent(prompt);
  }

  /// Chat mit System-Prompt + Conversation History.
  Future<String> chatWithTutor({
    required String userMessage,
    required List<Map<String, String>> conversationHistory,
    String? currentQuestion,
    String? topic,
  }) async {
    // Vorstellen nur beim allerersten Austausch. Sobald es Verlauf gibt,
    // bekommt das Modell die gegenteilige Anweisung, sonst stellt sich
    // Ada bei jeder Antwort neu vor.
    final vorstellung = conversationHistory.isEmpty
        ? 'Stelle dich in deiner ersten Antwort mit einem kurzen Satz als "Ada" vor, danach nie wieder.'
        : 'Du hast dich bereits vorgestellt. Stelle dich NICHT erneut vor, keine Begrüßungsfloskeln, antworte direkt auf die Frage.';

    final systemPrompt = currentQuestion != null
        ? '''Du bist Ada, eine geduldige und freundliche KI-Tutorin für IT-Berufe und IHK-Prüfungen.

Aktuelle Aufgabe des Azubis:
$currentQuestion

Thema: ${topic ?? 'IT-Grundlagen'}

Beantworte Fragen zum Thema, gib Hinweise und erkläre Schritt für Schritt.
Bleibe geduldig, motivierend und pädagogisch wertvoll.
$vorstellung'''
        : 'Du bist Ada, eine geduldige KI-Tutorin für IT-Berufe. Beantworte Fragen motivierend und verständlich. $vorstellung';

    final messages = [
      {'role': 'system', 'content': systemPrompt},
      ...conversationHistory,
      {'role': 'user', 'content': userMessage},
    ];

    return await _callEdgeFunction(messages: messages);
  }

  // ─── PRIVATE: Edge Function Call ────────────

  Future<String> _callEdgeFunction({
    required List<Map<String, String>> messages,
    int maxTokens = 1000,
    double temperature = 0.7,
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        'ai-tutor',
        body: {
          'messages': messages,
          'max_tokens': maxTokens,
          'temperature': temperature,
        },
      );

      // Hinweis: Ein Status außer 2xx kommt hier nie an. functions_client
      // wirft dafür eine FunctionException, siehe unten. Die Prüfung bleibt
      // nur als Absicherung.
      if (response.status != 200) {
        final data = response.data as Map<String, dynamic>?;
        final errorMsg = data?['error'] ?? 'HTTP ${response.status}';
        debugPrint('❌ AI-Tutor Edge Function Fehler: $errorMsg');
        throw Exception('AI-Tutor Fehler: $errorMsg');
      }

      // Erfolg
      final data = response.data as Map<String, dynamic>?;
      final content = data?['content'] as String?;
      final provider = data?['provider'] as String?;

      if (content == null || content.isEmpty) {
        throw Exception('Keine Antwort vom AI-Tutor');
      }

      debugPrint('✅ AI-Tutor Antwort von Provider: $provider');
      return content;
    } on FunctionException catch (e) {
      // functions_client wirft bei jedem Status außer 2xx eine
      // FunctionException (bei Verbindungsfehlern mit status 0). Bis
      // 03.10.2026 wurde 429 deshalb nie als Limit erkannt, und die Nutzer
      // lasen „nicht erreichbar, prüf deine Internetverbindung“
      // (Play-Bewertung 27.09.2026).
      if (e.status == 429) {
        final details = e.details;
        final limit = details is Map ? details['limit'] : null;
        final used = details is Map ? details['used'] : null;
        throw LimitReachedException(
          limit: limit is int ? limit : 5,
          used: used is int ? used : 5,
        );
      }
      debugPrint('❌ AI-Tutor Edge Function Fehler: ${e.status} ${e.details}');
      rethrow;
    } catch (e) {
      debugPrint('❌ AI-Tutor Aufruf fehlgeschlagen: $e');
      rethrow;
    }
  }

  /// Verständliche Meldung für jeden Fehler aus diesem Service, damit kein
  /// Screen mehr rohe Exception-Texte anzeigt.
  static String fehlerText(Object fehler) {
    if (fehler is LimitReachedException) {
      return 'Du hast deine ${fehler.limit} kostenlosen Ada-Fragen für heute '
          'aufgebraucht. Morgen geht es weiter, mit Premium fragst du ohne '
          'Limit.';
    }
    if (fehler is FunctionException && fehler.status == 0) {
      return 'Keine Verbindung zu Ada. Prüf deine Internetverbindung und '
          'versuch es gleich nochmal.';
    }
    return 'Ada hat gerade ein technisches Problem. Versuch es in ein paar '
        'Minuten nochmal.';
  }
}

/// Exception die geworfen wird, wenn der User sein Daily-Limit erreicht hat.
class LimitReachedException implements Exception {
  final int limit;
  final int used;

  LimitReachedException({required this.limit, required this.used});

  @override
  String toString() => 'AI-Tutor Limit erreicht: $used/$limit';
}
