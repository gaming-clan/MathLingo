# 🏃 MathLingo — Plani i Plotë i Sprinteve S7–S12

> **Dokumenti:** Sprint Planning v1.0  
> **Data:** Maj 2026  
> **Versioni aktual:** v1.3.0 (pas Sprint 6)  
> **Target final:** v2.0.0  
> **Gjuha:** Shqip (UI), Dart/Flutter (kod)

---

## Konteksti i pikënisjes

Pas Sprint 6, MathLingo ka:
- Riverpod + AdaptiveScaffold + Hive aktive
- OCR pipeline me fallback (tekst i shtypur funksionon, shkrimi dore B011 Monitor)
- Sprint 7 planifikuar por ende i pa filluar
- Android Release Signing i hapur si bllokues Play Store
- GDPR compliance 0% — vendim: rruga hibride (lokal default, cloud opt-in prindëror)

---

## 🔵 Sprint 7 — Thellimi Pedagogjik & Logjika Matematikore
**Versioni:** v1.4.0 | **Kohëzgjatja:** 2 javë | **Varësia:** asnjë

### Konteksti

Sprint 7 adresson mangësitë pedagogjike të identifikuara pas analizës vizuale dhe matematikore të aplikacionit. Tabelat e zbritjes dhe pjesëtimit kanë probleme konceptuale serioze. Distractors janë random, jo pedagogjikë. Gjeometria ka probleme vizuale. Asnjë pyetje me "x të panjohur" nuk ekziston.

### Track A — Reforma e Tabelave (5 detyra)

**A-01** `prioritet i lartë`  
Ridizajno tabelën e Zbritjes si "Inverse të Mbledhjes". Tabela e 4 tregon `4+1=5 → 5-4=?` në vend të `4-1, 4-2`. Krijon lidhjen inverse sipas kurrikulës shqiptare kl.1-4.

**A-02** `prioritet i lartë`  
Reformulo tabelën e Pjesëtimit si "Plotëso shumëzimin". Shfaq `4×?=28` në vend të `28÷4`. Paraqet të gjithë shumëfishat (jo vetëm ndarësit e numrit të zgjedhur).

**A-03** `prioritet i lartë`  
Shto model të ri `TableQuestion` me fushën `questionType`. Enum: `standard | inverse_add | inverse_mult | fill_blank`. Provider i ri: `TablesV2Provider` (Riverpod StateNotifier).

**A-04** `prioritet mesatar`  
Toggle UI "Mënyrë Klasike / Mënyrë Inverse" në header të tabelave. Widget `CosmicChip` pranë selectorit të numrit. Zgjedhja persiston me Hive.

**A-05** `prioritet mesatar`  
Unit tests për gjeneratorin e ri. Verifikon: asnjë rezultat negativ, të gjitha rastet me mbetje 0, mbulim i shumëfishave 1–12.

### Track B — Distractor Engine Pedagogjik (3 detyra)

**B-01** `prioritet i lartë`  
Krijo `DistractorEngine` si klasë e ndarë në Domain Layer. Metoda `generateFor(operation, correctAnswer) → List<int>`. Nuk duhet të jetë brenda widget-eve.

**B-02** `prioritet i lartë`  
Implemento gabimet tipike për çdo operacion:
- Mbledhje: gabim carry (`1+9=19`)
- Shumëzim: tabela ngjitur (`7×8→54, 56, 63`)
- Zbritje: operandë të inversuar (`9-3=6` vs `3-9`)
- Pjesëtim: rezultat i shumëzimit inversal

**B-03** `prioritet mesatar`  
Unit tests: 500 pyetje → 0 opsione duplicate, saktësisht 1 e saktë. Shpërndarje statistikore e distractors e verifikuar.

### Track C — Sfida "X i Panjohur" (4 detyra)

**C-01** `prioritet i lartë`  
Shto model `MissingXQuestion` dhe enum `MissingXType`. Llojet: `add_missing_addend (5+?=12)`, `mult_missing_factor (?×4=20)`, `sub_missing_subtrahend (9-?=3)`.

**C-02** `prioritet i lartë`  
Implemento `MissingXGenerator` në Domain Layer. Gjeneron pyetje të vlefshme: rezultat pozitiv, numra brenda diapazonit të nivelit, 4 opsione unike plausible.

**C-03** `prioritet i lartë`  
Krijo `MissingXChallengeScreen` si feature e ndarë (`lib/features/missing_x/`). Shfaq `?` vizualisht të dalluar (cyan, bold). Integrohet me `ProgressProvider` ekzistues.

**C-04** `prioritet i ulët`  
Shto kartë të re "Gjej X-in" në `_DashboardPage`. Feature flag: aktivizohet vetëm pas kompletimit të C-01, C-02, C-03.

### Track D — Gjeometri Vizuale & Konceptuale (4 detyra)

**D-01** `prioritet i lartë`  
Fix `CustomPainter`: respekto raportin gjerësi/lartësi. Drejtkëndësh `gjerësi 4, lartësi 6` duhet vizualisht vertikal, jo horizontal. Golden tests para dhe pas.

**D-02** `prioritet i lartë`  
Shto llogaritjen e perimetrit për drejtkëndësh dhe katror. Enum i ri: `GeometryQuestion.calculationType` (`area | perimeter`). Generatori gjeneron të dy llojet.

**D-03** `prioritet mesatar`  
Shto formulën vizuale si hint: `NeonChip` i vogël nën formë me `S = g × l`. Shfaqet vetëm pas 2 sekondash (delayed display).

**D-04** `prioritet mesatar`  
Golden tests `CustomPainter` output: screenshot para/pas D-01 për verifikim proporcionesh.

### Planifikimi javor Sprint 7

| Java | Ditët | Detyrat |
|------|-------|---------|
| Java 1 | D1–D2 | A-01, A-03 (model + tabela zbritje) |
| Java 1 | D3–D4 | A-02, B-01 (tabela pjesëtim + DistractorEngine) |
| Java 1 | D5 | B-02, A-04 (gabimet tipike + toggle UI) |
| Java 2 | D1–D3 | C-01, C-02, C-03 (MissingX komplet) |
| Java 2 | D4–D5 | D-01, D-02, D-03, A-05, B-03, D-04 (fix + tests) |

### Kriteret e pranimit Sprint 7

- [ ] Tabela Zbritje tregon relacionin inverse në "Mënyrë Inverse"
- [ ] Tabela Pjesëtim tregon të gjithë shumëfishat në "Mënyrë Inverse"
- [ ] Distractors janë gabime tipike pedagogjike, jo random ±6
- [ ] Sfida MissingX funksionon për mbledhje dhe shumëzim (minimum)
- [ ] `CustomPainter` respekton raportin gjerësi/lartësi
- [ ] Gjeometria ofron pyetje perimetri
- [ ] `fvm flutter test` kalon (unit tests të reja)
- [ ] `fvm flutter analyze` — 0 warnings

---

## 🔵 Sprint 8 — Adaptiviteti & Android Release Signing
**Versioni:** v1.5.0 | **Kohëzgjatja:** 2 javë | **Varësia:** Sprint 7 Track A+B

### Konteksti

Sprint 8 mbyll dy boshllëqe të mëdha: (1) sistemi adaptiv i vështirësisë që e bën aplikacionin të "mësohet" me fëmijën, dhe (2) Android Release Signing — bllokuesi i vetëm i mbetur për Play Store. Këto dy gjëra janë të pavarura dhe mund të punohen paralelisht.

### Track A — DifficultyEngine Adaptiv (4 detyra)

**A-01** `prioritet i lartë`  
Krijo `DifficultyEngine` si klasë pure Dart në Domain Layer. Logjika: pas 3 sesionesh me saktësi ≥90%, niveli rritet automatikisht. Pas 3 sesionesh me saktësi <50%, niveli ulet.

**A-02** `prioritet i lartë`  
Implemento `SessionTracker` me Hive. Ruan: saktësinë e 5 sesioneve të fundit për çdo operacion. Nuk ruan historik të plotë — vetëm sliding window 5 sesionesh.

**A-03** `prioritet i lartë`  
Integro `DifficultyEngine` me `ChallengeProvider` dhe `GeometryProvider`. Niveli aktual lexohet nga Hive para çdo sesioni të ri.

**A-04** `prioritet mesatar`  
UI indicator i nivelit aktual: `NeonChip` i vogël në `ChallengeScreen` (`Niveli 1 / 2 / 3`). Animacion i vogël kur ndodh level-up.

### Track B — Android Release Signing (3 detyra)

**B-01** `prioritet i lartë — BLLOKUES`  
Gjenero `keystore` release për `com.mathlingo.app`. Konfigurim `key.properties` (jashtë git). Update `android/app/build.gradle.kts` me `signingConfigs.release`.

**B-02** `prioritet i lartë — BLLOKUES`  
Verifiko build release: `fvm flutter build apk --release` dhe `fvm flutter build appbundle --release`. APK duhet nënshkruar me certificate të re (jo debug).

**B-03** `prioritet i lartë`  
Verifiko AAPT2 ARM64 Linux (bug B005 Monitor). Nëse konfirmohet, shto workaround në `build.gradle.kts`. Mbyll bug B005.

### Track C — Unit Tests & QA (2 detyra)

**C-01** `prioritet mesatar`  
Unit tests `DifficultyEngine`: verifikon level-up pas 3 sesionesh ≥90%, level-down pas 3 sesionesh <50%, qëndrueshmëri në nivel mesatar.

**C-02** `prioritet mesatar`  
Integration test i rrjedhës komplet: sesion → SessionTracker → DifficultyEngine → nivel i ri → ChallengeScreen shfaq pyetje me diapazon të ri.

### Kriteret e pranimit Sprint 8

- [ ] Niveli rritet automatikisht pas 3 sesionesh me saktësi ≥90%
- [ ] Niveli ulet automatikisht pas 3 sesionesh me saktësi <50%
- [ ] `fvm flutter build appbundle --release` prodhon bundle të nënshkruar
- [ ] APK mund të instalohet në pajisje fizike pa "untrusted source" warning
- [ ] Bug B005 (AAPT2) konfirmuar ose zgjidhur
- [ ] `fvm flutter test` kalon

---

## 🔵 Sprint 9 — Fraksionet & Vizualizimi Konceptual
**Versioni:** v1.5.1 | **Kohëzgjatja:** 2 javë | **Varësia:** Sprint 7 (D-01 i domosdoshëm)

### Konteksti

Sprint 9 shton dy module pedagogjike të reja që zgjerojnë audiencën nga klasa 1-4 drejt klasës 3-6: (1) fraksionet si objekte vizuale (jo si numra abstraktë), dhe (2) vizualizimi grilë i shumëzimit që kalon nga memorizimi në kuptim konceptual.

### Track A — Moduli i Fraksioneve (5 detyra)

**A-01** `prioritet i lartë`  
Krijo model `FractionQuestion` në Domain Layer. Fushat: `numerator`, `denominator`, `answer`, `options`, `visualType` (`pie | bar | set`).

**A-02** `prioritet i lartë`  
Implemento `FractionGenerator`. Fraksionet e mbështetura për MVP: `½, ⅓, ¼, ¾, ⅔, ⅛, ⅜, ⅝, ⅞`. Gjeneron: identifikim fraksioni nga vizualizim, krahasim fraksionesh, mbledhje fraksionesh me emërues të njëjtë.

**A-03** `prioritet i lartë`  
Krijo `FractionPainter` (CustomPainter). Vizualizon: tarte e ndarë (`pie`), shirit i ndarë (`bar`). Ngjyrat: pjesa e ngjyrosur cyan, pjesa e panjë surfaceLow. Madhësia adaptive.

**A-04** `prioritet i lartë`  
Krijo `FractionChallengeScreen` si feature e ndarë (`lib/features/fraction/`). Integrohet me `ProgressProvider`. 4 pyetje për sesion, +15 pikë secila.

**A-05** `prioritet mesatar`  
ARB strings për fraksionet në shqip: `gjysmë`, `një e treta`, `një e katërta` etj. Shto në `app_sq.arb`.

### Track B — Vizualizimi Grilë Shumëzimi (3 detyra)

**B-01** `prioritet i lartë`  
Krijo `MultiplicationGridPainter` (CustomPainter). Vizualizon `3×4` si grilë 3 rreshta × 4 kolona me 12 qeliza. Qelizat ngjyrosen cyan me animacion sekuencial (300ms delay mes kolonave).

**B-02** `prioritet mesatar`  
Integro `MultiplicationGridPainter` si modalitet opsional në `ChallengeScreen` për shumëzim: buton "Shfaq Grilën" anës pyetjes.

**B-03** `prioritet mesatar`  
Widget tests `FractionPainter` dhe `MultiplicationGridPainter`: verifikojnë dimensionet, numrin e seksioneve, proporcionet.

### Milestone pas Sprint 9

**Play Store Beta (Internal Testing)**  
Versioni v1.5.1 me release bundle të nënshkruar (Sprint 8) dhe përmbajtje pedagogjike të plotë (Sprint 7+9) është gati për distribitim internal testing në Google Play.

### Kriteret e pranimit Sprint 9

- [ ] `FractionPainter` shfaq tarte dhe shirit të ndarë saktë
- [ ] Fraksionet ½, ⅓, ¼, ¾ funksionojnë si pyetje multiple-choice
- [ ] `MultiplicationGridPainter` shfaq grilën animuar
- [ ] Butoni "Shfaq Grilën" funksionon pa ndërprerë rrjedhën e sfidës
- [ ] ARB strings shqip të plota për fraksionet
- [ ] `fvm flutter test` kalon (widget tests)

---

## 🟡 Sprint 10A — Profili Familjar Lokal
**Versioni:** v1.6.0 | **Kohëzgjatja:** 1.5 javë | **Varësia:** Sprint 9

### Konteksti

Sprint 10A implementon sistemin e profilimit familjar plotësisht lokal — pa asnjë cloud, pa asnjë regjistrim online. Prindi krijon profil lokal, shton 1–4 fëmijë me pseudonime dhe avatarë. Ky sprint është i pavarur nga Firebase dhe plotësisht GDPR-compliant automatikisht.

**Vendim arkitekturor:** Hive mbetet burimi i vetëm i të dhënave. Cloud nuk ekziston ende. Kjo është zgjedhje e qëllimshme sipas parimit "Privacy by Default" (GDPR Neni 25).

### Track A — Modeli i Profilit Familjar (4 detyra)

**A-01** `prioritet i lartë`  
Krijo modele `FamilyProfile` dhe `ChildProfile` me Hive TypeAdapters. Fushat `FamilyProfile`: `id`, `createdAt`, `children[]`. Fushat `ChildProfile`: `id`, `pseudonym`, `avatarIndex`, `totalPoints`, `accuracy`, `moduleHistory`.

**A-02** `prioritet i lartë`  
Implemento `FamilyProfileRepository` (Riverpod Provider). Operacionet: `createFamily()`, `addChild()`, `updateChildProgress()`, `deleteChild()`, `deleteFamily()`.

**A-03** `prioritet i lartë`  
Ekran `FamilySetupScreen` — hyrja e parë kur nuk ka profil. Pyetje: "Si ta quajmë fëmijën?" (pseudonim, max 20 karaktere). Zgjedhje avatari (8 opsione — emoji ose ikonë simple pa imazh real). `CosmicButton` "Fillo Aventurën".

**A-04** `prioritet mesatar`  
Ekran `FamilySwitcherScreen` — ndërrimi i profilit aktiv. Listë me kartat e fëmijëve (pseudonim + avatar + pikë totale). Butoni `+` shton fëmijë të ri (max 4).

### Track B — Integrimi me Sistemin Ekzistues (3 detyra)

**B-01** `prioritet i lartë`  
Lidh `ProgressProvider` me `ChildProfile` aktiv. Çdo sesion shkruan pikët dhe saktësinë te profili aktiv i Hive-it, jo te një hap global.

**B-02** `prioritet i lartë`  
Update `DashboardScreen`: shfaq pseudonimin + avatarin e fëmijës aktiv në `_CosmicTopBar`. Tap → hap `FamilySwitcherScreen`.

**B-03** `prioritet mesatar`  
Ekran `ParentReportScreen` (i thjeshtë): statistika agregate për çdo fëmijë. Nuk kërkon PIN ose fjalëkalim në MVP (shtohet Sprint 10.5).

### Kriteret e pranimit Sprint 10A

- [ ] Prindi mund të krijojë familje me 1–4 fëmijë
- [ ] Pseudonimi dhe avatari ruhen në Hive
- [ ] Progres i ndarë mes profileve (fëmija A nuk sheh pikët e fëmijës B)
- [ ] Dashboard shfaq profilin aktiv
- [ ] Fshirja e fëmijës fshin të gjitha të dhënat e tij nga Hive
- [ ] Zero cloud calls — plotësisht offline

---

## 🟡 Sprint 10.5 — Privacy & Compliance
**Versioni:** v1.6.1 | **Kohëzgjatja:** 1 javë | **Varësia:** Sprint 10A | **OBLIGATOR para 10B**

### Konteksti

Sprint 10.5 është sprint i detyrueshëm ligjor. Pa të, aktivizimi i çdo shërbimi cloud është shkelje e GDPR për fëmijë. Ky sprint implementon të drejtat e garantuara nga GDPR Nenet 13, 17, 20, 25 dhe krijon infrastrukturën e consent-it prindëror.

### Detyrat (7 detyra)

**P-01** `prioritet i lartë — LIGJOR`  
Shkruaj Politikën e Privatësisë brenda aplikacionit (jo link i jashtëm). Gjuhë e thjeshtë shqipe, jo legaleze. Seksionet: çfarë mblidhet, pse, kush ka akses, si fshihet. Max 300 fjalë.

**P-02** `prioritet i lartë — LIGJOR`  
Implemento `DeleteAllDataScreen`. Butoni "Fshi të Gjitha të Dhënat" → dialog konfirmimi → fshirje e plotë e Hive (dhe Firestore nëse aktiv). Kthimi në ekranin e setup-it të parë.

**P-03** `prioritet i lartë — LIGJOR`  
Implemento eksport JSON të progresit (`SettingsScreen` → "Shkarko të Dhënat"). Prodhon skedar `mathlingo_progress_[pseudonim]_[data].json`. Respekton GDPR Nenin 20 (portabilitet).

**P-04** `prioritet i lartë`  
Krijo `ConsentFlowScreen` — shfaqet para aktivizimit të çdo shërbimi cloud. Hapat: (1) shpjegim i qartë se çfarë ndodh, (2) checkbox "Jam prind/kujdestar i fëmijës", (3) checkbox "Kam lexuar Politikën e Privatësisë", (4) konfirmim me PIN 4-shifror (prindi vendos PIN-in).

**P-05** `prioritet i lartë`  
`SettingsScreen` i ri: Politika e Privatësisë, Fshi të Dhënat, Shkarko të Dhënat, Rreth Aplikacionit (versioni, kontakti). E aksesueshme nga `_CosmicTopBar`.

**P-06** `prioritet mesatar`  
Konfiguro Firebase Console: çaktivizo Firebase Analytics, çaktivizo Crashlytics automatic collection, aktivizo DPA (Data Processing Agreement) me Google. Dokumento konfigurimin.

**P-07** `prioritet mesatar`  
Shto `age_verification_gate`: nëse fëmija po tenton të regjistrohet direkt (nëse rrugën cloud e gjen vetë), shfaq "Ky seksion kërkon llogari prindi. Lëre prindërin tënd të konfigurojë."

### Kriteret e pranimit Sprint 10.5

- [ ] Politika e Privatësisë e disponueshme brenda aplikacionit
- [ ] Fshirja e plotë e të dhënave funksionon dhe verifikohet
- [ ] Eksporti JSON prodhon skedar të vlefshëm
- [ ] `ConsentFlowScreen` shfaqet para çdo aktivizimi cloud
- [ ] Firebase Analytics është çaktivizuar (verifikim në DebugView)
- [ ] DPA me Google i konfiguruar
- [ ] `fvm flutter analyze` — 0 warnings

---

## 🟡 Sprint 10B — Sinkronizim Cloud Opt-in
**Versioni:** v1.6.2 | **Kohëzgjatja:** 1.5 javë | **Varësia:** Sprint 10A + Sprint 10.5 (TË DY)

### Konteksti

Sprint 10B aktivizon sinkronizimin cloud vetëm për familjet që kanë dhënë consent eksplicit (Sprint 10.5). Firebase Auth përdoret me email (jo Google Sign-In — inkompatibil me GDPR për fëmijë). Firestore është pasqyrë e Hive, jo zëvendësim.

**Rregull kritike:** Aplikacioni vazhdon të funksionojë plotësisht edhe pa lidhje internet. Hive është e vërteta lokale, Firestore është backup.

### Track A — Firebase Auth (3 detyra)

**A-01** `prioritet i lartë`  
Shto `firebase_core`, `firebase_auth`, `cloud_firestore` në `pubspec.yaml`. Konfigurim `google-services.json` (Android) dhe `GoogleService-Info.plist` (iOS). Firebase inicializohet vetëm pas consent-it (jo automatikisht).

**A-02** `prioritet i lartë`  
Implemento `AuthService` (Riverpod Provider). Metoda: `signUpWithEmail()`, `signInWithEmail()`, `signOut()`, `deleteAccount()`. Email vetëm për prindërit — asnjë llogari direkt fëmijësh.

**A-03** `prioritet i lartë`  
Ekrane: `ParentSignUpScreen`, `ParentSignInScreen`. Design: `GlassPanel` me `CosmicButton`. Validim email + fjalëkalim (min 8 karaktere, 1 numër). Lidhja me `ConsentFlowScreen` (Sprint 10.5).

### Track B — Firestore Sync (4 detyra)

**B-01** `prioritet i lartë`  
Krijo `SyncService` (Riverpod Provider). Logjika: Hive → Firestore pas çdo sesioni (nëse online dhe logged in). Firestore → Hive pas login-it të parë në pajisje të re.

**B-02** `prioritet i lartë`  
Skema Firestore: `users/{uid}/children/{childId}/progress/{date}`. Vetëm pseudonime dhe pikë — asnjë emër real, asnjë imazh.

**B-03** `prioritet mesatar`  
Conflict resolution: "last write wins" me timestamp. Nëse Hive ka progres më të ri se Firestore, Hive ka prioritet.

**B-04** `prioritet mesatar`  
Offline handling: nëse nuk ka internet, aplikacioni funksionon normalisht nga Hive. Sinkronizimi ndodh automatikisht sapo rikthehet lidhja.

### Kriteret e pranimit Sprint 10B

- [ ] Prindi mund të krijojë llogari me email
- [ ] Progres sinkronizohet ndërmjet 2 pajisjeve (test me dy telefona)
- [ ] Fshirja e llogarisë fshin të dhënat nga Firestore brenda 30 sekondash
- [ ] Aplikacioni funksionon plotësisht offline (Hive i pavarur)
- [ ] Firebase Analytics mbetet çaktivizuar (verifikim)
- [ ] Asnjë emër real fëmije në Firestore — vetëm pseudonime

---

## 🟢 Sprint 11 — Gamification, Leaderboard & Audio
**Versioni:** v1.7.0 | **Kohëzgjatja:** 2 javë | **Varësia:** Sprint 10A (minimum), 10B (opsional)

### Konteksti

Sprint 11 është shiftuesi kryesor i angazhimit afatgjatë. Badge-et, leaderboard familjar dhe audio transformojnë MathLingo nga aplikacion edukativ në eksperiencë motivuese. **Rregull kritike:** Leaderboard është VETËM brenda familjes ose klasës me kod — asnjë ekspozim publik.

### Track A — Sistemi i Arritjeve / Badge-et (4 detyra)

**A-01** `prioritet i lartë`  
Krijo modelin `Achievement` dhe `AchievementService`. 15 badge të planifikuara:
- Arritje operacionesh: "Maestro i Mbledhjes" (100 mbledhje), "Zoti i Shumëzimit" (50 shumëzime saktë), "Mjeshtri i Fraksioneve"
- Arritje saktësie: "100% Shënjestër" (sesion perfekt), "Seria e Artë" (5 sesione radhazi ≥90%)
- Arritje eksplorimi: "Aventurieri" (të gjitha modulet provuar), "Gjuetari X" (10 pyetje MissingX saktë)
- Arritje speciale: "Shkencëtar i Gjeometrisë", "Eksploruesi i Tabelave" (të gjitha tabelat 1-12)

**A-02** `prioritet i lartë`  
`BadgeDisplayScreen` — galeria e badge-eve. Grid 3 kolona: badge të fituara (me ngjyrë), badge të pafituara (gri, me progress indicator). Animacion reveal kur fitohet badge i ri.

**A-03** `prioritet i lartë`  
Notifikim in-app kur fitohet badge: dialog overlay me `GlassPanel`, mascot Stitch në modalitet festiv, animacion konfeti (i thjeshtë me `CustomPainter`).

**A-04** `prioritet mesatar`  
Integrimi i badge-eve me `ProgressProvider`. Çek pas çdo sesioni nëse janë arritur kushtet e badge-eve të reja.

### Track B — Leaderboard Familjar (3 detyra)

**B-01** `prioritet i lartë`  
`LeaderboardScreen` brenda familjes: listë e renditur sipas pikëve totale. Shfaq pseudonimin + avatarin + pikët. Vetëm profil aktiv highlighted.

**B-02** `prioritet mesatar`  
Leaderboard me "Kod Klase" (opsional, vetëm nëse cloud aktiv): mësuesi gjeneron kod 6-shifror. Studentët bashkohen me kodin. Leaderboard i klasës shfaq pseudonime, jo emra realë.

**B-03** `prioritet mesatar`  
Risi javore: badge "Lider i Javës" për fëmijën me më shumë pikë brenda familjes në 7 ditët e fundit.

### Track C — Audio & Feedback Sensorik (3 detyra)

**C-01** `prioritet i lartë`  
Shto `audioplayers: ^6.0.0` në `pubspec.yaml`. Shto 5 tinguj SFX (ogg format, <50KB secili):
- `correct.ogg` — tingull pozitiv i shkurtër (100ms)
- `wrong.ogg` — tingull i butë gabimi (150ms)
- `levelup.ogg` — melodi e shkurtër suksesi (500ms)
- `badge.ogg` — tingull festiv (800ms)
- `tap.ogg` — feedback i butë prekjeje (50ms)

**C-02** `prioritet i lartë`  
`AudioService` (Riverpod Provider). Metoda: `playCorrect()`, `playWrong()`, `playLevelUp()`, `playBadge()`. Toggle: on/off nga `SettingsScreen`.

**C-03** `prioritet mesatar`  
`HapticService`: `HapticFeedback.lightImpact()` për tap, `HapticFeedback.mediumImpact()` për saktësi, `HapticFeedback.heavyImpact()` për level-up. iOS dhe Android.

### Milestone pas Sprint 11

**Play Store Public Release (v1.7.0)**  
Publikim i plotë në Google Play Store. Produkt gati për shkollat dhe prindërit shqiptarë.

### Kriteret e pranimit Sprint 11

- [ ] 15 badge të implementuara, prej të cilave ≥5 të fitueshme në sesionin e parë
- [ ] Animacioni reveal badge funksionon pa lag
- [ ] Leaderboard familjar rendit saktë sipas pikëve
- [ ] Tingujt luajnë brenda 50ms nga aksioni
- [ ] Toggle audio on/off funksionon dhe persiston
- [ ] Asnjë emër real në leaderboard — vetëm pseudonime
- [ ] `fvm flutter test` kalon

---

## 🔴 Sprint 12 — AI, Certifikata & Finalizimi
**Versioni:** v2.0.0 | **Kohëzgjatja:** 2 javë | **Varësia:** Sprint 10B (për AI personalizim)

### Konteksti

Sprint 12 shënon kalimin e MathLingo nga produkt statik në produkt me inteligjencë artificiale. Gemini API personalizon pyetjet bazuar në historikun e çdo fëmijë. Certifikatat PDF i bëjnë arritjet të ndashme dhe të festueshme. Ky sprint gjithashtu mbyll lokalizimin dhe mundëson dark/light mode.

### Track A — AI Gjenerimi i Pyetjeve (4 detyra)

**A-01** `prioritet i lartë`  
Integro Gemini API (`google_generative_ai` package). `AIQuestionService` (Riverpod Provider). Input: historia e 10 sesioneve të fundit (tipet e gabimeve, niveli aktual). Output: 5 pyetje të personalizuara.

**A-02** `prioritet i lartë`  
Prompt engineering për pyetje matematikore shqip. Prompt system: "Gjenero 5 pyetje matematikore për fëmijë [mosha] vjeç, niveli [N]. Fëmija ka vështirësi me [gabimet e fundit]. Format JSON: [{question, options, answer, operationType}]". Validim i output-it JSON.

**A-03** `prioritet i lartë`  
Fallback i plotë: nëse Gemini nuk është i disponueshëm (offline, error, quota), kthehet automatikisht te gjeneratori lokal. Asnjë ndërprerje e rrjedhës.

**A-04** `prioritet mesatar`  
"Sfida e AI-t" — kartë e re në dashboard. Shfaqet vetëm pas ≥5 sesioneve (ka histori mjaftueshëm për personalizim). Badge special: "Testues i AI-t".

### Track B — Certifikatat PDF (3 detyra)

**B-01** `prioritet i lartë`  
Shto `pdf: ^3.10.8` dhe `share_plus: ^7.0.0` në `pubspec.yaml`. Dizajni i certifikatës: sfond kozmik, logo MathLingo, pseudonimi i fëmijës, modulet e përfunduara, pikët totale, data.

**B-02** `prioritet i lartë`  
`CertificateGenerator`: gjeneron PDF on-device. Triggerohet nga `ResultsScreen` kur arrihet milestone (e.g., 500 pikë, ose badge "Maestro"). Butoni "Shkarko Certifikatën" + "Ndaj me Prindërit".

**B-03** `prioritet mesatar`  
Share flow: `share_plus` për ndaje certifikatën si PDF ose imazh. Mesazh i paracaktuar shqip: "🎓 [Pseudonimi] mbaroi modulin e Matematikës me [pikë] pikë dhe [saktësi]% saktësi!"

### Track C — Finalizimi & Polishing (3 detyra)

**C-01** `prioritet mesatar`  
Dark/Light mode toggle nga `SettingsScreen`. `ThemeMode` switch me Riverpod + Hive persistence. Të gjitha ngjyrat janë të varura nga CSS variables — kalimi duhet të jetë i menjëhershëm.

**C-02** `prioritet mesatar`  
Lokalizim bazë Anglisht (EN). Shto `app_en.arb` me ≥80% string-eve të përkthyera. Ndërrimi i gjuhës nga Settings.

**C-03** `prioritet mesatar`  
Fix `ResultsScreen` tablet — hapësirë e zbrazët poshtë mascot-it (identifikuar në analizën UI/UX). Fix drejtshkrimor "Progresi për modul". Fix grafiku rrethit Progress (max dinamik, jo statik).

### Milestone final Sprint 12

**v2.0.0 — Platforma e Plotë**  
MathLingo v2.0.0 është: AI-powered, multi-gjuhë, me certifikata, me backend opsional, plotësisht GDPR-compliant, gati për partneritet me shkollat shqiptare.

### Kriteret e pranimit Sprint 12

- [ ] Gemini API gjeneron pyetje koherente matematikore shqip
- [ ] Fallback te gjeneratori lokal funksionon pa ndërprerje
- [ ] PDF certifikatë gjenerohet dhe ndahet saktë
- [ ] Dark/Light mode ndërron pa flicker
- [ ] EN lokalizim ≥80% komplet
- [ ] `fvm flutter test` kalon të gjitha
- [ ] `fvm flutter analyze` — 0 warnings
- [ ] Release bundle v2.0.0 i nënshkruar dhe gati

---

## 📊 Tabela e Varësive

| Sprint | Varësia e detyrueshme | Varësia opsionale |
|--------|----------------------|-------------------|
| S7 | S6 DONE | — |
| S8 | S7 Track A+B | — |
| S9 | S7 D-01 | S8 |
| S10A | S9 | — |
| S10.5 | S10A | — |
| S10B | S10A + S10.5 (TË DY) | — |
| S11 | S10A | S10B (për leaderboard cloud) |
| S12 | S11 | S10B (për AI personalizim) |

---

## 📦 Varësitë e Reja (pubspec.yaml)

| Sprint | Package | Versioni | Funksioni |
|--------|---------|----------|-----------|
| S10B | `firebase_core` | `^3.0.0` | Firebase init |
| S10B | `firebase_auth` | `^5.0.0` | Auth prindëror |
| S10B | `cloud_firestore` | `^5.0.0` | Sync cloud |
| S11 | `audioplayers` | `^6.0.0` | Audio SFX |
| S12 | `pdf` | `^3.10.8` | Certifikata |
| S12 | `share_plus` | `^7.0.0` | Share PDF |
| S12 | `google_generative_ai` | `^0.4.0` | Gemini API |

---

## 🗓️ Kalendari i Milestone-ve

| Data (target) | Milestone | Versioni |
|---------------|-----------|---------|
| Pas S9 | Play Store Internal Beta | v1.5.1 |
| Pas S11 | Play Store Public Release | v1.7.0 |
| Pas S12 | Platforma e Plotë | v2.0.0 |

---

## ⚠️ Rregullat e Detyrueshme për të Gjitha Sprintet

1. **Gjuha:** Çdo string i dukshëm në UI duhet të jetë shqip (ose EN nëse lokalizimi është aktiv)
2. **Null Safety:** Gjithmonë null-safety strikte
3. **State Management:** Riverpod për logjikën e biznesit, `setState` vetëm për animacione vizuale
4. **Modularizimi:** Asnjë kod i ri në `main.dart`. Çdo feature → `lib/features/[emri]/`
5. **Responsiviteti:** `AdaptiveLayout` për çdo dimension — asnjë vlerë hardcoded
6. **Privacy:** Asnjë të dhënë personale fëmijësh pa consent prindëror të shprehur
7. **Tests:** Çdo gjenerator i ri ka unit tests. Çdo sprint mbyllet me `fvm flutter test` ✓
8. **Git:** Feature branches nga `develop`, Convention Commits, merge me PR

---

*Dokumenti është autoritativ për planifikimin e Sprint 7–12. Çdo ndryshim duhet reflektuar këtu dhe në SSOT_MathLingo.md.*
