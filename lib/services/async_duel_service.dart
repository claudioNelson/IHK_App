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
    final id = await c.rpc('join_random_open_match');

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

  /// Platzhalter-Antwort-Id fuer Sonderfragen, Pseudo-Antworten und
  /// Zeitablauf (antwort_id ist NOT NULL mit FK -> muss existieren).
  /// Ob die Antwort richtig war, entscheidet in diesen Faellen [isCorrect],
  /// nicht die Tabelle antworten (Migration 20260905010000).
  static const int sentinelAnswerId = 1;

  /// [isCorrect] == null: Server schlaegt ist_richtig in `antworten` nach
  /// (echte Multiple-Choice-Antwort). Sonst wird der Wert uebernommen.
  Future<bool> submitAnswer({
    required String matchId,
    required int idx,
    required int answerId,
    bool? isCorrect,
  }) async {
    final done = await c.rpc(
      'submit_async_answer',
      params: {
        'p_match': matchId,
        'p_idx': idx,
        'p_antwort_id': answerId,
        if (isCorrect != null) 'p_is_correct': isCorrect,
      },
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
          'idx, frage_id, fragen:frage_id(id, frage, question_type, calculation_data, erklaerung, antworten(id, text, ist_richtig))',
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

  /// Zwischenstand fuer den Wartebildschirm ("Status pruefen"):
  /// eigener Score, ob ein Gegner da ist und wie weit er ist, beide Profile.
  /// Nur Lesen ueber bestehende Tabellen (matches, match_answers, profiles).
  Future<Map<String, dynamic>?> loadWaitingStatus(String matchId) async {
    final myId = c.auth.currentUser?.id;
    if (myId == null) return null;

    final match = await c
        .from('matches')
        .select('player1_id, player2_id, total_questions, status')
        .eq('id', matchId)
        .maybeSingle();
    if (match == null) return null;

    final total = match['total_questions'] as int? ?? 10;
    final p1 = match['player1_id'] as String?;
    final p2 = match['player2_id'] as String?;
    final opponentId = (p1 == myId) ? p2 : p1;

    // Die vier Abfragen sind unabhaengig -> parallel (spart auf Mobilfunk ~1 s)
    final results = await Future.wait<dynamic>([
      c.from('match_answers').select('is_correct').eq('match_id', matchId).eq('user_id', myId),
      opponentId == null
          ? Future.value(<dynamic>[])
          : c.from('match_answers').select('is_correct').eq('match_id', matchId).eq('user_id', opponentId),
      c.from('profiles').select('id, username, avatar_url').eq('id', myId).maybeSingle(),
      opponentId == null
          ? Future.value(null)
          : c.from('profiles').select('id, username, avatar_url').eq('id', opponentId).maybeSingle(),
    ]);

    final List myAnswers = results[0];
    final myCorrect = myAnswers.where((a) => a['is_correct'] == true).length;
    final List opponentAnswers = results[1];
    final opponentCorrect =
        opponentAnswers.where((a) => a['is_correct'] == true).length;
    final myProfile = results[2] as Map<String, dynamic>?;
    final opponentProfile = results[3] as Map<String, dynamic>?;

    return {
      'total': total,
      'my_correct': myCorrect,
      'my_answered': myAnswers.length,
      'my_profile': myProfile,
      'has_opponent': opponentId != null,
      'opponent_correct': opponentCorrect,
      'opponent_answered': opponentAnswers.length,
      'opponent_profile': opponentProfile,
    };
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

    // Lade Spieler-Profile separat (player2 kann bei abgebrochenen Matches
    // fehlen -> .eq('id', null) wuerde einen PostgREST-Fehler werfen)
    final p1Id = scores['player1_id'] as String?;
    final p2Id = scores['player2_id'] as String?;
    Future<Map<String, dynamic>?> profil(String? id) async {
      if (id == null) return null;
      return await c
          .from('profiles')
          .select('id, username, email, avatar_url')
          .eq('id', id)
          .maybeSingle();
    }

    final profiles = await Future.wait([profil(p1Id), profil(p2Id)]);
    final player1Profile = profiles[0];
    final player2Profile = profiles[1];

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

    final list = List<Map<String, dynamic>>.from(result);
    if (list.isEmpty) return list;

    // Premium-Status für alle User in einem Query laden
    final userIds = list.map((p) => p['user_id'] as String).toList();
    final profiles = await c
        .from('profiles')
        .select('id, is_premium, premium_tier')
        .inFilter('id', userIds);

    // Map für schnelles Lookup
    final premiumMap = <String, Map<String, dynamic>>{};
    for (final p in profiles) {
      premiumMap[p['id'] as String] = p as Map<String, dynamic>;
    }

    // Premium-Daten ins Hauptobjekt mergen
    for (final player in list) {
      final userId = player['user_id'] as String;
      final profile = premiumMap[userId];
      player['is_premium'] = profile?['is_premium'] ?? false;
      player['premium_tier'] = profile?['premium_tier'];
    }

    return list;
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

  /// Laedt Profile (id, username, avatar_url) fuer mehrere User in einer Abfrage.
  Future<Map<String, Map<String, dynamic>>> getProfiles(List<String> userIds) async {
    final ids = userIds.toSet().toList();
    if (ids.isEmpty) return {};
    final rows = await c
        .from('profiles')
        .select('id, username, avatar_url')
        .inFilter('id', ids);
    final map = <String, Map<String, dynamic>>{};
    for (final r in rows) {
      map[r['id'] as String] = Map<String, dynamic>.from(r as Map);
    }
    return map;
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
        .inFilter('match_id', matchIds);

    final Map<String, Map<String, dynamic>> scores = {};
    for (var row in result) {
      scores[row['match_id']] = row;
    }
    return scores;
  }

  /// Lädt für mehrere Matches, wie viele Fragen ICH schon beantwortet habe.
  /// Returns: { matchId: anzahlAntworten }
  Future<Map<String, int>> getMyAnswerCounts(List<String> matchIds) async {
    if (matchIds.isEmpty) return {};
    final userId = c.auth.currentUser?.id;
    if (userId == null) return {};

    final result = await c
        .from('match_answers')
        .select('match_id')
        .eq('user_id', userId)
        .inFilter('match_id', matchIds);

    final Map<String, int> counts = {};
    for (final row in result) {
      final mid = row['match_id'] as String;
      counts[mid] = (counts[mid] ?? 0) + 1;
    }
    return counts;
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
