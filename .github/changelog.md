# 📝 Changelog - MathLingo

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