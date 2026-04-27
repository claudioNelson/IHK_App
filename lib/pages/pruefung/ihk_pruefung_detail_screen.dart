import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/ihk_exam_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';
import 'ihk_pruefung_exam_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/subscription_service.dart';
import '../../widgets/premium_lock.dart';

class IHKPruefungDetailScreen extends StatelessWidget {
  final IHKExam exam;

  const IHKPruefungDetailScreen({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;

    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

    // ─── PAYWALL ─────────────────────────────
    if (!SubscriptionService().isPremium) {
      return PremiumLock(
        featureName: 'IHK-Prüfungen',
        description:
            'Mit Premium hast du Zugriff auf alle IHK-Prüfungen aus Frühjahr und Herbst.',
        icon: Icons.assignment_outlined,
        onUpgrade: () {
          // TODO: Stripe Checkout starten
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Stripe-Checkout kommt bald!')),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: [
          // ─── APPBAR ─────────────────────────
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
                    'Prüfungsinfo',
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

          // ─── CONTENT ────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                // Exam Header
                _buildHeader(surface, border, text, textMid, textDim),

                const SizedBox(height: 12),

                // Prüfungsinfos
                _buildInfoCard(surface, border, text, textMid, textDim),

                const SizedBox(height: 12),

                // Web-Empfehlung
                _buildWebCard(surface, border, text, textMid),

                const SizedBox(height: 12),

                // Hinweise
                _buildHinweiseCard(surface, border, text, textMid),

                const SizedBox(height: 12),

                // Szenario
                _buildSzenarioCard(surface, border, text, textMid),

                const SizedBox(height: 8),
              ],
            ),
          ),

          // ─── BOTTOM BAR ──────────────────────
          Container(
            decoration: BoxDecoration(
              color: surface,
              border: Border(top: BorderSide(color: border)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => IHKPruefungExamScreen(exam: exam),
                      ),
                    ),
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
            ),
          ),
        ],
      ),
    );
  }

  // ─── HEADER ───────────────────────────────
  Widget _buildHeader(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
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
                'IHK-PRÜFUNG',
                style: AppTextStyles.monoLabel(AppColors.accent),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            exam.title,
            style: AppTextStyles.instrumentSerif(
              size: 28,
              color: text,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${exam.company} · ${exam.season} ${exam.year}',
            style: AppTextStyles.bodyMedium(textMid),
          ),
        ],
      ),
    );
  }

  // ─── INFO CARD ────────────────────────────
  Widget _buildInfoCard(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 16, height: 1, color: AppColors.accent),
              const SizedBox(width: 10),
              Text(
                'PRÜFUNGSINFOS',
                style: AppTextStyles.monoLabel(AppColors.accent),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _statItem(
                  '${exam.duration}',
                  'MIN',
                  'DAUER',
                  text,
                  textDim,
                ),
              ),
              Container(width: 1, height: 40, color: border),
              Expanded(
                child: _statItem(
                  '${exam.totalPoints}',
                  'PT',
                  'PUNKTE',
                  text,
                  textDim,
                ),
              ),
              Container(width: 1, height: 40, color: border),
              Expanded(
                child: _statItem(
                  '${exam.sections.length}',
                  'von 5',
                  'AUFGABEN',
                  text,
                  textDim,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(
    String value,
    String unit,
    String label,
    Color text,
    Color textDim,
  ) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: AppTextStyles.instrumentSerif(
                  size: 26,
                  color: text,
                  letterSpacing: -0.5,
                ),
              ),
              TextSpan(text: ' $unit', style: AppTextStyles.bodySmall(textDim)),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.monoSmall(textDim)),
      ],
    );
  }

  // ─── WEB CARD ────────────────────────────
  Widget _buildWebCard(Color surface, Color border, Color text, Color textMid) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accentCyan.withOpacity(0.3)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.015, 0.015, 1.0],
          colors: [
            AppColors.accentCyan,
            AppColors.accentCyan,
            surface,
            surface,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 16, height: 1, color: AppColors.accentCyan),
              const SizedBox(width: 10),
              Text(
                'EMPFEHLUNG',
                style: AppTextStyles.monoLabel(AppColors.accentCyan),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Besseres Erlebnis am Desktop.', style: AppTextStyles.h3(text)),
          const SizedBox(height: 8),
          Text(
            'Für ein authentisches Prüfungserlebnis empfehlen wir die Web-App am Desktop:',
            style: AppTextStyles.bodySmall(textMid),
          ),
          const SizedBox(height: 10),
          _bulletItem('Größerer Bildschirm für Diagramme', textMid),
          _bulletItem('Bessere Übersicht bei langen Texten', textMid),
          _bulletItem('Einfacheres Zeichnen von UML/ER-Diagrammen', textMid),
          const SizedBox(height: 12),

          // ← NEU: Link Button
          GestureDetector(
            onTap: () async {
              final uri = Uri.parse('https://lernarena.app');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.accentCyan.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.accentCyan.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.open_in_new_rounded,
                    color: AppColors.accentCyan,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'lernarena.app öffnen',
                    style: AppTextStyles.mono(
                      size: 12,
                      color: AppColors.accentCyan,
                      weight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.success.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.phone_android_rounded,
                  size: 16,
                  color: AppColors.success,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Smartphone: Lade Fotos deiner Antworten hoch — unser KI-Tutor prüft sie!',
                    style: AppTextStyles.bodySmall(AppColors.success),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── HINWEISE CARD ───────────────────────
  Widget _buildHinweiseCard(
    Color surface,
    Color border,
    Color text,
    Color textMid,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.015, 0.015, 1.0],
          colors: [AppColors.warning, AppColors.warning, surface, surface],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 16, height: 1, color: AppColors.warning),
              const SizedBox(width: 10),
              Text(
                'WICHTIGE HINWEISE',
                style: AppTextStyles.monoLabel(AppColors.warning),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _bulletItem(
            'Keine Hilfsmittel — bearbeite ohne Google oder andere Hilfen',
            textMid,
          ),
          _bulletItem('Echte Prüfungsbedingungen — der Timer läuft', textMid),
          _bulletItem('Antworten werden automatisch gespeichert', textMid),
          _bulletItem(
            'Foto-Upload: Fotografiere Diagramme und lade sie hoch',
            textMid,
          ),
        ],
      ),
    );
  }

  // ─── SZENARIO CARD ───────────────────────
  Widget _buildSzenarioCard(
    Color surface,
    Color border,
    Color text,
    Color textMid,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 16, height: 1, color: AppColors.accent),
              const SizedBox(width: 10),
              Text(
                'SZENARIO',
                style: AppTextStyles.monoLabel(AppColors.accent),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(exam.scenario, style: AppTextStyles.bodyMedium(textMid)),
        ],
      ),
    );
  }

  // ─── BULLET ITEM ─────────────────────────
  Widget _bulletItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 4,
            height: 4,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: AppTextStyles.bodySmall(color))),
        ],
      ),
    );
  }
}
