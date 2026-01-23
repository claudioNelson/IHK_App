import 'package:supabase_flutter/supabase_flutter.dart';

class BadgeService {
  final _client = Supabase.instance.client;

  /// Lädt alle verfügbaren Badges
  Future<List<Map<String, dynamic>>> getAllBadges() async {
    final result = await _client
        .from('badges')
        .select()
        .order('sort_order');
    return List<Map<String, dynamic>>.from(result);
  }

  /// Lädt die Badges eines Users
  Future<List<Map<String, dynamic>>> getUserBadges(String oderId) async {
    final result = await _client
        .from('user_badges')
        .select('badge_id, earned_at, badges(*)')
        .eq('user_id', oderId)
        .order('earned_at', ascending: false);
    return List<Map<String, dynamic>>.from(result);
  }

  /// Lädt eigene Badges
  Future<List<Map<String, dynamic>>> getMyBadges() async {
    final oderId = _client.auth.currentUser?.id;
    if (oderId == null) return [];
    return getUserBadges(oderId);
  }

  /// Vergibt ein Badge an den aktuellen User
  Future<bool> awardBadge(String badgeId) async {
    final oderId = _client.auth.currentUser?.id;
    if (oderId == null) return false;

    try {
      await _client.from('user_badges').upsert({
        'user_id': oderId,
        'badge_id': badgeId,
      });
      print('🏆 Badge vergeben: $badgeId');
      return true;
    } catch (e) {
      print('❌ Badge-Fehler: $e');
      return false;
    }
  }

  /// Prüft und vergibt Match-Badges
  Future<List<String>> checkMatchBadges() async {
    final oderId = _client.auth.currentUser?.id;
    if (oderId == null) return [];

    final awarded = <String>[];

    // Stats laden
    final stats = await _client
        .from('player_stats')
        .select('wins, losses, elo_rating')
        .eq('user_id', oderId)
        .maybeSingle();

    if (stats == null) return [];

    final wins = stats['wins'] ?? 0;
    final total = wins + (stats['losses'] ?? 0);
    final elo = stats['elo_rating'] ?? 1000;

    // Bereits verdiente Badges laden
    final existing = await getMyBadges();
    final earnedIds = existing.map((b) => b['badge_id']).toSet();

    // Match Badges prüfen
    if (total >= 1 && !earnedIds.contains('match_first')) {
      if (await awardBadge('match_first')) awarded.add('match_first');
    }
    if (wins >= 1 && !earnedIds.contains('match_win_first')) {
      if (await awardBadge('match_win_first')) awarded.add('match_win_first');
    }
    if (wins >= 10 && !earnedIds.contains('match_win_10')) {
      if (await awardBadge('match_win_10')) awarded.add('match_win_10');
    }
    if (wins >= 50 && !earnedIds.contains('match_win_50')) {
      if (await awardBadge('match_win_50')) awarded.add('match_win_50');
    }

    // ELO Badges prüfen
    if (elo >= 1100 && !earnedIds.contains('elo_1100')) {
      if (await awardBadge('elo_1100')) awarded.add('elo_1100');
    }
    if (elo >= 1250 && !earnedIds.contains('elo_1250')) {
      if (await awardBadge('elo_1250')) awarded.add('elo_1250');
    }
    if (elo >= 1500 && !earnedIds.contains('elo_1500')) {
      if (await awardBadge('elo_1500')) awarded.add('elo_1500');
    }

    return awarded;
  }

  /// Prüft und vergibt Modul-Badges
  Future<List<String>> checkModuleBadges(int completedModules) async {
    final oderId = _client.auth.currentUser?.id;
    if (oderId == null) return [];

    final awarded = <String>[];
    final existing = await getMyBadges();
    final earnedIds = existing.map((b) => b['badge_id']).toSet();

    if (completedModules >= 1 && !earnedIds.contains('module_first')) {
      if (await awardBadge('module_first')) awarded.add('module_first');
    }
    if (completedModules >= 5 && !earnedIds.contains('module_5')) {
      if (await awardBadge('module_5')) awarded.add('module_5');
    }
    if (completedModules >= 10 && !earnedIds.contains('module_10')) {
      if (await awardBadge('module_10')) awarded.add('module_10');
    }
    if (completedModules >= 17 && !earnedIds.contains('module_all')) {
      if (await awardBadge('module_all')) awarded.add('module_all');
    }

    return awarded;
  }

  /// Prüft und vergibt Prüfungs-Badges
  Future<List<String>> checkExamBadges({required int passed, bool? scoreOver90}) async {
    final oderId = _client.auth.currentUser?.id;
    if (oderId == null) return [];

    final awarded = <String>[];
    final existing = await getMyBadges();
    final earnedIds = existing.map((b) => b['badge_id']).toSet();

    if (passed >= 1 && !earnedIds.contains('exam_first')) {
      if (await awardBadge('exam_first')) awarded.add('exam_first');
    }
    if (scoreOver90 == true && !earnedIds.contains('exam_perfect')) {
      if (await awardBadge('exam_perfect')) awarded.add('exam_perfect');
    }
    if (passed >= 5 && !earnedIds.contains('exam_all')) {
      if (await awardBadge('exam_all')) awarded.add('exam_all');
    }

    return awarded;
  }

  /// Prüft und vergibt Zertifikat-Badges
  Future<List<String>> checkCertificateBadges(List<String> earnedCerts) async {
    final oderId = _client.auth.currentUser?.id;
    if (oderId == null) return [];

    final awarded = <String>[];
    final existing = await getMyBadges();
    final earnedIds = existing.map((b) => b['badge_id']).toSet();

    if (earnedCerts.isNotEmpty && !earnedIds.contains('cert_first')) {
      if (await awardBadge('cert_first')) awarded.add('cert_first');
    }
    if (earnedCerts.contains('aws') && !earnedIds.contains('cert_aws')) {
      if (await awardBadge('cert_aws')) awarded.add('cert_aws');
    }
    if (earnedCerts.contains('azure') && !earnedIds.contains('cert_azure')) {
      if (await awardBadge('cert_azure')) awarded.add('cert_azure');
    }
    if (earnedCerts.contains('gcp') && !earnedIds.contains('cert_gcp')) {
      if (await awardBadge('cert_gcp')) awarded.add('cert_gcp');
    }
    if (earnedCerts.length >= 3 && !earnedIds.contains('cert_multi')) {
      if (await awardBadge('cert_multi')) awarded.add('cert_multi');
    }

    return awarded;
  }
}