// lib/services/exam_attempt_service.dart
//
// Speichert Versuche der IHK-Pruefungssimulationen (AE-1 ... SI-2) in
// public.user_exam_attempts, damit sie im Profil (App + Web) auftauchen
// und Exam-Badges vergeben werden koennen.
//
// Ablauf:
//   1. Abgeben  -> versuchSpeichern(): Zeile mit status 'submitted'
//   2. KI-Korrektur liefert Punkte -> bewertungSpeichern(): Punkte,
//      Prozent, bestanden (ab 50 %, IHK-Grenze), status 'graded'
//
// Die App kennt Pruefungen nur ueber ihren Slug ('ae-1'), die Tabelle
// exams hat dafuer seit Migration 20260901100000 die Spalte slug.

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExamBewertung {
  final double erreicht;
  final double gesamt;

  const ExamBewertung({required this.erreicht, required this.gesamt});

  double get prozent => gesamt <= 0 ? 0 : (erreicht / gesamt * 100).clamp(0, 100);
  bool get bestanden => prozent >= 50;

  /// IHK-Notenschluessel (Punkte in Prozent).
  int get note {
    final p = prozent;
    if (p >= 92) return 1;
    if (p >= 81) return 2;
    if (p >= 67) return 3;
    if (p >= 50) return 4;
    if (p >= 30) return 5;
    return 6;
  }
}

class ExamAttemptService {
  final _client = Supabase.instance.client;

  String? get _userId => _client.auth.currentUser?.id;

  Future<int?> _examIdFuerSlug(String slug) async {
    final zeile = await _client
        .from('exams')
        .select('id')
        .eq('slug', slug)
        .maybeSingle();
    return zeile?['id'] as int?;
  }

  /// Nach dem Abgeben: Versuch anlegen. Gibt die Versuch-Id zurueck
  /// (null, wenn nicht eingeloggt oder Pruefung unbekannt).
  Future<String?> versuchSpeichern({
    required String examSlug,
    required int gesamtPunkte,
    required int sekundenGebraucht,
  }) async {
    final userId = _userId;
    if (userId == null) return null;
    try {
      final examId = await _examIdFuerSlug(examSlug);
      if (examId == null) {
        debugPrint('Exam-Versuch: kein exams-Eintrag fuer $examSlug');
        return null;
      }
      final jetzt = DateTime.now();
      final zeile = await _client
          .from('user_exam_attempts')
          .insert({
            'user_id': userId,
            'exam_id': examId,
            'started_at': jetzt
                .subtract(Duration(seconds: sekundenGebraucht))
                .toIso8601String(),
            'submitted_at': jetzt.toIso8601String(),
            'time_spent_seconds': sekundenGebraucht,
            'total_points': gesamtPunkte,
            'status': 'submitted',
          })
          .select('id')
          .single();
      return zeile['id'] as String?;
    } catch (e) {
      debugPrint('Exam-Versuch speichern fehlgeschlagen: $e');
      return null;
    }
  }

  /// Nach der KI-Korrektur: Punkte eintragen und Versuch als bewertet
  /// markieren.
  Future<bool> bewertungSpeichern({
    required String attemptId,
    required ExamBewertung bewertung,
  }) async {
    if (_userId == null) return false;
    try {
      await _client
          .from('user_exam_attempts')
          .update({
            'achieved_points': bewertung.erreicht,
            'total_points': bewertung.gesamt,
            'percentage': double.parse(bewertung.prozent.toStringAsFixed(1)),
            'passed': bewertung.bestanden,
            'status': 'graded',
          })
          .eq('id', attemptId);
      return true;
    } catch (e) {
      debugPrint('Exam-Bewertung speichern fehlgeschlagen: $e');
      return false;
    }
  }

  /// Anzahl bestandener Versuche (fuer die Exam-Badges).
  Future<int> anzahlBestanden() async {
    final userId = _userId;
    if (userId == null) return 0;
    try {
      final zeilen = await _client
          .from('user_exam_attempts')
          .select('id')
          .eq('user_id', userId)
          .eq('passed', true);
      return (zeilen as List).length;
    } catch (_) {
      return 0;
    }
  }

  /// Holt "GESAMTPUNKTE: 63/100" (oder 63 / 100, 63,5/100) aus dem
  /// KI-Text. Null, wenn die KI die Zeile nicht geliefert hat.
  static ExamBewertung? punkteAusKiText(String text, int gesamtFallback) {
    final muster = RegExp(
      r'GESAMTPUNKTE\s*:\s*(\d+(?:[.,]\d+)?)\s*/\s*(\d+(?:[.,]\d+)?)',
      caseSensitive: false,
    );
    final treffer = muster.firstMatch(text);
    if (treffer == null) return null;
    final erreicht = double.tryParse(treffer.group(1)!.replaceAll(',', '.'));
    final gesamt = double.tryParse(treffer.group(2)!.replaceAll(',', '.'));
    if (erreicht == null) return null;
    final g = (gesamt == null || gesamt <= 0) ? gesamtFallback.toDouble() : gesamt;
    return ExamBewertung(erreicht: erreicht.clamp(0, g), gesamt: g);
  }
}
