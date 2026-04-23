// lib/screens/learning/review_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/spaced_repetition_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';
import 'review_questions_screen.dart';

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
    } catch (_) {
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
    final isDark = context.read<ThemeProvider>().isDark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    Container(width: 16, height: 1, color: AppColors.accent),
                    const SizedBox(width: 10),
                    Text(
                      'SPACED REPETITION',
                      style: AppTextStyles.monoLabel(AppColors.accent),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Der schnellste Weg\nzum Behalten.',
                  style: AppTextStyles.instrumentSerif(
                    size: 28,
                    color: text,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Wissenschaftlich bewiesene Lernmethode, '
                  'basierend auf 100+ Jahren Gedächtnisforschung.',
                  style: AppTextStyles.bodyMedium(textMid),
                ),

                const SizedBox(height: 24),

                _infoItem(
                  number: '01',
                  title: 'Das Problem',
                  description:
                      'Ohne Wiederholung vergessen wir 80% des Gelernten innerhalb von 24 Stunden.',
                  text: text,
                  textMid: textMid,
                  border: border,
                ),
                const SizedBox(height: 16),
                _infoItem(
                  number: '02',
                  title: 'Die Lösung',
                  description:
                      'Wiederholung in optimalen Abständen: 1 Tag → 3 Tage → 1 Woche → 2 Wochen...',
                  text: text,
                  textMid: textMid,
                  border: border,
                ),
                const SizedBox(height: 16),
                _infoItem(
                  number: '03',
                  title: 'Automatisch',
                  description:
                      'Die App merkt sich welche Fragen du falsch hattest und plant die Wiederholung.',
                  text: text,
                  textMid: textMid,
                  border: border,
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: textMid,
                          side: BorderSide(color: border),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Verstanden'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _startReview();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: text,
                          foregroundColor: bg,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                          textStyle: AppTextStyles.labelLarge(bg),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Los geht\'s'),
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

  Widget _infoItem({
    required String number,
    required String title,
    required String description,
    required Color text,
    required Color textMid,
    required Color border,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 32,
          child: Text(
            number,
            style: AppTextStyles.mono(
              size: 11,
              color: AppColors.accent,
              weight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.labelLarge(text)),
              const SizedBox(height: 4),
              Text(description, style: AppTextStyles.bodySmall(textMid)),
            ],
          ),
        ),
      ],
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

    // Gruppiere Fragen nach Modul
    final byModule = <String, List<Map<String, dynamic>>>{};
    for (final q in _dueQuestions) {
      final frage = q['fragen'] as Map<String, dynamic>?;
      if (frage == null) continue;
      final modul = frage['module'] as Map<String, dynamic>?;
      final modulName =
          modul?['name'] ??
          (frage['modul_id'] == null
              ? 'Kernthemen'
              : 'Modul ${frage['modul_id']}');
      byModule.putIfAbsent(modulName, () => []).add(q);
    }

    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: [
          // ─── APPBAR ──────────────────────────
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
                  Text(
                    'Wiederholen',
                    style: AppTextStyles.instrumentSerif(
                      size: 24,
                      color: text,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _showInfoDialog,
                    icon: Icon(
                      Icons.info_outline_rounded,
                      color: textMid,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── CONTENT ─────────────────────────
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.accent),
                  )
                : _dueQuestions.isEmpty
                ? _buildEmptyState(text, textMid, textDim)
                : RefreshIndicator(
                    color: AppColors.accent,
                    onRefresh: _loadDueQuestions,
                    child: _buildList(
                      byModule,
                      surface,
                      border,
                      text,
                      textMid,
                      textDim,
                    ),
                  ),
          ),

          // ─── START BUTTON ─────────────────────
          if (!_loading && _dueQuestions.isNotEmpty)
            _buildStartBar(bg, surface, border, text, textMid),
        ],
      ),
    );
  }

  // ─── EMPTY STATE ─────────────────────────
  Widget _buildEmptyState(Color text, Color textMid, Color textDim) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Success-Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.12),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'ALLES ERLEDIGT',
                style: AppTextStyles.mono(
                  size: 11,
                  color: AppColors.success,
                  weight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Nichts zu wiederholen.',
              style: AppTextStyles.instrumentSerif(
                size: 32,
                color: text,
                letterSpacing: -1.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Deine Wiederholungen sind auf dem neuesten Stand. '
              'Schau später wieder vorbei.',
              style: AppTextStyles.bodyMedium(textMid),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ─── LIST ────────────────────────────────
  Widget _buildList(
    Map<String, List<Map<String, dynamic>>> byModule,
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
        // Intro
        Row(
          children: [
            Container(width: 16, height: 1, color: AppColors.accent),
            const SizedBox(width: 10),
            Text(
              'FÄLLIG HEUTE',
              style: AppTextStyles.monoLabel(AppColors.accent),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Zeit für Wiederholung.',
          style: AppTextStyles.instrumentSerif(
            size: 32,
            color: text,
            letterSpacing: -1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Was du heute nicht wiederholst, vergisst du morgen.',
          style: AppTextStyles.bodyMedium(textMid),
        ),

        const SizedBox(height: 28),

        // Stats-Banner
        _buildStatsBanner(
          byModule.length,
          surface,
          border,
          text,
          textMid,
          textDim,
        ),

        const SizedBox(height: 28),

        // Section Header
        Row(
          children: [
            Container(width: 16, height: 1, color: AppColors.accent),
            const SizedBox(width: 10),
            Text(
              'VERTEILUNG · ${byModule.length} MODULE',
              style: AppTextStyles.monoLabel(AppColors.accent),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Module-Liste
        ...byModule.entries.map((entry) {
          return _buildModuleRow(
            name: entry.key,
            count: entry.value.length,
            totalCount: _dueQuestions.length,
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

  // ─── STATS BANNER ────────────────────────
  Widget _buildStatsBanner(
    int modulCount,
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
        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.015, 0.015, 1.0],
          colors: [AppColors.warning, AppColors.warning, surface, surface],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Pulsating Dot
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.warning,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.warning.withOpacity(0.6),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'WARTEN AUF DICH',
                style: AppTextStyles.monoLabel(AppColors.warning),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${_dueQuestions.length}',
                style: AppTextStyles.instrumentSerif(
                  size: 52,
                  color: text,
                  letterSpacing: -2,
                ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  _dueQuestions.length == 1 ? 'Frage' : 'Fragen',
                  style: AppTextStyles.bodyMedium(textMid),
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$modulCount',
                    style: AppTextStyles.instrumentSerif(
                      size: 28,
                      color: AppColors.warning,
                      letterSpacing: -1,
                    ),
                  ),
                  Text(
                    modulCount == 1 ? 'MODUL' : 'MODULE',
                    style: AppTextStyles.monoSmall(textDim),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Diese Fragen sind heute fällig — basierend auf dem Spaced-Repetition-Algorithmus.',
            style: AppTextStyles.bodySmall(textMid),
          ),
        ],
      ),
    );
  }

  // ─── MODULE ROW ──────────────────────────
  Widget _buildModuleRow({
    required String name,
    required int count,
    required int totalCount,
    required Color surface,
    required Color border,
    required Color text,
    required Color textMid,
    required Color textDim,
  }) {
    final percent = totalCount > 0 ? count / totalCount : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: AppTextStyles.labelLarge(text),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$count',
                  style: AppTextStyles.mono(
                    size: 14,
                    color: AppColors.warning,
                    weight: FontWeight.w700,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: percent,
                backgroundColor: border,
                valueColor: const AlwaysStoppedAnimation(AppColors.warning),
                minHeight: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── START BAR ───────────────────────────
  Widget _buildStartBar(
    Color bg,
    Color surface,
    Color border,
    Color text,
    Color textMid,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        border: Border(top: BorderSide(color: border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _startReview,
              icon: const Icon(Icons.play_arrow_rounded, size: 18),
              label: Text('Wiederholung starten · ${_dueQuestions.length}'),
              style: ElevatedButton.styleFrom(
                backgroundColor: text,
                foregroundColor: bg,
                elevation: 0,
                textStyle: AppTextStyles.labelLarge(bg),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
