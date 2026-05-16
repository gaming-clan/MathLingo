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

## Sprint 8: Adaptiviteti & Android Release Signing - IN PROGRESS
**Versioni:** v1.5.0 | **Branch:** `feature/sprint-8-difficulty-engine`

### Track A — DifficultyEngine Adaptiv
- [ ] **A-01:** `DifficultyEngine` si klasë pure Dart në Domain Layer. Level-up pas 3 sesionesh ≥90%, level-down pas 3 sesionesh <50%.
- [ ] **A-02:** `SessionTracker` me Hive — sliding window 5 sesionesh për çdo operacion.
- [ ] **A-03:** Integro `DifficultyEngine` me `ChallengeProvider` dhe `GeometryProvider`.
- [ ] **A-04:** UI `NeonChip` "Niveli 1/2/3" në `ChallengeScreen` + animacion level-up.

### Track B — Android Release Signing
- [ ] **B-01 BLLOKUES:** Gjenero `keystore`, konfigurim `key.properties`, update `build.gradle.kts`.
- [ ] **B-02 BLLOKUES:** Verifiko `fvm flutter build appbundle --release` me certificate release.
- [ ] **B-03:** Verifiko AAPT2 ARM64 Linux (bug B005). Mbyll bug B005.

### Track C — Unit Tests & QA
- [ ] **C-01:** Unit tests `DifficultyEngine` (level-up, level-down, stabilitet).
- [ ] **C-02:** Integration test sesion → SessionTracker → DifficultyEngine → nivel i ri.