import 'package:supabase_flutter/supabase_flutter.dart';

class ReportService {
  final _client = Supabase.instance.client;

  /// Erstellt einen neuen Report
  Future<void> submitReport({
    required int frageId,
    required String reportType,
    required String description,
    required String screenType,
  }) async {
    final userId = _client.auth.currentUser?.id;

    await _client.from('question_reports').insert({
      'frage_id': frageId,
      'user_id': userId,
      'report_type': reportType,
      'description': description,
      'screen_type': screenType,
    });

    print('✅ Report erfolgreich erstellt für Frage: $frageId');
  }

  /// Lädt eigene Reports (für später)
  Future<List<Map<String, dynamic>>> getMyReports() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final result = await _client
        .from('question_reports')
        .select('*, fragen:frage_id(frage)')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(result);
  }
}
