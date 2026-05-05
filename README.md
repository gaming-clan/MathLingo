# MathLingo — AI Math Tutor

> **Shqip:** Aplikacioni shqiptar i matematikës që e kthen mësimin në lojë — me sfida ditore, tabela interaktive dhe zgjidhës ekuacionesh me AI.
>
> **English:** The Albanian math app that turns learning into a game — with daily challenges, interactive tables, and an AI-powered equation solver.

---

## Çfarë është MathLingo? / What is MathLingo?

**Shqip:**
MathLingo është një aplikacion mësimor matematike me gamifikim, ndërtuar me Flutter, i dizajnuar për nxënësit shqiptarë. Ai e transformon matematikën — një lëndë tradicionalisht të thatë — në një përvojë tërheqëse dhe ndërvepruese, nëpërmjet sfidave ditore, tabelave të operacioneve, ushtrimeve gjeometrike dhe një zgjidhësi ekuacionesh të fuqizuar nga AI — gjithçka e mbështjellë në një ndërfaqe të errët dhe futuriste të quajtur **Cosmic Logic**.

**English:**
MathLingo is a gamified math learning app built with Flutter, designed for Albanian students. It transforms the traditionally dry subject of mathematics into an engaging, interactive experience through daily challenges, operation tables, geometry puzzles, and an AI-powered exercise solver — all wrapped in a futuristic dark-themed UI called **Cosmic Logic**.

---

## Veçoritë / Features

### Sfida e Dites — Daily Challenge
**Shqip:** Një sfidë e re matematike çdo ditë. Përdoruesit zgjedhin një operacion (mbledhje, zbritje, shumëzim ose pjesëtim), u përgjigjen pyetjeve dhe fitojnë pikë. Progresi gjurmohet dhe rezultatet shfaqen me një ekran "Bravo!".

**English:** A fresh math challenge every day. Users pick an operation (addition, subtraction, multiplication, or division), answer questions under pressure, and earn a score. Results are displayed with a "Bravo!" results screen.

---

### Tabelat Matematikore — Math Tables
**Shqip:** Tabela interaktive operacionesh për të katër operacionet aritmetike. Përdoruesit zgjedhin një numër dhe praktikojnë tabelat e shumëzimit, pjesëtimit, mbledhjes ose zbritjes.

**English:** Interactive operation tables for all four arithmetic operations. Users select a number and practice multiplication, division, addition, or subtraction tables in a clean, readable layout.

---

### Gjeometria — Geometry Challenges
**Shqip:** Sfida të bazuara në figura gjeometrike që mbulojnë drejtkëndësha, trekëndësha dhe katrorë. Nxënësit llogaritsin sipërfaqen, perimetrin dhe të dhëna të tjera duke zgjedhur nga përgjigjet e mundshme.

**English:** Shape-based challenges covering rectangles, triangles, and squares. Users calculate area, perimeter, and other measurements by selecting from multiple choice answers.

---

### Gamify Exercise — AI Solver
**Shqip:** Një zgjidhës ushtrimesh i fuqizuar nga kamera. Nxënësit mund të fotografojnë një problem matematike të shkruar me dorë nga fletoret e tyre ose ta shkruajnë manualisht, dhe aplikacioni e analizon e zgjidh atë — me mbështetje të planifikuar për shpjegim hap-pas-hapi nëpërmjet ML Kit.

**English:** A camera-powered exercise solver. Students can photograph a handwritten math problem from their notebook or type it manually, and the app parses and solves it — with step-by-step explanation support planned via ML Kit integration.

---

## Stiva Teknologjike / Tech Stack

| Shtresa / Layer | Teknologjia / Technology |
|---|---|
| Framework | Flutter (Dart) |
| SDK minimal / Min SDK | Dart ^3.9.2 |
| Sistemi UI / UI System | Material Design 3 (dark theme) |
| Sistemi i Dizajnit / Design System | Cosmic Logic |
| Trajtimi i imazheve / Image Handling | image_picker ^1.0.0 |
| Platformat / Target Platforms | Android, iOS, Web, Windows, macOS |

---

## Sistemi i Dizajnit — Cosmic Logic / Design System — Cosmic Logic

**Shqip:**
MathLingo përdor një sistem dizajni të personalizuar të quajtur **Cosmic Logic**, ndërtuar rreth:
- **Paleta e ngjyrave:** Sfond Deep Space-Indigo (`#101126`), Vjollcë Neon si ngjyrë primare (`#BC13FE`), Cyan Neon për progresin (`#00EEFC`), Magenta e ndezur për shpërblimet (`#D700C1`)
- **Tipografia:** Space Grotesk (titujt) + Lexend (teksti i trupit dhe etiketat)
- **Stili:** Glassmorphism + Minimalizëm Futuristik me efekte blur, karta transparente dhe efekte neon glow

**English:**
MathLingo uses a custom design system called **Cosmic Logic**, built around:
- **Color palette:** Deep Space-Indigo background (`#101126`), Neon Electric Purple primary (`#BC13FE`), Neon Cyan for progress (`#00EEFC`), Vibrant Magenta for rewards (`#D700C1`)
- **Typography:** Space Grotesk (headlines) + Lexend (body/labels)
- **Style:** Glassmorphism + Futuristic Minimalism with heavy backdrop blurs, translucent cards, and neon glow effects

---

## Fillimi / Getting Started

### Kërkesat paraprake / Prerequisites
- Flutter SDK `^3.9.2`
- Dart SDK `^3.9.2`
- Android Studio ose VS Code me shtojcën Flutter / Android Studio or VS Code with Flutter extension

### Instalimi / Installation

```bash
# Klono repositorin / Clone the repository
git clone https://github.com/yourusername/mathlingo.git

# Navigo te dosja e projektit / Navigate to project directory
cd mathlingo

# Instalo varësitë / Install dependencies
flutter pub get

# Ekzekuto aplikacionin / Run the app
flutter run
```

### Gjenero ikonat e launcher / Generate launcher icons
```bash
dart run flutter_launcher_icons
```

---

## Struktura e Projektit / Project Structure

```
lib/
├── main.dart              # Pika hyrëse, Dashboard, ekranet e Sfidave / App entry point, Dashboard, Challenge screens
├── colors.dart            # Konstantet e ngjyrave Cosmic Logic / Cosmic Logic color constants
├── gamify_exercise.dart   # Ekrani i zgjidhësit AI / AI-powered exercise solver screen
├── simple_tables.dart     # Ekrani i tabelave matematikore / Math operation tables screen
├── responsive.dart        # Utilitetet e paraqitjes adaptive / Adaptive layout utilities
└── stitch_screens.dart    # Ndihmuesi i ekraneve / Screen stitching helper

assets/
└── icons/
    └── stich_icon.png     # Ikona e launcher / App launcher icon
```

---

## Rruga Përpara / Roadmap

- [ ] Integrimi i ML Kit për OCR real mbi ekuacionet e shkruara me dorë / ML Kit integration for real OCR on handwritten equations
- [ ] Autentifikimi i përdoruesit dhe ruajtja e progresit / User authentication and progress persistence
- [ ] Sistemi i streakave dhe insignieve të shpërblimit / Streak system and reward badges
- [ ] Tabelë liderësh për konkurrencë në klasë / Leaderboard for classroom competition
- [ ] Përshtatje me kurrikulën shqiptare (Klasat 6–12) / Albanian curriculum alignment (Grade 6–12)
- [ ] Mbështetje offline / Offline support

---

## Kontributi / Contributing

**Shqip:** Kërkesat pull janë të mirëpritura. Për ndryshime të mëdha, ju lutemi hapni fillimisht një problem (issue) për të diskutuar atë që dëshironi të ndryshoni.

**English:** Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

---

## Licenca / License

**Shqip:** Ky projekt është i licencuar nën **GNU General Public License v3.0**. Kjo do të thotë se mund ta përdorni, modifikoni dhe shpërndani lirisht këtë software, me kusht që çdo version i modifikuar të mbetet gjithashtu me kod të hapur dhe i licencuar nën të njëjtën licencë.

**English:** This project is licensed under the **GNU General Public License v3.0**. You are free to use, modify, and distribute this software, provided that any modified version also remains open source and licensed under the same license.

Shiko / See [`LICENSE`](LICENSE) për detaje të plota / for full details.

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

---

*MathLingo — Mëso. Sfidohu. Triumfo.*
