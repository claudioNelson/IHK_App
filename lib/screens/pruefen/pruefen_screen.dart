// lib/screens/pruefen/pruefen_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/ihk_exam_model.dart';
import '../../data/exams/ae-1.dart';
import '../../data/exams/ae-2.dart';
import '../../data/exams/ae-3.dart';
import '../../data/exams/si-1.dart';
import '../../data/exams/si-2.dart';
import '../../services/app_cache_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';
import '../../widgets/zertifikat_info_dialog.dart';
import '../../pages/pruefung/ihk_pruefung_detail_screen.dart';
import '../zertifikate/zertifikat_test_screen.dart';

class PruefenScreen extends StatefulWidget {
  const PruefenScreen({super.key});

  @override
  State<PruefenScreen> createState() => _PruefenScreenState();
}

class _PruefenScreenState extends State<PruefenScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final supabase = Supabase.instance.client;

  // IHK Data
  final _aeExams = [ae1Exam, ae2Exam, ae3Exam];
  final _siExams = [si1Exam, si2Exam];

  // Certificate Data
  List<dynamic> _zertifikate = [];
  Map<int, Map<String, dynamic>> _userResults = {};
  bool _loadingCerts = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));

    final cacheService = AppCacheService();
    if (cacheService.certificatesLoaded &&
        cacheService.cachedZertifikate.isNotEmpty) {
      _zertifikate = cacheService.cachedZertifikate;
      _userResults = Map.from(cacheService.cachedUserResults);
      _loadingCerts = false;
    } else {
      _loadZertifikate();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadZertifikate() async {
    try {
      final data = await supabase
          .from('zertifikate')
          .select(
              'id, name, anbieter, anzahl_fragen, pruefungsdauer, mindest_punktzahl')
          .order('anbieter');

      final userId = supabase.auth.currentUser?.id;
      if (userId != null) {
        final results = await supabase
            .from('user_certificates')
            .select()
            .eq('user_id', userId);
        for (var r in results) {
          _userResults[r['zertifikat_id']] = r;
        }
      }

      if (!mounted) return;
      setState(() {
        _zertifikate = data;
        _loadingCerts = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingCerts = false);
    }
  }

  Color _vendorColor(String? anbieter) {
    switch ((anbieter ?? '').toLowerCase()) {
      case 'aws':
        return AppColors.awsOrange;
      case 'microsoft':
        return AppColors.azureBlue;
      case 'google cloud':
        return AppColors.gcpBlue;
      case 'sap':
        return AppColors.sapBlue;
      default:
        return AppColors.accent;
    }
  }

  String _vendorTag(String? anbieter) {
    switch ((anbieter ?? '').toLowerCase()) {
      case 'aws':
        return 'AWS';
      case 'microsoft':
        return 'AZURE';
      case 'google cloud':
        return 'GCP';
      case 'sap':
        return 'SAP';
      default:
        return (anbieter ?? 'CERT').toUpperCase();
    }
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

    final totalIhk = _aeExams.length + _siExams.length;
    final totalCerts = _zertifikate.length;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ─── HEADER ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 1,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'PRÜFEN',
                        style: AppTextStyles.monoLabel(AppColors.accent),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Unter Prüfungsbedingungen.',
                    style: AppTextStyles.instrumentSerif(
                      size: 34,
                      color: text,
                      letterSpacing: -1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Timer an. Keine Erklärungen. Echte Bewertung.',
                    style: AppTextStyles.bodyMedium(textMid),
                  ),
                ],
              ),
            ),

            // ─── CUSTOM TABS ────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTabButton(
                        index: 0,
                        label: 'IHK-Prüfung',
                        count: totalIhk,
                        text: text,
                        textDim: textDim,
                        bgMuted: isDark
                            ? AppColors.darkBgMuted
                            : AppColors.lightBgMuted,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: _buildTabButton(
                        index: 1,
                        label: 'Zertifikate',
                        count: totalCerts,
                        text: text,
                        textDim: textDim,
                        bgMuted: isDark
                            ? AppColors.darkBgMuted
                            : AppColors.lightBgMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ─── CONTENT ────────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildIhkList(surface, border, text, textMid, textDim),
                  _buildCertList(surface, border, text, textMid, textDim),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── TAB BUTTON ───────────────────────────────────────
  Widget _buildTabButton({
    required int index,
    required String label,
    required int count,
    required Color text,
    required Color textDim,
    required Color bgMuted,
  }) {
    final isActive = _tabController.index == index;

    return GestureDetector(
      onTap: () => _tabController.animateTo(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isActive ? bgMuted : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: AppTextStyles.interTight(
                size: 13,
                weight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? text : textDim,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.accent
                    : textDim.withOpacity(0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '$count',
                style: AppTextStyles.mono(
                  size: 10,
                  color: isActive ? Colors.white : textDim,
                  weight: FontWeight.w700,
                  letterSpacing: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── IHK LIST ─────────────────────────────────────────
  Widget _buildIhkList(Color surface, Color border, Color text, Color textMid,
      Color textDim) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
      physics: const BouncingScrollPhysics(),
      children: [
        if (_aeExams.isNotEmpty) ...[
          _buildCategoryHeader(
            tag: 'AE',
            tagColor: const Color(0xFF60A5FA),
            title: 'Anwendungsentwicklung',
            meta: '${_aeExams.length} PRÜFUNGEN',
            textMid: textMid,
            textDim: textDim,
            text: text,
          ),
          const SizedBox(height: 12),
          ..._aeExams.map((exam) => _buildIhkCard(
                exam: exam,
                category: 'AE',
                categoryColor: const Color(0xFF60A5FA),
                surface: surface,
                border: border,
                text: text,
                textMid: textMid,
                textDim: textDim,
              )),
          const SizedBox(height: 28),
        ],
        if (_siExams.isNotEmpty) ...[
          _buildCategoryHeader(
            tag: 'SI',
            tagColor: const Color(0xFF34D399),
            title: 'Systemintegration',
            meta: '${_siExams.length} PRÜFUNGEN',
            textMid: textMid,
            textDim: textDim,
            text: text,
          ),
          const SizedBox(height: 12),
          ..._siExams.map((exam) => _buildIhkCard(
                exam: exam,
                category: 'SI',
                categoryColor: const Color(0xFF34D399),
                surface: surface,
                border: border,
                text: text,
                textMid: textMid,
                textDim: textDim,
              )),
        ],
      ],
    );
  }

  // ─── CERT LIST ────────────────────────────────────────
  Widget _buildCertList(Color surface, Color border, Color text, Color textMid,
      Color textDim) {
    if (_loadingCerts) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.accent),
      );
    }

    if (_zertifikate.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: textDim),
            const SizedBox(height: 12),
            Text(
              'Keine Zertifikate verfügbar',
              style: AppTextStyles.bodyMedium(textMid),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.accent,
      onRefresh: _loadZertifikate,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        children: [
          // Info-Box
          Container(
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.accent.withOpacity(0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded,
                    color: AppColors.accent, size: 16),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Zertifikats-Simulationen laufen mit Timer und ohne Erklärungen — wie die echte Prüfung.',
                    style: AppTextStyles.bodySmall(text),
                  ),
                ),
              ],
            ),
          ),
          ..._zertifikate.map(
            (cert) => _buildCertCard(
              cert: cert,
              surface: surface,
              border: border,
              text: text,
              textMid: textMid,
              textDim: textDim,
            ),
          ),
        ],
      ),
    );
  }

  // ─── CATEGORY HEADER ──────────────────────────────────
  Widget _buildCategoryHeader({
    required String tag,
    required Color tagColor,
    required String title,
    required String meta,
    required Color text,
    required Color textMid,
    required Color textDim,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: tagColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: tagColor.withOpacity(0.3)),
          ),
          child: Center(
            child: Text(
              tag,
              style: AppTextStyles.mono(
                size: 11,
                color: tagColor,
                weight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.h3(text)),
              Text(meta, style: AppTextStyles.monoSmall(textDim)),
            ],
          ),
        ),
      ],
    );
  }

  // ─── IHK CARD ────────────────────────────────────────
  Widget _buildIhkCard({
    required IHKExam exam,
    required String category,
    required Color categoryColor,
    required Color surface,
    required Color border,
    required Color text,
    required Color textMid,
    required Color textDim,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => IHKPruefungDetailScreen(exam: exam),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top: Tag + Season
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${exam.season.toUpperCase()} ${exam.year}',
                      style: AppTextStyles.mono(
                        size: 10,
                        color: categoryColor,
                        weight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded,
                      color: textDim, size: 12),
                ],
              ),
              const SizedBox(height: 12),

              // Title
              Text(exam.title, style: AppTextStyles.h3(text)),
              const SizedBox(height: 4),

              // Company (italic)
              Text(
                exam.company,
                style: AppTextStyles.instrumentSerif(
                  size: 14,
                  color: textMid,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 14),

              // Info Row (Icon + Text statt abstrakte Zahlen)
Row(
  children: [
    _infoItem(Icons.schedule_rounded, '${exam.duration} Minuten',
        textMid, textDim),
    const SizedBox(width: 20),
    _infoItem(Icons.check_circle_outline_rounded,
        '${exam.totalPoints} Punkte', textMid, textDim),
    const Spacer(),
    // Starten-CTA
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Starten',
            style: AppTextStyles.interTight(
              size: 12,
              weight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_forward_rounded,
              color: Colors.white, size: 12),
        ],
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

  Widget _statBlock(String label, String value, String unit, Color valueColor,
      Color textDim) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label, style: AppTextStyles.monoSmall(textDim)),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: AppTextStyles.interTight(
                    size: 15,
                    weight: FontWeight.w600,
                    color: valueColor,
                  ),
                ),
                if (unit.isNotEmpty)
                  TextSpan(
                    text: ' $unit',
                    style: AppTextStyles.bodySmall(textDim),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String label, Color color, Color iconColor) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 14, color: iconColor),
      const SizedBox(width: 6),
      Text(
        label,
        style: AppTextStyles.bodySmall(color),
      ),
    ],
  );
}

  // ─── CERT CARD ────────────────────────────────────────
  Widget _buildCertCard({
    required dynamic cert,
    required Color surface,
    required Color border,
    required Color text,
    required Color textMid,
    required Color textDim,
  }) {
    final vendorColor = _vendorColor(cert['anbieter']);
    final vendorTag = _vendorTag(cert['anbieter']);
    final result = _userResults[cert['id']];
    final passed = result?['passed'] == true;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () async {
          final shouldStart = await showZertifikatInfoDialog(context, cert);
          if (shouldStart == true && context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ZertifikatTestPage(
                  zertifikatId: cert['id'],
                  zertifikatName: cert['name'],
                  anzahlFragen: cert['anzahl_fragen'],
                  pruefungsdauer: cert['pruefungsdauer'],
                  mindestPunktzahl: cert['mindest_punktzahl'],
                ),
              ),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: passed
                  ? AppColors.success.withOpacity(0.4)
                  : border,
            ),
            // Top-Accent-Line je Vendor
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.02, 0.02, 1.0],
              colors: [
                vendorColor,
                vendorColor,
                surface,
                surface,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top: Vendor + Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: vendorColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      vendorTag,
                      style: AppTextStyles.mono(
                        size: 10,
                        color: vendorColor,
                        weight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  if (passed)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified_rounded,
                              size: 12, color: AppColors.success),
                          const SizedBox(width: 4),
                          Text(
                            'BESTANDEN',
                            style: AppTextStyles.mono(
                              size: 9,
                              color: AppColors.success,
                              weight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Icon(Icons.arrow_forward_ios_rounded,
                        color: textDim, size: 12),
                ],
              ),
              const SizedBox(height: 12),

              // Title
              Text(cert['name'] ?? '', style: AppTextStyles.h3(text)),
              const SizedBox(height: 14),

              // Stats
              // Info Row
Row(
  children: [
    _infoItem(Icons.quiz_outlined,
        '${cert['anzahl_fragen'] ?? 0} Fragen', textMid, textDim),
    const SizedBox(width: 16),
    _infoItem(Icons.schedule_rounded,
        '${cert['pruefungsdauer'] ?? '–'} Min', textMid, textDim),
    const SizedBox(width: 16),
    _infoItem(Icons.flag_outlined,
        'Min. ${cert['mindest_punktzahl'] ?? '–'}%', textMid, textDim),
  ],
),

              // Best Score (wenn vorhanden)
              if (result != null) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.trending_up_rounded,
                        size: 14, color: AppColors.accentCyan),
                    const SizedBox(width: 6),
                    Text(
                      'Bester Versuch: ${result['best_score']}% · ${result['attempts']}x versucht',
                      style: AppTextStyles.monoSmall(textMid),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}