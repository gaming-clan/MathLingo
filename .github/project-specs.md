# ⚙️ Specifikimet e Projektit

## 1. Mjedisi i Zhvillimit
- **Flutter Version:** `3.41.9` (Kyçur me FVM).
- **Dart SDK:** `^3.9.2`.
- **Android Target SDK:** 35.
- **Android Min SDK:** 26.
- **Namespace:** `com.mathlingo.app`.

## 2. Varësitë Kryesore (Installed)
- `cupertino_icons: ^1.0.8`
- `image_picker: ^1.0.0`
- `image: ^4.2.0` — preprocesim OCR (grayscale, crop, threshold)
- `google_mlkit_text_recognition: ^0.15.1` — OCR real (printed text; handwriting kufizim i njohur)
- `flutter_localizations` (SDK) + `intl: any` — lokalizim shqip (ARB files)
- `flutter_riverpod: ^2.6.1` — State Management (Sprint 4+)
- `hive: ^2.2.3` + `hive_flutter: ^1.1.0` — persistencë lokale (Sprint 3+)
- `flutter_launcher_icons: ^0.13.1` (dev)

## 3. Platformat & Mbështetja
- **Mobile:** Android & iOS (Fokus parësor).
- **Web/Desktop:** Mbështetje bazë (Responsive layout).

## 4. Rregullat e Git Workflow
- **Branch-i kryesor:** `main` (Vetëm për release).
- **Branch-i i zhvillimit:** `develop` (Integration branch).
- **Feature Branches:** `feature/emri-i-feature` (Nisur nga `develop`).
- **Bugfix Branches:** `bugfix/pershkrimi-i-bug` (Nisur nga `develop`).
- **Commits:** Convention Commits (`feat:`, `fix:`, `refactor:`, `docs:`).