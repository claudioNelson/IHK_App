// lib/widgets/dialogs/avatar_picker_sheet.dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../user_avatar.dart';

/// Bottom-Sheet zur Avatar-Auswahl (Emoji + Farbe).
/// Gibt die gespeicherte Kennung (`avatar://emoji/…`) zurueck oder null bei Abbruch.
Future<String?> showAvatarPickerSheet(
  BuildContext context, {
  required bool isDark,
  String? current,
}) {
  final bg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
  final surface = isDark ? AppColors.darkSurfaceElev : AppColors.lightBgMuted;
  final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
  final text = isDark ? AppColors.darkText : AppColors.lightText;
  final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
  final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

  final decoded = EmojiAvatar.decode(current);
  String emoji = decoded?.emoji ?? EmojiAvatar.emojis.first;
  int colorIdx = decoded == null
      ? 0
      : EmojiAvatar.colors.indexOf(decoded.color).clamp(0, EmojiAvatar.colors.length - 1);

  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: bg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setSheet) {
        final preview = EmojiAvatar.encode(emoji, colorIdx);
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(width: 16, height: 1, color: AppColors.accent),
                    const SizedBox(width: 10),
                    Text(
                      'AVATAR WÄHLEN',
                      style: AppTextStyles.monoLabel(AppColors.accent),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: UserAvatar(
                    avatarUrl: preview,
                    size: 88,
                    surface: surface,
                    border: border,
                    textColor: text,
                  ),
                ),
                const SizedBox(height: 18),
                Text('Farbe', style: AppTextStyles.labelSmall(textDim)),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(EmojiAvatar.colors.length, (i) {
                    final c = EmojiAvatar.colors[i];
                    final selected = i == colorIdx;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () => setSheet(() => colorIdx = i),
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: c.withOpacity(selected ? 1 : 0.35),
                            border: Border.all(
                              color: selected ? text : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: selected
                              ? const Icon(Icons.check, size: 16, color: Colors.white)
                              : null,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                Text('Symbol', style: AppTextStyles.labelSmall(textDim)),
                const SizedBox(height: 8),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: EmojiAvatar.emojis.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemBuilder: (_, i) {
                    final e = EmojiAvatar.emojis[i];
                    final selected = e == emoji;
                    return GestureDetector(
                      onTap: () => setSheet(() => emoji = e),
                      child: Container(
                        decoration: BoxDecoration(
                          color: selected
                              ? EmojiAvatar.colors[colorIdx].withOpacity(0.25)
                              : surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selected ? EmojiAvatar.colors[colorIdx] : border,
                            width: selected ? 1.5 : 1,
                          ),
                        ),
                        child: Center(
                          child: Text(e, style: const TextStyle(fontSize: 20, height: 1)),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: border),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Abbrechen', style: AppTextStyles.labelMedium(textMid)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(ctx).pop(preview),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: text,
                          foregroundColor: bg,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Speichern', style: AppTextStyles.labelLarge(bg)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
