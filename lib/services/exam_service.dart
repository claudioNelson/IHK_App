import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/question_model.dart';

class ExamService {
  final _supabase = Supabase.instance.client;

  /// Lädt alle Fragen für ein bestimmtes Exam
  Future<List<Question>> getExamQuestions(int examId) async {
    try {
      final response = await _supabase
          .from('exam_questions')
          .select()
          .eq('exam_id', examId)
          .order('sort_order', ascending: true);

      if (response == null || response.isEmpty) {
        print('⚠️ Keine Fragen gefunden für exam_id: $examId');
        return [];
      }

      final questions = (response as List)
          .map((json) => Question.fromJson(json))
          .toList();

      print('✅ ${questions.length} Fragen geladen für exam_id: $examId');
      return questions;
    } catch (e) {
      print('❌ Fehler beim Laden der Fragen: $e');
      rethrow;
    }
  }

  /// Lädt Exam-Informationen
  Future<Map<String, dynamic>?> getExamInfo(int examId) async {
    try {
      final response = await _supabase
          .from('exams')
          .select()
          .eq('id', examId)
          .single();

      return response;
    } catch (e) {
      print('❌ Fehler beim Laden des Exams: $e');
      return null;
    }
  }

  /// Speichert eine Antwort
  Future<void> saveAnswer({
    required String userId,
    required int examId,
    required String questionId,
    required dynamic answer,
  }) async {
    try {
      await _supabase.from('user_exam_answers').upsert({
        'user_id': userId,
        'exam_id': examId,
        'question_id': questionId,
        'answer': answer,
        'answered_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('❌ Fehler beim Speichern der Antwort: $e');
    }
  }
}