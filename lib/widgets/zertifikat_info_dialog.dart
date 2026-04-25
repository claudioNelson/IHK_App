import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/theme_provider.dart';

Future<bool?> showZertifikatInfoDialog(
  BuildContext context,
  Map<String, dynamic> cert,
) {
  return showDialog<bool>(
    context: context,
    builder: (context) => _ZertifikatInfoDialogContent(cert: cert),
  );
}

class _ZertifikatInfoDialogContent extends StatelessWidget {
  final Map<String, dynamic> cert;

  const _ZertifikatInfoDialogContent({required this.cert});

  // Vendor Akzentfarbe (subtil)
  Color _vendorColor(String anbieter) {
    if (anbieter.contains('AWS') || anbieter.contains('Amazon'))
      return AppColors.warning;
    if (anbieter.contains('Microsoft') || anbieter.contains('Azure'))
      return AppColors.accentCyan;
    if (anbieter.contains('Google')) return AppColors.accent;
    if (anbieter.contains('SAP')) return AppColors.accentCyan;
    return AppColors.accent;
  }

  String _vendorLabel(String anbieter) {
    if (anbieter.contains('AWS') || anbieter.contains('Amazon')) return 'AWS';
    if (anbieter.contains('Microsoft') || anbieter.contains('Azure'))
      return 'AZURE';
    if (anbieter.contains('Google')) return 'GCP';
    if (anbieter.contains('SAP')) return 'SAP';
    return anbieter.toUpperCase();
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

    final anbieter = cert['anbieter'] as String? ?? '';
    final accentColor = _vendorColor(anbieter);
    final vendorLabel = _vendorLabel(anbieter);

    return Dialog(
      backgroundColor: surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── HEADER ──────────────────────
                Row(
                  children: [
                    Container(width: 16, height: 1, color: accentColor),
                    const SizedBox(width: 10),
                    Text(
                      'PRÜFUNG · $vendorLabel',
                      style: AppTextStyles.monoLabel(accentColor),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Cert Name in Serif
                Text(
                  cert['name'] ?? '',
                  style: AppTextStyles.instrumentSerif(
                    size: 28,
                    color: text,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  anbieter.toUpperCase(),
                  style: AppTextStyles.monoSmall(textMid),
                ),

                const SizedBox(height: 24),

                // ─── PRÜFUNGSDETAILS ─────────────
                _buildSection('PRÜFUNGSDETAILS', accentColor, textMid),
                const SizedBox(height: 10),
                _buildStatRow(
                  Icons.help_outline_rounded,
                  'Fragen',
                  '${cert['anzahl_fragen']}',
                  surface,
                  border,
                  text,
                  textMid,
                  textDim,
                ),
                const SizedBox(height: 8),
                _buildStatRow(
                  Icons.timer_outlined,
                  'Prüfungsdauer',
                  '${cert['pruefungsdauer']} Min',
                  surface,
                  border,
                  text,
                  textMid,
                  textDim,
                ),
                const SizedBox(height: 8),
                _buildStatRow(
                  Icons.flag_outlined,
                  'Bestehensgrenze',
                  '${cert['mindest_punktzahl']}%',
                  surface,
                  border,
                  text,
                  textMid,
                  textDim,
                ),

                const SizedBox(height: 22),

                // ─── HINWEISE ────────────────────
                _buildSection('HINWEISE', AppColors.warning, textMid),
                const SizedBox(height: 10),
                _buildBulletList([
                  'Multiple-Choice Fragen',
                  'Timer läuft während der Prüfung',
                  'Fortschritt wird automatisch gespeichert',
                  'Fragen sind nachträglich änderbar',
                ], textMid),

                const SizedBox(height: 22),

                // ─── TIPPS ───────────────────────
                _buildSection('TIPPS', AppColors.success, textMid),
                const SizedBox(height: 10),
                _buildBulletList([
                  'Lies jede Frage sorgfältig',
                  'Behalte die Zeit im Auge',
                  'Bei Unsicherheit: später prüfen',
                  'Keine Hilfsmittel für echtes Training',
                ], textMid),

                const SizedBox(height: 28),

                // ─── ACTIONS ─────────────────────
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: border),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Abbrechen',
                            style: AppTextStyles.mono(
                              size: 11,
                              color: textMid,
                              weight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context, true),
                          icon: const Icon(Icons.play_arrow_rounded, size: 18),
                          label: const Text('Prüfung starten'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: text,
                            foregroundColor: bg,
                            elevation: 0,
                            textStyle: AppTextStyles.labelLarge(bg),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String label, Color color, Color textMid) {
    return Row(
      children: [
        Container(width: 12, height: 1, color: color),
        const SizedBox(width: 8),
        Text(label, style: AppTextStyles.monoLabel(color)),
      ],
    );
  }

  Widget _buildStatRow(
    IconData icon,
    String label,
    String value,
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: textMid),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label, style: AppTextStyles.bodyMedium(textMid)),
          ),
          Text(
            value,
            style: AppTextStyles.mono(
              size: 13,
              color: text,
              weight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletList(List<String> items, Color textMid) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: textMid,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(item, style: AppTextStyles.bodyMedium(textMid)),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
