// lib/mixins/practice_limit_mixin.dart
import 'package:flutter/material.dart';
import '../services/usage_tracker.dart';
import '../widgets/limit_reached_dialog.dart';

/// Mixin für alle Practice-Screens (Module + Kernthemen).
///
/// Enthält die komplette Daily-Limit-Logik:
/// - Limit-Check beim Öffnen des Screens
/// - Counter-Increment nach jeder beantworteten Frage
/// - Dialog-Anzeige + Pop bei Limit-Überschreitung
///
/// Verwendung:
/// ```dart
/// class _MyPracticeScreenState extends State<MyPracticeScreen>
///     with PracticeLimitMixin<MyPracticeScreen> {
///
///   @override
///   void initState() {
///     super.initState();
///     _loadQuestions();
///   }
///
///   Future<void> _loadQuestions() async {
///     // Erst Limit prüfen
///     if (!await checkPracticeLimit(widget.moduleId)) return;
///     // ... dann Fragen laden
///   }
///
///   void _onAnswered(bool isCorrect) async {
///     await recordPracticeAnswer(widget.moduleId);
///     // ... rest der Logik
///   }
/// }
/// ```
mixin PracticeLimitMixin<T extends StatefulWidget> on State<T> {
  /// Prüft, ob der User noch Fragen stellen darf.
  ///
  /// Returns:
  /// - `true`  → User darf weitermachen
  /// - `false` → Limit erreicht, Dialog wird angezeigt + Screen wird gepoppt
  Future<bool> checkPracticeLimit(int moduleId) async {
    final canUse = await UsageTracker().canUse(
      feature: UsageFeature.moduleQuestions,
      context: moduleId.toString(),
    );

    if (canUse) return true;

    if (!mounted) return false;

    // Limit erreicht → Dialog zeigen, dann Screen schließen
    LimitReachedDialog.show(
      context,
      featureName: 'Modul-Fragen',
      limit: UsageTracker.limitModuleQuestions,
      icon: Icons.help_outline_rounded,
      onUpgrade: () {
        // TODO: später zur Pricing-Page navigieren
      },
    ).then((_) {
      if (mounted) Navigator.pop(context);
    });

    return false;
  }

  /// Inkrementiert den Counter für die beantwortete Frage.
  ///
  /// Premium-User: No-Op (UsageTracker macht das intern).
  Future<void> recordPracticeAnswer(int moduleId) async {
    await UsageTracker().increment(
      feature: UsageFeature.moduleQuestions,
      context: moduleId.toString(),
    );
  }
}
