# SSOT - MathLingo

## Single Source of Truth për Produktin dhe Implementimin

| Fusha | Vlera |
|---|---|
| Emri i projektit | MathLingo |
| Lloji i dokumentit | SSOT - Single Source of Truth |
| Versioni i dokumentit | 2.0.1 |
| Data | 19 Maj 2026 |
| Gjuha e dokumentit | Shqip |
| Audienca | Zhvillues, QA, UI/UX, Product, stakeholders |
| Statusi | Aktiv |

## 1. Qëllimi i këtij dokumenti

Ky dokument është autoriteti i vetëm i projektit MathLingo për këto katër fusha:

1. Teknologjia e përdorur dhe kufijtë teknikë të aprovuar.
2. Rregullat e biznesit dhe logjika e lojës.
3. Specifikimet e dizajnit dhe komponentët e personalizuar.
4. Statusi aktual i implementimit, duke dalluar qartë mes asaj që është ndërtuar, asaj që është pjesërisht aktive dhe asaj që është ende plan.

Ky dokument nuk zëvendëson kodin burimor si e vërtetë ekzekutueshme, por është dokumenti normativ që duhet të lexohet i pari nga çdo zhvillues i ri ose stakeholder për të kuptuar gjendjen reale të produktit.

## 2. Rregulli i autoritetit

- Çdo ndryshim funksional, teknik ose vizual në MathLingo duhet të reflektohet në këtë dokument në të njëjtin cikël pune.
- Nëse kodi aktual devijon nga rregullat e biznesit të deklaruara këtu, SSOT përcakton sjelljen e synuar, ndërsa devijimi duhet të shënohet në seksionin e statusit si mospërputhje ose bug.
- Dokumentet e tjera si SSD, auditime teknike, README ose analiza ndihmëse konsiderohen dokumente mbështetëse. Ky dokument ka përparësi si referencë sintetike dhe operative.

## 3. Identiteti i produktit

### 3.1 Përkufizimi i produktit

MathLingo është një aplikacion edukativ i ndërtuar me Flutter për mësimin interaktiv të matematikës në gjuhën shqipe. Produkti kombinon:

- mësimin me sfida të shkurtra,
- gamification,
- prezantim vizual të fortë me temë kozmike,
- ndërveprim të thjeshtë për fëmijë dhe përdorues të rinj.

### 3.2 Audienca kryesore

| Audienca | Përshkrimi |
|---|---|
| Nxënës të ciklit fillor | Objektivi kryesor i produktit |
| Nxënës të ciklit të ulët | Përdorues dytësor për ushtrime bazë dhe gjeometri |
| Prindër dhe mësues | Përdorues mbështetës për orientim dhe ndjekje të progresit |

### 3.3 Parimet e produktit

- Gjuha primare e ndërfaqes është shqip.
- Matematika duhet të paraqitet si eksperiencë miqësore dhe jo frikësuese.
- Çdo ekran duhet të jetë i lexueshëm dhe i përdorshëm në celular dhe tablet.
- Elementët ndërveprues duhet të jenë të mëdhenj, të qartë dhe me feedback të menjëhershëm.

## 4. Teknologjia e përdorur

### 4.1 Stack-u teknik i aprovuar

| Kategoria | Teknologjia | Statusi |
|---|---|---|
| Framework | Flutter | Aktiv |
| Gjuha | Dart | Aktiv |
| UI framework | Material Design 3 | Aktiv |
| State management | Riverpod `StateNotifierProvider` + `autoDispose.family` | Aktiv |
| Navigimi | `Navigator 1.0` + `MaterialPageRoute` | Aktiv |
| Kamera/Galeria | `image_picker` | Aktiv |
| Persistence lokale | Hive (pa codegen) | Aktiv |
| Authentication | Firebase Auth | Aktiv (lazy init pas consent) |
| Cloud sync | Cloud Firestore | Aktiv (opt-in) |
| Audio feedback | `audioplayers 6.0.0` | Aktiv |
| Haptik | `HapticFeedback` native | Aktiv |
| Eksport / Share | `share_plus ^13.1.0` | Aktiv |
| Testim | `flutter_test` | Aktiv (141 teste) |
| Ikona launcher | `flutter_launcher_icons` | Aktiv |

### 4.2 Baseline i versioneve

| Parametri | Vlera e projektit |
|---|---|
| App version | `1.10.1` |
| Dart constraint | `^3.9.2` |
| Flutter SDK target | familja `3.41.x` |
| `cupertino_icons` | `^1.0.8` |
| `image_picker` | `^1.0.0` |
| `image` | `^4.2.0` |
| `google_mlkit_text_recognition` | `^0.15.1` |
| `flutter_riverpod` | `^2.6.1` |
| `hive` | `^2.2.3` |
| `hive_flutter` | `^1.1.0` |
| `firebase_core` | `^3.4.0` |
| `firebase_auth` | `^5.2.0` |
| `cloud_firestore` | `^5.3.0` |
| `audioplayers` | `6.0.0` |
| `share_plus` | `^13.1.0` |
| `package_info_plus` | `^10.1.0` |
| `path_provider` | `^2.1.5` |
| `fl_chart` | `^0.69.0` |
| `flutter_lints` | `^5.0.0` |
| `flutter_launcher_icons` | `^0.13.1` |

### 4.3 Platformat e targetuara

| Platforma | Mbështetja |
|---|---|
| Android | Po |
| iOS | Po |
| Web | Po |
| Windows | Po |
| macOS | Po |
| Linux | Po |

### 4.4 Konfigurimi teknik aktual që duhet ditur

| Zona | Gjendja aktuale |
|---|---|
| Android `minSdk` | 26 |
| Android namespace | `com.mathlingo.app` |
| Android release signing | `mathlingo-release.jks` me alias `mathlingo_alias`; `key.properties` gitignored |
| Firebase project | `mathlingo-90084` (Google Cloud) |
| Firebase App ID Android | `1:978533022478:android:bc5fc6aa979153a87ff55f` |
| Firebase App ID iOS | `1:978533022478:ios:72e41a9b3ac808dc7ff55f` |
| Local toolchain | FVM 3.41.x / Dart 3.9.2 — mjedis i verifikuar |

### 4.5 Burimi teknik i së vërtetës

Skedarët bazë teknikë që e përcaktojnë projektin janë:

- `pubspec.yaml`
- `analysis_options.yaml`
- `android/app/build.gradle.kts`
- `pubspec.yaml`
- `analysis_options.yaml`
- `android/app/build.gradle.kts`
- `lib/main.dart`
- `lib/colors.dart`
- `lib/responsive.dart`
- `lib/firebase_options.dart`
- `lib/features/` (feature modules)
- `lib/core/` (services, providers, domain, sync)
- `lib/shared/` (widgets, navigation, painting, utils)
- `lib/models/` (domain models)

## 5. Arkitektura aktuale e aplikacionit

### 5.1 Struktura reale e kodit Flutter

| Skedari | Roli aktual |
|---|---|
| `lib/main.dart` | Root app, modelet bazë, dashboard, sfidat, rezultatet, widget-et shared, animacionet |
| `lib/colors.dart` | Paleta autoritative e ngjyrave |
| `lib/responsive.dart` | Rregullat e layout-it responsive |
| `lib/gamify_exercise.dart` | Moduli i kamerës, input-it dhe zgjidhjes argëtuese |
| `lib/simple_tables.dart` | Moduli i tabelave matematikore dhe kod i mbetur/prototip për gjeometri |

### 5.2 Modeli arkitekturor aktual

Arkitektura aktuale është një MVP monolitik i ndarë sipas skedarëve, jo sipas feature modules.

Karakteristikat aktuale:

- UI, logjika e domenit dhe state-i janë të përziera në të njëjtat widget-e.
- `main.dart` mban disa përgjegjësi në një vend.
- Ka komponentë të ripërdorshëm të mirë, por jo ende të ndarë në bibliotekë të veçantë `shared`.
- `setState` është mekanizmi dominant i gjendjes.

### 5.3 Vendimi arkitekturor aktual

- Arkitektura ekzistuese është e pranueshme për fazën MVP.
- Nuk konsiderohet arkitekturë afatgjatë për shkallëzim.
- Migrimi i synuar afatmesëm është drejt një strukture feature-based dhe Riverpod.

## 6. Rregullat e biznesit dhe logjika e lojës

Ky seksion përkufizon sjelljen e aprovuar të produktit. Kur implementimi aktual devijon, kjo shënohet në seksionin e statusit.

### 6.1 Rregullat globale të eksperiencës

- Aplikacioni është në gjuhën shqipe.
- Çdo modul duhet të jetë i kuptueshëm për nxënës pa nevojë për trajnim teknik.
- Feedback-u për përgjigje duhet të jetë i menjëhershëm, i qartë dhe motivues.
- Përdoruesi duhet të mund të rifillojë rrjedhën e mësimit pa u humbur në navigim.

### 6.2 Dashboard dhe navigimi kryesor

#### Rregull biznesi

- Produkti hapet në `DashboardScreen`.
- Navigimi kryesor ndahet në 4 seksione:
  - `Sfida e Ditës`
  - `Mësime`
  - `Tabelat`
  - `Progresi`
- Ndërrimi i tabs nuk duhet të humbasë menjëherë kontekstin e faqes së përzgjedhur brenda sesionit aktual.

#### Implementimi aktual

- Tabs menaxhohen me `IndexedStack` dhe `_selectedIndex` në `DashboardScreen`.
- Navigimi në module dytësore bëhet me `MaterialPageRoute`.

### 6.3 Sfida aritmetike

#### Qëllimi i modulit

- Të ofrojë ushtrime të shpejta me multiple-choice për 4 operacione bazë.

#### Operacionet autoritative

| Operacioni | Label | Simboli i shfaqjes |
|---|---|---|
| Mbledhje | `Mbledhje` | `+` |
| Zbritje | `Zbritje` | `-` |
| Shumëzim | `Shumëzim` | `x` |
| Pjesëtim | `Pjesëtim` | `÷` |

#### Nivelet e vështirësisë

| Niveli | Rregulli |
|---|---|
| 1 | Numra të vegjël, hyrës |
| 2 | Numra të mesëm |
| 3 | Numra më të mëdhenj |

#### Rregullat autoritative të gjenerimit

- Mbledhje:
  - `num1` dhe `num2` gjenerohen pozitivë brenda diapazonit të nivelit.
- Zbritje:
  - rezultati duhet të jetë jo-negativ në flow-un standard të sfidës.
- Shumëzim:
  - diapazoni i faktorëve ulet krahasuar me mbledhjen për të ruajtur vështirësi të ekuilibruar.
- Pjesëtim:
  - pyetjet standarde të sfidës duhet të japin pjesëtim pa mbetje.

#### Rregullat e sesionit

| Parametri | Rregulli aktual |
|---|---|
| Session length default | 5 pyetje për sfidën aritmetike |
| Numri i opsioneve | 4 |
| Pikë për përgjigje të saktë | 10 |
| Accuracy | `(correct / sessionLength) * 100` |

#### Rregullat e feedback-ut

- Përgjigjja e saktë duhet të japë feedback pozitiv.
- Përgjigjja e gabuar duhet të japë feedback korrigjues pa penalizim të rëndë.
- Pas përgjigjes së saktë, rrjedha kalon automatikisht te pyetja tjetër ose te rezultatet.

### 6.4 Sfida gjeometrike

#### Qëllimi i modulit

- Të prezantojë forma bazë dhe llogaritje të thjeshta me mbështetje vizuale.

#### Format autoritative

| Forma | Llogaritja |
|---|---|
| Drejtkëndësh | Sipërfaqe / Perimetër |
| Trekëndësh | Sipërfaqe |
| Katror | Sipërfaqe / Perimetër |
| Rreth | Perimetër (`π ≈ 3`) |
| Paralelogram | Sipërfaqe |

#### Rregullat e sesionit

| Parametri | Rregulli aktual |
|---|---|
| Session length default | 4 pyetje |
| Numri i opsioneve | 4 |
| Pikë për përgjigje të saktë | 15 |

#### Rregullat e gjenerimit

- Drejtkëndëshi llogaritet me `gjerësi * lartësi` për sipërfaqe ose `2 * (gjerësi + lartësi)` për perimetër.
- Trekëndëshi llogaritet me `(bazë * lartësi) / 2`.
- Katrori llogaritet me `brinja * brinja` për sipërfaqe ose `brinja * 4` për perimetrin.
- Rrethi llogaritet me `2 * π * r`, ku për modul bazë përdoret `π ≈ 3`.
- Paralelogrami llogaritet me `bazë * lartësi`.
- Opsionet duhet të jenë pozitive dhe të plausibile.

### 6.5 Tabelat matematikore

#### Qëllimi i modulit

- Të shërbejë si modul praktik dhe referencial për faktet bazë matematikore.

#### Rregullat e aprovura të produktit

- Përdoruesi zgjedh një operacion.
- Përdoruesi zgjedh një numër baze nga 1 deri 12.
- Sistemi shfaq 10 rezultate për tabelën e përzgjedhur.
- Rezultatet duhet të jenë pedagogjikisht të përshtatshme për audiencën kryesore.

#### Modaliteti Invers (Sprint 7 A-01/A-02)

Tabela ka dy modalitete të aktivizueshme me toggle:

| Modaliteti | Zbritja | Pjesëtimi |
|---|---|---|
| Klasik | `8 − 3 = ?` | `12 ÷ 3 = ?` |
| Invers | `? + 3 = 8` (inverse i mbledhjes) | `? × 3 = 12` (plotëso shumëzimin) |

- Toggle `_InverseModeToggle` chip shfaqet në header të tabelave.
- Mbledhja dhe shumëzimi nuk ndryshojnë në modalitetin invers.
- Persisti i modalitetit: planifikuar për Sprint 8 A-04 (Hive).

#### Statusi normativ i sjelljes së pritshme

- Mbledhja dhe shumëzimi mund të shfaqen drejtpërdrejt.
- Zbritja në modulin bazë nuk duhet të prezantohet me rezultate negative, përveç nëse ekziston një modalitet i dedikuar i avancuar.
- Pjesëtimi në modulin bazë nuk duhet të shfaqë rezultat të truncuar. Duhet të shfaqen vetëm raste me pjesëtim të saktë ose të ketë një format tjetër shpjegues.

### 6.6 Moduli Gamify

#### Qëllimi i modulit

- Të lejojë futjen e një ushtrimi me tekst, kamerë ose galeri dhe të japë një shpjegim argëtues.

#### Format e input-it

| Forma e input-it | Statusi |
|---|---|
| Tekst manual | Aktiv |
| Kamera | Aktiv |
| Galeria | Aktiv |
| OCR real | Jo aktiv ende |

#### Rregullat e parser-it aktual

- Input-i normalizohet në lowercase.
- Hiqen fjalë kyçe bazë si:
  - `zgjidh`
  - `llogarit`
  - `sa është`
  - `janë`
- Parser-i aktual mbështet:
  - `+`
  - `-`
  - `*`
  - `x`
  - `×`
  - `/`
  - `÷`

#### Rregullat e sjelljes

- Nëse input-i është bosh, përdoruesi merr një mesazh gabimi.
- Nëse shprehja kuptohet, gjenerohet një zgjidhje narrative argëtuese.
- Nëse shprehja nuk kuptohet, sistemi jep udhëzim generik dhe shembuj.

#### Statusi normativ

- OCR nuk konsiderohet i implementuar derisa `_processImage()` të zëvendësohet me njohje reale të tekstit.
- Placeholder tekstual nuk konsiderohet implementim i plotë i vision/OCR.

### 6.7 Progresi dhe rezultatet

#### Rregullat aktuale

- `ResultsScreen` shfaq gjithmonë:
  - pikët totale,
  - saktësinë në përqindje,
  - CTA për kthim në dashboard.
- Moduli `Progresi` në dashboard është aktualisht informues dhe statik, jo i lidhur me persistence reale.

### 6.8 Sfida "Gjej X-in" (MissingX)

#### Qëllimi i modulit

- Të stërvitë të menduarit inversal duke gjetur numrin e munguar në ekuacion.

#### Llojet e pyetjeve

| Tipi | Shembull | Zgjidhja |
|---|---|---|
| `addMissingAddend` | `5 + ? = 12` | `? = 7` |
| `multMissingFactor` | `? × 4 = 20` | `? = 5` |
| `subMissingSubtrahend` | `9 − ? = 3` | `? = 6` |

#### Rregullat e sesionit

| Parametri | Vlera |
|---|---|
| Session length default | 4 pyetje |
| Numri i opsioneve | 4 |
| Pikë për përgjigje të saktë | 10 |
| Shfaqja e `?` | Cyan, bold, font ×1.1 |

#### Rregullat e gjenerimit

- Të gjithë numrat (knownNum, answer, result) janë pozitivë.
- `answer` ≥ 1 gjithmonë.
- 4 opsione unike — asnjë negativ ose zero.

- `ResultsScreen` shfaq gjithmonë:
  - pikët totale,
  - saktësinë në përqindje,
  - CTA për kthim në dashboard.
- Moduli `Progresi` në dashboard është aktualisht informues dhe statik, jo i lidhur me persistence reale.

## 7. Specifikimet e dizajnit

Ky seksion është autoriteti i vetëm për vendimet vizuale bazë të produktit.

### 7.1 Tema vizuale

Tema zyrtare e MathLingo është `Cosmic Dark`.

Karakteristikat:

- sfond i errët blu-vjollcë,
- akcent magenta neon,
- akcent sekondar cyan neon,
- panele me efekt glassmorphism,
- tone të buta për tekst dytësor,
- kontrast i lartë për veprimet kryesore.

### 7.2 Paleta autoritative e ngjyrave

| Token | Hex | Roli |
|---|---|---|
| `background` | `#101126` | Sfond global |
| `surface` | `#1D1E33` | Surface kryesor |
| `surfaceLow` | `#191A2F` | Surface i ulët |
| `surfaceHigh` | `#27283E` | Surface i ngritur |
| `surfaceHighest` | `#32334A` | Surface me kontrast më të lartë |
| `onSurface` | `#FFFFFF` | Tekst kryesor |
| `onSurfaceVariant` | `#EEEBFF` | Tekst sekondar |
| `outline` | `#B9A7BC` | Kufij |
| `outlineVariant` | `#6C5E70` | Kufij sekondarë |
| `primary` | `#F3D6FF` | Ton primar i lehtë |
| `primaryContainer` | `#BC13FE` | Magenta neon, akcent primar |
| `onPrimaryContainer` | `#FFFFFF` | Tekst mbi akcentin primar |
| `secondary` | `#D3FBFF` | Ton sekondar i lehtë |
| `secondaryContainer` | `#00EEFC` | Cyan neon, akcent sekondar |
| `tertiary` | `#FFACE8` | Akcent terciar |
| `tertiaryContainer` | `#D700C1` | Magenta gradient i errët |
| `error` | `#FFB4AB` | Error state |

### 7.3 Tipografia autoritative

| Stil | Madhësia | Pesha | Përdorimi |
|---|---|---|---|
| `headlineLarge` | 32 | 800 | Tituj kryesorë |
| `headlineMedium` | 24 | 700 | Tituj seksionesh dhe modulesh |
| `bodyMedium` | 16 | normal | Përshkrime dhe tekst ndihmës |
| `labelLarge` | 14 | 700 | Etiketa dhe meta labels |

### 7.4 Widget-et dhe komponentët custom autoritativë

| Komponenti | Roli |
|---|---|
| `GlassPanel` | Panel vizual me glassmorphism |
| `CosmicButton` | Butoni primar CTA me gradient |
| `_CosmicTopBar` | App bar i personalizuar |
| `_CosmicBottomNav` | Bottom navigation i personalizuar |
| `_CosmicProgress` | Progress bar me stil tematik |
| `_AnswerButton` | Butoni i përgjigjeve në sfida |
| `_MascotFrame` | Kontejneri i mascot-it me animacion |
| `_NeonChip` | Label i vogël me akcent neon |
| `ResponsivePage` | Wrapper për layout responsive |

### 7.5 Rregullat vizuale të komponentëve

#### `GlassPanel`

- Duhet të ketë border radius të madh.
- Duhet të përdorë gradient të butë dhe border transparent.
- Duhet të japë ndjesi floating pa humbur kontrastin e tekstit.

#### `CosmicButton`

- Duhet të përdorë gradient nga `primaryContainer` te `tertiaryContainer`.
- Duhet të jetë komponenti kryesor i aksionit.
- Duhet të jetë i lexueshëm dhe i prekshëm lehtësisht në mobile.

#### `_CosmicBottomNav`

- Është navigimi primar i aplikacionit.
- Duhet të ketë identitet të qëndrueshëm në të gjitha ekranet ku përdoret.

#### `_MascotFrame`

- Mascot-i është pjesë e identitetit të produktit.
- Asset-i aktual përdor `assets/icons/stich_icon.png`.
- Branding-u i produktit e referon si Stitch, pavarësisht emrit aktual të asset-it.

### 7.6 Rregullat responsive autoritative

| Gjerësia | Sjellja |
|---|---|
| `< 600` | Layout kompakt |
| `600 - 799` | 3 ose më shumë kolona sipas kontekstit |
| `800 - 1099` | Layout i zgjeruar, tablet dhe medium screens |
| `>= 1100` | Max width 1120 dhe përdorim i kolonave expanded |

### 7.7 Rregullat e ndërveprimit

- Touch targets duhet të jenë të sigurta për përdorim mobile.
- Butonat numerikë, quick action tiles dhe bottom nav konsiderohen pjesë kritike të UX-it.
- Snackbar ose messaging i përkohshëm nuk duhet të fshehë navigimin primar për një kohë të gjatë.

## 8. Statusi aktual i implementimit

Ky seksion përshkruan gjendjen reale të projektit në kohën e hartimit të SSOT-it.

### 8.1 Matrica e statusit

| Zona | Statusi | Shënim |
|---|---|---|
| Shell i aplikacionit | Implementuar | `MathLingoApp` me Material 3 dhe theme custom |
| Dashboard | Implementuar | Ka 4 tabs dhe kartat kryesore |
| Sfida aritmetike | Implementuar | 4 operacione, 3 nivele, DistractorEngine pedagogjik (Sprint 7 B-01/B-02) |
| Sfida gjeometrike | Implementuar | 5 forma, area/perimetër (Sprint 7 D-02), CustomPainter me raport dimensional korrekt (D-01), painter custom, scoring aktiv |
| Results screen | Implementuar | Pikë, saktësi, kthim në dashboard |
| Tabelat matematikore | Implementuar | Zbritja shmang negativet, pjesëtimi pa mbetje, modalitet invers (Sprint 7 A-01–A-04); ridizenjim kartave (Sprint 14): `_TableCard` zbulim interaktiv, `_TableOperationTheme` ngjyra per operacion |
| Gamify me input manual | Implementuar | Parser funksional për operacione bazë |
| Gamify me kamerë/galeri | Implementuar pjesërisht | Input-i merret me ML Kit OCR; OCR shkrim dore është kufizim i njohur i ML Kit |
| OCR printed text | Implementuar | `_processImage()` me fallback pipeline + preprocesim |
| Localization shqip | Implementuar | `flutter_localizations` + ARB files + 200+ strings shqip |
| Persistence e progresit | Implementuar | `ChildProfile`, `UserProgress` ruhen me Hive |
| Authentication Firebase | Implementuar | Firebase Auth (Email/Password); `AuthService`; `AuthNotifier`; lazy init pas consent |
| Cloud Sync Firestore | Implementuar | `SyncService` — opt-in; `FirestoreSchema` — path constants; GDPR delete |
| Profili Familjar | Implementuar | `ChildProfile`, `FamilyProfile`, PIN protection, `FamilySwitcherScreen` |
| Sistemi i Arritjeve | Implementuar | `AchievementService` + `BadgeDisplayScreen` + `BadgeNotificationOverlay` + Hive persist |
| Leaderboard | Implementuar | `LeaderboardScreen` — renditje sipas pikëve |
| Audio feedback | Implementuar | `AudioService` me `audioplayers`; triggered nga eventi i saktë/gabuar/level-up |
| Haptic feedback | Implementuar | `HapticService` — light/medium/heavy/success/error |
| Eksport CSV | Implementuar | `DataExportService` + `share_plus` |
| Raport Prindi | Implementuar | `ParentReportScreen` — statistika sesioni për secilin fëmijë |
| Consent & Privacy | Implementuar | `ConsentFlowScreen`, `PrivacyPolicyScreen`, `DeleteAllDataScreen` (GDPR Art. 17) |
| Settings i plotë | Implementuar | `SettingsScreen` me seksione: Profili, Gamifikimi, Cloud Sync, Privatësia |
| Arkitektura Feature-Based | Implementuar | 13 features të ndarë; `lib/core/`, `lib/shared/`, `lib/models/` |
| State management Riverpod | Implementuar | `StateNotifierProvider` + `autoDispose.family` për të gjitha features |
| DistractorEngine | Implementuar | Domain Layer, gabimet tipike pedagogjike, 11 teste |
| MissingX "Gjej X-in" | Implementuar | Model + generator + ekran + karta dashboard, 9 teste |
| DifficultyEngine adaptiv | Implementuar | Level-up/down automatik; `SessionTracker` Hive sliding window; `_NeonLevelChip` UI |
| Fraksionet vizuale | Implementuar | `FractionPainter` (pie + bar), 4 pyetje/sesion, 9 fraksione, 6 widget tests |
| Vizualizimi Grilë Shumëzimi | Implementuar | `MultiplicationGridPainter` me animacion sekuencial |
| Android Release Signing | Implementuar | `mathlingo-release.jks`; `key.properties` gitignored; `build.gradle.kts` i konfiguruar |
| Raportet Prindërore | Implementuar | `ParentReportScreen` me BarChart/LineChart (`fl_chart`), auto-sync, `_RecentActivitySection` |
| Testim unit | Implementuar | 146 teste kalin ✅ |
| Integration tests | Jo të implementuara | Mungojnë flows fundorë (Deferred) |

### 8.2 Statusi i QA dhe build-it

| Fusha | Statusi aktual |
|---|---|
| `fvm flutter test` | 146/146 ✅ (19 Maj 2026) |
| `fvm flutter analyze` | 0 issues ✅ (19 Maj 2026) |
| Android Release Signing | Konfiguruar — `mathlingo-release.jks` |
| Firebase Registered | ✅ — 5 platforma në projekt `mathlingo-90084` |
| Email/Password Auth Provider | ✅ Aktivizuar në Firebase Console |
| iOS `GoogleService-Info.plist` | Jashtë scope v1.9.0 — Deferred |

### 8.3 Devijimet aktuale të njohura

| Devijimi | Kategoria | Statusi |
|---|---|---|
| OCR shkrim dore (ML Kit `blocks=0`) | Feature completeness | Monitor — kufizim i njohur |
| Email/Password Auth Provider jo aktiv në Firebase Console | Firebase Config | Monitor — kërkon veprim manual |
| `GoogleService-Info.plist` mungon nga repo | iOS Build | Monitor — gitignored me qëllim |

## 9. Çfarë konsiderohet e përfunduar dhe çfarë jo

### 9.1 E përfunduar — Release Candidate v2.0.1

- Identiteti vizual Cosmic Dark, tema autoritative `CosmicColors`.
- Dashboard me navigim të qartë dhe kartat e të gjitha moduleve.
- Sfidat bazë aritmetike me `DistractorEngine` pedagogjik dhe `DifficultyEngine` adaptiv.
- Sfida gjeometrike me 5 forma, area/perimetër, `GeometryHintChip`, `CustomPainter`.
- Sfida "Gjej X-in" (MissingX) për të menduarit inversal.
- Fraksionet vizuale (pie + bar) me `FractionPainter` dhe `FractionGenerator`.
- Tabelat me modalitet klasik dhe invers (mbledhje, zbritje, shumëzim, pjesëtim) — logjika inverse e verifikuar; ridizenjim i plotë kartave (Sprint 14) me `_TableCard` interaktiv, `_TableOperationTheme`, selektor numrash kompakt.
- Moduli Gamify me OCR ML Kit (printed text), fallback pipeline, parser simbolik dhe kuadratik.
- Sistem familjar: profila fëmijësh, PIN protection, `FamilySwitcherScreen`, `ParentReportScreen`.
- Raportet e prindërve me grafik (`BarChart` + `LineChart` nga `fl_chart`), statistika javore, seksion aktiviteti i fundit, auto-sync.
- Sistemi i arritjeve: `AchievementService`, badge display, overlay njoftimi (kontrast WCAG ✅).
- Leaderboard familjar (të gjithë fëmijët me `isActive` highlight).
- Audio + Haptic feedback.
- Cloud Sync opt-in me Firebase Auth (Email/Password) + Firestore.
- Consent flow + Privacy Policy + GDPR delete (`DeleteAllDataScreen`).
- `SettingsScreen` i plotë.
- Android Release Signing konfiguruar.
- `flutter_localizations` + ARB + 200+ strings shqip.
- Persistencë lokale me Hive (pa codegen) për të gjitha modulet.
- Arkitekturë Feature-Based me Domain/Service/Provider/Presentation shtresë.
- 146 teste kalojnë; 0 issues analyze.

### 9.2 Deferred — Jo e përfunduar

- Integration tests (flows fundorë).
- iOS `GoogleService-Info.plist` në repo (jashtë scope v1.10.1 — Deferred).
- OCR shkrim dore (kufizim ML Kit — kërkon Google Vision API cloud).
- Multi-language lokalizim (shqip vetëm aktualisht).
- Golden tests për ekranet kryesore.

## 10. Rruga e aprovuar e evolucionit teknik

Ky seksion nuk është backlog i plotë, por përkufizon drejtimin teknik të aprovuar.

### 10.1 Prioritetet afatshkurtra (Sprint i ardhshëm)

- Aktivizimi i Email/Password Auth Provider në Firebase Console.
- Gjenerimi dhe integrimi i `GoogleService-Info.plist` për iOS build.
- Shtimi i integration tests për flows kryesore (consent → auth → sync).
- CI/CD workflow me GitHub Actions (`flutter analyze` + `flutter test` + build debug).

### 10.2 Prioritetet afatmesme

- Zgjerim i Firestore Security Rules (`users/{uid}` path protection).
- Golden tests vizuale për ekranet kryesore (Cosmic Dark tema).
- Zgjerim i `DifficultyEngine` me algoritëm adaptiv ML të thjeshtë.
- OCR shkrim dore me Google Vision API cloud (parakusht: backend proxy).

### 10.3 Prioritetet afatgjata

- Multi-language lokalizim (anglisht si locale e dytë për QA).
- Analytics dhe telemetri lokale e sesioneve.
- Publikim në Google Play Store (Release APK/AAB i verifikuar).
- Zgjerim curriculum: numrat dhjetorë, përqindjet, algjebra elementare.

## 11. Udhëzues i shpejtë për zhvillues të rinj

### 11.1 Nga të fillosh

1. Lexo këtë dokument.
2. Lexo `pubspec.yaml` për varësitë dhe baseline-in teknik.
3. Lexo `lib/features/` për rrjedhën aktuale të ekraneve.
4. Lexo `lib/shared/` për komponentët dhe painter-at e ripërdorshëm.
5. Lexo `lib/colors.dart`, `lib/responsive.dart`, `lib/gamify_exercise.dart` dhe `lib/simple_tables.dart` për theme/layout dhe modulet jashtë Sprint 2.

### 11.2 Çfarë duhet ruajtur patjetër

- Gjuha shqipe si gjuhë primare.
- Identiteti Cosmic Dark.
- Thjeshtësia e përdorimit për nxënës.
- Feedback i shpejtë dhe i qartë.

### 11.3 Çfarë nuk duhet normalizuar si “e saktë”

- Pjesëtimi i truncuar në tabelat bazë.
- Rezultatet negative në tabelat bazë pa kontekst pedagogjik.
- Placeholder OCR si feature e përfunduar.
- Debug signing si konfigurim production.

## 12. Përfundimi autoritativ

MathLingo është aktualisht një MVP funksional me identitet të fortë vizual dhe me bazë solide për mësim interaktiv të matematikës. E vërteta operative e projektit është kjo:

- produkti është vizualisht i qartë dhe funksional në modulët kryesorë,
- ka rregulla të mira bazë për sfidat aritmetike dhe gjeometrike,
- ka borxh teknik të menaxhueshëm, por të dukshëm,
- nuk është ende gati si produkt i plotë production-grade pa korrigjuar build readiness, localization, persistence, architecture dhe correctness të tabelave.

Ky dokument mbetet referenca qendrore për vendimmarrje teknike dhe produkti deri në përditësimin e tij të ardhshëm.