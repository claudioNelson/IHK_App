// screens/exam_screens/result_screen.dart

import 'package:flutter/material.dart';
import '../../models/question_model.dart';
import '../../services/gemini_service.dart';

const _green = Color(0xFF059669);
const _greenDark = Color(0xFF065F46);
const _greenLight = Color(0xFF10B981);
const _purple = Color(0xFF7C3AED);
const _purpleLight = Color(0xFF8B5CF6);

class ResultScreen extends StatefulWidget {
  final List<ExamSection> sections;
  final Map<String, dynamic> userAnswers;
  final int timeSpent;

  const ResultScreen({
    super.key,
    required this.sections,
    required this.userAnswers,
    required this.timeSpent,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final _geminiService = GeminiService();
  String? _kiKorrektur;
  bool _isLoading = false;
  bool _showKorrektur = false;

  int get _totalPoints =>
      widget.sections.fold(0, (sum, s) => sum + s.totalPoints);

  int get _answeredCount => widget.userAnswers.length;

  int get _totalQuestions =>
      widget.sections.fold(0, (sum, s) => sum + s.questions.length);

  double get _completionRate =>
      _totalQuestions > 0 ? _answeredCount / _totalQuestions : 0;

  String _formatTime(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    if (h > 0) return '${h}h ${m}m';
    return '${m}m ${s}s';
  }

  Future<void> _requestKiKorrektur() async {
    setState(() => _isLoading = true);
    try {
      final allQuestions = <Map<String, dynamic>>[];
      for (var section in widget.sections) {
        for (var question in section.questions) {
          allQuestions.add({
            'frage': '${question.title}: ${question.description}',
            'typ': question.type.toString(),
            'user_antwort':
                widget.userAnswers[question.id]?.toString() ??
                    'Nicht beantwortet',
            'section': section.title,
          });
        }
      }
      final prompt = _buildKorrekturPrompt(allQuestions);
      final response = await _geminiService.generateContent(prompt);
      setState(() {
        _kiKorrektur = response;
        _showKorrektur = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  String _buildKorrekturPrompt(List<Map<String, dynamic>> questions) {
    final buffer = StringBuffer()
      ..writeln(
          'Du bist ein freundlicher IHK-Prüfer und Tutor für Fachinformatiker.')
      ..writeln('')
      ..writeln(
          'Ein Azubi hat gerade eine Prüfungssimulation abgeschlossen.')
      ..writeln(
          'Bitte analysiere die Antworten und gib konstruktives Feedback.')
      ..writeln('')
      ..writeln('=== PRÜFUNGSDATEN ===')
      ..writeln('Bearbeitungszeit: ${_formatTime(widget.timeSpent)}')
      ..writeln(
          'Beantwortete Fragen: $_answeredCount von $_totalQuestions')
      ..writeln('')
      ..writeln('=== FRAGEN UND ANTWORTEN ===');

    for (int i = 0; i < questions.length; i++) {
      final q = questions[i];
      buffer
        ..writeln('')
        ..writeln('Frage ${i + 1} (${q['section']}):')
        ..writeln('${q['frage']}')
        ..writeln('Antwort: ${q['user_antwort']}');
    }

    buffer
      ..writeln('')
      ..writeln('=== DEINE AUFGABE ===')
      ..writeln(
          'Gib Feedback mit: 📊 Gesamtbewertung, ✅ Stärken, ⚠️ Verbesserungsbedarf, 📚 Lernempfehlungen, 💪 Motivation.')
      ..writeln(
          'Antworte auf Deutsch, freundlich und motivierend. Nutze Emojis.');

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final completePct =
        (_completionRate * 100).toStringAsFixed(1);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ── HEADER ──────────────────────────────────────
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_greenDark, _green, _greenLight],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding:
                      const EdgeInsets.fromLTRB(20, 20, 20, 36),
                  child: Column(
                    children: [
                      // Score Circle
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$completePct%',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: _green),
                              ),
                              Text('erledigt',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade500)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Prüfung abgegeben!',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Lass die KI deine Antworten korrigieren',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8)),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.fromLTRB(16, 20, 16, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── STATS ──────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                          child: _statCard(
                        icon: Icons.assignment_turned_in_rounded,
                        value: '$_answeredCount / $_totalQuestions',
                        label: 'Beantwortet',
                        color: const Color(0xFF1D4ED8),
                      )),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _statCard(
                        icon: Icons.timer_rounded,
                        value: _formatTime(widget.timeSpent),
                        label: 'Bearbeitungszeit',
                        color: _purple,
                      )),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _statCard(
                        icon: Icons.stars_rounded,
                        value: '$_totalPoints P',
                        label: 'Mögl. Punkte',
                        color: Colors.amber.shade700,
                      )),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── KI BUTTON ──────────────────────────────
                  GestureDetector(
                    onTap: _isLoading ? null : _requestKiKorrektur,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [_purple, _purpleLight]),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: _purple.withOpacity(0.3),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white),
                                )
                              : const Icon(
                                  Icons.psychology_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                          const SizedBox(width: 10),
                          Text(
                            _isLoading
                                ? 'KI analysiert...'
                                : '🤖 KI-Tutor Korrektur anfordern',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── KI RESULT ──────────────────────────────
                  if (_showKorrektur && _kiKorrektur != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: _purple.withOpacity(0.2),
                            width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: _purple.withOpacity(0.06),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
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
                                      colors: [_purple, _purpleLight]),
                                  borderRadius:
                                      BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                    Icons.psychology_rounded,
                                    color: Colors.white,
                                    size: 20),
                              ),
                              const SizedBox(width: 10),
                              const Text('KI-Tutor Feedback',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Divider(
                              height: 24, color: Colors.grey.shade100),
                          SelectableText(
                            _kiKorrektur!,
                            style: const TextStyle(
                                fontSize: 14, height: 1.6),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // ── SECTIONS ───────────────────────────────
                  Row(
                    children: [
                      Container(
                          width: 3,
                          height: 16,
                          decoration: BoxDecoration(
                              color: _green,
                              borderRadius: BorderRadius.circular(2))),
                      const SizedBox(width: 10),
                      const Icon(Icons.view_list_rounded,
                          color: _green, size: 17),
                      const SizedBox(width: 6),
                      const Text('Handlungsschritte',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),

                  ...widget.sections.map((section) {
                    final sectionAnswered = section.questions
                        .where((q) =>
                            widget.userAnswers.containsKey(q.id))
                        .length;
                    final sectionTotal =
                        section.questions.length;
                    final pct = sectionTotal > 0
                        ? sectionAnswered / sectionTotal
                        : 0.0;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: _green.withOpacity(0.1),
                            width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(section.title,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight:
                                            FontWeight.w600)),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color:
                                      _green.withOpacity(0.08),
                                  borderRadius:
                                      BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '$sectionAnswered/$sectionTotal',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: _green),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: pct,
                              backgroundColor:
                                  Colors.grey.shade100,
                              valueColor:
                                  const AlwaysStoppedAnimation<
                                      Color>(_green),
                              minHeight: 6,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${(pct * 100).toInt()}% beantwortet',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade500),
                              ),
                              Text(
                                '${section.totalPoints} Punkte',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 16),

                  // ── BACK BUTTON ────────────────────────────
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: const Color(0xFF1D4ED8)
                                .withOpacity(0.3),
                            width: 1.5),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.home_rounded,
                              color: Color(0xFF1D4ED8), size: 20),
                          SizedBox(width: 8),
                          Text('Zurück zur Startseite',
                              style: TextStyle(
                                  color: Color(0xFF1D4ED8),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  fontSize: 10, color: Colors.grey.shade500),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}