import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../screens/module/modul_liste_screen.dart';
import '../../services/app_cache_service.dart';
import '../../services/auth_service.dart';
import '../../services/spaced_repetition_service.dart';
import '../../services/streak_service.dart';
import '../../services/flashcard_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';
import 'review_screen.dart';
import 'anschluesse_quiz_screen.dart';
import 'flashcard_screen.dart';
import '../zertifikate/certificate_overview_screen.dart';
import '../levels/level_module_screen.dart';
import '../kurse/kurs_uebersicht_screen.dart';
import '../../data/kurse/sql_kurs.dart';
import '../../data/kurse/python_kurs.dart';
import '../../widgets/header_wash.dart';
import '../../services/ziel_service.dart';
import '../../services/lernplan_service.dart';
import '../../widgets/navigation/nav_root.dart';
import '../module/test_fragen_screen.dart';
import '../onboarding/ziel_screen.dart';
import '../../services/aktions_service.dart';
import '../../services/subscription_service.dart';
import '../../widgets/premium_kauf_sheet.dart';

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
  Aktion? _aktion;

  /// Laesst die Stunden/Minuten-Zeile im Countdown mitlaufen.
  Timer? _countdownTick;

  @override
  void initState() {
    super.initState();
    _countdownTick = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted && _ziel?.datum != null) setState(() {});
    });
    _loadCounts();
    _loadUsername();
    _loadZiel();
    _loadAktion();
    StreakService.aktuell.addListener(_onStreak);
  }

  void _onStreak() {
    final w = StreakService.aktuell.value;
    if (mounted && w != _streak) setState(() => _streak = w);
  }

  /// Laufende Aktion (z. B. Pruefungs-Endspurt). Nur fuer Free-Nutzer auf
  /// Plattformen, auf denen gekauft werden kann.
  Future<void> _loadAktion() async {
    if (!premiumKaufMoeglich) return;
    final aktion = await AktionsService().laden();
    if (!mounted) return;
    setState(() => _aktion = aktion);
  }

  Future<void> _aktionOeffnen() async {
    final gekauft = await showPremiumKaufSheet(context);
    if (gekauft == true && mounted) setState(() {});
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
      _loadTagesZeile(neu: true);
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
  void dispose() {
    StreakService.aktuell.removeListener(_onStreak);
    _countdownTick?.cancel();
    super.dispose();
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
    // Cache hat Vorrang: der wird beim Umbenennen im Profil aktualisiert,
    // _username stammt vom ersten Laden des Hubs.
    final cachedName = AppCacheService().cachedMyProfile?['username'] as String?;
    final name = (cachedName != null && cachedName.trim().isNotEmpty)
        ? cachedName.trim()
        : _username;

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
    // Fallback = Stand der DB (16 Module ohne Kernthema, 25.09.2026).
    final modulCount = cache.cachedModule.isNotEmpty
        ? cache.cachedModule.length
        : 16;
    // Laeuft der Tagesplan, steht "Wiederholen" schon als Posten in der
    // Countdown-Karte; die Schnellzugriff-Karte waere doppelt. Ohne Ziel
    // (Einladung statt Plan) bleibt sie der einzige Weg zu den Wiederholungen.
    final planLaeuft = _ziel != null && _plan != null;

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
        onRefresh: () async {
          await _loadCounts();
          await _loadTagesZeile(neu: true);
        },
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
                  // SECTION: SCHNELLZUGRIFF
                  _buildSectionLabel('Schnellzugriff', textMid),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      if (!planLaeuft) ...[
                      Expanded(
                        child: _buildActionCard(
                          icon: Icons.replay_rounded,
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
                      ],
                      Expanded(
                        child: _buildActionCard(
                          icon: Icons.style_outlined,
                          label: 'Karteikarten',
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
                  _buildSectionLabel('Lernbereiche', textMid),
                  const SizedBox(height: 14),

                  _buildCategoryRow(
                    tag: 'LV',
                    tagColor: AppColors.accent,
                    title: 'Levels',
                    sub: 'Aufbauende Lernpfade',
                    empfohlen: true,
                    count: '$levelCount Level',
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
                    count: '$modulCount Module',
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
                    count: '16 Fragen',
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
                  _buildSectionLabel('Kurse', textMid),
                  const SizedBox(height: 14),
                  _buildKursRow(
                    tag: 'SQL',
                    tagColor: AppColors.accentCyan,
                    title: sqlKurs.titel,
                    sub: 'Interaktiver Kurs mit echter Datenbank',
                    count: '${sqlKurs.lektionen.length} Lektionen',
                    neu: false,
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
                    count: '${pythonKurs.lektionen.length} Lektionen',
                    neu: false,
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
                  _buildSectionLabel('Zertifikate üben', textMid),
                  const SizedBox(height: 14),
                  _buildCategoryRow(
                    tag: 'ZT',
                    tagColor: AppColors.awsOrange,
                    title: 'Zertifikate üben',
                    sub: 'AWS, Azure, Google Cloud, SAP',
                    count: '4 Zertifikate',
                    surface: surface,
                    border: border,
                    text: text,
                    textMid: textMid,
                    textDim: textDim,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CertificateOverviewScreen(),
                      ),
                    ),
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
              'Dein Plan für heute.',
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

    final aktionSichtbar =
        _aktion != null && !SubscriptionService().isPremium;

    if (ziel == null) {
      final einladung = GestureDetector(
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
      return Column(
        children: [
          einladung,
          if (aktionSichtbar) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.fromLTRB(18, 10, 12, 10),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: border),
              ),
              child: _buildAktionsZeile(_aktion!, text, textMid, textDim),
            ),
          ],
        ],
      );
    }

    final tage = ziel.tageBis;
    final vorbei = tage != null && tage < 0;
    final heute = tage == 0;
    // Restdauer bis 0:00 Uhr am Pruefungstag: grosse Zahl = volle Tage,
    // darunter laufen Stunden und Minuten mit (Timer, minuetlich).
    final rest = ziel.datum == null || tage == null || tage <= 0
        ? null
        : DateTime(ziel.datum!.year, ziel.datum!.month, ziel.datum!.day)
            .difference(DateTime.now());
    final restTage = rest?.inDays;
    final zahl = tage == null
        ? '?'
        : vorbei
            ? '✓'
            : heute
                ? '0'
                : '${restTage ?? tage}';
    final ticker = rest == null
        ? null
        : '${(rest.inHours % 24).toString().padLeft(2, '0')} STD · '
            '${(rest.inMinutes % 60).toString().padLeft(2, '0')} MIN';
    final einheit = tage == null
        ? 'TERMIN OFFEN'
        : vorbei
            ? 'GESCHAFFT?'
            : heute
                ? 'HEUTE'
                : ((restTage ?? tage) == 1 ? 'TAG' : 'TAGE');
    // Kurz: Pruefung und Fachrichtung stehen schon im Chip oben rechts.
    final titel = 'bis zur ${ziel.pruefung}';
    final untertitel = ziel.datum == null
        ? 'Termin noch eintragen'
        : '${_wochentag(ziel.datum!)}, ${ZielScreen.datumText(ziel.datum!)}';

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
                // Kein Kicker: "8 Tage bis zur AP1" erklaert sich selbst.
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
            // Kompakt: eine Zeile "12 TAGE · 11 STD · 17 MIN" (bzw. HEUTE /
            // GESCHAFFT? / TERMIN OFFEN), darunter klein "bis zur AP1 · Datum".
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  zahl,
                  style: AppTextStyles.instrumentSerif(
                    size: 34,
                    color: AppColors.accent,
                    letterSpacing: -1.2,
                  ).copyWith(height: 1.0),
                ),
                const SizedBox(width: 6),
                Text(
                  einheit,
                  style: AppTextStyles.mono(
                    size: 10,
                    color: textDim,
                    weight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
                if (ticker != null) ...[
                  const SizedBox(width: 10),
                  Text(
                    '·  $ticker',
                    style: AppTextStyles.mono(
                      size: 11,
                      color: AppColors.accent.withOpacity(0.85),
                      weight: FontWeight.w600,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 2),
            Text(
              vorbei ? 'Prüfung liegt hinter dir · Neues Ziel setzen' : '$titel · $untertitel',
              style: AppTextStyles.bodySmall(textMid),
            ),
            const SizedBox(height: 12),
            // Tagesbezug: Fragen heute gegen ein Tagesziel (15, bis der
            // Tagesplan in Phase 2 den Wert liefert) + Streak.
            _buildTagesZeile(text, textMid, textDim, border),
            if (aktionSichtbar) ...[
              const SizedBox(height: 12),
              Container(height: 1, color: border),
              const SizedBox(height: 10),
              _buildAktionsZeile(_aktion!, text, textMid, textDim),
            ],
          ],
        ),
      ),
    );
  }

  Tagesplan? _plan;
  int _streak = 0;

  /// Tagesplan aufgeklappt (alle Posten) oder nur der naechste offene.
  bool _planOffen = false;

  /// Tagesplan (Phase 2): eine RPC liefert alles, LernplanService rechnet
  /// die Posten. Streak kommt weiter aus dem Profil-Cache.
  Future<void> _loadTagesZeile({bool neu = false}) async {
    final plan = await LernplanService().laden(neu: neu);
    final profil = AppCacheService().cachedMyProfile;
    // Frisch berechneter Wert aus StreakService hat Vorrang vor dem Cache.
    final live = StreakService.aktuell.value;
    final streak = live > 0 ? live : (profil?['streak_days'] as num?)?.toInt() ?? 0;
    if (!mounted) return;
    setState(() {
      _plan = plan;
      _streak = streak;
    });
  }

  /// Posten antippen: Thema, Wiederholungen oder Pruefen oeffnen; danach
  /// Plan und Zaehler neu laden.
  Future<void> _postenOeffnen(LernPosten p) async {
    switch (p.typ) {
      case PostenTyp.thema:
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TestFragen(
              modulId: p.modulId!,
              modulName: '${p.modulName} • ${p.themaName}',
              themaId: p.themaId!,
              requiredScore: p.requiredScore,
            ),
          ),
        );
        break;
      case PostenTyp.wiederholen:
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ReviewScreen(totalCount: _dueCount)),
        );
        break;
      case PostenTyp.pruefung:
        // Pruefen-Tab (Index 1) statt eines eigenen Screens; der Plan wird
        // beim naechsten Aufruf des Hubs neu geladen.
        NavRoot.tabWechsel.value = 1;
        return;
    }
    if (!mounted) return;
    _loadCounts();
    _loadTagesZeile(neu: true);
  }

  Widget _buildTagesZeile(Color text, Color textMid, Color textDim, Color border) {
    final plan = _plan;
    final tagesziel = plan?.tagesziel ?? 15;
    final heute = plan?.heuteFragen ?? 0;
    final anteil = (heute / tagesziel).clamp(0.0, 1.0);
    final fertig = heute >= tagesziel;
    final alles = plan?.allesFertig ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
                        alles
                            ? 'Alles erledigt'
                            : fertig
                                ? 'Tagesziel erreicht'
                                : '$heute / $tagesziel Fragen',
                        style: AppTextStyles.labelMedium(
                            (fertig || alles) ? AppColors.success : text),
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
            // Streak nur zeigen, wenn es einen gibt ("0 Tage" war ein
            // Negativ-Signal an prominenter Stelle).
            if (_streak > 0) ...[
              const SizedBox(width: 16),
              Row(
                children: [
                  const Icon(
                    Icons.local_fire_department_rounded,
                    size: 16,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _streak == 1 ? '1 Tag' : '$_streak Tage',
                    style: AppTextStyles.labelMedium(text),
                  ),
                ],
              ),
            ],
          ],
        ),
        if (plan != null && plan.posten.isNotEmpty && !alles) ...[
          const SizedBox(height: 10),
          ..._buildPlanZeilen(plan, text, textMid, textDim),
        ],
      ],
    );
  }

  /// Schlank: standardmaessig nur der naechste offene Posten, rechts ein
  /// "2 weitere", das die ganze Liste aufklappt. Erledigte rutschen nach
  /// hinten und werden erst im aufgeklappten Zustand gezeigt.
  List<Widget> _buildPlanZeilen(Tagesplan plan, Color text, Color textMid, Color textDim) {
    final offen = plan.posten.where((p) => !p.fertig).toList();
    final fertig = plan.posten.where((p) => p.fertig).toList();
    if (!_planOffen) {
      final naechster = offen.first;
      final weitere = plan.posten.length - 1;
      return [
        _buildPosten(
          naechster, text, textMid, textDim,
          trailing: weitere > 0
              ? GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _planOffen = true),
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 44),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '+$weitere',
                        style: AppTextStyles.mono(
                          size: 10,
                          color: AppColors.accent,
                          weight: FontWeight.w600,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ),
                )
              : null,
        ),
      ];
    }
    return [
      for (final p in [...offen, ...fertig]) _buildPosten(p, text, textMid, textDim),
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setState(() => _planOffen = false),
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          alignment: Alignment.centerLeft,
          child: Text(
            'WENIGER',
            style: AppTextStyles.mono(size: 10, color: textDim, weight: FontWeight.w600),
          ),
        ),
      ),
    ];
  }

  /// Ein Posten des Tagesplans: Haken-Kreis, Titel, Untertitel, rechts der
  /// Stand ("6/12") oder ein gruener Haken. Antippbar.
  Widget _buildPosten(
    LernPosten p,
    Color text,
    Color textMid,
    Color textDim, {
    String? label,
    Widget? trailing,
  }) {
    final fertig = p.fertig;
    final icon = switch (p.typ) {
      PostenTyp.thema => Icons.menu_book_rounded,
      PostenTyp.wiederholen => Icons.replay_rounded,
      PostenTyp.pruefung => Icons.timer_outlined,
    };
    // Der Posten selbst ist antippbar. Ein optionales trailing (z. B. der
    // "+2"-Chip zum Aufklappen) liegt AUSSERHALB dieses Taps, sonst
    // gewinnt der Posten und der Chip navigiert statt aufzuklappen.
    final posten = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _postenOeffnen(p),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: fertig ? AppColors.success.withOpacity(0.18) : Colors.transparent,
                border: Border.all(
                  color: fertig ? AppColors.success : AppColors.accent.withOpacity(0.5),
                  width: 1.5,
                ),
              ),
              child: Icon(
                fertig ? Icons.check_rounded : icon,
                size: 14,
                color: fertig ? AppColors.success : AppColors.accent,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.titel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.labelMedium(fertig ? textMid : text).copyWith(
                      decoration: fertig ? TextDecoration.lineThrough : null,
                      decorationColor: textDim,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    label != null ? '$label · ${p.untertitel}' : p.untertitel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall(textDim),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (!fertig && p.ziel > 1)
              Text(
                '${p.erledigt}/${p.ziel}',
                style: AppTextStyles.mono(
                  size: 11,
                  color: p.erledigt > 0 ? AppColors.accent : textDim,
                  weight: FontWeight.w600,
                ),
              ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right_rounded, size: 18, color: textDim),
          ],
        ),
      ),
    );
    if (trailing == null) return posten;
    return Row(
      children: [
        Expanded(child: posten),
        trailing,
      ],
    );
  }

  static String _wochentag(DateTime d) {
    const wt = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
    return wt[d.weekday - 1];
  }

  // ─── AKTION (z. B. Pruefungs-Endspurt) ───────────────
  // Schmale Zeile am Fuss der Countdown-Karte statt eigener Karte: die
  // Aktion gehoert zur Pruefung, und drei Hero-Karten uebereinander waren
  // zu viel. Bernstein nur auf Icon und Frist-Chip. Preise stehen nicht
  // hier, die zeigt das Kauf-Sheet aus dem Store.
  Widget _buildAktionsZeile(
    Aktion aktion,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    const farbe = AppColors.warning;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _aktionOeffnen,
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: farbe.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.local_offer_rounded,
                color: farbe, size: 15),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${aktion.titel}: ',
                    style: AppTextStyles.labelMedium(text),
                  ),
                  TextSpan(
                    text: aktion.text,
                    style: AppTextStyles.bodySmall(textMid),
                  ),
                ],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: farbe.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              aktion.fristLabel,
              style: AppTextStyles.mono(
                size: 9,
                color: farbe,
                weight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right_rounded, size: 18, color: textDim),
        ],
      ),
    );
  }

  // ─── SECTION LABEL ──────────────────────────────────
  // Schlichte Ueberschrift in der Textschrift; kein Mono-Kicker mit Strich
  // (Befund Design-Review 21.09.: wirkte wie Deko auf jedem Abschnitt).
  Widget _buildSectionLabel(String label, Color color) {
    return Text(label, style: AppTextStyles.labelLarge(color));
  }

  // ─── ACTION CARD (2er-Grid) ─────────────────────────
  Widget _buildActionCard({
    required IconData icon,
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
            // Icon statt laufender Nummer ("01"/"02" trug keine Information)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: accent ? AppColors.accent : textDim,
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
    bool empfohlen = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: empfohlen ? AppColors.accent.withOpacity(0.45) : border,
          ),
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
                  Row(
                    children: [
                      Text(title, style: AppTextStyles.h3(text)),
                      if (empfohlen) ...[
                        const SizedBox(width: 8),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'EMPFOHLENER EINSTIEG',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.mono(
                                size: 9,
                                color: AppColors.accent,
                                weight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
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
                size: 11,
                color: textDim,
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
                size: 11,
                color: textDim,
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
}
