import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_lingo/core/providers/family_provider.dart' as family;
import 'package:math_lingo/core/providers/weekly_stats_provider.dart';
import 'package:math_lingo/core/repositories/family_profile_repository.dart';
import 'package:math_lingo/core/sync/sync_service.dart';
import 'package:math_lingo/models/child_profile.dart';
import 'package:math_lingo/models/daily_stats.dart';
import 'package:math_lingo/models/family_profile.dart';

class _FakeSyncService extends SyncService {
  _FakeSyncService(
    super.ref, {
    required this.result,
  });

  final List<Map<String, dynamic>> result;

  @override
  Future<List<Map<String, dynamic>>> pullWeeklyStats(String childId) async {
    return result;
  }
}

class _TestFamilyNotifierImpl extends family.FamilyNotifier {
  _TestFamilyNotifierImpl(family.FamilyState initial) : super() {
    state = initial;
  }
}

class _FakeFamilyProfileRepository extends FamilyProfileRepository {
  _FakeFamilyProfileRepository(this.localResult);

  final List<DailyStats> localResult;

  @override
  Future<List<DailyStats>> getLocalWeeklyStats(String childId) async {
    return localResult;
  }
}

ChildProfile _child({String id = 'c1'}) {
  return ChildProfile(
    id: id,
    pseudonym: 'Ylli',
    avatarIndex: 0,
    totalPoints: 0,
    totalAccuracy: 0,
    completedSessions: 0,
    moduleHistory: const {},
  );
}

family.FamilyState _familyStateWithActiveChild(ChildProfile child) {
  final profile = FamilyProfile(
    id: 'f1',
    createdAt: DateTime(2026, 1, 1),
    children: [child],
  );
  return family.FamilyState(family: profile, activeChild: child);
}

List<Map<String, dynamic>> _cloudWeeklyRaw({int days = 7, bool reverse = false}) {
  final list = List.generate(days, (i) {
    final day = i + 1;
    final date = '2026-05-${day.toString().padLeft(2, '0')}';
    return {
      'date': date,
      'totalPoints': day * 10,
      'sessionsCount': day,
      'avgAccuracy': 0.5,
      'modules': <String, int>{'addition': day * 5},
    };
  });
  return reverse ? list.reversed.toList() : list;
}

List<DailyStats> _localWeeklyStats() => [
      const DailyStats(
        date: '2026-05-08',
        totalPoints: 20,
        sessionsCount: 2,
        avgAccuracy: 0.8,
        modules: {'addition': 20},
      ),
      const DailyStats(
        date: '2026-05-09',
        totalPoints: 10,
        sessionsCount: 1,
        avgAccuracy: 0.9,
        modules: {'addition': 10},
      ),
    ];

Future<WeeklyStatsState> _loadState(ProviderContainer container) async {
  final sub = container.listen(weeklyStatsProvider, (_, __) {});
  addTearDown(sub.close);
  await container.read(weeklyStatsProvider.notifier).load();
  return container.read(weeklyStatsProvider);
}

void main() {
  group('weeklyStatsProvider', () {
    test('kur cloud aktiv kthen 7 dite nga Firestore', () async {
      final child = _child();
      final container = ProviderContainer(
        overrides: [
          family.familyProvider.overrideWith(
            (ref) => _TestFamilyNotifierImpl(_familyStateWithActiveChild(child)),
          ),
          syncServiceProvider.overrideWith(
            (ref) => _FakeSyncService(ref, result: _cloudWeeklyRaw(days: 7)),
          ),
          familyProfileRepositoryProvider.overrideWith(
            (ref) => _FakeFamilyProfileRepository(const []),
          ),
        ],
      );
      addTearDown(container.dispose);

      final state = await _loadState(container);
      expect(state, isA<WeeklyStatsLoaded>());
      final stats = (state as WeeklyStatsLoaded).stats;
      expect(stats.length, 7);
      expect(stats.first.date, '2026-05-01');
      expect(stats.last.date, '2026-05-07');
    });

    test('kur cloud bosh kthen fallback nga Hive', () async {
      final child = _child();
      final local = _localWeeklyStats();
      final container = ProviderContainer(
        overrides: [
          family.familyProvider.overrideWith(
            (ref) => _TestFamilyNotifierImpl(_familyStateWithActiveChild(child)),
          ),
          syncServiceProvider.overrideWith(
            (ref) => _FakeSyncService(ref, result: const []),
          ),
          familyProfileRepositoryProvider.overrideWith(
            (ref) => _FakeFamilyProfileRepository(local),
          ),
        ],
      );
      addTearDown(container.dispose);

      final state = await _loadState(container);
      expect(state, isA<WeeklyStatsLoaded>());
      final stats = (state as WeeklyStatsLoaded).stats;
      expect(stats.length, local.length);
      expect(stats.first.date, '2026-05-08');
      expect(stats.last.date, '2026-05-09');
    });

    test('kur asnje burim ska te dhena kthen WeeklyStatsLoaded bosh', () async {
      final child = _child();
      final container = ProviderContainer(
        overrides: [
          family.familyProvider.overrideWith(
            (ref) => _TestFamilyNotifierImpl(_familyStateWithActiveChild(child)),
          ),
          syncServiceProvider.overrideWith(
            (ref) => _FakeSyncService(ref, result: const []),
          ),
          familyProfileRepositoryProvider.overrideWith(
            (ref) => _FakeFamilyProfileRepository(const []),
          ),
        ],
      );
      addTearDown(container.dispose);

      final state = await _loadState(container);
      expect(state, isA<WeeklyStatsLoaded>());
      expect((state as WeeklyStatsLoaded).stats, isEmpty);
    });

    test('renditja kronologjike respektohet gjithmone', () async {
      final child = _child();
      final container = ProviderContainer(
        overrides: [
          family.familyProvider.overrideWith(
            (ref) => _TestFamilyNotifierImpl(_familyStateWithActiveChild(child)),
          ),
          syncServiceProvider.overrideWith(
            (ref) => _FakeSyncService(ref, result: _cloudWeeklyRaw(days: 4, reverse: true)),
          ),
          familyProfileRepositoryProvider.overrideWith(
            (ref) => _FakeFamilyProfileRepository(const []),
          ),
        ],
      );
      addTearDown(container.dispose);

      final state = await _loadState(container);
      final stats = (state as WeeklyStatsLoaded).stats;
      expect(stats.map((e) => e.date).toList(), [
        '2026-05-01',
        '2026-05-02',
        '2026-05-03',
        '2026-05-04',
      ]);
    });

    test('femija aktiv i gabuar kthen bosh pa exception', () async {
      final stateNoChild = const family.FamilyState(
        family: null,
        activeChild: null,
      );
      final container = ProviderContainer(
        overrides: [
          family.familyProvider.overrideWith(
            (ref) => _TestFamilyNotifierImpl(stateNoChild),
          ),
          syncServiceProvider.overrideWith(
            (ref) => _FakeSyncService(ref, result: _cloudWeeklyRaw(days: 3)),
          ),
          familyProfileRepositoryProvider.overrideWith(
            (ref) => _FakeFamilyProfileRepository(_localWeeklyStats()),
          ),
        ],
      );
      addTearDown(container.dispose);

      final state = await _loadState(container);
      expect(state, isA<WeeklyStatsLoaded>());
      expect((state as WeeklyStatsLoaded).stats, isEmpty);
    });
  });
}
