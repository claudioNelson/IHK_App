// lib/services/level_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

/// Tier eines Levels (Schwierigkeitsgrad-Stufe)
enum LevelTier { basics, praxis, pruefung }

extension LevelTierX on LevelTier {
  String get label {
    switch (this) {
      case LevelTier.basics:
        return 'Basics';
      case LevelTier.praxis:
        return 'Praxis';
      case LevelTier.pruefung:
        return 'Prüfung';
    }
  }

  static LevelTier fromString(String? raw) {
    switch (raw) {
      case 'praxis':
        return LevelTier.praxis;
      case 'pruefung':
        return LevelTier.pruefung;
      default:
        return LevelTier.basics;
    }
  }
}

/// Ein Level innerhalb eines Moduls — inkl. User-Progress
class Level {
  final int id;
  final int modulId;
  final int nummer;
  final String titel;
  final String? beschreibung;
  final LevelTier tier;
  final int schwelle; // 70/80/100
  final bool isPremium;

  // Progress (aus level_progress geladen)
  final int bestScore;
  final int sterne; // 0-3
  final int attempts;
  final DateTime? firstCompletedAt;

  const Level({
    required this.id,
    required this.modulId,
    required this.nummer,
    required this.titel,
    this.beschreibung,
    required this.tier,
    required this.schwelle,
    required this.isPremium,
    this.bestScore = 0,
    this.sterne = 0,
    this.attempts = 0,
    this.firstCompletedAt,
  });

  /// Level gilt als geschafft, wenn Best-Score >= Schwelle
  bool get isCompleted => bestScore >= schwelle;

  /// Wurde mindestens einmal versucht?
  bool get isStarted => attempts > 0;

  static Level fromMap(
    Map<String, dynamic> levelRow, {
    Map<String, dynamic>? progressRow,
  }) {
    return Level(
      id: levelRow['id'] as int,
      modulId: levelRow['modul_id'] as int,
      nummer: levelRow['nummer'] as int,
      titel: levelRow['titel'] as String,
      beschreibung: levelRow['beschreibung'] as String?,
      tier: LevelTierX.fromString(levelRow['tier'] as String?),
      schwelle: levelRow['schwelle'] as int,
      isPremium: levelRow['is_premium'] as bool? ?? false,
      bestScore: progressRow?['best_score'] as int? ?? 0,
      sterne: progressRow?['sterne'] as int? ?? 0,
      attempts: progressRow?['attempts'] as int? ?? 0,
      firstCompletedAt: progressRow?['first_completed_at'] != null
          ? DateTime.tryParse(progressRow!['first_completed_at'] as String)
          : null,
    );
  }
}

/// Service für Level-Daten und Progress-Tracking
class LevelService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Alle Levels eines Moduls inkl. User-Progress laden
  Future<List<Level>> getLevelsForModul(int modulId) async {
    // 1. Levels laden
    final levelsRes = await _supabase
        .from('levels')
        .select()
        .eq('modul_id', modulId)
        .order('nummer');

    final levelRows = List<Map<String, dynamic>>.from(levelsRes as List);
    if (levelRows.isEmpty) return [];

    // 2. Progress des aktuellen Users laden
    final userId = _supabase.auth.currentUser?.id;
    Map<int, Map<String, dynamic>> progressMap = {};

    if (userId != null) {
      // Alle level_ids zu einem CSV für die in-Filter-Klausel
      final levelIds = levelRows.map((l) => l['id']).toList();
      final progressRes = await _supabase
          .from('level_progress')
          .select()
          .eq('user_id', userId)
          .filter('level_id', 'in', '(${levelIds.join(',')})');

      for (final row in progressRes as List) {
        progressMap[row['level_id'] as int] = row as Map<String, dynamic>;
      }
    }

    // 3. Mergen
    return levelRows
        .map((row) => Level.fromMap(row, progressRow: progressMap[row['id']]))
        .toList();
  }

  /// Fragen eines Levels laden (mit Antworten + calculation_data)
  /// Bei Basics: Reihenfolge fix (Drill). Bei Praxis/Pruefung: gemischt.
  /// Antworten werden immer gemischt (sonst ist die richtige immer an
  /// der gleichen Position).
  Future<List<Map<String, dynamic>>> getFragenForLevel(
    int levelId, {
    required LevelTier tier,
  }) async {
    final res = await _supabase
        .from('fragen')
        .select(
          'id, frage, frage_typ, erklaerung, calculation_data, reihenfolge, '
          'antworten(id, text, ist_richtig, erklaerung)',
        )
        .eq('level_id', levelId)
        .order('reihenfolge', ascending: true);

    final list = List<Map<String, dynamic>>.from(res as List);

    if (tier != LevelTier.basics) {
      list.shuffle();
    }
    for (final f in list) {
      if (f['antworten'] != null) {
        final a = List<dynamic>.from(f['antworten'] as List);
        a.shuffle();
        f['antworten'] = a;
      }
    }
    return list;
  }

  /// Result eines Levels speichern (Best-Score-Logik)
  /// Returns: aktualisiertes level_progress Row
  Future<Map<String, dynamic>> saveResult({
    required int levelId,
    required int score, // 0-100
    required int schwelle,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Nicht eingeloggt');
    }

    final sterne = calculateSterne(score);
    final now = DateTime.now().toIso8601String();

    // 1. Existierenden Progress holen
    final existing = await _supabase
        .from('level_progress')
        .select()
        .eq('user_id', userId)
        .eq('level_id', levelId)
        .maybeSingle();

    if (existing == null) {
      // Erster Versuch
      final inserted = await _supabase
          .from('level_progress')
          .insert({
            'user_id': userId,
            'level_id': levelId,
            'best_score': score,
            'sterne': sterne,
            'attempts': 1,
            'first_completed_at': score >= schwelle ? now : null,
            'last_attempt_at': now,
          })
          .select()
          .single();
      return inserted as Map<String, dynamic>;
    } else {
      // Update: Best-Score-Logik
      final oldBest = existing['best_score'] as int;
      final oldSterne = existing['sterne'] as int;
      final newBest = score > oldBest ? score : oldBest;
      final newSterne = sterne > oldSterne ? sterne : oldSterne;

      final firstCompletedAt = existing['first_completed_at'];
      final newFirstCompleted =
          firstCompletedAt ?? (score >= schwelle ? now : null);

      final updated = await _supabase
          .from('level_progress')
          .update({
            'best_score': newBest,
            'sterne': newSterne,
            'attempts': (existing['attempts'] as int) + 1,
            'first_completed_at': newFirstCompleted,
            'last_attempt_at': now,
          })
          .eq('user_id', userId)
          .eq('level_id', levelId)
          .select()
          .single();
      return updated as Map<String, dynamic>;
    }
  }

  /// Sterne-Berechnung nach Score:
  /// 100% = 3 Sterne, 80-99% = 2, 60-79% = 1, <60% = 0
  static int calculateSterne(int score) {
    if (score >= 100) return 3;
    if (score >= 80) return 2;
    if (score >= 60) return 1;
    return 0;
  }

  /// Strikt linear: Level X freigeschaltet wenn Level X-1 completed.
  /// Level 1 ist immer frei.
  static bool isUnlocked(Level level, List<Level> allLevels) {
    if (level.nummer == 1) return true;
    final previous = allLevels.where((l) => l.nummer == level.nummer - 1);
    if (previous.isEmpty) return true; // kein Vorgänger gefunden → frei
    return previous.first.isCompleted;
  }
}
