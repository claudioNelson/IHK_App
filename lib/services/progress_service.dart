import 'package:supabase_flutter/supabase_flutter.dart';

class ProgressService {
  final _client = Supabase.instance.client;

  String? get _userId => _client.auth.currentUser?.id;

  /// Speichert eine beantwortete Frage
  Future<void> saveAnswer({
    required int modulId,
    required int themaId,
    required int frageId,
    required bool isCorrect,
  }) async {
    if (_userId == null) return;

    try {
      await _client.from('user_progress').upsert({
        'user_id': _userId,
        'modul_id': modulId,
        'thema_id': themaId,
        'frage_id': frageId,
        'is_correct': isCorrect,
        'answered_at': DateTime.now().toIso8601String(),
      }, onConflict: 'user_id,frage_id');
    } catch (e) {
      print('❌ Fehler beim Speichern: $e');
    }
  }

  /// Lädt alle beantworteten Fragen für ein Modul
  Future<Set<int>> getAnsweredFragen(int modulId) async {
    if (_userId == null) return {};

    try {
      final result = await _client
          .from('user_progress')
          .select('frage_id')
          .eq('user_id', _userId!)
          .eq('modul_id', modulId);

      return result.map<int>((r) => r['frage_id'] as int).toSet();
    } catch (e) {
      print('❌ Fehler beim Laden: $e');
      return {};
    }
  }

  /// Lädt richtig beantwortete Fragen für ein Modul
  Future<Set<int>> getCorrectFragen(int modulId) async {
    if (_userId == null) return {};

    try {
      final result = await _client
          .from('user_progress')
          .select('frage_id')
          .eq('user_id', _userId!)
          .eq('modul_id', modulId)
          .eq('is_correct', true);

      return result.map<int>((r) => r['frage_id'] as int).toSet();
    } catch (e) {
      print('❌ Fehler beim Laden: $e');
      return {};
    }
  }

  /// Lädt Fortschritt für ein Thema (richtige Antworten)
  Future<Set<int>> getThemaProgress(int modulId, int themaId) async {
    if (_userId == null) return {};

    try {
      final result = await _client
          .from('user_progress')
          .select('frage_id')
          .eq('user_id', _userId!)
          .eq('modul_id', modulId)
          .eq('thema_id', themaId)
          .eq('is_correct', true);

      return result.map<int>((r) => r['frage_id'] as int).toSet();
    } catch (e) {
      print('❌ Fehler beim Laden: $e');
      return {};
    }
  }

  /// Zählt abgeschlossene Module (≥80% richtig beantwortet)
  Future<int> getCompletedModulesCount() async {
    if (_userId == null) return 0;

    try {
      // Alle Module laden
      final modules = await _client.from('module').select('id');

      int completedCount = 0;

      for (final modul in modules) {
        final modulId = modul['id'] as int;

        // Gesamtanzahl Fragen im Modul
        final allFragen = await _client
            .from('fragen')
            .select('id')
            .eq('modul_id', modulId);

        final totalFragen = allFragen.length;
        if (totalFragen == 0) continue;

        // Richtig beantwortete Fragen
        final correct = await _client
            .from('user_progress')
            .select('frage_id')
            .eq('user_id', _userId!)
            .eq('modul_id', modulId)
            .eq('is_correct', true);

        final correctCount = correct.length;
        final percent = correctCount / totalFragen;

        if (percent >= 0.8) completedCount++;
      }

      return completedCount;
    } catch (e) {
      print('❌ Fehler beim Laden: $e');
      return 0;
    }
  }

  /// Berechnet Score für ein Thema
  Future<double> getThemaScore(
    int modulId,
    int themaId,
    int totalFragen,
  ) async {
    if (_userId == null || totalFragen == 0) return 0.0;

    try {
      final result = await _client
          .from('user_progress')
          .select('frage_id')
          .eq('user_id', _userId!)
          .eq('modul_id', modulId)
          .eq('thema_id', themaId)
          .eq('is_correct', true);

      return (result.length / totalFragen) * 100;
    } catch (e) {
      print('❌ Fehler beim Laden: $e');
      return 0.0;
    }
  }

  // ========== KERNTHEMEN PROGRESS ==========

  /// Speichert Antwort für Kernthemen-Frage
  Future<void> saveKernthemaAnswer({
    required int modulId,
    required int frageId,
    required bool isCorrect,
  }) async {
    print(
      '🔍 saveKernthemaAnswer gestartet: modul=$modulId, frage=$frageId, correct=$isCorrect',
    ); // ← NEU
    print('🔍 UserId: $_userId'); // ← NEU

    if (_userId == null) {
      print('❌ UserId ist null!'); // ← NEU
      return;
    }

    try {
      print('🔍 Versuche DB-Insert...'); // ← NEU

      await _client.from('user_progress').upsert(
        {
          'user_id': _userId,
          'modul_id': modulId,
          'thema_id': null,
          'frage_id': frageId,
          'is_correct': isCorrect,
          'answered_at': DateTime.now().toIso8601String(),
        },
        onConflict: 'user_id,frage_id', // ← NEU! Welche Spalten für Conflict
      );

      print(
        '✅ Kernthema-Antwort gespeichert: Modul $modulId, Frage $frageId, ${isCorrect ? "richtig" : "falsch"}',
      );
    } catch (e) {
      print('❌ Fehler beim Speichern Kernthema-Antwort: $e');
    }
  }

  /// Lädt Progress für ein Kernthemen-Modul
  Future<Map<String, dynamic>> getKernthemaProgress(int modulId) async {
    if (_userId == null) {
      return {'total': 0, 'correct': 0, 'answered': 0, 'percent': 0.0};
    }

    try {
      print('🔍 Lade Progress für Modul $modulId');
      // Alle Fragen des Moduls
      final allQuestions = await _client
          .from('fragen')
          .select('id')
          .eq('modul_id', modulId);

      print('🔍 Total Fragen: ${allQuestions.length}');

      final totalQuestions = allQuestions.length;

      // User Antworten
      final answers = await _client
          .from('user_progress') // ← user_progress statt user_answers
          .select('frage_id, is_correct')
          .eq('user_id', _userId!)
          .eq('modul_id', modulId);

      print('🔍 Antworten gefunden: ${answers.length}'); // ← NEU
      print('🔍 Antworten: $answers');

      final answeredCount = answers.length;
      final correctCount = answers.where((a) => a['is_correct'] == true).length;
      final percent = totalQuestions > 0
          ? (correctCount / totalQuestions * 100)
          : 0.0;

      return {
        'total': totalQuestions,
        'correct': correctCount,
        'answered': answeredCount,
        'percent': percent,
      };
    } catch (e) {
      print('❌ Fehler beim Laden Kernthema-Progress: $e');
      return {'total': 0, 'correct': 0, 'answered': 0, 'percent': 0.0};
    }
  }

  /// Lädt Gesamt-Progress für alle Kernthemen
  Future<Map<String, dynamic>> getAllKernthemenProgress() async {
    if (_userId == null) {
      return {'total': 0, 'correct': 0, 'answered': 0, 'percent': 0.0};
    }

    try {
      // Alle Kernthemen-Module
      final modules = await _client
          .from('module')
          .select('id')
          .eq('kategorie', 'kernthema');

      final moduleIds = modules.map((m) => m['id'] as int).toList();

      // Alle Kernthemen-Fragen
      final allQuestions = await _client
          .from('fragen')
          .select('id')
          .in_('modul_id', moduleIds);

      final totalQuestions = allQuestions.length;

      // User Antworten für Kernthemen
      final answers = await _client
          .from('user_progress') // ← user_progress statt user_answers
          .select('frage_id, is_correct')
          .eq('user_id', _userId!)
          .in_('modul_id', moduleIds);

      final answeredCount = answers.length;
      final correctCount = answers.where((a) => a['is_correct'] == true).length;
      final percent = totalQuestions > 0
          ? (correctCount / totalQuestions * 100)
          : 0.0;

      return {
        'total': totalQuestions,
        'correct': correctCount,
        'answered': answeredCount,
        'percent': percent,
      };
    } catch (e) {
      print('❌ Fehler beim Laden Gesamt-Kernthemen-Progress: $e');
      return {'total': 0, 'correct': 0, 'answered': 0, 'percent': 0.0};
    }
  }
}
