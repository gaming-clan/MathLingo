# Plan Pune nga Auditimi Pre-Release — MathLingo v2.1.0

**Burimi:** Auditim Teknik 20 Maj 2026
**Vendimi aktual:** RELEASE I BLLOKUAR
**Objektivi:** Mbyll bllokuesit → RELEASE ME KUSHTE ose GATI PËR RELEASE

---

## SPRINT 15 — Release Gate (para publikimit)

**Branch:** `feature/sprint-15-release-gate`
**Versioni pas merge:** `v2.1.0` (me `pubspec.yaml` të sinkronizuar)
**Kusht:** të gjithë taskat 🔴 duhen mbyllur para çdo submit në Play Console.

---

### Task 1 — Consent flow real para Firebase 🔴 [KRITIKE LIGJORE]

**Problemi (B015):** `ConsentFlowScreen` nuk ruan consent-in dhe kthen `true` pa
vlerësim real. Firebase inicializohet pa gate efektiv prindëror.

**Skedarët:**
- `lib/features/settings/presentation/consent_flow_screen.dart` (L40 — koment TODO aktiv)
- `lib/features/settings/presentation/settings_screen.dart` (L61, L477, L488)

**Çfarë duhet bërë:**

Hapi A — Implemento persistencën e consent-it në `consent_flow_screen.dart`:
```dart
// Zëvendëso: return true  (L40)
// Me:
await HiveConsentRepository.saveConsent(
  ConsentRecord(
    grantedAt: DateTime.now(),
    version: ConsentVersion.current,
    uid: parentUid, // i disponueshëm pas auth ose para si 'pending'
  ),
);
return true;
```

Hapi B — Shto `AgeVerificationGate` në rrjedhën reale të `settings_screen.dart`:
```dart
// Para onInitFirebase():
final hasConsent = await HiveConsentRepository.hasValidConsent();
if (!hasConsent) {
  final granted = await Navigator.push(context,
    MaterialPageRoute(builder: (_) => const ConsentFlowScreen()));
  if (granted != true) return; // përdoruesi refuzoi
}
// Vetëm pastaj:
final ok = await FirebaseInitService.initialize();
```

Hapi C — Shto metodën e tërheqjes (GDPR Art. 17):
- `HiveConsentRepository.revokeConsent()` → fshin consent-in nga Hive
- Kjo duhet të çaktivizojë `_canSync()` automatikisht pa fshirë të dhënat lokale

**Kriteri pranimit:**
- [ ] Consent ruhet në Hive pas konfirmimit
- [ ] Firebase nuk inicializohet pa consent të ruajtur
- [ ] Tërheqja e consent-it bllokon sync-un e mëtejshëm
- [ ] Test i ri: `consent_flow_test.dart` verifikon të tria rrugët (grant / refuse / revoke)

---

### Task 2 — Fshirja e llogarisë fshin Firestore para Auth 🔴 [GDPR ART. 17]

**Problemi (B016):** `AuthService.deleteAccount()` fshi llogarinë Auth pa pastruar
dokumentet Firestore. Të dhënat cloud mbeten pa pronar.

**Skedarët:**
- `lib/features/auth/services/auth_service.dart` (L135–L141)
- `lib/features/settings/presentation/settings_screen.dart` (L399)

**Çfarë duhet bërë:**

Refaktoro `AuthService.deleteAccount()`:
```dart
static Future<AuthResult> deleteAccount() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return AuthResult.failure('Nuk ka llogari aktive');

  // Hapi 1: fshi Firestore PARA fshirjes Auth
  try {
    await SyncService.deleteAllUserData(uid);
  } catch (e) {
    // Dështimi i Firestore nuk duhet të bllokojë fshirjen Auth
    // por duhet të raportohet qartë
    debugPrint('GDPR: Firestore cleanup dështoi: ${e.toString()}');
    // Kthe error dhe lejo përdoruesin të vendosë nëse vazhdon
    return AuthResult.partialFailure('Të dhënat cloud nuk u fshinë. Vazhdo gjithsesi?');
  }

  // Hapi 2: pastro Hive lokal
  await HiveConsentRepository.revokeConsent();
  await FamilyProfileRepository.clearAll();

  // Hapi 3: fshi llogarinë Auth
  try {
    await FirebaseAuth.instance.currentUser!.delete();
    return AuthResult.success();
  } catch (e) {
    return AuthResult.failure('Fshirja e llogarisë dështoi: ${e.toString()}');
  }
}
```

Shto dialog konfirmimi dy-hapësh në `settings_screen.dart` që tregon qartë:
*"Po fshish të dhënat cloud dhe llogarinë. Progresi lokal mbetet në pajisje."*

**Kriteri pranimit:**
- [ ] `SyncService.deleteAllUserData()` thirret para `user.delete()`
- [ ] Dështimi i Firestore trajtohet pa humbje të llogarisë Auth pa dijeninë e përdoruesit
- [ ] Test i ri: `auth_service_delete_test.dart` verifikon rendin e operacioneve

---

### Task 3 — Politika e privatësisë reflekton realitetin 🔴 [DISCLOSURE]

**Problemi (B017):** `privacy_policy_screen.dart:46` deklaron se "asnjë të dhënë nuk
dërgohet në internet" ndërkohë që `sync_service.dart` dërgon të dhëna në Firestore.

**Skedari:**
- `lib/features/settings/presentation/privacy_policy_screen.dart` (L46)

**Çfarë duhet bërë:**

Zëvendëso tekstin statik me dy seksione të kushtëzuara bazuar në gjendjen e consent-it:

```dart
// Seksioni A — gjithmonë i shfaqur (modaliteti lokal)
'Modaliteti lokal (aktiv gjithmonë): Të gjithë të dhënat e lojës — '
'progresi, pikët dhe aktiviteti — ruhen vetëm në pajisjen tuaj '
'dhe nuk dërgohen askund.',

// Seksioni B — shfaqet vetëm nëse hasConsent == true
if (hasConsent) ...[
  'Modaliteti cloud (aktiv sipas zgjedhjes suaj): Keni zgjedhur '
  'sinkronizimin e progresit. Të dhënat dërgohen të enkriptuara '
  'në serverët e Firebase (Google) sipas kushteve të datës [data consent]. '
  'Mund ta çaktivizoni në çdo kohë nga Cilësimet → Fshi llogarinë cloud.',
]
```

**Kriteri pranimit:**
- [ ] Teksti i politikës ndryshon dinamikisht sipas gjendjes së consent-it
- [ ] Versioni "lokal-only" nuk përmend Firebase fare
- [ ] Versioni "cloud aktiv" specifikon çfarë dërgohet dhe si tërhiqet

---

### Task 4 — Gjeneratori i trekëndëshit — width çift i garantuar 🔴 [PEDAGOGJIKE]

**Problemi (B018):** `geometry_question_generator.dart:47` gjeneron `width` me
`nextInt(8) + 3` (vlera 3–10, gjysma tek). Formula `S = b×h/2` jep decimale.
Aktualisht zgjidhet me `_roundToOneDecimal()` — jo e pranueshme pedagogjikisht
për nxënës 6–10 vjeç.

**Skedari:**
- `lib/features/geometry/domain/geometry_question_generator.dart` (L47, L56)

**Çfarë duhet bërë:**
```dart
// Para:
width = random.nextInt(8) + 3;

// Pas:
// Gjenero vetëm çift: 4, 6, 8, 10, 12, 14
final evenWidths = [4, 6, 8, 10, 12, 14];
width = evenWidths[random.nextInt(evenWidths.length)];
```

Hiq `_roundToOneDecimal()` nga llogaritja e trekëndëshit — nuk duhet të jetë
kurrë e nevojshme pas ndryshimit.

Verifiko gjithashtu logjikën e distractors të trekëndëshit: a mund të prodhojë
distractor negativ ose zero? Nëse po, shto `where((d) => d > 0)`.

**Kriteri pranimit:**
- [ ] Të gjitha pyetjet e trekëndëshit kanë `answer` të plotë (int)
- [ ] `_roundToOneDecimal()` hiqet ose nuk thirret më për trekëndësh
- [ ] Test ekzistues `geometry_question_generator_test.dart` zgjerohet me:
  `expect(question.answer % 1, equals(0))` për çdo pyetje trekëndëshi

---

### Task 5 — Sinkronizimi i versionit në pubspec.yaml 🔴 [METADATA]

**Problemi:** `pubspec.yaml:20` tregon `version: 2.0.0+1`; auditimi synon `v2.1.0`.

**Skedari:**
- `pubspec.yaml` (L20)

**Çfarë duhet bërë:**
```yaml
# Para:
version: 2.0.0+1

# Pas:
version: 2.1.0+2
```

`versionCode` (`+2`) duhet të jetë gjithmonë në rritje nga versioni i mëparshëm
i publikuar në Play Console. Verifiko `versionCode` aktual në Play Console para
vendosjes së numrit.

**Kriteri pranimit:**
- [ ] `pubspec.yaml` tregon `2.1.0+2` (ose `versionCode` i duhur sipas historikut Play Console)
- [ ] `flutter build apk --release` prodhon APK me `versionName=2.1.0`

---

### Task 6 — Teste për bllokuesit e rinj 🔴 [MBULIM]

**Problemi:** Tre rrjedhat më kritike (consent, fshirje llogarie, sync) nuk kanë
teste direkte.

**Skedarët e rinj:**
- `test/features/privacy/consent_flow_test.dart`
- `test/features/auth/auth_service_delete_test.dart`
- `test/core/sync/sync_service_delete_test.dart`

**Çfarë duhet testuar:**

*consent_flow_test.dart:*
```
✓ Consent i dhënë → ruhet në Hive me timestamp
✓ Consent i refuzuar → Firebase nuk inicializohet
✓ Consent i tërhequr → _canSync() kthen false
✓ ConsentFlowScreen shfaqet para ParentSignUpScreen kur consent mungon
```

*auth_service_delete_test.dart:*
```
✓ deleteAccount() thirret SyncService.deleteAllUserData() para user.delete()
✓ Nëse Firestore dështon → kthehet partialFailure, Auth nuk fshihet
✓ Pas fshirjes → HiveConsentRepository.hasValidConsent() kthen false
```

*sync_service_delete_test.dart:*
```
✓ deleteAllUserData(uid) fshin të gjitha dokumentet sipas uid
✓ Nëse Firestore nuk është i aksesueshëm → hedh exception (jo silent fail)
```

**Kriteri pranimit:** Suite totale ≥ 168 teste, kalon.

---

## POST-RELEASE BACKLOG (pas Sprint 15)

Këto janë të rëndësishme por **nuk bllokojnë** release-in nëse Sprint 15 mbyllet.

### PB-1 — `StateNotifier` → `AsyncNotifier` 🟡
Refaktoro `ProgressNotifier` dhe `WeeklyStatsNotifier` në `AsyncNotifier`.
Prioritet: i ulët. Funksionon korrekt aktualisht.

### PB-2 — Hardcoded dimensions mbetëse 🟡
Adreso rastet e identifikuara:
- `parent_report_screen.dart` L69 (`maxWidth: 700`), L471 (`width: 22`), L753 (`fontSize: 26`)
- `challenge_screen.dart` L156 (`EdgeInsets.all(22)`)
- `settings_screen.dart` L102 (`maxWidth: 640`)
- `family_setup_screen.dart` L94 (`EdgeInsets.all(20)`)
Strategji: kërkim sistematik me grep, jo one-by-one.

### PB-3 — Copy hardcoded mbetëse 🟡
Shto ARB strings për:
- `settings_screen.dart` (`'Cilësimet'`)
- `privacy_policy_screen.dart` (`'Politika e Privatësisë'`)
- `fraction_challenge_screen.dart` (kicker, title, label)
- `missing_x_challenge_screen.dart` (feedback, tituj)

### PB-4 — Aksesueshmëria: Semantics dhe Tooltip 🟡
- `CosmicTopBar`: shto `tooltip` për butonat back/settings/notifications
- `AnswerButton`: shto `Semantics(label: ...)` me vlerën numerike
- `CosmicBottomNav`: shto `tooltip` per çdo tab
- Vendos `minimumSize: Size(48, 48)` explicit ku mungon

### PB-5 — Teste end-to-end për rrjedhat cloud 🟡
- Integration test: Dashboard → Consent → SignUp → Sync → DeleteAccount
- Golden tests: Dashboard dark theme, ResultsScreen celebratory

### PB-6 — Paketa: major updates 🟡
Pas stabilizimit të release-it, vlerëso:
- `flutter_riverpod` → version i ri major (breaking changes të mundshme)
- `firebase_*` → updateo në grup
- `fl_chart` → verifiko API changes
- `audioplayers` → verifiko nëse API ndryshoi
Strategji: branch i dedikuar `chore/dependency-upgrade`, teste para merge.

---

## Regjistri i bug-eve të rinj

| ID | Përshkrimi | Severiteti | Sprint |
|---|---|---|---|
| B015 | Consent flow nuk ruan në Hive dhe nuk gate-on Firebase | **Kritik/Ligjor** | Sprint 15 |
| B016 | Fshirja Auth nuk pastron Firestore (GDPR Art. 17) | **Kritik/Ligjor** | Sprint 15 |
| B017 | Politika privatësisë kundërshton sjelljen reale cloud | **Kritik/Ligjor** | Sprint 15 |
| B018 | Gjeneratori trekëndëshi prodhon sipërfaqe decimale | **Kritik/Pedagogjik** | Sprint 15 |

---

## Kushtëzimi i release-it

```
Sprint 15 Tasks 1–6 → MBYLLUR
         ↓
fvm flutter test   → 168+ teste, kalon
fvm flutter analyze → 0 warnings
flutter build apk --release → builds pa gabime
         ↓
RELEASE ME KUSHTE → Submit në Play Store Internal Testing
         ↓
PB-1 deri PB-6 → Post-release, sipas prioritetit
```
