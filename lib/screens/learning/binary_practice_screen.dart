import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/questions/dns_port_match_widget.dart';
import '../../widgets/questions/freitext_ada_widget.dart';
import '../../widgets/questions/binary_calculation_widget.dart';

class BinaryPracticeScreen extends StatefulWidget {
  final int moduleId;
  final String moduleName;

  const BinaryPracticeScreen({
    super.key,
    required this.moduleId,
    required this.moduleName,
  });

  @override
  State<BinaryPracticeScreen> createState() => _BinaryPracticeScreenState();
}

class _BinaryPracticeScreenState extends State<BinaryPracticeScreen> {
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
        _questions = List<Map<String, dynamic>>.from(data);
        _questions.shuffle();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fehler beim Laden: $e')));
    }
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() => _currentIndex++);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Fertig! 🎉'),
          content: const Text('Du hast alle Fragen durchgearbeitet!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Zurück'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(widget.moduleName),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _questions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'Noch keine Fragen verfügbar',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Frage ${_currentIndex + 1} von ${_questions.length}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${((_currentIndex + 1) / _questions.length * 100).toInt()}%',
                            style: TextStyle(
                              color: Colors.orange.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: (_currentIndex + 1) / _questions.length,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: _buildQuestionWidget()),
              ],
            ),
    );
  }

  Widget _buildQuestionWidget() {
    final question = _questions[_currentIndex];
    final questionType = question['question_type'] as String;

    // Binär/Hex Berechnung mit Scratch Pad
    if (questionType == 'dns_port_match') {
      return BinaryCalculationWidget(
        // ← NEU! Statt DnsPortMatchWidget
        questionText: question['frage'],
        correctAnswers: Map<String, dynamic>.from(
          question['calculation_data'] ?? {},
        ),
        explanation: question['erklaerung'],
        onAnswered: _nextQuestion,
        questionId: question['id'],
        moduleId: widget.moduleId,
      );
    } else if (questionType == 'freitext_ada') {
      return FreitextAdaWidget(
        questionText: question['frage'],
        correctAnswers: Map<String, dynamic>.from(
          question['calculation_data'] ?? {},
        ),
        explanation: question['erklaerung'],
        onAnswered: _nextQuestion,
        questionId: question['id'],
        moduleId: widget.moduleId,
      );
    }

    return Center(child: Text('Unbekannter Fragentyp: $questionType'));
  }
}
