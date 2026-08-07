import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _soundsEnabled = true;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _soundsEnabled = prefs.getBool('sounds_enabled') ?? true;
  }

  Future<void> toggleSounds(bool enabled) async {
    _soundsEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sounds_enabled', enabled);
  }

  bool get soundsEnabled => _soundsEnabled;

  Future<void> playSound(SoundType type) async {
    if (!_soundsEnabled) return;

    // Eigene, lokal gebündelte Sounds (assets/sounds/) — funktionieren
    // offline und spielen ohne Netzwerk-Verzögerung ab.
    try {
      final String asset = switch (type) {
        SoundType.correct => 'sounds/correct.mp3',
        SoundType.wrong => 'sounds/wrong.mp3',
        SoundType.victory => 'sounds/victory.mp3',
        SoundType.defeat => 'sounds/defeat.mp3',
        SoundType.timeUp => 'sounds/timeup.mp3',
        SoundType.click => 'sounds/click.mp3',
      };

      await _player.play(AssetSource(asset), volume: 0.5);
    } catch (e) {
      print('🔇 Sound error: $e');
    }
  }

  void dispose() {
    _player.dispose();
  }
}

enum SoundType {
  correct, // ✅ Richtige Antwort
  wrong, // ❌ Falsche Antwort
  victory, // 🏆 Match/Prüfung gewonnen
  defeat, // 😢 Match/Prüfung verloren
  timeUp, // ⏰ Zeit abgelaufen
  click, // 🖱️ Button click
}
