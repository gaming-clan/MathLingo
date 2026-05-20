import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_lingo/core/services/hive_consent_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('mathlingo_consent_test_');
    await HiveConsentRepository.resetForTests(testPath: tempDir.path);
  });

  tearDown(() async {
    await HiveConsentRepository.closeForTests();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('grant ruan consent ne Hive', () async {
    await HiveConsentRepository.saveConsent(
      ConsentRecord(
        grantedAt: DateTime(2026, 5, 20),
        version: ConsentVersion.current,
      ),
    );

    expect(await HiveConsentRepository.hasValidConsent(), isTrue);
    final record = await HiveConsentRepository.loadConsent();
    expect(record, isNotNull);
    expect(record?.version, ConsentVersion.current);
  });

  test('refuse nuk ruan consent', () async {
    final record = await HiveConsentRepository.loadConsent();

    expect(record, isNull);
    expect(await HiveConsentRepository.hasValidConsent(), isFalse);
  });

  test('revoke e heq consent-in e ruajtur', () async {
    await HiveConsentRepository.saveConsent(
      ConsentRecord(
        grantedAt: DateTime(2026, 5, 20),
        version: ConsentVersion.current,
      ),
    );

    expect(await HiveConsentRepository.hasValidConsent(), isTrue);

    await HiveConsentRepository.revokeConsent();

    expect(await HiveConsentRepository.hasValidConsent(), isFalse);
    expect(HiveConsentRepository.hasValidConsentSync, isFalse);
  });
}