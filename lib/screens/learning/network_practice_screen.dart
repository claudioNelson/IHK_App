import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/questions/network_calculation_widget.dart';

class NetworkPracticeScreen extends StatefulWidget {
  final int moduleId;
  final String moduleName;

  const NetworkPracticeScreen({
    super.key,
    required this.moduleId,
    required this.moduleName,
  });

  @override
  State<NetworkPracticeScreen> createState() => _NetworkPracticeScreenState();
}

class _NetworkPracticeScreenState extends State<NetworkPracticeScreen> {
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
          .select('id, frage, calculation_data, erklaerung')
          .eq('modul_id', widget.moduleId)
          .eq('question_type', 'network_calculation')
          .order('id');

      if (!mounted) return;
      setState(() {
        _questions = List<Map<String, dynamic>>.from(data);
        _questions.shuffle();
        _loading = false;
      });
      if (_questions.isNotEmpty) {
        print('🟢 Erste Frage geladen:');
        print('   ID: ${_questions[0]['id']}');
        print('   ModulID: ${widget.moduleId}');
      }
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
        backgroundColor: Colors.teal,
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
                // Progress Bar
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
                              color: Colors.teal.shade700,
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
                          Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ),

                // Question Widget
                Expanded(
                  child: NetworkCalculationWidget(
                    questionText: _questions[_currentIndex]['frage'],
                    correctAnswers: Map<String, String>.from(
                      _questions[_currentIndex]['calculation_data'] ?? {},
                    ),
                    explanation: _questions[_currentIndex]['erklaerung'],
                    onAnswered: _nextQuestion,
                    questionId: _questions[_currentIndex]['id'],
                    moduleId: widget.moduleId,
                  ),
                ),
              ],
            ),
    );
  }
}
