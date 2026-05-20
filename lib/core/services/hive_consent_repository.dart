import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ConsentRecord {
  const ConsentRecord({
    required this.grantedAt,
    required this.version,
    this.uid,
  });

  final DateTime grantedAt;
  final String version;
  final String? uid;

  Map<String, dynamic> toMap() => {
        'grantedAt': grantedAt.toIso8601String(),
        'version': version,
        'uid': uid,
      };

  factory ConsentRecord.fromMap(Map<dynamic, dynamic> map) => ConsentRecord(
        grantedAt: DateTime.parse(map['grantedAt'] as String),
        version: map['version'] as String,
        uid: map['uid'] as String?,
      );
}

abstract final class ConsentVersion {
  static const current = '1.0';
}

abstract final class HiveConsentRepository {
  static const String _boxName = 'privacy_consent';
  static const String _consentKey = 'record';

  static Future<void>? _initFuture;

  static Future<void> init() {
    _initFuture ??= _initInternal();
    return _initFuture!;
  }

  static Future<void> _initInternal() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<dynamic>(_boxName);
    }
  }

  static Box<dynamic> get _box {
    if (!Hive.isBoxOpen(_boxName)) {
      throw StateError(
        'HiveConsentRepository: box "$_boxName" nuk është hapur. '
        'Thirr HiveConsentRepository.init() në main().',
      );
    }
    return Hive.box<dynamic>(_boxName);
  }

  static bool get hasValidConsentSync {
    if (!Hive.isBoxOpen(_boxName)) return false;
    return _box.get(_consentKey) != null;
  }

  static Future<bool> hasValidConsent() async {
    await init();
    return _box.get(_consentKey) != null;
  }

  static Future<ConsentRecord?> loadConsent() async {
    await init();
    final raw = _box.get(_consentKey);
    if (raw == null) return null;
    return ConsentRecord.fromMap(raw as Map<dynamic, dynamic>);
  }

  static Future<void> saveConsent(ConsentRecord record) async {
    await init();
    await _box.put(_consentKey, record.toMap());
  }

  static Future<void> revokeConsent() async {
    await init();
    await _box.delete(_consentKey);
  }

  @visibleForTesting
  static Future<void> resetForTests({String? testPath}) async {
    if (Hive.isBoxOpen(_boxName)) {
      await Hive.box<dynamic>(_boxName).close();
    }
    if (testPath != null) {
      Hive.init(testPath);
    }
    _initFuture = null;
    await init();
    await _box.clear();
  }

  @visibleForTesting
  static Future<void> closeForTests() async {
    if (Hive.isBoxOpen(_boxName)) {
      await Hive.box<dynamic>(_boxName).close();
    }
    _initFuture = null;
  }
}