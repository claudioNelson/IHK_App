// lib/screens/levels/level_pfad_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/level_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';
import 'level_play_screen.dart';

class LevelPfadScreen extends StatefulWidget {
  final int modulId;
  final String modulName;

  const LevelPfadScreen({
    super.key,
    required this.modulId,
    required this.modulName,
  });

  @override
  State<LevelPfadScreen> createState() => _LevelPfadScreenState();
}

class _LevelPfadScreenState extends State<LevelPfadScreen> {
  final _service = LevelService();
  List<Level> _levels = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadLevels();
  }

  Future<void> _loadLevels() async {
    setState(() => _loading = true);
    try {
      final levels = await _service.getLevelsForModul(widget.modulId);
      if (!mounted) return;
      setState(() {
        _levels = levels;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Laden: $e'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _openLevel(Level level) async {
    final unlocked = LevelService.isUnlocked(level, _levels);
    if (!unlocked) {
      _snack('Erst das vorherige Level abschließen.');
      return;
    }
    if (level.isPremium) {
      // TODO: Premium-Check sobald Subscription-System steht
      // Für jetzt: Premium-Levels für alle freigeschaltet (Prototyp)
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            LevelPlayScreen(level: level, modulName: widget.modulName),
      ),
    );
    // Nach Rückkehr: Progress neu laden
    _loadLevels();
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.warning,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Stats für Banner
  int get _completedCount => _levels.where((l) => l.isCompleted).length;
  int get _totalSterne => _levels.fold(0, (sum, l) => sum + l.sterne);
  int get _maxSterne => _levels.length * 3;

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
                        size: 24,
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

          // ─── CONTENT ──────────────────────────────
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.accent),
                  )
                : _levels.isEmpty
                ? _buildEmpty(textMid, textDim)
                : RefreshIndicator(
                    color: AppColors.accent,
                    onRefresh: _loadLevels,
                    child: _buildList(surface, border, text, textMid, textDim),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(Color textMid, Color textDim) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_stories_outlined, size: 48, color: textDim),
          const SizedBox(height: 16),
          Text(
            'Noch keine Levels für dieses Modul',
            style: AppTextStyles.h3(textMid),
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
    // Levels nach Tier gruppieren
    final basics = _levels.where((l) => l.tier == LevelTier.basics).toList();
    final praxis = _levels.where((l) => l.tier == LevelTier.praxis).toList();
    final pruefung = _levels
        .where((l) => l.tier == LevelTier.pruefung)
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      children: [
        // Intro
        _buildIntro(text, textMid),
        const SizedBox(height: 24),

        // Banner
        _buildStatusBanner(surface, border, text, textMid, textDim),
        const SizedBox(height: 28),

        // Basics
        if (basics.isNotEmpty) ...[
          _buildSectionHeader('BASICS · ${basics.length}', AppColors.accent),
          const SizedBox(height: 12),
          ...basics.map(
            (l) => _buildLevelCard(l, surface, border, text, textMid, textDim),
          ),
          const SizedBox(height: 24),
        ],

        // Praxis (Premium)
        if (praxis.isNotEmpty) ...[
          _buildSectionHeader(
            'PRAXIS · ${praxis.length} · PREMIUM',
            AppColors.warning,
          ),
          const SizedBox(height: 12),
          ...praxis.map(
            (l) => _buildLevelCard(l, surface, border, text, textMid, textDim),
          ),
          const SizedBox(height: 24),
        ],

        // Pruefung (Premium)
        if (pruefung.isNotEmpty) ...[
          _buildSectionHeader(
            'PRÜFUNG · ${pruefung.length} · PREMIUM',
            AppColors.error,
          ),
          const SizedBox(height: 12),
          ...pruefung.map(
            (l) => _buildLevelCard(l, surface, border, text, textMid, textDim),
          ),
        ],
      ],
    );
  }

  Widget _buildIntro(Color text, Color textMid) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 16, height: 1, color: AppColors.accent),
            const SizedBox(width: 10),
            Text(
              'LEVEL-PFAD',
              style: AppTextStyles.monoLabel(AppColors.accent),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Schritt für Schritt.',
          style: AppTextStyles.instrumentSerif(
            size: 34,
            color: text,
            letterSpacing: -1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Schließe Level ab, um das nächste freizuschalten.',
          style: AppTextStyles.bodyMedium(textMid),
        ),
      ],
    );
  }

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
                'FORTSCHRITT',
                style: AppTextStyles.monoLabel(AppColors.accent),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$_completedCount',
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
                  '/ ${_levels.length} Levels',
                  style: AppTextStyles.bodyMedium(textMid),
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: AppColors.warning,
                        size: 22,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$_totalSterne / $_maxSterne',
                        style: AppTextStyles.instrumentSerif(
                          size: 24,
                          color: text,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  Text('STERNE', style: AppTextStyles.monoSmall(textDim)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String label, Color color) {
    return Row(
      children: [
        Container(width: 16, height: 1, color: color),
        const SizedBox(width: 10),
        Text(label, style: AppTextStyles.monoLabel(color)),
      ],
    );
  }

  Widget _buildLevelCard(
    Level level,
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    final unlocked = LevelService.isUnlocked(level, _levels);
    final completed = level.isCompleted;
    final started = level.isStarted;

    final accentColor = completed
        ? AppColors.success
        : (unlocked ? AppColors.accent : textDim);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Opacity(
        opacity: unlocked ? 1.0 : 0.55,
        child: GestureDetector(
          onTap: () => _openLevel(level),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: completed ? AppColors.success.withOpacity(0.4) : border,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Level-Nummer Badge
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: accentColor.withOpacity(0.3)),
                  ),
                  child: Center(
                    child: unlocked
                        ? Text(
                            level.nummer.toString().padLeft(2, '0'),
                            style: AppTextStyles.mono(
                              size: 16,
                              color: accentColor,
                              weight: FontWeight.w700,
                              letterSpacing: 0,
                            ),
                          )
                        : Icon(Icons.lock_rounded, color: textDim, size: 20),
                  ),
                ),
                const SizedBox(width: 14),

                // Titel + Beschreibung + Sterne
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              level.titel,
                              style: AppTextStyles.labelLarge(text),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (level.isPremium && !unlocked) ...[
                            const SizedBox(width: 6),
                            Icon(
                              Icons.workspace_premium_rounded,
                              color: AppColors.warning,
                              size: 14,
                            ),
                          ],
                          if (completed) ...[
                            const SizedBox(width: 6),
                            Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.success,
                              size: 16,
                            ),
                          ],
                        ],
                      ),
                      if (level.beschreibung != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          level.beschreibung!,
                          style: AppTextStyles.bodySmall(textMid),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 10),

                      // Sterne + Schwelle/Score-Info
                      Row(
                        children: [
                          // Sterne-Reihe (immer 3 Slots)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(3, (i) {
                              final filled = i < level.sterne;
                              return Padding(
                                padding: const EdgeInsets.only(right: 2),
                                child: Icon(
                                  filled
                                      ? Icons.star_rounded
                                      : Icons.star_outline_rounded,
                                  color: filled ? AppColors.warning : textDim,
                                  size: 16,
                                ),
                              );
                            }),
                          ),
                          const SizedBox(width: 10),
                          // Schwelle-Info
                          Text(
                            started
                                ? '${level.bestScore}% / ${level.schwelle}%'
                                : 'Schwelle ${level.schwelle}%',
                            style: AppTextStyles.monoSmall(textDim),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arrow
                if (unlocked)
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 4),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: textDim,
                      size: 12,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
