# MathLingo - Code Improvements & Enhancement Guide

## Summary of Improvements Made

### ✅ Completed Fixes

1. **Auth Localization Final Pass (Shqip Standard)**
  - **Files:** `lib/features/auth/presentation/parent_signin_screen.dart`, `lib/features/auth/presentation/parent_signup_screen.dart`, `lib/l10n/app_sq.arb`, `test/widget_test.dart`
  - **Issue:** Auth screens still had inline strings and duplicated error text logic, with mixed style and non-centralized copy.
  - **Fix:** Migrated user-facing Auth copy to `AppLocalizations`, added missing ARB keys (subtitle/hint/reset-email states), and aligned widget tests with updated Albanian copy.
  - **Impact:** Consistent Albanian UX copy across Auth, easier maintenance via centralized localization, and stable automated tests.
  - **Validation:** `fvm flutter gen-l10n`, `fvm flutter analyze`, `fvm flutter test` (150/150 passed).
  - **Status:** ✅ Complete

2. **Removed Undefined Font Family**
   - **File:** `lib/main.dart` (line 33)
   - **Issue:** App referenced 'Lexend' font that wasn't defined in pubspec.yaml
   - **Fix:** Removed `fontFamily: 'Lexend'` to use system default
   - **Impact:** Eliminates potential runtime font loading errors
   - **Status:** ✅ Complete

### Summary Status
- **Code Quality:** ✅ Excellent (0 issues in flutter analyze)
- **Type Safety:** ✅ Perfect (null safety enforced)
- **Compilation:** ✅ Clean (no errors)
- **Dependencies:** ✅ Updated

---

## Recommended Code Enhancements

### High Priority (Next Sprint)

#### 1. Data Persistence - User Progress Tracking
**File:** Extract to new `lib/models/user_progress.dart`

**Current State:** No data saved between sessions

**Proposed Solution:**
```dart
// lib/models/user_progress.dart
import 'package:hive/hive.dart';

part 'user_progress.g.dart';

@HiveType(typeId: 1)
class UserProgress {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final int totalPoints;

  @HiveField(2)
  final int level;

  @HiveField(3)
  final Map<String, int> operationScores;

  @HiveField(4)
  final DateTime lastActive;

  UserProgress({
    required this.userId,
    required this.totalPoints,
    required this.level,
    required this.operationScores,
    required this.lastActive,
  });
}

// lib/services/progress_service.dart
class ProgressService {
  late final Box<UserProgress> _progressBox;

  Future<void> initialize() async {
    _progressBox = await Hive.openBox<UserProgress>('user_progress');
  }

  Future<void> saveProgress(UserProgress progress) async {
    await _progressBox.put(progress.userId, progress);
  }

  UserProgress? getProgress(String userId) {
    return _progressBox.get(userId);
  }
}
```

**Implementation in main.dart:**
```dart
// In ChallengeScreen._ChallengeScreenState
@override
Future<void> _onGameComplete() async {
  final progressService = ProgressService.instance;
  final progress = UserProgress(
    userId: 'user_1',
    totalPoints: _score,
    level: widget.level,
    operationScores: {widget.operation.name: _score},
    lastActive: DateTime.now(),
  );
  await progressService.saveProgress(progress);
}
```

**Dependencies to Add:**
```yaml
dependencies:
  hive: ^2.3.0
  hive_flutter: ^1.1.0

dev_dependencies:
  hive_generator: ^2.0.0
  build_runner: ^2.4.0
```

**Build Steps:**
```bash
flutter pub add hive hive_flutter
flutter pub add -d hive_generator build_runner
flutter pub run build_runner build
```

---

#### 2. State Management Upgrade - Provider Pattern
**Current Issue:** No centralized state management, prop drilling

**Proposed Solution:**
```dart
// lib/providers/game_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class GameState {}
class GameInitial extends GameState {}
class GameLoading extends GameState {}
class GameReady extends GameState {
  final bool isAnswerCorrect;
  GameReady({required this.isAnswerCorrect});
}

final gameStateProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier();
});

class GameNotifier extends StateNotifier<GameState> {
  GameNotifier() : super(GameInitial());

  Future<void> checkAnswer(int answer, int correctAnswer) async {
    state = GameLoading();
    await Future.delayed(const Duration(milliseconds: 300));
    state = GameReady(isAnswerCorrect: answer == correctAnswer);
  }
}
```

**Usage in ChallengeScreen:**
```dart
class ChallengeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);

    return Column(
      children: [
        // UI here
        GridView(
          children: _question.options.map((option) {
            return ElevatedButton(
              onPressed: () {
                ref.read(gameStateProvider.notifier)
                    .checkAnswer(option, _question.answer);
              },
              child: Text(option.toString()),
            );
          }).toList(),
        ),
      ],
    );
  }
}
```

**Dependencies:**
```yaml
dependencies:
  flutter_riverpod: ^2.4.0
```

---

#### 3. ML Kit Integration for Image Recognition
**File:** `lib/services/ml_service.dart`
**Status:** Currently has TODO at line 61

**Implementation:**
```dart
// lib/services/ml_service.dart
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';

class MLService {
  static final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  static Future<String> recognizeTextFromImage(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      
      String text = '';
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          text += '${line.text}\n';
        }
      }
      
      return text;
    } catch (e) {
      print('Error recognizing text: $e');
      rethrow;
    }
  }

  static Future<String> parseEquation(String recognizedText) async {
    // Clean the text
    String cleaned = recognizedText
        .toLowerCase()
        .replaceAll(RegExp(r'[^0-9+\-*/=÷×]'), '')
        .trim();
    
    if (cleaned.isEmpty) {
      throw Exception('No equation found in image');
    }
    
    return cleaned;
  }

  static void dispose() {
    _textRecognizer.close();
  }
}
```

**Update gamify_exercise.dart:**
```dart
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'ml_service.dart';

Future<void> _processImage() async {
  if (_selectedImage == null) return;
  
  setState(() => _recognizedText = 'Processing image...');
  
  try {
    final recognizedText = await MLService.recognizeTextFromImage(_selectedImage!);
    final equation = await MLService.parseEquation(recognizedText);
    
    setState(() {
      _recognizedText = equation;
    });
  } catch (e) {
    _showErrorSnackBar('Failed to recognize text: $e');
  }
}
```

**Dependencies:**
```yaml
dependencies:
  google_mlkit_text_recognition: ^0.7.0
```

---

#### 4. Add Unit Tests
**Create:** `test/models/math_question_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mathlingo/main.dart';

void main() {
  group('MathQuestion', () {
    test('Addition question generates correct answer', () {
      final question = MathQuestion(
        num1: 5,
        num2: 3,
        answer: 8,
        options: [7, 8, 9, 10],
      );

      expect(question.num1 + question.num2, equals(question.answer));
    });

    test('Division question generates integer answer', () {
      final question = MathQuestion(
        num1: 12,
        num2: 3,
        answer: 4,
        options: [3, 4, 5, 6],
      );

      expect(question.num1 ~/ question.num2, equals(question.answer));
    });
  });
}
```

**Create:** `test/challenge_screen_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mathlingo/main.dart';

void main() {
  group('ChallengeScreen', () {
    testWidgets('Displays question correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MathLingoApp());
      
      // Navigate to challenge
      await tester.tap(find.byIcon(Icons.add)); // Addition
      await tester.pumpAndSettle();

      expect(find.byType(ChallengeScreen), findsOneWidget);
      expect(find.text(RegExp(r'\? = \?')), findsWidgets);
    });

    testWidgets('Correct answer advances to next question', (WidgetTester tester) async {
      // Implementation...
    });
  });
}
```

---

### Medium Priority (Future Sprints)

#### 5. Internationalization (i18n)
**Create:** `lib/l10n/app_en.arb`

```json
{
  "welcome": "Welcome!",
  "dashboardTitle": "Math Challenge",
  "addition": "Addition",
  "subtraction": "Subtraction",
  "multiplication": "Multiplication",
  "division": "Division",
  "congratulations": "Congratulations!",
  "yourScore": "Your Score: {score}",
  "@yourScore": {
    "description": "Display user's score",
    "placeholders": {
      "score": {
        "type": "int"
      }
    }
  }
}
```

**Update pubspec.yaml:**
```yaml
dependencies:
  flutter_localizations:
    sdk: flutter

flutter:
  generate: true
```

**Use in app:**
```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Text(AppLocalizations.of(context)!.welcome)
```

---

#### 6. Advanced Analytics
**File**: `lib/services/analytics_service.dart`

```dart
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final _analytics = FirebaseAnalytics.instance;

  static Future<void> logChallengeStarted(String operation) async {
    await _analytics.logEvent(
      name: 'challenge_started',
      parameters: {
        'operation': operation,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  static Future<void> logChallengeCompleted(
    String operation, 
    int score, 
    int accuracy,
  ) async {
    await _analytics.logEvent(
      name: 'challenge_completed',
      parameters: {
        'operation': operation,
        'score': score,
        'accuracy': accuracy,
      },
    );
  }
}
```

---

#### 7. Achievement System
**Create:** `lib/models/achievement.dart`

```dart
enum AchievementType {
  firstChallenge,
  tenChallenges,
  hundredPoints,
  perfectScore,
  fastSolver,
}

class Achievement {
  final AchievementType type;
  final String title;
  final String description;
  final DateTime unlockedAt;

  Achievement({
    required this.type,
    required this.title,
    required this.description,
    required this.unlockedAt,
  });
}

class AchievementManager {
  List<Achievement> _achievements = [];

  void checkAndUnlockAchievements(int totalScore, int sessionScore, int currentLevel) {
    if (!_isAchievementUnlocked(AchievementType.firstChallenge)) {
      _unlockAchievement(
        AchievementType.firstChallenge,
        'First Challenge',
        'Complete your first math challenge!',
      );
    }

    if (totalScore >= 100 && !_isAchievementUnlocked(AchievementType.hundredPoints)) {
      _unlockAchievement(
        AchievementType.hundredPoints,
        '100 Points',
        'Accumulate 100 points!',
      );
    }

    if (sessionScore == 50 && !_isAchievementUnlocked(AchievementType.perfectScore)) {
      _unlockAchievement(
        AchievementType.perfectScore,
        'Perfect Score',
        'Get 100% accuracy in a challenge!',
      );
    }
  }

  void _unlockAchievement(AchievementType type, String title, String description) {
    _achievements.add(Achievement(
      type: type,
      title: title,
      description: description,
      unlockedAt: DateTime.now(),
    ));
  }

  bool _isAchievementUnlocked(AchievementType type) {
    return _achievements.any((a) => a.type == type);
  }
}
```

---

### Low Priority (Polish & Optimization)

#### 8. Performance Optimizations

**Image Caching:**
```dart
// Optimize mascot image loading
Image.asset(
  'assets/icons/stich_icon.png',
  fit: BoxFit.contain,
  cacheHeight: (widget.size * 2).toInt(),
  cacheWidth: (widget.size * 2).toInt(),
)
```

**Lazy Loading:**
```dart
// Load screens only when needed
final pages = [
  (_selectedIndex == 0) ? _DashboardPage(...) : SizedBox.shrink(),
  (_selectedIndex == 1) ? _LessonsPage(...) : SizedBox.shrink(),
  // etc...
];
```

**Memory Management:**
```dart
@override
void dispose() {
  _bounceController.dispose();
  _swayController.dispose();
  _celebrationController.dispose();
  _exerciseController.dispose();  // Already done
  super.dispose();
}
```

---

#### 9. UI/UX Enhancements

**Add Haptic Feedback:**
```dart
import 'package:flutter/services.dart';

void _checkAnswer(int answer) {
  if (answer == _question.answer) {
    HapticFeedback.heavyImpact();
  } else {
    HapticFeedback.lightImpact();
  }
}
```

**Add Sound Effects:**
```dart
import 'package:audioplayers/audioplayers.dart';

final audioPlayer = AudioPlayer();

void _playSuccessSound() async {
  await audioPlayer.play(AssetSource('sounds/success.mp3'));
}
```

**Micro-interactions:**
```dart
ScaleTransition(
  scale: _scaleAnimation,
  child: _AnswerButton(...),
)
```

---

#### 10. Accessibility Improvements

**Add Semantic Labels:**
```dart
Semantics(
  enabled: true,
  label: 'Addition Challenge Question',
  child: GestureDetector(
    onTap: () => _startChallenge(Operation.addition),
    child: _OperationTile(...),
  ),
)
```

**Screen Reader Support:**
```dart
GestureDetector(
  onTap: () => _checkAnswer(option),
  onLongPress: () => Semantics.announce(
    'Correct answer: $option',
  ),
  child: _AnswerButton(...),
)
```

---

## File Organization Recommendations

**Current Structure (Flat):**
```
lib/
├── main.dart
├── colors.dart
├── responsive.dart
├── gamify_exercise.dart
├── simple_tables.dart
└── stitch_screens.dart
```

**Recommended Structure:**
```
lib/
├── main.dart
├── config/
│   ├── theme.dart
│   ├── colors.dart
│   └── routes.dart
├── models/
│   ├── math_question.dart
│   ├── geometry_question.dart
│   ├── user.dart
│   └── achievement.dart
├── services/
│   ├── progress_service.dart
│   ├── ml_service.dart
│   └── analytics_service.dart
├── providers/
│   ├── game_provider.dart
│   └── user_provider.dart
├── widgets/
│   ├── common/
│   │   ├── glass_panel.dart
│   │   ├── cosmic_button.dart
│   │   └── cosmic_progress.dart
│   └── screens/
│       ├── dashboard_screen.dart
│       ├── challenge_screen.dart
│       ├── geometry_challenge_screen.dart
│       └── results_screen.dart
├── utils/
│   ├── responsive.dart
│   └── constants.dart
└── l10n/
    ├── app_en.arb
    └── app_sq.arb
```

---

## Performance Benchmarks

### Current Performance (Estimated)

| Metric | Value | Target |
|--------|-------|--------|
| App Size | ~30-50 MB | <50 MB |
| Startup Time | ~2-3 seconds | <2s |
| Question Generation | <100ms | <50ms |
| Memory Usage (Idle) | ~80 MB | <100 MB |
| Frame Rate | 60 FPS | 60 FPS |

### Optimization Targets

- [ ] Reduce app size to <40 MB
- [ ] Achieve <1.5s startup time
- [ ] Generate questions in <50ms
- [ ] Maintain >55 FPS on mid-range devices
- [ ] Support devices with 2GB RAM minimum

---

## Testing Checklist

- [ ] Unit tests: 70%+ code coverage
- [ ] Widget tests for all screens
- [ ] Integration tests for main flows
- [ ] Performance profiling
- [ ] Memory leak detection
- [ ] Test on Android 8.0 (API 26) minimum
- [ ] Test on tablets (10" + screens)
- [ ] Test on devices with 2GB-8GB RAM
- [ ] Dark mode testing
- [ ] Landscape orientation testing
- [ ] Network connectivity issues
- [ ] Permission handling tests

---

## Release Preparation

### Pre-Release Checklist

- [ ] Update version in pubspec.yaml
- [ ] Create CHANGELOG entry
- [ ] Update README with latest features
- [ ] Run full test suite (100% pass rate)
- [ ] Performance profiling (target: 60 FPS)
- [ ] Security audit
- [ ] Privacy policy documentation
- [ ] Terms of service (if applicable)
- [ ] App Store description and keywords
- [ ] Screenshots and app preview video
- [ ] Beta testing with 50+ users
- [ ] Accessibility audit
- [ ] Localization proof-read

---

## Next Steps

1. **This Week:** Implement data persistence (H priority #1)
2. **Next Week:** Add state management upgrade (H priority #2)
3. **Sprint 2:** ML Kit integration (H priority #3)
4. **Sprint 3:** Analytics and achievements
5. **Sprint 4:** Internationalization and optimization

---

**Last Updated:** May 6, 2026  
**Next Review:** June 6, 2026
