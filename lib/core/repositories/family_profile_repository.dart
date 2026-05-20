import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/daily_stats.dart';
import '../../models/user_progress.dart';
import '../../shared/utils/user_progress_storage.dart';

class FamilyProfileRepository {
  const FamilyProfileRepository();

  Future<List<DailyStats>> getLocalWeeklyStats(String childId) async {
    final progress = await UserProgressStorage.load(childId: childId);
    if (progress.recentSessions.isEmpty) return const [];

    final grouped = <String, _DailyAggregate>{};
    for (final session in progress.recentSessions) {
      final key = _dateKey(session.timestamp);
      final current = grouped[key] ?? _DailyAggregate.empty();
      grouped[key] = current.add(session);
    }

    final orderedKeys = grouped.keys.toList()..sort();
    final last7Keys =
        orderedKeys.length > 7 ? orderedKeys.sublist(orderedKeys.length - 7) : orderedKeys;

    return last7Keys
        .map((k) {
          final agg = grouped[k]!;
          return DailyStats(
            date: k,
            totalPoints: agg.totalPoints,
            sessionsCount: agg.sessionsCount,
            avgAccuracy: agg.avgAccuracy,
            modules: agg.modules,
          );
        })
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  String _dateKey(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }
}

class _DailyAggregate {
  const _DailyAggregate({
    required this.totalPoints,
    required this.sessionsCount,
    required this.accuracySum,
    required this.modules,
  });

  factory _DailyAggregate.empty() => const _DailyAggregate(
        totalPoints: 0,
        sessionsCount: 0,
        accuracySum: 0,
        modules: {},
      );

  final int totalPoints;
  final int sessionsCount;
  final int accuracySum;
  final Map<String, int> modules;

  double get avgAccuracy {
    if (sessionsCount == 0) return 0.0;
    final avgPercent = accuracySum / sessionsCount;
    return avgPercent / 100.0;
  }

  _DailyAggregate add(SessionRecord record) {
    final nextModules = Map<String, int>.from(modules);
    if (record.moduleKey != null && record.moduleKey!.isNotEmpty) {
      nextModules[record.moduleKey!] =
          (nextModules[record.moduleKey!] ?? 0) + record.points;
    }

    return _DailyAggregate(
      totalPoints: totalPoints + record.points,
      sessionsCount: sessionsCount + 1,
      accuracySum: accuracySum + record.accuracy,
      modules: nextModules,
    );
  }
}

final familyProfileRepositoryProvider = Provider<FamilyProfileRepository>(
  (ref) => const FamilyProfileRepository(),
);
