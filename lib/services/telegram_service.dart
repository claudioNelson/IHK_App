// lib/services/telegram_service.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service zum Senden von Admin-Benachrichtigungen via Telegram Bot.
class TelegramService {
  static final TelegramService _instance = TelegramService._internal();
  factory TelegramService() => _instance;
  TelegramService._internal();

  String? get _botToken => dotenv.env['TELEGRAM_BOT_TOKEN'];
  String? get _chatId => dotenv.env['TELEGRAM_ADMIN_CHAT_ID'];

  bool get _isConfigured =>
      _botToken != null &&
      _botToken!.isNotEmpty &&
      _chatId != null &&
      _chatId!.isNotEmpty;

  final Set<int> _reportedQuestionIds = {};

  Future<void> reportEmptyQuestion({
    required int frageId,
    required String frageText,
    String? modulName,
    String? questionType,
  }) async {
    if (!_isConfigured) {
      debugPrint('⚠️ Telegram nicht konfiguriert (Token/ChatID fehlt)');
      return;
    }

    if (_reportedQuestionIds.contains(frageId)) return;
    _reportedQuestionIds.add(frageId);

    final user = Supabase.instance.client.auth.currentUser;
    final userEmail = user?.email ?? 'Anonym';
    final userId = user?.id ?? '-';
    final userIdShort = userId.length > 8 ? userId.substring(0, 8) : userId;

    final message =
        '''
🚨 <b>Leere Frage gefunden</b>

📝 <b>Frage ID:</b> <code>$frageId</code>
📚 <b>Modul:</b> ${_escapeHtml(modulName ?? '-')}
🏷️ <b>Type:</b> ${_escapeHtml(questionType ?? '-')}

<b>Frage:</b>
${_escapeHtml(frageText)}

👤 <b>User:</b> ${_escapeHtml(userEmail)}
🆔 <b>User ID:</b> <code>$userIdShort...</code>

⏰ ${DateTime.now().toString().substring(0, 16)}
''';

    await _sendMessage(message);
  }

  Future<bool> sendNotification(String message) async {
    if (!_isConfigured) return false;
    return await _sendMessage(message);
  }

  Future<bool> _sendMessage(String message) async {
    try {
      final url = Uri.parse(
        'https://api.telegram.org/bot$_botToken/sendMessage',
      );
      final response = await http.post(
        url,
        body: {'chat_id': _chatId!, 'text': message, 'parse_mode': 'HTML'},
      );

      if (response.statusCode == 200) {
        debugPrint('✅ Telegram Nachricht gesendet');
        return true;
      } else {
        debugPrint('❌ Telegram Fehler: ${response.statusCode}');
        debugPrint('   Body: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Telegram Exception: $e');
      return false;
    }
  }

  /// HTML Escape für Telegram (verhindert Tag-Probleme bei < > &)
  String _escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;');
  }
}
