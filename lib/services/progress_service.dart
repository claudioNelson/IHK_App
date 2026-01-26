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
      });
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

  /// Zählt abgeschlossene Module (mindestens 1 Thema mit Fortschritt)
  Future<int> getCompletedModulesCount() async {
    if (_userId == null) return 0;

    try {
      final result = await _client
          .from('user_progress')
          .select('modul_id')
          .eq('user_id', _userId!);

      return result.map((r) => r['modul_id']).toSet().length;
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
}
