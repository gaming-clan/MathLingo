# 📝 Changelog - MathLingo

## [2.0.1] - 2026-05-19 — Sprint 14: Ridizenjimi i Kartave të Tabelave
### Changed
- **`_TableCard` Widget i ri:** Kartat e tabelave ndërtuar nga e para si `StatefulWidget` me mekanizëm zbulimi me trokitje: trokitje e parë zbulon përgjigjen me `AnimatedSwitcher` + SnackBar me ekuacionin e plotë; trokitje e dytë fsheh. `AnimatedContainer` me kufi dhe ngjyrë adaptive sipas operacionit.
- **`_TableOperationTheme` extension:** ngjyra unike per operacion — `cardBackground`, `cardBorderColor`, `cardTextColor` (gjelbër/kuq/portokallë/kaltër).
- **Selektor numrash kompakt:** `ListView` me `ElevatedButton` zëvendësohet me `Wrap` prej 36×36 `AnimatedContainer` buttons me ngjyrë operacioni.
- **GridView layout:** `childAspectRatio: 1.0` (karta katrore), `mainAxisSpacing: 10`, `crossAxisSpacing: 10`.
- **Hequr `Color color` parametri** nga `_buildOperationTable` — ngjyrat vijnë nga `_TableOperationTheme`.

### Fixed
- **B-S14-01 — SnackBar formula:** SnackBar tregonte `l10n.tablesEquationSnackBar(...)` me parametra gabim; tani `snackText()` ndërton formulën e saktë per operacion dhe modalitet (p.sh. `5 × 3 = 15`, `15 ÷ ? = 5`).
- **B-S14-02 — Zbritje Invers Ekuacioni:** `equationText` për zbritje invers tregonte `'? + $num = $selectedTable'` (identik me mbledhjen invers); korrigjuar në `'$selectedTable − $num = ?'`.
- **B-S14-03 — Zbritje Invers Hyrjet:** `_buildVisibleEntries` nuk kishte rast special për zbritje invers — kthehej te logjika generike; tani gjeneron `n=1..table-1` (shmanget `result=0`, p.sh. `4−4=0`).
- **`badgeSymbol` zbritje invers:** `badgeSymbol()` kthente `'+'` për zbritje invers; zëvendësohet tërësisht me `revealValue()` + `snackText()` me logjikë të saktë.

### Tests
- `tables_inverse_mode_test.dart` — +5 teste zbritje invers: ekuacion, entries, badgeSymbol; 19 → 24 teste totale.

### Validated
- `fvm flutter test` — 146/146 ✅
- `fvm flutter analyze` — 0 warnings/errors ✅

---

## [1.10.1] - 2026-05-19 — Sprint 11.5: Bug-Fix & Polish
### Fixed
- **B-01 — Shumëzim Invers:** `equationText` tregonte gabimisht `?÷n=tableNum`; korrigjuar në `?×n=result`. `badgeSymbol` ishte `÷`; korrigjuar në `×`. Rrethi tregonte `result`; korrigjuar në `selectedTable`.
- **B-01 — Pjesëtim Invers:** `equationText` tregonte `?×n=tableNum`; korrigjuar në `result÷?=tableNum`. Rrethi tregonte `result`; korrigjuar në `num` (divisori). `_buildVisibleEntries` gjeneronte vetëm shumëfishat e saktë të `selectedTable`; korrigjuar — tani gjeneron 10 hyrje `(tableNum×1)..(tableNum×10)`.
- **B-02 — Mbledhje Invers:** `_buildTabViews` kalonte `isInverseMode: false` hardcoded për tab-in e mbledhjes; korrigjuar në `isInverseMode: isInverseMode`. `_buildVisibleEntries` gjeneron hyrje inverse `?+n=tableNum → result=tableNum-n`.
- **B-03 — Badge Reveal Button:** `FilledButton` me sfond `#F3D6FF` (kontrast ~1.36:1 — nën WCAG AA) zëvendësohet me `CosmicButton` (gradient magenta→violet, tekst i bardhë, kontrast ~7:1).
- **B-04 — Card Padding:** Shtohet `Padding(EdgeInsets.fromLTRB(8,10,8,0))` rreth tekstit të formulës — teksti nuk ngjitet më me bordurin e kartës.
- **B-07 — Card Font:** `fontSize: 20` → `fontSize: 16` me `maxLines: 2` dhe `overflow: TextOverflow.ellipsis` — shprehje të gjata nuk priten.
- **B-08 — Card Contrast:** Shtohet `Shadow(Colors.black54, blurRadius:4, offset:Offset(0,1))` — tekst i lexueshëm mbi fondacione me ngjyra (portokalli, e kuqe).
- **B-05 konfirmuar:** `addition_starter` tashmë kishte `emoji:'➕'` — pa ndryshim.
- **B-06 konfirmuar:** `LeaderboardScreen` tashmë tregonte të gjithë fëmijët me `isActive` highlight — pa ndryshim.

### Tests
- `test/features/tables/tables_inverse_mode_test.dart` rifaqosur: 12 → 19 teste (shumëzim/pjesëtim/mbledhje invers, entries, circle values, regresion klasik).

### Validated
- `fvm flutter test` — 141/141 ✅
- `fvm flutter analyze` — No issues found ✅

---

## [1.10.0] - 2026-05-19 — Sprint 12: Raportet e Prindërve
### Added
- **`SyncService.pullWeeklyStats(uid, childId)`** — lexon historikun e 7 ditëve nga koleksioni Firestore `progress/{date}` dhe ndërton `WeeklyStatsState` me lista `points`, `accuracy`, `sessions`.
- **`WeeklyStatsState`** (`lib/features/family/providers/`) — Riverpod `StateNotifierProvider`; menaxhon gjendjen e statistikave javore (loading/error/data).
- **`ParentReportScreen`** zgjeruar me:
  - `BarChart` (`fl_chart`) — pikët e 7 ditëve të fundit me gradientë cyan.
  - `LineChart` (`fl_chart`) — saktësia % e 7 ditëve me spot cyan/red mbi 70%.
  - `_ChildReportCard` — krahasim mes profileve fëmijësh (pikë totale, saktësi, sesione).
  - `_RecentActivitySection` + `_ActivityRow` — 5 ditët e fundit me datë, pikë (⚡), saktësi%, numër sesionesh, renditje kronologjike inverse.
- **Auto-sync pas sesionit:** `ChallengeScreen` thirr `SyncService.updateDailyStats()` fire-and-forget pas çdo sesioni të përfunduar (kur Firebase aktiv + autentikuar).
- **`AuthService.updateLastSyncAt(DateTime)`** — lexon `ParentAccount` nga Hive, ruan me `lastSyncAt` të përditësuar.
- **`AuthNotifier.refreshAccount()`** — rifreskon `ParentAccount` nga Hive dhe përditëson state.
- **Indicator "Sinkronizuar Para X min"** në `SettingsScreen._CloudSyncSection` — shfaq `lastSyncAt` i formatuar (Tani / Para X min / Para X orë / dd/mm HH:MM).
- **`fl_chart: ^0.69.0`** — paketë grafike për vizualizimin e statistikave prindërore.
- **Firestore Security Rules** (`firestore.rules`) — `users/{uid}/**` aksesueshe vetëm nga `request.auth.uid == uid`.

### Validated
- `fvm flutter test` — 134/134 ✅
- `fvm flutter analyze` — No issues found ✅

---

## [1.9.0] - 2026-05-18 — Stabilization Update
### Fixed (UI Polish)
- **B012 — PIN Dialog:** `hintStyle` i fushave të hyrjes së PIN-it vendosur me `color: Colors.white38` — hintText nuk dukej si tekst i plotë.
- **B013 — Fractions Bug:** Hequr widget `Text('${question.numerator}/${question.denominator}')` nga `FractionChallengeScreen` — fëmija nuk sheh më numerikisht vlerën e thyesës para se ta zgjidhë.
- **B014 — Achievements Grid:** `BadgeDisplayScreen` GridView bërë responsive (`crossAxisCount: isTablet ? 4 : 3`, `childAspectRatio: isTablet ? 1.0 : 0.9`); emoji `fontSize` ulur nga 34 në 28.

### Validated
- `fvm flutter test` — 134/134 ✅
- `fvm flutter analyze` — No issues found ✅

---

## [1.8.0] - 2026-05-17 — Sprint 10B: Firebase Auth & Cloud Sync
### Added
- **Firebase integration:** `firebase_core: ^3.4.0`, `firebase_auth: ^5.2.0`, `cloud_firestore: ^5.3.0`.
- **`FirebaseInitService`** (`lib/core/services/firebase_init_service.dart`) — inicializim lazy pas consent prindi; `isInitialized` flag global.
- **`DefaultFirebaseOptions`** (`lib/firebase_options.dart`) — gjeneruar nga `flutterfire configure --project=mathlingo-90084`; regjistron Android, iOS, Web, macOS, Windows.
- **`google-services.json`** (`android/app/`) — skedar real i gjeneruar nga Firebase CLI v15.18.0.
- **`firebase.json`** — konfigurim CLI i projektit Firebase.
- **`ParentAccount`** model (`lib/features/auth/models/`) — `uid`, `email`, `createdAt`, `cloudSyncEnabled`, `lastSyncAt`; ruhet në Hive box `'parent_account'`.
- **`AuthService`** (`lib/features/auth/services/`) — `signUp`, `signIn`, `signOut`, `deleteAccount`, `getCurrentAccount`; `_mapFirebaseError` maps Firebase error codes → ARB keys.
- **Sealed `AuthState`** (`lib/features/auth/providers/auth_provider.dart`) — `AuthStateInitial | Loading | Authenticated | Unauthenticated | Error`; `authProvider`, `isAuthenticatedProvider`, `currentParentProvider`.
- **`ParentSignUpScreen`** + **`ParentSignInScreen`** (`lib/features/auth/presentation/`) — `ConsumerStatefulWidget`, `GlassPanel`, `CosmicButton`, `ref.listen<AuthState>`, `sendPasswordResetEmail` për "Forgot Password".
- **`FirestoreSchema`** (`lib/core/sync/`) — konstantet e path-eve Firestore (`users/{uid}/children/{childId}/info/profile`, `progress/{date}`).
- **`SyncService`** (`lib/core/sync/`) — `syncChildInfo`, `syncChildProgress`, `pullChildInfo`, `deleteAllUserData` (GDPR Article 17); `syncServiceProvider`.
- **`SettingsScreen`** zgjeruar me `_CloudSyncSection` — shfaq email + "Dil" + "Fshi Llogarinë" nëse autentikuar; shfaq "Krijo Llogari Prindi" + "Hyni" ndryshe.
- **`DeleteAllDataScreen`** zgjeruar — pas fshirjes lokale, nëse Firebase inicializuar dhe sesioni aktiv, thirr `deleteAllUserData(uid)` + `signOut()`.
- **30+ ARB strings** shqip të reja: `authSignUpTitle`, `authSignInTitle`, `authEmailLabel`, `authPasswordLabel`, `authConfirmPasswordLabel`, `authSignUpButton`, `authSignInButton`, `authSigningUp`, `authSigningIn`, `authHaveAccount`, `authNoAccount`, `authForgotPassword`, `authPrivacyNote`, 8 `authError*` keys, `syncEnabled`, `syncDisabled`, `syncLastSync`, `authDeleteAccountTitle`, `authDeleteAccountConfirm`, `authDeleteAccountButton`, `authSignOutButton`.
- **`android/app/build.gradle.kts`:** Google Services plugin + release signing nga `key.properties`.
- **`android/settings.gradle.kts`:** `id("com.google.gms.google-services") version "4.4.2" apply false`.

### Changed
- `.gitignore`: `lib/firebase_options.dart` dhe `android/app/google-services.json` hequr nga lista e ignore (tashmë të commit-uara).

### Validated
- `fvm flutter test` — 134/134 ✅
- `fvm flutter analyze` — No issues found ✅

---

## [1.7.0] - 2026-05-17 — Sprint 11: Gamifikimi i Avancuar
### Added
- **Sistemi i Arritjeve (Achievements):** `Achievement` model (`lib/models/achievement.dart`) — badge me id, title, description, icon, category, unlockedAt.
- **`AchievementService`** (`lib/core/services/`) — static service për dhënie dhe ruajtje me Hive; `unlockAchievement`, `getAll`, `deleteAllData`; integrate me challenge results.
- **`AchievementProvider`** (`lib/core/providers/`) — Riverpod `StateNotifierProvider`; shpërndan badges ndaj UI.
- **`BadgeDisplayScreen`** (`lib/features/achievements/presentation/`) — GridView responsive me 3/4 kolona; koston e badge-ve me emoji dhe titull.
- **`BadgeNotificationOverlay`** (`lib/features/achievements/presentation/`) — overlay njoftim kur shkyçet badge i ri.
- **`LeaderboardScreen`** (`lib/features/leaderboard/presentation/`) — renditje e anëtarëve të familjes sipas pikëve totale.
- **`AudioService`** (`lib/core/services/`) — `playCorrect`, `playWrong`, `playLevelUp`, `playAchievement` me `audioplayers: 6.0.0`; nullable — fjalë nëse audioplayers nuk inicializon.
- **`HapticService`** (`lib/core/services/`) — `lightImpact`, `mediumImpact`, `heavyImpact`, `success`, `error` — feedback haptik me `HapticFeedback` native.
- **`DataExportService`** (`lib/core/services/`) — eksport CSV i sesioneve dhe progresit; `share_plus: ^13.1.0`.
- **`package_info_plus: ^10.1.0`** — informacion versioni i aplikacionit.
- **`share_plus: ^13.1.0`** — ndarje skedaresh (raporte, CSV eksport).
- **`audioplayers: 6.0.0`** — audio feedback lojërave.

### Validated
- `fvm flutter test` — 134/134 ✅
- `fvm flutter analyze` — No issues found ✅

---

## [1.6.0] - 2026-05-17 — Sprint 10A: Familja, Privatësia & Gamifikimi Bazë
### Added
- **`ChildProfile`** model (`lib/models/child_profile.dart`) — id, name, avatarEmoji, totalPoints, sessionsCompleted, operationScores; Hive-persisted me `toMap()`/`fromMap()`.
- **`FamilyProfile`** model (`lib/models/family_profile.dart`) — lista e `ChildProfile`, `activeChildId`, PIN-hash.
- **`FamilyProfileService`** (`lib/core/services/`) — `createChild`, `switchChild`, `getActiveChild`, `verifyPin`, `setPin`; persist me Hive box `'family_profile'`.
- **`FamilyProvider`** (`lib/core/providers/`) — Riverpod StateNotifier; shpërndan profil aktiv dhe listë fëmijësh.
- **`FamilySetupScreen`** (`lib/features/family/presentation/`) — krijimi i profilave fëmijësh me avatar emoji.
- **`FamilySwitcherScreen`** (`lib/features/family/presentation/`) — ndërrimi i profilit aktiv fëmije.
- **`ParentPinDialog`** (`lib/features/family/presentation/`) — dialog PIN-mbrojtje për ndërrimin e profilit; dy variante (verifikimi + krijimi).
- **`ParentReportScreen`** (`lib/features/family/presentation/`) — raport progresi për prindët (pikë totale, sesione, saktësi për operacion).
- **`SettingsScreen`** (`lib/features/settings/presentation/`) — ekran i plotë i cilësimeve me seksione: Profili, Gamifikimi, Privatësia, Cloud Sync.
- **`ConsentFlowScreen`** (`lib/features/settings/presentation/`) — flow i pranimit GDPR për inicializimin e Firebase.
- **`PrivacyPolicyScreen`** (`lib/features/settings/presentation/`) — politika e privatësisë e brendshme (GDPR-compliant).
- **`DeleteAllDataScreen`** (`lib/features/settings/presentation/`) — fshirja konfirmuese e të dhënave lokale me `AchievementService.deleteAllData`.
- **`UserProgress`** model (`lib/models/user_progress.dart`) — pikë, sesione, saktësi, operacioni i preferuar.

### Validated
- `fvm flutter test` — 134/134 ✅
- `fvm flutter analyze` — No issues found ✅

---

## [1.5.1] - 2026-05-16
### Added
- `FractionQuestion` model (Domain Layer) — numerator, denominator, answer, options, visualType (pie|bar).
- `FractionGenerator` — gjeneron pyetje për 9 fraksionet e mbuluar (½, ⅓, ¼, ¾, ⅔, ⅛, ⅜, ⅝, ⅞) me 3 distractor plausible.
- `FractionPainter` (CustomPainter) — pie (tarte) + bar (shirit); qeliza cyan të ngjyrosura kundrejt `surfaceLow`.
- `FractionChallengeScreen` (`lib/features/fraction/`) — 4 pyetje/sesion, +15 pikë/pyetje, integrim me `ResultsScreen`.
- `FractionProvider` (Riverpod `StateNotifierProvider.autoDispose.family`) — menaxhon state të sfidës.
- Kartë "Fraksionet" në `DashboardScreen` (mobile + master-detail) — me `_NeonChip` cyan dhe buton navigimi.
- ARB strings shqip: `fractionKicker`, `fractionTitle`, `fractionPrompt`, `fractionCorrectFeedback`, `fractionIncorrectFeedback`, `dashboardFractionsChip/Title/Description/Button`, + 9 emra fraksionesh.
- `MultiplicationGridPainter` (CustomPainter) — grilë N×M me `animatedCols` kolonë të ngjyrosura cyan.
- Buton "Shfaq Grilën" / "Fshih Grilën" në `ChallengeScreen` (vetëm për shumëzim) — animacion `AnimatedCrossFade` + `AnimationController` 300ms/kolonë.
- Widget tests: `fraction_painter_test.dart` (6 tests), `multiplication_grid_painter_test.dart` (6 tests).

### Validated
- `fvm flutter test` — 134/134 ✅
- `fvm flutter analyze` — No issues found ✅

## [1.5.0] - 2026-05-16
### Added
- `DifficultyEngine` (Domain Layer) — sistem adaptiv niveli; level-up pas 3 sesionesh ≥90%, level-down pas <50%. 20 unit tests.
- `SessionTracker` (Hive) — sliding window 5 sesionesh për operacion; ruan dhe lexon `DifficultyLevel` aktual per operacion.
- `_NeonLevelChip` widget në `ChallengeScreen` — shfaq "Niveli 1/2/3" me ngjyrë dinamike (cyan/gold/neon-orange).
- Animacion SnackBar level-up në fillim të sesionit kur ndodh level-up.
- `ChallengeConfig.difficultyLevel` (zvëndëson `int level`) — përdor `DifficultyLevel.maxNumber` për diapazoning numerave.
- `ChallengeState.difficultyLevel` — UI lexon nivelin aktual nga state.
- `SessionTracker.init()` i thirrur në `main()` pas `UserProgressStorage.initialize()`.

### Changed
- `ChallengeScreen` nuk pranon më `level: int` — niveli llogaritet automatikisht nga `SessionTracker` + `DifficultyEngine` në `initState`.
- `ChallengeScreen` regjistron sesionin dhe ruan nivelin e ri në Hive kur sfida përfundon.

### Deferred
- Android Release Signing (B-01/B-02/B-03) — shtyer pas Sprint 9.
- Integration test C-02 — shtyer.

### Validated
- `fvm flutter test` — 118/118 ✅
- `fvm flutter analyze` — No issues found ✅

## [1.4.0] - 2026-05-16
### Added
- `DistractorEngine` (Domain Layer) — gjeneron gabime pedagogjike tipike për 4 operacionet bazë (mbledhje, zbritje, shumëzim, pjesëtim). 11 unit tests.
- Sfida "Gjej X-in" (`MissingXChallengeScreen`) — 3 lloje ekuacionesh (`addMissingAddend`, `multMissingFactor`, `subMissingSubtrahend`) me `?` cyan/bold.
- Dashboard card "Gjej X-in" — aksesueshe nga ekrani kryesor (mobile + master-detail).
- Modaliteti Invers i Tabelave — zbritja si `? + b = a`, pjesëtimi si `? × b = a`, toggle `_InverseModeToggle` chip në header. 21 unit tests.
- `TableQuestion` model dhe `isInverseMode` në `TablesState`/`TablesNotifier`.
- `MissingXQuestion` model + `MissingXType` enum.
- `MissingXGenerator` (Domain Layer) me 4 opsione plausible. 9 unit tests.
- `MissingXNotifier` me Riverpod `autoDispose.family`.
- `GeometryCalculationType` enum (`area | perimeter`) — drejtkëndëshi dhe katrori gjenerojnë të dy llojet.
- `GeometryHintChip` shfaq formulën e saktë pas 2 sekondash.

### Fixed
- `GeometryShapePainter`: drejtkëndëshi respekton raportin gjerësi/lartësi (D-01).
- `geometry_provider.dart`: hequr `_buildOptions` i papërdorur.
- Import path i gabuar në `missing_x_provider.dart`.

### Validated
- `fvm flutter test` — 98/98 ✅
- `fvm flutter analyze` — No issues found ✅

## [1.2.0] - 2026-05-08
### Added
- Zgjerimi i sfidës së gjeometrisë me forma të reja: rreth dhe paralelogram.
- Generator i dedikuar i pyetjeve të gjeometrisë në domain: `geometry_question_generator.dart`.
- Parser i dedikuar i ushtrimeve për Gamify në domain: `gamify_parser.dart`.
- Unit tests të rinj për parser-in e Gamify dhe generatorin e gjeometrisë.

### Changed
- `GeometryChallengeScreen` tani përdor generator domain në vend të logjikës inline.
- `GeometryShapePainter` renderon edhe format e reja të gjeometrisë.
- Tekstet UI kryesore të `LessonsPage` dhe `GamifyExerciseScreen` u centralizuan në `app_text.dart`.

### Validated
- `fvm flutter analyze` kalon pa issue.
- `fvm flutter test` kalon me sukses pas shtimit të testeve të reja.

## [1.3.0] - 2026-05-07
### Added
- Tablet landscape layouts 2-kolona për Progress, Lessons dhe Geometry (`AdaptiveScaffold`).
- OCR fallback pipeline: `InputImage.fromFilePath` → `fromFile` → variante të preprocesimit.
- Preprocesim i imazhit me `image ^4.2.0`: grayscale+kontrast, crop qendror, luminance threshold.
- Parser simbolik për `a^2±b^2` (identiteti i diferencës së katrorëve) dhe `x^2+bx+c=0` (faktorizim kuadratik).
- Solver kuadratik me faktorizim: `x^2+5x+6 → (x+2)(x+3)=0`.
- 3 mesazhe të reja lokalizimi shqip: `gamifySymbolicSolution`, `gamifyDifferenceOfSquares`, `gamifyQuadraticEquation`.
- Logging diagnostik i OCR pipeline (`[OCR] blocks`, `rawText`, `extractedEquation`).

### Changed
- `_ActionTile` në dashboard tani është responsive (padding 12→8, icon 54→48, `maxLines:2`) — parandalon overflow.
- `_normalizeEquationText()` kaloi te `replaceAllMapped` për konvertimin `a2→a^2` (Dart capture groups).
- `AndroidManifest.xml`: shtim i `<meta-data>` për `com.google.mlkit.vision.DEPENDENCIES = "ocr"`.
- `.gitignore`: shtohen `key.properties`, `*.keystore`, `*.jks` dhe artifakte toolchain.

### Fixed
- RenderFlex overflow 6.1px në `_ActionTile` quick-actions të dashboard.
- `replaceAll` me capture groups (Dart nuk interpolon `$1` — zëvendësuar me `replaceAllMapped`).

### Known Limitations
- OCR (`blocks=0`) nuk mbështet shkrim dore — kufizim i ML Kit; kërkon Google Vision API cloud për v2.

## [1.2.0] - 2026-05-07
### Added
- Integrimi i `flutter_riverpod ^2.6.1`; `ProviderScope` si rrënjë e aplikacionit.
- Providerë `StateNotifier`: `ChallengeProvider`, `GeometryProvider`, `ProgressProvider`, `TablesProvider`.
- `AdaptiveScaffold`: `NavigationRail` (≥600px) dhe `BottomNavigationBar` (<600px) automatikisht.
- Master-Detail layout me `ShimmerLoading` për Progress dhe Lessons.
- `ProGuard rules` (`proguard-rules.pro`) dhe korrigjim i R8 release build.
- `hive_flutter ^1.1.0` për persistencë lokale.

### Changed
- `NavigationRail` gjithmonë `extended: true` kur gjerësia ≥600px.
- `TabBar` pa clipping në detail pane (tema globale e `clipBehavior`).
- Package name konfirmuar si `com.mathlingo.app`.

### Fixed
- R8 shrinking dështonte për shkak të `google_mlkit_text_recognition` reflection — zgjidhur me ProGuard rules.

## [1.1.0] - 2026-05-07
### Added
- Modularizimi i plotë i ekraneve në `lib/features/` për dashboard, sfida, rezultate dhe gjeometri.
- Komponentët shared në `lib/shared/` për navigation, progress, cards dhe painter-a.
- Routing bazë i aplikacionit përmes `AppRoutes` dhe `main.dart` minimal.

### Changed
- Package name updated from `com.example.mathlingo` to `com.mathlingo.app` (Android & iOS).
- `main.dart` tani përmban vetëm bootstrap-in e aplikacionit, temën dhe konfigurimin bazë të route-ve.
- Testet e widget-eve u përditësuan sipas strukturës së re modulare.

### Fixed
- Validimi me `fvm flutter analyze` dhe `fvm flutter test` kalon pas modularizimit të Sprint 2.

## [1.0.0+1] - 2026-05-07 (Aktuale)
### Added
- Struktura bazë e Dashboard me 4 tabs.
- Sfida Aritmetike (Mbledhje, Zbritje, Shumëzim, Pjesëtim).
- Sfida Gjeometrike me CustomPainter.
- Moduli Gamify (Input manual dhe Media Picker).
- Sistemi i temës Cosmic Dark dhe Glassmorphism.

### Fixed (Planned - Sprint 1)
- Bug-i i rezultateve negative te tabelat e zbritjes.
- Bug-i i pjesëtimit të truncuar (`~/`) te tabelat e pjesëtimit.
- Mbivendosja e SnackBar me BottomNav.

### Security
- Ndryshimi i signing nga debug në release-ready configuration (Planned).