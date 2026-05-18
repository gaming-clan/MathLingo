import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';

/// Menaxhon inicializimin e Firebase pas consent-it prindëror.
///
/// Firebase **nuk inicializohet automatikisht** në `main()`.
/// Thirret VETËM kur prindi nis rrjedhën e regjistrimit/hyrjes nga SettingsScreen.
abstract final class FirebaseInitService {
  static bool _initialized = false;

  static bool get isInitialized => _initialized;

  /// Inicializon Firebase. I sigurt për thirrje të shumëfishta.
  static Future<bool> initialize() async {
    if (_initialized) return true;

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _initialized = true;
      debugPrint('[Firebase] Inicializuar me sukses pas consent-it.');
      return true;
    } catch (e) {
      debugPrint('[Firebase] Gabim inicializimi: $e');
      return false;
    }
  }

  /// Rinicio gjendjen (për fshirje llogarie ose logout).
  static void reset() {
    _initialized = false;
  }
}
