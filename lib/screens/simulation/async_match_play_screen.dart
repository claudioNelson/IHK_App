import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/async_duel_service.dart';
import '../../../async_match_progress.dart';
import 'dart:async';
import '../../../widgets/report_dialog.dart';
import '../../../services/sound_service.dart';
import '../../services/badge_service.dart';
import '../../widgets/badge_celebration_dialog.dart';
import '../../widgets/dialogs/match_status_dialog.dart';
import '../../widgets/user_avatar.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';

class AsyncMatchPlayPage extends StatefulWidget {
  final String matchId;
  /// true = nur Ergebnis eines beendeten Matches anzeigen (aus der Historie),
  /// ohne Sounds/Badge-Check und ohne Fragen zu laden.
  final bool showResult;
  const AsyncMatchPlayPage({
    super.key,
    required this.matchId,
    this.showResult = false,
  });

  @override
  State<AsyncMatchPlayPage> createState() => _AsyncMatchPlayPageState();
}

class _AsyncMatchPlayPageState extends State<AsyncMatchPlayPage> {
  final _svc = AsyncDuelService();
  final _soundService = SoundService();

  AsyncMatchProgressStore? _store;
  AsyncMatchProgress? _progress;

  List<dynamic> _questions = [];
  int _idx = 0;
  bool _loading = true;

  bool _answered = false;
  bool _submitting = false;
  bool _wasCorrect = false;
  int? _selectedAnswerId;
  bool _waitingForOpponent = false;

  Map<int, String> _fillBlankAnswers = {};
  List<String> _sequenceOrder = [];
  Map<int, List<dynamic>> _shuffledAnswers = {};
  final Map<int, TextEditingController> _freitextControllers = {};

  bool _matchCompleted = false;
  Map<String, dynamic>? _finalScores;

  Timer? _timer;
  int _timeLeft = 30;
  final int _maxTime = 30;

  /// Zeit je Fragetyp: Antippen geht in 30 s, Sortieren und Tippen
  /// brauchen mehr Luft. Freitext ist aus der Arena verbannt, bekommt
  /// aber fuer Alt-Matches trotzdem einen fairen Wert.
  int _zeitFuerTyp(String typ) {
    switch (typ) {
      case 'sequence':
      case 'fill_blank':
        return 60;
      case 'freitext_ada':
        return 120;
      default:
        return _maxTime;
    }
  }
  final _badgeService = BadgeService();

  String get _userId =>
      Supabase.instance.client.auth.currentUser?.id ?? 'local';

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _stopTimer();
    for (final c in _freitextControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _init() async {
    if (widget.showResult) {
      await _zeigeErgebnisAusHistorie();
      return;
    }
    try {
      await _soundService.init();
      _store ??= await AsyncMatchProgressStore.instance;
      _progress = await _store!.ensure(_userId, widget.matchId);

      final data = await _svc.loadMatch(widget.matchId);
      final q = (data['questions'] as List<dynamic>).toList()
        ..sort((a, b) => (a['idx'] as int).compareTo(b['idx'] as int));
      _questions = q;

      final myAnswers = data['myAnswers'] as List<dynamic>;
      if (myAnswers.length >= _questions.length) {
        await _tryFinalize();
        return;
      }

      // Der Server ist die Wahrheit: weiter bei der ersten Frage, fuer
      // die dort noch KEINE Antwort von mir liegt.
      final answeredIdxs = myAnswers.map((a) => a['idx'] as int).toSet();
      int? ersteOffene;
      for (int i = 0; i < _questions.length; i++) {
        final qIdx = _questions[i]['idx'] as int;
        if (!answeredIdxs.contains(qIdx)) {
          ersteOffene = i;
          break;
        }
      }

      // Alle Frage-Idx sind schon beantwortet (frueher fiel dieser Fall
      // stumm auf Frage 1 zurueck, die dann "nicht akzeptiert" wurde):
      // Match direkt abschliessen bzw. auf den Gegner warten.
      if (ersteOffene == null) {
        await _tryFinalize();
        return;
      }

      _idx = ersteOffene;
      _progress!.currentIdx = _idx;
      await _store!.save(_progress!);

      _startTimer();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Laden: $e'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = _zeitFuerTyp(_getQuestionType());

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _timeLeft--);
      if (_timeLeft <= 0) {
        timer.cancel();
        _onTimeUp();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  Future<void> _onTimeUp() async {
    if (_answered || _submitting) return;
    _soundService.playSound(SoundType.timeUp);

    setState(() {
      _submitting = true;
      _answered = true;
      _wasCorrect = false;
      _selectedAnswerId = null;
    });

    // Zeitablauf muss serverseitig als (falsche) Antwort landen, sonst hat
    // der Server nur 9/10 Antworten und das Match wird nie ausgewertet.
    final q = _questions[_idx];
    try {
      final ok = await _svc.submitAnswer(
        matchId: widget.matchId,
        idx: q['idx'] as int,
        answerId: AsyncDuelService.sentinelAnswerId,
        isCorrect: false,
      );
      if (!mounted) return;
      if (!ok) {
        // Antwort lag schon vor (z. B. Doppel-Tap kurz vor Ablauf) -> Stand
        // vom Server holen; _nachAblehnungNeuSyncen springt selbst weiter.
        setState(() => _answered = false);
        await _nachAblehnungNeuSyncen();
        return;
      }
      _progress!.answers[_idx] = AsyncDuelService.sentinelAnswerId;
      await _store!.save(_progress!);
    } catch (_) {
      // Netzfehler: NICHT lokal weiterspringen (sonst fehlt die Antwort auf
      // dem Server). Stand abgleichen; klappt auch das nicht, bleibt die
      // Frage offen und der Nutzer kann sie manuell beantworten.
      if (!mounted) return;
      setState(() => _answered = false);
      await _nachAblehnungNeuSyncen();
      return;
    } finally {
      if (mounted) setState(() => _submitting = false);
    }

    if (!mounted) return;
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) _next();
    });
  }

  Future<void> _submitMultipleChoice(int answerId, bool correct) async {
    if (_submitting || _answered) return;
    _stopTimer();

    setState(() {
      _submitting = true;
      _selectedAnswerId = answerId;
    });

    final q = _questions[_idx];

    try {
      // Pseudo-Antworten (Optionen aus calculation_data, z. B. DNS/Ports
      // oder Schluessel-Fragen) tragen nur ihren Listen-Index 0..3 als id.
      // Diese Ids gibt es in der antworten-Tabelle nicht; Index 0 crashte
      // mit einem FK-Fehler. Fuer solche Fragen wird wie bei den
      // Spezialfragen die Sentinel-Id gespeichert und richtig/falsch explizit
      // mitgeschickt (die Sentinel-Zeile in `antworten` ist zufaellig eine
      // richtige Antwort!). Echte antworten-Ids sind immer deutlich groesser
      // und werden weiterhin serverseitig nachgeschlagen.
      final istPseudoId = answerId < 100;

      final ok = await _svc.submitAnswer(
        matchId: widget.matchId,
        idx: q['idx'] as int,
        answerId: istPseudoId ? AsyncDuelService.sentinelAnswerId : answerId,
        isCorrect: istPseudoId ? correct : null,
      );

      if (!ok) {
        // "Nicht akzeptiert" heisst: die Antwort liegt serverseitig schon
        // vor (oder das Match existiert nicht mehr). Statt rotem Fehler:
        // Stand vom Server holen und zur naechsten offenen Frage springen.
        await _nachAblehnungNeuSyncen();
        return;
      }

      _progress!.answers[_idx] = answerId;
      await _store!.save(_progress!);

      setState(() {
        _answered = true;
        _wasCorrect = correct;
      });

      if (correct) {
        _soundService.playSound(SoundType.correct);
      } else {
        _soundService.playSound(SoundType.wrong);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler: $e'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() {
        _submitting = false;
        _selectedAnswerId = null;
      });
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _submitSpecialQuestion(
    bool isCorrect,
    dynamic userAnswer,
  ) async {
    if (_submitting || _answered) return;
    _stopTimer();

    setState(() => _submitting = true);

    final q = _questions[_idx];

    try {
      // Sonderfragen haben keine antworten-Zeile -> Sentinel-Id plus das
      // in der App ermittelte Ergebnis (sonst wertet der Server immer "richtig").
      final ok = await _svc.submitAnswer(
        matchId: widget.matchId,
        idx: q['idx'] as int,
        answerId: AsyncDuelService.sentinelAnswerId,
        isCorrect: isCorrect,
      );

      if (!ok) {
        // Gleiches Netz wie bei Multiple Choice: Server-Stand holen und
        // weiterspringen statt Fehlermeldung.
        await _nachAblehnungNeuSyncen();
        return;
      }

      _progress!.answers[_idx] = AsyncDuelService.sentinelAnswerId;
      await _store!.save(_progress!);

      setState(() {
        _answered = true;
        _wasCorrect = isCorrect;
      });

      if (isCorrect) {
        _soundService.playSound(SoundType.correct);
      } else {
        _soundService.playSound(SoundType.wrong);
      }

      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) _next();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler: $e'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() => _submitting = false);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  /// Der Server hat eine Antwort abgelehnt ("schon beantwortet" oder
  /// Match existiert nicht mehr). Frischen Stand laden und den Nutzer
  /// sinnvoll weiterbringen, statt ihn an der Frage festzunageln.
  Future<void> _nachAblehnungNeuSyncen() async {
    try {
      final data = await _svc.loadMatch(widget.matchId);
      final qs = (data['questions'] as List<dynamic>).toList()
        ..sort((a, b) => (a['idx'] as int).compareTo(b['idx'] as int));

      // Match ist serverseitig weg (z. B. aufgeraeumt): zurueck zur Liste.
      if (qs.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Dieses Match existiert nicht mehr'),
            backgroundColor: AppColors.warning,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context).pop();
        return;
      }

      _questions = qs;
      final myAnswers = data['myAnswers'] as List<dynamic>;
      final answeredIdxs = myAnswers.map((a) => a['idx'] as int).toSet();

      int? ersteOffene;
      for (int i = 0; i < _questions.length; i++) {
        final qIdx = _questions[i]['idx'] as int;
        if (!answeredIdxs.contains(qIdx)) {
          ersteOffene = i;
          break;
        }
      }

      if (ersteOffene == null) {
        // Alles beantwortet: abschliessen bzw. auf den Gegner warten.
        if (mounted) setState(() => _submitting = false);
        await _tryFinalize();
        return;
      }

      if (!mounted) return;
      setState(() {
        _idx = ersteOffene!;
        _submitting = false;
        _answered = false;
        _wasCorrect = false;
        _selectedAnswerId = null;
        _fillBlankAnswers = {};
        _sequenceOrder = [];
      });

      _progress!.currentIdx = _idx;
      await _store!.save(_progress!);
      _startTimer();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Abgleich: $e'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() {
        _submitting = false;
        _selectedAnswerId = null;
      });
    }
  }

  Future<void> _next() async {
    if (_idx + 1 >= _questions.length) {
      await _tryFinalize();
      return;
    }

    setState(() {
      _idx++;
      _answered = false;
      _wasCorrect = false;
      _selectedAnswerId = null;
      _fillBlankAnswers = {};
      _sequenceOrder = [];
    });

    _progress!.currentIdx = _idx;
    await _store!.save(_progress!);
    _startTimer();
  }

  /// Historie: Ergebnis eines bereits beendeten Matches laden (nur match_scores
  /// + Profile), keine RPC, keine Fragen.
  Future<void> _zeigeErgebnisAusHistorie() async {
    try {
      final scores = await _svc.loadScores(widget.matchId);
      if (!mounted) return;
      if (scores == null) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Für dieses Match liegt kein Ergebnis vor.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        if (ModalRoute.of(context)?.isCurrent == true) {
          Navigator.of(context).pop();
        }
        return;
      }
      setState(() {
        _matchCompleted = true;
        _finalScores = scores;
        _waitingForOpponent = false;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ergebnis konnte nicht geladen werden: $e'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      if (ModalRoute.of(context)?.isCurrent == true) {
        Navigator.of(context).pop();
      }
    }
  }

  /// "Status pruefen" im Wartebildschirm: Ist der Gegner fertig, rendert
  /// _tryFinalize automatisch das Ergebnis. Sonst zeigt ein Dialog den
  /// eigenen Zwischenstand mit beiden Profilbildern.
  bool _checking = false;

  Future<void> _pruefeStatus() async {
    if (_checking) return;
    setState(() => _checking = true);
    await _tryFinalize();
    if (!mounted) return;
    if (_matchCompleted) {
      setState(() => _checking = false);
      return;
    }
    Map<String, dynamic>? status;
    try {
      status = await _svc.loadWaitingStatus(widget.matchId);
    } catch (_) {
      status = null;
    }
    if (!mounted) return;
    setState(() => _checking = false);
    if (status == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dein Gegner ist noch nicht fertig.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    await showMatchStatusDialog(
      context,
      status: status,
      isDark: context.read<ThemeProvider>().isDark,
    );
  }

  Future<void> _tryFinalize() async {
    try {
      final status = await _svc.tryFinalize(widget.matchId);
      if (!mounted) return;
      if (status == 'completed' || status == 'finalized') {
        final scores = await _svc.loadScores(widget.matchId);
        if (!mounted) return;
        setState(() {
          _matchCompleted = true;
          _finalScores = scores;
          // Wartebildschirm hat in build() Vorrang -> hier zuruecksetzen,
          // sonst bleibt "Warte auf Gegner" trotz fertigem Match stehen.
          _waitingForOpponent = false;
        });
      } else if (status == 'waiting') {
        if (!mounted) return;
        setState(() => _waitingForOpponent = true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Abschluss: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  String _getQuestionType() {
    final q = _questions[_idx];
    final frageData = q['fragen'];
    return frageData['question_type'] as String? ?? 'multiple_choice';
  }

  Color _timerColor() {
    if (_timeLeft <= 5) return AppColors.error;
    if (_timeLeft <= 10) return AppColors.warning;
    return AppColors.accent;
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

    if (_loading) {
      return Scaffold(
        backgroundColor: bg,
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      );
    }

    if (_waitingForOpponent) {
      return _buildWaitingScreen(bg, surface, border, text, textMid, textDim);
    }

    if (_matchCompleted && _finalScores != null) {
      return _buildResultScreen(bg, surface, border, text, textMid, textDim);
    }

    if (_questions.isEmpty) {
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

    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: [
          // ─── APPBAR ─────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
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
                          'ASYNC MATCH',
                          style: AppTextStyles.monoLabel(textMid),
                        ),
                        Text(
                          'FRAGE ${(_idx + 1).toString().padLeft(2, '0')} / ${_questions.length.toString().padLeft(2, '0')}',
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
                      color: _timerColor().withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _timerColor().withOpacity(0.4)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _timeLeft <= 5
                              ? Icons.alarm_rounded
                              : Icons.timer_outlined,
                          size: 13,
                          color: _timerColor(),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${_timeLeft}s',
                          style: AppTextStyles.mono(
                            size: 12,
                            color: _timerColor(),
                            weight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Report Button
                  IconButton(
                    onPressed: () {
                      if (_questions.isEmpty || _idx >= _questions.length) {
                        return;
                      }
                      final q = _questions[_idx];
                      final frageId = q['fragen']['id'] as int;
                      showDialog(
                        context: context,
                        builder: (context) => ReportDialog(
                          frageId: frageId,
                          screenType: 'async_match',
                        ),
                      );
                    },
                    icon: Icon(Icons.flag_outlined, color: textMid, size: 20),
                  ),
                ],
              ),
            ),
          ),

          // ─── PROGRESS BAR ───────────────────
          LinearProgressIndicator(
            value: (_idx + 1) / _questions.length,
            backgroundColor: border,
            valueColor: const AlwaysStoppedAnimation(AppColors.accent),
            minHeight: 2,
          ),

          // ─── CONTENT ────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: _buildQuestionByType(
                surface,
                border,
                text,
                textMid,
                textDim,
                bg,
              ),
            ),
          ),

          // ─── WEITER BUTTON ──────────────────
          if (_answered)
            Container(
              decoration: BoxDecoration(
                color: surface,
                border: Border(top: BorderSide(color: border)),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _next,
                      icon: Icon(
                        _idx + 1 >= _questions.length
                            ? Icons.check_rounded
                            : Icons.arrow_forward_rounded,
                        size: 18,
                      ),
                      label: Text(
                        _idx + 1 >= _questions.length ? 'Beenden' : 'Weiter',
                      ),
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
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuestionByType(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
    Color bg,
  ) {
    final type = _getQuestionType();

    if (type == 'fill_blank') {
      return _buildFillBlank(surface, border, text, textMid, textDim, bg);
    } else if (type == 'sequence') {
      return _buildSequence(surface, border, text, textMid, textDim, bg);
    } else if (type == 'dns_port_match') {
      return _buildDnsPortMatch(surface, border, text, textMid, textDim, bg);
    } else if (type == 'freitext_ada') {
      return _buildFreitext(surface, border, text, textMid, textDim, bg);
    }
    return _buildMultipleChoice(surface, border, text, textMid, textDim, bg);
  }

  // ═══════════════════════════════════════════
  // MULTIPLE CHOICE
  // ═══════════════════════════════════════════
  Widget _buildMultipleChoice(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
    Color bg,
  ) {
    final q = _questions[_idx];
    final frageData = q['fragen'];
    final frageText = frageData['frage'] as String;

    if (!_shuffledAnswers.containsKey(_idx)) {
      final list = (frageData['antworten'] as List<dynamic>? ?? []).toList();
      list.shuffle();
      _shuffledAnswers[_idx] = list;
    }
    final antworten = _shuffledAnswers[_idx]!;

    return Column(
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
        Text(
          frageText,
          style: AppTextStyles.instrumentSerif(
            size: 22,
            color: text,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 24),
        ..._buildMCOptions(antworten, surface, border, text, textMid),
      ],
    );
  }

  List<Widget> _buildMCOptions(
    List<dynamic> antworten,
    Color surface,
    Color border,
    Color text,
    Color textMid,
  ) {
    return antworten.asMap().entries.map((entry) {
      final i = entry.key;
      final a = entry.value;
      final aid = a['id'] as int;
      final antwortText = a['text'] as String;
      final correct = a['ist_richtig'] == true;
      final isSelected = _selectedAnswerId == aid;
      final showResult = _answered && isSelected;
      final showCorrect = _answered && !isSelected && correct;

      Color borderColor = border;
      Color bgColor = surface;
      Color letterColor = textMid;
      Color letterBg = border;

      if (showResult) {
        if (correct) {
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
        borderColor = AppColors.success.withOpacity(0.5);
        letterColor = AppColors.success;
        letterBg = AppColors.success.withOpacity(0.15);
      } else if (isSelected) {
        borderColor = AppColors.accent;
        letterColor = Colors.white;
        letterBg = AppColors.accent;
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: GestureDetector(
          onTap: _answered || _submitting
              ? null
              : () => _submitMultipleChoice(aid, correct),
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
                            correct ? Icons.check_rounded : Icons.close_rounded,
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
                            String.fromCharCode(65 + i),
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
                    child: Text(
                      antwortText,
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
      );
    }).toList();
  }

  // ═══════════════════════════════════════════
  // DNS PORT MATCH (intern als MC mit options)
  // ═══════════════════════════════════════════
  Widget _buildDnsPortMatch(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
    Color bg,
  ) {
    final q = _questions[_idx];
    final frageData = q['fragen'];
    final frageText = frageData['frage'] as String;
    final calcData =
        frageData['calculation_data'] as Map<String, dynamic>? ?? {};
    final options = (calcData['options'] as List?)?.cast<String>() ?? [];
    final correctAnswer = calcData['correct_answer'] as String? ?? '';

    if (!_shuffledAnswers.containsKey(_idx)) {
      final list = options
          .asMap()
          .entries
          .map(
            (e) => {
              'id': e.key,
              'text': e.value,
              'ist_richtig': e.value == correctAnswer,
            },
          )
          .toList();
      list.shuffle();
      _shuffledAnswers[_idx] = list;
    }
    final antworten = _shuffledAnswers[_idx]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 16, height: 1, color: AppColors.accent),
            const SizedBox(width: 10),
            Text(
              'DNS · PORTS',
              style: AppTextStyles.monoLabel(AppColors.accent),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          frageText,
          style: AppTextStyles.instrumentSerif(
            size: 22,
            color: text,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 24),
        ..._buildMCOptions(antworten, surface, border, text, textMid),
      ],
    );
  }

  // ═══════════════════════════════════════════
  // FREITEXT
  // ═══════════════════════════════════════════
  Widget _buildFreitext(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
    Color bg,
  ) {
    final q = _questions[_idx];
    final frageData = q['fragen'];
    final frageText = frageData['frage'] as String;
    final calcData =
        frageData['calculation_data'] as Map<String, dynamic>? ?? {};
    final keywords = (calcData['keywords'] as List?)?.cast<String>() ?? [];

    _freitextControllers[_idx] ??= TextEditingController();
    final controller = _freitextControllers[_idx]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 16, height: 1, color: AppColors.accent),
            const SizedBox(width: 10),
            Text('FREITEXT', style: AppTextStyles.monoLabel(AppColors.accent)),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          frageText,
          style: AppTextStyles.instrumentSerif(
            size: 22,
            color: text,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 20),
        if (!_answered) ...[
          Text('DEINE ANTWORT', style: AppTextStyles.monoSmall(textDim)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: 5,
            maxLength: calcData['max_length'] as int? ?? 500,
            style: AppTextStyles.bodyMedium(text),
            decoration: InputDecoration(
              hintText: 'Schreibe deine Antwort...',
              hintStyle: AppTextStyles.bodyMedium(textDim),
              filled: true,
              fillColor: surface,
              counterStyle: AppTextStyles.monoSmall(textDim),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.accent),
              ),
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _submitting
                  ? null
                  : () {
                      final input = controller.text.toLowerCase();
                      final hits = keywords
                          .where((k) => input.contains(k.toLowerCase()))
                          .length;
                      final isCorrect = hits >= (keywords.length * 0.5).ceil();
                      _submitSpecialQuestion(isCorrect, controller.text);
                    },
              icon: const Icon(Icons.check_rounded, size: 18),
              label: const Text('Antwort prüfen'),
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
        ] else ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: (_wasCorrect ? AppColors.success : AppColors.warning)
                    .withOpacity(0.3),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.015, 0.015, 1.0],
                colors: [
                  _wasCorrect ? AppColors.success : AppColors.warning,
                  _wasCorrect ? AppColors.success : AppColors.warning,
                  surface,
                  surface,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _wasCorrect
                          ? Icons.check_circle_outline_rounded
                          : Icons.lightbulb_outline_rounded,
                      color: _wasCorrect
                          ? AppColors.success
                          : AppColors.warning,
                      size: 14,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _wasCorrect ? 'GUT ERKLÄRT' : 'WICHTIGE BEGRIFFE',
                      style: AppTextStyles.monoLabel(
                        _wasCorrect ? AppColors.success : AppColors.warning,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: keywords.map((k) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: border),
                      ),
                      child: Text(
                        k,
                        style: AppTextStyles.mono(
                          size: 11,
                          color: textMid,
                          weight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // ═══════════════════════════════════════════
  // FILL BLANK
  // ═══════════════════════════════════════════
  Widget _buildFillBlank(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
    Color bg,
  ) {
    final q = _questions[_idx];
    final frageData = q['fragen'];
    final frageText = frageData['frage'] as String;
    final calcData =
        frageData['calculation_data'] as Map<String, dynamic>? ?? {};
    final blanks =
        (calcData['blanks'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final allFilled = _fillBlankAnswers.length == blanks.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 16, height: 1, color: AppColors.accent),
            const SizedBox(width: 10),
            Text(
              'LÜCKENTEXT',
              style: AppTextStyles.monoLabel(AppColors.accent),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          frageText,
          style: AppTextStyles.instrumentSerif(
            size: 22,
            color: text,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 24),

        // Blanks
        ...List.generate(blanks.length, (index) {
          final blank = blanks[index];
          final options = (blank['options'] as List?)?.cast<String>() ?? [];
          final selectedAnswer = _fillBlankAnswers[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: AppColors.accent.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        'LÜCKE ${index + 1}',
                        style: AppTextStyles.mono(
                          size: 9,
                          color: AppColors.accent,
                          weight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: selectedAnswer != null
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.accent.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      selectedAnswer,
                                      style: AppTextStyles.mono(
                                        size: 13,
                                        color: text,
                                        weight: FontWeight.w600,
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _answered || _submitting
                                        ? null
                                        : () {
                                            setState(
                                              () => _fillBlankAnswers.remove(
                                                index,
                                              ),
                                            );
                                          },
                                    child: Icon(
                                      Icons.close_rounded,
                                      color: textMid,
                                      size: 14,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                '______',
                                style: AppTextStyles.mono(
                                  size: 14,
                                  color: textDim,
                                  weight: FontWeight.w400,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
                if (selectedAnswer == null) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: options.map((option) {
                      final isUsed = _fillBlankAnswers.values.contains(option);
                      return GestureDetector(
                        onTap: _answered || _submitting || isUsed
                            ? null
                            : () {
                                setState(() {
                                  _fillBlankAnswers[index] = option;
                                });
                              },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isUsed ? bg : surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isUsed
                                  ? border
                                  : AppColors.accent.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            option,
                            style: AppTextStyles.mono(
                              size: 12,
                              color: isUsed
                                  ? textDim
                                  : (isDarkMode(context)
                                        ? AppColors.darkText
                                        : AppColors.accent),
                              weight: FontWeight.w600,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          );
        }),

        const SizedBox(height: 8),

        // Submit
        if (!_answered)
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: (_submitting || !allFilled)
                  ? null
                  : () {
                      bool allCorrect = true;
                      for (int i = 0; i < blanks.length; i++) {
                        final correctAnswer =
                            blanks[i]['correctAnswer'] as String;
                        final userAnswer = _fillBlankAnswers[i];
                        if (userAnswer != correctAnswer) {
                          allCorrect = false;
                          break;
                        }
                      }
                      _submitSpecialQuestion(allCorrect, _fillBlankAnswers);
                    },
              icon: const Icon(Icons.check_rounded, size: 18),
              label: Text(allFilled ? 'Prüfen' : 'Bitte alle Lücken ausfüllen'),
              style: ElevatedButton.styleFrom(
                backgroundColor: text,
                foregroundColor: bg,
                disabledBackgroundColor: border,
                disabledForegroundColor: textDim,
                elevation: 0,
                textStyle: AppTextStyles.labelLarge(bg),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
      ],
    );
  }

  bool isDarkMode(BuildContext context) {
    return context.read<ThemeProvider>().isDark;
  }

  // ═══════════════════════════════════════════
  // SEQUENCE
  // ═══════════════════════════════════════════
  Widget _buildSequence(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
    Color bg,
  ) {
    final q = _questions[_idx];
    final frageData = q['fragen'];
    final frageText = frageData['frage'] as String;
    final calcData =
        frageData['calculation_data'] as Map<String, dynamic>? ?? {};
    final items = (calcData['items'] as List?)?.cast<String>() ?? [];
    final correctOrder =
        (calcData['correctOrder'] as List?)?.cast<String>() ?? [];

    if (_sequenceOrder.isEmpty && items.isNotEmpty) {
      _sequenceOrder = List<String>.filled(items.length, '');
    }

    final allFilled =
        _sequenceOrder.where((s) => s.isNotEmpty).length == items.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 16, height: 1, color: AppColors.accent),
            const SizedBox(width: 10),
            Text(
              'REIHENFOLGE',
              style: AppTextStyles.monoLabel(AppColors.accent),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          frageText,
          style: AppTextStyles.instrumentSerif(
            size: 22,
            color: text,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 24),

        // Slots
        ...List.generate(items.length, (index) {
          final item = _sequenceOrder.length > index
              ? _sequenceOrder[index]
              : '';
          final isEmpty = item.isEmpty;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                // Position
                Container(
                  width: 36,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.accent.withOpacity(0.3),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: AppTextStyles.mono(
                        size: 14,
                        color: AppColors.accent,
                        weight: FontWeight.w700,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Slot
                Expanded(
                  child: GestureDetector(
                    onTap: isEmpty || _answered || _submitting
                        ? null
                        : () => setState(() => _sequenceOrder[index] = ''),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isEmpty
                            ? surface
                            : AppColors.accent.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isEmpty
                              ? border
                              : AppColors.accent.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              isEmpty ? '__________' : item,
                              style: AppTextStyles.interTight(
                                size: 14,
                                weight: isEmpty
                                    ? FontWeight.w400
                                    : FontWeight.w600,
                                color: isEmpty ? textDim : text,
                                height: 1.3,
                              ),
                            ),
                          ),
                          if (!isEmpty && !_answered && !_submitting)
                            Icon(Icons.close_rounded, color: textMid, size: 14),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),

        const SizedBox(height: 20),

        // Auswahl
        if (!_answered) ...[
          Text('AUSWAHL', style: AppTextStyles.monoSmall(textDim)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: items.map((item) {
              final isSelected = _sequenceOrder.contains(item);
              return GestureDetector(
                onTap: _answered || _submitting || isSelected
                    ? null
                    : () {
                        setState(() {
                          final emptyIndex = _sequenceOrder.indexOf('');
                          if (emptyIndex != -1) {
                            _sequenceOrder[emptyIndex] = item;
                          }
                        });
                      },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? bg : surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? border
                          : AppColors.accent.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    item,
                    style: AppTextStyles.interTight(
                      size: 13,
                      weight: FontWeight.w600,
                      color: isSelected ? textDim : text,
                      height: 1.3,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: (_submitting || !allFilled)
                  ? null
                  : () {
                      bool isCorrect = true;
                      for (int i = 0; i < correctOrder.length; i++) {
                        if (i >= _sequenceOrder.length ||
                            _sequenceOrder[i] != correctOrder[i]) {
                          isCorrect = false;
                          break;
                        }
                      }
                      _submitSpecialQuestion(isCorrect, _sequenceOrder);
                    },
              icon: const Icon(Icons.check_rounded, size: 18),
              label: Text(
                allFilled ? 'Prüfen' : 'Bitte alle Positionen ausfüllen',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: text,
                foregroundColor: bg,
                disabledBackgroundColor: border,
                disabledForegroundColor: textDim,
                elevation: 0,
                textStyle: AppTextStyles.labelLarge(bg),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ═══════════════════════════════════════════
  // WAITING SCREEN
  // ═══════════════════════════════════════════
  Widget _buildWaitingScreen(
    Color bg,
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(width: 16, height: 1, color: AppColors.warning),
                  const SizedBox(width: 10),
                  Text(
                    'WARTE AUF GEGNER',
                    style: AppTextStyles.monoLabel(AppColors.warning),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'Du hast alles\nbeantwortet.',
                style: AppTextStyles.instrumentSerif(
                  size: 36,
                  color: text,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Das Ergebnis wird angezeigt, sobald dein Gegner fertig ist.',
                style: AppTextStyles.bodyMedium(textMid),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _checking ? null : _pruefeStatus,
                  icon: _checking
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh_rounded, size: 18),
                  label: Text(_checking ? 'Prüfe…' : 'Status prüfen'),
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
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 48,
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
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  // RESULT SCREEN
  // ═══════════════════════════════════════════
  Widget _buildResultScreen(
    Color bg,
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    final myScore = (_finalScores?['my_score'] as num?)?.toInt() ?? 0;
    final oppScore = (_finalScores?['opponent_score'] as num?)?.toInt() ?? 0;
    final myProfile = _finalScores?['my_profile'] as Map<String, dynamic>?;
    final oppProfile =
        _finalScores?['opponent_profile'] as Map<String, dynamic>?;
    final String myName = (myProfile?['username'] as String?) ?? 'Du';
    final String oppName = (oppProfile?['username'] as String?) ?? 'Gegner';

    final isWinner = myScore > oppScore;
    final isDraw = myScore == oppScore;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.showResult) return; // Historie: keine Sounds, keine Badges
      if (isWinner) {
        _soundService.playSound(SoundType.victory);
      } else if (!isDraw) {
        _soundService.playSound(SoundType.defeat);
      }

      final newBadges = await _badgeService.checkMatchBadges();
      if (newBadges.isNotEmpty && mounted) {
        final allBadges = await _badgeService.getAllBadges();
        final earnedDetails = allBadges
            .where((b) => newBadges.contains(b['id']))
            .toList();
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => BadgeCelebrationDialog(
              badgeIds: newBadges,
              badgeDetails: earnedDetails,
            ),
          );
        }
      }
    });

    final accentColor = isDraw
        ? AppColors.warning
        : (isWinner ? AppColors.success : AppColors.error);
    final statusLabel = isDraw
        ? 'UNENTSCHIEDEN'
        : (isWinner ? 'GEWONNEN' : 'VERLOREN');

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
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
                      'MATCH ERGEBNIS',
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
                    Row(
                      children: [
                        Container(width: 16, height: 1, color: accentColor),
                        const SizedBox(width: 10),
                        Text(
                          statusLabel,
                          style: AppTextStyles.monoLabel(accentColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      isDraw
                          ? 'Patt.'
                          : (isWinner ? 'Gewonnen!' : 'Knapp daneben.'),
                      style: AppTextStyles.instrumentSerif(
                        size: 48,
                        color: text,
                        letterSpacing: -1.8,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Score Comparison
                    Row(
                      children: [
                        Expanded(
                          child: _buildPlayerScoreCard(
                            myName,
                            myScore,
                            true,
                            isWinner,
                            surface,
                            border,
                            text,
                            textMid,
                            textDim,
                            avatarUrl: myProfile?['avatar_url'] as String?,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'VS',
                            style: AppTextStyles.mono(
                              size: 14,
                              color: textDim,
                              weight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        Expanded(
                          child: _buildPlayerScoreCard(
                            oppName,
                            oppScore,
                            false,
                            !isWinner && !isDraw,
                            surface,
                            border,
                            text,
                            textMid,
                            textDim,
                            avatarUrl: oppProfile?['avatar_url'] as String?,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_rounded, size: 18),
                        label: const Text('Zurück zur Übersicht'),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerScoreCard(
    String name,
    int score,
    bool isMe,
    bool isWinner,
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim, {
    String? avatarUrl,
  }) {
    final accentColor = isWinner ? AppColors.success : AppColors.accent;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isWinner ? AppColors.success.withOpacity(0.4) : border,
        ),
        gradient: isWinner
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.015, 0.015, 1.0],
                colors: [
                  AppColors.success,
                  AppColors.success,
                  surface,
                  surface,
                ],
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAvatar(
            avatarUrl: avatarUrl,
            username: name,
            size: 44,
            surface: surface,
            border: isWinner ? AppColors.success : border,
            textColor: text,
          ),
          const SizedBox(height: 10),
          Text(
            isMe ? 'DU' : 'GEGNER',
            style: AppTextStyles.monoSmall(
              isWinner ? AppColors.success : textMid,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: AppTextStyles.interTight(
              size: 14,
              weight: FontWeight.w600,
              color: text,
              height: 1.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Text(
            '$score',
            style: AppTextStyles.instrumentSerif(
              size: 40,
              color: text,
              letterSpacing: -1.5,
            ),
          ),
          const SizedBox(height: 2),
          Text('PUNKTE', style: AppTextStyles.monoSmall(textMid)),
        ],
      ),
    );
  }
}
