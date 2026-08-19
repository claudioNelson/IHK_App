// lib/services/badge_service.dart
//
// Badges laden und vergeben.
//
// Überarbeitet 08/2026:
// - Die achtfach kopierte Lade-Prüf-Vergib-Logik steckt jetzt einmal in
//   _pruefeUndVergebe(). Neue Badge-Gruppen sind damit drei Zeilen.
// - Upsert mit ignoreDuplicates: das ursprüngliche earned_at bleibt
//   erhalten, wenn ein Badge doppelt vergeben würde.
// - debugPrint statt print (nichts loggt mehr im Release-Build).
// - Neu: Kurs-Badges (checkKursBadges) und getBadgeDetails() für den
//   Feier-Dialog.
//
// Die öffentlichen Methoden und ihre Signaturen sind unverändert,
// bestehende Aufrufer brauchen keine Anpassung.

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BadgeService {
  final _client = Supabase.instance.client;

  String? get _userId => _client.auth.currentUser?.id;

  // ─── Laden ──────────────────────────────────────────────────────────

  /// Alle verfügbaren Badges (für die Übersichtsseite).
  Future<List<Map<String, dynamic>>> getAllBadges() async {
    final result = await _client.from('badges').select().order('sort_order');
    return List<Map<String, dynamic>>.from(result);
  }

  /// Badges eines bestimmten Users.
  Future<List<Map<String, dynamic>>> getUserBadges(String userId) async {
    final result = await _client
        .from('user_badges')
        .select('badge_id, earned_at, badges(*)')
        .eq('user_id', userId)
        .order('earned_at', ascending: false);
    return List<Map<String, dynamic>>.from(result);
  }

  /// Eigene Badges.
  Future<List<Map<String, dynamic>>> getMyBadges() async {
    final userId = _userId;
    if (userId == null) return [];
    return getUserBadges(userId);
  }

  /// Details (Name, Icon, Beschreibung) zu einer Liste von Badge-IDs,
  /// z. B. für den BadgeCelebrationDialog.
  Future<List<Map<String, dynamic>>> getBadgeDetails(
    List<String> badgeIds,
  ) async {
    if (badgeIds.isEmpty) return [];
    final result = await _client
        .from('badges')
        .select()
        .inFilter('id', badgeIds);
    return List<Map<String, dynamic>>.from(result);
  }

  // ─── Vergeben ───────────────────────────────────────────────────────

  /// Vergibt ein Badge an den aktuellen User.
  /// ignoreDuplicates: ein bereits vergebenes Badge behält sein
  /// ursprüngliches earned_at, statt es zu überschreiben.
  Future<bool> awardBadge(String badgeId) async {
    final userId = _userId;
    if (userId == null) return false;

    try {
      await _client.from('user_badges').upsert(
        {'user_id': userId, 'badge_id': badgeId},
        onConflict: 'user_id,badge_id',
        ignoreDuplicates: true,
      );
      debugPrint('🏆 Badge vergeben: $badgeId');
      return true;
    } catch (e) {
      debugPrint('❌ Badge-Fehler ($badgeId): $e');
      return false;
    }
  }

  /// Kern der Vergabe: prüft eine Menge von Bedingungen gegen die schon
  /// verdienten Badges und vergibt alles Neue.
  ///
  /// [bedingungen] bildet Badge-ID auf "verdient ja/nein" ab.
  /// Zurück kommen die IDs der NEU vergebenen Badges.
  Future<List<String>> _pruefeUndVergebe(
    Map<String, bool> bedingungen,
  ) async {
    if (_userId == null) return [];

    final vorhandene = await getMyBadges();
    final schonVerdient = vorhandene.map((b) => b['badge_id']).toSet();

    final neu = <String>[];
    for (final eintrag in bedingungen.entries) {
      if (!eintrag.value) continue;
      if (schonVerdient.contains(eintrag.key)) continue;
      if (await awardBadge(eintrag.key)) neu.add(eintrag.key);
    }
    return neu;
  }

  // ─── Badge-Gruppen ──────────────────────────────────────────────────

  /// Match-Badges (Duelle): Teilnahme, Siege, Elo.
  Future<List<String>> checkMatchBadges() async {
    final userId = _userId;
    if (userId == null) return [];

    final stats = await _client
        .from('player_stats')
        .select('wins, losses, elo_rating')
        .eq('user_id', userId)
        .maybeSingle();
    if (stats == null) return [];

    final wins = (stats['wins'] ?? 0) as int;
    final total = wins + ((stats['losses'] ?? 0) as int);
    final elo = (stats['elo_rating'] ?? 1000) as int;

    return _pruefeUndVergebe({
      'match_first': total >= 1,
      'match_win_first': wins >= 1,
      'match_win_10': wins >= 10,
      'match_win_50': wins >= 50,
      'elo_1100': elo >= 1100,
      'elo_1250': elo >= 1250,
      'elo_1500': elo >= 1500,
    });
  }

  /// Modul-Badges (freies Üben).
  Future<List<String>> checkModuleBadges(int completedModules) {
    return _pruefeUndVergebe({
      'module_first': completedModules >= 1,
      'module_5': completedModules >= 5,
      'module_10': completedModules >= 10,
      'module_all': completedModules >= 17,
    });
  }

  /// Prüfungs-Badges (IHK-Simulationen).
  Future<List<String>> checkExamBadges({
    required int passed,
    bool? scoreOver90,
  }) {
    return _pruefeUndVergebe({
      'exam_first': passed >= 1,
      'exam_perfect': scoreOver90 == true,
      'exam_all': passed >= 5,
    });
  }

  /// Zertifikat-Badges (AWS/Azure/GCP-Übungen).
  Future<List<String>> checkCertificateBadges(List<String> earnedCerts) {
    return _pruefeUndVergebe({
      'cert_first': earnedCerts.isNotEmpty,
      'cert_aws': earnedCerts.contains('aws'),
      'cert_azure': earnedCerts.contains('azure'),
      'cert_gcp': earnedCerts.contains('gcp'),
      'cert_multi': earnedCerts.length >= 3,
    });
  }

  /// Kurs-Badges (SQL-Kurs, später auch Python auf denselben Stufen).
  ///
  /// [kursSlug] ist z. B. 'sql'. Die Badge-IDs heißen
  /// kurs_<slug>_start / _haelfte / _meister und müssen in der
  /// badges-Tabelle existieren.
  Future<List<String>> checkKursBadges({
    required String kursSlug,
    required int abgeschlosseneLektionen,
    required int lektionenGesamt,
  }) {
    final haelfte = (lektionenGesamt / 2).ceil();
    return _pruefeUndVergebe({
      'kurs_${kursSlug}_start': abgeschlosseneLektionen >= 1,
      'kurs_${kursSlug}_haelfte': abgeschlosseneLektionen >= haelfte,
      'kurs_${kursSlug}_meister':
          lektionenGesamt > 0 && abgeschlosseneLektionen >= lektionenGesamt,
    });
  }
}
