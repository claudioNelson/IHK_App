// lib/widgets/limit_indicator_pill.dart
import 'package:flutter/material.dart';
import '../services/usage_tracker.dart';
import '../services/subscription_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Pill-Indikator der zeigt, wieviele Aktionen ein Free-User heute noch hat.
///
/// - Premium-User: returnt SizedBox.shrink (Widget unsichtbar)
/// - Free-User: zeigt "3 / 5" als Pill
/// - Bei Limit erreicht: rote Variante mit "0 / 5"
///
/// Verwendung im Screen-Header:
/// ```dart
/// LimitIndicatorPill(
///   feature: UsageFeature.moduleQuestions,
///   contextValue: widget.moduleId.toString(),
/// )
/// ```
class LimitIndicatorPill extends StatefulWidget {
  final UsageFeature feature;
  final String? contextValue;

  /// Wird automatisch aktualisiert wenn der Counter sich ändert
  /// (z.B. nach jeder beantworteten Frage). Übergebe currentIndex
  /// oder eine andere Variable die sich pro Frage ändert als Key.
  const LimitIndicatorPill({
    super.key,
    required this.feature,
    this.contextValue,
  });

  @override
  State<LimitIndicatorPill> createState() => _LimitIndicatorPillState();
}

class _LimitIndicatorPillState extends State<LimitIndicatorPill> {
  final _tracker = UsageTracker();
  final _subscription = SubscriptionService();

  int _used = 0;
  int _limit = 0;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant LimitIndicatorPill oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Bei Key-Change neu laden
    _load();
  }

  Future<void> _load() async {
    if (_subscription.isPremium) {
      if (mounted) setState(() => _loaded = true);
      return;
    }
    final used = await _tracker.getUsage(
      feature: widget.feature,
      context: widget.contextValue,
    );
    final remaining = await _tracker.getRemaining(
      feature: widget.feature,
      context: widget.contextValue,
    );
    if (!mounted) return;
    setState(() {
      _used = used;
      _limit = used + remaining;
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Premium: nichts anzeigen
    if (_subscription.isPremium) return const SizedBox.shrink();

    // Noch nicht geladen
    if (!_loaded) return const SizedBox.shrink();

    final reached = _used >= _limit;
    final lowWarning = !reached && (_limit - _used) <= 1;

    Color bg;
    Color fg;
    Color borderColor;

    if (reached) {
      bg = AppColors.error.withOpacity(0.12);
      fg = AppColors.error;
      borderColor = AppColors.error.withOpacity(0.3);
    } else if (lowWarning) {
      bg = AppColors.warning.withOpacity(0.12);
      fg = AppColors.warning;
      borderColor = AppColors.warning.withOpacity(0.3);
    } else {
      bg = AppColors.accent.withOpacity(0.12);
      fg = AppColors.accent;
      borderColor = AppColors.accent.withOpacity(0.3);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        '$_used / $_limit',
        style: AppTextStyles.mono(
          size: 11,
          color: fg,
          weight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
