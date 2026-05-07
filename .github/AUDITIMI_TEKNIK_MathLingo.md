# Auditim Teknik i MathLingo

## Fusha e auditimit

- Auditimi bazohet në kodin aktual të projektit, screenshot-et e dorëzuara dhe verifikime reale në mjedisin lokal.
- Verifikimet e ekzekutuara:
  - `flutter pub outdated`
  - `flutter test`
  - `flutter analyze`
  - `flutter --version`
  - `flutter doctor -v`

## Përmbledhje ekzekutive

- Projekti ka bazë të mirë UI dhe një drejtim të qartë vizual, por ka disa bllokues teknikë që duhen adresuar përpara se aplikacioni të konsiderohet i qëndrueshëm për zhvillim të vazhdueshëm ose publikim.
- Bllokuesi kryesor i dokumentuar historikisht është mospërputhja e arkitekturës së AAPT2 në hoste ARM64 Linux. Megjithatë, në mjedisin aktual të auditimit, problemi më i menjëhershëm nuk është AAPT2, por mospërputhja e SDK-së lokale me kërkesën e projektit.
- Ka edhe një problem real të saktësisë pedagogjike te tabelat matematikore: pjesëtimi përdor pjesëtim të plotë dhe zbritja prodhon rezultate negative për tabelat bazë. Kjo është më shumë se çështje UX; është çështje korrektësie funksionale.
- Arkitektura aktuale është ende e menaxhueshme për një MVP, por nuk është e shkallëzueshme: `main.dart` është monolit, tekstet janë hardcoded dhe gjendja menaxhohet kryesisht me `StatefulWidget` + `setState`.

## Prioritetet

### Kritike

| Gjetja | Ndikimi | Evidenca | Rekomandimi |
|---|---|---|---|
| SDK lokale nuk përputhet me projektin | `flutter test` dhe `flutter analyze` nuk nisen; pipeline lokale QA është e bllokuar | `pubspec.yaml` kërkon `sdk: ^3.9.2`; mjedisi lokal raporton Flutter 3.32.5 / Dart 3.8.1 | Përditëso Flutter në 3.41.9 ose ekuivalent që sjell Dart >= 3.9.2 para çdo pune tjetër |
| Mospërputhja AAPT2 ARM64 vs x86_64 në hoste ARM64 Linux | Android build dështon në ato hoste pavarësisht se kodi është valid | Dokumentuar në analizat ekzistuese si `Cannot find '/lib64/ld-linux-x86-64.so.2' loader` | Për zhvillim ditor në ARM64 Linux zgjidhja më efikase është multi-lib setup; Docker rezervoje për CI ose ambiente të paqëndrueshme |
| Pjesëtimi në tabela është matematikisht i gabuar për mësim bazë | Nxënësi sheh rezultate të prera me `~/`, p.sh. `12 ÷ 5 = 2` | `lib/simple_tables.dart` përdor `_buildOperationTable('Pjesëtim', (a, b) => a ~/ b, Colors.blue)` | Kufizo tabelën e pjesëtimit vetëm në çifte që japin rezultat të plotë ose shfaq thyesa/decimale sipas nivelit |
| Release build përdor debug signing | Rrezik sigurie dhe build jo i përshtatshëm për publikim | `android/app/build.gradle.kts` konfiguron `signingConfig = signingConfigs.getByName("debug")` për `release` | Krijo `keystore` release dhe ndaji kredencialet nga kodi me `key.properties` + CI secrets |

### Mesatare

| Gjetja | Ndikimi | Evidenca | Rekomandimi |
|---|---|---|---|
| `main.dart` është monolit | Rrit koston e mirëmbajtjes, rrezikun e regresioneve dhe vështirëson testimin | Numërim real: `lib/main.dart` = 1813 rreshta | Ndaje sipas ekranit, widgets shared dhe models; shiko planin e refaktorimit më poshtë |
| Tekstet janë hardcoded në shqip | Bllokon lokalizimin, testet tekstuale dhe konsistencën e copy-së | Tituj dhe mesazhe direkt në `lib/main.dart` dhe `lib/gamify_exercise.dart` | Implemento `flutter_localizations` + `intl` + ARB files |
| Përdorim i gjerë i `StatefulWidget` / `setState` | Gjendja shpërndahet në disa ekrane pa një model unik, gjë që e vështirëson persistencën dhe side-effects | `DashboardScreen`, `ChallengeScreen`, `GeometryChallengeScreen`, `GamifyExerciseScreen`, `OperationTablesScreen` | Migro në Riverpod me `Notifier`/`AsyncNotifier` |
| Zbritja në tabela prodhon numra negativë | Mund të bjerë ndesh me objektivin didaktik të nivelit fillor | Screenshot-i tregon `2 - 3 = -1`; logjika në `lib/simple_tables.dart` është `a - b` pa filtër | Përcakto politikë të qartë: ose lejo negative vetëm në modul të avancuar, ose filtro tabelën bazë |
| Ka logjikë gjeometrie të dyfishuar / e papërdorur | Kod i vdekur dhe rrezik divergjence mes moduleve | `SimpleGeometryChallenge` ekziston vetëm në `lib/simple_tables.dart` dhe nuk referencohet nga pjesë të tjera | Hiqe ose migroje në modul testues të dedikuar jashtë prod code |
| Lejet Android nuk janë të plota në mjedisin aktual | Build/deploy në Android mbetet i paqëndrueshëm edhe pas rregullimit të SDK | `flutter doctor -v` raporton Android licenses jo të pranuara | Ekzekuto `flutter doctor --android-licenses` në workstation-in e zhvillimit |

### Sugjerime për përmirësim

| Sugjerimi | Vlera |
|---|---|
| Shto golden tests për ekranet kryesore | Ruajtje e qëndrueshmërisë vizuale të temës Cosmic Dark |
| Shto telemetry lokale për sesionet e sfidës | Matje reale e progresit dhe vështirësisë |
| Shto error reporting jo-intruziv | Më e lehtë diagnostika në prod |
| Shto CI për `flutter analyze`, `flutter test` dhe build debug | Parandalon regresionet para merge |

## 1. Analiza e build-it

### 1.1 AAPT2: ARM64 vs x86_64

- Gjetja e dokumentuar në repo është e saktë: problemi është mjedisor, jo problem i kodit Flutter.
- Në host ARM64 Linux, binari `aapt2` i Android build-tools është x86_64 dhe kërkon loader-in `ld-linux-x86-64.so.2`, i cili mungon.
- Kjo nuk u riprodhua në mjedisin aktual të auditimit, sepse auditimi u ekzekutua në Windows x64. Prandaj kjo duhet trajtuar si çështje e veçantë e hostit Linux/ARM64, jo si defekt universal i projektit.

### 1.2 Rekomandimi: Docker apo multi-lib?

#### Rekomandimi kryesor për zhvillim lokal në ARM64 Linux: multi-lib setup

- Është zgjidhja më efikase kur:
  - zhvilluesi build-on shpesh lokalishte,
  - duhen cikle të shpejta `flutter clean`, `flutter run`, `flutter build apk`,
  - emulatori, adb dhe cache-t lokale duhen përdorur direkt pa shtresa shtesë.
- Avantazhet:
  - më pak overhead se Docker,
  - integrim më i thjeshtë me Android SDK lokal,
  - më pak friction për debug iterativ.
- Disavantazhet:
  - konfigurim i ndjeshëm i hostit,
  - varësi nga paketa sistemore x86.

#### Docker: zgjidhje më e mirë për CI dhe reproducibility

- Docker është zgjidhje më e mirë kur:
  - kërkohet build i riprodhueshëm për ekip ose CI,
  - hosti është i paqëndrueshëm,
  - build-i duhet izoluar nga ndotja e workstation-it.
- Disavantazhet për zhvillim ditor:
  - I/O më i ngadaltë,
  - debug më i vështirë me emulator/kamerë/ADB,
  - më shumë overhead operacional.

#### Vendim praktik

- Për workstation ARM64 Linux: përdor multi-lib setup.
- Për CI/CD: përdor Docker ose GitHub Actions.
- Për workstation-in aktual Windows: asnjëra nuk është zgjidhja e problemit aktual; këtu bllokuesi është versioni i Flutter SDK dhe licencat Android.

### 1.3 Gjetje shtesë nga auditimi real i mjedisit lokal

| Kontrolli | Rezultati | Impakti |
|---|---|---|
| `flutter --version` | Flutter 3.32.5, Dart 3.8.1 | Më i vjetër se kërkesa e projektit |
| `flutter test` | Dështon në dependency resolution | QA lokale e bllokuar |
| `flutter analyze` | Dështon në dependency resolution | Analiza statike e bllokuar |
| `flutter doctor -v` | Android licenses jo të pranuara | Android build ende jo i pastër |

## 2. Kodi dhe performanca

### 2.1 Madhësia e `main.dart`

- Pretendimi fillestar ishte “mbi 2000 rreshta”. Snapshot-i aktual i kodit është pak më poshtë, por problemi arkitekturor mbetet i njëjtë.

| Skedari | Rreshta |
|---|---|
| `lib/main.dart` | 1813 |
| `lib/simple_tables.dart` | 524 |
| `lib/gamify_exercise.dart` | 502 |
| `lib/responsive.dart` | 92 |

- `main.dart` aktualisht përmban në të njëjtin skedar:
  - bootstrap-in e aplikacionit,
  - modelet `MathQuestion` dhe `GeometryQuestion`,
  - routing-un e dashboard-it,
  - ekranet kryesore të sfidave,
  - rezultatin,
  - komponentët shared të UI,
  - painter-a dhe mascot animation.

Kjo e bën skedarin një “god object” të UI.

### 2.2 Plan konkret refaktorimi

#### Faza 1: Ndarje pa ndryshim sjelljeje

Synimi: zero ndryshim funksional, vetëm ndarje e përgjegjësive.

Strukturë e rekomanduar:

```text
lib/
  app/
    math_lingo_app.dart
    routes.dart
  core/
    theme/
      cosmic_colors.dart
      app_theme.dart
    layout/
      adaptive_layout.dart
      responsive_page.dart
    localization/
      l10n.dart
  features/
    dashboard/
      presentation/
        dashboard_screen.dart
        dashboard_page.dart
        lessons_page.dart
        progress_page.dart
        widgets/
          daily_challenge_card.dart
          gamify_card.dart
          progress_module_card.dart
          quick_actions_card.dart
    challenges/
      domain/
        operation.dart
        math_question.dart
        geometry_question.dart
      presentation/
        challenge_screen.dart
        geometry_challenge_screen.dart
        results_screen.dart
        widgets/
          answer_button.dart
          cosmic_progress.dart
          operation_tile.dart
      logic/
        math_question_generator.dart
        geometry_question_generator.dart
    tables/
      presentation/
        operation_tables_screen.dart
        widgets/
          table_selector.dart
          operation_result_card.dart
    gamify/
      presentation/
        gamify_exercise_screen.dart
      logic/
        equation_parser.dart
        solution_formatter.dart
    shared/
      widgets/
        cosmic_top_bar.dart
        cosmic_bottom_nav.dart
        cosmic_button.dart
        glass_panel.dart
        mascot_frame.dart
      painting/
        geometry_shape_painter.dart
```

#### Faza 2: Ndarje e logjikës nga UI

- Zhvendos gjeneratorët e pyetjeve nga widget state në klasa të veçanta pure Dart.
- Zhvendos parser-in e Gamify në një service të dedikuar.
- Bëj që ekranet të konsumojnë state dhe jo ta prodhojnë logjikën vetë.

#### Faza 3: Përgatitje për testim dhe state management

- Çdo feature të ketë:
  - `domain`
  - `logic` ose `application`
  - `presentation`
- Çdo generator/parser të mbulohet me unit tests.

### 2.3 Rreziqet e performancës

- Nuk ka indikacione për problem madhor rendering në screenshot-e; UI është relativisht i lehtë dhe Flutter e mban lehtë në 60 FPS në pajisje normale.
- Rreziqet kryesore afatmesme janë:
  - rebuild-e të gjera nga `setState`,
  - rritje e kostos së mirëmbajtjes dhe regresioneve,
  - animacione të shpërndara në të njëjtin skedar me logjikën e biznesit.

## 3. Hardcoded strings dhe lokalizimi

### Gjendja aktuale

- Titujt, tekstet e ndihmës, feedback-u i gabimeve, navigimi dhe copy pedagogjike janë hardcoded direkt në kod.
- Kjo shihet qartë në `lib/main.dart` dhe `lib/gamify_exercise.dart`.

### Rreziqet

- Nuk ka single source of truth për copy.
- Ndryshimet në terminologji kërkojnë ndryshim në shumë skedarë.
- Testet bëhen të brishta, sepse lidhen fort me string literal-et.
- Aplikacioni nuk mund të zgjerohet lehtë në gjuhë të tjera.

### Implementimi i rekomanduar

Paketat:

```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.20.2
```

Strukturë e rekomanduar:

```text
lib/l10n/
  app_sq.arb
  app_en.arb
```

Shembull minimal:

- `app_sq.arb`
  - `"welcomeTitle": "Mirësevini!"`
  - `"dailyChallenge": "Sfida e Ditës"`
  - `"chooseNumber": "Zgjidh numrin"`

- Në kod:
  - `AppLocalizations.of(context)!.welcomeTitle`

Vendimi arkitekturor:

- Shqipja mbetet default locale.
- Anglishtja shtohet si locale e dytë për QA, demonstrime dhe zgjerim tregu.

## 4. Menaxhimi i gjendjes

### Gjendja aktuale

- Projekti përdor shumë `StatefulWidget` me state lokal.
- Kjo është e pranueshme për MVP, por po arrin kufirin praktik sapo të shtohen:
  - persistenca,
  - autentikimi,
  - sinkronizimi i progresit,
  - lokalizimi dinamik,
  - telemetria dhe feature flags.

### Kritikë teknike

- `setState` është i shpërndarë në ekrane që përmbajnë edhe logjikë biznesi.
- Nuk ka ndarje të qartë mes state-it transient të UI dhe state-it të domenit.
- Testing bëhet më i vështirë, sepse logjika e pyetjeve është e lidhur fort me widget lifecycle.

### Provider apo Riverpod?

#### Rekomandimi: Riverpod

- Provider është i thjeshtë, por Riverpod ofron:
  - injektim më të qartë të varësive,
  - testueshmëri më të mirë,
  - më pak varësi nga widget tree,
  - shkallëzim më të mirë për feature modules.

### Migrim i rekomanduar

#### Hapi 1

- Vendos `ProviderScope` në root.

#### Hapi 2

- Krijo notifier-a të ndarë:
  - `dashboardTabProvider`
  - `challengeSessionProvider`
  - `geometrySessionProvider`
  - `gamifyProvider`
  - `userProgressProvider`

#### Hapi 3

- Mbaj `AnimationController` dhe state strikt vizual brenda widget-eve.
- Zhvendos state-in e domenit dhe side-effects te Riverpod.

## 5. Auditim i sigurisë dhe i të dhënave

### 5.1 Persistenca dhe enkriptimi

- Aktualisht aplikacioni nuk ruan progres përdoruesi në storage lokal. Pra, në gjendjen aktuale nuk ka “data-at-rest” për t’u enkriptuar.
- Rreziku i vërtetë nuk është ruajtja e paenkriptuar ekzistuese, por mungesa e infrastrukturës për ruajtje të sigurt sapo progresi të shtohet.

### Rekomandimi

- Nëse progresi ruhet lokalisht:
  - për data model të thjeshtë: `Hive` ose `Hive CE`,
  - për nevoja më të forta query: `sqflite` ose SQLite i menaxhuar.
- Për të dhëna sensitive ose profile përdoruesi:
  - ruaj çelësin e enkriptimit me `flutter_secure_storage`,
  - enkripto payload-in ose përdor storage me encryption layer.

### 5.2 Autentikimi

- Nuk ka sistem autentikimi.
- Për MVP lokal kjo është e pranueshme nëse aplikacioni është vetëm offline dhe pa sinkronizim.
- Sapo të shtohen profile, leaderboard, cloud save ose statistikë përdoruesi, autentikimi bëhet detyrim funksional dhe sigurie.

### Rekomandimi

- Fazë 1: profil lokal anonim.
- Fazë 2: Firebase Auth me sign-in të lehtë për prind/mësues ose link-based auth.

### 5.3 Gjetje shtesë sigurie

- Release signing me debug key është jo-pranueshëm për publikim.
- Kamera përdoret përmes `image_picker`, por flow i lejeve duhet të testohet eksplcit në Android dhe iOS.

## 6. UX/UI check bazuar në screenshot-et

### 6.1 Touch targets sipas standardit Google

Standardi minimal praktik është 48 x 48 dp.

### Vlerësim i elementeve kryesore

| Elementi | Vlerësimi | Arsyeja |
|---|---|---|
| Quick action tiles | Kalon | Kartat janë dukshëm shumë më të mëdha se 48dp dhe kanë sipërfaqe të rehatshme prekëse |
| Butonat numerikë të tabelave | Kalon | Nga kodi kanë `height: 60` dhe padding të mjaftueshëm; vizualisht janë mbi kufirin minimal |
| TabBar i operacioneve | Kalon | Segmentet janë të gjera dhe të prekshme në mobile |
| Bottom navigation | Kalon | Zonat aktive janë të mëdha dhe të qarta |
| Ikonat rrethore në top bar | Kalon | Duken rreth 56dp ose më shumë |
| Kartat e rezultateve në tabela | Kalon | E gjithë karta është clickable, jo vetëm teksti |

### 6.2 Gjetje UX nga screenshot-et

- Tema vizuale është koherente dhe e qëndrueshme në të gjitha ekranet.
- Kontrasti i tekstit kryesor është i mirë.
- CTA-ja kryesore është e qartë dhe vizualisht prioritare.
- Snackbar-i “Shortcut to mathlingo added on Home screen.” mbivendoset mbi përmbajtjen dhe bottom nav në disa screenshot-e; kjo është e bezdisshme në mobile dhe duhet kaluar në `SnackBarBehavior.floating` me `margin` të përshtatshëm.
- Ekrani i progresit në disa screenshot-e duket i prerë afër top bar-it; kjo duhet rishikuar me scroll offset dhe spacing fillestar në pajisje reale.

### 6.3 Gjetje funksionale nga screenshot-et

- Tabela e pjesëtimit shfaq `12 ÷ 5 = 2`, `12 ÷ 8 = 1` dhe të ngjashme. Kjo është gabim pedagogjik për një modul që paraqitet si “tabelë matematikore”.
- Tabela e zbritjes shfaq vlera negative në ekranin bazë. Nëse kjo është e qëllimshme, duhet kategorizuar si nivel më i avancuar. Në gjendjen aktuale është e paqartë dhe potencialisht jo e përshtatshme për audiencën fillore.

## 7. Checklist e mirëmbajtjes

### 7.1 Paketat për përditësim

Rezultat real nga `flutter pub outdated`:

| Paketa | Versioni aktual | Latest |
|---|---|---|
| `flutter_launcher_icons` | 0.13.1 | 0.14.4 |
| `flutter_lints` | 5.0.0 | 6.0.0 |
| `image_picker_ios` | 0.8.13+3 | 0.8.13+6 |
| `meta` | 1.17.0 | 1.18.2 |
| `vector_math` | 2.2.0 | 2.3.0 |
| `cli_util` | 0.4.2 | 0.5.1 |
| `lints` | 5.1.1 | 6.1.0 |
| `matcher` | 0.12.18 | 0.12.20 |
| `test_api` | 0.7.9 | 0.7.12 |
| `xml` | 6.6.1 | 7.0.1 |

Shënim:

- Para përditësimit të paketave duhet të përditësohet Flutter SDK, ndryshe dependency resolution mbetet i bllokuar.

### 7.2 Testet që mungojnë aktualisht

#### Unit tests që duhen shtuar

- Gjenerimi i pyetjeve për çdo operacion dhe çdo nivel.
- Verifikim që pyetjet e pjesëtimit në `ChallengeScreen` japin gjithmonë rezultat të plotë.
- Verifikim që opsionet janë unike dhe përfshijnë përgjigjen e saktë.
- Formula e sipërfaqes së trekëndëshit, drejtkëndëshit dhe perimetrit të katrorit.
- Parser-i i Gamify për formatet `+`, `-`, `*`, `x`, `×`, `/`, `÷`.
- Normalizimi i inputit shqip: `zgjidh`, `llogarit`, `sa është`, `janë`.

#### Widget tests që duhen shtuar

- Ndërrimi i tab-eve në dashboard.
- Ndërrimi i operacioneve te tabelat matematikore.
- Ndërrimi i numrit të tabelës dhe rifreskimi i grid-it.
- Rrjedha e plotë e `ChallengeScreen` me përgjigje të sakta dhe të gabuara.
- Rrjedha e plotë e `GeometryChallengeScreen`.
- Validimi i `SnackBar`-it të gabimit në Gamify.
- Verifikimi i layout-it responsive për phone dhe tablet.

#### Integration tests që duhen shtuar

- Navigim fundor nga dashboard te rezultatet dhe kthimi në dashboard.
- Kamera/galeri me mocking.
- Android back navigation dhe lifecycle restore.

## 8. Rendi i zbatimit të rekomanduar

### Sprint 1

- Përditëso Flutter SDK në version kompatibël me `sdk: ^3.9.2`.
- Prano Android licenses.
- Rregullo tabelat e zbritjes dhe pjesëtimit që të mos japin rezultate pedagogjikisht të gabuara.
- Zëvendëso release debug signing me release signing korrekt.

### Sprint 2

- Refaktoro `main.dart` në feature-based structure pa ndryshim sjelljeje.
- Nxirr gjeneratorët dhe parser-at në klasa pure Dart.
- Shto unit tests për logjikën e pyetjeve.

### Sprint 3

- Implemento `flutter_localizations` dhe `intl`.
- Fillo migrimin e state management në Riverpod.
- Shto widget tests dhe CI checks.

### Sprint 4

- Shto persistencë të progresit me Hive ose SQLite.
- Ruaj çelësat me `flutter_secure_storage` dhe përgatit encryption model.
- Përgatit autentikim nëse roadmap-i përfshin profile dhe sinkronizim.

## Konkluzioni

- MathLingo ka theme/UI të fortë dhe rrjedhë MVP të qartë, por aktualisht nuk është në gjendjen ideale për shkallëzim ose publikim pa ndërhyrje.
- Prioriteti i parë është stabilizimi i mjedisit të zhvillimit dhe korrigjimi i gabimeve matematikore në tabela.
- Prioriteti i dytë është refaktorimi strukturor: ndarja e `main.dart`, lokalizimi dhe kalimi në state management më të qëndrueshëm.
- Prioriteti i tretë është fortifikimi i produktit me testim, persistencë të sigurt dhe release pipeline të rregullt.# Auditim Teknik i MathLingo

Data: 07 Maj 2026

## Përmbledhje Ekzekutive

Ky auditim kombinon leximin e kodit aktual, verifikimin e mjedisit lokal dhe vëzhgimet nga screenshot-et e UI-së. Gjetja më e rëndësishme është se projekti ka dy bllokues të ndryshëm të mjedisit:

- Në analizën ekzistuese historike, build-i Android është bllokuar nga mospërputhja e arkitekturës së `AAPT2` në host ARM64 kundrejt veglave `x86_64`.
- Në mjedisin aktual të auditimit në Windows, problemi i menjëhershëm nuk është `AAPT2`, por mospërputhja e versionit të Flutter/Dart me kufizimin e projektit në `pubspec.yaml`.

Nga ana e kodit, aplikacioni ka bazë të mirë vizuale dhe UX tërheqës, por aktualisht ka probleme të dukshme në korrektësinë matematikore të modulit të tabelave, centralizim të tepërt të logjikës në `main.dart`, mungesë lokalizimi, dhe mungesë të një arkitekture të shkallëzueshme për state management dhe ruajtjen e të dhënave.

## Prioritete Kritike

### 1. Bllokues i mjedisit lokal: Flutter SDK është më i vjetër se sa kërkon projekti

Statusi i verifikuar gjatë auditimit:

- `flutter --version`: Flutter `3.32.5`, Dart `3.8.1`
- `pubspec.yaml`: `environment: sdk: ^3.9.2`
- `flutter test` dhe `flutter analyze` dështojnë para ekzekutimit për shkak të version solving

Ndikimi:

- QA bazike nuk mund të ekzekutohet lokalisht
- Nuk mund të bëhet `flutter analyze`, `flutter test`, ose `pub get` në mënyrë të qëndrueshme me këtë SDK
- Çdo rezultat tjetër i build-it mbetet i paqëndrueshëm derisa të harmonizohet toolchain-i

Vendim i rekomanduar:

- Standardizoni mjedisin në Flutter `3.41.9` ose version kompatibil me Dart `3.9.x`
- Në ekip, vendosni version pinning me FVM ose me një dokument të qartë bootstrap-i

Prioriteti: Kritike

### 2. Bllokues historik i build-it Android: AAPT2 architecture mismatch

Bazuar në analizën ekzistuese të repo-s:

- Host-i problematik: ARM64
- Binary i `aapt2`: `x86-64`
- Error: mungon loader-i `'/lib64/ld-linux-x86-64.so.2'`

Vlerësim arkitekturor:

- Ky është problem i mjedisit të build-it, jo i kodit Flutter
- Nëse zhvillimi bëhet përditë në një makinë ARM64 Linux, zgjidhja më efikase për iterim lokal është **multi-lib setup**, jo Docker

Rekomandim i qartë:

- Për zhvillim lokal në ARM64 Linux: përdorni **multi-lib setup** (`libc6:i386`, `libstdc++6:i386`, `gcc-multilib`, `g++-multilib`)
- Për CI/CD, build-e të riprodhueshme dhe ekipe heterogjene: përdorni **Docker** ose GitHub Actions

Arsyetim:

- Multi-lib ka më pak overhead, iterim më të shpejtë dhe integrim më të thjeshtë me emulatorët lokalë
- Docker është më i mirë për riprodhueshmëri, por është më i rëndë për debug të përditshëm Android, sidomos me volume, SDK cache dhe lidhje me emulator/device

Vendimi praktik:

- Nëse një zhvillues i vetëm po punon lokalisht në ARM64: zgjidhni multi-lib
- Nëse build-i do standardizim dhe automatizim ekipi: shtoni Docker vetëm si kanal sekondar ose CI

Prioriteti: Kritike

### 3. Moduli i tabelave ka probleme reale të korrektësisë matematikore

Nga kodi dhe screenshot-et:

- Zbritja përdor `a - b` pa kufizim, prandaj shfaq vlera negative si `2 - 9 = -7`
- Pjesëtimi përdor `a ~/ b`, prandaj shfaq pjesëtim të truncuar, p.sh. `12 ÷ 5 = 2`

Ky është problem funksional, jo vetëm UX.

Ndikimi:

- Nxënësit marrin rezultate që nuk përputhen me pritshmërinë pedagogjike të tabelave bazë
- Sjellja bie ndesh me logjikën e `ChallengeScreen`, ku pjesëtimi gjenerohet me rezultat të plotë dhe zbritja shmang rezultatet negative
- Rritet rreziku i konfuzionit mësimor dhe humbet besueshmëria e aplikacionit

Rekomandim:

- Për tabelat e zbritjes: kufizoni çiftet në mënyrë që `a >= b`, ose ktheni tabelën në format "fakte zbritjeje" ku rezultati nuk del negativ për grupmoshën synuar
- Për tabelat e pjesëtimit: shfaqni vetëm çifte ku `a % b == 0`, ose ndryshoni UI-në për të treguar pjesëtim me mbetje/thyesë nëse kjo është pjesë e kurrikulës

Prioriteti: Kritike

### 4. Release build po nënshkruhet me debug key

Në `android/app/build.gradle.kts`, `release` përdor:

- `signingConfig = signingConfigs.getByName("debug")`

Ndikimi:

- Build-i release nuk është i përshtatshëm për shpërndarje reale
- Ky konfigurim është i pranueshëm vetëm si zgjidhje e përkohshme lokale

Rekomandim:

- Krijoni keystore reale për production
- Nxirrni kredencialet nga kodi dhe përdorni `key.properties` + variabla ambienti në CI

Prioriteti: Kritike

## Prioritete Mesatare

### 5. `main.dart` është shumë i madh dhe po mbledh përgjegjësi të shumta

Matja aktuale e verifikuar:

- `lib/main.dart`: 1813 rreshta
- `lib/gamify_exercise.dart`: 502 rreshta
- `lib/simple_tables.dart`: 524 rreshta
- `lib/responsive.dart`: 92 rreshta

Edhe pse snapshot-i aktual është nën 2000 rreshta, problemi i monolitit është real. `main.dart` përmban njëkohësisht:

- bootstrap-in e aplikacionit
- theming
- dashboard navigation
- challenge logic
- geometry challenge logic
- results screen
- design-system widgets
- mascot animation controllers

Rreziqet:

- ndryshimet bëhen të vështira për t’u testuar në izolim
- rritet coupling ndërmjet UI, navigimit dhe logjikës së biznesit
- rritet kostoja e code review dhe rreziku i regressions

Plan konkret refaktorimi:

1. Nxirrni bootstrap-in në:
   - `lib/app/app.dart`
   - `lib/app/theme.dart`
2. Ndani ekranet në:
   - `lib/features/dashboard/dashboard_screen.dart`
   - `lib/features/challenge/challenge_screen.dart`
   - `lib/features/geometry/geometry_challenge_screen.dart`
   - `lib/features/results/results_screen.dart`
   - `lib/features/lessons/lessons_page.dart`
   - `lib/features/progress/progress_page.dart`
3. Nxirrni widget-et e ripërdorshme në:
   - `lib/shared/widgets/glass_panel.dart`
   - `lib/shared/widgets/cosmic_button.dart`
   - `lib/shared/widgets/cosmic_top_bar.dart`
   - `lib/shared/widgets/cosmic_bottom_nav.dart`
   - `lib/shared/widgets/cosmic_progress.dart`
   - `lib/shared/widgets/mascot_frame.dart`
4. Nxirrni modelet dhe generatorët në:
   - `lib/features/challenge/domain/math_question.dart`
   - `lib/features/challenge/domain/generate_math_question.dart`
   - `lib/features/geometry/domain/geometry_question.dart`
   - `lib/features/geometry/domain/generate_geometry_question.dart`
5. Lëreni `main.dart` minimal:
   - `void main()`
   - `runApp(const MathLingoApp())`

Rendi i rekomanduar i ekzekutimit:

- Faza 1: design-system widgets
- Faza 2: results + dashboard pages
- Faza 3: challenge logic
- Faza 4: mascot animation dhe painter-at

Prioriteti: Mesatar

### 6. Hardcoded strings në shqip e bllokojnë lokalizimin dhe testimin

Shembuj të drejtpërdrejtë:

- `main.dart` dhe `gamify_exercise.dart` mbajnë tekstet UI, feedback-un dhe mesazhet e gabimit direkt në kod
- `MaterialApp` aktual nuk është i konfiguruar me `localizationsDelegates` ose `supportedLocales`

Rreziqet:

- përkthimet kërkojnë ndryshime në kod, jo vetëm në resource files
- testet bëhen të brishta ndaj copy changes
- nuk ka rrugë të pastër për EN/SQ ose për terminologji alternative sipas klasës

Zbatim i rekomanduar:

1. Shtoni në `pubspec.yaml`:
   - `flutter_localizations` nga SDK
   - `intl`
2. Aktivizoni gjenerimin e l10n:
   - `flutter: generate: true`
3. Krijoni:
   - `lib/l10n/app_sq.arb`
   - `lib/l10n/app_en.arb`
4. Konfiguroni `MaterialApp` me:
   - `localizationsDelegates`
   - `supportedLocales`
   - `localeResolutionCallback` nëse duhet
5. Filloni me nxjerrjen e string-eve nga:
   - navigation labels
   - dashboard headings
   - snackbars dhe error messages
   - challenge feedback messages

Prioriteti: Mesatar

### 7. State management aktual me `StatefulWidget`/`setState` nuk shkallëzon mirë

Gjendja aktuale:

- `DashboardScreen`, `ChallengeScreen`, `GeometryChallengeScreen`, `GamifyExerciseScreen`, `OperationTablesScreen`, dhe `SimpleGeometryChallenge` përdorin state lokal
- kjo është e pranueshme për prototip, por jo për progres persistent, analytics, auth dhe personalizim

Kritika teknike:

- logjika e pyetjeve është e lidhur ngushtë me UI state
- `setState` e bën më të vështirë testimin e logjikës pa widget tree
- nuk ka single source of truth për progresin e përdoruesit

Rekomandim:

- Kalimi i synuar: **Riverpod**, jo Provider klasik

Pse Riverpod është zgjedhja më e mirë këtu:

- testueshmëri më e lartë pa BuildContext
- ndarje e pastër ndërmjet providers, state dhe UI
- i përshtatshëm për state async të OCR, storage dhe auth
- redukton varësinë nga lifecycle i widget-eve

Model i rekomanduar:

- `StateNotifier` ose `Notifier` për challenge state
- provider i veçantë për progress repository
- provider i veçantë për auth/session
- provider i veçantë për local settings dhe locale

Strategji migrimi me risk të ulët:

1. Filloni me `DashboardScreen` dhe `BottomNav`
2. Pastaj migroni `ChallengeScreen`
3. Pastaj `GeometryChallengeScreen`
4. Në fund `GamifyExerciseScreen` sepse do lidhet me OCR async dhe storage

Prioriteti: Mesatar

### 8. Ka shenja të kodit të mbetur ose të dyfishuar në `simple_tables.dart`

Në të njëjtin skedar ekziston edhe `SimpleGeometryChallenge`, `GeometryProblem`, dhe `TrianglePainter`, ndërkohë që aplikacioni kryesor ka tashmë `GeometryChallengeScreen` dhe `GeometryShapePainter` në `main.dart`.

Rreziku:

- drift funksional midis dy implementimeve të gjeometrisë
- konfuzion gjatë refaktorimit
- rritje e kodit të papërdorur dhe borxhit teknik

Rekomandim:

- hiqni prototipet e papërdorura ose zhvendosini në branch historik/reference
- mbani vetëm një implementim aktiv për çdo feature

Prioriteti: Mesatar

### 9. Siguria dhe të dhënat: nuk ka auth dhe nuk ka plan të sigurt për persistencë

Gjendja aktuale:

- aplikacioni aktual nuk ruan progres real të përdoruesit
- nuk ka autentikim
- nuk ka enkriptim sepse nuk ka ende storage funksionale për progresin

Vlerësim i saktë i riskut:

- aktualisht rreziku i rrjedhjes së progresit është i ulët sepse të dhënat nuk persistohen
- rreziku real është arkitekturor: kur të shtohet storage, shumë ekipe përfundojnë duke ruajtur të dhëna pa enkriptim dhe pa user isolation

Rekomandim teknik:

- për storage lokal të progresit:
  - Hive për shpejtësi dhe thjeshtësi, ose SQLite nëse duhet query model më i pasur
- për të dhëna të ndjeshme ose çelësa:
  - `flutter_secure_storage`
- nëse përdoret SQLite për të dhëna me ndjeshmëri më të lartë:
  - konsideroni `sqlcipher` ose model hibrid ku vetëm identifikuesit/çelësat ruhen në secure storage
- për auth:
  - në fazë fillestare, anonymous auth ose profile lokale
  - në fazë prodhimi, Firebase Auth ose backend i dedikuar

Prioriteti: Mesatar

## UX/UI Check nga Screenshot-et

### 10. Touch targets janë kryesisht në rregull sipas standardit 48dp

Bazuar në screenshot-et dhe përmasat e deklaruara në kod:

- butonat numerikë te tabelat kanë lartësi rreth `60` dhe padding vertikal `14`, pra kalojnë pragun minimal 48dp
- kartat e `Veprime të Shpejta` janë dukshëm më të mëdha se minimumi dhe janë të sigurta për touch
- bottom navigation ka zona klikimi të mjaftueshme
- ikonat rrethore të top bar-it gjithashtu duken në kufi të sigurt ose mbi 48dp

Përfundim:

- Nga pikëpamja e Google touch target guidelines, nuk shoh shkelje kritike në screenshot-et e dhëna

Përmirësime të rekomanduara:

- shtoni `tooltip`/semantics labels për aksesueshmëri
- rrisni kontrastin e disa numrave joaktivë në rreshtin horizontal të tabelave, sepse në disa screenshot-e `unselected` duken pak të zbehtë
- përdorni `SnackBarBehavior.floating` me `margin` mbi bottom nav, sepse snackbar aktual mbivendos navigimin në screenshot dhe ul qartësinë e ndërveprimit

Prioriteti: Mesatar

## Sugjerime për Përmirësim

### 11. Checklist e mirëmbajtjes së paketave

Nga `flutter pub outdated`:

- `flutter_launcher_icons`: `0.13.1` -> `0.14.4`
- `flutter_lints`: `5.0.0` -> `6.0.0`
- transitives të vjetruara:
  - `image_picker_ios`
  - `meta`
  - `vector_math`
  - `cli_util`
  - `lints`
  - `matcher`
  - `test_api`
  - `xml`

Shënim i rëndësishëm:

- Para upgrade të paketave, duhet të rregullohet së pari versioni i Flutter SDK, ndryshe dependency resolution mbetet i bllokuar

Prioriteti: Sugjerim me ndikim të lartë

### 12. Testet që mungojnë aktualisht

Gjendja aktuale:

- ekziston një set i vogël `widget_test.dart`
- nuk ka mbulim real për domain logic, localizations, error states, ose regresionet e tabelave

Testet që duhen shtuar menjëherë:

#### Unit tests

- gjenerimi i pyetjeve të mbledhjes sipas niveleve
- zbritja pa rezultat negativ në challenge flow
- pjesëtimi me rezultat të plotë në challenge flow
- formulat e gjeometrisë për katror, trekëndësh, drejtkëndësh
- parser-i i `GamifyExerciseScreen` për `+`, `-`, `*`, `×`, `x`, `/`, `÷`
- normalizimi i inputit shqip: `zgjidh`, `llogarit`, `sa është`
- llogaritja e `accuracy` dhe `score`

#### Widget tests

- ndryshimi i tabs në `OperationTablesScreen`
- selektimi i numrit të tabelës dhe azhurnimi i grid-it
- navigimi nga dashboard te challenge dhe geometry
- `ResultsScreen` pas sesionit të përfunduar
- shfaqja e `SnackBar` kur inputi i Gamify është bosh
- responsive layout për mobile dhe tablet

#### Integration tests

- flow i plotë: dashboard -> challenge -> results -> dashboard
- flow i kamerës/galerisë me mock ose fake picker
- flow i bottom nav pa humbje state-je

#### Golden tests

- dashboard dark theme
- operation tables për secilin operation state
- results screen me celebratory mascot

Prioriteti: Sugjerim me ndikim të lartë

### 13. Observime shtesë të cilësisë

- UI është vizualisht koherent dhe identiteti "Cosmic Dark" është i fortë
- Glassmorphism dhe neon palette funksionojnë mirë për target grupmoshën
- Përdorimi i `CustomPainter` për gjeometrinë është zgjedhje e mirë për performancë dhe kontroll vizual
- `GamifyExerciseScreen` ka placeholder të qartë për OCR, por duhet të ndahet nga parser-i dhe nga state-i UI sapo të integrohet ML Kit

Prioriteti: Sugjerim

## Plan Veprimi i Rekomanduar

### Sprint 1

- Përditësoni Flutter SDK në version kompatibil me `^3.9.2`
- Rregulloni Android licenses lokale
- Korrigjoni tabelat e zbritjes dhe pjesëtimit
- Hiqni debug signing nga release config

### Sprint 2

- Nxirrni design-system widgets nga `main.dart`
- Ndani `challenge`, `geometry`, `results`, `dashboard` në feature folders
- Hiqni ose arkivoni `SimpleGeometryChallenge`
- Shtoni unit tests për generatorët dhe parser-in

### Sprint 3

- Implementoni `flutter_localizations` + `intl`
- Nisni migrimin në Riverpod
- Shtoni storage për progresin me repository abstraction
- Përcaktoni modelin e auth-it

### Sprint 4

- Integroni ML Kit OCR
- Shtoni integration tests dhe golden tests
- Shtoni CI pipeline për build/test/analyze

## Konkluzion

MathLingo ka një bazë të mirë produkti dhe një drejtim të qartë vizual, por para se të konsiderohet i fortë për rritje funksionale duhet të adresohen katër çështje prioritare: harmonizimi i SDK/toolchain-it, korrigjimi i korrektësisë matematikore në tabela, pastrimi i konfigurimit release, dhe ndarja e monolitit të `main.dart`.

Pas këtyre hapave, kalimi te lokalizimi, Riverpod, persistenca dhe OCR do të jetë shumë më i sigurt dhe më i lirë për t’u mirëmbajtur.