// lib/services/gemini_service.dart
//
// AI-Tutor Client. Spricht NICHT mehr direkt mit Groq/Gemini,
// sondern mit unserer Supabase Edge Function "ai-tutor".
//
// Vorteile:
// - API-Keys nicht mehr in der App (sicher)
// - Failover Groq → Gemini im Backend
// - Server-seitiger Limit-Check (kann nicht umgangen werden)
// - Provider-Wechsel ohne App-Update möglich

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GeminiService {
  static final GeminiService _instance = GeminiService._internal();
  factory GeminiService() => _instance;
  GeminiService._internal();

  final _supabase = Supabase.instance.client;

  // ─── PUBLIC API ──────────────────────────────

  /// Einfacher One-Shot Prompt (für explainMistake/getHint).
  Future<String> generateContent(String prompt) async {
    return await _callEdgeFunction(
      messages: [
        {'role': 'user', 'content': prompt},
      ],
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
    final systemPrompt = currentQuestion != null
        ? '''Du bist Ada, eine geduldige und freundliche KI-Tutorin für IT-Berufe und IHK-Prüfungen.

Aktuelle Aufgabe des Azubis:
$currentQuestion

Thema: ${topic ?? 'IT-Grundlagen'}

Beantworte Fragen zum Thema, gib Hinweise und erkläre Schritt für Schritt.
Bleibe geduldig, motivierend und pädagogisch wertvoll.
Stelle dich bei der ersten Nachricht kurz als "Ada" vor.'''
        : 'Du bist Ada, eine geduldige KI-Tutorin für IT-Berufe. Beantworte Fragen motivierend und verständlich. Stelle dich kurz als "Ada" vor.';

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

      // Limit erreicht
      if (response.status == 429) {
        final data = response.data as Map<String, dynamic>?;
        throw LimitReachedException(
          limit: data?['limit'] ?? 5,
          used: data?['used'] ?? 5,
        );
      }

      // Andere Fehler
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
    } on LimitReachedException {
      rethrow;
    } catch (e) {
      debugPrint('❌ AI-Tutor Aufruf fehlgeschlagen: $e');
      rethrow;
    }
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
