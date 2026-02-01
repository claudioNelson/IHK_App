import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'async_duel_service.dart';
import 'badge_service.dart';

class AppCacheService {
  static final AppCacheService _instance = AppCacheService._internal();
  factory AppCacheService() => _instance;
  AppCacheService._internal();

  final supabase = Supabase.instance.client;
  final _duelSvc = AsyncDuelService();
  final _badgeSvc = BadgeService();

  // MODULE CACHE
  List<dynamic> cachedModule = [];
  Map<int, int> cachedAnzahlFragen = {};
  Map<int, int> cachedBeantworteteFragen = {};
  Map<int, int> cachedLetzteThemaId = {};
  bool modulesLoaded = false;

  // ZERTIFIKATE CACHE
  List<dynamic> cachedZertifikate = [];
  Map<int, Map<String, dynamic>> cachedUserResults = {};
  bool certificatesLoaded = false;

  // MATCHES CACHE
  List<Map<String, dynamic>> cachedActiveMatches = [];
  List<Map<String, dynamic>> cachedHistoryMatches = [];
  Map<String, dynamic>? cachedMyStats;
  Map<String, Map<String, dynamic>> cachedMatchScores = {};
  bool matchesLoaded = false;

  // PROFIL CACHE
  Map<String, dynamic>? cachedMyProfile;
  List<Map<String, dynamic>> cachedMyBadges = [];
  bool profileLoaded = false;

  Future<void> preloadAllData() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      await Future.wait([
        _preloadModules(),
        _preloadZertifikate(userId),
        _preloadMatches(userId),
        _preloadProfile(userId),
      ]);
    } catch (e) {
      print('❌ Fehler beim Vorladen: $e');
    }
  }

  Future<void> _preloadModules() async {
    try {
      final response = await supabase.from('module').select().order('id');
      final alleFragen = await supabase.from('fragen').select('id, modul_id');

      final Map<int, int> fragenCount = {};
      for (var frage in alleFragen) {
        final modulId = frage['modul_id'];
        if (modulId != null && modulId is int) {
          fragenCount[modulId] = (fragenCount[modulId] ?? 0) + 1;
        }
      }

      final prefs = await SharedPreferences.getInstance();

      for (var modul in response) {
        final modulId = modul['id'];
        if (modulId == null || modulId is! int) continue;

        cachedAnzahlFragen[modulId] = fragenCount[modulId] ?? 0;
        cachedBeantworteteFragen[modulId] =
            prefs.getStringList('fortschritt_modul_$modulId')?.length ?? 0;
        cachedLetzteThemaId[modulId] =
            prefs.getInt('letztes_thema_modul_$modulId') ?? 0;
      }

      cachedModule = response;
      modulesLoaded = true;
    } catch (e) {
      print('❌ Fehler Module: $e');
    }
  }

  Future<void> _preloadZertifikate(String userId) async {
    try {
      final data = await supabase
          .from('zertifikate')
          .select()
          .order('anbieter, name');

      final results = await supabase
          .from('user_certificates')
          .select()
          .eq('user_id', userId);

      final Map<int, Map<String, dynamic>> userResultsMap = {};
      for (var r in results) {
        userResultsMap[r['zertifikat_id']] = r;
      }

      cachedZertifikate = data;
      cachedUserResults = userResultsMap;
      certificatesLoaded = true;
    } catch (e) {
      print('❌ Fehler Zertifikate: $e');
    }
  }

  Future<void> _preloadMatches(String userId) async {
    try {
      final matches = await _duelSvc.getMyMatches();
      final stats = await _duelSvc.getMyStats();

      final active = <Map<String, dynamic>>[];
      final history = <Map<String, dynamic>>[];

      for (var match in matches) {
        final status = match['status'] as String;
        if (status == 'completed' ||
            status == 'finalized' ||
            status == 'finished') {
          history.add(match);
        } else {
          active.add(match);
        }
      }

      final historyIds = history.map((m) => m['id'] as String).toList();
      final scores = await _duelSvc.getMatchScores(historyIds);

      cachedActiveMatches = active;
      cachedHistoryMatches = history;
      cachedMyStats = stats;
      cachedMatchScores = scores;
      matchesLoaded = true;
    } catch (e) {
      print('❌ Fehler Matches: $e');
    }
  }

  Future<void> _preloadProfile(String userId) async {
    try {
      final profile = await supabase
          .from('profiles')
          .select('id, username, avatar_url, created_at')
          .eq('id', userId)
          .maybeSingle();

      final stats = await supabase
          .from('player_stats')
          .select('elo_rating, wins, losses')
          .eq('user_id', userId)
          .maybeSingle();

      final badges = await _badgeSvc.getUserBadges(userId);

      cachedMyProfile = profile;
      cachedMyStats = stats;
      cachedMyBadges = badges;
      profileLoaded = true;
    } catch (e) {
      print('❌ Fehler Profil: $e');
    }
  }
}