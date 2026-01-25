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
        .select(
          'id, status, player1_id, player2_id, total_questions, created_at',
        )
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
          'idx, frage_id, fragen:frage_id(id, frage, question_type, calculation_data, antworten(id, text, ist_richtig))',
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

    // Lade Scores
    final scores = await c
        .from('match_scores')
        .select()
        .eq('match_id', matchId)
        .maybeSingle();

    if (scores == null) return null;

    // Lade Spieler-Profile separat
    final player1Profile = await c
        .from('profiles')
        .select('id, username, email')
        .eq('id', scores['player1_id'])
        .maybeSingle();

    final player2Profile = await c
        .from('profiles')
        .select('id, username, email')
        .eq('id', scores['player2_id'])
        .maybeSingle();

    final isPlayer1 = scores['player1_id'] == userId;

    return {
      'my_score': isPlayer1 ? scores['player1_score'] : scores['player2_score'],
      'opponent_score': isPlayer1
          ? scores['player2_score']
          : scores['player1_score'],
      'my_profile': isPlayer1 ? player1Profile : player2Profile,
      'opponent_profile': isPlayer1 ? player2Profile : player1Profile,
    };
  }

  /// Lädt die Rangliste (Top-Spieler nach Elo)
  Future<List<Map<String, dynamic>>> getLeaderboard({int limit = 50}) async {
    final result = await c
        .from('player_stats')
        .select()
        .order('elo_rating', ascending: false)
        .limit(limit);

    return List<Map<String, dynamic>>.from(result);
  }

  /// Lädt die eigenen Stats
  Future<Map<String, dynamic>?> getMyStats() async {
    final userId = c.auth.currentUser?.id;
    if (userId == null) return null;

    final result = await c
        .from('player_stats')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    return result;
  }

  /// Lädt alle offenen Matches (von anderen Spielern, nur wenn Ersteller fertig ist)
  Future<List<Map<String, dynamic>>> getOpenMatches() async {
    final userId = c.auth.currentUser?.id;
    if (userId == null) return [];

    // Matches laden (ohne Join)
    final matches = await c
        .from('matches')
        .select('id, status, player1_id, total_questions, created_at')
        .eq('status', 'open')
        .neq('player1_id', userId)
        .order('created_at', ascending: false)
        .limit(20);

    final allMatches = List<Map<String, dynamic>>.from(matches);
    final result = <Map<String, dynamic>>[];

    // Nur Matches wo Ersteller alle Fragen beantwortet hat
    for (var match in allMatches) {
      final matchId = match['id'] as String;
      final oderId = match['player1_id'] as String?;
      final totalQuestions = match['total_questions'] as int? ?? 10;

      if (oderId == null) continue;

      // Anzahl Antworten des Erstellers prüfen
      final answers = await c
          .from('match_answers')
          .select('idx')
          .eq('match_id', matchId)
          .eq('user_id', oderId);

      final answerCount = (answers as List).length;

      // Nur wenn alle Fragen beantwortet wurden
      if (answerCount >= totalQuestions) {
        // Profil laden
        final profile = await c
            .from('profiles')
            .select('id, username, avatar_url')
            .eq('id', oderId)
            .maybeSingle();
        match['creator'] = profile;
        result.add(match);
      }
    }

    return result;
  }

  /// Lädt die Scores für mehrere Matches
  Future<Map<String, Map<String, dynamic>>> getMatchScores(
    List<String> matchIds,
  ) async {
    if (matchIds.isEmpty) return {};

    final result = await c
        .from('match_scores')
        .select(
          'match_id, player1_id, player2_id, player1_score, player2_score',
        )
        .in_('match_id', matchIds);

    final Map<String, Map<String, dynamic>> scores = {};
    for (var row in result) {
      scores[row['match_id']] = row;
    }
    return scores;
  }

  /// Lädt gemeinsame Matches mit einem Spieler
  Future<List<Map<String, dynamic>>> getMatchesWithPlayer(String oderId) async {
    final userId = c.auth.currentUser?.id;
    if (userId == null) return [];

    final result = await c
        .from('matches')
        .select(
          'id, status, player1_id, player2_id, total_questions, created_at',
        )
        .or(
          'and(player1_id.eq.$userId,player2_id.eq.$oderId),and(player1_id.eq.$oderId,player2_id.eq.$userId)',
        )
        .order('created_at', ascending: false)
        .limit(10);

    return List<Map<String, dynamic>>.from(result);
  }
}
