import 'package:supabase_flutter/supabase_flutter.dart';

class SpacedRepetitionService {
  final _supabase = Supabase.instance.client;

  /// Registriert eine beantwortete Frage und berechnet nächste Wiederholung
  Future<void> recordAnswer({
    required int frageId,
    required bool isCorrect,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      // Prüfe ob Frage schon existiert
      final existing = await _supabase
          .from('spaced_repetition')
          .select()
          .eq('user_id', userId)
          .eq('frage_id', frageId)
          .maybeSingle();

      if (existing == null) {
        // Erste Beantwortung - neu anlegen
        await _createNewCard(userId, frageId, isCorrect);
      } else {
        // Update basierend auf Antwort
        await _updateCard(existing, isCorrect);
      }
    } catch (e) {
      print('❌ Fehler beim Speichern der Wiederholung: $e');
    }
  }

  /// Erstellt eine neue Karteikarte
  Future<void> _createNewCard(String userId, int frageId, bool isCorrect) async {
    final now = DateTime.now();
    final nextReview = isCorrect
        ? now.add(const Duration(days: 1)) // Richtig → 1 Tag
        : now.add(const Duration(hours: 1)); // Falsch → 1 Stunde

    await _supabase.from('spaced_repetition').insert({
      'user_id': userId,
      'frage_id': frageId,
      'easiness_factor': 2.5,
      'interval': isCorrect ? 1 : 0,
      'repetitions': isCorrect ? 1 : 0,
      'last_reviewed_at': now.toIso8601String(),
      'next_review_at': nextReview.toIso8601String(),
    });
  }

  /// Aktualisiert eine existierende Karteikarte mit SM-2 Algorithmus
  Future<void> _updateCard(Map<String, dynamic> card, bool isCorrect) async {
    double easinessFactor = (card['easiness_factor'] ?? 2.5).toDouble();
    int interval = card['interval'] ?? 1;
    int repetitions = card['repetitions'] ?? 0;

    if (isCorrect) {
      // SM-2 Algorithmus
      if (repetitions == 0) {
        interval = 1;
      } else if (repetitions == 1) {
        interval = 6;
      } else {
        interval = (interval * easinessFactor).round();
      }

      repetitions++;
      easinessFactor = easinessFactor + (0.1 - (5 - 5) * (0.08 + (5 - 5) * 0.02));
      
      // EF sollte zwischen 1.3 und 2.5 bleiben
      if (easinessFactor < 1.3) easinessFactor = 1.3;
      if (easinessFactor > 2.5) easinessFactor = 2.5;
    } else {
      // Falsch beantwortet → Reset
      repetitions = 0;
      interval = 1;
    }

    final nextReview = DateTime.now().add(Duration(days: interval));

    await _supabase.from('spaced_repetition').update({
      'easiness_factor': easinessFactor,
      'interval': interval,
      'repetitions': repetitions,
      'last_reviewed_at': DateTime.now().toIso8601String(),
      'next_review_at': nextReview.toIso8601String(),
    }).eq('id', card['id']);
  }

  /// Holt alle Fragen die heute wiederholt werden sollten
  Future<List<Map<String, dynamic>>> getDueQuestions() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return [];

      final now = DateTime.now();

      final results = await _supabase
          .from('spaced_repetition')
          .select('''
            *,
            fragen (
              id,
              frage,
              modul_id,
              thema_id
            )
          ''')
          .eq('user_id', userId)
          .lte('next_review_at', now.toIso8601String())
          .order('next_review_at', ascending: true)
          .limit(50); // Max 50 Fragen pro Session

      return List<Map<String, dynamic>>.from(results);
    } catch (e) {
      print('❌ Fehler beim Laden fälliger Fragen: $e');
      return [];
    }
  }

  /// Zählt wie viele Fragen heute fällig sind
  Future<int> getDueCount() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return 0;

      final now = DateTime.now();

      final result = await _supabase
          .from('spaced_repetition')
          .select('id')
          .eq('user_id', userId)
          .lte('next_review_at', now.toIso8601String());

      return result.length;
    } catch (e) {
      print('❌ Fehler beim Zählen: $e');
      return 0;
    }
  }

  /// Statistiken für Dashboard
  Future<Map<String, dynamic>> getStats() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return {};

      final all = await _supabase
          .from('spaced_repetition')
          .select('repetitions, interval')
          .eq('user_id', userId);

      final total = all.length;
      final mastered = all.where((c) => (c['repetitions'] ?? 0) >= 5).length;
      final learning = all.where((c) {
        final reps = c['repetitions'] ?? 0;
        return reps > 0 && reps < 5;
      }).length;
      final new_ = all.where((c) => (c['repetitions'] ?? 0) == 0).length;

      return {
        'total': total,
        'mastered': mastered,
        'learning': learning,
        'new': new_,
      };
    } catch (e) {
      print('❌ Fehler bei Stats: $e');
      return {};
    }
  }
}