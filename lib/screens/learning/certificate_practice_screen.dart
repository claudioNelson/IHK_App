// lib/screens/learning/certificate_practice_screen.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/sound_service.dart';
import '../../services/spaced_repetition_service.dart';

const _indigo = Color(0xFF4F46E5);
const _indigoDark = Color(0xFF3730A3);
const _indigoLight = Color(0xFF6366F1);

class CertificatePracticeScreen extends StatefulWidget {
  final int zertifikatId;
  final String zertifikatName;
  final int anzahlFragen;

  const CertificatePracticeScreen({
    super.key,
    required this.zertifikatId,
    required this.zertifikatName,
    required this.anzahlFragen,
  });

  @override
  State<CertificatePracticeScreen> createState() =>
      _CertificatePracticeScreenState();
}

class _CertificatePracticeScreenState
    extends State<CertificatePracticeScreen> with TickerProviderStateMixin {
  final supabase = Supabase.instance.client;
  final _soundService = SoundService();
  final _srsService = SpacedRepetitionService();

  List<dynamic> fragen = [];
  int currentIndex = 0;
  bool loading = true;
  int? selectedAnswer;
  bool hasAnswered = false;
  String? generatedExplanation;
  bool generatingExplanation = false;
  int correctCount = 0;

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
        duration: const Duration(milliseconds: 300), vsync: this);
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);
    _slideController = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    _slideAnimation =
        Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _slideController, curve: Curves.easeOutCubic));
    _fadeController.forward();
    _slideController.forward();
  }

  Future<void> _loadFragen() async {
    try {
      final res = await supabase
          .from('fragen')
          .select('id, frage, antworten(id, text, ist_richtig, erklaerung)')
          .eq('zertifikat_id', widget.zertifikatId)
          .limit(widget.anzahlFragen);

      if (!mounted) return;
      final frageListe = List<dynamic>.from(res)..shuffle();
      for (final frage in frageListe) {
        if (frage['antworten'] != null) {
          final antworten = List<dynamic>.from(frage['antworten'])..shuffle();
          frage['antworten'] = antworten;
        }
      }
      setState(() {
        fragen = frageListe;
        loading = false;
      });
      _fadeController.forward(from: 0);
      _slideController.forward(from: 0);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Fehler: $e')));
      setState(() => loading = false);
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
      correctCount++;
    } else {
      _soundService.playSound(SoundType.wrong);
    }
    await _srsService.recordAnswer(frageId: frage['id'], isCorrect: isCorrect);
    if (!isCorrect &&
        (selected['erklaerung'] == null ||
            selected['erklaerung'].toString().trim().isEmpty)) {
      _generateExplanation(frage, antworten);
    }
  }

  Future<void> _generateExplanation(
      Map<String, dynamic> frage, List antworten) async {
    setState(() => generatingExplanation = true);
    await Future.delayed(const Duration(milliseconds: 800));
    final correct = antworten.firstWhere(
        (a) => a['ist_richtig'] == true,
        orElse: () => null);
    setState(() {
      generatedExplanation = correct != null
          ? 'Die richtige Antwort ist: "${correct['text']}".\n\nTipp: Überprüfe dein Verständnis zu diesem Thema in den Lernmaterialien.'
          : 'Die richtige Antwort konnte nicht ermittelt werden.';
      generatingExplanation = false;
    });
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
      setState(() {
        currentIndex--;
        selectedAnswer = null;
        hasAnswered = false;
        generatedExplanation = null;
      });
      await _fadeController.forward();
    }
  }

  void _showCompletionDialog() {
    final percent = ((correctCount / fragen.length) * 100).toInt();
    final passed = percent >= 70;
    final color = percent >= 90
        ? Colors.amber
        : percent >= 70
            ? Colors.green
            : percent >= 50
                ? Colors.orange
                : Colors.red;
    final label = percent >= 90
        ? 'Hervorragend!'
        : percent >= 70
            ? 'Gut gemacht!'
            : percent >= 50
                ? 'Nicht schlecht!'
                : 'Weiter üben!';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                    color: color.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(
                    passed ? Icons.emoji_events_rounded : Icons.psychology_rounded,
                    color: color, size: 48),
              ),
              const SizedBox(height: 16),
              Text(label,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color)),
              const SizedBox(height: 8),
              Text('$percent%',
                  style: TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                      color: color)),
              Text('$correctCount von ${fragen.length} richtig',
                  style: TextStyle(
                      fontSize: 15, color: Colors.grey.shade600)),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: correctCount / fragen.length,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation(color),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Fertig'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          currentIndex = 0;
                          selectedAnswer = null;
                          hasAnswered = false;
                          generatedExplanation = null;
                          correctCount = 0;
                        });
                        _loadFragen();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Nochmal'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      body: Column(
        children: [
          // Header
          Container(
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
                padding: const EdgeInsets.fromLTRB(8, 4, 16, 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_rounded,
                              color: Colors.white, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.workspace_premium_rounded,
                              color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(widget.zertifikatName,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${currentIndex + 1} / ${fragen.length}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    if (!loading && fragen.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: (currentIndex + 1) / fragen.length,
                            backgroundColor: Colors.white.withOpacity(0.25),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white),
                            minHeight: 7,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(color: _indigo))
                : fragen.isEmpty
                    ? Center(
                        child: Text('Keine Fragen verfügbar',
                            style: TextStyle(color: Colors.grey.shade500)))
                    : FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: _buildQuestionContent(),
                        ),
                      ),
          ),

          // Nav Bar
          if (!loading && fragen.isNotEmpty) _buildNavBar(),
        ],
      ),
    );
  }

  Widget _buildQuestionContent() {
    final frage = fragen[currentIndex];
    final antworten = frage['antworten'] as List;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Frage Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _indigo.withOpacity(0.15), width: 1.5),
              boxShadow: [
                BoxShadow(
                    color: _indigo.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [_indigoDark, _indigo]),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.help_outline_rounded,
                          color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 10),
                    const Text('Frage',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: _indigo)),
                  ],
                ),
                const SizedBox(height: 14),
                Text(frage['frage'] ?? '',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500, height: 1.5)),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Antworten
          ...antworten.asMap().entries.map((entry) {
            final i = entry.key;
            final antwort = entry.value;
            final answerId = antwort['id'] as int;
            final isSelected = selectedAnswer == answerId;
            final isCorrect = antwort['ist_richtig'] == true;
            final showCorrect = hasAnswered && isCorrect;
            final showWrong = hasAnswered && isSelected && !isCorrect;

            Color bgColor = Colors.white;
            Color borderColor = Colors.grey.shade200;
            if (showCorrect) {
              bgColor = Colors.green.shade50;
              borderColor = Colors.green;
            } else if (showWrong) {
              bgColor = Colors.red.shade50;
              borderColor = Colors.red;
            } else if (isSelected) {
              bgColor = _indigo.withOpacity(0.05);
              borderColor = _indigo;
            }

            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 200 + (i * 50)),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (ctx, val, child) => Transform.translate(
                offset: Offset(30 * (1 - val), 0),
                child: Opacity(opacity: val, child: child),
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: borderColor, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2)),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    onTap: hasAnswered ? null : () => _checkAnswer(answerId),
                    borderRadius: BorderRadius.circular(14),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: showCorrect
                                  ? Colors.green
                                  : showWrong
                                      ? Colors.red
                                      : isSelected
                                          ? _indigo
                                          : Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: (showCorrect || showWrong)
                                  ? Icon(
                                      showCorrect ? Icons.check : Icons.close,
                                      color: Colors.white,
                                      size: 18)
                                  : Text(
                                      String.fromCharCode(65 + i),
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.grey.shade600,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(antwort['text'] ?? '',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: (showCorrect || isSelected)
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: showCorrect
                                      ? Colors.green.shade900
                                      : showWrong
                                          ? Colors.red.shade900
                                          : Colors.black87,
                                  height: 1.3,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),

          if (hasAnswered) ...[
            const SizedBox(height: 16),
            _buildExplanationCard(antworten),
          ],
        ],
      ),
    );
  }

  Widget _buildExplanationCard(List antworten) {
    final selectedAnt =
        antworten.firstWhere((a) => a['id'] == selectedAnswer, orElse: () => null);
    if (selectedAnt == null) return const SizedBox.shrink();

    final isCorrect = selectedAnt['ist_richtig'] == true;
    final explanation = selectedAnt['erklaerung'];
    final hasExplanation =
        explanation != null && explanation.toString().trim().isNotEmpty;
    final correctAnswer = antworten.firstWhere(
        (a) => a['ist_richtig'] == true,
        orElse: () => null);
    final color = isCorrect ? Colors.green : Colors.orange;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (ctx, val, child) =>
          Transform.scale(scale: 0.85 + (0.15 * val),
              child: Opacity(opacity: val, child: child)),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isCorrect ? Icons.check_circle_rounded : Icons.lightbulb_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  isCorrect ? 'Richtig!' : 'Erklärung',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (hasExplanation)
              Text(explanation,
                  style: TextStyle(
                      fontSize: 14, height: 1.6, color: Colors.grey.shade800))
            else if (generatingExplanation)
              Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: color),
                  ),
                  const SizedBox(width: 10),
                  Text('Generiere Erklärung...',
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic)),
                ],
              )
            else if (generatedExplanation != null)
              Text(generatedExplanation!,
                  style: TextStyle(
                      fontSize: 14, height: 1.6, color: Colors.grey.shade800)),
            if (!isCorrect && correctAnswer != null) ...[
              const SizedBox(height: 12),
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
                    Icon(Icons.check_circle_rounded,
                        color: Colors.green.shade600, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Richtige Antwort:',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700)),
                          const SizedBox(height: 4),
                          Text(correctAnswer['text'] ?? '',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade800)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNavBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (currentIndex > 0) ...[
              OutlinedButton.icon(
                onPressed: _previousQuestion,
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: const Text('Zurück'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  side: const BorderSide(color: _indigoLight),
                  foregroundColor: _indigo,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: ElevatedButton.icon(
                onPressed: hasAnswered ? _nextQuestion : null,
                icon: Icon(
                    currentIndex < fragen.length - 1
                        ? Icons.arrow_forward_rounded
                        : Icons.check_circle_rounded,
                    size: 18),
                label: Text(
                    currentIndex < fragen.length - 1
                        ? 'Weiter'
                        : 'Abschließen',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: _indigo,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade200,
                  disabledForegroundColor: Colors.grey.shade400,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
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
