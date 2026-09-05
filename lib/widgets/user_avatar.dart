// lib/widgets/user_avatar.dart
import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

/// Emoji-Avatare: werden in `profiles.avatar_url` als Kennung gespeichert,
/// z. B. `avatar://emoji/🦊/2` (Emoji + Index der Hintergrundfarbe).
/// Echte Bild-URLs (http...) bleiben weiterhin moeglich.
class EmojiAvatar {
  EmojiAvatar._();

  static const String prefix = 'avatar://emoji/';

  /// Auswahl im Picker (Tiere, Technik, Lernen).
  static const List<String> emojis = [
    '🦊', '🐼', '🦉', '🐧', '🦁', '🐸', '🐙', '🦄',
    '🤖', '👾', '🚀', '🛸', '💻', '🧠', '⚡', '🔥',
    '🎯', '🏆', '📚', '🧩', '🎧', '🕹️', '🛰️', '🌙',
  ];

  /// Hintergrundfarben (Index wird gespeichert).
  static const List<Color> colors = [
    Color(0xFF7C6DFF), // Indigo (Akzent)
    Color(0xFF22D3EE), // Cyan
    Color(0xFF10B981), // Gruen
    Color(0xFFF59E0B), // Orange
    Color(0xFFEF4444), // Rot
    Color(0xFFEC4899), // Pink
  ];

  static String encode(String emoji, int colorIndex) =>
      '$prefix$emoji/${colorIndex.clamp(0, colors.length - 1)}';

  /// Liefert (emoji, farbe) oder null, wenn `value` kein Emoji-Avatar ist.
  static ({String emoji, Color color})? decode(String? value) {
    if (value == null || !value.startsWith(prefix)) return null;
    final rest = value.substring(prefix.length);
    final slash = rest.lastIndexOf('/');
    if (slash <= 0) return null;
    final emoji = rest.substring(0, slash);
    final idx = int.tryParse(rest.substring(slash + 1)) ?? 0;
    if (emoji.isEmpty) return null;
    return (emoji: emoji, color: colors[idx.clamp(0, colors.length - 1)]);
  }
}

/// Rundes Profilbild: Emoji-Avatar, sonst Bild aus `avatarUrl`, sonst die
/// Initiale von `username`, sonst ein Fragezeichen (z. B. solange noch kein
/// Gegner da ist).
class UserAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String? username;
  final double size;
  final Color surface;
  final Color border;
  final Color textColor;
  final bool placeholder;

  const UserAvatar({
    super.key,
    this.avatarUrl,
    this.username,
    this.size = 64,
    required this.surface,
    required this.border,
    required this.textColor,
    this.placeholder = false,
  });

  @override
  Widget build(BuildContext context) {
    final emoji = placeholder ? null : EmojiAvatar.decode(avatarUrl);
    final hasImage = !placeholder &&
        emoji == null &&
        avatarUrl != null &&
        avatarUrl!.trim().startsWith('http');
    final name = (username ?? '').trim();
    final initial = placeholder || name.isEmpty ? '?' : name[0].toUpperCase();

    if (emoji != null) {
      return Container(
        width: size,
        height: size,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: emoji.color.withOpacity(0.22),
          border: Border.all(color: emoji.color.withOpacity(0.75), width: 1.5),
        ),
        child: Center(
          child: Text(
            emoji.emoji,
            // Noto Color Emoji rendert ~1.17x der fontSize -> 0.44 statt 0.5
            style: TextStyle(fontSize: size * 0.44, height: 1),
          ),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: surface,
        border: Border.all(color: border, width: 1.5),
        image: hasImage
            ? DecorationImage(
                image: NetworkImage(avatarUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: hasImage
          ? null
          : Center(
              child: Text(
                initial,
                style: AppTextStyles.interTight(
                  size: size * 0.4,
                  weight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
    );
  }
}
