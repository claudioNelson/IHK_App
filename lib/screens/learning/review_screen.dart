import 'package:flutter/material.dart';
import '../../services/spaced_repetition_service.dart';
import 'review_questions_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final _srsService = SpacedRepetitionService();
  List<Map<String, dynamic>> _dueQuestions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDueQuestions();
    _checkAndShowInfoDialog();
  }

  Future<void> _loadDueQuestions() async {
    final questions = await _srsService.getDueQuestions();
    if (!mounted) return;
    setState(() {
      _dueQuestions = questions;
      _loading = false;
    });
  }

  void _startReview() async {
    if (_dueQuestions.isEmpty) return;

    // Sammle alle Fragen-IDs und Modul-Infos
    final frageIds = _dueQuestions.map((q) => q['frage_id'] as int).toList();

    // Navigation zu speziellem Review-Screen
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReviewQuestionsScreen(
          frageIds: frageIds,
          dueQuestions: _dueQuestions,
        ),
      ),
    );

    // Nach Review neu laden
    _loadDueQuestions();
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.purple.shade700],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Wie funktioniert das?',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Einleitung
              const Text(
                'Spaced Repetition ist wissenschaftlich bewiesen die effektivste Lernmethode!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 16),

              // Ebbinghaus
              _buildInfoSection(
                Icons.trending_down,
                Colors.red,
                'Das Problem',
                'Nach der Ebbinghaus-Vergessenskurve vergessen wir 80% des Gelernten innerhalb von 24 Stunden!',
              ),
              const SizedBox(height: 12),

              // Lösung
              _buildInfoSection(
                Icons.wb_incandescent,
                Colors.orange,
                'Die Lösung',
                'Durch gezielte Wiederholung in optimalen Abständen (1 Tag → 3 Tage → 1 Woche...) wandert Wissen ins Langzeitgedächtnis.',
              ),
              const SizedBox(height: 12),

              // Wie es funktioniert
              _buildInfoSection(
                Icons.auto_awesome,
                Colors.blue,
                'So funktioniert\'s',
                'Die App merkt sich automatisch:\n• Welche Fragen du falsch beantwortet hast\n• Wann du sie wiederholen solltest\n• Wie oft du sie schon richtig hattest',
              ),
              const SizedBox(height: 12),

              // Vorteil
              _buildInfoSection(
                Icons.emoji_events,
                Colors.amber,
                'Dein Vorteil',
                'Statt alles kurz vor der Prüfung zu pauken (und schnell zu vergessen), baust du solides Langzeitwissen auf!',
              ),
              const SizedBox(height: 16),

              // Wissenschaft
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.purple.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.science,
                      color: Colors.purple.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Basiert auf über 100 Jahren Gedächtnisforschung',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.purple.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Verstanden'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startReview();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Los geht\'s!'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    IconData icon,
    Color color,
    String title,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(fontSize: 13, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _checkAndShowInfoDialog() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenInfo = prefs.getBool('has_seen_srs_info') ?? false;

    if (!hasSeenInfo && mounted) {
      // Kurz warten damit Screen geladen ist
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;

      _showInfoDialog();
      await prefs.setBool('has_seen_srs_info', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Wiederholungen',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _dueQuestions.isEmpty
          ? _buildEmptyState()
          : _buildQuestionsList(),
      floatingActionButton: _dueQuestions.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _startReview,
              backgroundColor: Colors.orange,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Starten'),
            )
          : null,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle,
              size: 80,
              color: Colors.green.shade400,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Alles erledigt!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Keine Fragen zum Wiederholen',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsList() {
    // Gruppiere nach Modul
    final Map<int, List<Map<String, dynamic>>> byModule = {};
    for (final q in _dueQuestions) {
      final frage = q['fragen'] as Map<String, dynamic>?;
      if (frage == null) continue;
      final modulId = frage['modul_id'] as int? ?? 0;
      byModule.putIfAbsent(modulId, () => []).add(q);
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade50, Colors.white],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.orange.shade200),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.replay_circle_filled,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_dueQuestions.length} Fragen',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Aus ${byModule.length} Modulen',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Module auflisten
        ...byModule.entries.map((entry) {
          final modulId = entry.key;
          final questions = entry.value;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.auto_stories,
                    color: Colors.indigo.shade700,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Modul $modulId',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${questions.length} Fragen',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${questions.length}',
                    style: TextStyle(
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),

        const SizedBox(height: 100),
      ],
    );
  }
}
