// lib/screens/learning/backup_practice_screen.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/questions/dns_port_match_widget.dart';
import '../../widgets/questions/freitext_ada_widget.dart';
import '../../services/flashcard_service.dart';
import '../../services/progress_service.dart';
import '../../services/sound_service.dart';

const _indigo = Color(0xFF4F46E5);
const _indigoDark = Color(0xFF3730A3);
const _indigoLight = Color(0xFF6366F1);
const _teal = Color(0xFF0891B2);

class BackupPracticeScreen extends StatefulWidget {
  final int moduleId;
  final String moduleName;

  const BackupPracticeScreen({
    super.key,
    required this.moduleId,
    required this.moduleName,
  });

  @override
  State<BackupPracticeScreen> createState() => _BackupPracticeScreenState();
}

class _BackupPracticeScreenState extends State<BackupPracticeScreen> {
  final _supabase = Supabase.instance.client;
  final _flashcardService = FlashcardService();
  final _progressService = ProgressService();
  final _soundService = SoundService();
  List<Map<String, dynamic>> _questions = [];
  bool _loading = true;
  int _currentIndex = 0;
  int? _selectedAnswer;
  bool _hasAnswered = false;

  @override
  void initState() {
    super.initState();
    _soundService.init();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final data = await _supabase
          .from('fragen')
          .select('id, frage, question_type, calculation_data, erklaerung, antworten(id, text, ist_richtig, erklaerung)')
          .eq('modul_id', widget.moduleId)
          .order('id');

      if (!mounted) return;
      final list = List<Map<String, dynamic>>.from(data);
      list.shuffle();
      for (final q in list) {
        if (q['antworten'] != null) {
          final antworten = List<dynamic>.from(q['antworten']);
          antworten.shuffle();
          q['antworten'] = antworten;
        }
      }
      setState(() {
        _questions = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Fehler beim Laden: $e')));
    }
  }

  void _onAnswered(bool isCorrect) async {
    if (!isCorrect) {
      final q = _questions[_currentIndex];
      final type = q['question_type'] as String?;
      String richtigeAntwort = '';
      if (type == 'multiple_choice') {
        final antworten = q['antworten'] as List?;
        final richtige = antworten?.firstWhere(
          (a) => a['ist_richtig'] == true, orElse: () => null);
        richtigeAntwort = richtige?['text'] ?? '';
      } else if (type == 'dns_port_match') {
        richtigeAntwort = q['calculation_data']?['correct_answer'] ?? '';
      }
      await _flashcardService.createFromWrongAnswer(
        frageId: q['id'],
        frageText: q['frage'],
        richtigeAntwort: richtigeAntwort,
        modulName: widget.moduleName,
        themaName: null,
      );
    }
    _nextQuestion();
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _hasAnswered = false;
      });
    } else {
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
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
                  child: const Text('🎉', style: TextStyle(fontSize: 48)),
                ),
                const SizedBox(height: 20),
                const Text('Geschafft!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Du hast alle ${_questions.length} Fragen durchgearbeitet!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 15)),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back_rounded, size: 18),
                    label: const Text('Zurück zur Übersicht'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  void _checkMCAnswer(int answerId) async {
    if (_hasAnswered) return;
    final q = _questions[_currentIndex];
    final antworten = q['antworten'] as List;
    final selected = antworten.firstWhere((a) => a['id'] == answerId);
    final isCorrect = selected['ist_richtig'] == true;
    setState(() {
      _selectedAnswer = answerId;
      _hasAnswered = true;
    });
    if (isCorrect) {
      _soundService.playSound(SoundType.correct);
    } else {
      _soundService.playSound(SoundType.wrong);
    }
    await _progressService.saveKernthemaAnswer(
      modulId: widget.moduleId,
      frageId: q['id'],
      isCorrect: isCorrect,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0E7490), _teal, Color(0xFF22D3EE)],
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
                          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.backup_rounded, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(widget.moduleName,
                              style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                    if (!_loading && _questions.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: LinearProgressIndicator(
                                  value: (_currentIndex + 1) / _questions.length,
                                  backgroundColor: Colors.white.withOpacity(0.25),
                                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                  minHeight: 7,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text('${_currentIndex + 1} / ${_questions.length}',
                                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: _teal))
                : _questions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade300),
                            const SizedBox(height: 12),
                            Text('Noch keine Fragen verfügbar',
                                style: TextStyle(fontSize: 16, color: Colors.grey.shade500)),
                          ],
                        ),
                      )
                    : _buildQuestionWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionWidget() {
    final q = _questions[_currentIndex];
    final type = q['question_type'] as String?;

    if (type == 'dns_port_match') {
      return DnsPortMatchWidget(
        questionText: q['frage'],
        correctAnswers: Map<String, dynamic>.from(q['calculation_data'] ?? {}),
        explanation: q['erklaerung'],
        onAnswered: _onAnswered,
        questionId: q['id'],
        moduleId: widget.moduleId,
      );
    } else if (type == 'freitext_ada') {
      return FreitextAdaWidget(
        questionText: q['frage'],
        correctAnswers: Map<String, dynamic>.from(q['calculation_data'] ?? {}),
        explanation: q['erklaerung'],
        onAnswered: (_) => _nextQuestion(),
        questionId: q['id'],
        moduleId: widget.moduleId,
      );
    } else if (type == 'multiple_choice') {
      return _buildMCQuestion(q);
    }

    return Center(child: Text('Unbekannter Fragentyp: $type', style: TextStyle(color: Colors.grey.shade600)));
  }

  Widget _buildMCQuestion(Map<String, dynamic> q) {
    final antworten = q['antworten'] as List? ?? [];
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.indigo.shade50, Colors.white], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _indigo.withOpacity(0.12)),
              boxShadow: [BoxShadow(color: _indigo.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 6))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [_indigoDark, _indigo]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.help_outline, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 10),
                    const Text('Frage', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _indigo)),
                  ],
                ),
                const SizedBox(height: 14),
                Text(q['frage'] ?? '', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, height: 1.5)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...antworten.asMap().entries.map((entry) {
            final index = entry.key;
            final antwort = entry.value;
            final answerId = antwort['id'] as int;
            final isSelected = _selectedAnswer == answerId;
            final isCorrect = antwort['ist_richtig'] == true;
            final showResult = _hasAnswered && isSelected;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _hasAnswered ? null : () => _checkMCAnswer(answerId),
                  borderRadius: BorderRadius.circular(16),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: showResult ? (isCorrect ? Colors.green.shade50 : Colors.red.shade50) : (isSelected ? Colors.indigo.shade50 : Colors.white),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: showResult ? (isCorrect ? Colors.green : Colors.red) : (isSelected ? _indigo : Colors.grey.shade200),
                        width: showResult ? 2 : 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32, height: 32,
                          decoration: BoxDecoration(
                            color: showResult ? (isCorrect ? Colors.green : Colors.red) : (isSelected ? _indigo : Colors.grey.shade200),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: showResult
                                ? Icon(isCorrect ? Icons.check : Icons.close, color: Colors.white, size: 18)
                                : Text(String.fromCharCode(65 + index),
                                    style: TextStyle(color: isSelected ? Colors.white : Colors.grey.shade600, fontWeight: FontWeight.bold, fontSize: 15)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(antwort['text'] ?? '',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                color: showResult ? (isCorrect ? Colors.green.shade900 : Colors.red.shade900) : Colors.black87)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          if (_hasAnswered) ...[
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                final antworten = q['antworten'] as List;
                final selected = antworten.firstWhere((a) => a['id'] == _selectedAnswer);
                _onAnswered(selected['ist_richtig'] == true);
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Weiter'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}