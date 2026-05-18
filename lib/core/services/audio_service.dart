import 'package:audioplayers/audioplayers.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Shërbimi i audios — C-02.
///
/// Tingujt SFX janë të vendosur në `assets/audio/`.
/// Nëse fajllat mungojnë, shërbimi dështon me heshtje (graceful failure).
///
/// Toggle on/off persist me Hive (box 'app_settings').
abstract final class AudioService {
  static const String _boxName = 'app_settings';
  static const String _audioKey = 'audio_enabled';

  static bool _enabled = true;

  static Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<dynamic>(_boxName);
    }
    _enabled = (Hive.box<dynamic>(_boxName).get(_audioKey) as bool?) ?? true;
  }

  static bool get isEnabled => _enabled;

  static Future<void> setEnabled(bool value) async {
    _enabled = value;
    if (Hive.isBoxOpen(_boxName)) {
      await Hive.box<dynamic>(_boxName).put(_audioKey, value);
    }
  }

  static Future<void> playCorrect() => _play('correct.ogg');
  static Future<void> playWrong() => _play('wrong.ogg');
  static Future<void> playLevelUp() => _play('levelup.ogg');
  static Future<void> playBadge() => _play('badge.ogg');

  static Future<void> _play(String filename) async {
    if (!_enabled) return;
    try {
      final player = AudioPlayer();
      await player.play(AssetSource('audio/$filename'));
      player.onPlayerComplete.first.then((_) => player.dispose());
    } catch (_) {
      // Fajllat audio mungojnë ose nuk mund të luhen — dështim i heshtur
    }
  }
}
