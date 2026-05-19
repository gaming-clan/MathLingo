# 🏃 Sprint Tracker

## Sprint 1: Stabilizimi & Korrektësia (Opsioni A) - DONE
- [x] **Task 1:** Konfigurimi i FVM (Flutter 3.41.9).
- [x] **Task 2:** Korrigjimi i logjikës së Tabelave (Zbritja & Pjesëtimi).
- [x] **Task 3:** Fix SnackBar UI (Floating & Margins).
- [ ] **Task 4:** Konfigurimi i Android Release Signing. *(Shtyrë për hardening pas Sprint 3)*

## Sprint 2: Modularizimi & Arkitektura (Opsioni B) - DONE
- [x] **Task 1:** Krijimi i strukturës së re të folderave.
- [x] **Task 2:** Nxjerrja e Modeleve (MathQuestion, Operation, etj).
- [x] **Task 3:** Nxjerrja e Shared Widgets (GlassPanel, CosmicButton, navigation, painter).
- [x] **Task 4:** Refaktorimi i `main.dart` (Ndarja e ekraneve).
- [x] **Task 5:** Validimi me `fvm flutter analyze` dhe `fvm flutter test`.

## Sprint 3: Shkallëzimi & Inteligjenca - DONE
- [x] **Task 1:** Lokalizimi zyrtar (ARB files).
- [x] **Task 2:** Integrimi i ML Kit OCR (Real Image Recognition).
- [x] **Task 3:** Persistenca lokale e progresit (Hive).

## Sprint 4: State Management & Hardening - DONE
- [x] **A1:** Integrimi i `flutter_riverpod ^2.6.1`; wrap-imi i app-it me `ProviderScope`.
- [x] **A2:** Krijimi i providerëve bazë: `ChallengeProvider`, `GeometryProvider`, `ProgressProvider`, `TablesProvider`.
- [x] **B1:** Implementimi i `AdaptiveScaffold` (NavigationRail ≥600px, BottomNav <600px).
- [x] **B2:** NavigationRail gjithmonë extended ≥600px; TabBar pa clipping në detail pane.
- [x] **C1:** Master-Detail layout me shimmer loading për ekranet e progresit dhe mësimeve.
- [x] **C2:** Korrigjimi i R8 (ProGuard) release build; shtimi i `proguard-rules.pro`.
- [x] **C3:** Persistenca lokale me Hive (`hive ^2.2.3`, `hive_flutter ^1.1.0`).

## Sprint 5: Tablet Landscape Layouts & OCR Hardening - DONE
- [x] **A1:** Layout landscape për ekranin e Progresit (Master-Detail 2-kolona).
- [x] **A2:** Layout landscape për ekranin e Mësimeve (detail pane expandable).
- [x] **A3:** Layout landscape për ekranin e Gjeometrisë (`GeometryChallengeScreen`).
- [x] **B1:** Diagnostikë e plotë e OCR pipeline (`debugPrint` logs: blocks, rawText, extractedEquation).
- [x] **B2:** Fallback OCR: `InputImage.fromFilePath` → `fromFile` → variante të preprocesimit.
- [x] **B3:** Preprocesim i imazhit me paketën `image`: grayscale+kontrast, crop qendror, luminanceThreshold.
- [x] **C1:** Shtesa në parser për shprehje simbolike: `a^2+b^2` (gamifySymbolicSolution), `a^2-b^2` (gamifyDifferenceOfSquares).
- [x] **C2:** Solver kuadratik: detektim `x^2+bx+c=0` → faktorizim `(x+p)(x+q)=0`.
- [x] **C3:** Lokalizim shqip për zgjidhjet simbolike dhe kuadratike (3 mesazhe të reja në ARB).
- [x] **D1:** Fix overflow i dashboard quick-action tiles (`_ActionTile` responsive: padding, icon size, maxLines:2).
- [x] **D2:** Ignore signing credentials & toolchain artifacts (`.gitignore` i përditësuar). *(D2 manual QA e shtyrë)*

## Sprint 6: UX Layout Stabilizimi - DONE
- [x] **T01:** Tablet portrait breakpoint me bazë gjerësie (`AdaptiveLayout.isTablet` dhe scaffold adaptive).
- [x] **T02:** ChallengeScreen layout compact (kartë pyetjeje adaptive + grid përgjigjesh 2x2 në mobile).
- [x] **T03:** BottomNav safe-area/inset handling për gesture bar Android.
- [x] **T04:** ResultsScreen layout adaptive (mascot responsive + buton `Vazhdo` gjithmonë i dukshëm).
- [x] **T05:** Renditja e Dashboard mobile: `Veprime të Shpejta` para `Sfidës`.

## Sprint 7: Code & Docs Sync + Thellimi Pedagogjik - DONE
### Sprint 7a — Code & Docs Sync
- [x] **Task 1:** Krijimi i branch-it të sprintit (`fix/sprint-7-code-doc-sync`).
- [x] **Task 2:** Nxjerrja e parser-it të Gamify në domain (`gamify_parser.dart`).
- [x] **Task 3:** Shtimi i unit tests për parser-in e Gamify.
- [x] **Task 4:** Zgjerimi i sfidës së gjeometrisë me forma të reja (rreth, paralelogram).
- [x] **Task 5:** Nxjerrja e generatorit të pyetjeve të gjeometrisë në domain.
- [x] **Task 6:** Shtimi i unit tests për generatorin e gjeometrisë.
- [x] **Task 7:** Validimi me `fvm flutter analyze` dhe `fvm flutter test`.
- [x] **Task 8:** Finalizimi i sinkronizimit të dokumentacionit (README + SSOT + changelog).

### Sprint 7b — Thellimi Pedagogjik & Logjika Matematikore (v1.4.0)
- [x] **D-02:** Enum `GeometryCalculationType` (area/perimeter) — drejtkëndësh dhe katror gjenerojnë të dy llojet.
- [x] **D-03:** `GeometryHintChip` shfaq formulën e saktë pas 2 sekondash.
- [x] **D-01:** `GeometryShapePainter` respekton raportin gjerësi/lartësi të drejtkëndëshit.
- [x] **B-01:** `DistractorEngine` si klasë pure Dart në Domain Layer.
- [x] **B-02:** Gabimet tipike pedagogjike per operacion (carry, tabela ngjitur, inversim).
- [x] **B-03:** 11 unit tests — 500 pyetje/operacion, 0 duplicate, shpërndarje statistikore.
- [x] **C-01:** Model `MissingXQuestion` + enum `MissingXType`.
- [x] **C-02:** `MissingXGenerator` në Domain Layer me 4 opsione plausible.
- [x] **C-03:** `MissingXChallengeScreen` — `?` cyan/bold, Riverpod StateNotifier.
- [x] **C-04:** Kartë "Gjej X-in" në dashboard (mobile + master-detail).
- [x] **A-01:** Tabela Zbritje shfaqet si `? + b = a` në modalitetin invers.
- [x] **A-02:** Tabela Pjesëtim shfaqet si `? × b = a` (plotëso shumëzimin).
- [x] **A-03:** Model `TableQuestion` + `isInverseMode` në `TablesState`/`TablesNotifier`.
- [x] **A-04:** `_InverseModeToggle` chip në header të tabelave.
- [x] **A-05:** 21 teste kalojnë — modaliteti klasik/invers, konsistencë rezultatesh.
- [x] **Final:** `fvm flutter test` 98/98 ✅ · `fvm flutter analyze` 0 issues ✅

## Hardening & Release Ops
- [x] **Task 1:** Credentials signing të shtuara në `.gitignore` (key.properties, *.keystore).
- [x] **Task 2:** R8/ProGuard release build i korrigjuar (commit a8c2c92).
- [ ] **Task 3:** Konfigurimi final i Android Release Signing për Play Store.
- [ ] **Task 4:** Verifikimi i AAPT2 në mjedise ARM64 Linux.

---

## Sprint 8: Adaptiviteti & DifficultyEngine - DONE
**Versioni:** v1.5.0 | **Branch:** `feature/sprint-8-difficulty-engine`

### Track A — DifficultyEngine Adaptiv
- [x] **A-01:** `DifficultyEngine` klasë pure Dart — level-up pas 3 sesionesh ≥90%, level-down pas 3 sesionesh <50%.
- [x] **A-02:** `SessionTracker` me Hive — sliding window 5 sesionesh për operacion; `getCurrentLevel`/`setCurrentLevel`.
- [x] **A-03:** Integrimi me `ChallengeProvider` — `ChallengeConfig.difficultyLevel`, `maxNumber` nga `DifficultyLevel`; regjistrim sesioni në `ChallengeScreen`.
- [x] **A-04:** `_NeonLevelChip` widget (cyan/gold/neon-orange) në `ChallengeScreen`; SnackBar level-up me `addPostFrameCallback`.

### Track B — Android Release Signing — SHTYER
- [ ] **B-01 BLLOKUES:** Gjenero `keystore` release; konfigurim `key.properties`; update `build.gradle.kts`. *(Shtyer — kryhet pas Sprint 9)*
- [ ] **B-02 BLLOKUES:** Verifiko `fvm flutter build appbundle --release`. *(Shtyer)*
- [ ] **B-03:** Verifiko AAPT2 ARM64 Linux (bug B005). *(Shtyer)*

### Track C — Unit Tests
- [x] **C-01:** 20 unit tests `DifficultyEngine` (level-up, level-down, stabil, extension `maxNumber`/`label`).
- [ ] **C-02:** Integration test sesion → SessionTracker → DifficultyEngine → nivel i ri. *(Shtyer)*

- [x] **Final:** `fvm flutter test` 118/118 ✅ · `fvm flutter analyze` 0 issues ✅

---

## Sprint 9: Fraksionet & Vizualizimi Konceptual - DONE
**Versioni:** v1.5.1 | **Branch:** `feature/sprint-9-fractions`

### Track A — Moduli i Fraksioneve
- [x] **A-01:** Model `FractionQuestion` në Domain Layer (numerator, denominator, answer, options, visualType).
- [x] **A-02:** `FractionGenerator` — fraksione të mbuluar: ½, ⅓, ¼, ¾, ⅔, ⅛, ⅜, ⅝, ⅞.
- [x] **A-03:** `FractionPainter` (CustomPainter) — pie dhe bar vizualizim; ngjyra adaptive Cosmic.
- [x] **A-04:** `FractionChallengeScreen` si feature e ndarë (`lib/features/fraction/`); 4 pyetje, +15 pikë.
- [x] **A-05:** Kartë "Fraksionet" në dashboard + ARB strings shqip për fraksionet.

### Track B — Vizualizimi Grilë Shumëzimi
- [x] **B-01:** `MultiplicationGridPainter` — grilë N×M me animacion sekuencial (300ms mes kolonave).
- [x] **B-02:** Buton "Shfaq Grilën" në `ChallengeScreen` për shumëzim.
- [x] **B-03:** Widget tests për `FractionPainter` dhe `MultiplicationGridPainter`.

---

## Sprint 10A: Familja, Privatësia & Gamifikimi Bazë — DONE
**Versioni:** v1.6.0 | **Branch:** `feature/sprint-10a-family-gamification`

### Track A — Sistemi Familjar
- [x] **A-01:** Model `ChildProfile` (`lib/models/`) — id, name, avatarEmoji, totalPoints, sessionsCompleted, operationScores; Hive-persisted me `toMap()`/`fromMap()`.
- [x] **A-02:** Model `FamilyProfile` — lista `ChildProfile`, `activeChildId`, PIN-hash.
- [x] **A-03:** `FamilyProfileService` — `createChild`, `switchChild`, `getActiveChild`, `verifyPin`, `setPin`; Hive box `'family_profile'`.
- [x] **A-04:** `FamilyProvider` — Riverpod `StateNotifierProvider`; shpërndan profil aktiv dhe listë fëmijësh.
- [x] **A-05:** `FamilySetupScreen` — krijimi i profilave fëmijësh me avatar emoji.
- [x] **A-06:** `FamilySwitcherScreen` — ndërrimi i profilit aktiv fëmije.
- [x] **A-07:** `ParentPinDialog` — dialog PIN-mbrojtje (verifikimi + krijimi) me dy variante.
- [x] **A-08:** `ParentReportScreen` — raport progresi: pikë totale, sesione, saktësi për operacion.

### Track B — Privatësia & Consent
- [x] **B-01:** `ConsentFlowScreen` — flow i pranimit GDPR; parakusht i inicializimit Firebase.
- [x] **B-02:** `PrivacyPolicyScreen` — politika e brendshme e privatësisë (GDPR-compliant).
- [x] **B-03:** `DeleteAllDataScreen` — fshirje konfirmuese e të gjitha të dhënave lokale.
- [x] **B-04:** `SettingsScreen` bazë me seksione: Profili, Privatësia.

### Track C — Gamifikimi Bazë
- [x] **C-01:** Model `Achievement` — id, title, description, icon, category, unlockedAt.
- [x] **C-02:** `AchievementService` — `unlockAchievement`, `getAll`, `deleteAllData`; Hive persist; integrate me challenge results.
- [x] **C-03:** `AchievementProvider` — Riverpod `StateNotifierProvider`.
- [x] **C-04:** `BadgeDisplayScreen` — GridView responsive (3/4 kolona) me badge emoji dhe titull.
- [x] **C-05:** `BadgeNotificationOverlay` — overlay njoftim kur shkyçet badge i ri.

- [x] **Final:** `fvm flutter test` 134/134 ✅ · `fvm flutter analyze` 0 issues ✅

---

## Sprint 11: Gamifikimi i Avancuar — DONE
**Versioni:** v1.7.0 | **Branch:** `feature/sprint-11-advanced-gamification`

### Track A — Audio & Haptik
- [x] **A-01:** `AudioService` — `playCorrect`, `playWrong`, `playLevelUp`, `playAchievement` me `audioplayers: 6.0.0`.
- [x] **A-02:** `HapticService` — `lightImpact`, `mediumImpact`, `heavyImpact`, `success`, `error` me `HapticFeedback` native.
- [x] **A-03:** Integrimi i Audio + Haptic me `ChallengeScreen` dhe events kryesore.

### Track B — Eksport & Ndaj
- [x] **B-01:** `DataExportService` — eksport CSV sesionesh dhe progresi.
- [x] **B-02:** `share_plus: ^13.1.0` — ndarje skedarësh.
- [x] **B-03:** `package_info_plus: ^10.1.0` — informacion versioni.

### Track C — Leaderboard & Settings finalizim
- [x] **C-01:** `LeaderboardScreen` — renditje anëtarësh familjes sipas pikëve totale.
- [x] **C-02:** `SettingsScreen` zgjeruar me seksion Gamifikimi (audio on/off, haptic on/off).

- [x] **Final:** `fvm flutter test` 134/134 ✅ · `fvm flutter analyze` 0 issues ✅

---

## Sprint 10B: Firebase Auth & Cloud Sync — DONE
**Versioni:** v1.8.0 | **Branch:** `main` (merged direkt)

### Track A — Firebase Setup
- [x] **A-01:** `firebase_core: ^3.4.0`, `firebase_auth: ^5.2.0`, `cloud_firestore: ^5.3.0` në `pubspec.yaml`.
- [x] **A-02:** `flutterfire configure --project=mathlingo-90084` — generoi `firebase_options.dart` + `google-services.json` + `firebase.json`.
- [x] **A-03:** `android/app/build.gradle.kts` — Google Services plugin + release signing nga `key.properties`.
- [x] **A-04:** `android/settings.gradle.kts` — `com.google.gms.google-services v4.4.2`.
- [x] **A-05:** `FirebaseInitService` — inicializim lazy pas consent; `isInitialized` flag; `reset()` për teste.

### Track B — Auth
- [x] **B-01:** Model `ParentAccount` — `uid`, `email`, `createdAt`, `cloudSyncEnabled`, `lastSyncAt`; Hive box `'parent_account'`.
- [x] **B-02:** `AuthService` — `signUp`, `signIn`, `signOut`, `deleteAccount`; `_mapFirebaseError`; validim email/password.
- [x] **B-03:** Sealed `AuthState` (`Initial | Loading | Authenticated | Unauthenticated | Error`).
- [x] **B-04:** `AuthNotifier` + `authProvider`, `isAuthenticatedProvider`, `currentParentProvider`.
- [x] **B-05:** `ParentSignUpScreen` + `ParentSignInScreen` — `ConsumerStatefulWidget`, `ref.listen<AuthState>`, `GlassPanel`, `CosmicButton`.

### Track C — Cloud Sync
- [x] **C-01:** `FirestoreSchema` — konstantet e path-eve Firestore.
- [x] **C-02:** `SyncService` — `syncChildInfo`, `syncChildProgress`, `pullChildInfo`, `deleteAllUserData` (GDPR Art. 17).
- [x] **C-03:** `SettingsScreen` — `_CloudSyncSection` me shfaqje email + "Dil" + "Fshi Llogarinë".
- [x] **C-04:** `DeleteAllDataScreen` — pas fshirjes lokale, thirr `deleteAllUserData(uid)` + `signOut()` nëse Firebase aktiv.

### Track D — ARB Strings
- [x] **D-01:** 30+ strings shqip të reja: `authSignUpTitle`, `authSignInTitle`, error keys, sync keys, delete/signout keys.

- [x] **Final:** `fvm flutter test` 134/134 ✅ · `fvm flutter analyze` 0 issues ✅

---

## Stabilization v1.9.0: UI Polish Final — DONE

- [x] **B012:** `parent_pin_dialog.dart` — `hintStyle: color: Colors.white38` për të dy fushat PIN.
- [x] **B013:** `fraction_challenge_screen.dart` — hequr `Text('${q.numerator}/${q.denominator}')` nga UI.
- [x] **B014:** `badge_display_screen.dart` — GridView responsive (`crossAxisCount: isTablet ? 4 : 3`); emoji `fontSize: 28`.

- [x] **Final:** `fvm flutter test` 134/134 ✅ · `fvm flutter analyze` 0 issues ✅

---

## 🚀 ROADMAP GO-TO-MARKET (v2.0.0)

> Bazuar në gjendjen aktuale v1.9.0 Release Candidate.
> Firebase Auth aktiv ✅ · 134 teste ✅ · 0 issues analyze ✅

---

## Sprint 12: Raportet e Prindërve (Parental Reports) — IN PROGRESS
**Versioni target:** v1.10.0 | **Branch:** `feature/sprint-12-parental-reports`

### Track A — Vizualizimi i të Dhënave Firestore
- [x] **A-01:** `SyncService.pullWeeklyStats(uid, childId)` — lexim historiku 7 ditë nga Firestore (commit e5514a5).
- [x] **A-02:** `ParentReportScreen` me grafik pikësh (BarChart) dhe saktësie (LineChart) — `fl_chart` (commit 77fcf6a).
- [x] **A-03:** Krahasim mes profileve fëmijësh — `_ChildReportCard` me pikë totale, saktësi, sesione.
- [x] **A-04:** Seksion "Aktiviteti i Fundit" — `_RecentActivitySection` me 5 ditët e fundit: datë, pikë, saktësi, sesione.

### Track B — Sinkronizimi Automatik i Progresit
- [x] **B-01:** Thirr `SyncService.updateDailyStats()` automatikisht pas çdo sesioni të përfunduar në `ChallengeScreen` (fire-and-forget, nëse Firebase aktiv + autentikuar).
- [x] **B-02:** Indicator "Sinkronizuar Para X min" në `SettingsScreen._CloudSyncSection` — shfaq `lastSyncAt` nga `ParentAccount`; `AuthService.updateLastSyncAt()` + `AuthNotifier.refreshAccount()`.
- [x] **B-03:** Menaxhim graceful i gabimeve rrjeti — `_canSync()` guard + try/catch fire-and-forget; gabimi nuk ndikon në lojë.

### Track C — Firestore Security Rules
- [x] **C-01:** Rregulla Firestore: `users/{uid}/**` aksesueshe vetëm nga `request.auth.uid == uid` (commit 77fcf6a).
- [ ] **C-02:** Validim me Firebase Emulator. *(Manual QA — shtyer)*

### Validation
- [x] `fvm flutter test` 134/134 ✅
- [x] `fvm flutter analyze` 0 issues ✅

---

## Sprint 11.5: Bug-Fix & Polish — DONE
**Versioni:** v1.10.1 | **Branch:** `fix/sprint-11-5-bugfix-polish`

### Bug Fixes
- [x] **B-01:** `simple_tables.dart` — Korrigjim `equationText` dhe `badgeSymbol` për shumëzim invers (`?×n=result`) dhe pjesëtim invers (`result÷?=tableNum`). Rrethi tregon vlerën e saktë (selectedTable për shumëzim, num/divisor për pjesëtim).
- [x] **B-02:** `simple_tables.dart` — Mbledhja kalon `isInverseMode: isInverseMode` (ishte hardcoded `false`). `_buildVisibleEntries` gjeneron hyrje inverse për mbledhje (`?+n=tableNum → result=tableNum-n`).
- [x] **B-03:** `badge_notification_overlay.dart` — `FilledButton` (sfond rozë i çelët, kontrast i ulët) zëvendësohet me `CosmicButton` (gradient magenta→violet, tekst i bardhë).
- [x] **B-04:** `simple_tables.dart` — Shtim padding `EdgeInsets.fromLTRB(8,10,8,0)` brenda kartave tabelave.
- [x] **B-05:** ~~Emoji i mungueshëm tek `addition_starter`~~ — Ishte tashmë `emoji: '➕'` → pa ndryshim.
- [x] **B-06:** ~~Leaderboard tregon vetëm profilin aktiv~~ — Ishte tashmë duke treguar të gjithë fëmijët → pa ndryshim.
- [x] **B-07:** `simple_tables.dart` — `fontSize: 16`, `maxLines: 2`, `overflow: TextOverflow.ellipsis` për formulën e kartës.
- [x] **B-08:** `simple_tables.dart` — `shadow: Shadow(black54, blur:4)` mbi tekstin e formulës për kontrast mbi fondacione me ngjyra.
- [x] **`_buildVisibleEntries` rindërtim inverse:** Pjesëtimi invers → 10 hyrje (`tableNum×mult`), mbledhja invers → `tableNum` hyrje (`tableNum-n`).

### Unit Tests
- [x] **T-01…T-19:** `test/features/tables/tables_inverse_mode_test.dart` — 19 teste (rifaqosur nga 12 → 19): shumëzim invers ekuacion+rreth, pjesëtim invers ekuacion+rreth+entries, mbledhje invers ekuacion+entries+badge, regresion klasik.

### Validation
- [x] `fvm flutter test` 141/141 ✅
- [x] `fvm flutter analyze` 0 errors/warnings ✅

---

## Sprint 13: Store Submission (Përgatitja e Lansimit) — PLANNED
**Versioni target:** v1.11.0

### Qëllimi
Finalizimi i të gjitha aseteve dhe konfiguracioneve të nevojshme për publikim në Google Play Store.

### Track A — Asetet e Play Store
- [ ] **A-01:** Screenshots Android (telefon + tablet) — minimum 4 screenshot; tekst i qartë shqip.
- [ ] **A-02:** Feature Graphic (1024×500 px) — branding Cosmic Dark + "MathLingo" + tagline shqip.
- [ ] **A-03:** App Icon 512×512 px pa shtresë transparente — upload në Play Console.
- [ ] **A-04:** Përshkrimi i shkurtër (≤80 karaktere) dhe i gjatë (≤4000 karaktere) shqip në Play Console.

### Track B — Konfigurimi Teknik Final
- [ ] **B-01:** `pubspec.yaml`: `version: 2.0.0+1`.
- [ ] **B-02:** `fvm flutter build appbundle --release` — verifikim AAB me `key.properties` + `mathlingo-release.jks`.
- [ ] **B-03:** Content Rating Questionnaire — kategori: Edukative / Fëmijë 6-12 vjeç.
- [ ] **B-04:** Data Safety Form — deklarim `firebase_auth`, `cloud_firestore`, `image_picker`; opt-in, të dhëna familjare.
- [ ] **B-05:** Target Audience — "Children and Families" me verifikim prindi (PIN) të dokumentuar.

### Track C — QA Final
- [ ] **C-01:** Smoke test mbi pajisje fizike Android — onboarding → sfidë → arritje → cloud sync.
- [ ] **C-02:** Flows Firebase Auth: regjistrim, hyrje, dalje, fshirje llogarie.
- [ ] **C-03:** Verifikim `PrivacyPolicyScreen` dhe `ConsentFlowScreen` — tekste shqip korrekte.
- [ ] **C-04:** `fvm flutter test` — zero regresione.

### Validation
- [ ] `fvm flutter build appbundle --release` → `build/app/outputs/bundle/release/app-release.aab` ✓
- [ ] Play Console → Internal Testing track me AAB të ngarkuar ✓

---

## 🏆 v2.0.0 — Lansimi Zyrtar (Go-to-Market)
**Target:** Google Play Store — Shqipëri

### Kriteret e Lansimit (Definition of Done)
- [ ] Sprint 12 dhe Sprint 13 — 100% të detyrave ✅
- [ ] AAB Release i ndërtuar me signing real ✅
- [ ] Play Console → Production track i aprovuar nga Google ✅
- [ ] Firebase project `mathlingo-90084` — Firestore Security Rules deployed ✅
- [ ] URL Play Store publik i disponueshëm ✅

### Pas Lansimit (v2.x Backlog)
- iOS submission (App Store Connect + `GoogleService-Info.plist`).
- Lokalizim anglisht (locale e dytë për zgjerim tregu).
- Integration tests end-to-end.
- OCR shkrim dore me Google Vision API cloud.
- Analytics dhe telemetri sesionesh.