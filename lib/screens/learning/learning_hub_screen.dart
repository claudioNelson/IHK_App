import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../screens/module/modul_liste_screen.dart';
import '../../services/spaced_repetition_service.dart';
import '../../services/flashcard_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';
import 'review_screen.dart';
import 'core_topics_screen.dart';
import 'flashcard_screen.dart';
import '../zertifikate/certificate_overview_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _loadCounts();
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
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Guten Morgen.';
    if (hour < 17) return 'Hey.';
    if (hour < 22) return 'Guten Abend.';
    return 'Spät noch wach?';
  }

  String _getDateLabel() {
    final now = DateTime.now();
    const months = [
      'JAN', 'FEB', 'MÄR', 'APR', 'MAI', 'JUN',
      'JUL', 'AUG', 'SEP', 'OKT', 'NOV', 'DEZ'
    ];
    const weekdays = ['MO', 'DI', 'MI', 'DO', 'FR', 'SA', 'SO'];
    final wd = weekdays[now.weekday - 1];
    final m = months[now.month - 1];
    return '$wd · ${now.day.toString().padLeft(2, '0')} $m ${now.year}';
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
              child: _buildHeader(text, textMid, textDim),
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

                  _buildCategoryRow(
                    tag: 'KT',
                    tagColor: AppColors.accentCyan,
                    title: 'Kernthemen',
                    sub: 'Prüfungsrelevante Basics',
                    count: '8',
                    surface: surface,
                    border: border,
                    text: text,
                    textMid: textMid,
                    textDim: textDim,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CoreTopicsScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  _buildCategoryRow(
                    tag: 'MO',
                    tagColor: AppColors.accent,
                    title: 'Module',
                    sub: 'Systematisch durcharbeiten',
                    count: '17',
                    surface: surface,
                    border: border,
                    text: text,
                    textMid: textMid,
                    textDim: textDim,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ModulListe(),
                        ),
                      );
                      _loadCounts();
                    },
                  ),
                  const SizedBox(height: 10),

                  _buildCategoryRow(
                    tag: 'ZT',
                    tagColor: AppColors.awsOrange,
                    title: 'Zertifikate',
                    sub: 'AWS · Azure · GCP · SAP',
                    count: '4',
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
      child: SafeArea(
        bottom: false,
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
                Text(
                  _getDateLabel(),
                  style: AppTextStyles.monoLabel(textDim),
                ),
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
          ],
        ),
      ),
    );
  }

  // ─── SECTION LABEL ──────────────────────────────────
  Widget _buildSectionLabel(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 1,
          color: AppColors.accent,
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: AppTextStyles.monoLabel(AppColors.accent),
        ),
      ],
    );
  }

  // ─── DUE STRIPE (Hero für fällige Wiederholungen) ───
  Widget _buildDueStripe(
      Color surface, Color border, Color text, Color textMid) {
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
            colors: [
              AppColors.accent.withOpacity(0.08),
              surface,
            ],
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
                            horizontal: 6, vertical: 2),
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
                  Icon(
                    Icons.arrow_outward_rounded,
                    color: textMid,
                    size: 16,
                  )
                else
                  Icon(
                    Icons.check_rounded,
                    color: AppColors.success,
                    size: 16,
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              label,
              style: AppTextStyles.h3(text),
            ),
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
                border: Border.all(
                  color: tagColor.withOpacity(0.3),
                ),
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
                  Text(
                    title,
                    style: AppTextStyles.h3(text),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sub,
                    style: AppTextStyles.bodySmall(textMid),
                  ),
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
        MaterialPageRoute(
          builder: (_) => const CertificateOverviewScreen(),
        ),
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
                    'Nach der IHK ist vor der Cloud.',
                    style: AppTextStyles.instrumentSerif(
                      size: 22,
                      color: text,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_outward_rounded,
                  color: textMid,
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Cert-Grid
            Row(
              children: certs.map((c) {
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      right: c == certs.last ? 0 : 8,
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: c.color, width: 2),
                      ),
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