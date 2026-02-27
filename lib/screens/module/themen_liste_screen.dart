import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'test_fragen_screen.dart';
import '../../services/app_cache_service.dart';

class ThemenListe extends StatefulWidget {
  final int modulId;
  final String modulName;
  final Function(int)? onThemaSelected;

  const ThemenListe({
    super.key,
    required this.modulId,
    required this.modulName,
    this.onThemaSelected,
  });

  @override
  State<ThemenListe> createState() => _ThemenListeState();
}

class _ThemenListeState extends State<ThemenListe>
    with TickerProviderStateMixin {
  final supabase = Supabase.instance.client;

  List<dynamic> themen = [];
  bool loading = true;
  Map<int, double> cachedScores = {};
  Map<int, int> themenRequired = {};
  Map<int, int> fragenCount = {};

  late AnimationController _lockAnimController;

  @override
  void initState() {
    super.initState();
    _setupAnimations();

    // ⭐ NEU: Cache prüfen
    final cacheService = AppCacheService();
    if (cacheService.themenLoaded[widget.modulId] == true) {
      _loadFromCache();
    } else {
      _load();
    }
  }

  // ⭐ NEU: Aus Cache laden
  void _loadFromCache() {
    final cacheService = AppCacheService();
    setState(() {
      themen = cacheService.cachedThemen[widget.modulId] ?? [];
      fragenCount = cacheService.cachedFragenCount[widget.modulId] ?? {};
      loading = false;
    });
    _loadScores();
  }

  @override
  void dispose() {
    _lockAnimController.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    _lockAnimController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
  }

  Future<void> _load() async {
    setState(() => loading = true);

    await Future.wait([_loadThemen(), _loadScores()]);

    await _loadFragenCount();

    // ⭐ NEU: In Cache speichern
    final cacheService = AppCacheService();
    cacheService.cachedThemen[widget.modulId] = themen;
    cacheService.cachedFragenCount[widget.modulId] = fragenCount;
    cacheService.themenLoaded[widget.modulId] = true;

    if (!mounted) return;
    setState(() => loading = false);
  }

  Future<void> _loadThemen() async {
    try {
      final res = await supabase
          .from('themen')
          .select(
            'id, name, beschreibung, sort_index, required_score, unlocked_by, schwierigkeitsgrad',
          )
          .eq('module_id', widget.modulId)
          .order('sort_index, id');

      if (!mounted) return;

      themen = res;
      for (final t in res) {
        themenRequired[t['id'] as int] = (t['required_score'] ?? 80) as int;
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Laden der Themen: $e')),
      );
    }
  }

  Future<void> _loadScores() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      for (final t in themen) {
        final id = t['id'] as int;
        final key = _scoreKey(widget.modulId, id);
        final val = prefs.getDouble(key) ?? 0.0;
        cachedScores[id] = val;
      }
    } catch (e) {
      // Fehler ignorieren
    }
  }

  Future<void> _loadFragenCount() async {
    try {
      // ⭐ ALTE Version (langsam):
      // for (final t in themen) {
      //   final response = await supabase.from('fragen').select('id').eq('thema_id', id);
      // }

      // ⭐ NEUE Version (schnell): ALLE Fragen auf einmal holen
      final alleFragen = await supabase
          .from('fragen')
          .select('id, thema_id')
          .eq('modul_id', widget.modulId);

      // Im Speicher zählen
      for (final frage in alleFragen) {
        final themaId = frage['thema_id'] as int;
        fragenCount[themaId] = (fragenCount[themaId] ?? 0) + 1;
      }
    } catch (e) {
      print('Fehler beim Laden der Fragen-Counts: $e');
    }
  }

  static String _scoreKey(int modulId, int themaId) =>
      'score_mod_${modulId}_thema_$themaId';

  bool _isUnlocked(Map<String, dynamic> thema) {
    final int? unlockedBy = thema['unlocked_by'] as int?;
    if (unlockedBy == null) return true;
    final double prevScore = cachedScores[unlockedBy] ?? 0.0;
    final int needed = themenRequired[unlockedBy] ?? 80;
    return prevScore >= needed;
  }

  Color _getDifficultyColor(String? difficulty) {
    if (difficulty == null) return Colors.blue;
    switch (difficulty.toLowerCase()) {
      case 'leicht':
        return Colors.green;
      case 'mittel':
        return Colors.orange;
      case 'schwer':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  IconData _getDifficultyIcon(String? difficulty) {
    if (difficulty == null) return Icons.help_outline;
    switch (difficulty.toLowerCase()) {
      case 'leicht':
        return Icons.sentiment_satisfied;
      case 'mittel':
        return Icons.sentiment_neutral;
      case 'schwer':
        return Icons.sentiment_very_dissatisfied;
      default:
        return Icons.help_outline;
    }
  }

  int _getEstimatedMinutes(int? fragenAnzahl) {
    if (fragenAnzahl == null || fragenAnzahl == 0) return 5;
    return (fragenAnzahl * 1.5).ceil();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.modulName,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.indigo.shade50, Colors.white],
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 60),
                    child: Text(
                      'Themen',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo.shade700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          if (loading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (themen.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text(
                  'Keine Themen vorhanden',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, i) {
                  return TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 200 + (i * 100)),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, 30 * (1 - value)),
                        child: Opacity(opacity: value, child: child),
                      );
                    },
                    child: _buildThemaCard(themen[i] as Map<String, dynamic>),
                  );
                }, childCount: themen.length),
              ),
            ),
        ],
      ),
      backgroundColor: Colors.grey[50],
    );
  }

  Widget _buildThemaCard(Map<String, dynamic> thema) {
    final id = thema['id'] as int;
    final unlocked = _isUnlocked(thema);
    final score = cachedScores[id] ?? 0.0;
    final difficulty = thema['schwierigkeitsgrad'] as String?;
    final fragenAnzahl = fragenCount[id] ?? 0;
    final estimatedMin = _getEstimatedMinutes(fragenAnzahl);
    final requiredScore = thema['required_score'] ?? 80;
    final isPerfect = score >= 100;
    final isPassed = score >= requiredScore;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => unlocked ? _openThema(thema) : _showLockedDialog(thema),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: unlocked
                    ? [Colors.white, Colors.indigo.shade50.withValues(alpha: 0.3)]
                    : [Colors.grey.shade100, Colors.grey.shade200],
              ),
              boxShadow: [
                BoxShadow(
                  color: unlocked
                      ? Colors.indigo.withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AnimatedBuilder(
                        animation: _lockAnimController,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: unlocked
                                ? 0
                                : _lockAnimController.value * 0.1 - 0.05,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: unlocked
                                      ? [Colors.green, Colors.green.shade700]
                                      : [Colors.grey, Colors.grey.shade700],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        (unlocked ? Colors.green : Colors.grey)
                                            .withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                unlocked ? Icons.lock_open : Icons.lock,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    thema['name'] ?? '',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: unlocked
                                          ? Colors.black
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                                if (isPerfect && unlocked)
                                  _buildBadge(Icons.star, '100%', Colors.amber)
                                else if (isPassed && unlocked)
                                  _buildBadge(
                                    Icons.check_circle,
                                    'Bestanden',
                                    Colors.green,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            if (thema['beschreibung'] != null &&
                                thema['beschreibung'].toString().isNotEmpty)
                              Text(
                                thema['beschreibung'],
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),

                      if (unlocked)
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 60,
                                height: 60,
                                child: CircularProgressIndicator(
                                  value: 1.0,
                                  strokeWidth: 5,
                                  backgroundColor: Colors.transparent,
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.grey.shade300,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 60,
                                height: 60,
                                child: TweenAnimationBuilder<double>(
                                  duration: const Duration(milliseconds: 800),
                                  tween: Tween(begin: 0.0, end: score / 100),
                                  curve: Curves.easeOutCubic,
                                  builder: (context, value, child) {
                                    return CircularProgressIndicator(
                                      value: value,
                                      strokeWidth: 5,
                                      backgroundColor: Colors.transparent,
                                      valueColor: AlwaysStoppedAnimation(
                                        score >= requiredScore
                                            ? Colors.green
                                            : Colors.indigo,
                                      ),
                                      strokeCap: StrokeCap.round,
                                    );
                                  },
                                ),
                              ),
                              Text(
                                '${score.toStringAsFixed(0)}%',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: score >= requiredScore
                                      ? Colors.green
                                      : Colors.indigo,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (difficulty != null && difficulty.isNotEmpty)
                        _buildInfoChip(
                          _getDifficultyIcon(difficulty),
                          difficulty,
                          _getDifficultyColor(difficulty),
                        ),
                      _buildInfoChip(
                        Icons.quiz_outlined,
                        '$fragenAnzahl Fragen',
                        Colors.blue,
                      ),
                      _buildInfoChip(
                        Icons.timer_outlined,
                        '~$estimatedMin Min',
                        Colors.orange,
                      ),
                      if (!unlocked)
                        _buildInfoChip(
                          Icons.military_tech,
                          'Mind. $requiredScore%',
                          Colors.purple,
                        ),
                    ],
                  ),

                  if (!unlocked) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 20,
                            color: Colors.orange.shade700,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _getUnlockMessage(thema),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange.shade700,
                                fontWeight: FontWeight.w600,
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
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.8)]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  String _getUnlockMessage(Map<String, dynamic> thema) {
    final prevId = thema['unlocked_by'];
    final need = themenRequired[prevId] ?? 80;
    final have = cachedScores[prevId] ?? 0.0;

    final prevThema = themen.firstWhere(
      (t) => t['id'] == prevId,
      orElse: () => {'name': 'vorheriges Thema'},
    );

    return 'Erreiche mindestens $need% in "${prevThema['name']}" (aktuell ${have.toStringAsFixed(0)}%)';
  }

  void _openThema(Map<String, dynamic> thema) async {
    final id = thema['id'] as int;

    widget.onThemaSelected?.call(id);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TestFragen(
          modulId: widget.modulId,
          modulName: '${widget.modulName} • ${thema['name']}',
          themaId: id,
        ),
      ),
    );
    await _load();
  }

  void _showLockedDialog(Map<String, dynamic> thema) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.lock, color: Colors.orange.shade700),
            ),
            const SizedBox(width: 12),
            const Expanded(child: Text('Thema gesperrt')),
          ],
        ),
        content: Text(_getUnlockMessage(thema)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Verstanden'),
          ),
        ],
      ),
    );
  }
}
