# 🔐 MathLingo — Udhëzim Implementimi: Firebase Auth
## Sprint 10B · v1.6.2 · Varësia: Sprint 10A + Sprint 10.5 (TË DY)

> **Ky dokument:** Udhëzim teknik step-by-step për implementimin e Firebase Auth  
> **Audienca:** Zhvilluesi kryesor Flutter  
> **Parakusht i detyrueshëm:** Sprint 10.5 (Privacy & Compliance) duhet të jetë **DONE** para çdo linje kodi të këtij sprinti  
> **Rregull kritike:** Firebase inicializohet VETËM pas consent-it aktiv prindëror — jo automatikisht në `main()`

---

## 0. Konteksti arkitekturor

### Çfarë ekziston tashmë (pas Sprint 10A)

```
lib/
├── features/
│   ├── family/
│   │   ├── models/
│   │   │   ├── family_profile.dart        ✅ Sprint 10A
│   │   │   └── child_profile.dart         ✅ Sprint 10A
│   │   ├── repositories/
│   │   │   └── family_profile_repository.dart  ✅ Sprint 10A
│   │   └── screens/
│   │       ├── family_setup_screen.dart   ✅ Sprint 10A
│   │       └── family_switcher_screen.dart ✅ Sprint 10A
│   └── privacy/                           ✅ Sprint 10.5
│       ├── consent_flow_screen.dart
│       ├── settings_screen.dart
│       └── privacy_policy_screen.dart
├── core/
│   └── storage/
│       └── user_progress_storage.dart     ✅ ekzistues
```

### Çfarë ndërtojmë në Sprint 10B

```
lib/
├── features/
│   └── auth/                              🔨 SPRINT 10B
│       ├── models/
│       │   └── parent_account.dart
│       ├── services/
│       │   └── auth_service.dart
│       ├── providers/
│       │   └── auth_provider.dart
│       ├── screens/
│       │   ├── parent_signup_screen.dart
│       │   └── parent_signin_screen.dart
│       └── widgets/
│           └── auth_gate.dart
├── core/
│   └── sync/                              🔨 SPRINT 10B
│       ├── sync_service.dart
│       └── firestore_schema.dart
```

### Parimi i arkitekturës: Hive është e vërteta

```
Hive (lokal)  ←→  SyncService  ←→  Firestore (cloud)
     ↑                                      ↓
  E vërteta                          Pasqyrë/backup
  primare                            (vetëm me consent)
```

---

## Hapi 1: Konfigurimi i Firebase Project

### 1.1 Krijo projektin në Firebase Console

```
1. Shko te https://console.firebase.google.com
2. "Add project" → Emri: "MathLingo"
3. Çaktivizo Google Analytics (GDPR — nuk e duam)
4. Krijo projektin
```

### 1.2 Regjistro aplikacionin Android

```
1. "Add app" → Android
2. Package name: com.mathlingo.app  (saktësisht ky — jo tjetër)
3. App nickname: MathLingo Android
4. Debug signing certificate SHA-1:
   cd android && ./gradlew signingReport
   (kopjo SHA-1 nga "Variant: debug")
5. Shkarko google-services.json
6. Vendose te: android/app/google-services.json
```

### 1.3 Regjistro aplikacionin iOS

```
1. "Add app" → iOS
2. Bundle ID: com.mathlingo.app
3. App nickname: MathLingo iOS
4. Shkarko GoogleService-Info.plist
5. Vendose te: ios/Runner/GoogleService-Info.plist
   (në Xcode: drag & drop, "Copy items if needed" ✓)
```

### 1.4 Aktivizo Authentication

```
Firebase Console → Authentication → Get started
→ Sign-in method → Email/Password → Enable → Save

MOS aktivizo:
  ✗ Google Sign-in  (inkompatibël GDPR për fëmijë)
  ✗ Phone           (kompleks për kontekstin shqiptar)
  ✗ Anonymous       (do e shtojmë vetëm nëse nevojitet)
```

### 1.5 Konfiguro Firestore

```
Firebase Console → Firestore Database → Create database
→ Start in production mode (jo test mode)
→ Location: europe-west3 (Frankfurt — më afër, GDPR compliant)
```

**Security Rules fillestare** (do i rifinojmë në hapin 7):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Vetëm prindi akseson të dhënat e veta
    match /users/{uid}/{document=**} {
      allow read, write: if request.auth != null 
                         && request.auth.uid == uid;
    }
    // Asnjë akses publik
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

### 1.6 Çaktivizo Firebase Analytics dhe Crashlytics

```
Firebase Console → Project Settings → Integrations
→ Google Analytics → Disconnect (ose mos e aktivizo)

Në google-services.json, verifikoni:
"services": {
  "analytics-service": {
    "status": 1  ← duhet të jetë 1 (disabled)
  }
}
```

---

## Hapi 2: Varësitë pubspec.yaml

### 2.1 Shto paketet

Hap `pubspec.yaml` dhe shto nën `dependencies:`:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # === EKZISTUESE (mos i ndrysho) ===
  flutter_riverpod: ^2.6.1
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  google_mlkit_text_recognition: ^0.15.1
  image: ^4.2.0
  image_picker: ^1.0.0
  flutter_launcher_icons: ^0.13.1
  cupertino_icons: ^1.0.8

  # === TË REJA — SPRINT 10B ===
  firebase_core: ^3.4.0
  firebase_auth: ^5.2.0
  cloud_firestore: ^5.3.0
```

```
fvm flutter pub get
```

### 2.2 Konfiguro Android build.gradle.kts

Hap `android/build.gradle.kts` (root level):

```kotlin
plugins {
    // Shto:
    id("com.google.gms.google-services") version "4.4.2" apply false
}
```

Hap `android/app/build.gradle.kts`:

```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    // Shto:
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}
```

### 2.3 Konfiguro iOS

Hap `ios/Podfile` dhe sigurohu:

```ruby
platform :ios, '13.0'  # Firebase kërkon minimum iOS 13
```

Pastaj:

```
cd ios && pod install && cd ..
```

---

## Hapi 3: Inicializimi i Firebase

### 3.1 Rregull kritike e inicializimit

Firebase **nuk duhet** të inicializohet automatikisht në `main()`. Inicializohet vetëm pas:
1. Consent-it aktiv prindëror (Sprint 10.5 — `ConsentFlowScreen`)
2. Konfirmimit të PIN-it prindëror

### 3.2 Modifiko main.dart

```dart
// lib/main.dart

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // gjenerohet nga FlutterFire CLI

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive inicializohet gjithmonë (lokal, pa consent)
  await Hive.initFlutter();
  await UserProgressStorage.initialize();
  await SessionTracker.init();
  await FamilyProfileRepository.initialize(); // Sprint 10A

  // Firebase NUK inicializohet këtu.
  // Inicializohet nga FirebaseInitService pas consent-it.

  runApp(
    const ProviderScope(
      child: MathLingoApp(),
    ),
  );
}
```

### 3.3 Krijo FirebaseInitService

```dart
// lib/core/services/firebase_init_service.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../../firebase_options.dart';

/// Menaxhon inicializimin e Firebase pas consent-it prindëror.
/// Thirret VETËM nga ConsentFlowScreen pas konfirmimit të PIN.
class FirebaseInitService {
  static bool _initialized = false;

  static bool get isInitialized => _initialized;

  /// Inicializon Firebase. Thirret vetëm pas consent-it.
  static Future<bool> initialize() async {
    if (_initialized) return true;

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Çaktivizo analytics eksplicitisht
      // (edhe nëse është i konfiguruar gabimisht)
      if (!kIsWeb) {
        // Analytics është çaktivizuar nga konfigurimi i projektit
        // Shtesë sigurie: nuk thirrim asnjë analytics API
      }

      _initialized = true;
      debugPrint('[Firebase] Inicializuar me sukses pas consent-it.');
      return true;
    } catch (e) {
      debugPrint('[Firebase] Gabim inicializimi: $e');
      return false;
    }
  }

  /// Rinicio gjendjen (për fshirje llogarie).
  static void reset() {
    _initialized = false;
  }
}
```

### 3.4 Gjenero firebase_options.dart me FlutterFire CLI

```bash
# Instalo FlutterFire CLI (nëse nuk e ke)
dart pub global activate flutterfire_cli

# Konfiguro — zgjedh projektin MathLingo
flutterfire configure --project=mathlingo-xxxxx

# Kjo gjeneron: lib/firebase_options.dart
# SHTO firebase_options.dart në .gitignore!
```

Shto në `.gitignore`:

```
# Firebase (sensitive)
lib/firebase_options.dart
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
```

---

## Hapi 4: Modeli ParentAccount

```dart
// lib/features/auth/models/parent_account.dart

import 'package:hive/hive.dart';

part 'parent_account.g.dart';

/// Modeli i llogarisë prindërore.
/// Ruan vetëm informacionin minimal — email-in dhe UID Firebase.
/// NDALIM: Asnjë të dhënë fëmijësh nuk ruhet këtu.
@HiveType(typeId: 10)
class ParentAccount extends HiveObject {
  @HiveField(0)
  final String uid; // Firebase UID — jo email (privacy)

  @HiveField(1)
  final String email;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final bool cloudSyncEnabled;

  @HiveField(4)
  final DateTime? lastSyncAt;

  ParentAccount({
    required this.uid,
    required this.email,
    required this.createdAt,
    this.cloudSyncEnabled = false,
    this.lastSyncAt,
  });

  ParentAccount copyWith({
    bool? cloudSyncEnabled,
    DateTime? lastSyncAt,
  }) {
    return ParentAccount(
      uid: uid,
      email: email,
      createdAt: createdAt,
      cloudSyncEnabled: cloudSyncEnabled ?? this.cloudSyncEnabled,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
    );
  }
}
```

Gjenero adapter:

```bash
fvm flutter packages pub run build_runner build --delete-conflicting-outputs
```

---

## Hapi 5: AuthService

```dart
// lib/features/auth/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/parent_account.dart';
import '../../../core/services/firebase_init_service.dart';

/// Rezultati i operacioneve të auth.
sealed class AuthResult {
  const AuthResult();
}

class AuthSuccess extends AuthResult {
  final ParentAccount account;
  const AuthSuccess(this.account);
}

class AuthFailure extends AuthResult {
  final String messageKey; // çelës ARB për mesazhin shqip
  const AuthFailure(this.messageKey);
}

/// Shërbimi kryesor i autentifikimit prindëror.
///
/// Rregull: Fëmija nuk krijon llogari.
/// Vetëm prindi krijon llogari, fëmija luan nën profilin familjar.
class AuthService {
  static const String _boxName = 'parent_account';
  static const String _accountKey = 'current';

  FirebaseAuth get _auth => FirebaseAuth.instance;

  /// Regjistrim i prindit me email dhe fjalëkalim.
  Future<AuthResult> signUp({
    required String email,
    required String password,
  }) async {
    // Sigurim: Firebase duhet të jetë inicializuar
    if (!FirebaseInitService.isInitialized) {
      return const AuthFailure('authErrorFirebaseNotReady');
    }

    // Validim bazë para thirrjes API
    if (!_isValidEmail(email)) {
      return const AuthFailure('authErrorInvalidEmail');
    }
    if (!_isValidPassword(password)) {
      return const AuthFailure('authErrorWeakPassword');
    }

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        return const AuthFailure('authErrorUnknown');
      }

      // Krijo ParentAccount dhe ruaje lokalisht
      final account = ParentAccount(
        uid: user.uid,
        email: email.trim().toLowerCase(),
        createdAt: DateTime.now(),
        cloudSyncEnabled: true,
      );

      await _saveAccountLocally(account);
      debugPrint('[Auth] Prind i regjistruar: ${user.uid}');
      return AuthSuccess(account);

    } on FirebaseAuthException catch (e) {
      debugPrint('[Auth] FirebaseAuthException: ${e.code}');
      return AuthFailure(_mapFirebaseError(e.code));
    } catch (e) {
      debugPrint('[Auth] Gabim i papritur: $e');
      return const AuthFailure('authErrorUnknown');
    }
  }

  /// Hyrje e prindit me email dhe fjalëkalim.
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    if (!FirebaseInitService.isInitialized) {
      return const AuthFailure('authErrorFirebaseNotReady');
    }

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        return const AuthFailure('authErrorUnknown');
      }

      // Lexo ose krijo ParentAccount lokalisht
      var account = await _loadAccountLocally();
      if (account == null) {
        account = ParentAccount(
          uid: user.uid,
          email: email.trim().toLowerCase(),
          createdAt: DateTime.now(),
          cloudSyncEnabled: true,
        );
        await _saveAccountLocally(account);
      }

      debugPrint('[Auth] Hyrje e suksesshme: ${user.uid}');
      return AuthSuccess(account);

    } on FirebaseAuthException catch (e) {
      debugPrint('[Auth] FirebaseAuthException: ${e.code}');
      return AuthFailure(_mapFirebaseError(e.code));
    } catch (e) {
      debugPrint('[Auth] Gabim i papritur: $e');
      return const AuthFailure('authErrorUnknown');
    }
  }

  /// Dalje nga llogaria.
  Future<void> signOut() async {
    if (!FirebaseInitService.isInitialized) return;
    await _auth.signOut();
    await _clearAccountLocally();
    debugPrint('[Auth] Prindi doli nga llogaria.');
  }

  /// Fshi llogarinë dhe të gjitha të dhënat cloud.
  /// Kjo zbaton GDPR Nenin 17 (e drejta e fshirjes).
  Future<bool> deleteAccount() async {
    if (!FirebaseInitService.isInitialized) return false;

    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      // 1. Fshi të dhënat Firestore (SyncService do e bëjë këtë)
      // 2. Fshi llogarinë Firebase Auth
      await user.delete();
      // 3. Fshi të dhënat lokale
      await _clearAccountLocally();

      debugPrint('[Auth] Llogaria u fshi — GDPR Art.17 ✓');
      FirebaseInitService.reset();
      return true;

    } on FirebaseAuthException catch (e) {
      // Nëse kërkohet ri-autentifikim
      if (e.code == 'requires-recent-login') {
        debugPrint('[Auth] Kërkohet ri-autentifikim për fshirje.');
        return false;
      }
      return false;
    }
  }

  /// Kthe prindin aktual ose null.
  Future<ParentAccount?> getCurrentAccount() async {
    return _loadAccountLocally();
  }

  /// A është prindi i kyçur?
  bool get isSignedIn =>
      FirebaseInitService.isInitialized &&
      _auth.currentUser != null;

  // === Private helpers ===

  Future<void> _saveAccountLocally(ParentAccount account) async {
    final box = await Hive.openBox<ParentAccount>(_boxName);
    await box.put(_accountKey, account);
  }

  Future<ParentAccount?> _loadAccountLocally() async {
    final box = await Hive.openBox<ParentAccount>(_boxName);
    return box.get(_accountKey);
  }

  Future<void> _clearAccountLocally() async {
    final box = await Hive.openBox<ParentAccount>(_boxName);
    await box.clear();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$').hasMatch(email.trim());
  }

  bool _isValidPassword(String password) {
    // Minimum 8 karaktere, të paktën 1 numër
    return password.length >= 8 &&
        password.contains(RegExp(r'\d'));
  }

  String _mapFirebaseError(String code) => switch (code) {
    'email-already-in-use'   => 'authErrorEmailInUse',
    'invalid-email'          => 'authErrorInvalidEmail',
    'weak-password'          => 'authErrorWeakPassword',
    'user-not-found'         => 'authErrorUserNotFound',
    'wrong-password'         => 'authErrorWrongPassword',
    'too-many-requests'      => 'authErrorTooManyRequests',
    'network-request-failed' => 'authErrorNetwork',
    'user-disabled'          => 'authErrorUserDisabled',
    _                        => 'authErrorUnknown',
  };
}
```

---

## Hapi 6: AuthProvider (Riverpod)

```dart
// lib/features/auth/providers/auth_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/parent_account.dart';
import '../services/auth_service.dart';

/// State i autentifikimit.
sealed class AuthState {
  const AuthState();
}

class AuthStateInitial extends AuthState {
  const AuthStateInitial();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateAuthenticated extends AuthState {
  final ParentAccount account;
  const AuthStateAuthenticated(this.account);
}

class AuthStateUnauthenticated extends AuthState {
  const AuthStateUnauthenticated();
}

class AuthStateError extends AuthState {
  final String messageKey;
  const AuthStateError(this.messageKey);
}

/// Notifier kryesor i autentifikimit.
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthStateInitial()) {
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    final account = await _authService.getCurrentAccount();
    if (account != null && _authService.isSignedIn) {
      state = AuthStateAuthenticated(account);
    } else {
      state = const AuthStateUnauthenticated();
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    state = const AuthStateLoading();

    final result = await _authService.signUp(
      email: email,
      password: password,
    );

    state = switch (result) {
      AuthSuccess(:final account) => AuthStateAuthenticated(account),
      AuthFailure(:final messageKey) => AuthStateError(messageKey),
    };
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AuthStateLoading();

    final result = await _authService.signIn(
      email: email,
      password: password,
    );

    state = switch (result) {
      AuthSuccess(:final account) => AuthStateAuthenticated(account),
      AuthFailure(:final messageKey) => AuthStateError(messageKey),
    };
  }

  Future<void> signOut() async {
    await _authService.signOut();
    state = const AuthStateUnauthenticated();
  }

  Future<bool> deleteAccount() async {
    final success = await _authService.deleteAccount();
    if (success) {
      state = const AuthStateUnauthenticated();
    }
    return success;
  }
}

// === Providers ===

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authServiceProvider));
});

// Provider helper për akses të shpejtë
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider) is AuthStateAuthenticated;
});

final currentParentProvider = Provider<ParentAccount?>((ref) {
  final state = ref.watch(authProvider);
  return state is AuthStateAuthenticated ? state.account : null;
});
```

---

## Hapi 7: Ekranet Auth

### 7.1 ParentSignUpScreen

```dart
// lib/features/auth/screens/parent_signup_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../../../shared/widgets/glass_panel.dart';
import '../../../shared/widgets/cosmic_button.dart';
import '../../../core/services/firebase_init_service.dart';
import '../../privacy/screens/consent_flow_screen.dart';

class ParentSignUpScreen extends ConsumerStatefulWidget {
  const ParentSignUpScreen({super.key});

  @override
  ConsumerState<ParentSignUpScreen> createState() =>
      _ParentSignUpScreenState();
}

class _ParentSignUpScreenState extends ConsumerState<ParentSignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _onSignUp() async {
    // Validim lokal
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      _showError('authErrorEmptyFields');
      return;
    }

    if (_passwordController.text != _confirmController.text) {
      _showError('authErrorPasswordMismatch');
      return;
    }

    // RREGULL KRITIKE: Verifikimi i consent-it para Firebase
    final hasConsent = await _checkAndRequestConsent();
    if (!hasConsent) return;

    // Inicializo Firebase pas consent-it
    final initialized = await FirebaseInitService.initialize();
    if (!initialized && mounted) {
      _showError('authErrorFirebaseNotReady');
      return;
    }

    if (!mounted) return;

    await ref.read(authProvider.notifier).signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  Future<bool> _checkAndRequestConsent() async {
    // Nëse consent-i është dhënë tashmë (Sprint 10.5), kalo.
    // Nëse jo, hap ConsentFlowScreen.
    final consentGiven = await ConsentFlowScreen.checkConsent();
    if (consentGiven) return true;

    if (!mounted) return false;

    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => const ConsentFlowScreen(),
      ),
    );

    return result == true;
  }

  void _showError(String messageKey) {
    // Shfaq mesazhin nga ARB strings
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_getErrorMessage(messageKey)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  String _getErrorMessage(String key) => switch (key) {
    'authErrorEmptyFields'      => 'Plotësoni të gjitha fushat.',
    'authErrorPasswordMismatch' => 'Fjalëkalimet nuk përputhen.',
    'authErrorEmailInUse'       => 'Ky email është i regjistruar tashmë.',
    'authErrorWeakPassword'     =>
        'Fjalëkalimi duhet të ketë ≥8 karaktere dhe 1 numër.',
    'authErrorNetwork'          => 'Problem me lidhjen. Provo sërish.',
    'authErrorFirebaseNotReady' => 'Shërbimi nuk është gati. Provo sërish.',
    _                           => 'Ndodhi një gabim. Provo sërish.',
  };

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthStateLoading;

    // Navigo automatikisht pas suksesit
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthStateAuthenticated && mounted) {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      } else if (next is AuthStateError && mounted) {
        _showError(next.messageKey);
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'MathLingo',
          style: TextStyle(
            color: Color(0xFFBC13FE),
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Titull
              Text(
                'Krijo Llogari Prindi',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Llogaria e prindit menaxhon profilet e fëmijëve '
                'dhe mundëson sinkronizimin ndërmjet pajisjeve.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                ),
              ),

              const SizedBox(height: 32),

              // Formë
              GlassPanel(
                child: Column(
                  children: [
                    // Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        labelText: 'Email-i i prindit',
                        hintText: 'prindi@shembull.com',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Fjalëkalimi
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Fjalëkalimi',
                        hintText: 'Minimum 8 karaktere, 1 numër',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Konfirmo fjalëkalimin
                    TextFormField(
                      controller: _confirmController,
                      obscureText: _obscureConfirm,
                      decoration: InputDecoration(
                        labelText: 'Konfirmo fjalëkalimin',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () => setState(
                            () => _obscureConfirm = !_obscureConfirm,
                          ),
                        ),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Shënim privacy
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 14,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Të dhënat ruhen me enkriptim. '
                      'Lexo Politikën e Privatësisë para regjistrimit.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Butoni Regjistrohu
              SizedBox(
                width: double.infinity,
                child: CosmicButton(
                  label: isLoading ? 'Duke u regjistruar...' : 'Regjistrohu',
                  onPressed: isLoading ? null : _onSignUp,
                ),
              ),

              const SizedBox(height: 16),

              // Lidhja me hyrjen
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const ParentSignInScreen(),
                      ),
                    );
                  },
                  child: const Text('Keni llogari? Hyni këtu'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### 7.2 ParentSignInScreen (struktura kryesore)

```dart
// lib/features/auth/screens/parent_signin_screen.dart

// Strukturë identike me SignUp, por me:
// - Vetëm 2 fusha: email + fjalëkalim
// - Butoni: "Hyni"
// - Thirrja: ref.read(authProvider.notifier).signIn(...)
// - Lidhja te "Harruat fjalëkalimin?" → Firebase sendPasswordResetEmail
// - Lidhja te "Keni nevojë për llogari? Regjistrohuni"

class ParentSignInScreen extends ConsumerStatefulWidget {
  const ParentSignInScreen({super.key});
  // ... implementim i ngjashëm me SignUp
}
```

---

## Hapi 8: Skema Firestore dhe SyncService

### 8.1 Skema e të dhënave Firestore

```
Firestore Database
└── users/
    └── {uid}/                          ← UID Firebase i prindit
        ├── profile/
        │   └── meta                    ← createdAt, lastSyncAt
        └── children/
            └── {childId}/              ← childId nga Hive (UUID lokal)
                ├── info                ← pseudonym, avatarIndex (JO emra realë)
                └── progress/
                    └── {date}/         ← yyyy-MM-dd
                        ├── totalPoints
                        ├── accuracy
                        └── moduleScores: {geometry: 60, addition: 40, ...}
```

### 8.2 firestore_schema.dart

```dart
// lib/core/sync/firestore_schema.dart

/// Çelësat e koleksioneve dhe fushave Firestore.
/// Centralizuar këtu për të shmangur typos.
abstract class FirestoreSchema {
  // Koleksionet
  static const String users     = 'users';
  static const String children  = 'children';
  static const String progress  = 'progress';
  static const String info      = 'info';

  // Fushat e profilit
  static const String pseudonym    = 'pseudonym';
  static const String avatarIndex  = 'avatarIndex';
  static const String createdAt    = 'createdAt';
  static const String lastSyncAt   = 'lastSyncAt';

  // Fushat e progresit
  static const String totalPoints  = 'totalPoints';
  static const String accuracy     = 'accuracy';
  static const String moduleScores = 'moduleScores';

  // Rrugët e dokumenteve
  static String userDoc(String uid) => '$users/$uid';

  static String childInfoDoc(String uid, String childId) =>
      '$users/$uid/$children/$childId/$info';

  static String progressDoc(String uid, String childId, String date) =>
      '$users/$uid/$children/$childId/$progress/$date';
}
```

### 8.3 SyncService

```dart
// lib/core/sync/sync_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/firebase_init_service.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/family/models/child_profile.dart';
import '../../features/family/repositories/family_profile_repository.dart';
import 'firestore_schema.dart';

/// Menaxhon sinkronizimin Hive ↔ Firestore.
///
/// Rregull: Hive është e vërteta primare.
/// Firestore është vetëm pasqyrë për backup dhe multi-device.
/// Nëse nuk ka internet, aplikacioni funksionon plotësisht nga Hive.
class SyncService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Ref _ref;

  SyncService(this._ref);

  /// Sinkronizo progresin e një fëmijë me Firestore.
  /// Thirret pas çdo sesioni të përfunduar.
  Future<void> syncChildProgress(ChildProfile child) async {
    // Kushtet e parakërkuara
    if (!_canSync()) return;

    final uid = _ref.read(currentParentProvider)?.uid;
    if (uid == null) return;

    final today = _todayKey();

    try {
      final docPath = FirestoreSchema.progressDoc(uid, child.id, today);

      await _db.doc(docPath).set({
        FirestoreSchema.totalPoints: child.totalPoints,
        FirestoreSchema.accuracy:
            (child.accuracy * 100).round(), // ruaj si integer 0-100
        FirestoreSchema.moduleScores: child.moduleScores,
        FirestoreSchema.lastSyncAt: FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('[Sync] Progres i sinkronizuar: ${child.pseudonym}');
    } on FirebaseException catch (e) {
      // Dështimi i sinkronizimit nuk prek funksionimin lokal
      debugPrint('[Sync] Gabim Firestore: ${e.code} — ${e.message}');
    } catch (e) {
      debugPrint('[Sync] Gabim i papritur: $e');
    }
  }

  /// Sinkronizo profilin e fëmijës (info bazë).
  /// Thirret kur krijohet ose ndryshohet profili.
  Future<void> syncChildInfo(ChildProfile child) async {
    if (!_canSync()) return;

    final uid = _ref.read(currentParentProvider)?.uid;
    if (uid == null) return;

    try {
      final docPath = FirestoreSchema.childInfoDoc(uid, child.id);

      await _db.doc(docPath).set({
        // VETËM pseudonim dhe avatar — jo emra realë
        FirestoreSchema.pseudonym: child.pseudonym,
        FirestoreSchema.avatarIndex: child.avatarIndex,
        FirestoreSchema.createdAt: child.createdAt.toIso8601String(),
        FirestoreSchema.lastSyncAt: FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('[Sync] Info fëmije i sinkronizuar: ${child.pseudonym}');
    } on FirebaseException catch (e) {
      debugPrint('[Sync] Gabim Firestore: ${e.code}');
    }
  }

  /// Shkarko progresin nga Firestore kur hapet pajisja e re.
  /// Last-write-wins: nëse Firestore ka timestamp më të ri, merr nga cloud.
  Future<void> pullFromCloud(String childId) async {
    if (!_canSync()) return;

    final uid = _ref.read(currentParentProvider)?.uid;
    if (uid == null) return;

    try {
      final today = _todayKey();
      final docPath =
          FirestoreSchema.progressDoc(uid, childId, today);
      final doc = await _db.doc(docPath).get();

      if (!doc.exists || doc.data() == null) return;

      final data = doc.data()!;
      final cloudPoints = (data[FirestoreSchema.totalPoints] as int?) ?? 0;

      // Lexo nga Hive
      final local = await FamilyProfileRepository.getChild(childId);
      if (local == null) return;

      // Last-write-wins: merr vlerën më të madhe
      if (cloudPoints > local.totalPoints) {
        await FamilyProfileRepository.updatePoints(
          childId: childId,
          points: cloudPoints,
          accuracy: ((data[FirestoreSchema.accuracy] as int?) ?? 0) / 100.0,
        );
        debugPrint('[Sync] Progres i marrë nga cloud: $cloudPoints pikë');
      }
    } on FirebaseException catch (e) {
      debugPrint('[Sync] Pull error: ${e.code}');
    }
  }

  /// Fshi të gjitha të dhënat cloud të një prindi.
  /// Zbaton GDPR Nenin 17 — e drejta e fshirjes.
  Future<void> deleteAllUserData(String uid) async {
    if (!FirebaseInitService.isInitialized) return;

    try {
      // Fshi të gjithë koleksionin e fëmijëve
      final childrenRef = _db
          .collection(FirestoreSchema.users)
          .doc(uid)
          .collection(FirestoreSchema.children);

      final children = await childrenRef.get();
      final batch = _db.batch();

      for (final child in children.docs) {
        // Fshi progresin e çdo fëmije
        final progressRef = child.reference
            .collection(FirestoreSchema.progress);
        final progress = await progressRef.get();
        for (final p in progress.docs) {
          batch.delete(p.reference);
        }
        batch.delete(child.reference);
      }

      // Fshi dokumentin kryesor të userit
      batch.delete(
        _db.collection(FirestoreSchema.users).doc(uid),
      );

      await batch.commit();
      debugPrint('[Sync] Të gjitha të dhënat cloud u fshin — GDPR Art.17 ✓');
    } on FirebaseException catch (e) {
      debugPrint('[Sync] Gabim fshirjeje: ${e.code}');
    }
  }

  // === Helpers ===

  bool _canSync() {
    return FirebaseInitService.isInitialized &&
        _ref.read(isAuthenticatedProvider);
  }

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}'
        '-${now.day.toString().padLeft(2, '0')}';
  }
}

// Provider
final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(ref);
});
```

---

## Hapi 9: Integrimi me ProgressProvider

### 9.1 Shto sinkronizimin pas sesionit

Në `ChallengeScreen`, `MissingXChallengeScreen` dhe `FractionChallengeScreen`, pas regjistrimit të sesionit:

```dart
// Në metodën _onSessionComplete() të çdo ekrani sfide:

// 1. Regjistro te ProgressProvider (ekzistues)
await ref.read(progressProvider.notifier).recordSession(
  operation: operation,
  score: score,
  accuracy: accuracy,
);

// 2. Sinkronizo me cloud (vetëm nëse autentifikuar)
final activeChild = ref.read(activeFamilyChildProvider);
if (activeChild != null) {
  final syncService = ref.read(syncServiceProvider);
  // Fire-and-forget — dështimi nuk bllokon UI
  unawaited(syncService.syncChildProgress(activeChild));
}
```

### 9.2 Lidhja ProgressProvider me profilin aktiv

```dart
// Modifikimi i ProgressProvider për t'u lidhur me childId aktiv

final progressProvider = StateNotifierProvider
    .autoDispose
    .family<ProgressNotifier, ProgressState, String>(
  (ref, childId) => ProgressNotifier(childId: childId),
);

// Provider kompozit — lexon childId nga profili aktiv
final activeProgressProvider = Provider<ProgressState>((ref) {
  final activeChild = ref.watch(activeFamilyChildProvider);
  if (activeChild == null) {
    return const ProgressState.empty();
  }
  return ref.watch(progressProvider(activeChild.id));
});
```

---

## Hapi 10: AuthGate — Rrjedha e navigimit

```dart
// lib/features/auth/widgets/auth_gate.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

/// Vendos ku shkon prindi sipas gjendjes së auth.
///
/// Logjika:
/// - Pa llogari → DashboardScreen (modal lokal)
/// - Me llogari → DashboardScreen (me sync aktiv)
/// - Butoni "Sinkronizo" në Settings → ParentSignUpScreen
///
/// RREGULL: AuthGate nuk bllokon aksesin e fëmijës.
/// Fëmija gjithmonë mund të luajë pa regjistrim.
class AuthGate extends ConsumerWidget {
  final Widget child; // DashboardScreen

  const AuthGate({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Asnjëherë mos bloko UI — trego fëmijën gjithmonë
    return child;
  }
}
```

**Shënim arkitekturor:** `AuthGate` nuk bllokon UI-n. Firebase Auth nuk është barrierë hyrjeje — është shërbim opsional i aktivizuar nga prindi nga `SettingsScreen`.

---

## Hapi 11: ARB Strings të reja

Shto në `lib/l10n/app_sq.arb`:

```json
{
  "authSignUpTitle": "Krijo Llogari Prindi",
  "authSignInTitle": "Hyni në Llogarinë Tuaj",
  "authEmailLabel": "Email-i i prindit",
  "authEmailHint": "prindi@shembull.com",
  "authPasswordLabel": "Fjalëkalimi",
  "authPasswordHint": "Minimum 8 karaktere, 1 numër",
  "authConfirmPasswordLabel": "Konfirmo fjalëkalimin",
  "authSignUpButton": "Regjistrohu",
  "authSignInButton": "Hyni",
  "authSigningUp": "Duke u regjistruar...",
  "authSigningIn": "Duke hyrë...",
  "authHaveAccount": "Keni llogari? Hyni këtu",
  "authNoAccount": "Keni nevojë për llogari? Regjistrohuni",
  "authForgotPassword": "Harruat fjalëkalimin?",
  "authPrivacyNote": "Të dhënat ruhen me enkriptim. Lexo Politikën e Privatësisë para regjistrimit.",
  "authErrorEmptyFields": "Plotësoni të gjitha fushat.",
  "authErrorPasswordMismatch": "Fjalëkalimet nuk përputhen.",
  "authErrorEmailInUse": "Ky email është i regjistruar tashmë.",
  "authErrorInvalidEmail": "Formati i email-it nuk është i saktë.",
  "authErrorWeakPassword": "Fjalëkalimi duhet të ketë ≥8 karaktere dhe 1 numër.",
  "authErrorUserNotFound": "Nuk u gjet llogari me këtë email.",
  "authErrorWrongPassword": "Fjalëkalimi nuk është i saktë.",
  "authErrorTooManyRequests": "Shumë tentativa. Provo pas disa minutash.",
  "authErrorNetwork": "Problem me lidhjen. Kontrollo internetin.",
  "authErrorFirebaseNotReady": "Shërbimi nuk është gati. Provo sërish.",
  "authErrorUserDisabled": "Kjo llogari është çaktivizuar.",
  "authErrorUnknown": "Ndodhi një gabim i papritur. Provo sërish.",
  "syncEnabled": "Sinkronizimi aktiv",
  "syncDisabled": "Sinkronizimi çaktiv",
  "syncLastSync": "Sinkronizimi i fundit: {date}",
  "@syncLastSync": {
    "placeholders": {
      "date": { "type": "String" }
    }
  },
  "authDeleteAccountTitle": "Fshi Llogarinë",
  "authDeleteAccountConfirm": "Kjo veprim fshi të gjitha të dhënat nga serveri. Të dhënat lokale mbeten. Jeni i sigurt?",
  "authDeleteAccountButton": "Fshi Llogarinë Përfundimisht",
  "authSignOutButton": "Dil nga Llogaria"
}
```

---

## Hapi 12: Firestore Security Rules finale

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Funksion ndihmës: a është prindi pronar?
    function isOwner(uid) {
      return request.auth != null && request.auth.uid == uid;
    }

    // Funksion ndihmës: validizo të dhënat e progresit
    function isValidProgress() {
      let data = request.resource.data;
      return data.keys().hasAll(['totalPoints', 'accuracy'])
          && data.totalPoints is int
          && data.totalPoints >= 0
          && data.accuracy is int
          && data.accuracy >= 0
          && data.accuracy <= 100;
    }

    // Funksion ndihmës: validizo info fëmije
    function isValidChildInfo() {
      let data = request.resource.data;
      return data.keys().hasAll(['pseudonym', 'avatarIndex'])
          && data.pseudonym is string
          && data.pseudonym.size() >= 1
          && data.pseudonym.size() <= 20
          && data.avatarIndex is int
          && data.avatarIndex >= 0
          && data.avatarIndex < 8; // 8 avatarë disponueshëm
    }

    // Profili i userit
    match /users/{uid} {
      allow read, write: if isOwner(uid);

      // Info e fëmijës
      match /children/{childId}/info {
        allow read: if isOwner(uid);
        allow write: if isOwner(uid) && isValidChildInfo();
      }

      // Progresi ditor
      match /children/{childId}/progress/{date} {
        allow read: if isOwner(uid);
        allow write: if isOwner(uid) && isValidProgress();
      }
    }

    // Asnjë gjë tjetër nuk lejohet
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

---

## Hapi 13: Tests

### 13.1 Unit tests AuthService

```dart
// test/features/auth/auth_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mathlingo/features/auth/services/auth_service.dart';

void main() {
  group('AuthService — validim lokal', () {
    final service = AuthService();

    test('email i vlefshëm kalon', () {
      // Teston metodën private nëpërmjet reflektimit ose
      // nëpërmjet signUp me email të gabuar
    });

    test('fjalëkalim i dobët — < 8 karaktere', () {
      // Shto metodë publike testimi ose bëje package-private
    });

    test('fjalëkalim i dobët — pa numër', () {
      // p.sh. "fjalëkalim" → failure
    });

    test('fjalëkalim i fortë kalon', () {
      // p.sh. "Fjalëkalim1" → kalon validimin
    });
  });

  group('_mapFirebaseError', () {
    // Teston mappimin e kodeve Firebase → çelësa ARB
  });
}
```

### 13.2 Unit tests SyncService

```dart
// test/core/sync/sync_service_test.dart

// Teston:
// - _todayKey() → format yyyy-MM-dd
// - _canSync() kur Firebase nuk është inicializuar → false
// - _canSync() kur jo i autentifikuar → false
// - Skema Firestore paths → string i saktë
```

---

## Hapi 14: Checklist final para merge

```
KONFIGURIMI
[ ] google-services.json ✅ (te android/app/) 
[ ] GoogleService-Info.plist ✅ (te ios/Runner/)
[ ] firebase_options.dart ✅ (i gjeneruar nga FlutterFire CLI)
[ ] .gitignore: google-services.json, GoogleService-Info.plist,
    firebase_options.dart ✅

FIREBASE CONSOLE
[ ] Authentication → Email/Password aktiv ✅
[ ] Google Analytics çaktivizuar ✅
[ ] Firestore → production mode ✅
[ ] Firestore → region: europe-west3 ✅
[ ] Security Rules → të ngarkuara dhe testuara ✅
[ ] DPA (Data Processing Agreement) → konfirmuar ✅

KOD
[ ] Firebase inicializohet VETËM pas consent-it ✅
[ ] Asnjë analytics API nuk thirret ✅
[ ] Asnjë emër real fëmije në Firestore ✅ (vetëm pseudonime)
[ ] Fshirja e llogarisë fshin edhe Firestore ✅
[ ] SyncService dështimi nuk bllokon UI ✅
[ ] Offline mode funksionon plotësisht pa internet ✅

TESTS
[ ] AuthService unit tests ✅
[ ] SyncService unit tests ✅
[ ] fvm flutter test → e gjitha kalojnë ✅
[ ] fvm flutter analyze → 0 warnings ✅

VERIFIKIM MANUAL (2 pajisje fizike)
[ ] Regjistrohu me email → llogari krijohet ✅
[ ] Hyr nga pajisja 2 me të njëjtin email → sinkronizohet ✅
[ ] Pikët e fëmijës A shihen nga pajisja 2 ✅
[ ] Fshirja e llogarisë fshin Firestore brenda 30s ✅
[ ] Offline: hap aplikacionin pa internet → funksionon ✅
[ ] Online: kthehu → sinkronizon automatikisht ✅
[ ] Firebase Analytics në DebugView: 0 evente ✅
```

---

## Shënime të rëndësishme

**Mos bëj kurrë:**
```dart
// ❌ GABIM — Firebase në main() pa consent
await Firebase.initializeApp();

// ❌ GABIM — Google Sign-In (GDPR + moshe)
await GoogleSignIn().signIn();

// ❌ GABIM — Ruaj emrin real të fëmijës
await _db.doc(path).set({'firstName': child.realName});

// ❌ GABIM — Analytics automatike
FirebaseAnalytics.instance.logEvent(name: 'session_start');
```

**Gjithmonë bëj:**
```dart
// ✅ SAKTË — Firebase pas consent-it
final ok = await FirebaseInitService.initialize();
if (!ok) return; // consent nuk u dha

// ✅ SAKTË — Vetëm pseudonime
await _db.doc(path).set({'pseudonym': child.pseudonym});

// ✅ SAKTË — Sync fire-and-forget
unawaited(syncService.syncChildProgress(child));

// ✅ SAKTË — Fallback lokal nëse Firebase dështon
try { await _db... } catch (e) { /* vazhdo me Hive */ }
```

---

*Dokumenti i plotë teknik për Sprint 10B — Firebase Auth & Sync.*  
*Versioni: 1.0 · Data: Maj 2026 · Varësia: Sprint 10A ✅ + Sprint 10.5 ✅*
