// lib/services/telegram_service.dart
//
// Service zum Senden von Admin-Benachrichtigungen via Telegram Bot.
// Ruft dafür die Supabase Edge Function 'report-bug' auf.
// Token + Chat-ID liegen NICHT in der App, sondern als Supabase Secrets.

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TelegramService {
  static final TelegramService _instance = TelegramService._internal();
  factory TelegramService() => _instance;
  TelegramService._internal();

  /// Speichert IDs bereits gemeldeter Probleme, um Spam zu vermeiden.
  final Set<int> _reportedQuestionIds = {};

  /// Meldet eine leere Frage an den Admin.
  /// Pro frageId wird maximal EIN Report gesendet.
  Future<void> reportEmptyQuestion({
    required int frageId,
    required String frageText,
    String? modulName,
    String? questionType,
  }) async {
    if (_reportedQuestionIds.contains(frageId)) return;
    _reportedQuestionIds.add(frageId);

    final user = Supabase.instance.client.auth.currentUser;
    final userEmail = user?.email ?? 'Anonym';
    final userId = user?.id ?? '-';
    final userIdShort = userId.length > 8 ? userId.substring(0, 8) : userId;

    final message =
        '''
🚨 <b>Leere Frage gefunden</b>

🏷️ <b>Type:</b> ${_escapeHtml(questionType ?? '-')}
📚 <b>Modul:</b> ${_escapeHtml(modulName ?? '-')}

<b>Frage:</b>
${_escapeHtml(frageText)}

👤 <b>User:</b> ${_escapeHtml(userEmail)}
🆔 <b>User ID:</b> <code>$userIdShort...</code>
⏰ ${DateTime.now().toString().substring(0, 16)}
''';

    await _sendMessage(message);
  }

  /// Sendet eine beliebige Notification an den Admin.
  Future<bool> sendNotification(String message) async {
    return await _sendMessage(message);
  }

  /// Interner Send-Aufruf via Edge Function.
  Future<bool> _sendMessage(String message) async {
    try {
      final response = await Supabase.instance.client.functions.invoke(
        'report-bug',
        body: {'message': message},
      );

      // Supabase liefert bei 2xx automatisch response.data, bei 4xx/5xx
      // wirft es eine FunctionException (kommt unten im catch an).
      if (response.status == 200) {
        debugPrint('✅ Telegram Nachricht gesendet (via Edge Function)');
        return true;
      } else {
        debugPrint(
          '⚠️ Edge Function antwortete unerwartet: ${response.status} – ${response.data}',
        );
        return false;
      }
    } catch (e) {
      // Wir wollen NICHT, dass eine fehlgeschlagene Bug-Meldung die App crasht.
      // Loggen, schlucken, weitermachen.
      debugPrint('❌ Telegram (Edge Function) Fehler: $e');
      return false;
    }
  }

  String _escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;');
  }
}
