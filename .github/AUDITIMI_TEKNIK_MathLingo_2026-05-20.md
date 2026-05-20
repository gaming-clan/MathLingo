# Auditim Pre-Release MathLingo v2.1.0

**Data:** 20 Maj 2026
**Suite testesh:** 159 teste, kalon sipas gjendjes së konfirmuar të projektit; inventari aktual i lexuar në repo përfshin 17 skedarë test.
**flutter analyze:** kalon pa warnings sipas gjendjes së konfirmuar të projektit; nuk u ri-ekzekutua në këtë audit.

## Shënime metodologjike

- Skedari i kërkuar [Zona 1] `lib/features/challenges/domain/math_question_generator.dart` nuk u gjet. Sjellja aktuale e gjeneratorit të aritmetikës kontrollohet nga `lib/core/providers/challenge_provider.dart`.
- Dosja e kërkuar [Zona 1.3] `lib/features/tables/` nuk u gjet. Implementimi aktual i tabelave ndodhet te `lib/simple_tables.dart` dhe `lib/core/providers/tables_provider.dart`.
- Modeli i kërkuar [Zona 2.3] `ProgressEntry` nuk u gjet. Persistenca aktuale përdor `SessionRecord` dhe `UserProgress` te `lib/models/user_progress.dart`.

### 🔴 Bllokues Release (duhen korrigjuar para publikimit)

1. **[Zona 2.1, 2.2, 3.4] Consent-i prindëror nuk zbatohet realisht para inicializimit të Firebase dhe hyrjes në flow-un cloud.**

	 Evidencë:

	 - `lib/features/settings/presentation/settings_screen.dart:61`

		 ```dart
		 final ok = await FirebaseInitService.initialize();
		 ```

	 - `lib/features/settings/presentation/settings_screen.dart:477`

		 ```dart
		 onTap: () => onInitFirebase(context, const ParentSignUpScreen()),
		 ```

	 - `lib/features/settings/presentation/settings_screen.dart:488`

		 ```dart
		 onTap: () => onInitFirebase(context, const ParentSignInScreen()),
		 ```

	 - `lib/features/settings/presentation/consent_flow_screen.dart:40`

		 ```dart
		 // Sprint 10B do të ruajë consent-in dhe do të aktivizojë cloud
		 // Për tani, kthehemi me true
		 ```

	 - Kërkimi për `AgeVerificationGate` në `lib/**/*.dart` ktheu vetëm deklarimin te `lib/features/settings/presentation/consent_flow_screen.dart:202-203`; nuk u gjet përdorim real në rrjedhën e aplikacionit.

	 Ndikimi: rrjedha aktuale lejon fëmijën të arrijë te hyrja/regjistrimi cloud pa një gate efektiv prindëror, pa persistencë të consent-it në Hive dhe pa provë të tërheqjes së consent-it para inicializimit.

	 Rekomandimi: `SettingsScreen` duhet të kalojë fillimisht në `ConsentFlowScreen.show(...)`, të ruajë consent-in në Hive dhe vetëm pas kësaj të thërrasë `FirebaseInitService.initialize()`.

2. **[Zona 2.1, 2.2, 4.3] Fshirja e “llogarisë cloud” nuk fshin të dhënat në Firestore përpara fshirjes së llogarisë Auth.**

	 Evidencë:

	 - `lib/features/settings/presentation/settings_screen.dart:399`

		 ```dart
		 await ref.read(authProvider.notifier).deleteAccount();
		 ```

	 - `lib/features/auth/services/auth_service.dart:135`

		 ```dart
		 static Future<bool> deleteAccount() async {
		 ```

	 - `lib/features/auth/services/auth_service.dart:141`

		 ```dart
		 await user.delete();
		 ```

	 - `lib/features/auth/services/auth_service.dart:174`

		 ```dart
		 static Future<void> _saveAccountLocally(ParentAccount account) async {
		 ```

	 - Në të njëjtën kohë ekziston rrjedha korrekte e fshirjes totale te `lib/features/settings/presentation/delete_all_data_screen.dart`, e cila thërret `syncService.deleteAllUserData(...)` para logout-it.

	 Ndikimi: përdoruesi mund të mendojë se ka fshirë llogarinë dhe të dhënat cloud, por dokumentet Firestore mund të mbeten të pahequra. Kjo prek drejtpërdrejt GDPR Art. 17.

	 Rekomandimi: rruga “Fshi llogarinë në cloud” duhet të thërrasë `SyncService.deleteAllUserData(uid)` para `AuthService.deleteAccount()` dhe të trajtojë qartë dështimet parcialë.

3. **[Zona 2.1, 2.5] Politika e privatësisë jep deklaratë faktikisht të pasaktë për transmetimin e të dhënave.**

	 Evidencë:

	 - `lib/features/settings/presentation/privacy_policy_screen.dart:46`

		 ```dart
		 'Vetëm familja juaj lokale. MathLingo nuk dërgon asnjë '
		 'të dhënë në internet — gjithçka ruhet vetëm në pajisjen '
		 'tuaj. Asnjë server i jashtëm nuk ka akses në këto të dhëna.',
		 ```

	 - `lib/core/sync/sync_service.dart:47`

		 ```dart
		 await _db.doc(FirestoreSchema.childInfoDoc(uid, child.id)).set(
		 ```

	 - `lib/core/sync/sync_service.dart:69`

		 ```dart
		 await _db.doc(FirestoreSchema.progressDoc(uid, child.id, today)).set(
		 ```

	 Ndikimi: dokumenti i privatësisë mohon ekzistencën e sinkronizimit cloud edhe pse kodi e mbështet atë. Për produkt për fëmijë kjo është shkelje disclosure-i, jo vetëm problem copy.

	 Rekomandimi: politika duhet të dallojë qartë modalitetin lokal nga modaliteti cloud “opt-in” dhe të përshkruajë saktësisht çfarë dërgohet në Firestore.

4. **[Zona 1.1] Gjeneratori i trekëndëshit nuk garanton gjerësi çift dhe lejon përgjigje jo-integrale të rrumbullakosura.**

	 Evidencë:

	 - `lib/features/geometry/domain/geometry_question_generator.dart:47`

		 ```dart
		 width = random.nextInt(8) + 3;
		 ```

	 - `lib/features/geometry/domain/geometry_question_generator.dart:56`

		 ```dart
		 answer = _roundToOneDecimal((width * height) / 2);
		 ```

	 Ndikimi: kërkesa pedagogjike e auditimit kërkon që `width` të jetë çift për formulën `S = b×h/2` pa thyesë. Implementimi aktual gjeneron edhe raste tek dhe i zgjidh me rrumbullakosje në 1 decimal.

	 Rekomandimi: kufizo `width` në numra çift ose gjenero çifte `(width, height)` që japin gjithmonë sipërfaqe të plotë për nivelin aktual.

5. **[Zona 6.2] Metadata e versionit nuk përputhen me target-in e auditimit v2.1.0.**

	 Evidencë:

	 - `pubspec.yaml:20`

		 ```yaml
		 version: 2.0.0+1
		 ```

	 - `android/app/build.gradle.kts:31-36` përdor `versionCode = flutter.versionCode` dhe `versionName = flutter.versionName`, prandaj Android release do të trashëgojë po këtë version.

	 Ndikimi: nëse ky auditim synon release-in “v2.1.0”, metadata e release-it janë ende në 2.0.0+1 dhe do të prodhojnë build me version të pasaktë në Play Console dhe në UI.

	 Rekomandimi: sinkronizo `pubspec.yaml` me versionin real të release-it para publikimit.

### 🟠 Risk i Lartë (rekomandohet korrigjim para release)

1. **[Zona 2.4] `AuthService` logon `uid` të plotë në disa rrjedha.**

	 Evidencë:

	 - `lib/features/auth/services/auth_service.dart:73`

		 ```dart
		 debugPrint('[Auth] Prindi u regjistrua: ${user.uid}');
		 ```

	 - `lib/features/auth/services/auth_service.dart:109`

		 ```dart
		 debugPrint('[Auth] Prindi hyri: ${user.uid}');
		 ```

	 - `lib/features/auth/services/auth_service.dart:143`

		 ```dart
		 debugPrint('[Auth] Llogaria u fshi: ${user.uid}');
		 ```

	 Ndikimi: korrigjimi B014 është lokal vetëm te `sync_service.dart`; logimi i identifikuesve vazhdon në shtresën e Auth.

2. **[Zona 2.4] OCR logon path-in e figurës dhe tekstin e njohur të ushtrimit.**

	 Evidencë:

	 - `lib/gamify_exercise.dart:83`

		 ```dart
		 debugPrint('[OCR] Starting processImage for path: ${image.path}');
		 ```

	 - `lib/gamify_exercise.dart:113`

		 ```dart
		 debugPrint('[OCR] rawText="${rawText.replaceAll('\n', ' ')}"');
		 ```

	 - `lib/gamify_exercise.dart:115`

		 ```dart
		 debugPrint('[OCR] extractedEquation=$equation');
		 ```

	 Ndikimi: përmbajtja e fletëve të punës dhe rruga lokale e skedarit dalin në log gjatë debug-ut; për aplikacion për fëmijë kjo duhet minimizuar ose maskuar.

3. **[Zona 2.3] Të dhënat lokale ruhen pa shtresë enkriptimi dhe PIN-i prindëror ruhet në plaintext.**

	 Evidencë:

	 - `lib/core/services/family_profile_service.dart:204-205`

		 ```dart
		 static Future<void> setParentPin(String pin) async {
			 await _box.put(_pinKey, pin);
		 }
		 ```

	 - `lib/features/auth/services/auth_service.dart:174-176`

		 ```dart
		 static Future<void> _saveAccountLocally(ParentAccount account) async {
			 final box = await Hive.openBox<dynamic>(_boxName);
			 await box.put(_accountKey, account.toMap());
		 }
		 ```

	 - Kërkimi për `flutter_secure_storage|encryptionKey|HiveAesCipher` në `lib/**/*.dart` dhe `pubspec.yaml` nuk ktheu asnjë rezultat.

	 Ndikimi: email-i, `uid`, gjendja e cloud sync dhe PIN-i prindëror ruhen lokalisht pa mbrojtje shtesë në nivel aplikacioni.

4. **[Zona 4.1] Firestore rules mbështeten vetëm te `isOwner(uid)` dhe nuk validon strukturën e payload-it.**

	 Evidencë:

	 - `firestore.rules:15`

		 ```js
		 allow read, write: if isOwner(uid);
		 ```

	 - `firestore.rules:19`

		 ```js
		 allow read, write: if isOwner(uid);
		 ```

	 - `firestore.rules:23`

		 ```js
		 allow read, write: if isOwner(uid);
		 ```

	 Ndikimi: klienti i autentifikuar mund të shkruajë çfarëdo skeme nën nyjet e veta pa kontroll fushash, tipesh apo kufijsh.

5. **[Zona 4.2] `SyncService` nuk ka trajtim të diferencuar për `FirebaseException`/`SocketException` dhe nuk ka retry/queue offline.**

	 Evidencë:

	 - `lib/core/sync/sync_service.dart:58`

		 ```dart
		 } catch (e) {
			 debugPrint('[Sync] Gabim syncChildInfo: $e');
		 }
		 ```

	 - `lib/core/sync/sync_service.dart:148`

		 ```dart
		 } catch (e) {
			 debugPrint('[Sync] Gabim updateDailyStats: $e');
		 }
		 ```

	 - `lib/core/sync/sync_service.dart:185`

		 ```dart
		 } catch (e) {
			 debugPrint('[Sync] Gabim pullWeeklyStats: $e');
			 return [];
		 }
		 ```

	 Ndikimi: aplikacioni degradohet me qetësi, por pa telemetry të strukturuar, pa retry të kontrolluar dhe pa queue për rikthim offline → online.

6. **[Zona 4.3] Regjistrimi nuk dërgon email verifikimi.**

	 Evidencë:

	 - `lib/features/auth/services/auth_service.dart:60-74` krijon përdoruesin, ndërton `ParentAccount`, ruan llogarinë lokalisht dhe kthen sukses; nuk ka thirrje `sendEmailVerification()` në këtë rrjedhë.

	 Ndikimi: llogari me email të paverifikuar mund të konsiderohen aktive menjëherë, gjë që ul besueshmërinë e identitetit prindëror.

7. **[Zona 1.2] Distractor-ët e gjeometrisë janë vetëm offset-e numerike, jo gabime tipike pedagogjike.**

	 Evidencë:

	 - `lib/features/geometry/domain/geometry_question_generator.dart:112`

		 ```dart
		 List<double> generateOptions(double correctAnswer, math.Random random) {
		 ```

	 - `lib/features/geometry/domain/geometry_question_generator.dart:115-118`

		 ```dart
		 var offset = (random.nextInt(14) - 7).toDouble();
		 final wrongAnswer = _roundToOneDecimal(correctAnswer + offset);
		 ```

	 Ndikimi: opsionet e gabuara nuk reflektojnë gabimet tipike të fëmijës si ngatërrim mes perimetrit dhe sipërfaqes, harresa e pjesëtimit me 2 te trekëndëshi, apo përdorimi i formulës së gabuar.

8. **[Zona 1.4] Saktësia nuk matet në mënyrë konsistente mes aritmetikës dhe gjeometrisë.**

	 Evidencë:

	 - `lib/core/providers/challenge_provider.dart:44`

		 ```dart
		 sessionLength > 0 ? ((correct / sessionLength) * 100).round() : 0;
		 ```

	 - `lib/core/providers/challenge_provider.dart:182`

		 ```dart
		 correct: state.correct + 1,
		 ```

	 - `lib/core/providers/geometry_provider.dart:38`

		 ```dart
		 sessionLength > 0 ? ((correct / sessionLength) * 100).round() : 0;
		 ```

	 - `lib/core/providers/geometry_provider.dart:136`

		 ```dart
		 final countAsCorrect = !state.hadWrongAttemptOnCurrent;
		 ```

	 - `lib/core/providers/geometry_provider.dart:141`

		 ```dart
		 correct: countAsCorrect ? state.correct + 1 : state.correct,
		 ```

	 Ndikimi: gjeometria llogarit first-attempt accuracy, ndërsa aritmetika e numëron si të saktë pyetjen edhe pas gabimit të parë nëse përdoruesi e gjen më pas. Ky është risk pedagogjik dhe analytics risk.

9. **[Zona 5.2] Mbulimi i testeve mungon pikërisht në rrjedhat ligjore dhe cloud.**

	 Evidencë:

	 - Nuk u gjet asnjë test për `lib/features/settings/presentation/consent_flow_screen.dart`.
	 - Nuk u gjet asnjë test për `lib/features/auth/services/auth_service.dart`.
	 - `test/features/family/weekly_stats_provider_test.dart` përdor `_FakeSyncService` dhe nuk teston drejtpërdrejt `SyncService.updateDailyStats()` ose `syncChildInfo()`.

	 Ndikimi: tre rrjedhat më të ndjeshme për GDPR dhe cloud nuk janë të mbuluara me teste direkte.

### 🟡 Borxh Teknik (planifikohet pas release)

1. **[Zona 3.1] Operacionet async vazhdojnë të menaxhohen me `StateNotifier<AsyncValue<...>>`, jo me `AsyncNotifier`.**

	 Evidencë:

	 - `lib/core/providers/progress_provider.dart:8`

		 ```dart
		 class ProgressNotifier extends StateNotifier<AsyncValue<UserProgress>> {
		 ```

	 - `lib/core/providers/weekly_stats_provider.dart:34`

		 ```dart
		 class WeeklyStatsNotifier extends StateNotifier<WeeklyStatsState> {
		 ```

	 Ndikimi: kodi është i lexueshëm, por async state menaxhohet manualisht dhe me boilerplate shtesë.

2. **[Zona 3.3] Hardcoded dimensions mbeten të përhapura në `lib/features/`, përfshirë `ParentReportScreen`.**

	 Evidencë për `ParentReportScreen`:

	 - `lib/features/family/presentation/parent_report_screen.dart:69`

		 ```dart
		 maxWidth: 700,
		 ```

	 - `lib/features/family/presentation/parent_report_screen.dart:471`

		 ```dart
		 width: 22,
		 ```

	 - `lib/features/family/presentation/parent_report_screen.dart:753`

		 ```dart
		 style: const TextStyle(fontSize: 26),
		 ```

	 Evidencë shtesë në feature files:

	 - `lib/features/challenges/presentation/challenge_screen.dart:156` `padding: const EdgeInsets.all(22),`
	 - `lib/features/settings/presentation/settings_screen.dart:102` `maxWidth: 640,`
	 - `lib/features/family/presentation/family_setup_screen.dart:94` `padding: const EdgeInsets.all(20),`

	 Ndikimi: B013 duket i pastruar në seksionet kritike, por jo plotësisht në gjithë `lib/features/`.

3. **[Zona 7.4] Ka ende copy hardcoded jashtë ARB files.**

	 Evidencë për shembuj reprezentativë:

	 - `lib/features/settings/presentation/settings_screen.dart:107` `'Cilësimet'`
	 - `lib/features/settings/presentation/privacy_policy_screen.dart:24` `'Politika e Privatësisë'`
	 - `lib/features/fraction/presentation/fraction_challenge_screen.dart:87-92` `kicker`, `title` dhe `label` janë stringje direkte
	 - `lib/features/missing_x/presentation/missing_x_challenge_screen.dart:77-93` feedback dhe titujt janë stringje direkte

	 Ndikimi: lokalizimi nuk është më problem sistemik si më parë, por mbetet i papërfunduar në disa feature slices.

4. **[Zona 7.2] Aksesueshmëria është e kufizuar: mungojnë `Semantics`/`Tooltip` në widget-et kryesore shared.**

	 Evidencë:

	 - `lib/shared/widgets/cosmic_top_bar.dart:110`

		 ```dart
		 return IconButton(
		 ```

	 - `lib/shared/widgets/cosmic_top_bar.dart:38-58` krijon butonat back/settings pa `tooltip`.

	 - Kërkimi për `Semantics|Tooltip|tooltip:` në `lib/**/*.dart` ktheu vetëm një `tooltip: 'Fshi'` te `lib/features/family/presentation/family_switcher_screen.dart:298`.

	 Ndikimi: screen reader-i dhe navigimi me assistive tech nuk kanë etiketa të qarta në shumicën e elementeve interaktivë.

5. **[Zona 5.3] Testi i navigimit për raportin prindëror nuk ushtron dialogun real të PIN-it.**

	 Evidencë:

	 - `test/features/family/parent_report_navigation_test.dart:41`

		 ```dart
		 final Future<bool> Function(BuildContext context) verifier;
		 ```

	 - `test/features/family/parent_report_navigation_test.dart:47`

		 ```dart
		 final ok = await verifier(context);
		 ```

	 Ndikimi: testi mbulon wiring-un me verifier të injektuar, jo `ParentPinDialog.verify(...)` end-to-end.

### 🟢 Sugjerime

1. **[Zona 7.1, 7.2] Vendos `minimumSize`, `tooltip` dhe `Semantics` eksplicite për `AnswerButton`, `CosmicBottomNav` dhe `CosmicTopBar`.**

	 Evidencë:

	 - `lib/features/challenges/presentation/widgets/answer_button.dart:21-31` nuk vendos `minimumSize` ose `fixedSize`.
	 - `lib/shared/widgets/cosmic_bottom_nav.dart:79-91` përdor `TextButton` me padding, por pa garanci eksplicite 48dp.

	 Vlerësim: **E paqartë nga kodi** nëse hit target-i final është gjithmonë ≥ 48dp në çdo layout, sepse madhësia varet nga constraints e prindit.

2. **[Zona 2.1, 2.5] Bëje politiken e privatësisë dinamike sipas modalitetit lokal/cloud dhe lidh atë me consent state real.**

3. **[Zona 4.1] Shto validim fushe në Firestore rules dhe një rregull të qartë dokumentues për deny-by-default.**

4. **[Zona 5] Shto teste të drejtpërdrejta për `ConsentFlowScreen`, `AuthService`, `SyncService` dhe për fshirjen e llogarisë cloud me cleanup të Firestore.**

### ✅ Zona pa probleme të identifikuara

- **[Zona 1.1] Aritmetika bazë është korrekte në implementimin aktual.** `lib/core/providers/challenge_provider.dart:133-153` gjeneron mbledhje me operandë pozitivë, zbritje me `num1 >= num2`, shumëzim me `multMax` sipas nivelit, dhe pjesëtim me `num1 = answer * num2`.
- **[Zona 1.1] Formula e katrorit për perimetrin është e saktë.** `lib/features/geometry/domain/geometry_question_generator.dart:63-66` përdor `answer = (width * 4).toDouble();` kur `calculationType == perimeter`.
- **[Zona 1.3] Tabelat filtrojnë zbritjet negative dhe pjesëtimet me mbetje.** `lib/simple_tables.dart:139-142` bën `continue` kur `selectedTable < operand` ose `selectedTable % operand != 0`.
- **[Zona 1.3] Inverse mode ndryshon realisht tekstin e pyetjes të paktën për mbledhje, shumëzim dhe pjesëtim.** `lib/simple_tables.dart:420-434` prodhon forma si `? + n = table`, `? × n = result`, `result ÷ ? = table`.
- **[Zona 1.4] Gjatësia e sesionit dhe formula bazë e accuracy janë në përputhje me kërkesën.** `lib/features/challenges/presentation/challenge_screen.dart:28` përdor `sessionLength = 5`, `lib/features/geometry/presentation/geometry_challenge_screen.dart:22` përdor `sessionLength = 4`, dhe provider-at në `challenge_provider.dart:44` / `geometry_provider.dart:38` përdorin formulën `correct / sessionLength * 100`.
- **[Zona 2.3] Modelet aktuale ruajnë pseudonim dhe jo emër real apo datëlindje.** `lib/models/child_profile.dart:3-32`, `lib/models/family_profile.dart:3-28`, `lib/models/user_progress.dart:1-57` nuk kanë fusha për moshë ose datëlindje.
- **[Zona 3.1] Nuk u identifikua `setState` në `lib/core/providers/`; logjika Riverpod është e ndarë nga state-i lokal i UI-së në provider-at kryesorë.**
- **[Zona 3.4] Navigimi i sfidës mbyll stack-un siç pritet.** `lib/features/challenges/presentation/challenge_screen.dart:112` përdor `pushReplacement(...)` për `ResultsScreen`, ndërsa `lib/features/challenges/presentation/results_screen.dart:166` përdor `pushNamedAndRemoveUntil(AppRoutes.dashboard, (_) => false)`.
- **[Zona 4.2] Guard-i `_canSync()` ekziston dhe përdoret para shkrim/lexim cloud në rrjedhat kryesore.** `lib/core/sync/sync_service.dart:24-27` dhe pastaj `if (!_canSync()) return;` në `syncChildInfo`, `syncChildProgress`, `updateDailyStats`, `pullChildInfo`, `pullWeeklyStats`.
- **[Zona 4.3] Auth flow është email-only; nuk u gjet Google Sign-In apo social auth.** `pubspec.yaml:34-55` deklaron vetëm `firebase_auth`, jo paketa për Google Sign-In.
- **[Zona 5.3] Rasti `activeChild == null` është i mbuluar nga testet.** `test/features/family/weekly_stats_provider_test.dart:205-224` verifikon `WeeklyStatsLoaded` bosh pa exception.
- **[Zona 6.1] Release signing nuk përdor debug key dhe sekretet e signing nuk janë në git.** `android/app/build.gradle.kts:41-51` përdor `signingConfigs.create("release")`; `.gitignore:18-31` përjashton `android/key.properties`, `*.jks`, `*.keystore`; kontrolli me `git ls-files` nuk gjeti `android/key.properties` të track-uar.
- **[Zona 6.3] Nuk u gjetën leje të panevojshme në manifest-in kryesor.** `android/app/src/main/AndroidManifest.xml` nuk deklaron `CAMERA`, `READ_EXTERNAL_STORAGE` ose leje të tjera sensitive; `INTERNET` shfaqet vetëm te `android/app/src/debug/AndroidManifest.xml` dhe `android/app/src/profile/AndroidManifest.xml`.
- **[Zona 6.5] Asset-et kritike ekzistojnë fizikisht.** `assets/icons/stich_icon.png` ekziston, `android/app/src/main/res/mipmap-anydpi-v26/launcher_icon.xml` ekziston dhe `pubspec.yaml:86-87,123-137` i deklaron.
- **[Zona 8.3] Licencat e paketave kyçe nuk duken inkompatibile me shpërndarje komerciale.** `flutter_riverpod` dhe `fl_chart` janë MIT; `hive` është Apache 2.0; `google_mlkit_text_recognition` përdor MIT sipas skedarëve LICENSE të repo-ve burimore.
- **[Zona 2.5] Nuk u gjetën reklama të palëve të treta, blerje in-app ose chat/social features.** Kërkimet në `pubspec.yaml` dhe `lib/**/*.dart` për `google_mobile_ads`, `in_app_purchase`, `chat`, `social` nuk kthyen implementime relevante.

### E paqartë nga kodi

- **[Zona 2.2] `analyticsEnabled: false` nuk u gjet si flag eksplicite.** Nuk ka `firebase_analytics` në `pubspec.yaml`, ndaj Analytics duket i paimplementuar; megjithatë ky përfundim vjen nga mungesa e dependency-ve, jo nga një flag i vendosur në kod.
- **[Zona 6.2] `targetSdkVersion = 35` është e paqartë nga kodi i aplikacionit.** `android/app/build.gradle.kts:31` përdor `targetSdk = flutter.targetSdkVersion`, jo vlerë të ngurtë, prandaj numri i saktë varet nga toolchain-i Flutter i përdorur për build.

### Vendimi i rekomanduar

**RELEASE I BLLOKUAR**

Arsyetimi:

- Ka shkelje materiale në rrjedhën e consent-it prindëror dhe në disclosure-in e privatësisë.
- Rrjedha “Fshi llogarinë në cloud” nuk garanton fshirjen e të dhënave Firestore përpara fshirjes së llogarisë Auth.
- Gjeneratori i trekëndëshit nuk respekton kufirin pedagogjik të kërkuar për rezultat integral.
- Metadata e versionit nuk përputhen me release-in e audituar v2.1.0.

Nëse këto katër pika mbyllen, pjesa tjetër e gjetjeve zbret në kategori të menaxhueshme para ose menjëherë pas release-it.
