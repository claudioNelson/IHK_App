// lib/services/flashcard_service.dart
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FlashcardService {
  final _supabase = Supabase.instance.client;

  String? get _userId => _supabase.auth.currentUser?.id;

  // Flashcard erstellen wenn Frage falsch beantwortet
  Future<void> createFromWrongAnswer({
    required int frageId,
    required String frageText,
    required String richtigeAntwort,
    String? modulName,
    String? themaName,
  }) async {
    debugPrint('FlashcardService: userId = $_userId');
    debugPrint('User Email: ${_supabase.auth.currentUser?.email}');
    if (_userId == null) return;

    try {
      await _supabase.from('flashcards').upsert({
        'user_id': _userId,
        'frage_id': frageId,
        'frage_text': frageText,
        'antwort_text': richtigeAntwort,
        'modul_name': modulName,
        'thema_name': themaName,
        'bekannt': false,
        'naechste_wiederholung': DateTime.now().toIso8601String(),
      }, onConflict: 'user_id,frage_id');
      debugPrint('✅ Flashcard gespeichert!');
    } catch (e) {
      debugPrint('❌ Flashcard Fehler: $e');
    }
  }

  // Alle Flashcards laden
  Future<List<Map<String, dynamic>>> getFlashcards() async {
    if (_userId == null) return [];

    try {
      final res = await _supabase
          .from('flashcards')
          .select()
          .eq('user_id', _userId!)
          .eq('bekannt', false)
          .order('naechste_wiederholung');

      return List<Map<String, dynamic>>.from(res);
    } catch (e) {
      return [];
    }
  }

  // Anzahl offener Flashcards
  Future<int> getCount() async {
    if (_userId == null) return 0;

    try {
      final res = await _supabase
          .from('flashcards')
          .select('id')
          .eq('user_id', _userId!)
          .eq('bekannt', false);

      return (res as List).length;
    } catch (e) {
      return 0;
    }
  }

  // Als bekannt markieren
  Future<void> markAsKnown(String flashcardId) async {
    try {
      await _supabase
          .from('flashcards')
          .update({'bekannt': true})
          .eq('id', flashcardId);
    } catch (e) {
      debugPrint('markAsKnown Fehler: $e');
    }
  }

  // Nochmal üben
  Future<void> markForRepeat(String flashcardId) async {
    try {
      await _supabase.from('flashcards').update({
        'naechste_wiederholung': DateTime.now()
            .add(const Duration(hours: 1))
            .toIso8601String(),
      }).eq('id', flashcardId);
    } catch (e) {
      debugPrint('markForRepeat Fehler: $e');
    }
  }

  // Alle zurücksetzen
  Future<void> resetAll() async {
    if (_userId == null) return;
    try {
      await _supabase
          .from('flashcards')
          .update({'bekannt': false})
          .eq('user_id', _userId!);
    } catch (e) {}
  }
}