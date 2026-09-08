// lib/screens/module/test_fragen_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/frage_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../widgets/calculation_question_widget.dart';
import '../../widgets/fill_in_blank_widget.dart';
import '../../widgets/sequence_question_widget.dart';
import '../../widgets/report_dialog.dart';
import '../../services/sound_service.dart';
import '../../services/badge_service.dart';
import '../../widgets/badge_celebration_dialog.dart';
import '../../services/progress_service.dart';
import '../../services/spaced_repetition_service.dart';
import '../../services/flashcard_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';
import '../../services/question_validator.dart';
import '../../mixins/practice_limit_mixin.dart';
import '../../services/thema_score_service.dart';

class TestFragen extends StatefulWidget {
  final int modulId;
  final String modulName;
  final int themaId;

  /// Prozent, ab denen das Thema als bestanden gilt (themen.required_score).
  final int requiredScore;

  /// true, wenn in der Themenliste noch ein Thema folgt. Dann bietet der
  /// Ergebnis-Dialog bei Bestehen "Naechstes Thema" an; der Screen wird
  /// mit dem Ergebnis 'next' geschlossen, die Themenliste oeffnet es.
  final bool hatNaechstesThema;

  const TestFragen({
    super.key,
    required this.modulId,
    required this.modulName,
    required this.themaId,
    this.requiredScore = 80,
    this.hatNaechstesThema = false,
  });

  @override
  State<TestFragen> createState() => _TestFragenState();
}

class _TestFragenState extends State<TestFragen>
    with SingleTickerProviderStateMixin, PracticeLimitMixin<TestFragen> {
  final supabase = Supabase.instance.client;

  List<dynamic> fragen = [];
  int currentIndex = 0;
  bool loading = true;
  Set<int> beantworteteFragen = {};

  /// Nur die in DIESER Runde richtig beantworteten Fragen. Der
  /// Ergebnis-Dialog wertet ausschliesslich diese Menge, sonst zaehlen
  /// richtige Antworten aus frueheren Sitzungen mit und jede Runde
  /// zeigt 100 %.
  final Set<int> _rundeRichtig = {};

  /// Alle in dieser Runde beantworteten Fragen (richtig oder falsch) und
  /// die Groesse der vollstaendigen Runde. Wird lokal gespeichert, damit
  /// eine abgebrochene Runde beim naechsten Oeffnen fortgesetzt werden
  /// kann (Befund 08.09.2026: nach dem Schliessen ging es immer wieder
  /// bei Frage 1 los, mit der Sortierung nach Schwierigkeit erreichte man
  /// die schweren Fragen praktisch nie).
  final Set<int> _rundeBeantwortet = {};
  int _rundeGesamt = 0;

  String get _rundeKey => 'runde_${widget.modulId}_${widget.themaId}';
  int? selectedAnswer;
  bool hasAnswered = false;
  String? generatedExplanation;
  bool generatingExplanation = false;
  String? calculationAnswer;
  bool _flashcardSaved = false;

  final _soundService = SoundService();
  final _badgeService = BadgeService();
  final _progressService = ProgressService();
  final _spacedRepService = SpacedRepetitionService();
  final _flashcardService = FlashcardService();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _soundService.init();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
    _loadFragen();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  bool get _isCalculationQuestion {
    if (fragen.isEmpty || currentIndex >= fragen.length) return false;
    return fragen[currentIndex]['question_type'] == 'calculation';
  }

  bool get _isFillBlankQuestion {
    if (fragen.isEmpty || currentIndex >= fragen.length) return false;
    return fragen[currentIndex]['question_type'] == 'fill_blank';
  }

  bool get _isSequenceQuestion {
    if (fragen.isEmpty || currentIndex >= fragen.length) return false;
    return fragen[currentIndex]['question_type'] == 'sequence';
  }

  /// Anzeigename der Stufe der aktuellen Frage ('leicht'/'mittel'/'schwer').
  String? get _aktuelleStufe {
    if (fragen.isEmpty || currentIndex >= fragen.length) return null;
    switch ((fragen[currentIndex]['schwierigkeitsgrad'] as String?)
        ?.toLowerCase()
        .trim()) {
      case 'einfach':
      case 'leicht':
        return 'leicht';
      case 'mittel':
        return 'mittel';
      case 'schwer':
        return 'schwer';
      default:
        return null;
    }
  }

  Color _stufenFarbe(String stufe) {
    switch (stufe) {
      case 'leicht':
        return AppColors.success;
      case 'schwer':
        return AppColors.error;
      default:
        return AppColors.warning;
    }
  }

  /// Gruppiert nach Schwierigkeit (einfach -> mittel -> schwer, Unbekanntes
  /// wie "mittel") und mischt nur innerhalb der Gruppe.
  static List<dynamic> _nachSchwierigkeitSortiert(List<dynamic> fragen) {
    int stufe(dynamic f) {
      switch ((f['schwierigkeitsgrad'] as String?)?.toLowerCase().trim()) {
        case 'einfach':
        case 'leicht':
          return 0;
        case 'schwer':
          return 2;
        default:
          return 1;
      }
    }

    final gruppen = <int, List<dynamic>>{0: [], 1: [], 2: []};
    for (final f in fragen) {
      gruppen[stufe(f)]!.add(f);
    }
    return [
      for (final k in [0, 1, 2]) ...(gruppen[k]!..shuffle()),
    ];
  }

  Future<void> _loadFragen() async {
    // ─── LIMIT-CHECK für Free-User ─────────────────
    if (!await checkPracticeLimit(widget.modulId)) {
      if (mounted) setState(() => loading = false);
      return;
    }

    try {
      final res = await supabase
          .from('fragen')
          .select(
            'id, frage, question_type, calculation_data, schwierigkeitsgrad, antworten(id, text, ist_richtig, erklaerung)',
          )
          .eq('modul_id', widget.modulId)
          .eq('thema_id', widget.themaId);

      if (!mounted) return;

      // Reihenfolge: erst alle einfachen, dann mittel, dann schwer -
      // innerhalb einer Stufe gemischt. Vorher wurde alles komplett
      // gemischt, sodass die erste Frage eines Themas oft "schwer" war
      // (Befund 07.09.2026: Schwierigkeit wurde in der App nirgends genutzt).
      final frageListe = _nachSchwierigkeitSortiert(List<dynamic>.from(res));
      _rundeGesamt = frageListe.length;

      // Angefangene Runde? Dann fragen, ob fortgesetzt werden soll.
      await _rundeWiederherstellen(frageListe);
      if (!mounted) return;

      for (final frage in frageListe) {
        if (frage['antworten'] != null) {
          final antworten = List<dynamic>.from(frage['antworten']);
          antworten.shuffle();
          frage['antworten'] = antworten;
        }
      }

      setState(() {
        fragen = frageListe;
        loading = false;
      });
      QuestionValidator().validateQuestions(
        questions: frageListe,
        contextName: widget.modulName,
        contextType: 'modul',
      );

      await _loadProgress();
      _fadeController.forward(from: 0);
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

  /// Liest eine gespeicherte Runde. Passt sie zur aktuellen Fragenmenge
  /// und ist sie noch nicht fertig, wird der Nutzer gefragt; bei
  /// "Fortsetzen" fliegen die schon beantworteten Fragen aus der Liste.
  Future<void> _rundeWiederherstellen(List<dynamic> frageListe) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_rundeKey);
      if (json == null) return;
      final data = jsonDecode(json) as Map<String, dynamic>;
      final beantwortet = (data['beantwortet'] as List).cast<int>().toSet();
      final richtig = (data['richtig'] as List).cast<int>().toSet();
      final gesamt = data['gesamt'] as int;
      final ids = frageListe.map((f) => f['id'] as int).toSet();
      final offen = ids.difference(beantwortet);
      // Fragenmenge hat sich geaendert oder Runde war schon komplett:
      // Merker weg, normal starten.
      if (gesamt != ids.length ||
          beantwortet.isEmpty ||
          offen.isEmpty ||
          !ids.containsAll(beantwortet)) {
        await prefs.remove(_rundeKey);
        return;
      }
      if (!mounted) return;
      final fortsetzen = await _frageFortsetzen(beantwortet.length, gesamt);
      if (fortsetzen == true) {
        _rundeBeantwortet.addAll(beantwortet);
        _rundeRichtig.addAll(richtig);
        frageListe.removeWhere((f) => beantwortet.contains(f['id']));
      } else {
        await prefs.remove(_rundeKey);
      }
    } catch (e) {
      debugPrint('Runde konnte nicht wiederhergestellt werden: $e');
    }
  }

  Future<bool?> _frageFortsetzen(int beantwortet, int gesamt) {
    final isDark = context.read<ThemeProvider>().isDark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
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
                  Container(width: 16, height: 1, color: AppColors.accent),
                  const SizedBox(width: 10),
                  Text(
                    'ANGEFANGENE RUNDE',
                    style: AppTextStyles.monoLabel(AppColors.accent),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Weitermachen?',
                style: AppTextStyles.instrumentSerif(
                  size: 32,
                  color: text,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Du hast $beantwortet von $gesamt Fragen beantwortet. '
                'Fortsetzen zeigt nur die restlichen ${gesamt - beantwortet}.',
                style: AppTextStyles.bodyMedium(textMid),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textMid,
                        side: BorderSide(color: textDim.withOpacity(0.3)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Von vorn'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: text,
                        foregroundColor: bg,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: AppTextStyles.labelLarge(bg),
                      ),
                      child: const Text('Fortsetzen'),
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

  Future<void> _rundeSpeichern() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _rundeKey,
        jsonEncode({
          'beantwortet': _rundeBeantwortet.toList(),
          'richtig': _rundeRichtig.toList(),
          'gesamt': _rundeGesamt,
        }),
      );
    } catch (e) {
      debugPrint('Runde konnte nicht gespeichert werden: $e');
    }
  }

  Future<void> _rundeLoeschen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_rundeKey);
    } catch (_) {}
  }

  Future<void> _loadProgress() async {
    try {
      final answered = await _progressService.getCorrectFragen(widget.modulId);
      setState(() => beantworteteFragen = answered);
    } catch (e) {
      debugPrint('Fehler beim Laden des Fortschritts: $e');
    }
  }

  Future<void> _saveProgress(int frageId, bool isCorrect) async {
    try {
      await _progressService.saveAnswer(
        modulId: widget.modulId,
        themaId: widget.themaId,
        frageId: frageId,
        isCorrect: isCorrect,
      );
      if (isCorrect) {
        beantworteteFragen.add(frageId);
        _rundeRichtig.add(frageId);
      }
    } catch (e) {
      debugPrint('Fehler beim Speichern: $e');
    }
    _rundeBeantwortet.add(frageId);
    await _rundeSpeichern();
  }

  Future<void> _saveFlashcardIfWrong({
    required int frageId,
    required String frageText,
    required List antworten,
  }) async {
    final richtigeAntwort = antworten.firstWhere(
      (a) => a['ist_richtig'] == true,
      orElse: () => null,
    );
    if (richtigeAntwort == null) return;

    final parts = widget.modulName.split(' • ');
    final modulName = parts.isNotEmpty ? parts[0] : widget.modulName;
    final themaName = parts.length > 1 ? parts[1] : null;

    await _flashcardService.createFromWrongAnswer(
      frageId: frageId,
      frageText: frageText,
      richtigeAntwort: richtigeAntwort['text'] as String,
      modulName: modulName,
      themaName: themaName,
    );

    if (mounted) setState(() => _flashcardSaved = true);
  }

  void _checkAnswer(int answerId) async {
    if (hasAnswered) return;

    // Counter erhöhen für Free-User
    await recordPracticeAnswer(widget.modulId);

    setState(() {
      selectedAnswer = answerId;
      hasAnswered = true;
      generatedExplanation = null;
      _flashcardSaved = false;
    });

    final frage = fragen[currentIndex];
    final antworten = frage['antworten'] as List;
    final selected = antworten.firstWhere((a) => a['id'] == answerId);
    final isCorrect = selected['ist_richtig'] == true;

    if (isCorrect) {
      _soundService.playSound(SoundType.correct);
    } else {
      _soundService.playSound(SoundType.wrong);
      await _saveFlashcardIfWrong(
        frageId: frage['id'],
        frageText: frage['frage'] as String,
        antworten: antworten,
      );
    }

    await _saveProgress(frage['id'], isCorrect);
    await _spacedRepService.recordAnswer(
      frageId: frage['id'],
      isCorrect: isCorrect,
    );

    if (!isCorrect &&
        (selected['erklaerung'] == null ||
            selected['erklaerung'].toString().trim().isEmpty)) {
      _generateExplanation(frage, antworten);
    }
  }

  void _handleCalculationAnswer(bool isCorrect, String? userAnswer) async {
    if (hasAnswered) return;

    // Counter erhöhen für Free-User
    await recordPracticeAnswer(widget.modulId);

    setState(() {
      hasAnswered = true;
      calculationAnswer = userAnswer;
      _flashcardSaved = false;
    });
    if (isCorrect) {
      _soundService.playSound(SoundType.correct);
    } else {
      _soundService.playSound(SoundType.wrong);
    }
    final frage = fragen[currentIndex];
    await _saveProgress(frage['id'], isCorrect);
    await _spacedRepService.recordAnswer(
      frageId: frage['id'],
      isCorrect: isCorrect,
    );
  }

  Future<void> _generateExplanation(
    Map<String, dynamic> frage,
    List antworten,
  ) async {
    setState(() {
      generatingExplanation = true;
      generatedExplanation = null;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    final correctAnswer = antworten.firstWhere(
      (a) => a['ist_richtig'] == true,
      orElse: () => null,
    );

    setState(() {
      generatedExplanation = correctAnswer == null
          ? 'Die richtige Antwort konnte nicht ermittelt werden.'
          : 'Die richtige Antwort ist: "${correctAnswer['text']}".';
      generatingExplanation = false;
    });
  }

  void _nextQuestion() async {
    if (currentIndex < fragen.length - 1) {
      await _fadeController.reverse();
      setState(() {
        currentIndex++;
        selectedAnswer = null;
        hasAnswered = false;
        generatedExplanation = null;
        calculationAnswer = null;
        _flashcardSaved = false;
      });
      await _fadeController.forward();
    } else {
      _showCompletionDialog();
    }
  }

  void _previousQuestion() async {
    if (currentIndex > 0) {
      await _fadeController.reverse();
      setState(() {
        currentIndex--;
        selectedAnswer = null;
        hasAnswered = false;
        generatedExplanation = null;
        calculationAnswer = null;
        _flashcardSaved = false;
      });
      await _fadeController.forward();
    }
  }

  /// Speichert das beste Runden-Ergebnis dieses Themas, lokal und in
  /// der Cloud (ueberlebt damit Logout und Geraetewechsel).
  Future<void> _besteScoreSpeichern(int prozent) async {
    await ThemaScoreService().speichern(
      modulId: widget.modulId,
      themaId: widget.themaId,
      prozent: prozent.toDouble(),
    );
  }

  void _showCompletionDialog() {
    final isDark = context.read<ThemeProvider>().isDark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

    // Runde ist fertig: Merker loeschen, sonst wuerde beim naechsten
    // Oeffnen "Fortsetzen" angeboten.
    _rundeLoeschen();

    // _rundeRichtig enthaelt nur Fragen dieser Runde (inkl. eines
    // fortgesetzten Teils), _rundeGesamt die volle Rundengroesse.
    final richtigInSession = _rundeRichtig.length;
    final gesamt = _rundeGesamt > 0 ? _rundeGesamt : fragen.length;
    final prozent = ((richtigInSession / gesamt) * 100).toInt();
    final bestanden = prozent >= widget.requiredScore;
    final zeigeNaechstes = bestanden && widget.hatNaechstesThema;

    // Bestes Ergebnis sichern: Die Themenliste liest genau diesen
    // Schluessel fuer "bestanden", Ø-Score und die Freischaltung des
    // naechsten Themas. Ohne diese Zeile blieb der Score fuer immer 0
    // (Kunden-Bugreport 22.08.2026).
    _besteScoreSpeichern(prozent);

    Color color;
    String bewertung;

    if (prozent >= 90) {
      bewertung = 'Hervorragend.';
      color = AppColors.accentCyan;
    } else if (prozent >= 70) {
      bewertung = 'Gut gemacht.';
      color = AppColors.success;
    } else if (prozent >= 50) {
      bewertung = 'Nicht schlecht.';
      color = AppColors.warning;
    } else {
      bewertung = 'Weiter üben.';
      color = AppColors.error;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
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
                  Container(width: 16, height: 1, color: color),
                  const SizedBox(width: 10),
                  Text('ERGEBNIS', style: AppTextStyles.monoLabel(color)),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                bewertung,
                style: AppTextStyles.instrumentSerif(
                  size: 32,
                  color: text,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$prozent',
                    style: AppTextStyles.instrumentSerif(
                      size: 56,
                      color: color,
                      letterSpacing: -2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      '%',
                      style: AppTextStyles.instrumentSerif(
                        size: 30,
                        color: color,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '$richtigInSession / $gesamt Fragen richtig',
                style: AppTextStyles.monoSmall(textDim),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: richtigInSession / gesamt,
                  backgroundColor: textDim.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation(color),
                  minHeight: 3,
                ),
              ),
              if (!bestanden && widget.hatNaechstesThema) ...[
                const SizedBox(height: 10),
                Text(
                  'Ziel: ${widget.requiredScore} % schalten das nächste Thema frei.',
                  style: AppTextStyles.monoSmall(textDim),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  // Links: bei Bestehen "Nochmal" als Nebenweg, sonst "Zurueck".
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        if (bestanden) {
                          _nochmal();
                        } else {
                          await _checkModuleBadgesAndPop();
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textMid,
                        side: BorderSide(color: textDim.withOpacity(0.3)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(bestanden ? 'Nochmal' : 'Zurück'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Rechts (Hauptweg): naechstes Thema / fertig / nochmal.
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        if (zeigeNaechstes) {
                          await _checkModuleBadgesAndPop(result: 'next');
                        } else if (bestanden) {
                          await _checkModuleBadgesAndPop();
                        } else {
                          _nochmal();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: text,
                        foregroundColor: bg,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: AppTextStyles.labelLarge(bg),
                      ),
                      child: Text(
                        zeigeNaechstes
                            ? 'Nächstes Thema'
                            : (bestanden ? 'Fertig' : 'Nochmal'),
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

  /// Neue Runde: alle Zaehler zuruecksetzen und die volle Fragenliste
  /// neu laden (nach "Fortsetzen" war sie auf die offenen Fragen gekuerzt).
  void _nochmal() {
    _rundeRichtig.clear();
    _rundeBeantwortet.clear();
    setState(() {
      loading = true;
      currentIndex = 0;
      selectedAnswer = null;
      hasAnswered = false;
      generatedExplanation = null;
      calculationAnswer = null;
      _flashcardSaved = false;
    });
    _loadFragen();
  }

  Future<void> _checkModuleBadgesAndPop({String? result}) async {
    try {
      final completedModules = await _progressService
          .getCompletedModulesCount();
      final newBadges = await _badgeService.checkModuleBadges(completedModules);

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
      debugPrint('Badge-Fehler: $e');
    }
    if (mounted) Navigator.pop(context, result);
  }

  /// Position in der gesamten Runde, auch nach "Fortsetzen" (dann ist
  /// `fragen` nur der Rest).
  int get _frageNummer => _rundeGesamt - fragen.length + currentIndex + 1;
  int get _frageAnzahl => _rundeGesamt > 0 ? _rundeGesamt : fragen.length;

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;

    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: [
          _buildHeader(text, textMid, textDim, border, surface),

          // Progress Bar
          if (!loading && fragen.isNotEmpty)
            LinearProgressIndicator(
              value: _frageNummer / _frageAnzahl,
              backgroundColor: border,
              valueColor: const AlwaysStoppedAnimation(AppColors.accent),
              minHeight: 2,
            ),

          // Content
          Expanded(
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.accent),
                  )
                : fragen.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.inbox_outlined, size: 48, color: textDim),
                        const SizedBox(height: 16),
                        Text(
                          'Keine Fragen verfügbar',
                          style: AppTextStyles.h3(textMid),
                        ),
                      ],
                    ),
                  )
                : FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildQuestionContent(
                      surface,
                      border,
                      text,
                      textMid,
                      textDim,
                    ),
                  ),
          ),

          if (!loading && fragen.isNotEmpty)
            _buildNavigationBar(bg, surface, border, text, textMid, textDim),
        ],
      ),
    );
  }

  // ─── HEADER ──────────────────────────────────
  Widget _buildHeader(
    Color text,
    Color textMid,
    Color textDim,
    Color border,
    Color surface,
  ) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.close_rounded, color: text, size: 22),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.modulName,
                    style: AppTextStyles.labelMedium(textMid),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!loading && fragen.isNotEmpty)
                    Row(
                      children: [
                        Text(
                          'FRAGE ${_frageNummer.toString().padLeft(2, '0')} / ${_frageAnzahl.toString().padLeft(2, '0')}',
                          style: AppTextStyles.monoSmall(textDim),
                        ),
                        // Stufe der aktuellen Frage: Fragen laufen aufsteigend
                        // (einfach -> mittel -> schwer), so sieht man, wann
                        // es schwerer wird.
                        if (_aktuelleStufe != null) ...[
                          Text('  ·  ', style: AppTextStyles.monoSmall(textDim)),
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _stufenFarbe(_aktuelleStufe!),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            _aktuelleStufe!.toUpperCase(),
                            style: AppTextStyles.mono(
                              size: 10,
                              color: _stufenFarbe(_aktuelleStufe!),
                              weight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ],
                    ),
                ],
              ),
            ),
            if (!loading && fragen.isNotEmpty)
              IconButton(
                onPressed: () {
                  if (currentIndex >= fragen.length) return;
                  final frageId = fragen[currentIndex]['id'] as int;
                  showDialog(
                    context: context,
                    builder: (context) => ReportDialog(
                      frageId: frageId,
                      screenType: 'test_fragen',
                    ),
                  );
                },
                icon: Icon(Icons.flag_outlined, color: textMid, size: 20),
                tooltip: 'Problem melden',
              ),
          ],
        ),
      ),
    );
  }

  // ─── QUESTION CONTENT ────────────────────────
  Widget _buildQuestionContent(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    final frage = fragen[currentIndex];

    // Special Widgets für andere Frage-Typen
    if (_isCalculationQuestion) {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: CalculationQuestionWidget(
          key: ValueKey('calc_$currentIndex'),
          questionText: frage['frage'] ?? '',
          calculationData: frage['calculation_data'] ?? {},
          onAnswerSubmitted: _handleCalculationAnswer,
        ),
      );
    }

    if (_isFillBlankQuestion) {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: FillInTheBlankWidget(
          key: ValueKey('fillblank_$currentIndex'),
          questionText: frage['frage'] ?? '',
          blankData: frage['calculation_data'] ?? {},
          onAnswerSubmitted: (isCorrect, userAnswers) {
            _handleCalculationAnswer(isCorrect, userAnswers.toString());
          },
        ),
      );
    }

    if (_isSequenceQuestion) {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: SequenceQuestionWidget(
          key: ValueKey('sequence_$currentIndex'),
          questionText: frage['frage'] ?? '',
          sequenceData: frage['calculation_data'] ?? {},
          onAnswerSubmitted: (isCorrect, userOrder) {
            _handleCalculationAnswer(isCorrect, userOrder.toString());
          },
        ),
      );
    }

    final antworten = frage['antworten'] as List;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Label
          Row(
            children: [
              Container(width: 16, height: 1, color: AppColors.accent),
              const SizedBox(width: 10),
              Text('FRAGE', style: AppTextStyles.monoLabel(AppColors.accent)),
            ],
          ),
          const SizedBox(height: 14),

          // Frage (groß, Instrument Serif)
          FrageText(
            frage['frage'] ?? '',
            style: AppTextStyles.instrumentSerif(
              size: 26,
              color: text,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 28),

          // Antwort-Optionen
          ...antworten.asMap().entries.map((entry) {
            final index = entry.key;
            final antwort = entry.value;
            return _buildAnswerTile(
              antwort: antwort,
              index: index,
              surface: surface,
              border: border,
              text: text,
              textMid: textMid,
            );
          }),

          // Flashcard-Hinweis
          if (hasAnswered && _flashcardSaved) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.accent.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.bookmark_outline_rounded,
                    color: AppColors.accent,
                    size: 16,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Flashcard gespeichert — übe sie später.',
                      style: AppTextStyles.bodySmall(text),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Erklärung
          if (hasAnswered && !_isCalculationQuestion) ...[
            const SizedBox(height: 20),
            _buildExplanation(
              antworten,
              surface,
              border,
              text,
              textMid,
              textDim,
            ),
          ],
        ],
      ),
    );
  }

  // ─── ANSWER TILE ─────────────────────────────
  Widget _buildAnswerTile({
    required Map<String, dynamic> antwort,
    required int index,
    required Color surface,
    required Color border,
    required Color text,
    required Color textMid,
  }) {
    final answerId = antwort['id'] as int;
    final isSelected = selectedAnswer == answerId;
    final isCorrect = antwort['ist_richtig'] == true;
    final showResult = hasAnswered && isSelected;
    final showCorrect = hasAnswered && !isSelected && isCorrect;

    // Border Farbe
    Color borderColor = border;
    Color bgColor = surface;
    Color letterColor = textMid;
    Color letterBg = border;

    if (showResult) {
      // Selected mit Feedback
      if (isCorrect) {
        borderColor = AppColors.success;
        bgColor = AppColors.success.withOpacity(0.05);
        letterColor = Colors.white;
        letterBg = AppColors.success;
      } else {
        borderColor = AppColors.error;
        bgColor = AppColors.error.withOpacity(0.05);
        letterColor = Colors.white;
        letterBg = AppColors.error;
      }
    } else if (showCorrect) {
      // Die richtige Antwort, wenn User falsch gewählt hat
      borderColor = AppColors.success.withOpacity(0.5);
      bgColor = AppColors.success.withOpacity(0.04);
      letterColor = AppColors.success;
      letterBg = AppColors.success.withOpacity(0.15);
    } else if (isSelected) {
      // Vorher selected (ohne Answer)
      borderColor = AppColors.accent;
      letterColor = Colors.white;
      letterBg = AppColors.accent;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: hasAnswered ? null : () => _checkAnswer(answerId),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Letter or Status-Icon
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: letterBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: showResult
                        ? Icon(
                            isCorrect
                                ? Icons.check_rounded
                                : Icons.close_rounded,
                            color: letterColor,
                            size: 16,
                          )
                        : showCorrect
                        ? Icon(
                            Icons.check_rounded,
                            color: letterColor,
                            size: 16,
                          )
                        : Text(
                            String.fromCharCode(65 + index),
                            style: AppTextStyles.mono(
                              size: 12,
                              color: letterColor,
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
                    child: FrageText(
                      antwort['text'] ?? '',
                      codeSize: 13,
                      style: AppTextStyles.interTight(
                        size: 15,
                        weight: isSelected || showCorrect
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
      ),
    );
  }

  // ─── EXPLANATION ─────────────────────────────
  Widget _buildExplanation(
    List antworten,
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    final selectedAnt = antworten.firstWhere(
      (a) => a['id'] == selectedAnswer,
      orElse: () => null,
    );
    if (selectedAnt == null) return const SizedBox.shrink();

    final isCorrect = selectedAnt['ist_richtig'] == true;
    final explanation = selectedAnt['erklaerung'];
    final hasExplanation =
        explanation != null && explanation.toString().trim().isNotEmpty;

    final accentColor = isCorrect ? AppColors.success : AppColors.warning;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.015, 0.015, 1.0],
          colors: [accentColor, accentColor, surface, surface],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect
                    ? Icons.check_circle_outline_rounded
                    : Icons.lightbulb_outline_rounded,
                color: accentColor,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                isCorrect ? 'RICHTIG' : 'ERKLÄRUNG',
                style: AppTextStyles.mono(
                  size: 11,
                  color: accentColor,
                  weight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (hasExplanation)
            Text(explanation, style: AppTextStyles.bodyMedium(text))
          else if (generatingExplanation)
            Row(
              children: [
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(accentColor),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Generiere Erklärung...',
                  style: AppTextStyles.bodySmall(textMid),
                ),
              ],
            )
          else if (generatedExplanation != null)
            Text(generatedExplanation!, style: AppTextStyles.bodyMedium(text)),
        ],
      ),
    );
  }

  // ─── NAV BAR ─────────────────────────────────
  Widget _buildNavigationBar(
    Color bg,
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    final isLast = currentIndex >= fragen.length - 1;

    return Container(
      decoration: BoxDecoration(
        color: surface,
        border: Border(top: BorderSide(color: border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Row(
            children: [
              if (currentIndex > 0)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _previousQuestion,
                    icon: const Icon(Icons.arrow_back_rounded, size: 16),
                    label: const Text('Zurück'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: textMid,
                      side: BorderSide(color: border),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              if (currentIndex > 0) const SizedBox(width: 10),
              Expanded(
                flex: currentIndex > 0 ? 2 : 1,
                child: ElevatedButton.icon(
                  onPressed: hasAnswered ? _nextQuestion : null,
                  icon: Icon(
                    isLast ? Icons.check_rounded : Icons.arrow_forward_rounded,
                    size: 16,
                  ),
                  label: Text(isLast ? 'Abschließen' : 'Weiter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: text,
                    foregroundColor: bg,
                    disabledBackgroundColor: border,
                    disabledForegroundColor: textDim,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
