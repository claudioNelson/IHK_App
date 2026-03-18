// lib/screens/module/test_fragen_screen.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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

const _indigo = Color(0xFF4F46E5);
const _indigoDark = Color(0xFF3730A3);
const _indigoLight = Color(0xFF6366F1);

class TestFragen extends StatefulWidget {
  final int modulId;
  final String modulName;
  final int themaId;

  const TestFragen({
    super.key,
    required this.modulId,
    required this.modulName,
    required this.themaId,
  });

  @override
  State<TestFragen> createState() => _TestFragenState();
}

class _TestFragenState extends State<TestFragen> with TickerProviderStateMixin {
  final supabase = Supabase.instance.client;

  List<dynamic> fragen = [];
  int currentIndex = 0;
  bool loading = true;
  Set<int> beantworteteFragen = {};
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
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _soundService.init();
    _setupAnimations();
    _loadFragen();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeController.forward();
    _slideController.forward();
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

  Future<void> _loadFragen() async {
    try {
      final res = await supabase
          .from('fragen')
          .select(
            'id, frage, question_type, calculation_data, antworten(id, text, ist_richtig, erklaerung)',
          )
          .eq('modul_id', widget.modulId)
          .eq('thema_id', widget.themaId);

      if (!mounted) return;

      final frageListe = List<dynamic>.from(res);
      frageListe.shuffle();

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

      await _loadProgress();
      _fadeController.forward(from: 0);
      _slideController.forward(from: 0);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fehler beim Laden: $e')));
      setState(() => loading = false);
    }
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
      if (isCorrect) beantworteteFragen.add(frageId);
    } catch (e) {
      debugPrint('Fehler beim Speichern: $e');
    }
  }

  // ── Flashcard bei falscher Antwort erstellen ─────────────────────────────
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

    // Modul/Thema Namen aus widget.modulName extrahieren
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

      // ── Flashcard automatisch erstellen ──
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
          : _buildFallbackExplanation(frage['frage'], correctAnswer['text']);
      generatingExplanation = false;
    });
  }

  String _buildFallbackExplanation(String frage, String correctText) {
    return 'Die richtige Antwort ist: "$correctText".\n\n'
        'Diese Antwort bezieht sich auf die Frage: "$frage".\n\n'
        'Tipp: Überprüfe dein Verständnis zu diesem Thema in den Lernmaterialien.';
  }

  void _nextQuestion() async {
    if (currentIndex < fragen.length - 1) {
      await _fadeController.reverse();
      await _slideController.reverse();
      setState(() {
        currentIndex++;
        selectedAnswer = null;
        hasAnswered = false;
        generatedExplanation = null;
        calculationAnswer = null;
        _flashcardSaved = false;
      });
      await _fadeController.forward();
      await _slideController.forward();
    } else {
      _showCompletionDialog();
    }
  }

  void _previousQuestion() async {
    if (currentIndex > 0) {
      await _fadeController.reverse();
      await _slideController.reverse();
      setState(() {
        currentIndex--;
        selectedAnswer = null;
        hasAnswered = false;
        generatedExplanation = null;
        calculationAnswer = null;
        _flashcardSaved = false;
      });
      await _fadeController.forward();
      await _slideController.forward();
    }
  }

  void _showCompletionDialog() {
    final allFragenIds = fragen.map((f) => f['id'] as int).toSet();
    final richtigInSession = allFragenIds
        .intersection(beantworteteFragen)
        .length;
    final gesamt = fragen.length;
    final prozent = ((richtigInSession / gesamt) * 100).toInt();

    Color color;
    IconData icon;
    String bewertung;

    if (prozent >= 90) {
      bewertung = 'Hervorragend!';
      icon = Icons.emoji_events;
      color = Colors.amber;
    } else if (prozent >= 70) {
      bewertung = 'Gut gemacht!';
      icon = Icons.thumb_up;
      color = Colors.green;
    } else if (prozent >= 50) {
      bewertung = 'Nicht schlecht!';
      icon = Icons.sentiment_satisfied;
      color = Colors.orange;
    } else {
      bewertung = 'Weiter üben!';
      icon = Icons.sentiment_dissatisfied;
      color = Colors.red;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                bewertung,
                style: TextStyle(color: color, fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$prozent%',
              style: TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '$richtigInSession von $gesamt Fragen richtig',
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: richtigInSession / gesamt,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 8,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Dialog schließen
              await _checkModuleBadgesAndPop();
              // ← kein zweites pop hier!
            },
            style: TextButton.styleFrom(foregroundColor: Colors.grey.shade600),
            child: const Text('Zurück zur Übersicht'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                currentIndex = 0;
                selectedAnswer = null;
                hasAnswered = false;
                generatedExplanation = null;
                calculationAnswer = null;
                _flashcardSaved = false;
              });
              _fadeController.forward(from: 0);
              _slideController.forward(from: 0);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Nochmal versuchen'),
          ),
        ],
      ),
    );
  }

  Future<void> _checkModuleBadgesAndPop() async {
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
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      body: Column(
        children: [
          _buildHeader(),
          if (!loading && fragen.isNotEmpty)
            Container(
              color: Colors.white,
              child: ClipRRect(
                child: LinearProgressIndicator(
                  value: (currentIndex + 1) / fragen.length,
                  backgroundColor: Colors.grey.shade100,
                  valueColor: const AlwaysStoppedAnimation<Color>(_indigo),
                  minHeight: 4,
                ),
              ),
            ),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator(color: _indigo))
                : fragen.isEmpty
                ? const Center(
                    child: Text(
                      'Keine Fragen verfügbar',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: _buildQuestionContent(),
                    ),
                  ),
          ),
          if (!loading && fragen.isNotEmpty) _buildNavigationBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_indigoDark, _indigo, _indigoLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 16, 16),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.quiz_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.modulName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (!loading && fragen.isNotEmpty)
                      Text(
                        'Frage ${currentIndex + 1} von ${fragen.length}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              if (!loading && fragen.isNotEmpty)
                IconButton(
                  icon: const Icon(
                    Icons.flag_outlined,
                    color: Colors.white70,
                    size: 22,
                  ),
                  tooltip: 'Problem melden',
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
                ),
              if (!loading && fragen.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${currentIndex + 1}/${fragen.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionContent() {
    final frage = fragen[currentIndex];

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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Frage Card
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.indigo.shade50, Colors.white],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _indigo.withOpacity(0.12)),
              boxShadow: [
                BoxShadow(
                  color: _indigo.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [_indigoDark, _indigo],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.help_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Frage',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _indigo,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  frage['frage'] ?? '',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Antwort-Karten
          ...antworten.asMap().entries.map((entry) {
            final index = entry.key;
            final antwort = entry.value;
            final answerId = antwort['id'] as int;
            final isSelected = selectedAnswer == answerId;
            final isCorrect = antwort['ist_richtig'] == true;
            final showResult = hasAnswered && isSelected;

            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 200 + (index * 50)),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) => Transform.translate(
                offset: Offset(30 * (1 - value), 0),
                child: Opacity(opacity: value, child: child),
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: hasAnswered ? null : () => _checkAnswer(answerId),
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: showResult
                            ? (isCorrect
                                  ? Colors.green.shade50
                                  : Colors.red.shade50)
                            : (isSelected
                                  ? Colors.indigo.shade50
                                  : Colors.white),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: showResult
                              ? (isCorrect ? Colors.green : Colors.red)
                              : (isSelected ? _indigo : Colors.grey.shade200),
                          width: showResult ? 2 : 1.5,
                        ),
                        boxShadow: [
                          if (isSelected && !hasAnswered)
                            BoxShadow(
                              color: _indigo.withOpacity(0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: showResult
                                  ? (isCorrect ? Colors.green : Colors.red)
                                  : (isSelected
                                        ? _indigo
                                        : Colors.grey.shade200),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: showResult
                                  ? Icon(
                                      isCorrect ? Icons.check : Icons.close,
                                      color: Colors.white,
                                      size: 18,
                                    )
                                  : Text(
                                      String.fromCharCode(65 + index),
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.grey.shade600,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              antwort['text'] ?? '',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: showResult
                                    ? (isCorrect
                                          ? Colors.green.shade900
                                          : Colors.red.shade900)
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),

          // Flashcard-Hinweis wenn falsch beantwortet
          if (hasAnswered && _flashcardSaved) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple.shade200),
              ),
              child: Row(
                children: [
                  const Text('🃏', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Flashcard gespeichert — übe sie später unter "Meine Flashcards"',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.purple.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (hasAnswered && !_isCalculationQuestion) ...[
            const SizedBox(height: 12),
            _buildExplanationCard(antworten),
          ],
        ],
      ),
    );
  }

  Widget _buildExplanationCard(List antworten) {
    final selectedAnt = antworten.firstWhere(
      (a) => a['id'] == selectedAnswer,
      orElse: () => null,
    );
    if (selectedAnt == null) return const SizedBox.shrink();

    final isCorrect = selectedAnt['ist_richtig'] == true;
    final explanation = selectedAnt['erklaerung'];
    final hasExplanation =
        explanation != null && explanation.toString().trim().isNotEmpty;
    final correctAnswer = antworten.firstWhere(
      (a) => a['ist_richtig'] == true,
      orElse: () => null,
    );

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Transform.scale(
        scale: 0.85 + (0.15 * value),
        child: Opacity(opacity: value, child: child),
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isCorrect
                ? [Colors.green.shade50, Colors.white]
                : [Colors.orange.shade50, Colors.white],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isCorrect ? Colors.green : Colors.orange,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: (isCorrect ? Colors.green : Colors.orange).withOpacity(
                0.15,
              ),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isCorrect
                          ? [Colors.green, Colors.green.shade700]
                          : [Colors.orange, Colors.orange.shade700],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isCorrect ? Icons.check_circle : Icons.lightbulb,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  isCorrect ? 'Richtig!' : 'Erklärung',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: isCorrect
                        ? Colors.green.shade700
                        : Colors.orange.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (isCorrect && hasExplanation)
              Text(
                explanation,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: Colors.grey.shade800,
                ),
              )
            else if (!isCorrect) ...[
              if (hasExplanation)
                Text(
                  explanation,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.grey.shade800,
                  ),
                )
              else if (generatingExplanation)
                Row(
                  children: [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(
                          Colors.orange.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Generiere Erklärung...',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                )
              else if (generatedExplanation != null)
                Text(
                  generatedExplanation!,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.grey.shade800,
                  ),
                ),
              if (!isCorrect && correctAnswer != null) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Richtige Antwort:',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              correctAnswer['text'] ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              if (currentIndex > 0)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _previousQuestion,
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: const Text('Zurück'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: _indigo),
                      foregroundColor: _indigo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              if (currentIndex > 0) const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: hasAnswered ? _nextQuestion : null,
                  icon: Icon(
                    currentIndex < fragen.length - 1
                        ? Icons.arrow_forward
                        : Icons.check,
                    size: 18,
                  ),
                  label: Text(
                    currentIndex < fragen.length - 1 ? 'Weiter' : 'Abschließen',
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: _indigo,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade200,
                    disabledForegroundColor: Colors.grey.shade500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: hasAnswered ? 2 : 0,
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
