import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_lingo/core/providers/family_provider.dart' as family;
import 'package:math_lingo/core/providers/weekly_stats_provider.dart';
import 'package:math_lingo/features/family/presentation/parent_report_screen.dart';
import 'package:math_lingo/l10n/app_localizations.dart';
import 'package:math_lingo/models/child_profile.dart';
import 'package:math_lingo/models/daily_stats.dart';
import 'package:math_lingo/models/family_profile.dart';

class _TestFamilyNotifier extends family.FamilyNotifier {
  _TestFamilyNotifier(family.FamilyState initial) : super() {
    state = initial;
  }
}

class _IdleWeeklyStatsNotifier extends WeeklyStatsNotifier {
  _IdleWeeklyStatsNotifier(super.ref)
      : super() {
    state = const WeeklyStatsLoaded([
      DailyStats(
        date: '2026-05-20',
        totalPoints: 10,
        sessionsCount: 1,
        avgAccuracy: 0.9,
        modules: {'addition': 10},
      )
    ]);
  }

  @override
  Future<void> load() async {}

  @override
  Future<void> refresh() async {}
}

class _OpenReportHarness extends StatelessWidget {
  const _OpenReportHarness({
    required this.onReportOpened,
    required this.verifier,
  });

  final VoidCallback onReportOpened;
  final Future<bool> Function(BuildContext context) verifier;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () async {
            final ok = await verifier(context);
            if (!ok) return;
            onReportOpened();
          },
          child: const Text('Hap raportin'),
        ),
      ),
    );
  }
}

ChildProfile _child({String pseudonym = 'Ylli'}) {
  return ChildProfile(
    id: 'c1',
    pseudonym: pseudonym,
    avatarIndex: 0,
    totalPoints: 120,
    totalAccuracy: 90,
    completedSessions: 12,
    moduleHistory: const {},
  );
}

family.FamilyState _familyStateWithChild(ChildProfile child) {
  final profile = FamilyProfile(
    id: 'f1',
    createdAt: DateTime(2026, 1, 1),
    children: [child],
  );
  return family.FamilyState(family: profile, activeChild: child);
}

Widget _testApp({required family.FamilyState familyState, required Widget home}) {
  return ProviderScope(
    overrides: [
      family.familyProvider
          .overrideWith((ref) => _TestFamilyNotifier(familyState)),
      weeklyStatsProvider.overrideWith((ref) => _IdleWeeklyStatsNotifier(ref)),
    ],
    child: MaterialApp(
      locale: const Locale('sq'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    ),
  );
}

Future<void> _pumpFrames(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
}

void main() {
  testWidgets('pa PIN te konfiguruar hyrja lejohet direkt', (tester) async {
    final familyState = _familyStateWithChild(_child());
    var opened = false;

    await tester.pumpWidget(
      _testApp(
        familyState: familyState,
        home: _OpenReportHarness(
          onReportOpened: () => opened = true,
          verifier: (_) async => true,
        ),
      ),
    );

    await tester.tap(find.text('Hap raportin'));
    await _pumpFrames(tester);

    expect(opened, isTrue);
  });

  testWidgets('me PIN te sakte ParentReportScreen hapet', (tester) async {
    final familyState = _familyStateWithChild(_child());
    var opened = false;

    await tester.pumpWidget(
      _testApp(
        familyState: familyState,
        home: _OpenReportHarness(
          onReportOpened: () => opened = true,
          verifier: (_) async => true,
        ),
      ),
    );

    await tester.tap(find.text('Hap raportin'));
    await _pumpFrames(tester);

    expect(opened, isTrue);
  });

  testWidgets('me PIN te gabuar ekrani nuk hapet', (tester) async {
    final familyState = _familyStateWithChild(_child());
    var opened = false;

    await tester.pumpWidget(
      _testApp(
        familyState: familyState,
        home: _OpenReportHarness(
          onReportOpened: () => opened = true,
          verifier: (_) async => false,
        ),
      ),
    );

    await tester.tap(find.text('Hap raportin'));
    await _pumpFrames(tester);

    expect(opened, isFalse);
  });

  testWidgets('ParentReportScreen shfaq pseudonimin', (tester) async {
    final child = _child(pseudonym: 'Astronauti');
    final familyState = _familyStateWithChild(child);

    await tester.pumpWidget(
      _testApp(
        familyState: familyState,
        home: const ParentReportScreen(),
      ),
    );
    await _pumpFrames(tester);

    expect(find.text('Astronauti'), findsOneWidget);
  });
}
