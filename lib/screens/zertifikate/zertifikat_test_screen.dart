import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/sound_service.dart';
import '../../services/badge_service.dart';
import '../../widgets/badge_celebration_dialog.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';
import '../../services/question_validator.dart';
import '../../services/subscription_service.dart';
import '../../widgets/premium_lock.dart';

class ZertifikatTestPage extends StatefulWidget {
  final int zertifikatId;
  final String zertifikatName;
  final int anzahlFragen;
  final int pruefungsdauer;
  final int mindestPunktzahl;

  const ZertifikatTestPage({
    super.key,
    required this.zertifikatId,
    required this.zertifikatName,
    required this.anzahlFragen,
    required this.pruefungsdauer,
    required this.mindestPunktzahl,
  });

  @override
  State<ZertifikatTestPage> createState() => _ZertifikatTestPageState();
}

class _ZertifikatTestPageState extends State<ZertifikatTestPage>
    with WidgetsBindingObserver {
  final supabase = Supabase.instance.client;

  List<dynamic> fragen = [];
  Map<int, List<dynamic>> gemischteAntworten = {};
  int aktuelleFrage = 0;
  Map<int, int> antworten = {};
  bool loading = true;
  bool pruefungAbgeschlossen = false;
  final _soundService = SoundService();
  final _badgeService = BadgeService();

  int? score;
  bool? bestanden;

  Timer? _timer;
  int _remainingSeconds = 0;
  DateTime? _startTime;
  int? _timeTakenSeconds;
  bool _autoSubmitted = false;

  // Vendor Akzentfarbe
  Color get _vendorColor {
    final name = widget.zertifikatName;
    if (name.contains('AWS') || name.contains('Amazon'))
      return AppColors.warning;
    if (name.contains('Azure') || name.contains('Microsoft'))
      return AppColors.accentCyan;
    if (name.contains('Google')) return AppColors.accent;
    if (name.contains('SAP')) return AppColors.accentCyan;
    return AppColors.accent;
  }

  String get _vendorLabel {
    final name = widget.zertifikatName;
    if (name.contains('AWS') || name.contains('Amazon')) return 'AWS';
    if (name.contains('Azure') || name.contains('Microsoft')) return 'AZURE';
    if (name.contains('Google')) return 'GCP';
    if (name.contains('SAP')) return 'SAP';
    return 'PRÜFUNG';
  }

  @override
  void initState() {
    super.initState();
    _soundService.init();
    WidgetsBinding.instance.addObserver(this);
    _loadFragen();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _timer?.cancel();
    } else if (state == AppLifecycleState.resumed) {
      if (!pruefungAbgeschlossen && _remainingSeconds > 0) _startTimer();
    }
  }

  Future<void> _loadFragen() async {
    try {
      final data = await supabase
          .from('fragen')
          .select('id, frage, antworten(id, text, ist_richtig)')
          .eq('zertifikat_id', widget.zertifikatId)
          .limit(widget.anzahlFragen);

      if (!mounted) return;
      for (final frage in data) {
        final antwortListe = List.from(frage['antworten'] as List);
        antwortListe.shuffle();
        gemischteAntworten[frage['id']] = antwortListe;
      }
      setState(() {
        fragen = data;
        loading = false;
      });
      _startPruefung();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Laden: $e'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() => loading = false);
    }
  }

  void _startPruefung() {
    _startTime = DateTime.now();
    _remainingSeconds = widget.pruefungsdauer * 60;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _remainingSeconds--);
      if (_remainingSeconds == 600) _showTimeWarning();
      if (_remainingSeconds <= 0) {
        timer.cancel();
        _autoSubmitted = true;
        _submitPruefung();
      }
    });
  }

  void _showTimeWarning() {
    final isDark = context.read<ThemeProvider>().isDark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(width: 16, height: 1, color: AppColors.warning),
                  const SizedBox(width: 10),
                  Text(
                    'ZEITWARNUNG',
                    style: AppTextStyles.monoLabel(AppColors.warning),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Noch 10 Minuten\nverbleibend.',
                style: AppTextStyles.instrumentSerif(
                  size: 26,
                  color: text,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Die Prüfung wird automatisch beendet, wenn die Zeit abläuft.',
                style: AppTextStyles.bodyMedium(textMid),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: text,
                    foregroundColor: bg,
                    elevation: 0,
                    textStyle: AppTextStyles.labelLarge(bg),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Verstanden'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _selectAntwort(int antwortId) {
    if (pruefungAbgeschlossen) return;
    _soundService.playSound(SoundType.click);
    setState(() => antworten[aktuelleFrage] = antwortId);
  }

  void _naechsteFrage() {
    if (aktuelleFrage < fragen.length - 1) setState(() => aktuelleFrage++);
  }

  void _vorherigeFrageGehen() {
    if (aktuelleFrage > 0) setState(() => aktuelleFrage--);
  }

  Future<bool> _showExitDialog() async {
    final isDark = context.read<ThemeProvider>().isDark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(width: 16, height: 1, color: AppColors.error),
                  const SizedBox(width: 10),
                  Text(
                    'PRÜFUNG ABBRECHEN',
                    style: AppTextStyles.monoLabel(AppColors.error),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Wirklich abbrechen?',
                style: AppTextStyles.instrumentSerif(
                  size: 26,
                  color: text,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Dein Fortschritt geht verloren.',
                style: AppTextStyles.bodyMedium(textMid),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Weiter',
                          style: AppTextStyles.mono(
                            size: 11,
                            color: textMid,
                            weight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          textStyle: AppTextStyles.labelLarge(Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Abbrechen'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    return result ?? false;
  }

  void _submitPruefung() async {
    _timer?.cancel();
    if (_startTime != null && _timeTakenSeconds == null) {
      _timeTakenSeconds = DateTime.now().difference(_startTime!).inSeconds;
    }

    int richtig = 0;
    for (int i = 0; i < fragen.length; i++) {
      final selectedId = antworten[i];
      if (selectedId == null) continue;
      final frage = fragen[i];
      final antwortListe = gemischteAntworten[frage['id']]!;
      final selected = antwortListe.firstWhere((a) => a['id'] == selectedId);
      if (selected['ist_richtig'] == true) richtig++;
    }

    final prozent = ((richtig / fragen.length) * 100).round();
    final passed = prozent >= widget.mindestPunktzahl;

    setState(() {
      score = prozent;
      bestanden = passed;
      pruefungAbgeschlossen = true;
    });

    await _saveResult(prozent, passed);

    if (passed) {
      _soundService.playSound(SoundType.victory);
      Future.delayed(
        const Duration(milliseconds: 500),
        _checkCertificateBadges,
      );
    } else {
      _soundService.playSound(SoundType.defeat);
    }
  }

  Future<void> _saveResult(int score, bool passed) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      final existing = await supabase
          .from('user_certificates')
          .select()
          .eq('user_id', userId)
          .eq('zertifikat_id', widget.zertifikatId)
          .maybeSingle();

      if (existing == null) {
        await supabase.from('user_certificates').insert({
          'user_id': userId,
          'zertifikat_id': widget.zertifikatId,
          'best_score': score,
          'passed': passed,
          'passed_at': passed ? DateTime.now().toIso8601String() : null,
          'attempts': 1,
        });
      } else {
        final newBestScore = score > (existing['best_score'] ?? 0)
            ? score
            : existing['best_score'];
        final newPassed = passed || (existing['passed'] ?? false);
        await supabase
            .from('user_certificates')
            .update({
              'best_score': newBestScore,
              'passed': newPassed,
              'passed_at': (newPassed && existing['passed_at'] == null)
                  ? DateTime.now().toIso8601String()
                  : existing['passed_at'],
              'attempts': (existing['attempts'] ?? 0) + 1,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('user_id', userId)
            .eq('zertifikat_id', widget.zertifikatId);
      }
    } catch (e) {
      print('❌ Fehler beim Speichern: $e');
    }
  }

  Future<void> _checkCertificateBadges() async {
    if (bestanden != true) return;
    try {
      String? certKey;
      switch (widget.zertifikatId) {
        case 1:
          certKey = 'aws';
          break;
        case 2:
          certKey = 'sap';
          break;
        case 3:
          certKey = 'azure';
          break;
        case 4:
          certKey = 'gcp';
          break;
      }
      final earnedCerts = <String>[];
      if (certKey != null) earnedCerts.add(certKey);
      final newBadges = await _badgeService.checkCertificateBadges(earnedCerts);
      if (newBadges.isNotEmpty && mounted) {
        final allBadges = await _badgeService.getAllBadges();
        final earnedDetails = allBadges
            .where((b) => newBadges.contains(b['id']))
            .toList();
        if (mounted) {
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => BadgeCelebrationDialog(
              badgeIds: newBadges,
              badgeDetails: earnedDetails,
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Badge-Fehler: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

    // ─── PAYWALL ─────────────────────────────
    if (!SubscriptionService().isPremium) {
      return PremiumLock(
        featureName: 'Zertifikat-Prüfungen',
        description:
            'Mit Premium absolvierst du echte Zertifikat-Prüfungen mit Timer und Bestehensgrenze.',
        icon: Icons.workspace_premium_outlined,
        onUpgrade: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Stripe-Checkout kommt bald!')),
          );
        },
      );
    }

    if (loading) {
      return Scaffold(
        backgroundColor: bg,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: _vendorColor),
              const SizedBox(height: 16),
              Text('Lade Fragen...', style: AppTextStyles.bodyMedium(textMid)),
            ],
          ),
        ),
      );
    }

    if (pruefungAbgeschlossen) {
      return _buildErgebnisScreen(bg, surface, border, text, textMid, textDim);
    }

    if (fragen.isEmpty) {
      return Scaffold(
        backgroundColor: bg,
        body: Center(
          child: Text(
            'Keine Fragen verfügbar',
            style: AppTextStyles.h3(textMid),
          ),
        ),
      );
    }

    final frage = fragen[aktuelleFrage];
    final antwortListe = gemischteAntworten[frage['id']]!;
    final selectedId = antworten[aktuelleFrage];
    final isLowTime = _remainingSeconds <= 600;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final exit = await _showExitDialog();
        if (exit && context.mounted) Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: bg,
        body: Column(
          children: [
            // ─── APPBAR ─────────────────────────
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        final exit = await _showExitDialog();
                        if (exit && context.mounted) Navigator.pop(context);
                      },
                      icon: Icon(Icons.close_rounded, color: text, size: 22),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.zertifikatName,
                            style: AppTextStyles.labelMedium(textMid),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'FRAGE ${(aktuelleFrage + 1).toString().padLeft(2, '0')} / ${fragen.length.toString().padLeft(2, '0')}',
                            style: AppTextStyles.monoSmall(textDim),
                          ),
                        ],
                      ),
                    ),
                    // Timer Pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isLowTime
                            ? AppColors.error.withOpacity(0.12)
                            : surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isLowTime
                              ? AppColors.error.withOpacity(0.4)
                              : border,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isLowTime
                                ? Icons.alarm_rounded
                                : Icons.timer_outlined,
                            size: 13,
                            color: isLowTime ? AppColors.error : textMid,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            _formatTime(_remainingSeconds),
                            style: AppTextStyles.mono(
                              size: 12,
                              color: isLowTime ? AppColors.error : text,
                              weight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ─── PROGRESS BAR ───────────────────
            LinearProgressIndicator(
              value: (aktuelleFrage + 1) / fragen.length,
              backgroundColor: border,
              valueColor: AlwaysStoppedAnimation(_vendorColor),
              minHeight: 2,
            ),

            // ─── CONTENT ────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Label + Status
                    Row(
                      children: [
                        Container(width: 16, height: 1, color: _vendorColor),
                        const SizedBox(width: 10),
                        Text(
                          'FRAGE',
                          style: AppTextStyles.monoLabel(_vendorColor),
                        ),
                        const Spacer(),
                        // Beantwortet/Offen Status
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: selectedId != null
                                ? AppColors.success.withOpacity(0.1)
                                : AppColors.warning.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: selectedId != null
                                  ? AppColors.success.withOpacity(0.3)
                                  : AppColors.warning.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            selectedId != null ? 'BEANTWORTET' : 'OFFEN',
                            style: AppTextStyles.mono(
                              size: 9,
                              color: selectedId != null
                                  ? AppColors.success
                                  : AppColors.warning,
                              weight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Frage
                    Text(
                      frage['frage'],
                      style: AppTextStyles.instrumentSerif(
                        size: 22,
                        color: text,
                        letterSpacing: -0.6,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Antworten (kein direktes Feedback im Prüfungsmodus!)
                    ...antwortListe.asMap().entries.map((entry) {
                      final index = entry.key;
                      final antwort = entry.value;
                      final antwortId = antwort['id'] as int;
                      final isSelected = selectedId == antwortId;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: () => _selectAntwort(antwortId),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? _vendorColor.withOpacity(0.05)
                                  : surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? _vendorColor : border,
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: isSelected ? _vendorColor : border,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      String.fromCharCode(65 + index),
                                      style: AppTextStyles.mono(
                                        size: 12,
                                        color: isSelected
                                            ? Colors.white
                                            : textMid,
                                        weight: FontWeight.w700,
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      antwort['text'],
                                      style: AppTextStyles.interTight(
                                        size: 15,
                                        weight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                        color: text,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // ─── NAVIGATION ─────────────────────
            _buildNavBar(surface, border, text, textMid, textDim, bg),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBar(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
    Color bg,
  ) {
    final beantwortet = antworten.length;
    final gesamt = fragen.length;
    final alleDone = beantwortet >= gesamt;

    return Container(
      decoration: BoxDecoration(
        color: surface,
        border: Border(top: BorderSide(color: border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Counter
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.quiz_outlined, size: 12, color: textMid),
                  const SizedBox(width: 6),
                  Text(
                    '$beantwortet / $gesamt BEANTWORTET',
                    style: AppTextStyles.monoSmall(textMid),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (aktuelleFrage > 0) ...[
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: _vorherigeFrageGehen,
                          icon: Icon(
                            Icons.arrow_back_rounded,
                            size: 14,
                            color: textMid,
                          ),
                          label: Text(
                            'Zurück',
                            style: AppTextStyles.mono(
                              size: 11,
                              color: textMid,
                              weight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: border),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: aktuelleFrage < fragen.length - 1
                            ? _naechsteFrage
                            : (alleDone ? _submitPruefung : null),
                        icon: Icon(
                          aktuelleFrage < fragen.length - 1
                              ? Icons.arrow_forward_rounded
                              : Icons.check_rounded,
                          size: 16,
                        ),
                        label: Text(
                          aktuelleFrage < fragen.length - 1
                              ? 'Weiter'
                              : 'Abgeben',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: text,
                          foregroundColor: bg,
                          elevation: 0,
                          textStyle: AppTextStyles.labelLarge(bg),
                          disabledBackgroundColor: border,
                          disabledForegroundColor: textDim,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // ERGEBNIS SCREEN
  // ═══════════════════════════════════════════════════════════
  Widget _buildErgebnisScreen(
    Color bg,
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    final accentColor = bestanden! ? AppColors.success : AppColors.error;
    final timeTakenFormatted = _timeTakenSeconds != null
        ? _formatTime(_timeTakenSeconds!)
        : 'Unbekannt';

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close_rounded, color: text, size: 22),
                  ),
                  Expanded(
                    child: Text(
                      'PRÜFUNGSERGEBNIS',
                      style: AppTextStyles.monoLabel(textMid),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Label
                    Row(
                      children: [
                        Container(width: 16, height: 1, color: accentColor),
                        const SizedBox(width: 10),
                        Text(
                          bestanden! ? 'BESTANDEN' : 'NICHT BESTANDEN',
                          style: AppTextStyles.monoLabel(accentColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Score in groß
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$score',
                          style: AppTextStyles.instrumentSerif(
                            size: 96,
                            color: text,
                            letterSpacing: -3,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: Text(
                            '%',
                            style: AppTextStyles.instrumentSerif(
                              size: 36,
                              color: textMid,
                              letterSpacing: -1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      bestanden!
                          ? 'Herzlichen Glückwunsch!'
                          : 'Leider nicht bestanden.',
                      style: AppTextStyles.instrumentSerif(
                        size: 24,
                        color: text,
                        letterSpacing: -0.6,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Performance Bar
                    _buildPerformanceBar(
                      accentColor,
                      surface,
                      border,
                      text,
                      textMid,
                      textDim,
                    ),
                    const SizedBox(height: 20),

                    // Stats
                    _buildStatsCard(
                      timeTakenFormatted,
                      surface,
                      border,
                      text,
                      textMid,
                      textDim,
                      accentColor,
                    ),

                    const SizedBox(height: 20),

                    // Auto-submitted Banner
                    if (_autoSubmitted) ...[
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.error.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.alarm_rounded,
                              color: AppColors.error,
                              size: 16,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Automatisch abgegeben — Zeit abgelaufen',
                                style: AppTextStyles.mono(
                                  size: 11,
                                  color: AppColors.error,
                                  weight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 52,
                            child: OutlinedButton.icon(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.arrow_back_rounded,
                                size: 14,
                                color: textMid,
                              ),
                              label: Text(
                                'Zurück',
                                style: AppTextStyles.mono(
                                  size: 11,
                                  color: textMid,
                                  weight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: border),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 52,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ZertifikatTestPage(
                                      zertifikatId: widget.zertifikatId,
                                      zertifikatName: widget.zertifikatName,
                                      anzahlFragen: widget.anzahlFragen,
                                      pruefungsdauer: widget.pruefungsdauer,
                                      mindestPunktzahl: widget.mindestPunktzahl,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.refresh_rounded, size: 16),
                              label: const Text('Nochmal'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: text,
                                foregroundColor: bg,
                                elevation: 0,
                                textStyle: AppTextStyles.labelLarge(bg),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceBar(
    Color accentColor,
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('DEINE LEISTUNG', style: AppTextStyles.monoSmall(textMid)),
              Text(
                '$score%',
                style: AppTextStyles.mono(
                  size: 14,
                  color: accentColor,
                  weight: FontWeight.w700,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: score! / 100,
                  minHeight: 10,
                  backgroundColor: border,
                  valueColor: AlwaysStoppedAnimation(accentColor),
                ),
              ),
              // Mindestpunktzahl Marker
              Positioned(
                left:
                    (widget.mindestPunktzahl / 100) *
                    (MediaQuery.of(context).size.width - 72),
                top: 0,
                bottom: 0,
                child: Container(width: 2, color: text),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0%', style: AppTextStyles.monoSmall(textDim)),
              Text(
                'MINDEST: ${widget.mindestPunktzahl}%',
                style: AppTextStyles.monoSmall(textMid),
              ),
              Text('100%', style: AppTextStyles.monoSmall(textDim)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(
    String time,
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
    Color accentColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          _statRow('ZERTIFIKAT', widget.zertifikatName, text, textMid),
          Divider(height: 1, color: border, indent: 14, endIndent: 14),
          _statRow(
            'BEANTWORTET',
            '${antworten.length} / ${fragen.length}',
            text,
            textMid,
          ),
          Divider(height: 1, color: border, indent: 14, endIndent: 14),
          _statRow('BENÖTIGTE ZEIT', time, text, textMid),
          Divider(height: 1, color: border, indent: 14, endIndent: 14),
          _statRow(
            'MINDESTPUNKTZAHL',
            '${widget.mindestPunktzahl}%',
            text,
            textMid,
          ),
        ],
      ),
    );
  }

  Widget _statRow(String label, String value, Color text, Color textMid) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.monoSmall(textMid)),
          Flexible(
            child: Text(
              value,
              style: AppTextStyles.mono(
                size: 12,
                color: text,
                weight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
