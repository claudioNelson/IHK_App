// lib/screens/learning/osi_practice_screen.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/questions/dns_port_match_widget.dart';
import '../../widgets/questions/freitext_ada_widget.dart';

const _indigo = Color(0xFF4F46E5);
const _indigoDark = Color(0xFF3730A3);
const _indigoLight = Color(0xFF6366F1);

class OsiPracticeScreen extends StatefulWidget {
  final int moduleId;
  final String moduleName;

  const OsiPracticeScreen({
    super.key,
    required this.moduleId,
    required this.moduleName,
  });

  @override
  State<OsiPracticeScreen> createState() => _OsiPracticeScreenState();
}

class _OsiPracticeScreenState extends State<OsiPracticeScreen> {
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
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(children: [
            Text('🎉 ', style: TextStyle(fontSize: 24)),
            Text('Fertig!', style: TextStyle(fontWeight: FontWeight.bold)),
          ]),
          content: const Text('Du hast alle Fragen durchgearbeitet!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: _indigo),
              child: const Text('Zurück', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _indigo))
          : _questions.isEmpty
              ? _buildEmpty()
              : Column(
                  children: [
                    _buildHeader(),
                    _buildProgressBar(),
                    Expanded(child: _buildQuestionWidget()),
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
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 20),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.layers_rounded, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.moduleName,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Text('OSI-Modell Übungen',
                        style: TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    final progress = _questions.isEmpty ? 0.0 : (_currentIndex + 1) / _questions.length;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: _indigo.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Frage ${_currentIndex + 1} von ${_questions.length}',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: _indigo.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Text('${(progress * 100).toInt()}%',
                    style: const TextStyle(
                        color: _indigo, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(_indigo),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: _indigo.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.inbox_outlined, size: 56, color: _indigo),
          ),
          const SizedBox(height: 16),
          const Text('Noch keine Fragen verfügbar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text('Schau später nochmal vorbei',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
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
        correctAnswers: Map<String, dynamic>.from(question['calculation_data'] ?? {}),
        explanation: question['erklaerung'],
        onAnswered: (_) => _nextQuestion(),
        questionId: question['id'],
        moduleId: widget.moduleId,
      );
    } else if (questionType == 'freitext_ada') {
      return FreitextAdaWidget(
        questionText: question['frage'],
        correctAnswers: Map<String, dynamic>.from(question['calculation_data'] ?? {}),
        explanation: question['erklaerung'],
        onAnswered: (_) => _nextQuestion(),
        questionId: question['id'],
        moduleId: widget.moduleId,
      );
    }

    return Center(child: Text('Unbekannter Fragentyp: $questionType'));
  }
}
