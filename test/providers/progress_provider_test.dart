// D1: Unit tests për ProgressNotifier
// Testojmë addSession dhe state transitions me Hive izoluar.

import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:math_lingo/core/providers/progress_provider.dart';
import 'package:math_lingo/models/user_progress.dart';
import 'package:math_lingo/shared/utils/user_progress_storage.dart';

/// Rrugë e përkohshme për Hive (izolim per-test).
Future<String> _tempHivePath(String name) async {
  final dir = await Directory.systemTemp.createTemp('hive_test_$name');
  return dir.path;
}

/// Aspeton derisa progressProvider kalon nga Loading.
Future<void> _waitForLoad(ProviderContainer container) async {
  // Provider e nisur me AsyncLoading; _load() është Future → pump microtasks.
  for (var i = 0; i < 100; i++) {
    await Future<void>.delayed(Duration.zero);
    if (container.read(progressProvider) is! AsyncLoading) return;
  }
  throw StateError('progressProvider nuk u azhurnua brenda kohe');
}


/// Mbyll Hive kur container shkatërrohet.
Future<({ProviderContainer container, String hivePath})> _buildContainer(
  String testName,
) async {
  final hivePath = await _tempHivePath(testName);
  // resetForTests shlyen _initializeFuture dhe hap box me rrugë të re
  await UserProgressStorage.resetForTests(testPath: hivePath);

  final container = ProviderContainer();
  return (container: container, hivePath: hivePath);
}

Future<void> _teardown(ProviderContainer container, String hivePath) async {
  container.dispose();
  // Mbyll box-in (resetForTests do ta rihapë per test tjetër me rrugë të re)
  if (Hive.isBoxOpen('user_progress')) {
    await Hive.box<dynamic>('user_progress').close();
  }
}

void main() {
  group('ProgressNotifier — state transitions', () {
    test('fillon me AsyncLoading', () async {
      final (:container, :hivePath) = await _buildContainer('start');
      addTearDown(() => _teardown(container, hivePath));

      final state = container.read(progressProvider);
      expect(state, const AsyncValue<UserProgress>.loading());
    });

    test('kalon në AsyncData pas load', () async {
      final (:container, :hivePath) = await _buildContainer('load');
      addTearDown(() => _teardown(container, hivePath));

      // Pres që provider të kryejë IO
      await _waitForLoad(container);

      final state = container.read(progressProvider);
      expect(state, isA<AsyncData<UserProgress>>());
      final data = state.asData!.value;
      expect(data.totalPoints, 0);
      expect(data.averageAccuracy, 0.0);
    });
  });

  group('ProgressNotifier.addSession()', () {
    test('shton pikë dhe azhurnon state', () async {
      final (:container, :hivePath) = await _buildContainer('add_points');
      addTearDown(() => _teardown(container, hivePath));

      await _waitForLoad(container);

      final notifier = container.read(progressProvider.notifier);
      await notifier.addSession(points: 30, accuracy: 90);

      final state = container.read(progressProvider);
      expect(state, isA<AsyncData<UserProgress>>());
      final data = state.asData!.value;
      expect(data.totalPoints, 30);
    });

    test('llogarit mesatare saktë pas dy sesioneve', () async {
      final (:container, :hivePath) = await _buildContainer('avg');
      addTearDown(() => _teardown(container, hivePath));

      await _waitForLoad(container);

      final notifier = container.read(progressProvider.notifier);
      await notifier.addSession(points: 10, accuracy: 80);
      await notifier.addSession(points: 20, accuracy: 60);

      final data = container.read(progressProvider).asData!.value;
      expect(data.totalPoints, 30);
      // Mesatare: (80*1 + 60) / 2 = 70
      expect(data.averageAccuracy, closeTo(70.0, 0.001));
    });

    test('state bëhet AsyncData (jo Loading) pas addSession', () async {
      final (:container, :hivePath) = await _buildContainer('noloading');
      addTearDown(() => _teardown(container, hivePath));

      await _waitForLoad(container);
      final notifier = container.read(progressProvider.notifier);
      await notifier.addSession(points: 10, accuracy: 50);

      final state = container.read(progressProvider);
      expect(state, isA<AsyncData<UserProgress>>());
    });
  });

  group('UserProgress helpers', () {
    test('totalPointsProgress clamp [0,1]', () {
      const p = UserProgress(totalPoints: 200, averageAccuracy: 90);
      expect(p.totalPointsProgress(), 1.0);
    });

    test('totalPointsProgress normal range', () {
      const p = UserProgress(totalPoints: 50, averageAccuracy: 0);
      expect(p.totalPointsProgress(), closeTo(0.5, 0.001));
    });

    test('accuracyProgress clamp [0,1]', () {
      const p = UserProgress(totalPoints: 0, averageAccuracy: 100);
      expect(p.accuracyProgress(), 1.0);
    });

    test('accuracyProgress 0 kur empty', () {
      const p = UserProgress.empty();
      expect(p.accuracyProgress(), 0.0);
    });
  });
}
