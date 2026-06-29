import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Ergebnis der Streak-Auswertung beim App-Eintritt.
class StreakResult {
  /// Aktueller Streak in Tagen (nach heutiger Berechnung).
  final int streakDays;

  /// true, wenn der Begrüßungs-Dialog heute noch nicht gezeigt wurde.
  final bool shouldShowGreeting;

  const StreakResult({
    required this.streakDays,
    required this.shouldShowGreeting,
  });
}

/// Kapselt die account-gebundene Streak-Berechnung (DB) und das
/// "einmal-pro-Tag"-Flag für den Begrüßungs-Dialog (SharedPreferences).
class StreakService {
  StreakService({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  final SupabaseClient _supabase;

  /// Pro Account ein eigener Key, damit zwei Accounts auf einem Gerät
  /// sich nicht gegenseitig den Dialog unterdrücken.
  static const _greetingKeyPrefix = 'streak_greeting_shown_';

  /// Berechnet den Streak (Tages-Guard, schreibt höchstens einmal pro Tag)
  /// und prüft, ob der Begrüßungs-Dialog heute noch aussteht.
  ///
  /// Gibt null zurück, wenn kein Nutzer eingeloggt ist.
  Future<StreakResult?> evaluate() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;

    final streak = await _calcStreak(userId);
    final shouldShow = await _greetingPending(userId);

    return StreakResult(streakDays: streak, shouldShowGreeting: shouldShow);
  }

  /// Markiert den Begrüßungs-Dialog für heute als gezeigt.
  /// Erst NACH dem Anzeigen aufrufen, damit ein Fehler ihn nicht unterdrückt.
  Future<void> markGreetingShown() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('$_greetingKeyPrefix$userId', _todayStr());
    } catch (_) {
      // Flag-Schreiben ist best-effort; im Zweifel zeigt der Dialog nochmal.
    }
  }

  /// true, wenn für heute noch kein Dialog gezeigt wurde.
  Future<bool> _greetingPending(String userId) async {
    if (kDebugMode)
      return true; // DEV: Dialog beim Testen immer zeigen – vor Release entfernen!
    try {
      final prefs = await SharedPreferences.getInstance();
      final shown = prefs.getString('$_greetingKeyPrefix$userId');
      return shown != _todayStr();
    } catch (_) {
      return false; // im Fehlerfall lieber keinen Dialog erzwingen
    }
  }

  /// Berechnet den Streak anhand des letzten Login-Tags – pro Account in der DB.
  /// Idempotent pro Tag: schreibt nur beim ersten Aufruf des Tages.
  /// (Logik 1:1 aus _calcStreak() der Profilseite übernommen.)
  Future<int> _calcStreak(String userId) async {
    try {
      final row = await _supabase
          .from('profiles')
          .select('streak_days, last_login_date')
          .eq('id', userId)
          .maybeSingle();

      int streak = (row?['streak_days'] as num?)?.toInt() ?? 0;
      final lastLogin = row?['last_login_date'] as String?;
      final todayStr = _todayStr();

      // Heute bereits gezählt -> unverändert zurück
      if (lastLogin == todayStr) return streak;

      final today = DateTime.now();
      if (lastLogin != null) {
        final last = DateTime.tryParse(lastLogin);
        if (last != null) {
          final lastDay = DateTime(last.year, last.month, last.day);
          final todayDay = DateTime(today.year, today.month, today.day);
          final diff = todayDay.difference(lastDay).inDays;
          if (diff == 1) {
            streak += 1; // gestern aktiv -> Streak +1
          } else if (diff > 1) {
            streak = 1; // Lücke -> zurück auf 1
          }
          // diff <= 0 -> unverändert lassen
        } else {
          streak = 1;
        }
      } else {
        streak = 1; // erster Login
      }

      await _supabase
          .from('profiles')
          .update({'streak_days': streak, 'last_login_date': todayStr})
          .eq('id', userId);

      return streak;
    } catch (e) {
      debugPrint('StreakService._calcStreak fehlgeschlagen: $e');
      return 0;
    }
  }

  String _todayStr() {
    final today = DateTime.now();
    return '${today.year.toString().padLeft(4, '0')}-'
        '${today.month.toString().padLeft(2, '0')}-'
        '${today.day.toString().padLeft(2, '0')}';
  }
}
