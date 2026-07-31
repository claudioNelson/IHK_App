// lib/widgets/premium_kauf_sheet.dart
//
// Bottom Sheet mit den drei Premium-Plänen (Google Play Billing).
// Aufruf über showPremiumKaufSheet(context) — liefert true zurück,
// wenn der Kauf erfolgreich war (Premium ist dann bereits freigeschaltet).

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/billing_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/theme_provider.dart';

/// Öffnet das Kauf-Sheet. Gibt true zurück, wenn Premium aktiviert wurde.
Future<bool?> showPremiumKaufSheet(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const PremiumKaufSheet(),
  );
}

class PremiumKaufSheet extends StatefulWidget {
  const PremiumKaufSheet({super.key});

  @override
  State<PremiumKaufSheet> createState() => _PremiumKaufSheetState();
}

class _PremiumKaufSheetState extends State<PremiumKaufSheet> {
  final _billing = BillingService();

  bool _busy = false;
  String? _error;

  StreamSubscription<bool>? _successSub;
  StreamSubscription<String>? _errorSub;

  @override
  void initState() {
    super.initState();

    // Erfolgreicher Kauf → Sheet mit true schließen.
    _successSub = _billing.onPremiumActivated.listen((_) {
      if (mounted) Navigator.pop(context, true);
    });

    // Fehler/Abbruch → Meldung anzeigen, Buttons wieder freigeben.
    _errorSub = _billing.onPurchaseError.listen((msg) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = msg;
        });
      }
    });

    // Preise nachladen, falls noch nicht geschehen.
    _billing.loadProducts().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _successSub?.cancel();
    _errorSub?.cancel();
    super.dispose();
  }

  Future<void> _buy(PremiumPlan plan) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final started = await _billing.buy(plan);
    if (!started && mounted) {
      setState(() => _busy = false);
    }
    // Danach übernimmt der purchaseStream (Erfolg → pop, Fehler → _errorSub).
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(color: border),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Grabber
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              Row(
                children: [
                  Container(width: 16, height: 1, color: AppColors.accent),
                  const SizedBox(width: 10),
                  Text(
                    'PREMIUM WERDEN',
                    style: AppTextStyles.monoLabel(AppColors.accent),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Text(
                'Wähle deinen Plan.',
                style: AppTextStyles.instrumentSerif(
                  size: 28,
                  color: text,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Alle Pläne enthalten den vollen Premium-Zugang. '
                'Jederzeit in Google Play kündbar.',
                style: AppTextStyles.bodySmall(textMid),
              ),
              const SizedBox(height: 18),

              // ─── Pläne ───────────────────────────
              _planCard(
                plan: PremiumPlan.annual,
                title: 'Jährlich',
                subtitle: '12 Monate · nur ${_perMonth(PremiumPlan.annual)} €/Monat',
                badge: 'BESTER PREIS',
                surface: surface,
                border: border,
                text: text,
                textMid: textMid,
              ),
              const SizedBox(height: 10),
              _planCard(
                plan: PremiumPlan.halfYear,
                title: 'Halbjährlich',
                subtitle: '6 Monate · nur ${_perMonth(PremiumPlan.halfYear)} €/Monat',
                surface: surface,
                border: border,
                text: text,
                textMid: textMid,
              ),
              const SizedBox(height: 10),
              _planCard(
                plan: PremiumPlan.monthly,
                title: 'Monatlich',
                subtitle: '1 Monat · flexibel kündbar',
                surface: surface,
                border: border,
                text: text,
                textMid: textMid,
              ),

              if (_error != null) ...[
                const SizedBox(height: 14),
                Text(
                  _error!,
                  style: AppTextStyles.bodySmall(AppColors.warning),
                ),
              ],

              const SizedBox(height: 14),
              Center(
                child: TextButton(
                  onPressed: _busy
                      ? null
                      : () => _billing.restorePurchases(),
                  child: Text(
                    'Käufe wiederherstellen',
                    style: AppTextStyles.bodySmall(textMid),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Abos verlängern sich automatisch zum jeweiligen Preis und '
                'können jederzeit in den Google-Play-Einstellungen gekündigt '
                'werden.',
                style: AppTextStyles.bodySmall(
                  textMid.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// €/Monat aus dem echten Google-Preis (oder Fallback) berechnen.
  String _perMonth(PremiumPlan plan) {
    final total = _billing.rawPriceFor(plan);
    return (total / plan.months).toStringAsFixed(2).replaceAll('.', ',');
  }

  Widget _planCard({
    required PremiumPlan plan,
    required String title,
    required String subtitle,
    String? badge,
    required Color surface,
    required Color border,
    required Color text,
    required Color textMid,
  }) {
    final highlighted = badge != null;

    return InkWell(
      onTap: _busy ? null : () => _buy(plan),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: highlighted ? AppColors.accent : border,
            width: highlighted ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.interTight(
                          size: 16,
                          weight: FontWeight.w700,
                          color: text,
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            badge,
                            style: AppTextStyles.mono(
                              size: 9,
                              color: AppColors.accent,
                              weight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.bodySmall(textMid)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _busy
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: textMid,
                    ),
                  )
                : Text(
                    _billing.priceFor(plan),
                    style: AppTextStyles.interTight(
                      size: 16,
                      weight: FontWeight.w700,
                      color: highlighted ? AppColors.accent : text,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
