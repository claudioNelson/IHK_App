import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../screens/module/modul_liste_screen.dart';
import '../../services/app_cache_service.dart';
import '../../services/auth_service.dart';
import '../../services/spaced_repetition_service.dart';
import '../../services/flashcard_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';
import 'review_screen.dart';
//import 'core_topics_screen.dart';
import 'anschluesse_quiz_screen.dart';
import 'flashcard_screen.dart';
import '../zertifikate/certificate_overview_screen.dart';
import '../levels/level_module_screen.dart';
import '../kurse/kurs_uebersicht_screen.dart';
import '../../data/kurse/sql_kurs.dart';
import '../../data/kurse/python_kurs.dart';
import '../../widgets/header_wash.dart';
import '../../services/ziel_service.dart';
import '../../services/daily_goal_service.dart';
import '../onboarding/ziel_screen.dart';

class LearningHubScreen extends StatefulWidget {
  const LearningHubScreen({super.key});

  @override
  State<LearningHubScreen> createState() => _LearningHubScreenState();
}

class _LearningHubScreenState extends State<LearningHubScreen> {
  final _srsService = SpacedRepetitionService();
  final _flashcardService = FlashcardService();
  int _dueCount = 0;
  int _flashcardCount = 0;
  bool _loading = true;
  String? _username;
  PruefungsZiel? _ziel;

  @override
  void initState() {
    super.initState();
    _loadCounts();
    _loadUsername();
    _loadZiel();
  }

  /// Pruefungsziel fuer den Countdown (lokale Kopie sofort, DB danach).
  Future<void> _loadZiel() async {
    final ziel = await ZielService().laden();
    if (!mounted) return;
    setState(() => _ziel = ziel);
  }

  Future<void> _zielBearbeiten() async {
    final geaendert = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const ZielScreen()),
    );
    if (geaendert == true && mounted) {
      setState(() => _ziel = ZielService().ziel);
    }
  }

  Future<void> _loadUsername() async {
    // Erst aus dem Cache (sofort da), sonst frisch laden.
    final cached = AppCacheService().cachedMyProfile;
    var name = cached?['username'] as String?;
    if (name == null || name.trim().isEmpty) {
      final profile = await AuthService().getProfile();
      name = profile?['username'] as String?;
    }
    if (!mounted) return;
    if (name != null && name.trim().isNotEmpty) {
      setState(() => _username = name!.trim());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    final count = await _srsService.getDueCount();
    final fcCount = await _flashcardService.getCount();
    if (!mounted) return;
    setState(() {
      _dueCount = count;
      _flashcardCount = fcCount;
      _loading = false;
    });
    _loadTagesZeile();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    final name = _username;

    if (name == null) {
      if (hour < 11) return 'Guten Morgen.';
      if (hour < 17) return 'Hey.';
      if (hour < 22) return 'Guten Abend.';
      return 'Spät noch wach?';
    }

    if (hour < 11) return 'Guten Morgen, $name.';
    if (hour < 17) return 'Hey $name.';
    if (hour < 22) return 'Guten Abend, $name.';
    return 'Spät noch wach, $name?';
  }

  String _getDateLabel() {
    final now = DateTime.now();
    const months = [
      'JAN',
      'FEB',
      'MÄR',
      'APR',
      'MAI',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OKT',
      'NOV',
      'DEZ',
    ];
    const weekdays = ['MO', 'DI', 'MI', 'DO', 'FR', 'SA', 'SO'];
    final wd = weekdays[now.weekday - 1];
    final m = months[now.month - 1];
    return '$wd · ${now.day.toString().padLeft(2, '0')} $m ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;

    // Zahlen rechts auf den Karten kommen aus dem App-Cache, der beim Start
    // befuellt wird (preloadAllData). Vorher standen hier feste Werte, und
    // bei "Levels" war es eine "1" aus der Zeit mit nur einem Lernpfad.
    // Fallbacks nur fuer den Fall, dass der Cache noch leer ist.
    final cache = AppCacheService();
    final levelCount = cache.cachedLevelModule.isNotEmpty
        ? cache.cachedLevelModule.length
        : 11;
    final modulCount = cache.cachedModule.isNotEmpty
        ? cache.cachedModule.length
        : 17;

    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

    return Scaffold(
      backgroundColor: bg,
      body: RefreshIndicator(
        color: AppColors.accent,
        onRefresh: _loadCounts,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            // ─── HEADER ────────────────────────────────────
            SliverToBoxAdapter(
              child: HeaderWash(
                isDark: isDark,
                child: _buildHeader(text, textMid, textDim),
              ),
            ),

            // ─── CONTENT ───────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Due-Stripe (nur wenn fällig)
                  if (_dueCount > 0) ...[
                    _buildDueStripe(surface, border, text, textMid),
                    const SizedBox(height: 24),
                  ],

                  // SECTION: QUICK ACTIONS
                  _buildSectionLabel('QUICK ACTIONS', textDim),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionCard(
                          number: '01',
                          label: 'Wiederholen',
                          sub: _loading
                              ? '…'
                              : _dueCount > 0
                              ? '$_dueCount fällig'
                              : 'Alles erledigt',
                          accent: _dueCount > 0,
                          surface: surface,
                          border: border,
                          text: text,
                          textMid: textMid,
                          textDim: textDim,
                          onTap: _dueCount > 0
                              ? () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ReviewScreen(totalCount: _dueCount),
                                    ),
                                  );
                                  _loadCounts();
                                }
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionCard(
                          number: '02',
                          label: 'Flashcards',
                          sub: _loading
                              ? '…'
                              : _flashcardCount > 0
                              ? '$_flashcardCount Karten'
                              : 'Noch leer',
                          accent: _flashcardCount > 0,
                          surface: surface,
                          border: border,
                          text: text,
                          textMid: textMid,
                          textDim: textDim,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const FlashcardScreen(),
                              ),
                            );
                            _loadCounts();
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 36),

                  // SECTION: LERNBEREICHE
                  _buildSectionLabel('LERNBEREICHE', textDim),
                  const SizedBox(height: 14),

                  // Kernthemen ausgeblendet — Inhalte sind als Lernpfade (Levels) migriert.
                  // Fragen bleiben in der DB (werden in Matches genutzt). Bei Bedarf reaktivieren.
                  // _buildCategoryRow(
                  //   tag: 'KT',
                  //   tagColor: AppColors.accentCyan,
                  //   title: 'Kernthemen',
                  //   sub: 'Prüfungsrelevante Basics',
                  //   count: '8',
                  //   surface: surface,
                  //   border: border,
                  //   text: text,
                  //   textMid: textMid,
                  //   textDim: textDim,
                  //   onTap: () => Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (_) => const CoreTopicsScreen(),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 10),
                  _buildCategoryRow(
                    tag: 'LV',
                    tagColor: AppColors.accent,
                    title: 'Levels',
                    sub: 'Aufbauende Lernpfade',
                    count: '$levelCount',
                    surface: surface,
                    border: border,
                    text: text,
                    textMid: textMid,
                    textDim: textDim,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LevelModuleScreen(),
                        ),
                      );
                      _loadCounts();
                    },
                  ),
                  const SizedBox(height: 10),

                  _buildCategoryRow(
                    tag: 'MO',
                    tagColor: AppColors.accent,
                    title: 'Module',
                    sub: 'Freies Üben',
                    count: '$modulCount',
                    surface: surface,
                    border: border,
                    text: text,
                    textMid: textMid,
                    textDim: textDim,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ModulListe()),
                      );
                      _loadCounts();
                    },
                  ),
                  const SizedBox(height: 10),

                  _buildCategoryRow(
                    tag: 'SI',
                    tagColor: AppColors.accentCyan,
                    title: 'Anschlüsse',
                    sub: 'Hardware erkennen · Systemintegration',
                    count: '16',
                    surface: surface,
                    border: border,
                    text: text,
                    textMid: textMid,
                    textDim: textDim,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AnschluesseQuizScreen(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // SECTION: KURSE (interaktive Kurse mit echter Ausführung)
                  _buildSectionLabel('KURSE', textDim),
                  const SizedBox(height: 14),
                  _buildKursRow(
                    tag: 'SQL',
                    tagColor: AppColors.accentCyan,
                    title: sqlKurs.titel,
                    sub: 'Interaktiver Kurs mit echter Datenbank',
                    count: '${sqlKurs.lektionen.length}',
                    neu: true,
                    surface: surface,
                    border: border,
                    text: text,
                    textMid: textMid,
                    textDim: textDim,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const KursUebersichtScreen(kurs: sqlKurs),
                        ),
                      );
                      _loadCounts();
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildKursRow(
                    tag: 'PY',
                    tagColor: AppColors.warning,
                    title: pythonKurs.titel,
                    sub: 'Interaktiver Kurs, ganz ohne Vorwissen',
                    count: '${pythonKurs.lektionen.length}',
                    neu: true,
                    surface: surface,
                    border: border,
                    text: text,
                    textMid: textMid,
                    textDim: textDim,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const KursUebersichtScreen(kurs: pythonKurs),
                        ),
                      );
                      _loadCounts();
                    },
                  ),

                  const SizedBox(height: 36),

                  // SECTION: ZERTIFIKATE-HIGHLIGHT
                  _buildSectionLabel('CLOUD-ZERTIFIKATE', textDim),
                  const SizedBox(height: 14),
                  _buildCertStrip(
                    surface: surface,
                    border: border,
                    text: text,
                    textMid: textMid,
                    textDim: textDim,
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── HEADER ─────────────────────────────────────────
  Widget _buildHeader(Color text, Color textMid, Color textDim) {
    // SafeArea aussen wie bei Pruefen/Arena/Profil, sonst addiert sich das
    // Top-Padding auf den Statusbar-Inset und der Header sitzt tiefer.
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Label
            Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accent,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.6),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(_getDateLabel(), style: AppTextStyles.monoLabel(textDim)),
              ],
            ),
            const SizedBox(height: 16),

            // Greeting
            Text(
              _getGreeting(),
              style: AppTextStyles.instrumentSerif(
                size: 42,
                color: text,
                letterSpacing: -1.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Dein Lernhub — alles an einem Ort.',
              style: AppTextStyles.bodyMedium(textMid),
            ),
            const SizedBox(height: 20),
            _buildCountdown(text, textMid, textDim),
          ],
        ),
      ),
    );
  }

  // ─── COUNTDOWN (Pruefungsziel, Phase 1) ─────────────
  // Hero-Karte: Tage gross mit Glow, Pruefung + Termin daneben, darunter
  // der Tagesbezug (Fragen heute vs. Tagesziel, Streak). Ohne Ziel eine
  // Einladung; ohne Termin nur Pruefung + Fachrichtung.
  Widget _buildCountdown(Color text, Color textMid, Color textDim) {
    final isDark = context.read<ThemeProvider>().isDark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final ziel = _ziel;

    final karte = BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppColors.accent.withOpacity(0.35)),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.accent.withOpacity(isDark ? 0.16 : 0.10), surface],
      ),
      boxShadow: isDark
          ? [
              BoxShadow(
                color: AppColors.accent.withOpacity(0.18),
                blurRadius: 28,
                offset: const Offset(0, 8),
              ),
            ]
          : [
              const BoxShadow(
                color: AppColors.lightShadow,
                blurRadius: 18,
                offset: Offset(0, 6),
              ),
            ],
    );

    if (ziel == null) {
      return GestureDetector(
        onTap: _zielBearbeiten,
        child: Container(
          padding: const EdgeInsets.fromLTRB(18, 16, 16, 16),
          decoration: karte,
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.flag_rounded,
                    color: AppColors.accent, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Wann ist deine Prüfung?',
                        style: AppTextStyles.h3(text)),
                    const SizedBox(height: 2),
                    Text('Termin eintragen und den Countdown starten.',
                        style: AppTextStyles.bodySmall(textMid)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: textDim),
            ],
          ),
        ),
      );
    }

    final tage = ziel.tageBis;
    final vorbei = tage != null && tage < 0;
    final heute = tage == 0;
    final zahl = tage == null ? '?' : (vorbei ? '✓' : '$tage');
    final einheit = tage == null
        ? 'TERMIN OFFEN'
        : vorbei
            ? 'GESCHAFFT?'
            : heute
                ? 'HEUTE'
                : (tage == 1 ? 'TAG' : 'TAGE');
    final titel = ziel.pruefung == 'AP1'
        ? 'bis zur Abschlussprüfung Teil 1'
        : 'bis zur Abschlussprüfung Teil 2';
    final untertitel = ziel.datum == null
        ? '${ziel.fachrichtungLabel} · Termin noch eintragen'
        : '${ziel.fachrichtungLabel} · ${_wochentag(ziel.datum!)}, ${ZielScreen.datumText(ziel.datum!)}';

    return GestureDetector(
      onTap: _zielBearbeiten,
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 14, 16, 16),
        decoration: karte,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(width: 16, height: 1, color: AppColors.accent),
                const SizedBox(width: 10),
                Text('PRÜFUNGS-COUNTDOWN',
                    style: AppTextStyles.monoLabel(AppColors.accent)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${ziel.pruefung} · ${ziel.fachrichtung}',
                    style: AppTextStyles.mono(
                      size: 10,
                      color: AppColors.accent,
                      weight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.edit_outlined, size: 15, color: textDim),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Zahl mit Glow
                Stack(
                  alignment: Alignment.center,
                  children: [
                    if (isDark)
                      Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withOpacity(0.35),
                              blurRadius: 40,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          zahl,
                          style: AppTextStyles.instrumentSerif(
                            size: zahl.length > 2 ? 52 : 64,
                            color: AppColors.accent,
                            letterSpacing: -2.5,
                          ).copyWith(height: 1.0),
                        ),
                        Text(
                          einheit,
                          style: AppTextStyles.mono(
                            size: 10,
                            color: textDim,
                            weight: FontWeight.w600,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vorbei ? 'Prüfung liegt hinter dir' : titel,
                        style: AppTextStyles.instrumentSerif(
                          size: 22,
                          color: text,
                          letterSpacing: -0.6,
                        ).copyWith(height: 1.15),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        vorbei ? 'Neues Ziel setzen →' : untertitel,
                        style: AppTextStyles.bodySmall(textMid),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Tagesbezug: Fragen heute gegen ein Tagesziel (15, bis der
            // Tagesplan in Phase 2 den Wert liefert) + Streak.
            _buildTagesZeile(text, textMid, textDim, border),
          ],
        ),
      ),
    );
  }

  static const int _tagesziel = 15;
  int _heuteFragen = 0;
  int _streak = 0;

  Future<void> _loadTagesZeile() async {
    final heute = await DailyGoalService().getTodayAnsweredCount();
    final profil = AppCacheService().cachedMyProfile;
    final streak = (profil?['streak_days'] as num?)?.toInt() ?? 0;
    if (!mounted) return;
    setState(() {
      _heuteFragen = heute;
      _streak = streak;
    });
  }

  Widget _buildTagesZeile(Color text, Color textMid, Color textDim, Color border) {
    final anteil = (_heuteFragen / _tagesziel).clamp(0.0, 1.0);
    final fertig = _heuteFragen >= _tagesziel;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('HEUTE', style: AppTextStyles.monoSmall(textDim)),
                  const SizedBox(width: 8),
                  Text(
                    fertig
                        ? 'Tagesziel erreicht'
                        : '$_heuteFragen / $_tagesziel Fragen',
                    style: AppTextStyles.labelMedium(fertig ? AppColors.success : text),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: anteil,
                  minHeight: 4,
                  backgroundColor: border,
                  valueColor: AlwaysStoppedAnimation(
                    fertig ? AppColors.success : AppColors.accent,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Row(
          children: [
            Icon(
              Icons.local_fire_department_rounded,
              size: 16,
              color: _streak > 0 ? AppColors.warning : textDim,
            ),
            const SizedBox(width: 4),
            Text(
              _streak == 1 ? '1 Tag' : '$_streak Tage',
              style: AppTextStyles.labelMedium(_streak > 0 ? text : textDim),
            ),
          ],
        ),
      ],
    );
  }

  static String _wochentag(DateTime d) {
    const wt = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
    return wt[d.weekday - 1];
  }

  // ─── SECTION LABEL ──────────────────────────────────
  Widget _buildSectionLabel(String label, Color color) {
    return Row(
      children: [
        Container(width: 16, height: 1, color: AppColors.accent),
        const SizedBox(width: 10),
        Text(label, style: AppTextStyles.monoLabel(AppColors.accent)),
      ],
    );
  }

  // ─── DUE STRIPE (Hero für fällige Wiederholungen) ───
  Widget _buildDueStripe(
    Color surface,
    Color border,
    Color text,
    Color textMid,
  ) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ReviewScreen(totalCount: _dueCount),
          ),
        );
        _loadCounts();
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.accent.withOpacity(0.3)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.accent.withOpacity(0.08), surface],
          ),
        ),
        child: Row(
          children: [
            // Pulsating Dot
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.warning,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.warning.withOpacity(0.6),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'FÄLLIG HEUTE',
                        style: AppTextStyles.monoSmall(AppColors.warning),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '$_dueCount',
                          style: AppTextStyles.mono(
                            size: 10,
                            color: AppColors.warning,
                            weight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _dueCount == 1
                        ? '1 Wiederholung wartet'
                        : '$_dueCount Wiederholungen warten',
                    style: AppTextStyles.h3(text),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Spaced Repetition — der schnellste Weg zum Behalten.',
                    style: AppTextStyles.bodySmall(textMid),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Play Button
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: text,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                color: surface,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── ACTION CARD (2er-Grid) ─────────────────────────
  Widget _buildActionCard({
    required String number,
    required String label,
    required String sub,
    required bool accent,
    required Color surface,
    required Color border,
    required Color text,
    required Color textMid,
    required Color textDim,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: accent ? AppColors.accent.withOpacity(0.3) : border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Number-Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  number,
                  style: AppTextStyles.mono(
                    size: 11,
                    color: accent ? AppColors.accent : textDim,
                    weight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                if (onTap != null)
                  Icon(Icons.arrow_outward_rounded, color: textMid, size: 16)
                else
                  Icon(Icons.check_rounded, color: AppColors.success, size: 16),
              ],
            ),
            const SizedBox(height: 20),
            Text(label, style: AppTextStyles.h3(text)),
            const SizedBox(height: 4),
            Text(
              sub,
              style: AppTextStyles.bodySmall(
                accent ? AppColors.accent : textDim,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── CATEGORY ROW ───────────────────────────────────
  Widget _buildCategoryRow({
    required String tag,
    required Color tagColor,
    required String title,
    required String sub,
    required String count,
    required Color surface,
    required Color border,
    required Color text,
    required Color textMid,
    required Color textDim,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            // Tag-Badge
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: tagColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: tagColor.withOpacity(0.3)),
              ),
              child: Center(
                child: Text(
                  tag,
                  style: AppTextStyles.mono(
                    size: 12,
                    color: tagColor,
                    weight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.h3(text)),
                  const SizedBox(height: 2),
                  Text(sub, style: AppTextStyles.bodySmall(textMid)),
                ],
              ),
            ),
            Text(
              count,
              style: AppTextStyles.mono(
                size: 14,
                color: textMid,
                weight: FontWeight.w600,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios_rounded, color: textDim, size: 12),
          ],
        ),
      ),
    );
  }

  // ─── KURS ROW (wie CategoryRow, plus NEU-Badge) ─────
  Widget _buildKursRow({
    required String tag,
    required Color tagColor,
    required String title,
    required String sub,
    required String count,
    required bool neu,
    required Color surface,
    required Color border,
    required Color text,
    required Color textMid,
    required Color textDim,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: neu ? tagColor.withOpacity(0.35) : border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: tagColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: tagColor.withOpacity(0.3)),
              ),
              child: Center(
                child: Text(
                  tag,
                  style: AppTextStyles.mono(
                    size: 12,
                    color: tagColor,
                    weight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(child: Text(title, style: AppTextStyles.h3(text))),
                      if (neu) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: tagColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'NEU',
                            style: AppTextStyles.mono(
                              size: 9,
                              color: tagColor,
                              weight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(sub, style: AppTextStyles.bodySmall(textMid)),
                ],
              ),
            ),
            Text(
              count,
              style: AppTextStyles.mono(
                size: 14,
                color: textMid,
                weight: FontWeight.w600,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios_rounded, color: textDim, size: 12),
          ],
        ),
      ),
    );
  }

  // ─── CERT STRIP ─────────────────────────────────────
  Widget _buildCertStrip({
    required Color surface,
    required Color border,
    required Color text,
    required Color textMid,
    required Color textDim,
  }) {
    final certs = [
      (name: 'AWS', full: 'Cloud Practitioner', color: AppColors.awsOrange),
      (name: 'AZURE', full: 'Fundamentals', color: AppColors.azureBlue),
      (name: 'GCP', full: 'Digital Leader', color: AppColors.gcpBlue),
      (name: 'SAP', full: 'Associate', color: AppColors.sapBlue),
    ];

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CertificateOverviewScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mini-Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    "Übe für deine nächsten Zertifikate.",
                    style: AppTextStyles.instrumentSerif(
                      size: 22,
                      color: text,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                Icon(Icons.arrow_outward_rounded, color: textMid, size: 18),
              ],
            ),
            const SizedBox(height: 16),

            // Cert-Grid
            Row(
              children: certs.map((c) {
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: c == certs.last ? 0 : 8),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: c.color, width: 2)),
                      color: c.color.withOpacity(0.05),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.name,
                          style: AppTextStyles.mono(
                            size: 10,
                            color: c.color,
                            weight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          c.full,
                          style: AppTextStyles.labelSmall(text),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
