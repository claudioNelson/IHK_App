import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'certificate_practice_screen.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';

class CertificateOverviewScreen extends StatefulWidget {
  const CertificateOverviewScreen({super.key});

  @override
  _CertificateOverviewScreenState createState() =>
      _CertificateOverviewScreenState();
}

class _CertificateOverviewScreenState extends State<CertificateOverviewScreen> {
  List<Map<String, dynamic>> certificates = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCertificates();
  }

  Future<void> _loadCertificates() async {
    try {
      final result = await Supabase.instance.client
          .from('zertifikate')
          .select()
          .order('created_at');
      if (!mounted) return;
      setState(() {
        certificates = List<Map<String, dynamic>>.from(result);
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Laden: $e'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Vendor: Kürzel + Name + Icon + Akzentfarbe
  String _vendorShort(String anbieter) {
    if (anbieter.contains('AWS') || anbieter.contains('Amazon')) return 'AWS';
    if (anbieter.contains('Microsoft') || anbieter.contains('Azure'))
      return 'AZURE';
    if (anbieter.contains('Google')) return 'GCP';
    if (anbieter.contains('SAP')) return 'SAP';
    return anbieter.toUpperCase();
  }

  String _vendorFull(String anbieter) {
    if (anbieter.contains('AWS') || anbieter.contains('Amazon'))
      return 'AMAZON WEB SERVICES';
    if (anbieter.contains('Microsoft') || anbieter.contains('Azure'))
      return 'MICROSOFT AZURE';
    if (anbieter.contains('Google')) return 'GOOGLE CLOUD';
    if (anbieter.contains('SAP')) return 'SAP';
    return anbieter.toUpperCase();
  }

  IconData _vendorIcon(String anbieter) {
    if (anbieter.contains('AWS') || anbieter.contains('Amazon'))
      return Icons.cloud_outlined;
    if (anbieter.contains('Microsoft') || anbieter.contains('Azure'))
      return Icons.window_outlined;
    if (anbieter.contains('Google')) return Icons.language_outlined;
    if (anbieter.contains('SAP')) return Icons.business_center_outlined;
    return Icons.workspace_premium_outlined;
  }

  Color _vendorColor(String anbieter) {
    if (anbieter.contains('AWS') || anbieter.contains('Amazon'))
      return AppColors.warning;
    if (anbieter.contains('Microsoft') || anbieter.contains('Azure'))
      return AppColors.accentCyan;
    if (anbieter.contains('Google')) return AppColors.accent;
    if (anbieter.contains('SAP')) return AppColors.accentCyan;
    return AppColors.accent;
  }

  // Difficulty aus Fragen-Anzahl ableiten
  String _difficultyLabel(int anzahl) {
    if (anzahl < 40) return 'EINSTIEG';
    if (anzahl <= 65) return 'FORTGESCHRITTEN';
    return 'PROFI';
  }

  Color _difficultyColor(int anzahl) {
    if (anzahl < 40) return AppColors.success;
    if (anzahl <= 65) return AppColors.warning;
    return AppColors.error;
  }

  // Geschätzte Lernzeit (~30 Sek pro Frage zum durcharbeiten)
  String _estimatedTime(int anzahl) {
    final mins = (anzahl * 0.5).round();
    if (mins < 60) return '~$mins MIN';
    final h = mins ~/ 60;
    final m = mins % 60;
    if (m == 0) return '~${h}H';
    return '~${h}H ${m}M';
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

    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // ─── APPBAR ─────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back_rounded, color: text, size: 22),
                  ),
                  Expanded(
                    child: Text(
                      'ZERTIFIKATE',
                      style: AppTextStyles.monoLabel(textMid),
                    ),
                  ),
                ],
              ),
            ),

            // ─── HEADER ─────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(width: 16, height: 1, color: AppColors.accent),
                      const SizedBox(width: 10),
                      Text(
                        'CLOUD & ENTERPRISE',
                        style: AppTextStyles.monoLabel(AppColors.accent),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Zertifikate.',
                    style: AppTextStyles.instrumentSerif(
                      size: 40,
                      color: text,
                      letterSpacing: -1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bereite dich auf deine Prüfung vor.',
                    style: AppTextStyles.bodyMedium(textMid),
                  ),
                  if (!isLoading && certificates.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppColors.accent.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        '${certificates.length} ZERTIFIKATE VERFÜGBAR',
                        style: AppTextStyles.mono(
                          size: 10,
                          color: AppColors.accent,
                          weight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // ─── CONTENT ────────────────────────────
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.accent),
                    )
                  : certificates.isEmpty
                  ? _buildEmpty(textMid, textDim)
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isWide ? 3 : 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: isWide ? 0.78 : 0.62,
                      ),
                      itemCount: certificates.length,
                      itemBuilder: (context, index) => _buildCertCard(
                        certificates[index],
                        surface,
                        border,
                        text,
                        textMid,
                        textDim,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(Color textMid, Color textDim) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: textDim),
          const SizedBox(height: 16),
          Text('Keine Zertifikate verfügbar', style: AppTextStyles.h3(textMid)),
        ],
      ),
    );
  }

  Widget _buildCertCard(
    Map<String, dynamic> cert,
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    final anbieter = cert['anbieter'] ?? '';
    final short = _vendorShort(anbieter);
    final fullName = _vendorFull(anbieter);
    final icon = _vendorIcon(anbieter);
    final accentColor = _vendorColor(anbieter);
    final anzahlFragen = cert['anzahl_fragen'] as int? ?? 0;
    final difficulty = _difficultyLabel(anzahlFragen);
    final difficultyColor = _difficultyColor(anzahlFragen);
    final time = _estimatedTime(anzahlFragen);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CertificatePracticeScreen(
            zertifikatId: cert['id'],
            certName: cert['name'],
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.015, 0.015, 1.0],
            colors: [accentColor, accentColor, surface, surface],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              // Top: Icon + Vendor Tag
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: accentColor, size: 16),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: accentColor.withOpacity(0.25)),
                    ),
                    child: Text(
                      short,
                      style: AppTextStyles.mono(
                        size: 9,
                        color: accentColor,
                        weight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Vendor Full Name (klein)
              Text(
                fullName,
                style: AppTextStyles.monoSmall(textDim),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              // Cert Name (Serif) — flexibel, nimmt verfügbaren Platz
              Expanded(
                child: Text(
                  cert['name'] ?? '',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.instrumentSerif(
                    size: 16,
                    color: text,
                    letterSpacing: -0.4,
                    height: 1.2,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Stats: Fragen + Zeit + Difficulty (alle in Wrap, umbricht automatisch)
              Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.help_outline_rounded,
                        size: 10,
                        color: textMid,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '$anzahlFragen',
                        style: AppTextStyles.monoSmall(textMid),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.access_time_rounded, size: 10, color: textMid),
                      const SizedBox(width: 3),
                      Text(time, style: AppTextStyles.monoSmall(textMid)),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Difficulty Badge + Arrow
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: difficultyColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: difficultyColor.withOpacity(0.25),
                        ),
                      ),
                      child: Text(
                        difficulty,
                        style: AppTextStyles.mono(
                          size: 9,
                          color: difficultyColor,
                          weight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, size: 12, color: textMid),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
