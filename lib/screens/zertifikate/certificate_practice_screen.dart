import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CertificatePracticeScreen extends StatefulWidget {
  final int zertifikatId;
  final String certName;

  const CertificatePracticeScreen({
    Key? key,
    required this.zertifikatId,
    required this.certName,
  }) : super(key: key);

  @override
  _CertificatePracticeScreenState createState() =>
      _CertificatePracticeScreenState();
}

class _CertificatePracticeScreenState extends State<CertificatePracticeScreen> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> questions = [];
  int currentIndex = 0;
  num? userAnswer;
  bool showExplanation = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      print('🔍 Lade Fragen für Zertifikat ID: ${widget.zertifikatId}');

      // 1. Finde alle Exams
      final exams = await supabase
          .from('exams')
          .select('id, name, is_published')
          .eq('zertifikat_id', widget.zertifikatId);

      print('🔍 Gefundene Exams: $exams');
      print('🔍 Anzahl Exams: ${exams.length}');

      if (exams.isEmpty) {
        print('⚠️ Keine Exams gefunden für Zertifikat ${widget.zertifikatId}');
        setState(() => isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Keine Übungsfragen verfügbar')),
          );
        }
        return;
      }

      // 2. Lade alle Fragen aus diesen Exams
      final examIds = exams.map((e) => e['id']).toList();
      print('🔍 Exam IDs: $examIds');

      final result = await supabase
          .from('exam_questions')
          .select()
          .in_('exam_id', examIds) // ← WICHTIG: .in_() statt .inFilter()
          .order('exam_id, aufgabe_nummer');

      print('🔍 Gefundene Fragen: ${result.length}');
      print(
        '🔍 Erste Frage (falls vorhanden): ${result.isNotEmpty ? result[0] : "keine"}',
      );

      setState(() {
        questions = List<Map<String, dynamic>>.from(result);
        isLoading = false;
      });
    } catch (e, stackTrace) {
      print('❌ FEHLER beim Laden: $e');
      print('📍 StackTrace: $stackTrace');

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Fehler beim Laden: $e')));
      }
      setState(() => isLoading = false);
    }
  }

  void _checkAnswer(num answer) {
    setState(() {
      userAnswer = answer;
      showExplanation = true;
    });
  }

  void _nextQuestion() {
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        userAnswer = null;
        showExplanation = false;
      });
    } else {
      // Quiz abgeschlossen
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('🎉 Fertig!'),
          content: const Text('Du hast alle Fragen durchgearbeitet.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
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
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.certName),
          backgroundColor: Colors.deepOrange,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.certName),
          backgroundColor: Colors.deepOrange,
        ),
        body: const Center(child: Text('Keine Übungsfragen verfügbar')),
      );
    }

    final question = questions[currentIndex];
    final calcData = question['calculation_data'] as Map<String, dynamic>?;
    final correctAnswer = calcData?['correctAnswer'] as num?;
    final explanation = calcData?['explanation'] as String?;
    final hint = calcData?['hint'] as String?;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.certName),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress
            LinearProgressIndicator(
              value: (currentIndex + 1) / questions.length,
              backgroundColor: Colors.grey.shade300,
              color: Colors.deepOrange,
            ),
            const SizedBox(height: 8),
            Text(
              'Frage ${currentIndex + 1} von ${questions.length}',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),

            // Frage Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aufgabe ${question['aufgabe_nummer']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.deepOrange.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      question['frage'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (hint != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              color: Colors.blue.shade700,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                hint,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue.shade900,
                                ),
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
            const SizedBox(height: 16),

            // Antwort Eingabe
            if (!showExplanation)
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Deine Antwort',
                          border: OutlineInputBorder(),
                          hintText: 'Gib eine Zahl ein',
                        ),
                        onSubmitted: (value) {
                          final parsed = num.tryParse(value);
                          if (parsed != null) _checkAnswer(parsed);
                        },
                        onChanged: (value) {
                          final parsed = num.tryParse(value);
                          if (parsed != null) {
                            setState(() => userAnswer = parsed);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: userAnswer != null
                            ? () => _checkAnswer(userAnswer!)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Antwort prüfen',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Erklärung
            if (showExplanation) ...[
              Card(
                color: userAnswer == correctAnswer
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            userAnswer == correctAnswer
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: userAnswer == correctAnswer
                                ? Colors.green
                                : Colors.red,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userAnswer == correctAnswer
                                      ? 'Richtig!'
                                      : 'Falsch!',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: userAnswer == correctAnswer
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                                Text(
                                  'Deine Antwort: $userAnswer',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                if (userAnswer != correctAnswer)
                                  Text(
                                    'Richtig wäre: $correctAnswer',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (explanation != null) ...[
                        const Divider(height: 24),
                        Text(
                          'Erklärung:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(explanation, style: const TextStyle(fontSize: 14)),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  currentIndex < questions.length - 1
                      ? 'Nächste Frage'
                      : 'Fertig',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

extension on PostgrestFilterBuilder {
  inFilter(String s, examIds) {}
}
