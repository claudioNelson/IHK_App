import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/calculation_question_widget.dart';
import '../../widgets/fill_in_blank_widget.dart';
import '../../widgets/sequence_question_widget.dart';
import '../../widgets/report_dialog.dart';
import '../../services/sound_service.dart';
import '../../services/badge_service.dart';
import '../../widgets/badge_celebration_dialog.dart';
import '../../services/progress_service.dart';
import '../../services/spaced_repetition_service.dart';

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
  String? calculationAnswer; // NEU: für Rechenaufgaben
  final _soundService = SoundService();
  final _badgeService = BadgeService();
  final _progressService = ProgressService();
  final _spacedRepService = SpacedRepetitionService();

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
    final frage = fragen[currentIndex];
    return frage['question_type'] == 'calculation';
  }

  bool get _isFillBlankQuestion {
    if (fragen.isEmpty || currentIndex >= fragen.length) return false;
    final frage = fragen[currentIndex];
    return frage['question_type'] == 'fill_blank';
  }

  bool get _isSequenceQuestion {
    if (fragen.isEmpty || currentIndex >= fragen.length) return false;
    final frage = fragen[currentIndex];
    return frage['question_type'] == 'sequence';
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

      // Fragen mischen
      final frageListe = List<dynamic>.from(res);
      frageListe.shuffle();

      // Antworten für jede Frage mischen
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
      // Aus Supabase laden
      final answered = await _progressService.getCorrectFragen(widget.modulId);
      setState(() {
        beantworteteFragen = answered;
      });
      print('✅ Fortschritt geladen: ${beantworteteFragen.length} Fragen');
    } catch (e) {
      print('❌ Fehler beim Laden des Fortschritts: $e');
    }
  }

  Future<void> _saveProgress(int frageId, bool isCorrect) async {
    try {
      print(
        '🔵 _saveProgress aufgerufen: Frage $frageId, isCorrect: $isCorrect',
      ); // ⭐ NEU

      // In Supabase speichern
      await _progressService.saveAnswer(
        modulId: widget.modulId,
        themaId: widget.themaId,
        frageId: frageId,
        isCorrect: isCorrect,
      );

      if (isCorrect) {
        beantworteteFragen.add(frageId);
      }

      print(
        '✅ Fortschritt gespeichert: Frage $frageId (${isCorrect ? "richtig" : "falsch"})',
      );
    } catch (e) {
      print('❌ Fehler beim Speichern: $e');
    }
  }

  Future<void> _saveThemaScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final allFragenIds = fragen.map((f) => f['id'] as int).toSet();
      final beantwortet = allFragenIds.intersection(beantworteteFragen);
      final percent = allFragenIds.isEmpty
          ? 0.0
          : (beantwortet.length / allFragenIds.length * 100);

      final key = 'score_mod_${widget.modulId}_thema_${widget.themaId}';
      await prefs.setDouble(key, percent);
      print('Score gespeichert: $key = $percent%');
    } catch (e) {
      print('Fehler beim Speichern des Scores: $e');
    }
  }

  void _checkAnswer(int answerId) async {
    if (hasAnswered) return;

    setState(() {
      selectedAnswer = answerId;
      hasAnswered = true;
      generatedExplanation = null;
    });

    final frage = fragen[currentIndex];
    final antworten = frage['antworten'] as List;
    final selected = antworten.firstWhere((a) => a['id'] == answerId);
    final isCorrect = selected['ist_richtig'] == true;

    if (isCorrect) {
      _soundService.playSound(SoundType.correct);
    } else {
      _soundService.playSound(SoundType.wrong);
    }

    // Fortschritt speichern
    await _saveProgress(frage['id'], isCorrect);

    // ⭐ NEU: Spaced Repetition
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
    });

    // Sound abspielen
    if (isCorrect) {
      _soundService.playSound(SoundType.correct);
    } else {
      _soundService.playSound(SoundType.wrong);
    }

    // Fortschritt speichern
    final frage = fragen[currentIndex];
    await _saveProgress(frage['id'], isCorrect);

    // ⭐ NEU: Spaced Repetition
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

    if (correctAnswer == null) {
      setState(() {
        generatedExplanation =
            'Die richtige Antwort konnte nicht ermittelt werden.';
        generatingExplanation = false;
      });
      return;
    }

    final explanation = _buildFallbackExplanation(
      frage['frage'],
      correctAnswer['text'],
    );

    setState(() {
      generatedExplanation = explanation;
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
        calculationAnswer = null; // NEU
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
        calculationAnswer = null; // NEU
      });

      await _fadeController.forward();
      await _slideController.forward();
    }
  }

  void _showCompletionDialog() {
    // Nur Fragen aus dem aktuellen Durchlauf zählen
    final allFragenIds = fragen.map((f) => f['id'] as int).toSet();
    final richtigInSession = allFragenIds
        .intersection(beantworteteFragen)
        .length;
    final gesamt = fragen.length;
    final prozent = ((richtigInSession / gesamt) * 100).toInt();

    final richtig = richtigInSession; // Variable umbenennen für restlichen Code

    String bewertung;
    IconData icon;
    Color color;

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
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(bewertung, style: TextStyle(color: color)),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$prozent%',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$richtig von $gesamt Fragen richtig',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: richtig / gesamt,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              // Badges prüfen
              await _checkModuleBadgesAndPop();

              if (mounted) Navigator.pop(context);
            },
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
              });
              _fadeController.forward(from: 0);
              _slideController.forward(from: 0);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
            ),
            child: const Text('Nochmal versuchen'),
          ),
        ],
      ),
    );
  }

  Future<void> _checkModuleBadgesAndPop() async {
    try {
      print('🎓 _checkModuleBadges() gestartet');

      // Aus Supabase laden statt SharedPreferences
      final completedModules = await _progressService
          .getCompletedModulesCount();

      print('🎓 Abgeschlossene Module: $completedModules');

      final newBadges = await _badgeService.checkModuleBadges(completedModules);
      print('🎓 Neue Badges: $newBadges');

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

    // Nach Konfetti (oder wenn keine Badges) zurück navigieren
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.modulName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          // Report Button
          IconButton(
            icon: const Icon(Icons.flag_outlined),
            tooltip: 'Problem melden',
            onPressed: () {
              if (fragen.isEmpty || currentIndex >= fragen.length) return;

              final frageId = fragen[currentIndex]['id'] as int;

              showDialog(
                context: context,
                builder: (context) =>
                    ReportDialog(frageId: frageId, screenType: 'test_fragen'),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${currentIndex + 1} / ${fragen.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : fragen.isEmpty
          ? const Center(
              child: Text(
                'Keine Fragen verfügbar',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                LinearProgressIndicator(
                  value: (currentIndex + 1) / fragen.length,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation(Colors.indigo),
                  minHeight: 4,
                ),
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: _buildQuestionContent(),
                    ),
                  ),
                ),
                _buildNavigationBar(),
              ],
            ),
      backgroundColor: Colors.grey[50],
    );
  }

  Widget _buildQuestionContent() {
    final frage = fragen[currentIndex];

    // NEU: Unterscheide zwischen Rechenaufgaben und Multiple Choice
    if (_isCalculationQuestion) {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: CalculationQuestionWidget(
          key: ValueKey('calc_$currentIndex'), // NEU: Key hinzufügen
          questionText: frage['frage'] ?? '',
          calculationData: frage['calculation_data'] ?? {},
          onAnswerSubmitted: _handleCalculationAnswer,
        ),
      );
    }

    // Für Fill-in-the-blank Aufgaben
    if (_isFillBlankQuestion) {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: FillInTheBlankWidget(
          key: ValueKey('fillblank_$currentIndex'),
          questionText: frage['frage'] ?? '',
          blankData: frage['calculation_data'] ?? {}, // Nutzt das gleiche Feld
          onAnswerSubmitted: (isCorrect, userAnswers) {
            _handleCalculationAnswer(isCorrect, userAnswers.toString());
          },
        ),
      );
    }

    // Für Sequence Aufgaben
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

    // Original Multiple Choice Code
    final antworten = frage['antworten'] as List;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.indigo.shade50, Colors.white],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.indigo, Colors.indigo.shade700],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.help_outline,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Frage',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  frage['frage'] ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

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
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(30 * (1 - value), 0),
                  child: Opacity(opacity: value, child: child),
                );
              },
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
                              : (isSelected
                                    ? Colors.indigo
                                    : Colors.grey.shade300),
                          width: showResult ? 2 : 1.5,
                        ),
                        boxShadow: [
                          if (isSelected && !hasAnswered)
                            BoxShadow(
                              color: Colors.indigo.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
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
                                        ? Colors.indigo
                                        : Colors.grey.shade300),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: showResult
                                  ? Icon(
                                      isCorrect ? Icons.check : Icons.close,
                                      color: Colors.white,
                                      size: 20,
                                    )
                                  : Text(
                                      String.fromCharCode(65 + index),
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.grey.shade700,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              antwort['text'] ?? '',
                              style: TextStyle(
                                fontSize: 16,
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

          if (hasAnswered && !_isCalculationQuestion) ...[
            const SizedBox(height: 24),
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
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
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
                0.2,
              ),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
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
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isCorrect ? 'Richtig!' : 'Erklärung',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isCorrect
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (isCorrect && hasExplanation)
              Text(
                explanation,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Colors.grey.shade800,
                ),
              )
            else if (!isCorrect) ...[
              if (hasExplanation)
                Text(
                  explanation,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: Colors.grey.shade800,
                  ),
                )
              else if (generatingExplanation)
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(
                          Colors.orange.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Generiere Erklärung...',
                      style: TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                )
              else if (generatedExplanation != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      generatedExplanation!,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 18,
                            color: Colors.blue.shade700,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Diese Erklärung wurde automatisch generiert.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              if (!isCorrect && correctAnswer != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
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
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Richtige Antwort:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              correctAnswer['text'] ?? '',
                              style: TextStyle(
                                fontSize: 15,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (currentIndex > 0)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _previousQuestion,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Zurück'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.indigo),
                    foregroundColor: Colors.indigo,
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
                ),
                label: Text(
                  currentIndex < fragen.length - 1 ? 'Weiter' : 'Abschließen',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  disabledForegroundColor: Colors.grey.shade600,
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
    );
  }
}
