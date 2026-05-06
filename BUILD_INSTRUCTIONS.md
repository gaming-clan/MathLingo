# MathLingo - Build Instructions & Troubleshooting

## Environment Setup

### Prerequisites
- Flutter SDK 3.41.9 (or latest stable)
- Android SDK Level 35
- Java JDK 11+
- Gradle 8.12+

### Current Environment Status
✅ Flutter 3.41.9 installed  
✅ Android SDK 35.0.0 configured  
✅ Java 11 available  
✅ Dart 3.11.5 ready  
✅ Code analysis passed  

❌ AAPT2 binary architecture mismatch (ARM64 system, x86_64 tools)

---

## Quick Start Build Options

### Option 1: Fix Build Environment (Recommended for ARM64 Systems)

**For Debian/Ubuntu ARM64:**

```bash
# Install 32-bit libraries for x86-64 support
sudo apt-get update
sudo apt-get install -y libc6:i386 libstdc++6:i386

# Or install full multilib support
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install -y libc6:i386 libstdc++6:i386 gcc-multilib g++-multilib

# Verify installation
file /home/dario/Android/Sdk/build-tools/35.0.0/aapt2
```

**After installing libraries:**

```bash
export PATH="/home/dario/flutter/bin:$PATH"
cd /home/dario/MathLingo
flutter clean
flutter build apk --debug
```

**Expected output:**
```
Build complete! (Took 2m 30s)
Built /home/dario/MathLingo/build/app/outputs/flutter-apk/app-debug.apk
```

---

### Option 2: Docker Build (Works on Any System)

**Create Dockerfile:**

```dockerfile
FROM ubuntu:22.04

# Set environment
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="${PATH}:/home/builder/flutter/bin:/home/builder/Android/Sdk/platform-tools:/home/builder/Android/Sdk/tools"

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl git unzip openjdk-11-jdk-headless \
    android-sdk android-sdk-build-tools libncurses5 libpulse0 \
    && rm -rf /var/lib/apt/lists/*

# Create user
RUN useradd -m -s /bin/bash builder

# Switch to builder user
USER builder
WORKDIR /home/builder

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git --branch stable
RUN flutter config --no-analytics

# Copy project
COPY --chown=builder:builder . /home/builder/mathlingo
WORKDIR /home/builder/mathlingo

# Build APK
RUN flutter pub get
RUN flutter build apk --debug

# Output
CMD ["ls", "-lah", "build/app/outputs/flutter-apk/"]
```

**Build using Docker:**

```bash
cd /home/dario/MathLingo
docker build -t mathlingo-builder .
docker run --rm -v $(pwd)/build:/home/builder/mathlingo/build mathlingo-builder
ls -lah build/app/outputs/flutter-apk/app-debug.apk
```

---

### Option 3: GitHub Actions Cloud Build (No Local Build Needed)

**Create `.github/workflows/build-debug-apk.yml`:**

```yaml
name: Build Debug APK

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.41.9'

    - name: Get dependencies
      run: flutter pub get

    - name: Build APK
      run: flutter build apk --debug

    - name: Upload APK
      uses: actions/upload-artifact@v3
      with:
        name: app-debug
        path: build/app/outputs/flutter-apk/app-debug.apk

    - name: Create Release
      uses: softprops/action-gh-release@v1
      if: startsWith(github.ref, 'refs/tags/')
      with:
        files: build/app/outputs/flutter-apk/app-debug.apk
```

**Push to GitHub:**
```bash
git add .github/workflows/
git commit -m "Add GitHub Actions APK build workflow"
git push origin main
```

Then download the APK from the GitHub Actions artifacts.

---

### Option 4: Remote SSH Build (Build on x86_64 Machine)

**On x86_64 Ubuntu machine with Flutter installed:**

```bash
# SSH into remote machine
ssh user@remote-machine

# Clone project
git clone https://github.com/your-repo/MathLingo.git
cd MathLingo

# Build APK
flutter clean
flutter build apk --debug

# Download APK locally
scp user@remote-machine:~/MathLingo/build/app/outputs/flutter-apk/app-debug.apk ./
```

---

## Build Configurations

### Debug Build
```bash
export PATH="/home/dario/flutter/bin:$PATH"
cd /home/dario/MathLingo
flutter build apk --debug
```
- Unoptimized, larger file size (~50MB)
- Faster build time
- Includes debug symbols
- Can be debugged with breakpoints

**Output:** `build/app/outputs/flutter-apk/app-debug.apk`

### Release Build
```bash
export PATH="/home/dario/flutter/bin:$PATH"
cd /home/dario/MathLingo
flutter build apk --release
```
- Optimized, smaller file size (~20MB)
- Slower build time
- No debug symbols
- Suitable for distribution
- Requires signing certificate

**Output:** `build/app/outputs/flutter-apk/app-release.apk`

### App Bundle (Google Play)
```bash
export PATH="/home/dario/flutter/bin:$PATH"
cd /home/dario/MathLingo
flutter build appbundle --release
```
- Optimized for Google Play
- Smaller download sizes per device
- Requires signing certificate

**Output:** `build/app/outputs/bundle/release/app-release.aab`

---

## Troubleshooting

### Problem: AAPT2 Architecture Mismatch
```
Error: x86_64-binfmt-P: Could not open '/lib64/ld-linux-x86-64.so.2'
```

**Solutions:**
1. Install x86-64 libraries (Option 1 above)
2. Use Docker build (Option 2)
3. Use GitHub Actions (Option 3)
4. Build on x86_64 machine (Option 4)

### Problem: Out of Memory during Build
```
Error: Java heap space
```

**Solution:**
```bash
# Modify gradle.properties
echo "org.gradle.jvmargs=-Xmx16G" >> android/gradle.properties

# Then rebuild
flutter clean
flutter build apk --debug
```

### Problem: Gradle Daemon Issues
```
Error: Gradle task failed
```

**Solution:**
```bash
# Disable Gradle daemon
echo "org.gradle.daemon=false" >> android/gradle.properties

# Clean and rebuild
flutter clean
flutter build apk --debug
```

### Problem: Dependency Resolution Failure
```
Error: Failed to resolve all files for configuration
```

**Solution:**
```bash
# Update packages
flutter pub upgrade

# Get fresh dependencies
flutter pub get

# Clean build
flutter clean
flutter build apk --debug
```

---

## APK Testing & Installation

### Install Debug APK on Device
```bash
# Via ADB
adb install build/app/outputs/flutter-apk/app-debug.apk

# Via Android Studio
open build/app/outputs/flutter-apk/app-debug.apk

# Via Android Emulator
emulator -avd <emulator-name>
adb install build/app/outputs/flutter-apk/app-debug.apk
```

### Verify APK
```bash
# Check APK file
ls -lh build/app/outputs/flutter-apk/app-debug.apk

# Extract and inspect
unzip -l build/app/outputs/flutter-apk/app-debug.apk | head -20

# Check APK certificate
jarsigner -verify -verbose build/app/outputs/flutter-apk/app-debug.apk
```

---

## Production Build Checklist

Before releasing to Google Play:

- [ ] Update application ID (currently: com.example.mathlingo)
- [ ] Set version number (currently: 1.0.0+1)
- [ ] Add launcher icon
- [ ] Configure app signing certificate
- [ ] Test on multiple Android versions
- [ ] Test on various screen sizes
- [ ] Enable ProGuard/R8 code shrinking
- [ ] Set proper permissions in AndroidManifest.xml
- [ ] Create privacy policy URL
- [ ] Create app description and screenshots
- [ ] Configure in-app purchases (if needed)

### Create Release Configuration

**Update pubspec.yaml:**
```yaml
version: 1.0.0+1  # Change to 1.0.0+2, 1.0.1+3, etc.
```

**Create keystore for signing:**
```bash
keytool -genkey -v -keystore ~/.android/math_lingo_key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias math_lingo_release
```

**Configure signing in build.gradle.kts:**
```kotlin
signingConfigs {
    release {
        storeFile = file("~/.android/math_lingo_key.jks")
        storePassword = "your_keystore_password"
        keyAlias = "math_lingo_release"
        keyPassword = "your_key_password"
    }
}

buildTypes {
    release {
        signingConfig = signingConfigs.release
    }
}
```

---

## Continuous Integration Setup

### GitHub Actions Workflow
File: `.github/workflows/ci.yml`

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter analyze

  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test

  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter build apk --debug
      - uses: actions/upload-artifact@v3
        with:
          name: app-debug
          path: build/app/outputs/flutter-apk/app-debug.apk
```

---

## Quick Reference

### Essential Commands
```bash
# Setup
export PATH="/home/dario/flutter/bin:$PATH"
cd /home/dario/MathLingo

# Development
flutter run                          # Run on connected device
flutter run -d chrome               # Run in browser
flutter pub get                     # Get dependencies
flutter pub upgrade                 # Upgrade dependencies

# Analysis & Testing
flutter analyze                     # Static analysis
flutter test                        # Run tests
flutter test --coverage            # Coverage report

# Building
flutter build apk --debug           # Debug APK
flutter build apk --release         # Release APK
flutter build appbundle --release   # App Bundle
flutter build ios                   # iOS app
flutter build web                   # Web app
flutter build linux                 # Linux app
flutter build windows               # Windows app
flutter build macos                 # macOS app

# Maintenance
flutter clean                       # Clean build artifacts
flutter upgrade                     # Update Flutter SDK
flutter doctor                      # Check environment
```

---

## File Locations

```
Project Root:     /home/dario/MathLingo
Flutter SDK:      /home/dario/flutter
Android SDK:      /home/dario/Android/Sdk
Build Output:     /home/dario/MathLingo/build/app/outputs/flutter-apk/
Debug APK:        build/app/outputs/flutter-apk/app-debug.apk
Release APK:      build/app/outputs/flutter-apk/app-release.apk
App Bundle:       build/app/outputs/bundle/release/app-release.aab
```

---

## Support & Resources

- Flutter Documentation: https://docs.flutter.dev
- Android Development: https://developer.android.com
- Google Play Console: https://play.google.com/console
- Flutter Community: https://flutter.dev/community
- Dart Documentation: https://dart.dev

---

**Last Updated:** May 6, 2026  
**Status:** Ready for production build (with environment fix)
