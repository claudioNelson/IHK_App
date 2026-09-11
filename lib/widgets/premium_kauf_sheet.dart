// lib/widgets/premium_kauf_sheet.dart
//
// Bottom Sheet mit den drei Premium-Plänen (Google Play Billing / App Store).
// Aufruf über showPremiumKaufSheet(context) — liefert true zurück,
// wenn der Kauf erfolgreich war (Premium ist dann bereits freigeschaltet).

import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/auth/upgrade_account_screen.dart';
import '../screens/legal/legal_document_screen.dart';
import '../services/aktions_service.dart';
import '../services/auth_service.dart';
import '../services/billing_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/theme_provider.dart';

/// Kann auf dieser Plattform überhaupt gekauft werden?
///
/// Seit 1.6 auch auf iOS (StoreKit über `billing_service.dart`). Der
/// Schalter [_iosKaufAktiv] bleibt als Notbremse: auf `false` verschwindet
/// die gesamte Kauf-Oberfläche auf iOS wieder (so lief 1.5.x durch Apples
/// Prüfung, weil ein toter Kauf-Knopf ein Ablehnungsgrund ist, Richtlinie 2.1).
///
/// WICHTIG: Auf iOS nie auf die Web-Version oder Google Play verweisen.
/// Nutzer zu einem Kaufweg ausserhalb des App Store zu lotsen verbietet
/// Richtlinie 3.1.3. Gesperrte Inhalte bleiben dann einfach gesperrt.
///
/// `kIsWeb` zuerst prüfen — `Platform` wirft im Browser.
const bool _iosKaufAktiv = true;
bool get premiumKaufMoeglich => kIsWeb || !Platform.isIOS || _iosKaufAktiv;


/// Öffnet das Kauf-Sheet. Gibt true zurück, wenn Premium aktiviert wurde.
/// Auf iOS passiert nichts (siehe [premiumKaufMoeglich]).
Future<bool?> showPremiumKaufSheet(BuildContext context) {
  if (!premiumKaufMoeglich) return Future<bool?>.value(null);

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
  final _authService = AuthService();

  bool _busy = false;
  String? _error;
  String? _statusText;
  Timer? _timeout;

  StreamSubscription<bool>? _successSub;
  StreamSubscription<String>? _errorSub;
  StreamSubscription<void>? _verifyingSub;

  @override
  void initState() {
    super.initState();

    // Erfolgreicher Kauf → Sheet mit true schließen.
    _successSub = _billing.onPremiumActivated.listen((_) {
      _timeout?.cancel();
      if (mounted) Navigator.pop(context, true);
    });

    // Fehler/Abbruch → Meldung anzeigen, Buttons wieder freigeben.
    _errorSub = _billing.onPurchaseError.listen((msg) {
      _timeout?.cancel();
      if (mounted) {
        setState(() {
          _busy = false;
          _statusText = null;
          _error = msg;
        });
      }
    });

    // Store hat den Kauf bestaetigt, Server prueft gerade den Beleg.
    _verifyingSub = _billing.onPurchaseVerifying.listen((_) {
      if (mounted) {
        setState(() {
          _busy = true;
          _statusText = 'Kauf wird bestätigt …';
        });
      }
    });

    // Preise nachladen, falls noch nicht geschehen.
    _billing.loadProducts().then((_) {
      if (mounted) setState(() {});
    });
    // Aktionstext nachladen, falls der Lernhub das noch nicht getan hat.
    AktionsService().laden().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timeout?.cancel();
    _successSub?.cancel();
    _errorSub?.cancel();
    _verifyingSub?.cancel();
    super.dispose();
  }

  Future<void> _buy(PremiumPlan plan) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
      _statusText = '$_storeLabel wird geöffnet …';
    });
    final started = await _billing.buy(plan);
    if (!started && mounted) {
      setState(() {
        _busy = false;
        _statusText = null;
      });
      return;
    }
    // Danach übernimmt der purchaseStream (Erfolg → pop, Fehler → _errorSub).
    // Sicherheitsnetz: meldet sich der Store gar nicht (Dialog weggewischt,
    // Sandbox haengt), Sheet nach 45 s wieder freigeben. Ein spaeter doch
    // eintreffender Kauf wird trotzdem verarbeitet (Listener bleibt).
    _timeout?.cancel();
    _timeout = Timer(const Duration(seconds: 45), () {
      if (!mounted || !_busy) return;
      setState(() {
        _busy = false;
        _statusText = null;
        _error = 'Keine Antwort vom $_storeLabel. Bitte erneut versuchen.';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Laufende Aktion (Text aus der DB) und, auf Google Play, das echte
    // Einfuehrungsangebot aus dem Store. Apple wendet sein Angebot im
    // Kaufdialog selbst an, dort gibt es nur den Text.
    final aktion = AktionsService().fuerPlan(PremiumPlan.monthly.basePlanId);
    final angebot = _billing.angebotFor(PremiumPlan.monthly);
    final isDark = context.watch<ThemeProvider>().isDark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;

    // Gäste können kein Premium kaufen — das Abo würde an einem
    // anonymen Account hängen und wäre bei Deinstallation verloren.
    if (_authService.isGuest) {
      return _buildGuestGate(bg, surface, border, text, textMid);
    }

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(color: border),
      ),
      child: SafeArea(
        top: false,
        // Scrollbar: mit den Abo-Pflichttexten passt das auf kleinen
        // iPhones sonst nicht mehr auf einen Screen.
        child: SingleChildScrollView(
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
                'Jederzeit im $_storeLabel kündbar.',
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
                subtitle: angebot != null
                    ? 'Erster Monat ${angebot.einfuehrungsPreis}, '
                        'danach ${angebot.regulaerPreis}/Monat'
                    : aktion != null
                        ? 'Erster Monat zum halben Preis, '
                            'danach ${_billing.priceFor(PremiumPlan.monthly)}/Monat'
                        : '1 Monat · flexibel kündbar',
                badge: (angebot != null || aktion != null) ? 'AKTION' : null,
                badgeColor: AppColors.warning,
                aktionsPreis: angebot?.einfuehrungsPreis,
                surface: surface,
                border: border,
                text: text,
                textMid: textMid,
              ),
              if (aktion?.hinweis != null) ...[
                const SizedBox(height: 10),
                Text(aktion!.hinweis!, style: AppTextStyles.bodySmall(textMid)),
              ],

              if (_error != null) ...[
                const SizedBox(height: 14),
                Text(
                  _error!,
                  style: AppTextStyles.bodySmall(AppColors.warning),
                ),
              ],

              // Statuszeile waehrend des Kaufs: der Store-Dialog braucht
              // (besonders in Apples Sandbox) gern 5-15 s, die Bestaetigung
              // beim Server nochmal ein paar Sekunden. Ohne Text wirkt der
              // Spinner wie "haengt".
              if (_busy && _statusText != null) ...[
                const SizedBox(height: 14),
                Row(
                  children: [
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _statusText!,
                        style: AppTextStyles.bodySmall(textMid),
                      ),
                    ),
                  ],
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
              // Pflichtangaben fuer Abos (Apple 3.1.2; bei Google ebenso
              // sinnvoll): Preis je Periode steht auf den Karten, hier
              // Verlaengerung/Kuendigung + Links zu AGB und Datenschutz.
              Text(
                'Die Zahlung wird über dein ${_storeLabel}-Konto abgerechnet. '
                'Das Abo verlängert sich automatisch zum jeweiligen Preis, '
                'sofern es nicht mindestens 24 Stunden vor Ablauf der '
                'laufenden Periode gekündigt wird. Kündigen kannst du '
                'jederzeit in den $_storeLabel-Einstellungen.',
                style: AppTextStyles.bodySmall(
                  textMid.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _legalLink(context, 'Nutzungsbedingungen', LegalDoc.agb, textMid),
                  Text(
                    '  ·  ',
                    style: AppTextStyles.bodySmall(textMid.withOpacity(0.5)),
                  ),
                  _legalLink(context, 'Datenschutz', LegalDoc.datenschutz, textMid),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// "App Store" auf iOS, sonst "Google Play" (fuer die Abo-Hinweise).
  String get _storeLabel =>
      (!kIsWeb && Platform.isIOS) ? 'App Store' : 'Google Play';

  /// Textlink auf AGB bzw. Datenschutz (in-App-Screens, kein externer Link).
  Widget _legalLink(
    BuildContext context,
    String label,
    LegalDoc doc,
    Color color,
  ) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => LegalDocumentScreen(doc: doc)),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall(color).copyWith(
          decoration: TextDecoration.underline,
          decorationColor: color.withOpacity(0.6),
        ),
      ),
    );
  }

  /// Ansicht für Gäste: erst Account erstellen, dann kaufen.
  Widget _buildGuestGate(
    Color bg,
    Color surface,
    Color border,
    Color text,
    Color textMid,
  ) {
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
                'Sichere zuerst deinen Account.',
                style: AppTextStyles.instrumentSerif(
                  size: 28,
                  color: text,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Dein Premium-Abo wird mit deinem Account verknüpft. '
                'Als Gast würde es bei einer Deinstallation verloren gehen. '
                'Erstelle deshalb zuerst einen kostenlosen Account — dein '
                'bisheriger Fortschritt bleibt dabei erhalten.',
                style: AppTextStyles.bodySmall(textMid),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final ok = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UpgradeAccountScreen(),
                      ),
                    );
                    // Nach der Umwandlung muss erst die Mail bestätigt
                    // werden — Sheet schließen, User kommt später wieder.
                    if (ok == true && mounted) {
                      Navigator.pop(context, false);
                    }
                  },
                  icon: const Icon(Icons.person_add_alt_1_outlined, size: 18),
                  label: Text(
                    'Account erstellen & Fortschritt sichern',
                    style: AppTextStyles.interTight(
                      size: 14,
                      weight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    'Vielleicht später',
                    style: AppTextStyles.bodySmall(textMid),
                  ),
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
    Color badgeColor = AppColors.accent,
    String? aktionsPreis,
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
            color: highlighted ? badgeColor : border,
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
                            color: badgeColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            badge,
                            style: AppTextStyles.mono(
                              size: 9,
                              color: badgeColor,
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
                : aktionsPreis != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            aktionsPreis,
                            style: AppTextStyles.interTight(
                              size: 16,
                              weight: FontWeight.w700,
                              color: badgeColor,
                            ),
                          ),
                          Text(
                            _billing.priceFor(plan),
                            style: AppTextStyles.bodySmall(textMid).copyWith(
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        _billing.priceFor(plan),
                        style: AppTextStyles.interTight(
                          size: 16,
                          weight: FontWeight.w700,
                          color: highlighted ? badgeColor : text,
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
