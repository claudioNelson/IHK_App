// lib/widgets/dialogs/match_status_dialog.dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../user_avatar.dart';

/// Zwischenstand im Arena-Wartebildschirm ("Status pruefen"):
/// links ich mit "X / N richtig", rechts der Gegner (oder Platzhalter).
/// `status` ist das Ergebnis von AsyncDuelService.loadWaitingStatus().
Future<void> showMatchStatusDialog(
  BuildContext context, {
  required Map<String, dynamic> status,
  required bool isDark,
}) {
  final bg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
  final surface = isDark ? AppColors.darkSurfaceElev : AppColors.lightBgMuted;
  final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
  final text = isDark ? AppColors.darkText : AppColors.lightText;
  final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
  final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

  final total = status['total'] as int? ?? 10;
  final myCorrect = status['my_correct'] as int? ?? 0;
  final myAnswered = status['my_answered'] as int? ?? 0;
  final hasOpponent = status['has_opponent'] == true;
  final oppCorrect = status['opponent_correct'] as int? ?? 0;
  final oppAnswered = status['opponent_answered'] as int? ?? 0;
  final oppDone = oppAnswered >= total;
  final me = status['my_profile'] as Map<String, dynamic>?;
  final opp = status['opponent_profile'] as Map<String, dynamic>?;

  final myName = (me?['username'] as String?)?.trim();
  final oppName = (opp?['username'] as String?)?.trim();

  return showDialog<void>(
    context: context,
    builder: (ctx) => Dialog(
      backgroundColor: bg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: border),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(width: 16, height: 1, color: AppColors.warning),
                const SizedBox(width: 10),
                Text(
                  'ZWISCHENSTAND',
                  style: AppTextStyles.monoLabel(AppColors.warning),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _PlayerColumn(
                    avatar: UserAvatar(
                      avatarUrl: me?['avatar_url'] as String?,
                      username: myName,
                      size: 64,
                      surface: surface,
                      border: border,
                      textColor: text,
                    ),
                    label: 'DU',
                    name: (myName == null || myName.isEmpty) ? 'Du' : myName,
                    value: '$myCorrect / $total',
                    caption: 'richtig',
                    progress: myAnswered < total
                        ? '$myAnswered von $total gespielt'
                        : null,
                    valueColor: AppColors.success,
                    text: text,
                    textMid: textMid,
                    textDim: textDim,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    'VS',
                    style: AppTextStyles.mono(
                      size: 11,
                      color: textDim,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: _PlayerColumn(
                    avatar: UserAvatar(
                      avatarUrl: opp?['avatar_url'] as String?,
                      username: oppName,
                      size: 64,
                      surface: surface,
                      border: border,
                      textColor: text,
                      placeholder: !hasOpponent,
                    ),
                    label: 'GEGNER',
                    name: hasOpponent
                        ? ((oppName == null || oppName.isEmpty)
                            ? 'Gegner'
                            : oppName)
                        : 'Noch niemand',
                    value: hasOpponent ? '$oppCorrect / $total' : '—',
                    caption: hasOpponent ? 'richtig' : 'wartet auf Gegner',
                    progress: hasOpponent && !oppDone
                        ? '$oppAnswered von $total gespielt'
                        : null,
                    valueColor: hasOpponent
                        ? (oppDone ? AppColors.success : AppColors.warning)
                        : textDim,
                    text: text,
                    textMid: textMid,
                    textDim: textDim,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              !hasOpponent
                  ? 'Sobald jemand dein Duell annimmt und spielt, siehst du hier das Ergebnis.'
                  : oppDone
                      ? 'Beide sind fertig – das Match wird in Kürze ausgewertet.'
                      : 'Das Ergebnis wird gewertet, sobald dein Gegner alle Fragen beantwortet hat.',
              style: AppTextStyles.bodySmall(textMid),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(
                  'Schließen',
                  style: AppTextStyles.labelMedium(text),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _PlayerColumn extends StatelessWidget {
  final Widget avatar;
  final String label;
  final String name;
  final String value;
  final String caption;
  /// Kleine Zusatzzeile, z. B. "7 von 10 gespielt" (null = fertig).
  final String? progress;
  final Color valueColor;
  final Color text;
  final Color textMid;
  final Color textDim;

  const _PlayerColumn({
    required this.avatar,
    required this.label,
    required this.name,
    required this.value,
    required this.caption,
    this.progress,
    required this.valueColor,
    required this.text,
    required this.textMid,
    required this.textDim,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        avatar,
        const SizedBox(height: 10),
        Text(label, style: AppTextStyles.monoSmall(textDim)),
        const SizedBox(height: 2),
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppTextStyles.labelMedium(text),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.interTight(
            size: 24,
            weight: FontWeight.w600,
            color: valueColor,
            letterSpacing: -0.5,
          ),
        ),
        Text(caption, style: AppTextStyles.bodySmall(textMid)),
        // Platz immer reservieren, damit beide Spalten gleich hoch bleiben
        const SizedBox(height: 4),
        Text(
          progress ?? '',
          style: AppTextStyles.monoSmall(progress == null ? Colors.transparent : textDim),
        ),
      ],
    );
  }
}
