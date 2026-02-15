import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static String get _apiKey {
    final key = dotenv.env['GROQ_API_KEY'] ?? '';
    print('🔍 Geladener Key: $key');
    print('🔍 dotenv.env Keys: ${dotenv.env.keys.toList()}');
    return key;
  }

  static const _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';

  static final GeminiService _instance = GeminiService._internal();
  factory GeminiService() => _instance;
  GeminiService._internal();

  Future<String> generateContent(String prompt) async {
    if (_apiKey.isEmpty) {
      return 'Fehler: API Key nicht konfiguriert';
    }

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode({
          'model': 'llama-3.3-70b-versatile',
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
          'max_tokens': 4000,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices'][0]['message']['content'] ?? 'Keine Antwort';
      } else {
        print('❌ Groq Fehler: ${response.statusCode} - ${response.body}');
        return 'Fehler: ${response.statusCode}';
      }
    } catch (e) {
      print('❌ Groq Fehler: $e');
      return 'Fehler bei der KI-Anfrage: $e';
    }
  }

  // 1. Fehler erklären (nach falscher Antwort)
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

  // 2. Hilfe geben (wenn User nicht weiterkommt)
  Future<String> getHint({
    required String question,
    required String topic,
    String? currentAttempt,
  }) async {
    // Debug: API Key prüfen
    print('🔑 API Key vorhanden: ${_apiKey.isNotEmpty}');
    print(
      '🔑 API Key Start: ${_apiKey.isEmpty ? "LEER!" : _apiKey.substring(0, 10)}...',
    );

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

    print('📤 Sende Anfrage an Groq API...');
    final result = await generateContent(prompt);
    print('📥 Antwort erhalten: ${result.substring(0, 50)}...');

    return result;
  }

  // Chat mit Kontext
  Future<String> chatWithTutor({
    required String userMessage,
    required List<Map<String, String>> conversationHistory,
    String? currentQuestion,
    String? topic,
  }) async {
    if (_apiKey.isEmpty) {
      return 'Fehler: API Key nicht konfiguriert';
    }

    try {
      // System-Prompt für Kontext
      final systemPrompt = currentQuestion != null
          ? '''Du bist Ada, eine geduldige und freundliche KI-Tutorin für IT-Berufe und IHK-Prüfungen.

      Aktuelle Aufgabe des Azubis:
      $currentQuestion

      Thema: ${topic ?? 'IT-Grundlagen'}

      Beantworte Fragen zum Thema, gib Hinweise und erkläre Schritt für Schritt.
      Bleibe geduldig, motivierend und pädagogisch wertvoll. 
      Stelle dich bei der ersten Nachricht kurz als "Ada" vor.'''
          : 'Du bist Ada, eine geduldige KI-Tutorin für IT-Berufe. Beantworte Fragen motivierend und verständlich. Stelle dich kurz als "Ada" vor.';

      // Messages für API aufbauen
      final messages = [
        {'role': 'system', 'content': systemPrompt},
        ...conversationHistory,
        {'role': 'user', 'content': userMessage},
      ];

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode({
          'model': 'llama-3.3-70b-versatile',
          'messages': messages,
          'max_tokens': 1000,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices'][0]['message']['content'] ?? 'Keine Antwort';
      } else {
        print('❌ Groq Chat Fehler: ${response.statusCode} - ${response.body}');
        return 'Fehler: ${response.statusCode}';
      }
    } catch (e) {
      print('❌ Groq Chat Fehler: $e');
      return 'Fehler bei der KI-Anfrage: $e';
    }
  }
}
