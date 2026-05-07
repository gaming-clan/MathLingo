# 🤖 Udhëzime për Copilot / AI Assistant

## 1. Konteksti i Projektit
- **Emri:** MathLingo.
- **Teknologjia:** Flutter 3.41.9, Dart 3.9.2.
- **Arkitektura:** Feature-based (në proces migrimi nga Monolith).
- **Gjuha:** Të gjitha string-et e dukshme për përdoruesin DUHET të jenë në **Shqip**.

## 2. Rregullat e Kodimit
- **Null Safety:** Gjithmonë përdor null-safety strikte.
- **State Management:** Prioritizo `setState` për animacione vizuale, por përdor **Riverpod** për logjikën e biznesit dhe persistencën (Sprint 3+).
- **Modularizimi:** Mos shto kod të ri në `main.dart`. Krijo skedarë të ndarë në folderat përkatës (`features/`, `shared/`, `core/`).
- **Responsiviteti:** Përdor klasën `AdaptiveLayout` për çdo dimension apo padding. Mos përdor vlera statike (hardcoded) për madhësitë e ekraneve.

## 3. Logjika Matematikore (Strikte)
- **Pjesëtimi:** Gjithmonë sigurohu që `num1 % num2 == 0`. Mos përdor `~/` pa kontrolluar mbetjen.
- **Zbritja:** Sigurohu që `num1 >= num2` për të shmangur rezultatet negative te fillestarët.
- **Generatorët:** Logjika e gjenerimit të pyetjeve duhet të jetë në klasa pure Dart (Domain Layer), jo brenda Widget-eve.

## 4. UI Patterns
- Përdor gjithmonë `GlassPanel` për kontejnerët e kartave.
- Përdor `CosmicButton` për veprimet kryesore.
- SnackBars duhet të jenë `floating: true` me margin mbi BottomNav.