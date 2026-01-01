import 'package:supabase_flutter/supabase_flutter.dart';

class AsyncDuelService {
  final c = Supabase.instance.client;

  Future<String> createMatch({int count = 10}) async {
    final id = await c.rpc(
      'create_async_match_any',
      params: {'p_count': count},
    );
    return id as String;
  }

Future<String?> joinRandomMatch() async {
  print('🔵 joinRandomMatch aufgerufen');
  print('🔵 User ID: ${c.auth.currentUser?.id}');
  
  final id = await c.rpc('join_random_open_match');
  
  print('🔵 Ergebnis: $id');
  
  return id == null ? null : id as String;
}

/// Lädt alle Matches wo der User beteiligt ist
Future<List<Map<String, dynamic>>> getMyMatches() async {
  final userId = c.auth.currentUser?.id;
  if (userId == null) return [];

  final result = await c
      .from('matches')
      .select('id, status, player1_id, player2_id, total_questions, created_at')
      .or('player1_id.eq.$userId,player2_id.eq.$userId')
      .order('created_at', ascending: false)
      .limit(10);

  return List<Map<String, dynamic>>.from(result);
}

  Future<bool> submitAnswer({
    required String matchId,
    required int idx,
    required int answerId,
  }) async {
    final done = await c.rpc(
      'submit_async_answer',
      params: {'p_match': matchId, 'p_idx': idx, 'p_antwort_id': answerId},
    );
    return (done as bool? ?? false);
  }

  Future<String> tryFinalize(String matchId) async {
    final status = await c.rpc(
      'try_finalize_match',
      params: {'p_match': matchId},
    );
    return status as String;
  }

  Future<Map<String, dynamic>> loadMatch(String matchId) async {
    final q = await c
        .from('match_questions')
        .select(
          'idx, frage_id, fragen:frage_id(id, frage, antworten(id, text, ist_richtig))',
        )
        .eq('match_id', matchId)
        .order('idx');

    final myId = c.auth.currentUser?.id;
    final myAnswers = (myId == null)
        ? <dynamic>[]
        : await c
              .from('match_answers')
              .select('idx, antwort_id, is_correct')
              .eq('match_id', matchId)
              .eq('user_id', myId);

    return {'questions': q, 'myAnswers': myAnswers};
  }

Future<Map<String, dynamic>?> loadScores(String matchId) async {
  final userId = c.auth.currentUser?.id;
  
  final rows = await c
      .from('match_scores')
      .select()
      .eq('match_id', matchId)
      .maybeSingle();

  if (rows == null) return null;

  // Bestimme wer "ich" und wer "Gegner" ist
  final isPlayer1 = rows['player1_id'] == userId;
  
  return {
    'my_score': isPlayer1 ? rows['player1_score'] : rows['player2_score'],
    'opponent_score': isPlayer1 ? rows['player2_score'] : rows['player1_score'],
    'user_id': userId,
    'opponent_id': isPlayer1 ? rows['player2_id'] : rows['player1_id'],
  };
}
}