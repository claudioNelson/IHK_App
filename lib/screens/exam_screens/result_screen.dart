// screens/exam_screens/result_screen.dart

import 'package:flutter/material.dart';
import '../../models/question_model.dart';
import '../../services/gemini_service.dart';

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

  int _getTotalPoints() {
    int total = 0;
    for (var section in widget.sections) {
      total += section.totalPoints;
    }
    return total;
  }

  int _getAnsweredCount() {
    return widget.userAnswers.length;
  }

  int _getTotalQuestions() {
    int total = 0;
    for (var section in widget.sections) {
      total += section.questions.length;
    }
    return total;
  }

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    return '${hours}h ${minutes}m ${secs}s';
  }

  Future<void> _requestKiKorrektur() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Sammle alle Fragen und Antworten
      final allQuestions = <Map<String, dynamic>>[];
      
      for (var section in widget.sections) {
        for (var question in section.questions) {
          final userAnswer = widget.userAnswers[question.id];
          
          allQuestions.add({
            'frage': '${question.title}: ${question.description}',
            'typ': question.type.toString(),
            'user_antwort': userAnswer?.toString() ?? 'Nicht beantwortet',
            'section': section.title,
          });
        }
      }

      // Baue Prompt für Gemini
      final prompt = _buildKorrekturPrompt(allQuestions);
      
      final response = await _geminiService.generateContent(prompt);
      
      setState(() {
        _kiKorrektur = response;
        _showKorrektur = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler bei KI-Korrektur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _buildKorrekturPrompt(List<Map<String, dynamic>> questions) {
    final buffer = StringBuffer();
    
    buffer.writeln('Du bist ein freundlicher IHK-Prüfer und Tutor für Fachinformatiker.');
    buffer.writeln('');
    buffer.writeln('Ein Azubi hat gerade eine Prüfungssimulation abgeschlossen.');
    buffer.writeln('Bitte analysiere die Antworten und gib konstruktives Feedback.');
    buffer.writeln('');
    buffer.writeln('=== PRÜFUNGSDATEN ===');
    buffer.writeln('Bearbeitungszeit: ${_formatTime(widget.timeSpent)}');
    buffer.writeln('Beantwortete Fragen: ${_getAnsweredCount()} von ${_getTotalQuestions()}');
    buffer.writeln('');
    buffer.writeln('=== FRAGEN UND ANTWORTEN ===');
    
    for (int i = 0; i < questions.length; i++) {
      final q = questions[i];
      buffer.writeln('');
      buffer.writeln('Frage ${i + 1} (${q['section']}):');
      buffer.writeln('${q['frage']}');
      buffer.writeln('Antwort des Schülers: ${q['user_antwort']}');
    }
    
    buffer.writeln('');
    buffer.writeln('=== DEINE AUFGABE ===');
    buffer.writeln('');
    buffer.writeln('Bitte gib ein ausführliches Feedback mit:');
    buffer.writeln('');
    buffer.writeln('1. 📊 GESAMTBEWERTUNG');
    buffer.writeln('   - Wie gut hat der Schüler abgeschnitten?');
    buffer.writeln('   - Geschätzte Punktzahl und ob bestanden');
    buffer.writeln('');
    buffer.writeln('2. ✅ STÄRKEN');
    buffer.writeln('   - Was hat der Schüler gut gemacht?');
    buffer.writeln('   - Welche Themenbereiche sitzen?');
    buffer.writeln('');
    buffer.writeln('3. ⚠️ VERBESSERUNGSBEDARF');
    buffer.writeln('   - Welche Antworten waren falsch oder unvollständig?');
    buffer.writeln('   - Erkläre kurz die richtige Lösung');
    buffer.writeln('');
    buffer.writeln('4. 📚 LERNEMPFEHLUNGEN');
    buffer.writeln('   - Welche Themen sollte der Schüler wiederholen?');
    buffer.writeln('   - Konkrete Tipps fürs Weiterlernen');
    buffer.writeln('');
    buffer.writeln('5. 💪 MOTIVATION');
    buffer.writeln('   - Ermutige den Schüler!');
    buffer.writeln('');
    buffer.writeln('Antworte auf Deutsch, freundlich und motivierend. Nutze Emojis für Übersichtlichkeit.');
    
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final totalPoints = _getTotalPoints();
    final answeredCount = _getAnsweredCount();
    final totalQuestions = _getTotalQuestions();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text(
          'Prüfung abgeschlossen',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Erfolgs-Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green[700]!, Colors.green[500]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.check_circle,
                      size: 60,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Prüfung erfolgreich abgegeben!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lass die KI deine Antworten korrigieren',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            // Statistiken
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildStatCard(
                    icon: Icons.assignment_turned_in,
                    title: 'Beantwortete Fragen',
                    value: '$answeredCount / $totalQuestions',
                    color: Colors.blue,
                    subtitle: '${((answeredCount / totalQuestions) * 100).toStringAsFixed(1)}% vollständig',
                  ),
                  const SizedBox(height: 16),
                  _buildStatCard(
                    icon: Icons.stars,
                    title: 'Mögliche Punkte',
                    value: '$totalPoints Punkte',
                    color: Colors.orange,
                    subtitle: '100 Punkte gesamt',
                  ),
                  const SizedBox(height: 16),
                  _buildStatCard(
                    icon: Icons.timer,
                    title: 'Bearbeitungszeit',
                    value: _formatTime(widget.timeSpent),
                    color: Colors.purple,
                    subtitle: 'von 90 Minuten',
                  ),
                ],
              ),
            ),

            // KI-Korrektur Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _requestKiKorrektur,
                  icon: _isLoading 
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.psychology, size: 28),
                  label: Text(
                    _isLoading ? 'KI analysiert...' : '🤖 KI-Tutor Korrektur anfordern',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),

            // KI-Korrektur Ergebnis
            if (_showKorrektur && _kiKorrektur != null) ...[
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple[50]!, Colors.blue[50]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.purple[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.purple[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.psychology,
                              color: Colors.purple[700],
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'KI-Tutor Feedback',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      SelectableText(
                        _kiKorrektur!,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Aufschlüsselung nach Handlungsschritten
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Aufschlüsselung nach Handlungsschritten',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...widget.sections.map((section) {
                    final sectionAnswered = section.questions
                        .where((q) => widget.userAnswers.containsKey(q.id))
                        .length;
                    final sectionTotal = section.questions.length;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    section.title,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${section.totalPoints} Punkte',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[700],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: sectionAnswered / sectionTotal,
                                    backgroundColor: Colors.grey[200],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.green[600]!,
                                    ),
                                    minHeight: 8,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '$sectionAnswered / $sectionTotal',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Aktions-Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.home),
                      label: const Text('Zurück zur Startseite'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required String subtitle,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
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
}