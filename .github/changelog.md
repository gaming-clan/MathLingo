# 📝 Changelog - MathLingo

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

## [1.1.0] - 2026-05-07
### Added
- Modularizimi i plotë i ekraneve në `lib/features/` për dashboard, sfida, rezultate dhe gjeometri.
- Komponentët shared në `lib/shared/` për navigation, progress, cards dhe painter-a.
- Routing bazë i aplikacionit përmes `AppRoutes` dhe `main.dart` minimal.

### Changed
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