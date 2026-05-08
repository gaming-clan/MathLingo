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

## Hardening & Release Ops
- [x] **Task 1:** Credentials signing të shtuara në `.gitignore` (key.properties, *.keystore).
- [x] **Task 2:** R8/ProGuard release build i korrigjuar (commit a8c2c92).
- [ ] **Task 3:** Konfigurimi final i Android Release Signing për Play Store.
- [ ] **Task 4:** Verifikimi i AAPT2 në mjedise ARM64 Linux.