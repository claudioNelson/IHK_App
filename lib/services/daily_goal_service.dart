import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Liest tagesbezogene Lern-Statistiken (für das Tagesziel im Begrüßungs-Dialog).
class DailyGoalService {
  DailyGoalService({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  final SupabaseClient _supabase;

  /// Zählt die heute (lokale Zeit) beantworteten Fragen aus user_progress.
  Future<int> getTodayAnsweredCount() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return 0;

      final now = DateTime.now();
      // Lokaler Tagesbeginn -> UTC, weil answered_at als timestamptz (UTC) liegt.
      final startOfDayUtc = DateTime(
        now.year,
        now.month,
        now.day,
      ).toUtc().toIso8601String();

      final rows = await _supabase
          .from('user_progress')
          .select('id')
          .eq('user_id', userId)
          .gte('answered_at', startOfDayUtc);

      return (rows as List).length;
    } catch (e) {
      debugPrint('DailyGoalService.getTodayAnsweredCount fehlgeschlagen: $e');
      return 0;
    }
  }

  /// Zählt die gestern (lokale Zeit) beantworteten Fragen aus user_progress.
  Future<int> getYesterdayAnsweredCount() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return 0;

      final now = DateTime.now();
      final startOfToday = DateTime(now.year, now.month, now.day);
      final startOfYesterday = startOfToday.subtract(const Duration(days: 1));

      final rows = await _supabase
          .from('user_progress')
          .select('id')
          .eq('user_id', userId)
          .gte('answered_at', startOfYesterday.toUtc().toIso8601String())
          .lt('answered_at', startOfToday.toUtc().toIso8601String());

      return (rows as List).length;
    } catch (e) {
      debugPrint(
        'DailyGoalService.getYesterdayAnsweredCount fehlgeschlagen: $e',
      );
      return 0;
    }
  }

  /// Liefert pro aktivem Tag die Anzahl beantworteter Fragen, für die
  /// letzten [weeks] Wochen. Schlüssel ist der lokale Tag (Mitternacht).
  /// Tage ohne Aktivität fehlen in der Map (nicht 0).
  Future<Map<DateTime, int>> getActiveDayCounts({int weeks = 12}) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return {};

      final now = DateTime.now();
      final startOfToday = DateTime(now.year, now.month, now.day);
      // weeks * 7 Tage zurück (inkl. heute).
      final from = startOfToday.subtract(Duration(days: weeks * 7 - 1));

      final rows = await _supabase
          .from('user_progress')
          .select('answered_at')
          .eq('user_id', userId)
          .gte('answered_at', from.toUtc().toIso8601String());

      final counts = <DateTime, int>{};
      for (final row in (rows as List)) {
        final raw = (row as Map)['answered_at'] as String?;
        if (raw == null) continue;
        final dt = DateTime.tryParse(raw)?.toLocal();
        if (dt == null) continue;
        // Auf lokalen Tag (Mitternacht) normalisieren.
        final day = DateTime(dt.year, dt.month, dt.day);
        counts[day] = (counts[day] ?? 0) + 1;
      }
      return counts;
    } catch (e) {
      debugPrint('DailyGoalService.getActiveDayCounts fehlgeschlagen: $e');
      return {};
    }
  }
}
