import 'package:supabase_flutter/supabase_flutter.dart';

class AsyncDuelService {
  final c = Supabase.instance.client;

  Future<String> createMatch({int count = 10, int? moduleId, int? themaId}) async {
    final id = await c.rpc('create_async_match', params: {
      'p_count': count,
      'p_module_id': moduleId,
      'p_thema_id': themaId, // <- stimmt mit der SQL-Funktion überein
    });
    return id as String;
  }

  Future<String?> joinRandomMatch() async {
    final id = await c.rpc('join_random_open_match');
    return id == null ? null : id as String;
  }

  Future<bool> submitAnswer({
    required String matchId,
    required int idx,
    required int answerId,
  }) async {
    final done = await c.rpc('submit_async_answer', params: {
      'p_match': matchId,
      'p_idx': idx,
      'p_antwort_id': answerId,
    });
    return (done as bool? ?? false);
  }

  Future<String> tryFinalize(String matchId) async {
    final status = await c.rpc('try_finalize_match', params: {'p_match': matchId});
    return status as String;
  }

  Future<Map<String, dynamic>> loadMatch(String matchId) async {
    final match = await c.from('matches').select().eq('id', matchId).single();
    final q = await c
        .from('match_questions')
        .select('idx, frage_id, fragen:frage_id(id, frage, antworten(id, text, ist_richtig))')
        .eq('match_id', matchId)
        .order('idx');
    final my = c.auth.currentUser!.id;
    final myAnswers = await c
        .from('match_answers')
        .select('idx, antwort_id, is_correct')
        .eq('match_id', matchId)
        .eq('user_id', my);
    return {'match': match, 'questions': q, 'myAnswers': myAnswers};
  }

  Future<Map<String, dynamic>?> loadScores(String matchId) async {
    final rows = await c.from('match_scores').select().eq('match_id', matchId).maybeSingle();
    return rows;
  }
}
