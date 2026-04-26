// lib/screens/module/modul_liste_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../module/themen_liste_screen.dart';
import '../../services/app_cache_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';

class ModulListe extends StatefulWidget {
  const ModulListe({super.key});

  @override
  State<ModulListe> createState() => _ModulListeState();
}

class _ModulListeState extends State<ModulListe> {
  final supabase = Supabase.instance.client;

  List<dynamic> module = [];
  Map<int, int> anzahlFragen = {};
  Map<int, int> beantworteteFragen = {};
  Map<int, int> letzteThemaId = {};
  bool loading = true;
  bool _showAsList = true;

  @override
  void initState() {
    super.initState();
    _loadViewPreference();
    final cacheService = AppCacheService();
    if (cacheService.modulesLoaded && cacheService.cachedModule.isNotEmpty) {
      module = cacheService.cachedModule;
      anzahlFragen = Map.from(cacheService.cachedAnzahlFragen);
      beantworteteFragen = Map.from(cacheService.cachedBeantworteteFragen);
      letzteThemaId = Map.from(cacheService.cachedLetzteThemaId);
      loading = false;
    } else {
      ladeModule();
    }
  }

  Future<void> _loadViewPreference() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _showAsList = prefs.getBool('module_view_as_list') ?? true;
    });
  }

  Future<void> _toggleView() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _showAsList = !_showAsList);
    await prefs.setBool('module_view_as_list', _showAsList);
  }

  Future<void> ladeModule() async {
    try {
      final response = await supabase
          .from('module')
          .select()
          .neq('kategorie', 'kernthema')
          .order('id');
      for (var modul in response) {
        final fragen = await supabase
            .from('fragen')
            .select('id')
            .eq('modul_id', modul['id']);
        anzahlFragen[modul['id']] = fragen.length;
        beantworteteFragen[modul['id']] = await _ladeModulFortschritt(
          modul['id'],
        );
        letzteThemaId[modul['id']] = await _ladeLetzteThemaId(modul['id']);
      }
      if (!mounted) return;
      setState(() {
        module = response;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler: $e'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() => loading = false);
    }
  }

  Future<int> _ladeModulFortschritt(int modulId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList('fortschritt_modul_$modulId')?.length ?? 0;
    } catch (_) {
      return 0;
    }
  }

  Future<int> _ladeLetzteThemaId(int modulId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('letztes_thema_modul_$modulId') ?? 0;
    } catch (_) {
      return 0;
    }
  }

  void _openModul(Map<String, dynamic> modul) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ThemenListe(
          modulId: modul['id'],
          modulName: modul['name'],
          onThemaSelected: (themaId) async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setInt('letztes_thema_modul_${modul['id']}', themaId);
          },
        ),
      ),
    ).then((_) => ladeModule());
  }

  int get _totalFragen {
    return anzahlFragen.values.fold(0, (a, b) => a + b);
  }

  int get _totalAnswered {
    return beantworteteFragen.values.fold(0, (a, b) => a + b);
  }

  int get _completedModules {
    return module.where((m) {
      final id = m['id'] as int;
      final total = anzahlFragen[id] ?? 0;
      final answered = beantworteteFragen[id] ?? 0;
      return total > 0 && answered >= total;
    }).length;
  }

  /// Gruppiert Module nach `kategorie` aus DB
  Map<String, List<Map<String, dynamic>>> _groupedModules() {
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final m in module) {
      final kat = (m['kategorie'] as String?)?.toUpperCase() ?? 'ALLGEMEIN';
      grouped.putIfAbsent(kat, () => []).add(m as Map<String, dynamic>);
    }
    return grouped;
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
          // ─── APPBAR ─────────────────────────────
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
                    'Lernmodule',
                    style: AppTextStyles.instrumentSerif(
                      size: 24,
                      color: text,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _toggleView,
                    icon: Icon(
                      _showAsList
                          ? Icons.grid_view_rounded
                          : Icons.view_list_rounded,
                      color: textMid,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── CONTENT ────────────────────────────
          Expanded(
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.accent),
                  )
                : module.isEmpty
                ? _buildEmpty(textMid, textDim)
                : RefreshIndicator(
                    color: AppColors.accent,
                    onRefresh: ladeModule,
                    child: _buildBody(surface, border, text, textMid, textDim),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    final grouped = _groupedModules();
    final categories = grouped.keys.toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      children: [
        // Stats-Banner
        _buildStatsBanner(surface, border, text, textMid, textDim),

        const SizedBox(height: 32),

        // Module je Kategorie
        for (int catIdx = 0; catIdx < categories.length; catIdx++) ...[
          _buildCategoryHeader(
            categories[catIdx],
            grouped[categories[catIdx]]!.length,
            textDim,
          ),
          const SizedBox(height: 12),
          if (_showAsList)
            ...grouped[categories[catIdx]]!.asMap().entries.map(
              (e) => _buildListItem(
                modul: e.value,
                surface: surface,
                border: border,
                text: text,
                textMid: textMid,
                textDim: textDim,
              ),
            )
          else
            _buildGrid(
              grouped[categories[catIdx]]!,
              surface,
              border,
              text,
              textMid,
              textDim,
            ),
          if (catIdx < categories.length - 1) const SizedBox(height: 28),
        ],
      ],
    );
  }

  // ─── STATS BANNER ────────────────────────────
  Widget _buildStatsBanner(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    final overallProgress = _totalFragen > 0
        ? (_totalAnswered / _totalFragen * 100).round()
        : 0;

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
                '$_totalAnswered',
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
                  '/ $_totalFragen',
                  style: AppTextStyles.bodyMedium(textMid),
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$overallProgress%',
                    style: AppTextStyles.instrumentSerif(
                      size: 28,
                      color: AppColors.accent,
                      letterSpacing: -1,
                    ),
                  ),
                  Text('GESAMT', style: AppTextStyles.monoSmall(textDim)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: _totalFragen > 0 ? _totalAnswered / _totalFragen : 0,
              backgroundColor: border,
              valueColor: const AlwaysStoppedAnimation(AppColors.accent),
              minHeight: 3,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _statMini(
                '$_completedModules / ${module.length}',
                'MODULE FERTIG',
                text,
                textDim,
              ),
              const SizedBox(width: 24),
              _statMini(
                '${anzahlFragen.length}',
                'MODULE GESAMT',
                text,
                textDim,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statMini(String value, String label, Color text, Color textDim) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTextStyles.interTight(
            size: 13,
            weight: FontWeight.w600,
            color: text,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.monoSmall(textDim)),
      ],
    );
  }

  // ─── CATEGORY HEADER ─────────────────────────
  Widget _buildCategoryHeader(String category, int count, Color textDim) {
    return Row(
      children: [
        Container(width: 16, height: 1, color: AppColors.accent),
        const SizedBox(width: 10),
        Text(
          '$category · $count',
          style: AppTextStyles.monoLabel(AppColors.accent),
        ),
      ],
    );
  }

  // ─── LIST ITEM ───────────────────────────────
  Widget _buildListItem({
    required Map<String, dynamic> modul,
    required Color surface,
    required Color border,
    required Color text,
    required Color textMid,
    required Color textDim,
  }) {
    final modulId = modul['id'] as int;
    final total = anzahlFragen[modulId] ?? 0;
    final answered = beantworteteFragen[modulId] ?? 0;
    final progress = total > 0 ? answered / total : 0.0;
    final isComplete = total > 0 && answered >= total;
    final isStarted = answered > 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => _openModul(modul),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isComplete ? AppColors.success.withOpacity(0.4) : border,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Modul-ID Badge
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: isComplete
                          ? AppColors.success.withOpacity(0.12)
                          : AppColors.accent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isComplete
                            ? AppColors.success.withOpacity(0.3)
                            : AppColors.accent.withOpacity(0.3),
                      ),
                    ),
                    child: Center(
                      child: isComplete
                          ? Icon(
                              Icons.check_rounded,
                              color: AppColors.success,
                              size: 20,
                            )
                          : Text(
                              _formatModulNumber(modulId),
                              style: AppTextStyles.mono(
                                size: 12,
                                color: AppColors.accent,
                                weight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          modul['name'] ?? '',
                          style: AppTextStyles.labelLarge(text),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (isStarted) ...[
                          const SizedBox(height: 4),
                          Text(
                            '$answered / $total Fragen',
                            style: AppTextStyles.monoSmall(textDim),
                          ),
                        ] else ...[
                          const SizedBox(height: 4),
                          Text(
                            '$total Fragen',
                            style: AppTextStyles.monoSmall(textDim),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Progress oder Badge
                  if (isComplete)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'FERTIG',
                        style: AppTextStyles.mono(
                          size: 9,
                          color: AppColors.success,
                          weight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    )
                  else if (isStarted)
                    Text(
                      '${(progress * 100).round()}%',
                      style: AppTextStyles.interTight(
                        size: 14,
                        weight: FontWeight.w700,
                        color: AppColors.accent,
                      ),
                    )
                  else
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: textDim,
                      size: 12,
                    ),
                ],
              ),
              // Progress Bar (nur wenn gestartet und nicht fertig)
              if (isStarted && !isComplete) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: border,
                    valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                    minHeight: 2,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ─── GRID ────────────────────────────────────
  Widget _buildGrid(
    List<Map<String, dynamic>> modulList,
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.95,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: modulList.length,
      itemBuilder: (ctx, i) {
        return _buildGridItem(
          modul: modulList[i],
          surface: surface,
          border: border,
          text: text,
          textMid: textMid,
          textDim: textDim,
        );
      },
    );
  }

  Widget _buildGridItem({
    required Map<String, dynamic> modul,
    required Color surface,
    required Color border,
    required Color text,
    required Color textMid,
    required Color textDim,
  }) {
    final modulId = modul['id'] as int;
    final total = anzahlFragen[modulId] ?? 0;
    final answered = beantworteteFragen[modulId] ?? 0;
    final progress = total > 0 ? answered / total : 0.0;
    final isComplete = total > 0 && answered >= total;
    final isStarted = answered > 0;

    return GestureDetector(
      onTap: () => _openModul(modul),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isComplete ? AppColors.success.withOpacity(0.4) : border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isComplete
                        ? AppColors.success.withOpacity(0.12)
                        : AppColors.accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isComplete
                          ? AppColors.success.withOpacity(0.3)
                          : AppColors.accent.withOpacity(0.3),
                    ),
                  ),
                  child: Center(
                    child: isComplete
                        ? Icon(
                            Icons.check_rounded,
                            color: AppColors.success,
                            size: 16,
                          )
                        : Text(
                            _formatModulNumber(modulId),
                            style: AppTextStyles.mono(
                              size: 10,
                              color: AppColors.accent,
                              weight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                ),
                if (isComplete)
                  Icon(Icons.star_rounded, color: AppColors.success, size: 16)
                else if (isStarted)
                  Text(
                    '${(progress * 100).round()}%',
                    style: AppTextStyles.mono(
                      size: 11,
                      color: AppColors.accent,
                      weight: FontWeight.w700,
                      letterSpacing: 0,
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              modul['name'] ?? '',
              style: AppTextStyles.labelMedium(text),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text('$answered / $total', style: AppTextStyles.monoSmall(textDim)),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: border,
                valueColor: AlwaysStoppedAnimation(
                  isComplete ? AppColors.success : AppColors.accent,
                ),
                minHeight: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Formatiert Modul-IDs zu schönen 2-stelligen Labels
  // 9001-9011 → 01-11, andere bleiben wie sie sind
  String _formatModulNumber(int id) {
    if (id >= 9001 && id <= 9099) {
      return (id - 9000).toString().padLeft(2, '0');
    }
    if (id < 100) return id.toString().padLeft(2, '0');
    return id.toString();
  }

  // ─── EMPTY ───────────────────────────────────
  Widget _buildEmpty(Color textMid, Color textDim) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.library_books_outlined, size: 48, color: textDim),
          const SizedBox(height: 16),
          Text('Keine Module gefunden', style: AppTextStyles.h3(textMid)),
          const SizedBox(height: 4),
          Text(
            'Zieh runter um zu aktualisieren',
            style: AppTextStyles.bodySmall(textDim),
          ),
        ],
      ),
    );
  }
}
