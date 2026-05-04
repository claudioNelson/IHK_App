import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'async_duel_service.dart';
import 'badge_service.dart';
import 'progress_service.dart';

class AppCacheService {
  static final AppCacheService _instance = AppCacheService._internal();
  factory AppCacheService() => _instance;
  AppCacheService._internal();
  final _client = Supabase.instance.client;

  final supabase = Supabase.instance.client;
  final _duelSvc = AsyncDuelService();
  final _badgeSvc = BadgeService();

  // MODULE CACHE
  List<dynamic> cachedModule = [];
  Map<int, int> cachedAnzahlFragen = {};
  Map<int, int> cachedBeantworteteFragen = {};
  Map<int, int> cachedLetzteThemaId = {};
  bool modulesLoaded = false;

  // ========== THEMEN CACHE ==========
  Map<int, List<dynamic>> cachedThemen = {}; // Key = modulId
  Map<int, Map<int, double>> cachedThemenScores = {}; // Key = modulId
  Map<int, Map<int, int>> cachedFragenCount = {}; // Key = modulId
  Map<int, bool> themenLoaded = {}; // Key = modulId

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

  // KERNTHEMEN CACHE
  List<dynamic> cachedKernthemen = [];
  Map<int, Map<String, dynamic>> cachedKernthemenProgress = {};
  bool kernthemenLoaded = false;

  // LEVELS CACHE
  /// Modul-Liste: [{id, name, total_levels, basics_levels, completed}, ...]
  List<Map<String, dynamic>> cachedLevelModule = [];
  bool levelModuleLoaded = false;

  /// Pro Modul: alle Level-Rohdaten (so wie aus DB) gemerged mit Progress
  Map<int, List<Map<String, dynamic>>> cachedLevelsForModul = {};
  Map<int, bool> levelsForModulLoaded = {};

  // ADA CHAT CACHE
  Map<String, List<ChatMessageCache>> cachedAdaChats = {};
  DateTime? lastAdaChatClear;

  Future<void> preloadAllData() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      await Future.wait([
        _preloadModules(),
        _preloadZertifikate(userId),
        _preloadMatches(userId),
        _preloadProfile(userId),
        preloadKernthemen(),
        preloadLevelModule(),
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

  /// Lädt Themen für ein bestimmtes Modul
  Future<void> preloadThemen(int modulId) async {
    if (themenLoaded[modulId] == true) return; // Schon geladen

    try {
      print('📖 Lade Themen für Modul $modulId...');

      final themen = await supabase
          .from('themen')
          .select(
            'id, name, beschreibung, sort_index, required_score, unlocked_by, schwierigkeitsgrad',
          )
          .eq('module_id', modulId)
          .order('sort_index, id');

      // Fragen-Count
      final alleFragen = await supabase
          .from('fragen')
          .select('id, thema_id')
          .eq('modul_id', modulId);

      final Map<int, int> fragenCount = {};
      for (final frage in alleFragen) {
        final themaId = frage['thema_id'] as int;
        fragenCount[themaId] = (fragenCount[themaId] ?? 0) + 1;
      }

      cachedThemen[modulId] = themen;
      cachedFragenCount[modulId] = fragenCount;
      themenLoaded[modulId] = true;

      print('✅ Themen geladen: ${themen.length}');
    } catch (e) {
      print('❌ Fehler Themen: $e');
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

  // ========== ADA CHAT CACHE ==========

  /// Chat-Verlauf für eine Frage speichern
  void saveAdaChat(String key, List<dynamic> messages) {
    cachedAdaChats[key] = messages
        .map(
          (m) => ChatMessageCache(
            text: m.text as String,
            isUser: m.isUser as bool,
            timestamp: m.timestamp as DateTime,
          ),
        )
        .toList();
  }

  /// Chat-Verlauf für eine Frage laden
  List<ChatMessageCache>? getAdaChat(String key) {
    return cachedAdaChats[key];
  }

  /// Alte Chats löschen (älter als 1 Stunde)
  void clearOldAdaChats() {
    final now = DateTime.now();

    // Nur alle 30 Minuten aufräumen
    if (lastAdaChatClear != null &&
        now.difference(lastAdaChatClear!).inMinutes < 30) {
      return;
    }

    cachedAdaChats.removeWhere((key, messages) {
      if (messages.isEmpty) return true;
      final lastMessage = messages.last.timestamp;
      return now.difference(lastMessage).inHours > 1;
    });

    lastAdaChatClear = now;
    print('🧹 Ada Chat Cache aufgeräumt');
  }

  /// Alle Ada Chats löschen
  void clearAllAdaChats() {
    cachedAdaChats.clear();
    print('🗑️ Alle Ada Chats gelöscht');
  }

  // Nur Progress neu laden (Module aus Cache), alle Module parallel
  Future<void> refreshKernthemenProgress() async {
    if (!kernthemenLoaded || cachedKernthemen.isEmpty) {
      await preloadKernthemen();
      return;
    }

    try {
      final progressSvc = ProgressService();
      final results = await Future.wait(
        cachedKernthemen.map((module) async {
          final moduleId = module['id'] as int;
          final progress = await progressSvc.getKernthemaProgress(moduleId);
          return MapEntry(moduleId, progress);
        }),
      );

      final progressMap = <int, Map<String, dynamic>>{};
      for (final entry in results) {
        progressMap[entry.key] = entry.value;
      }
      cachedKernthemenProgress = progressMap;
    } catch (e) {
      print('❌ Fehler Progress Refresh: $e');
    }
  }

  // Lädt Kernthemen mit Progress
  Future<void> preloadKernthemen() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return;

      print('📖 Lade Kernthemen...');

      // Module laden
      final modules = await _client
          .from('module')
          .select('id, name, beschreibung')
          .eq('kategorie', 'kernthema')
          .order('id');

      // Progress für alle Module laden
      final progressMap = <int, Map<String, dynamic>>{};
      final progressSvc = ProgressService();

      for (var module in modules) {
        final moduleId = module['id'] as int;
        final progress = await progressSvc.getKernthemaProgress(moduleId);
        progressMap[moduleId] = progress;
      }

      cachedKernthemen = modules;
      cachedKernthemenProgress = progressMap;
      kernthemenLoaded = true;

      print('✅ Kernthemen geladen: ${modules.length}');
      print('📊 Progress geladen für IDs: ${progressMap.keys.toList()}');
    } catch (e) {
      print('❌ Fehler Kernthemen: $e');
    }
  }

  // ========== LEVELS CACHE ==========

  /// Modul-Liste für den Level-Bereich (Übersicht).
  /// Liste der Module, die mind. 1 Level haben — inkl. Progress.
  Future<void> preloadLevelModule() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return;

      print('📖 Lade Level-Module...');

      // 1. Distinct modul_ids aus levels-Tabelle + Tier-Counts
      final levelRes = await _client
          .from('levels')
          .select('id, modul_id, tier, schwelle');

      final modulCounts = <int, Map<String, int>>{};
      final levelToModul = <int, int>{};
      final levelToSchwelle = <int, int>{};

      for (final row in levelRes as List) {
        final mid = row['modul_id'] as int;
        final tier = row['tier'] as String? ?? 'basics';
        final lid = row['id'] as int;
        final schwelle = row['schwelle'] as int;
        levelToModul[lid] = mid;
        levelToSchwelle[lid] = schwelle;
        modulCounts.putIfAbsent(mid, () => {'total': 0, 'basics': 0});
        modulCounts[mid]!['total'] = modulCounts[mid]!['total']! + 1;
        if (tier == 'basics') {
          modulCounts[mid]!['basics'] = modulCounts[mid]!['basics']! + 1;
        }
      }

      if (modulCounts.isEmpty) {
        cachedLevelModule = [];
        levelModuleLoaded = true;
        return;
      }

      // 2. Modul-Namen
      final ids = modulCounts.keys.toList();
      final modulRes = await _client
          .from('module')
          .select('id, name')
          .filter('id', 'in', '(${ids.join(',')})');

      // 3. Completed-Counter pro Modul
      final completedPerModul = <int, int>{};
      if (levelToModul.isNotEmpty) {
        final progressRes = await _client
            .from('level_progress')
            .select('level_id, best_score')
            .eq('user_id', userId)
            .filter('level_id', 'in', '(${levelToModul.keys.join(',')})');

        for (final p in progressRes as List) {
          final lid = p['level_id'] as int;
          final score = p['best_score'] as int;
          final schwelle = levelToSchwelle[lid] ?? 100;
          if (score >= schwelle) {
            final mid = levelToModul[lid]!;
            completedPerModul[mid] = (completedPerModul[mid] ?? 0) + 1;
          }
        }
      }

      // 4. Mergen
      final list = <Map<String, dynamic>>[];
      for (final m in modulRes as List) {
        final id = m['id'] as int;
        final counts = modulCounts[id]!;
        list.add({
          'id': id,
          'name': m['name'] as String,
          'total_levels': counts['total']!,
          'basics_levels': counts['basics']!,
          'completed': completedPerModul[id] ?? 0,
        });
      }
      list.sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));

      cachedLevelModule = list;
      levelModuleLoaded = true;

      print('✅ Level-Module geladen: ${list.length}');
    } catch (e) {
      print('❌ Fehler Level-Module: $e');
    }
  }

  /// Levels eines bestimmten Moduls inkl. Progress laden.
  Future<void> preloadLevelsForModul(int modulId) async {
    if (levelsForModulLoaded[modulId] == true) return;

    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return;

      print('📖 Lade Levels für Modul $modulId...');

      // 1. Levels
      final levelsRes = await _client
          .from('levels')
          .select()
          .eq('modul_id', modulId)
          .order('nummer');

      final levelRows = List<Map<String, dynamic>>.from(levelsRes as List);
      if (levelRows.isEmpty) {
        cachedLevelsForModul[modulId] = [];
        levelsForModulLoaded[modulId] = true;
        return;
      }

      // 2. User-Progress
      final levelIds = levelRows.map((l) => l['id']).toList();
      final progressRes = await _client
          .from('level_progress')
          .select()
          .eq('user_id', userId)
          .filter('level_id', 'in', '(${levelIds.join(',')})');

      final progressMap = <int, Map<String, dynamic>>{};
      for (final row in progressRes as List) {
        progressMap[row['level_id'] as int] = row as Map<String, dynamic>;
      }

      // 3. Merge: Progress in jede Level-Row mergen
      for (final row in levelRows) {
        final lid = row['id'] as int;
        if (progressMap.containsKey(lid)) {
          row['_progress'] = progressMap[lid];
        }
      }

      cachedLevelsForModul[modulId] = levelRows;
      levelsForModulLoaded[modulId] = true;

      print('✅ Levels für Modul $modulId: ${levelRows.length}');
    } catch (e) {
      print('❌ Fehler Levels für Modul $modulId: $e');
    }
  }

  /// Cache invalidieren (z.B. nach Level abschließen)
  void invalidateLevelModul(int modulId) {
    levelsForModulLoaded[modulId] = false;
    cachedLevelsForModul.remove(modulId);
    levelModuleLoaded = false;
    cachedLevelModule = [];
  }
}

// ChatMessageCache Klasse AUSSERHALB von AppCacheService
class ChatMessageCache {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessageCache({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
