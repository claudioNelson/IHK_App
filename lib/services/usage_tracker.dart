// lib/services/usage_tracker.dart
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'subscription_service.dart';

/// Trackt die Nutzung von limitierten Features für Free-User.
///
/// Limits werden pro Tag pro User pro Feature gespeichert.
/// Premium-User haben keine Limits — Service ist für sie No-Op.
class UsageTracker {
  static final UsageTracker _instance = UsageTracker._internal();
  factory UsageTracker() => _instance;
  UsageTracker._internal();

  final _supabase = Supabase.instance.client;
  final _subscription = SubscriptionService();

  // ─── DAILY LIMITS für FREE-USER ─────────────────
  static const int limitModuleQuestions = 5; // pro Modul!
  static const int limitAiTutor = 5;
  static const int limitAsyncMatch = 5;
  static const int limitFlashcards = 30;

  // ─── PUBLIC API ─────────────────────────────────

  /// Prüft ob User die Aktion ausführen darf.
  Future<bool> canUse({required UsageFeature feature, String? context}) async {
    if (_subscription.isPremium) return true;

    final used = await getUsage(feature: feature, context: context);
    final limit = _getLimit(feature);
    return used < limit;
  }

  /// Inkrementiert den Counter (für Free-User).
  Future<void> increment({
    required UsageFeature feature,
    String? context,
  }) async {
    debugPrint(
      '🟡 increment called: feature=${feature.key} context=$context isPremium=${_subscription.isPremium}',
    );
    if (_subscription.isPremium) {
      debugPrint('   → skipped (premium)');
      return;
    }

    final user = _supabase.auth.currentUser;
    if (user == null) {
      debugPrint('   → skipped (no user)');
      return;
    }
    debugPrint('   → proceeding for user ${user.id}');

    final today = DateTime.now().toIso8601String().substring(0, 10);
    final featureKey = feature.key;

    try {
      // Existiert ein Eintrag für heute?
      List<dynamic> existing;
      if (context != null) {
        existing = await _supabase
            .from('usage_tracking')
            .select()
            .eq('user_id', user.id)
            .eq('feature', featureKey)
            .eq('date', today)
            .eq('context', context);
      } else {
        existing = await _supabase
            .from('usage_tracking')
            .select()
            .eq('user_id', user.id)
            .eq('feature', featureKey)
            .eq('date', today)
            .filter('context', 'is', null);
      }

      if (existing.isNotEmpty) {
        // Update
        final entry = existing.first;
        await _supabase
            .from('usage_tracking')
            .update({
              'count': (entry['count'] as int) + 1,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', entry['id']);
      } else {
        // Insert
        await _supabase.from('usage_tracking').insert({
          'user_id': user.id,
          'feature': featureKey,
          'date': today,
          'count': 1,
          'context': context,
        });
      }
    } catch (e) {
      debugPrint('❌ UsageTracker increment error: $e');
    }
  }

  /// Liest aktuelle Nutzung (heute) zurück.
  Future<int> getUsage({required UsageFeature feature, String? context}) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return 0;

    final today = DateTime.now().toIso8601String().substring(0, 10);
    final featureKey = feature.key;

    try {
      List<dynamic> result;
      if (context != null) {
        result = await _supabase
            .from('usage_tracking')
            .select('count')
            .eq('user_id', user.id)
            .eq('feature', featureKey)
            .eq('date', today)
            .eq('context', context);
      } else {
        result = await _supabase
            .from('usage_tracking')
            .select('count')
            .eq('user_id', user.id)
            .eq('feature', featureKey)
            .eq('date', today)
            .filter('context', 'is', null);
      }

      if (result.isEmpty) return 0;
      return result.first['count'] as int? ?? 0;
    } catch (e) {
      debugPrint('❌ UsageTracker getUsage error: $e');
      return 0;
    }
  }

  /// Gibt das verbleibende Limit zurück.
  Future<int> getRemaining({
    required UsageFeature feature,
    String? context,
  }) async {
    if (_subscription.isPremium) return 999;
    final used = await getUsage(feature: feature, context: context);
    final limit = _getLimit(feature);
    return (limit - used).clamp(0, limit);
  }

  int _getLimit(UsageFeature feature) {
    switch (feature) {
      case UsageFeature.moduleQuestions:
        return limitModuleQuestions;
      case UsageFeature.aiTutor:
        return limitAiTutor;
      case UsageFeature.asyncMatch:
        return limitAsyncMatch;
      case UsageFeature.flashcards:
        return limitFlashcards;
    }
  }
}

/// Enum für alle limitierten Features
enum UsageFeature {
  moduleQuestions('module_questions'),
  aiTutor('ai_tutor'),
  asyncMatch('async_match'),
  flashcards('flashcards');

  final String key;
  const UsageFeature(this.key);
}
