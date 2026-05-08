# Software Specification Document (SSD)
## MathLingo — Aplikacioni i Mësimit Interaktiv të Matematikës

---

| Fusha | Detajet |
|---|---|
| **Versioni i Dokumentit** | 1.0.0 |
| **Data** | 07 Maj 2026 |
| **Autori** | Ekipi Teknik — MathLingo |
| **Statusi** | Draft i Finalizuar |
| **Platforma** | Flutter (Android, iOS, Web, Windows, macOS, Linux) |
| **Gjuha e UI** | Shqip |

---

## Tabela e Përmbajtjes

1. [Prezantimi](#1-prezantimi)
2. [Qëllimi dhe Fusha e Dokumentit](#2-qëllimi-dhe-fusha-e-dokumentit)
3. [Arkitektura e Sistemit](#3-arkitektura-e-sistemit)
4. [Specifikimet Funksionale](#4-specifikimet-funksionale)
5. [UI/UX Design](#5-uiux-design)
6. [Specifikimet Jo-Funksionale](#6-specifikimet-jo-funksionale)
7. [Struktura e të Dhënave](#7-struktura-e-të-dhënave)
8. [Menaxhimi i Navigimit](#8-menaxhimi-i-navigimit)
9. [Testimi](#9-testimi)
10. [Roadmap-i Teknik](#10-roadmap-i-teknik)
11. [Anekset](#11-anekset)

---

## 1. Prezantimi

### 1.1 Qëllimi i Aplikacionit

**MathLingo** është një aplikacion edukativ i ndërtuar me Flutter, i dedikuar për mësimin interaktiv dhe argëtues të matematikës bazë. Aplikacioni synon të eliminojë barrierat emocionale ndaj matematikës duke e shndërruar mësimin në një eksperiencë lojë-bazuar (**gamified learning**), të pasuruar me sfida, vizualizime dhe një mascot fëmijëror të dashur — **Stitch**.

### 1.2 Audienca e Synuar

| Segmenti | Mosha | Niveli |
|---|---|---|
| Nxënës fillorë | 6–10 vjeç | Matematikë bazë (operacionet aritmetike) |
| Nxënës të mesëm të ulët | 10–14 vjeç | Gjeometri hapësinore dhe algjebër bazë |
| Mësues dhe prindër | 25–50 vjeç | Monitorim progresi |

### 1.3 Gjuha dhe Lokalizimi

- **Gjuha primare e ndërfaqes:** Shqip (Albanian)
- Të gjitha etiketat, mesazhet e feedback-ut, titujt dhe udhëzimet janë në gjuhën shqipe
- Terminologjia matematikore ndjek kurrikulën shqiptare të arsimit parauniversitar

### 1.4 Platformat e Mbështetura

| Platforma | Statusi |
|---|---|
| Android | ✅ Mbështetur plotësisht |
| iOS | ✅ Mbështetur plotësisht |
| Web (PWA) | ✅ Mbështetur |
| Windows | ✅ Mbështetur |
| macOS | ✅ Mbështetur |
| Linux | ✅ Mbështetur |

---

## 2. Qëllimi dhe Fusha e Dokumentit

Ky dokument shërben si referencë teknike dhe funksionale për:

- **Zhvilluesit e softuerit** — detaje arkitekturore dhe API interne
- **Dizajnerët UI/UX** — specifikimet vizuale dhe sistemin e temës
- **Product Managerët** — modulet funksionale dhe roadmap-in
- **QA Inxhinierët** — kriteret e pranimit dhe strategjitë e testimit

---

## 3. Arkitektura e Sistemit

### 3.1 Stack Teknologjik

| Komponenti | Teknologjia | Versioni |
|---|---|---|
| Framework | Flutter SDK | `^3.41` (env Dart `^3.9.2`) |
| Gjuha e Programimit | Dart | `^3.9.2` |
| Design System | Material Design 3 | Aktiv (`useMaterial3: true`) |
| Menaxhimi i Gjendjes | `setState` / `StatefulWidget` | v1.0 (native Flutter) |
| Navigimi | `Navigator 1.0` / `MaterialPageRoute` | Native Flutter |
| Imazhet/Kamera | `image_picker` | `^1.0.0` |
| Ikonat | Cupertino Icons | `^1.0.8` |
| Lançimi i Ikonave | `flutter_launcher_icons` | `^0.13.1` |

### 3.2 Modeli Arkitekturor

```
┌─────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                      │
│  DashboardScreen │ ChallengeScreen │ GeometryChallenge       │
│  ResultsScreen   │ GamifyExercise  │ OperationTables         │
├─────────────────────────────────────────────────────────────┤
│                     WIDGET LIBRARY                          │
│  GlassPanel │ CosmicButton │ _MascotFrame │ _NeonChip        │
│  _AnswerButton │ _CosmicTopBar │ _CosmicBottomNav            │
├─────────────────────────────────────────────────────────────┤
│                     BUSINESS LOGIC                          │
│  MathQuestion generator │ GeometryQuestion generator        │
│  Score calculator │ Expression parser (Gamify)              │
├─────────────────────────────────────────────────────────────┤
│                     DATA MODELS                             │
│  MathQuestion │ GeometryQuestion │ Operation (enum)          │
│  GeometryShape (enum)                                       │
├─────────────────────────────────────────────────────────────┤
│                     DESIGN SYSTEM                           │
│  CosmicColors │ AdaptiveLayout │ ResponsivePage              │
└─────────────────────────────────────────────────────────────┘
```

### 3.3 Struktura e Skedarëve

```
lib/
├── main.dart              # Entry point, DashboardScreen, ChallengeScreen,
│                          # GeometryChallengeScreen, ResultsScreen,
│                          # dhe të gjitha widget-et primitive të UI
├── colors.dart            # CosmicColors — paleta globale e ngjyrave
├── responsive.dart        # AdaptiveLayout, ResponsivePage — responsiviteti
├── gamify_exercise.dart   # GamifyExerciseScreen — moduli i kamerës/ekuacionit
└── simple_tables.dart     # OperationTablesScreen — tabelat matematikore

assets/
└── icons/
    └── stich_icon.png     # Imazhi i mascot-it Stitch
```

### 3.4 Menaxhimi i Gjendjes (State Management)

Versioni aktual (v1.0) përdor **setState** natively:

| Ekrani | Gjendja e Menaxhuar |
|---|---|
| `ChallengeScreen` | Pyetja aktuale, skor, progres, përgjigja e zgjedhur, feedback |
| `GeometryChallengeScreen` | Pyetja gjeometrike, skor, progres, forma, matjet |
| `GamifyExerciseScreen` | Imazhi i zgjedhur, teksti i njohur, zgjidhja, statusi i procesimit |
| `OperationTablesScreen` | Tabela e zgjedhur (1–12), operacioni aktiv |
| `DashboardScreen` | Indeksi i tabs aktive (`_selectedIndex`) |

---

## 4. Specifikimet Funksionale

### 4.1 Dashboard Kryesor (`DashboardScreen`)

**Përshkrimi:** Ekrani kryesor i navigimit që shfaq modulet e disponueshme dhe progresin e nxënësit.

**Funksionalitetet:**

- **Tab Navigation** me 4 seksione:
  - `Sfida e Ditës` (Dashboard)
  - `Mësime` (Lessons)
  - `Tabelat` (Tables)
  - `Progresi` (Progress)
- **Responsive Grid Layout:**
  - Ekrane ≥ 900px: Layout 2-kolonësh me karta side-by-side
  - Ekrane < 900px: Layout me stack vertikal
- **Kartat e Disponueshme:**
  - `_GamifyCard` — Hyrja në modulin e kamerës
  - `_DailyChallengeCard` — Sfida gjeometrike e ditës me Stitch mascot
  - `_QuickActionsCard` — Shortcuts për 4 operacionet (+, −, ×, ÷)
  - `_ProgressModuleCard` — Shfaqja e progresit me progress bar-a

**Kriteret e Pranimit:**

- [ ] Dashboard ngarkohet në < 300ms
- [ ] Navigimi ndërmjet tabs është pa animacion glitch-e
- [ ] Layout-i adaptohet automatikisht sipas gjerësisë së ekranit

---

### 4.2 Moduli "Sfida e Ditës" (`ChallengeScreen`)

**Përshkrimi:** Moduli qendror i sfidave aritmetike me pyetje multiple-choice të gjeneruara dinamikisht.

#### 4.2.1 Operacionet e Mbështetura

| Operacioni | Simboli UI | Ikona Material |
|---|---|---|
| Mbledhje | `+` | `Icons.add` |
| Zbritje | `−` | `Icons.remove` |
| Shumëzim | `×` | `Icons.close` |
| Pjesëtim | `÷` | `Icons.percent` |

#### 4.2.2 Nivelet e Vështirësisë

| Niveli | Diapazoni i Numrave | Shumëzim/Pjesëtim (max) |
|---|---|---|
| Niveli 1 (Lehtë) | 1 – 10 | 1 – 5 |
| Niveli 2 (Mesatar) | 1 – 20 | 1 – 10 |
| Niveli 3 (Vështirë) | 1 – 50 | 1 – 12 |

#### 4.2.3 Logjika e Gjenerimit të Pyetjeve

- **Mbledhje:** `num1 ∈ [1, maxNumber]`, `num2 ∈ [1, maxNumber]`, `answer = num1 + num2`
- **Zbritje:** `num1 ∈ [2, maxNumber]`, `num2 ∈ [1, num1-1]` *(garantohet rezultat pozitiv)*
- **Shumëzim:** `num1, num2 ∈ [1, multMax]`
- **Pjesëtim:** Gjenerohet `answer` dhe `num2` fillimisht → `num1 = answer × num2` *(garantohet pjesëtim i saktë pa mbetje)*

#### 4.2.4 Opsionet e Zgjigjës

- Gjithmonë **4 opsione** per pyetje
- 1 përgjigje e saktë + 3 shpërqendrime *(offset random ±6 nga përgjigja e saktë)*
- Radhitja e opsioneve është e randomizuar
- Feedback vizual i menjëhershëm:
  - ✅ Saktë → ngjyra `secondaryContainer` (cyan)
  - ❌ Gabim → ngjyra `error` (e kuqe)

#### 4.2.5 Sistemin e Pikëve dhe Saktësisë

| Operacioni | Pikë per Përgjigje Saktë |
|---|---|
| Operacionet Aritmetike | +10 pikë |
| Gjeometria | +15 pikë |

- Saktësia llogaritet si: `accuracy = (correct / sessionLength) × 100`
- Sesioni default: **5 pyetje** per sesion
- Pas mbarimit të sesionit → `ResultsScreen`

---

### 4.3 Moduli "Gjeometria Hapësinore" (`GeometryChallengeScreen`)

**Përshkrimi:** Sfida gjeometrike interaktive me vizualizime të formave 2D të vizatuara me `CustomPainter`.

#### 4.3.1 Format e Mbështetura

| Forma | Llogaritja | Formula |
|---|---|---|
| Drejtkëndësh | Sipërfaqja | `S = gjerësia × lartësia` |
| Trekëndësh | Sipërfaqja | `S = (baza × lartësia) / 2` |
| Katror | Perimetri | `P = brinja × 4` |

#### 4.3.2 Vizualizimi me CustomPainter

- Forma vizatohet në kohë reale mbi `Canvas` Flutter
- Dimensionet janë proporcionale me vlerat e pyetjes
- Ikonat Material Design (`Icons.crop_square`, `Icons.change_history`, `Icons.square_outlined`) shfaqen si overlay me opacitet 20%
- Lartësia e canvas: 260px (tablet), 210px (celular)

#### 4.3.3 Parametrat e Gjenerimit

- **Drejtkëndësh:** `width ∈ [3, 9]`, `height ∈ [2, 7]`
- **Trekëndësh:** `width = (rand[3,7]) × 2` *(çift për rezultat të saktë)*, `height ∈ [2, 7]`
- **Katror:** `brinja ∈ [3, 10]`

---

### 4.4 Moduli "Tabelat Matematikore" (`OperationTablesScreen`)

**Përshkrimi:** Ekran referencial interaktiv për të gjitha tabelat matematikore nga 1 deri 12.

**Funksionalitetet:**

- **4 Tab-e** të ndara me `TabBar`:
  - `Mbledhje +`
  - `Zbritje −`
  - `Shumëzim ×`
  - `Pjesëtim ÷`
- **Zgjedhësi i tabelës:** ListView horizontal me butona 1–12 të kolorizuara sipas operacionit
- **Grid View responsiv** i rezultateve:
  - ≥ 1000px → 5 kolona
  - ≥ 700px → 4 kolona
  - < 700px → 3 kolona
- Ngjyrat sipas operacionit:
  - Mbledhje → `Colors.green`
  - Zbritje → `Colors.red`
  - Shumëzim → `Colors.orange`
  - Pjesëtim → `Colors.blue`
- Interaktiviteti **"Tap-to-reveal":** Çelësi vizual (butoni i zgjedhur ngjyros me ngjyrën e operacionit, i pa zgjedhur mbetet `surfaceHighest`)

---

### 4.5 Moduli "Gamify" — Zgjidhja e Ekuacioneve (`GamifyExerciseScreen`)

**Përshkrimi:** Moduli inovativ që lejon nxënësin të fotografojë ose shkruajë ekuacionin dhe të marrë një zgjidhje argëtuese.

#### 4.5.1 Metodat e Hyrjes

| Metoda | Implementimi | Statusi |
|---|---|---|
| Kamera | `ImagePicker(source: ImageSource.camera)` | ✅ Aktiv |
| Galeria | `ImagePicker(source: ImageSource.gallery)` | ✅ Aktiv |
| Tekst manual | `TextEditingController` | ✅ Aktiv |
| OCR/ML Kit | `_processImage()` — TODO | 🔄 Placeholder |

#### 4.5.2 Parseri i Ekuacioneve (`_generateFunSolution`)

Parseri aktual mbështet shprehjet e thjeshta binare:

| Operatori | Formatet e Mbështetura |
|---|---|
| Mbledhje | `num1 + num2` |
| Zbritje | `num1 - num2` |
| Shumëzim | `num1 * num2`, `num1 × num2`, `num1 x num2` |
| Pjesëtim | `num1 / num2`, `num1 ÷ num2` |

**Pre-procesimi i tekstit shqip:**
- Heq fjalë kyçe: `zgjidh`, `llogarit`, `sa është`, `janë`
- Normalizon të vogla: `.toLowerCase().trim()`

#### 4.5.3 Formati i Zgjidhjes Argëtuese

Çdo zgjidhje e gjeneruar përmban:
- Titull dekorativ me emoji
- **Hapi I** — Kontekst narrativ (ballona, mollë, kube, pica)
- **Hapi II** — Veprimet me numrat
- **Përgjigja Finale** — Rezultati numerik
- **Triku Argëtues** — Analogji mënduese

#### 4.5.4 Responsiviteti i Gamify

- ≥ 760px: Layout 2-kolonësh (Input | Preview)
- < 760px: Layout vertikal i grumbulluar

---

### 4.6 Ekrani i Rezultateve (`ResultsScreen`)

- Shfaqet pas çdo sesioni të përfunduar
- Tregon: Pikët totale, Saktësinë (%)
- Mascot Stitch në modalitet festiv (`celebratory: true`)
- Butoni "Vazhdo" → kthehet në `DashboardScreen` duke fshirë stack-un e navigimit

---

### 4.7 Ekrani "Mësimet" (`_LessonsPage`)

- Shfaq shembull ekuacioni statik: `5 + 3 = 8`
- Maskot Stitch i vendosur si overlay
- **Mjetet e Llogaritjes** — karta dekorative: `√x`, `π`, `x²`, `💡`
- Butoni "Vazhdo" → çon në `GeometryChallengeScreen`

---

### 4.8 Ekrani "Progresi" (`_ProgressPage`)

- Shfaqet brenda `DashboardScreen` si tab
- Progress bar-a animuar për modulet:
  - `Algjebra Abstrakte` — 85% (ngjyrë cyan)
  - `Analiza Matematike` — 42% (ngjyrë magenta)
- Skor-karta me ikonat `workspace_premium` dhe `my_location`

---

## 5. UI/UX Design

### 5.1 Tema "Cosmic Dark"

Aplikacioni përdor një temë të errët kozmike me gradiente ngjyrash që evokojnë hapësirën e pafund, duke krijuar një ambiente misterioze dhe motivuese për nxënësit.

#### 5.1.1 Paleta e Ngjyrave (CosmicColors)

| Token | Hex | Roli |
|---|---|---|
| `background` | `#101126` | Sfond kryesor — blu shumë e errët |
| `surface` | `#1D1E33` | Karta dhe panele |
| `surfaceLow` | `#191A2F` | Raste të vendosura thellë |
| `surfaceHigh` | `#27283E` | Elementi mbi surface |
| `surfaceHighest` | `#32334A` | Elementi me kontrast maksimal |
| `primary` | `#F3D6FF` | Tekst kryesor lavender |
| `primaryContainer` | `#BC13FE` | Akcentet kryesore — magenta neon |
| `secondary` | `#D3FBFF` | Tekst dytësor cyan |
| `secondaryContainer` | `#00EEFC` | Akcentet dytësore — cyan neon |
| `tertiary` | `#FFACE8` | Akcentet terciare — rozë |
| `tertiaryContainer` | `#D700C1` | Gradient button — magenta e errët |
| `onSurface` | `#FFFFFF` | Tekst mbi surface |
| `onSurfaceVariant` | `#EEEBFF` | Tekst dytësor mbi surface |
| `outline` | `#B9A7BC` | Kufij të dobët |
| `error` | `#FFB4AB` | Gabime dhe feedback negativ |

#### 5.1.2 Tipografia (Material 3 TextTheme)

| Stili | Madhësia | Pesha | Përdorimi |
|---|---|---|---|
| `headlineLarge` | 32px | W800 | Titujt kryesorë (`Mirësevini!`) |
| `headlineMedium` | 24px | W700 | Titujt e moduleve |
| `bodyMedium` | 16px | W400 | Tekstet përshkruese |
| `labelLarge` | 14px | W700 | Etiketat e seksioneve |

---

### 5.2 Glassmorphism — `GlassPanel`

Komponenti `GlassPanel` zbaton efektin e Glassmorphism nëpërmjet:

```dart
decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(32),
  border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
  gradient: LinearGradient(
    colors: [
      Colors.white.withValues(alpha: 0.08),
      CosmicColors.surface.withValues(alpha: 0.68),
      Colors.white.withValues(alpha: 0.02),
    ],
  ),
  boxShadow: [BoxShadow(
    color: CosmicColors.primaryContainer.withValues(alpha: 0.12),
    blurRadius: 28, offset: Offset(0, 12),
  )],
)
```

**Karakteristikat vizuale:**
- Border transparency: 12% e bardhë
- Background gradient: nga 8% → 68% → 2% e bardhë mbi `surface`
- `borderRadius: 32` — kënde shumë të rrumbullakosura
- Hija me ngjyrën e `primaryContainer` (magenta neon)
- Aplikohet në të gjitha kartat kryesore

---

### 5.3 Mascot "Stitch" (`_MascotFrame`)

**Stitch** është karakteri mascot i aplikacionit, i ndërtuar si widget Flutter nativë (pa asete PNG të jashtme sipas dokumentit kryesor):

- **Modaliteti Normal:** Shfaqet në `_DailyChallengeCard` dhe ekranet e mësimeve
- **Modaliteti Festiv (`celebratory: true`):** Shfaqet në `ResultsScreen` pas suksesin e sfidës
- Madhësia adaptohet: 170px (thumbnail), 220px (kartë), 260–280px (ekran i plotë)
- Pozicionimi: absolutisht i vendosur me `Positioned` brenda `Stack`-ut të kartave

---

### 5.4 Butoni Kozmik (`CosmicButton`)

Butoni kryesor CTA i aplikacionit me gradiente neon:

- **Gradient:** `primaryContainer (#BC13FE)` → `tertiaryContainer (#D700C1)`
- **Forma:** `StadiumBorder` — plotësisht ovale
- **Hija:** 38% e opak, blur 24px
- **Padding:** 16px vertikal, 24px horizontal
- **Teksti:** W900, madhësia 16px, ngjyra e bardhë

---

### 5.5 Chip-et Neon (`_NeonChip`)

Përdoren si "kicker label" mbi titujt e moduleve:

- Ikonë + tekst me ngjyrë të personalizueshme
- Sfond: 15% i opak i ngjyrës së përcaktuar
- `borderRadius: 999` — plotësisht rrumbullak
- Tipike: `secondaryContainer` (cyan) për Sfidën e Ditës, `primaryContainer` (magenta) për Gamify

---

### 5.6 Top Bar Kozmike (`_CosmicTopBar`)

- Lartësia: **76px**
- Ngjyra: `#0B0C21` me 80% opacitet (blur efekt implicit)
- Logo/Titull: `MathLingo` — W900, 24px, magenta
- Majtës: Butoni i profilit ose `arrow_back`
- Djathas: Butoni i njoftimeve
- Forma: `_RoundIconButton` — katrore me kënde 20px

---

### 5.7 Bottom Navigation (`_CosmicBottomNav`)

- Ngjyra: `#0B0C21` me 80% opacitet
- Border i sipërm: 10% e bardhë
- `borderRadius: 32` në këndet e sipërme
- Hija ngjitur nga lart me magenta 12%
- 4 seksione: Dashboard, Mësime, Tabelat, Progresi

---

### 5.8 Responsiviteti (`AdaptiveLayout` + `ResponsivePage`)

#### Breakpoints

| Gjerësia | Konfigurimi |
|---|---|
| `< 600px` | Celular kompakt — layout vertikal |
| `600–759px` | Celular i madh — 3 kolona |
| `760–899px` | Tablet i vogël — padding 40px |
| `900–1099px` | Tablet i madh — layout 2-kolonësh, padding 48px |
| `≥ 1100px` | Desktop / Tablet landscape — 5 kolona, padding 56px |

#### Metodat Kryesore të `AdaptiveLayout`

| Metoda | Funksioni |
|---|---|
| `isTablet(context)` | `shortestSide >= 600` |
| `isLargeTablet(context)` | `shortestSide >= 800 \|\| width >= 1000` |
| `pagePadding(context)` | Padding adaptive bazuar në gjerësi |
| `columnsForWidth(width)` | Numri i kolonave për GridView |
| `scaleFontSize(context, base)` | Shkallëzimi i fontit (1.1× tablet, 1.2× large tablet) |
| `scalePadding(context, base)` | Shkallëzimi i padding (1.15× tablet, 1.3× large tablet) |

---

### 5.9 Animacionet dhe Tranzicionet

| Elementi | Animacioni | Kohëzgjatja |
|---|---|---|
| Feedback i përgjigjeve | `AnimatedSwitcher` | 180ms |
| Kalimi tek pyetja tjetër (saktë) | `Future.delayed` + setState | 450ms |
| Kalimi në gjeometri (saktë) | `Future.delayed` + setState | 500ms |
| Simulimi i procesimit (Gamify) | `Future.delayed` | 800ms |
| Navigimi ndërmjet ekraneve | `MaterialPageRoute` (slide default) | Flutter default (~300ms) |

---

## 6. Specifikimet Jo-Funksionale

### 6.1 Performanca

| Metrika | Objektivi | Statusi Aktual |
|---|---|---|
| Frame rate | 60 FPS konstante | ✅ Arrihet me Flutter rendering engine |
| Koha e ngarkimit inicial | < 2 sekonda (cold start) | ✅ Minimal dependencies |
| Koha e gjenerimit të pyetjes | < 50ms | ✅ Komplet sinkoron (pa I/O) |
| Tranzicionet UI | < 300ms | ✅ Native Flutter transitions |
| Madhësia e APK (Release) | < 20MB | ✅ Pak dependenca |

### 6.2 Siguria

| Aspekti | Zbatimi |
|---|---|
| Validimi i Input-it | Ekuacionet parserohen me `try/catch` — gabimi trajtohet me grace |
| Aksesi i Kamerës | Kërkohet leja e platformës nëpërmjet `image_picker` (nuk menaxhohet direkt) |
| Ruajtja e të Dhënave | V1.0 nuk ka persistencë lokale — asnjë e dhënë nuk ruhet |
| Lidhjet e Jashtme | Nuk ka thirrje API — aplikacioni është plotësisht offline |
| Injektimi i Kodit | Parseri i ekuacioneve nuk ekzekuton kod — vetëm parse numerik |
| Leja CAMERA (Android) | Deklarohet në `AndroidManifest.xml` nëpërmjet plugin-it |

### 6.3 Mirëmbajtja

- Ndarja e qartë e **ngjyrave** (`colors.dart`), **layout-it** (`responsive.dart`), dhe **logjikës** (`gamify_exercise.dart`, `simple_tables.dart`)
- Komponenti `GlassPanel`, `CosmicButton`, `_AnswerButton` janë widget-e të ripërdorshme
- `enum Operation` dhe `enum GeometryShape` garantojnë type-safety
- Analiza statike aktive me `flutter_lints ^5.0.0`

### 6.4 Aksesueshmëria

| Karakteristika | Zbatimi |
|---|---|
| Kontrasti i ngjyrave | Ngjyrat neon (magenta/cyan) mbi sfond të errët garantojnë kontrast WCAG AA |
| Madhësia e butonave | Minimum 48×48px (Material Design guideline) |
| Fontet | W800–W900 për titujt e rëndësishëm |
| Feedback | Vizual + tekstual (AnimatedSwitcher) |

### 6.5 Adaptimi në Pajisje

| Pajisja | Sjellja |
|---|---|
| Celular portret (< 600px) | Layout vertikal, grid 2-kolonësh |
| Celular peizazh (600–759px) | 3 kolona, padding i shtuar |
| Tablet 7" (760–899px) | Layout 2-kolonësh, font i shkallëzuar 1.1× |
| Tablet 10"+ (≥ 900px) | Layout 2-kolonësh premium, font 1.2× |
| Desktop (≥ 1100px) | Max width 1120px, 5 kolona, padding 56px |

---

## 7. Struktura e të Dhënave

### 7.1 Modelet e të Dhënave

#### `MathQuestion`
```dart
class MathQuestion {
  final int num1;       // Numri i parë
  final int num2;       // Numri i dytë
  final int answer;     // Përgjigja e saktë
  final List<int> options; // 4 opsione (1 saktë + 3 shpërdorëse)
}
```

#### `GeometryQuestion`
```dart
class GeometryQuestion {
  final GeometryShape shape;    // Lloji i formës
  final String prompt;          // Pyetja ("Sa është sipërfaqja...?")
  final String measurement;     // Matjet ("gjerësi 5, lartësi 3")
  final int answer;             // Përgjigja numerike
  final List<int> options;      // 4 opsione
  final int width;              // Gjerësia vizuale
  final int height;             // Lartësia vizuale
}
```

#### `enum Operation`
```dart
enum Operation {
  addition('+', 'Mbledhje', Icons.add),
  subtraction('-', 'Zbritje', Icons.remove),
  multiplication('*', 'Shumëzim', Icons.close),
  division('/', 'Pjesëtim', Icons.percent),
}
```

#### `enum GeometryShape`
```dart
enum GeometryShape {
  rectangle('Drejtkëndësh', Icons.crop_square),
  triangle('Trekëndësh', Icons.change_history),
  square('Katror', Icons.square_outlined),
}
```

---

## 8. Menaxhimi i Navigimit

### 8.1 Grafi i Navigimit

```
DashboardScreen (Root)
├── Tab[0]: _DashboardPage
│   ├── → ChallengeScreen (MaterialPageRoute)
│   ├── → GeometryChallengeScreen (MaterialPageRoute)
│   └── → GamifyExerciseScreen (MaterialPageRoute)
├── Tab[1]: _LessonsPage
│   └── → GeometryChallengeScreen (MaterialPageRoute)
├── Tab[2]: OperationTablesScreen
└── Tab[3]: _ProgressPage

ChallengeScreen
└── → ResultsScreen (pushReplacement)
    └── → DashboardScreen (pushAndRemoveUntil — stack flush)

GeometryChallengeScreen
└── → ResultsScreen (pushReplacement)
    └── → DashboardScreen (pushAndRemoveUntil — stack flush)
```

### 8.2 Politika e Stack-ut

- `pushReplacement` → Zëvendëson ChallengeScreen me ResultsScreen (pamji Back nuk kthehet në sfidë)
- `pushAndRemoveUntil` → ResultsScreen pastron tërë stack-un → Landing në Dashboard

---

## 9. Testimi

### 9.1 Strategjia e Testimit

| Lloji | Framework | Mbulimi |
|---|---|---|
| Widget Tests | `flutter_test` | Widget-et primitive UI |
| Unit Tests | `flutter_test` | Gjeneratorët e pyetjeve, parser-i |
| Integration Tests | — | (Planifikuar në v1.1) |

### 9.2 Skenarët e Testimit të Ekzistuar

**`test/widget_test.dart`** — Testi bazë i pranimit:
- Aplikacioni ngarkohet pa gabime
- DashboardScreen renderizet saktë

### 9.3 Kriteret e Pranimit për Modulet Kryesore

#### Sfida e Ditës
- [ ] Jep gjithmonë 4 opsione unike
- [ ] Vetëm 1 opsion është i saktë
- [ ] Skor inkrementohet me +10 për çdo saktësi
- [ ] Pas `sessionLength` pyetjeve → shfaqet ResultsScreen
- [ ] Feedback vizual pasqyron saktësinë (cyan/error)

#### Gjeometria Hapësinore
- [ ] Trekëndëshi gjithmonë ka `width` çift (formula `S = base*h/2` pa thyesë)
- [ ] Pjesëtimi `num1 = answer × num2` jep gjithmonë numër të plotë
- [ ] CustomPaint vizatohet pa overflow

#### Tabelat Matematikore
- [ ] Tabela shfaqet për të gjitha vlerat 1–12
- [ ] Tap në butonin e numrit selekton korrektin
- [ ] Ndërrimi i Tab-it ndryshon operacionin

#### Moduli Gamify
- [ ] Kamera hapet pa crash kur jepet leja
- [ ] Parseri nuk lëshon exception për inpute të pasakta
- [ ] Mesazhi i gabimit shfaqet me SnackBar e kuqe

---

## 10. Roadmap-i Teknik

### 10.1 Faza 1 — v1.0 (Aktuale - Q2 2026)

| Funksionaliteti | Statusi |
|---|---|
| 4 operacione aritmetike me 3 nivele | ✅ Implementuar |
| Gjeometria bazë (3 forma) | ✅ Implementuar |
| Tabelat matematikore 1–12 | ✅ Implementuar |
| Moduli Gamify me kamerë (UI) | ✅ UI implementuar |
| Tema Cosmic Dark + Glassmorphism | ✅ Implementuar |
| Layout responsive (celular/tablet/desktop) | ✅ Implementuar |
| Ekrani i rezultateve | ✅ Implementuar |

---

### 10.2 Faza 2 — v1.1 (Q3 2026)

| Funksionaliteti | Prioriteti | Teknologjia |
|---|---|---|
| **OCR me ML Kit** — njohja e ekuacioneve nga foto reale | 🔴 I lartë | `google_mlkit_text_recognition` |
| **Persistenca e të Dhënave** — ruajtja e progresit dhe rezultateve | 🔴 I lartë | `hive` ose `sqflite` |
| **Menaxhimi i Gjendjes me Riverpod** — shkallëzueshmëri | 🟠 Mesatar | `flutter_riverpod` |
| **Animacionet e Mascot-it** — Stitch me Rive/Lottie | 🟠 Mesatar | `rive` ose `lottie` |
| **Sistemi i Niveleve** — progresimi i vështirësisë automatik | 🟠 Mesatar | State logic |
| **Tingulli dhe Feedback Audio** | 🟡 I ulët | `audioplayers` |

**Detajet e ML Kit:**
```yaml
dependencies:
  google_mlkit_text_recognition: ^0.13.0
```
- Zëvendëson `_processImage()` placeholder-in aktual
- Mbështet shkrimin manual dhe të shtypur
- Procesim offline (on-device) — pa dërgim të dhënash në server

---

### 10.3 Faza 3 — v1.2 (Q4 2026)

| Funksionaliteti | Prioriteti | Teknologjia |
|---|---|---|
| **Backend dhe Autentifikimi** — profili i nxënësit | 🟠 Mesatar | Firebase Auth + Firestore |
| **Leaderboard** — krahasimi i rezultateve | 🟡 I ulët | Firestore |
| **Gjenerimi i Ekuacioneve me AI** — personalizim | 🟡 I ulët | Gemini API / OpenAI |
| **Moduli i Fraksioneve dhe Thyesave** | 🟠 Mesatar | Logjikë e re |
| **Certifikatat e Arritjes** — PDF/share | 🟡 I ulët | `pdf` + `share_plus` |
| **Dark/Light Mode Toggle** | 🟡 I ulët | `ThemeMode` switch |
| **Lokalizimi i Plotë** — EN/SQ | 🟡 I ulët | `flutter_localizations` |

---

### 10.4 Detyrat Teknike Kritike (Tech Debt)

| Detyra | Arsyeja | Prioriteti |
|---|---|---|
| Migrimi te **Riverpod** | `setState` nuk shkallëzon mirë me persistencë | 🔴 I lartë |
| Shtimi i **Integration Tests** | Mungesa e testeve end-to-end | 🔴 I lartë |
| Shtimi i **Widget Tests** gjithëpërfshirëse | Mbulim aktual minimal | 🟠 Mesatar |
| Refaktorimi i `main.dart` | Skedari është shumë i madh (1400+ rreshta) | 🟠 Mesatar |
| Trajtimi i lejave të kamerës | Duhet `permission_handler` eksplicit | 🟠 Mesatar |
| `_processImage()` TODO | OCR placeholder duhet zëvendësuar | 🔴 I lartë |

---

## 11. Anekset

### Aneks A — Varësitë e Projektit

```yaml
# pubspec.yaml — Dependencies

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  image_picker: ^1.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  flutter_launcher_icons: ^0.13.1
```

### Aneks B — Konfigurimi i Platformave

| Platforma | Konfigurimi Kryesor |
|---|---|
| Android | `build.gradle.kts`, `minSdkVersion` sipas Flutter defaults |
| iOS | `Info.plist` — `NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription` |
| Web | `web/index.html`, `web/manifest.json` |
| Windows | `windows/runner/CMakeLists.txt` |

### Aneks C — Ikona e Aplikacionit

- **Skedari:** `assets/icons/stich_icon.png`
- **Konfigurimi:** `flutter_launcher_icons ^0.13.1`
- **Platformat:** Android adaptive icon, iOS icon set, Web favicon

### Aneks D — Metrikat e Kodit

| Metrika | Vlera |
|---|---|
| Skedarë Dart | 5 (`main.dart`, `colors.dart`, `responsive.dart`, `gamify_exercise.dart`, `simple_tables.dart`) |
| Rreshta totale (LOC) | ~1,600 (`main.dart` ≈ 1,400 + të tjera) |
| Komponentë widget | ~25 widget klasa |
| Modele të dhënash | 2 klasa + 2 enum |
| Platforma të mbështetura | 6 |
| Gjuha e UI | 1 (Shqip) |

---

*Ky dokument është gjeneruar bazuar në analizën e plotë të kodit burimor të MathLingo v1.0.0+1 — Maj 2026.*

*Çdo ndryshim i rëndësishëm arkitekturor ose funksional duhet të reflektohet në këtë SSD para implementimit.*
