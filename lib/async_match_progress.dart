import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Repräsentiert den Fortschritt eines einzelnen AsyncMatch-Spiels
class AsyncMatchProgress {
  final String userId;
  final String matchId;
  int currentIdx; // Aktuelle Fragenposition (0-basiert)
  final Map<int, int> answers; // idx -> answerId (gegebene Antworten)
  final DateTime startedAt;
  DateTime? lastUpdated; // Für Sync/Tracking

  AsyncMatchProgress({
    required this.userId,
    required this.matchId,
    required this.currentIdx,
    required this.answers,
    required this.startedAt,
    this.lastUpdated,
  });

  /// Serialisierung zu JSON
  Map<String, dynamic> toJson() => {
        'userId': userId,
        'matchId': matchId,
        'currentIdx': currentIdx,
        'answers': answers.map((k, v) => MapEntry(k.toString(), v)),
        'startedAt': startedAt.toIso8601String(),
        'lastUpdated': lastUpdated?.toIso8601String(),
      };

  /// Deserialisierung von JSON
  factory AsyncMatchProgress.fromJson(Map<String, dynamic> json) {
    try {
      final rawAnswers = (json['answers'] as Map?) ?? {};
      final parsedAnswers = <int, int>{};

      for (final entry in rawAnswers.entries) {
        final key = int.parse(entry.key.toString());
        final value = (entry.value as num).toInt();
        parsedAnswers[key] = value;
      }

      return AsyncMatchProgress(
        userId: json['userId'] as String,
        matchId: json['matchId'] as String,
        currentIdx: (json['currentIdx'] as num).toInt(),
        answers: parsedAnswers,
        startedAt: DateTime.parse(json['startedAt'] as String),
        lastUpdated: json['lastUpdated'] != null
            ? DateTime.parse(json['lastUpdated'] as String)
            : null,
      );
    } catch (e) {
      throw FormatException('Fehler beim Parsen von AsyncMatchProgress: $e');
    }
  }

  /// Prüft ob alle Fragen beantwortet wurden
  bool isComplete(int totalQuestions) {
    return answers.length >= totalQuestions;
  }

  /// Gibt Fortschritt in Prozent zurück
  double progressPercent(int totalQuestions) {
    if (totalQuestions == 0) return 0.0;
    return (answers.length / totalQuestions * 100).clamp(0.0, 100.0);
  }

  /// Kopiert das Objekt mit geänderten Werten
  AsyncMatchProgress copyWith({
    int? currentIdx,
    Map<int, int>? answers,
    DateTime? lastUpdated,
  }) {
    return AsyncMatchProgress(
      userId: userId,
      matchId: matchId,
      currentIdx: currentIdx ?? this.currentIdx,
      answers: answers ?? Map.from(this.answers),
      startedAt: startedAt,
      lastUpdated: lastUpdated ?? DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'AsyncMatchProgress(match: ${matchId.substring(0, 8)}, '
        'idx: $currentIdx, answers: ${answers.length})';
  }
}

/// Verwaltet die Persistenz von AsyncMatchProgress in SharedPreferences
class AsyncMatchProgressStore {
  final SharedPreferences _prefs;

  AsyncMatchProgressStore(this._prefs);

  /// Singleton Instance
  static AsyncMatchProgressStore? _instance;

  static Future<AsyncMatchProgressStore> get instance async {
    if (_instance != null) return _instance!;

    final prefs = await SharedPreferences.getInstance();
    _instance = AsyncMatchProgressStore(prefs);
    return _instance!;
  }

  /// Generiert den Storage-Key
  String _key(String userId, String matchId) => 'async_match/$userId/$matchId';

  /// Lädt den Progress für ein Match
  Future<AsyncMatchProgress?> load(String userId, String matchId) async {
    try {
      final raw = _prefs.getString(_key(userId, matchId));
      if (raw == null) {
        print('📭 Kein Progress gefunden für Match: ${matchId.substring(0, 8)}');
        return null;
      }

      final progress = AsyncMatchProgress.fromJson(jsonDecode(raw));
      print('📖 Progress geladen: $progress');
      return progress;
    } catch (e) {
      print('❌ Fehler beim Laden des Progress: $e');
      return null;
    }
  }

  /// Stellt sicher, dass ein Progress existiert (erstellt falls nötig)
  Future<AsyncMatchProgress> ensure(String userId, String matchId) async {
    final existing = await load(userId, matchId);
    if (existing != null) return existing;

    print('📝 Erstelle neuen Progress für Match: ${matchId.substring(0, 8)}');
    
    final fresh = AsyncMatchProgress(
      userId: userId,
      matchId: matchId,
      currentIdx: 0,
      answers: <int, int>{},
      startedAt: DateTime.now(),
      lastUpdated: DateTime.now(),
    );

    await save(fresh);
    return fresh;
  }

  /// Speichert den Progress
  Future<void> save(AsyncMatchProgress progress) async {
    try {
      // Update lastUpdated vor dem Speichern
      progress.lastUpdated = DateTime.now();

      final json = jsonEncode(progress.toJson());
      await _prefs.setString(_key(progress.userId, progress.matchId), json);
      
      print('💾 Progress gespeichert: $progress');
    } catch (e) {
      print('❌ Fehler beim Speichern des Progress: $e');
      rethrow;
    }
  }

  /// Löscht den Progress für ein Match
  Future<void> clear(String userId, String matchId) async {
    try {
      await _prefs.remove(_key(userId, matchId));
      print('🗑️ Progress gelöscht für Match: ${matchId.substring(0, 8)}');
    } catch (e) {
      print('❌ Fehler beim Löschen des Progress: $e');
      rethrow;
    }
  }

  /// Listet alle gespeicherten Matches für einen User
  Future<List<String>> listMatches(String userId) async {
    try {
      final prefix = 'async_match/$userId/';
      final keys = _prefs.getKeys().where((k) => k.startsWith(prefix));
      
      return keys.map((k) => k.substring(prefix.length)).toList();
    } catch (e) {
      print('❌ Fehler beim Listen der Matches: $e');
      return [];
    }
  }

  /// Löscht alle abgeschlossenen Matches (älter als X Tage)
  Future<int> cleanupOldMatches(String userId, {int daysOld = 7}) async {
    try {
      final matches = await listMatches(userId);
      int deleted = 0;
      final cutoff = DateTime.now().subtract(Duration(days: daysOld));

      for (final matchId in matches) {
        final progress = await load(userId, matchId);
        if (progress == null) continue;

        final age = progress.lastUpdated ?? progress.startedAt;
        if (age.isBefore(cutoff)) {
          await clear(userId, matchId);
          deleted++;
        }
      }

      if (deleted > 0) {
        print('🧹 $deleted alte Matches gelöscht (älter als $daysOld Tage)');
      }

      return deleted;
    } catch (e) {
      print('❌ Fehler beim Cleanup: $e');
      return 0;
    }
  }

  /// Exportiert alle Matches als JSON (für Backup/Debug)
  Future<Map<String, dynamic>> exportMatches(String userId) async {
    try {
      final matches = await listMatches(userId);
      final export = <String, dynamic>{};

      for (final matchId in matches) {
        final progress = await load(userId, matchId);
        if (progress != null) {
          export[matchId] = progress.toJson();
        }
      }

      return {
        'userId': userId,
        'exportedAt': DateTime.now().toIso8601String(),
        'matches': export,
      };
    } catch (e) {
      print('❌ Fehler beim Export: $e');
      return {};
    }
  }
}