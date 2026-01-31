import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static String get _apiKey => dotenv.env['GROQ_API_KEY'] ?? '';
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
            {
              'role': 'user',
              'content': prompt,
            }
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
}