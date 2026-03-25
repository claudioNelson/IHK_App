// lib/screens/learning/review_screen.dart
import 'package:flutter/material.dart';
import '../../services/spaced_repetition_service.dart';
import 'review_questions_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _indigo = Color(0xFF4F46E5);
const _indigoDark = Color(0xFF3730A3);
const _indigoLight = Color(0xFF6366F1);
const _orange = Color(0xFFEA580C);

class ReviewScreen extends StatefulWidget {
  final int? totalCount;
  const ReviewScreen({super.key, this.totalCount});

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
    final frageIds = _dueQuestions.map((q) => q['frage_id'] as int).toList();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReviewQuestionsScreen(
          frageIds: frageIds,
          dueQuestions: _dueQuestions,
        ),
      ),
    );
    _loadDueQuestions();
  }

  String _getModulName(List<Map<String, dynamic>> questions) {
    try {
      final frage = questions.first['fragen'] as Map<String, dynamic>?;
      final modul = frage?['module'] as Map<String, dynamic>?;
      if (modul?['name'] != null) return modul!['name'];
      if (frage?['modul_id'] == null) return 'Kernthemen';
      return 'Modul ${frage!['modul_id']}';
    } catch (e) {
      return 'Kernthemen';
    }
  }

  Future<void> _checkAndShowInfoDialog() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenInfo = prefs.getBool('has_seen_srs_info') ?? false;
    if (!hasSeenInfo && mounted) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      _showInfoDialog();
      await prefs.setBool('has_seen_srs_info', true);
    }
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [_indigoDark, _indigo],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.psychology_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Wie funktioniert das?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Spaced Repetition ist die effektivste Lernmethode!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  Icons.trending_down_rounded,
                  Colors.red,
                  'Das Problem',
                  'Wir vergessen 80% des Gelernten innerhalb von 24 Stunden!',
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.wb_incandescent_rounded,
                  _orange,
                  'Die Lösung',
                  'Gezielte Wiederholung in optimalen Abständen: 1 Tag → 3 Tage → 1 Woche...',
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.auto_awesome_rounded,
                  Colors.blue,
                  'So funktioniert\'s',
                  'Die App merkt sich welche Fragen du falsch hattest, wann du sie wiederholen solltest und wie oft du sie schon richtig hattest.',
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.emoji_events_rounded,
                  Colors.amber,
                  'Dein Vorteil',
                  'Solides Langzeitwissen statt schnelles Vergessen!',
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _indigo.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _indigo.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.science_rounded,
                        color: _indigo,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Basiert auf über 100 Jahren Gedächtnisforschung',
                          style: TextStyle(
                            fontSize: 12,
                            color: _indigo,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Verstanden'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _startReview();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _indigo,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Los geht\'s!'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
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
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
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
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 3),
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

  @override
  Widget build(BuildContext context) {
    final byModule = <String, List<Map<String, dynamic>>>{};
    int skipped = 0;
    for (final q in _dueQuestions) {
      final frage = q['fragen'] as Map<String, dynamic>?;
      if (frage == null) {
        skipped++;
        print('⚠️ Übersprungen: $q');
        continue;
      }
      final modul = frage['module'] as Map<String, dynamic>?;
      print('🔍 modul: $modul, modul_id: ${frage['modul_id']}');
      final modulName =
          modul?['name'] ??
          (frage['modul_id'] == null
              ? 'Kernthemen'
              : 'Modul ${frage['modul_id']}');
      byModule.putIfAbsent(modulName, () => []).add(q);
    }
    print('⚠️ Gesamt übersprungen: $skipped von ${_dueQuestions.length}');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      body: Column(
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFC2410C), _orange, Color(0xFFFB923C)],
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
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Row(
                  children: [
                    if (Navigator.canPop(context)) ...[
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 4),
                    ],
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.replay_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Wiederholungen',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _loading
                                ? 'Lädt...'
                                : '${_dueQuestions.length} Fragen fällig',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.help_outline_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      onPressed: _showInfoDialog,
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: _orange))
                : _dueQuestions.isEmpty
                ? _buildEmptyState()
                : _buildContent(byModule),
          ),
        ],
      ),
      floatingActionButton: _dueQuestions.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _startReview,
              backgroundColor: _orange,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text(
                'Starten',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              size: 80,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Alles erledigt! 🎉',
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

  Widget _buildContent(Map<String, List<Map<String, dynamic>>> byModule) {
    return RefreshIndicator(
      color: _orange,
      onRefresh: _loadDueQuestions,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
        children: [
          // Summary Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _orange.withOpacity(0.2), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: _orange.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _orange,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: _orange.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.replay_circle_filled_rounded,
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
                        '${widget.totalCount ?? _dueQuestions.length} Fragen',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'aus ${byModule.length} Modulen',
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

          const SizedBox(height: 20),

          // Modul-Liste
          ...byModule.entries.map((entry) {
            final modulName = entry.key;
            final questions = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _indigo.withOpacity(0.1), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _indigo.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.auto_stories_rounded,
                      color: _indigo,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getModulName(entry.value),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          '${questions.length} Fragen fällig',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 13,
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
                      color: _orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _orange.withOpacity(0.3)),
                    ),
                    child: Text(
                      '${questions.length}',
                      style: const TextStyle(
                        color: _orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
