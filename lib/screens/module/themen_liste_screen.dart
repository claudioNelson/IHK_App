import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'test_fragen_screen.dart';
import '../../services/app_cache_service.dart';
import '../../data/themen_summaries.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';

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

class _ThemenListeState extends State<ThemenListe> {
  final supabase = Supabase.instance.client;

  List<dynamic> themen = [];
  bool loading = true;
  Map<int, double> cachedScores = {};
  Map<int, int> themenRequired = {};
  Map<int, int> fragenCount = {};

  @override
  void initState() {
    super.initState();
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
        SnackBar(
          content: Text('Fehler beim Laden: $e'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
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
    } catch (_) {}
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
      debugPrint('Fehler beim Laden der Fragen-Counts: $e');
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
      case 'leicht':
        return AppColors.success;
      case 'mittel':
        return AppColors.warning;
      case 'schwer':
        return AppColors.error;
      default:
        return AppColors.accentCyan;
    }
  }

  int _getEstimatedMinutes(int? fragenAnzahl) {
    if (fragenAnzahl == null || fragenAnzahl == 0) return 5;
    return (fragenAnzahl * 1.5).ceil();
  }

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
    final isDark = context.read<ThemeProvider>().isDark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Row(
          children: [
            Icon(
              Icons.lock_outline_rounded,
              color: AppColors.warning,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text('Thema gesperrt', style: AppTextStyles.h3(text)),
          ],
        ),
        content: Text(
          _getUnlockMessage(thema),
          style: AppTextStyles.bodyMedium(textMid),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Verstanden'),
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

  void _showSummary(Map<String, dynamic> thema) {
    final id = thema['id'] as int;
    final summary = themenSummaries[id];

    if (summary == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Zusammenfassung folgt bald'),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final isDark = context.read<ThemeProvider>().isDark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

    final sections = summary['sections'] as List;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        builder: (_, scrollController) => Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border(top: BorderSide(color: border)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 3,
                decoration: BoxDecoration(
                  color: textDim,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 12, 16),
                child: Row(
                  children: [
                    Container(width: 16, height: 1, color: AppColors.accent),
                    const SizedBox(width: 10),
                    Text(
                      'ZUSAMMENFASSUNG',
                      style: AppTextStyles.monoLabel(AppColors.accent),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.close_rounded, color: textMid, size: 22),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        summary['title'] as String,
                        style: AppTextStyles.instrumentSerif(
                          size: 30,
                          color: text,
                          letterSpacing: -1.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: border, height: 24),

              // Content
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: sections.length,
                  itemBuilder: (_, i) {
                    final section = sections[i] as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${(i + 1).toString().padLeft(2, '0')}',
                                style: AppTextStyles.mono(
                                  size: 11,
                                  color: AppColors.accent,
                                  weight: FontWeight.w700,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(width: 24, height: 1, color: border),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  section['heading'] as String,
                                  style: AppTextStyles.h3(text),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(left: 44),
                            child: Text(
                              section['text'] as String,
                              style: AppTextStyles.bodyMedium(textMid),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Start Button
              Container(
                padding: EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  MediaQuery.of(context).padding.bottom + 16,
                ),
                decoration: BoxDecoration(
                  color: surface,
                  border: Border(top: BorderSide(color: border)),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _openThema(thema);
                    },
                    icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                    label: const Text('Jetzt üben'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: text,
                      foregroundColor: bg,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: AppTextStyles.labelLarge(bg),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;

    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: [
          // ─── APPBAR ──────────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back_rounded, color: text, size: 22),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      widget.modulName,
                      style: AppTextStyles.instrumentSerif(
                        size: 22,
                        color: text,
                        letterSpacing: -0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── BODY ─────────────────────────────────
          Expanded(
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.accent),
                  )
                : themen.isEmpty
                ? _buildEmpty(textMid, textDim)
                : RefreshIndicator(
                    color: AppColors.accent,
                    onRefresh: _load,
                    child: _buildList(surface, border, text, textMid, textDim),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      children: [
        // Status Banner
        _buildStatusBanner(surface, border, text, textMid, textDim),

        const SizedBox(height: 28),

        // Themen-Header
        Row(
          children: [
            Container(width: 16, height: 1, color: AppColors.accent),
            const SizedBox(width: 10),
            Text(
              'THEMEN · ${themen.length}',
              style: AppTextStyles.monoLabel(AppColors.accent),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Themen-Liste
        ...themen.asMap().entries.map((entry) {
          final idx = entry.key;
          final thema = entry.value as Map<String, dynamic>;
          return _buildThemaCard(
            thema: thema,
            index: idx,
            surface: surface,
            border: border,
            text: text,
            textMid: textMid,
            textDim: textDim,
          );
        }),
      ],
    );
  }

  // ─── STATUS BANNER ───────────────────────────
  Widget _buildStatusBanner(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.015, 0.015, 1.0],
          colors: [AppColors.accent, AppColors.accent, surface, surface],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 16, height: 1, color: AppColors.accent),
              const SizedBox(width: 10),
              Text(
                'DEIN FORTSCHRITT',
                style: AppTextStyles.monoLabel(AppColors.accent),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$_passedCount',
                style: AppTextStyles.instrumentSerif(
                  size: 42,
                  color: text,
                  letterSpacing: -1.5,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '/ ${themen.length} bestanden',
                  style: AppTextStyles.bodyMedium(textMid),
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${(_overallProgress * 100).toInt()}%',
                    style: AppTextStyles.instrumentSerif(
                      size: 28,
                      color: AppColors.accent,
                      letterSpacing: -1,
                    ),
                  ),
                  Text('Ø SCORE', style: AppTextStyles.monoSmall(textDim)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: _overallProgress,
              backgroundColor: border,
              valueColor: const AlwaysStoppedAnimation(AppColors.accent),
              minHeight: 3,
            ),
          ),
        ],
      ),
    );
  }

  // ─── THEMA CARD ──────────────────────────────
  Widget _buildThemaCard({
    required Map<String, dynamic> thema,
    required int index,
    required Color surface,
    required Color border,
    required Color text,
    required Color textMid,
    required Color textDim,
  }) {
    final id = thema['id'] as int;
    final unlocked = _isUnlocked(thema);
    final score = cachedScores[id] ?? 0.0;
    final difficulty = thema['schwierigkeitsgrad'] as String?;
    final fragenAnzahl = fragenCount[id] ?? 0;
    final estimatedMin = _getEstimatedMinutes(fragenAnzahl);
    final requiredScore = (thema['required_score'] ?? 80) as int;
    final isPerfect = score >= 100;
    final isPassed = score >= requiredScore;
    final hasBeschreibung = themenSummaries.containsKey(id);
    final scoreColor = isPerfect
        ? AppColors.accentCyan
        : isPassed
        ? AppColors.success
        : score > 0
        ? AppColors.warning
        : textDim;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => unlocked ? _openThema(thema) : _showLockedDialog(thema),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: !unlocked
                  ? border
                  : isPerfect
                  ? AppColors.accentCyan.withOpacity(0.4)
                  : isPassed
                  ? AppColors.success.withOpacity(0.4)
                  : border,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Index + Name + Status
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Number-Badge
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: !unlocked
                          ? border.withOpacity(0.5)
                          : AppColors.accent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: !unlocked
                            ? border
                            : AppColors.accent.withOpacity(0.3),
                      ),
                    ),
                    child: Center(
                      child: unlocked
                          ? Text(
                              '#${(index + 1).toString().padLeft(2, '0')}',
                              style: AppTextStyles.mono(
                                size: 11,
                                color: AppColors.accent,
                                weight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            )
                          : Icon(Icons.lock_rounded, color: textDim, size: 16),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Name & Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          thema['name'] ?? '',
                          style: AppTextStyles.interTight(
                            size: 15,
                            weight: FontWeight.w600,
                            color: unlocked ? text : textMid,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _buildInfoRow(
                          difficulty: difficulty,
                          fragenAnzahl: fragenAnzahl,
                          estimatedMin: estimatedMin,
                          unlocked: unlocked,
                          textMid: textMid,
                          textDim: textDim,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Right: Status-Badge oder Arrow
                  if (unlocked && isPerfect)
                    _statusBadge('100%', AppColors.accentCyan)
                  else if (unlocked && isPassed)
                    _statusBadge('✓', AppColors.success)
                  else if (unlocked && score > 0)
                    _scoreDisplay(score, scoreColor)
                  else if (unlocked)
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: textDim,
                      size: 12,
                    ),
                ],
              ),

              // Score-Progress (nur wenn gestartet aber nicht fertig)
              if (unlocked && score > 0 && !isPassed) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'FORTSCHRITT',
                      style: AppTextStyles.monoSmall(textDim),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: score / 100,
                          backgroundColor: border,
                          valueColor: AlwaysStoppedAnimation(scoreColor),
                          minHeight: 2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'ZIEL ${requiredScore}%',
                      style: AppTextStyles.monoSmall(textDim),
                    ),
                  ],
                ),
              ],

              // Locked Info
              if (!unlocked) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.warning.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.warning,
                        size: 14,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _getUnlockMessage(thema),
                          style: AppTextStyles.bodySmall(AppColors.warning),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Info-Button für Summary
              if (unlocked && hasBeschreibung) ...[
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _showSummary(thema),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.menu_book_outlined, color: textMid, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        'Zusammenfassung lesen',
                        style: AppTextStyles.mono(
                          size: 11,
                          color: textMid,
                          weight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: textMid,
                        size: 12,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required String? difficulty,
    required int fragenAnzahl,
    required int estimatedMin,
    required bool unlocked,
    required Color textMid,
    required Color textDim,
  }) {
    final parts = <Widget>[];

    // Difficulty
    if (difficulty != null && difficulty.isNotEmpty && unlocked) {
      parts.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getDifficultyColor(difficulty),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              difficulty.toUpperCase(),
              style: AppTextStyles.mono(
                size: 10,
                color: _getDifficultyColor(difficulty),
                weight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      );
    }

    parts.add(
      Text('$fragenAnzahl FRAGEN', style: AppTextStyles.monoSmall(textDim)),
    );

    if (unlocked) {
      parts.add(
        Text('~$estimatedMin MIN', style: AppTextStyles.monoSmall(textDim)),
      );
    }

    return Wrap(spacing: 12, runSpacing: 4, children: parts);
  }

  Widget _statusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: AppTextStyles.mono(
          size: 10,
          color: color,
          weight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _scoreDisplay(double score, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${score.toInt()}%',
          style: AppTextStyles.interTight(
            size: 15,
            weight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  // ─── EMPTY ───────────────────────────────────
  Widget _buildEmpty(Color textMid, Color textDim) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: textDim),
          const SizedBox(height: 16),
          Text('Keine Themen verfügbar', style: AppTextStyles.h3(textMid)),
        ],
      ),
    );
  }
}
