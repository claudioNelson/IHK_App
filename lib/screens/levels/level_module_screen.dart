// lib/screens/levels/level_module_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';
import 'level_pfad_screen.dart';

class LevelModuleScreen extends StatefulWidget {
  const LevelModuleScreen({super.key});

  @override
  State<LevelModuleScreen> createState() => _LevelModuleScreenState();
}

class _LevelModuleScreenState extends State<LevelModuleScreen> {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _module = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadModule();
  }

  Future<void> _loadModule() async {
    setState(() => _loading = true);
    try {
      // 1. Distinct modul_ids aus levels-Tabelle
      final levelRes = await _supabase.from('levels').select('modul_id, tier');

      final modulCounts = <int, Map<String, int>>{};
      for (final row in levelRes as List) {
        final mid = row['modul_id'] as int;
        final tier = row['tier'] as String? ?? 'basics';
        modulCounts.putIfAbsent(mid, () => {'total': 0, 'basics': 0});
        modulCounts[mid]!['total'] = modulCounts[mid]!['total']! + 1;
        if (tier == 'basics') {
          modulCounts[mid]!['basics'] = modulCounts[mid]!['basics']! + 1;
        }
      }

      if (modulCounts.isEmpty) {
        if (!mounted) return;
        setState(() {
          _module = [];
          _loading = false;
        });
        return;
      }

      // 2. Modul-Namen laden
      final ids = modulCounts.keys.toList();
      final modulRes = await _supabase
          .from('module')
          .select('id, name')
          .filter('id', 'in', '(${ids.join(',')})');

      // 3. User-Progress laden (für Completed-Counter)
      final userId = _supabase.auth.currentUser?.id;
      Map<int, int> completedPerModul = {};
      if (userId != null) {
        // level_ids holen
        final allLevels = await _supabase
            .from('levels')
            .select('id, modul_id, schwelle')
            .filter('modul_id', 'in', '(${ids.join(',')})');

        final levelToModul = <int, int>{};
        final levelToSchwelle = <int, int>{};
        for (final l in allLevels as List) {
          levelToModul[l['id'] as int] = l['modul_id'] as int;
          levelToSchwelle[l['id'] as int] = l['schwelle'] as int;
        }

        if (levelToModul.isNotEmpty) {
          final progressRes = await _supabase
              .from('level_progress')
              .select('level_id, best_score')
              .eq('user_id', userId)
              .filter('level_id', 'in', '(${levelToModul.keys.join(',')})');

          for (final p in progressRes as List) {
            final lid = p['level_id'] as int;
            final score = p['best_score'] as int;
            final schwelle = levelToSchwelle[lid] ?? 100;
            if (score >= schwelle) {
              final mid = levelToModul[lid]!;
              completedPerModul[mid] = (completedPerModul[mid] ?? 0) + 1;
            }
          }
        }
      }

      // 4. Mergen
      final list = <Map<String, dynamic>>[];
      for (final m in modulRes as List) {
        final id = m['id'] as int;
        final counts = modulCounts[id]!;
        list.add({
          'id': id,
          'name': m['name'] as String,
          'total_levels': counts['total']!,
          'basics_levels': counts['basics']!,
          'completed': completedPerModul[id] ?? 0,
        });
      }
      list.sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));

      if (!mounted) return;
      setState(() {
        _module = list;
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

  Future<void> _openModul(Map<String, dynamic> m) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LevelPfadScreen(modulId: m['id'], modulName: m['name']),
      ),
    );
    _loadModule();
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
                  Text(
                    'Levels',
                    style: AppTextStyles.instrumentSerif(
                      size: 24,
                      color: text,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── CONTENT ─────────────────────────────
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.accent),
                  )
                : _module.isEmpty
                ? _buildEmpty(textMid, textDim)
                : RefreshIndicator(
                    color: AppColors.accent,
                    onRefresh: _loadModule,
                    child: _buildList(surface, border, text, textMid, textDim),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(Color textMid, Color textDim) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome_rounded, size: 48, color: textDim),
            const SizedBox(height: 16),
            Text(
              'Noch keine Level-Module verfügbar',
              style: AppTextStyles.h3(textMid),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Bald gibt\'s hier strukturierte Lernpfade Schritt für Schritt.',
              style: AppTextStyles.bodyMedium(textDim),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
        // Intro
        Row(
          children: [
            Container(width: 16, height: 1, color: AppColors.accent),
            const SizedBox(width: 10),
            Text(
              'LEVEL-PFADE',
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
          'Konzept-für-Konzept aufbauend lernen — wie bei Mimo oder Duolingo.',
          style: AppTextStyles.bodyMedium(textMid),
        ),
        const SizedBox(height: 28),

        // Section-Header
        Row(
          children: [
            Container(width: 16, height: 1, color: AppColors.accent),
            const SizedBox(width: 10),
            Text(
              'MODULE · ${_module.length}',
              style: AppTextStyles.monoLabel(AppColors.accent),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Modul-Cards
        ..._module.map(
          (m) => _buildModulCard(m, surface, border, text, textMid, textDim),
        ),
      ],
    );
  }

  Widget _buildModulCard(
    Map<String, dynamic> m,
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    final total = m['total_levels'] as int;
    final completed = m['completed'] as int;
    final percent = total > 0 ? (completed / total) : 0.0;
    final isCompleted = completed == total && total > 0;
    final accentColor = isCompleted ? AppColors.success : AppColors.accent;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => _openModul(m),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isCompleted ? AppColors.success.withOpacity(0.4) : border,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon-Badge
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: accentColor.withOpacity(0.3)),
                    ),
                    child: Icon(
                      Icons.auto_stories_rounded,
                      color: accentColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Name + Level-Counter
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                m['name'] ?? '',
                                style: AppTextStyles.labelLarge(text),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isCompleted)
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Icon(
                                  Icons.check_circle_rounded,
                                  color: AppColors.success,
                                  size: 16,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$total Level${total == 1 ? '' : 's'} · '
                          '${m['basics_levels']} kostenlos',
                          style: AppTextStyles.bodySmall(textMid),
                        ),
                      ],
                    ),
                  ),

                  // Arrow
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

              const SizedBox(height: 12),

              // Progress
              Row(
                children: [
                  Text(
                    '$completed / $total',
                    style: AppTextStyles.monoSmall(textDim),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: percent,
                        backgroundColor: border,
                        valueColor: AlwaysStoppedAnimation(accentColor),
                        minHeight: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
