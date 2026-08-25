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

  /// Zuletzt geöffnetes Modul für die "Weiterlernen"-Karte.
  int? _weiterModulId;

  @override
  void initState() {
    super.initState();
    _loadViewPreference();
    _loadWeiterlernen();
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

  Future<void> _loadWeiterlernen() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => _weiterModulId = prefs.getInt('weiterlernen_modul_id'));
  }

  Future<void> _merkeWeiterlernen(int modulId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('weiterlernen_modul_id', modulId);
    if (mounted) setState(() => _weiterModulId = modulId);
  }

  /// Icon und Akzentfarbe je Modul, erkannt am Namen. Gibt der Liste
  /// Gesichter statt sechzehn identischer Kacheln.
  ({IconData icon, Color farbe}) _modulStil(String name) {
    final n = name.toLowerCase();
    if (n.contains('netzwerk')) {
      return (icon: Icons.hub_outlined, farbe: AppColors.accentCyan);
    }
    if (n.contains('sicherheit') || n.contains('security')) {
      return (icon: Icons.shield_outlined, farbe: AppColors.error);
    }
    if (n.contains('datenbank') || n.contains('sql')) {
      return (icon: Icons.storage_rounded, farbe: AppColors.info);
    }
    if (n.contains('algorithm') || n.contains('datenstruktur')) {
      return (icon: Icons.account_tree_outlined, farbe: AppColors.warning);
    }
    if (n.contains('programmier')) {
      return (icon: Icons.code_rounded, farbe: AppColors.accent);
    }
    if (n.contains('linux') || n.contains('betriebssystem')) {
      return (icon: Icons.terminal_rounded, farbe: AppColors.success);
    }
    if (n.contains('hardware') || n.contains('it-grundlagen')) {
      return (icon: Icons.memory_rounded, farbe: AppColors.azureBlue);
    }
    if (n.contains('web')) {
      return (icon: Icons.public_rounded, farbe: AppColors.gcpBlue);
    }
    if (n.contains('cloud') || n.contains('devops')) {
      return (icon: Icons.cloud_outlined, farbe: AppColors.accentCyan);
    }
    if (n.contains('projekt')) {
      return (icon: Icons.assignment_outlined, farbe: AppColors.sapBlue);
    }
    if (n.contains('wiso') ||
        n.contains('wirtschaft') ||
        n.contains('recht')) {
      return (icon: Icons.gavel_rounded, farbe: AppColors.awsOrange);
    }
    if (n.contains('mathe') || n.contains('zahlensystem')) {
      return (icon: Icons.calculate_outlined, farbe: AppColors.warning);
    }
    return (icon: Icons.school_outlined, farbe: AppColors.accent);
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
    _merkeWeiterlernen(modul['id'] as int);
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

        // Weiterlernen: eine Karte fuer das zuletzt geoeffnete Modul,
        // damit der haeufigste Klick der bequemste ist.
        ..._buildWeiterKarte(surface, border, text, textMid, textDim),

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

  // ─── WEITERLERNEN-KARTE ──────────────────────
  List<Widget> _buildWeiterKarte(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    if (_weiterModulId == null) return const [];
    final treffer = module.where((m) => m['id'] == _weiterModulId).toList();
    if (treffer.isEmpty) return const [];

    final modul = treffer.first as Map<String, dynamic>;
    final stil = _modulStil(modul['name'] ?? '');
    final total = anzahlFragen[_weiterModulId!] ?? 0;
    final answered = beantworteteFragen[_weiterModulId!] ?? 0;

    return [
      const SizedBox(height: 12),
      GestureDetector(
        onTap: () => _openModul(modul),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: stil.farbe.withOpacity(0.10),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: stil.farbe.withOpacity(0.35)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: stil.farbe.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.play_arrow_rounded,
                    color: stil.farbe, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('WEITERLERNEN',
                        style: AppTextStyles.monoLabel(stil.farbe)),
                    const SizedBox(height: 4),
                    Text(
                      modul['name'] ?? '',
                      style: AppTextStyles.labelLarge(text),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (total > 0) ...[
                      const SizedBox(height: 2),
                      Text('$answered / $total Fragen',
                          style: AppTextStyles.monoSmall(textDim)),
                    ],
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_rounded, color: stil.farbe, size: 20),
            ],
          ),
        ),
      ),
    ];
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
    final stil = _modulStil(modul['name'] ?? '');

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
          child: Row(
            children: [
              // Themen-Icon in Modulfarbe
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: stil.farbe.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: stil.farbe.withOpacity(0.3)),
                ),
                child: Icon(stil.icon, color: stil.farbe, size: 20),
              ),
              const SizedBox(width: 14),
              // Name + Fragen
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
                    const SizedBox(height: 4),
                    Text(
                      answered > 0
                          ? '$answered / $total Fragen'
                          : '$total Fragen',
                      style: AppTextStyles.monoSmall(textDim),
                    ),
                  ],
                ),
              ),
              // Fortschrittsring
              _FortschrittsRing(
                wert: progress,
                farbe: isComplete ? AppColors.success : stil.farbe,
                hintergrund: border,
                fertig: isComplete,
                textFarbe: textMid,
              ),
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
    final stil = _modulStil(modul['name'] ?? '');

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
                    color: stil.farbe.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: stil.farbe.withOpacity(0.3)),
                  ),
                  child: Icon(stil.icon, color: stil.farbe, size: 17),
                ),
                _FortschrittsRing(
                  wert: progress,
                  farbe: isComplete ? AppColors.success : stil.farbe,
                  hintergrund: border,
                  fertig: isComplete,
                  textFarbe: textMid,
                  klein: true,
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
                  isComplete ? AppColors.success : stil.farbe,
                ),
                minHeight: 2,
              ),
            ),
          ],
        ),
      ),
    );
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

// ─── FORTSCHRITTSRING ──────────────────────────
/// Kleiner Kreisring mit Prozentzahl, bei fertigen Modulen ein Haken.
class _FortschrittsRing extends StatelessWidget {
  final double wert;
  final Color farbe;
  final Color hintergrund;
  final bool fertig;
  final Color textFarbe;
  final bool klein;

  const _FortschrittsRing({
    required this.wert,
    required this.farbe,
    required this.hintergrund,
    required this.fertig,
    required this.textFarbe,
    this.klein = false,
  });

  @override
  Widget build(BuildContext context) {
    final groesse = klein ? 34.0 : 42.0;
    return SizedBox(
      width: groesse,
      height: groesse,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: wert.clamp(0.0, 1.0),
            strokeWidth: klein ? 3 : 3.5,
            backgroundColor: hintergrund,
            valueColor: AlwaysStoppedAnimation(farbe),
            strokeCap: StrokeCap.round,
          ),
          Center(
            child: fertig
                ? Icon(Icons.check_rounded, color: farbe, size: klein ? 15 : 18)
                : Text(
                    '${(wert * 100).round()}',
                    style: AppTextStyles.mono(
                      size: klein ? 9 : 11,
                      color: wert > 0 ? farbe : textFarbe,
                      weight: FontWeight.w700,
                      letterSpacing: 0,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
