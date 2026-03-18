// lib/screens/learning/backup_practice_screen.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/questions/dns_port_match_widget.dart';
import '../../widgets/questions/freitext_ada_widget.dart';

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
  List<Map<String, dynamic>> _questions = [];
  bool _loading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final data = await _supabase
          .from('fragen')
          .select('id, frage, question_type, calculation_data, erklaerung')
          .eq('modul_id', widget.moduleId)
          .order('id');

      if (!mounted) return;
      setState(() {
        _questions = List<Map<String, dynamic>>.from(data)..shuffle();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Fehler beim Laden: $e')));
    }
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() => _currentIndex++);
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
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Text('🎉', style: TextStyle(fontSize: 48)),
                ),
                const SizedBox(height: 20),
                const Text('Geschafft!',
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Du hast alle ${_questions.length} Fragen durchgearbeitet!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey.shade600, fontSize: 15)),
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
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
                          child: const Icon(Icons.backup_rounded,
                              color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.moduleName,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
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
                                  backgroundColor:
                                      Colors.white.withOpacity(0.25),
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                  minHeight: 7,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${_currentIndex + 1} / ${_questions.length}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
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

          // Content
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: _teal))
                : _questions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox_outlined,
                                size: 64, color: Colors.grey.shade300),
                            const SizedBox(height: 12),
                            Text('Noch keine Fragen verfügbar',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade500)),
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
    final question = _questions[_currentIndex];
    final questionType = question['question_type'] as String;

    if (questionType == 'dns_port_match') {
      return DnsPortMatchWidget(
        questionText: question['frage'],
        correctAnswers:
            Map<String, dynamic>.from(question['calculation_data'] ?? {}),
        explanation: question['erklaerung'],
        onAnswered: (_) => _nextQuestion(),
        questionId: question['id'],
        moduleId: widget.moduleId,
      );
    } else if (questionType == 'freitext_ada') {
      return FreitextAdaWidget(
        questionText: question['frage'],
        correctAnswers:
            Map<String, dynamic>.from(question['calculation_data'] ?? {}),
        explanation: question['erklaerung'],
        onAnswered: (_) => _nextQuestion(),
        questionId: question['id'],
        moduleId: widget.moduleId,
      );
    }

    return Center(
      child: Text('Unbekannter Fragentyp: $questionType',
          style: TextStyle(color: Colors.grey.shade600)),
    );
  }
}
