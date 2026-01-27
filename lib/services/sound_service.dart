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

    try {
      String url;
      switch (type) {
        case SoundType.correct:
          // Positive chime - DER IST GUT!
          url = 'https://cdn.freesound.org/previews/320/320655_5260872-lq.mp3';
          break;
        case SoundType.wrong:
          // Andere URL probieren
          url = 'https://cdn.freesound.org/previews/249/249300_4404552-lq.mp3';
          break;
        case SoundType.victory:
          // Victory fanfare
          url = 'https://cdn.freesound.org/previews/270/270404_5123851-lq.mp3';
          break;
        case SoundType.defeat:
          // Sad trombone
          url = 'https://cdn.freesound.org/previews/331/331912_3248244-lq.mp3';
          break;
        case SoundType.timeUp:
          url = 'https://cdn.freesound.org/previews/249/249300_4404552-lq.mp3';
          break;
        case SoundType.click:
          // Kurzer Pop/Click - ähnliches Format wie die anderen
          url = 'https://cdn.freesound.org/previews/512/512216_10393057-lq.mp3';
          break;
      }

      await _player.play(UrlSource(url), volume: 0.5);
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
