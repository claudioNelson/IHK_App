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

  // Vendor: Name + Icon + Akzentfarbe
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

  // Geschaetzte Lernzeit (etwa 30 Sekunden je Frage zum Durcharbeiten)
  String _estimatedTime(int anzahl) {
    final mins = (anzahl * 0.5).round();
    if (mins < 60) return 'etwa $mins Min';
    final h = mins ~/ 60;
    final m = mins % 60;
    if (m == 0) return 'etwa $h Std';
    return 'etwa $h Std $m Min';
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
                        style: AppTextStyles.monoLabel(AppColors.accentText),
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
                    'Mit Erklärungen üben, ohne Timer. Die Simulation findest du unter Prüfen.',
                    style: AppTextStyles.bodyMedium(textMid),
                  ),
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
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Row(
                          children: [
                            Container(width: 16, height: 1, color: AppColors.accent),
                            const SizedBox(width: 10),
                            Text(
                              'ZERTIFIKATE · ${certificates.length}',
                              style: AppTextStyles.monoLabel(AppColors.accentText),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        for (final cert in certificates)
                          _buildCertRow(cert, surface, border, text, textMid, textDim),
                      ],
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

  /// Eine Zeile je Zertifikat, gleicher Aufbau wie die Modulliste:
  /// Icon-Kachel in Anbieterfarbe, Anbieter als Kicker, Titel, Metazeile.
  Widget _buildCertRow(
    Map<String, dynamic> cert,
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    final anbieter = cert['anbieter'] ?? '';
    final fullName = _vendorFull(anbieter);
    final icon = _vendorIcon(anbieter);
    final accentColor = _vendorColor(anbieter);
    final anzahlFragen = cert['anzahl_fragen'] as int? ?? 0;
    final time = _estimatedTime(anzahlFragen);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border),
            boxShadow: AppColors.kartenSchatten,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: accentColor.withOpacity(0.3)),
                ),
                child: Icon(icon, color: accentColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName.toUpperCase(),
                      style: AppTextStyles.monoSmall(AppColors.ink(accentColor)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      cert['name'] ?? '',
                      style: AppTextStyles.h3(text),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$anzahlFragen Fragen · $time',
                      style: AppTextStyles.monoSmall(textDim),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios_rounded, color: textDim, size: 12),
            ],
          ),
        ),
      ),
    );
  }
}
