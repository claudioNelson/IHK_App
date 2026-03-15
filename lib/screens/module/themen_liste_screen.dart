import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'test_fragen_screen.dart';
import '../../services/app_cache_service.dart';

const _indigo = Color(0xFF4F46E5);
const _indigoDark = Color(0xFF3730A3);
const _indigoLight = Color(0xFF6366F1);

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
    final cacheService = AppCacheService();
    if (cacheService.themenLoaded[widget.modulId] == true) {
      _loadFromCache();
    } else {
      _load();
    }
  }

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
          .select('id, name, beschreibung, sort_index, required_score, unlocked_by, schwierigkeitsgrad')
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
        cachedScores[id] = prefs.getDouble(key) ?? 0.0;
      }
      if (mounted) setState(() {});
    } catch (e) {}
  }

  Future<void> _loadFragenCount() async {
    try {
      final alleFragen = await supabase
          .from('fragen')
          .select('id, thema_id')
          .eq('modul_id', widget.modulId);

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
    switch (difficulty?.toLowerCase()) {
      case 'leicht': return Colors.green;
      case 'mittel': return Colors.orange;
      case 'schwer': return Colors.red;
      default: return Colors.blue;
    }
  }

  IconData _getDifficultyIcon(String? difficulty) {
    switch (difficulty?.toLowerCase()) {
      case 'leicht': return Icons.sentiment_satisfied;
      case 'mittel': return Icons.sentiment_neutral;
      case 'schwer': return Icons.sentiment_very_dissatisfied;
      default: return Icons.help_outline;
    }
  }

  int _getEstimatedMinutes(int? fragenAnzahl) {
    if (fragenAnzahl == null || fragenAnzahl == 0) return 5;
    return (fragenAnzahl * 1.5).ceil();
  }

  // Fortschritt über alle Themen
  double get _overallProgress {
    if (themen.isEmpty) return 0;
    final scores = themen.map((t) => cachedScores[t['id'] as int] ?? 0.0);
    return scores.reduce((a, b) => a + b) / themen.length / 100;
  }

  int get _passedCount {
    return themen.where((t) {
      final id = t['id'] as int;
      final required = (t['required_score'] ?? 80) as int;
      return (cachedScores[id] ?? 0.0) >= required;
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── HEADER ─────────────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: _indigoDark,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_indigoDark, _indigo, _indigoLight],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 48, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.modulName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${themen.length} Themen verfügbar',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (!loading)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '$_passedCount/${themen.length} ✓',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (!loading && themen.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          // Fortschrittsbalken
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: _overallProgress,
                                    backgroundColor:
                                        Colors.white.withOpacity(0.2),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            Colors.white),
                                    minHeight: 6,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '${(_overallProgress * 100).toInt()}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              title: Text(
                widget.modulName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          if (loading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: _indigo),
              ),
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
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    return TweenAnimationBuilder<double>(
                      duration: Duration(milliseconds: 200 + (i * 80)),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 24 * (1 - value)),
                          child: Opacity(opacity: value, child: child),
                        );
                      },
                      child:
                          _buildThemaCard(themen[i] as Map<String, dynamic>),
                    );
                  },
                  childCount: themen.length,
                ),
              ),
            ),
        ],
      ),
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
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border.all(
          color: unlocked
              ? (isPassed
                  ? Colors.green.withOpacity(0.3)
                  : _indigo.withOpacity(0.12))
              : Colors.grey.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: unlocked
                ? _indigo.withOpacity(0.08)
                : Colors.grey.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () =>
              unlocked ? _openThema(thema) : _showLockedDialog(thema),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Icon Container
                    AnimatedBuilder(
                      animation: _lockAnimController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: unlocked
                              ? 0
                              : _lockAnimController.value * 0.08 - 0.04,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: unlocked
                                    ? (isPassed
                                        ? [Colors.green.shade400, Colors.green.shade700]
                                        : [_indigoLight, _indigoDark])
                                    : [Colors.grey.shade400, Colors.grey.shade600],
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: (unlocked
                                          ? (isPassed ? Colors.green : _indigo)
                                          : Colors.grey)
                                      .withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Icon(
                              unlocked
                                  ? (isPassed
                                      ? Icons.check_rounded
                                      : Icons.menu_book_rounded)
                                  : Icons.lock_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(width: 14),

                    // Name + Badge
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: unlocked
                                        ? const Color(0xFF1A1A2E)
                                        : Colors.grey.shade500,
                                  ),
                                ),
                              ),
                              if (isPerfect && unlocked)
                                _buildBadge(
                                    Icons.star_rounded, '100%', Colors.amber)
                              else if (isPassed && unlocked)
                                _buildBadge(Icons.check_circle_rounded,
                                    'Bestanden', Colors.green),
                            ],
                          ),
                          if (thema['beschreibung'] != null &&
                              thema['beschreibung'].toString().isNotEmpty) ...[
                            const SizedBox(height: 3),
                            Text(
                              thema['beschreibung'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Score Ring
                    if (unlocked) ...[
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 56,
                        height: 56,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 56,
                              height: 56,
                              child: CircularProgressIndicator(
                                value: 1.0,
                                strokeWidth: 5,
                                backgroundColor: Colors.transparent,
                                valueColor: AlwaysStoppedAnimation(
                                    Colors.grey.shade200),
                              ),
                            ),
                            SizedBox(
                              width: 56,
                              height: 56,
                              child: TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 900),
                                tween: Tween(begin: 0.0, end: score / 100),
                                curve: Curves.easeOutCubic,
                                builder: (context, value, _) {
                                  return CircularProgressIndicator(
                                    value: value,
                                    strokeWidth: 5,
                                    backgroundColor: Colors.transparent,
                                    valueColor: AlwaysStoppedAnimation(
                                      isPassed ? Colors.green : _indigo,
                                    ),
                                    strokeCap: StrokeCap.round,
                                  );
                                },
                              ),
                            ),
                            Text(
                              '${score.toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isPassed ? Colors.green : _indigo,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 14),

                // Chips
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
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
                      _indigo,
                    ),
                    _buildInfoChip(
                      Icons.timer_outlined,
                      '~$estimatedMin Min',
                      Colors.orange,
                    ),
                    if (!unlocked)
                      _buildInfoChip(
                        Icons.military_tech_rounded,
                        'Mind. $requiredScore%',
                        Colors.purple,
                      ),
                  ],
                ),

                // Locked Hinweis
                if (!unlocked) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline,
                            size: 18, color: Colors.orange.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _getUnlockMessage(thema),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange.shade800,
                              fontWeight: FontWeight.w500,
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
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient:
            LinearGradient(colors: [color, color.withOpacity(0.8)]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [_indigoLight, _indigoDark]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.lock_rounded,
                  color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Thema gesperrt',
                style: TextStyle(fontSize: 17),
              ),
            ),
          ],
        ),
        content: Text(
          _getUnlockMessage(thema),
          style: const TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: _indigo),
            child: const Text('Verstanden'),
          ),
        ],
      ),
    );
  }
}