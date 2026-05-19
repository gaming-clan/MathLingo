# 🐞 MathLingo — Sprint 11.5: Korrigjime & Polish
**Versioni:** v1.7.1 | **Branch:** `fix/sprint-11-5-bugfix-polish`  
**Kohëzgjatja:** 1 javë | **Prioriteti:** I lartë — para çdo release publik  
**Varësia:** Sprint 11 DONE ✅

---

## Konteksti

Pas analizës vizuale të build-it të 19 Majit 2026, u identifikuan **8 probleme** të kategorive të ndryshme: 2 bug logjike kritike, 2 probleme estetike të specifikuara nga testi manual, dhe 4 probleme UX/polish. Ky sprint i mbyll të gjitha para Sprint 12 (AI + Certifikata).

---

## Regjistri i Bug-eve Sprint 11.5

| ID | Kategoria | Përshkrimi | Severiteti | Skedari i prekur |
|:---|:---|:---|:---|:---|
| B-01 | 🔴 Logjikë | Shumëzim/Pjesëtim Invers janë swap-uar | Kritik | `tables_notifier.dart` |
| B-02 | 🔴 Logjikë | Mbledhja Invers nuk ndryshon formatin e kartave | Kritik | `tables_notifier.dart` |
| B-03 | 🟡 Estetikë | Badge reveal — buton "Tjetri" kontrast i dobët (sfond rozë + tekst i bardhë) | Mesatar | `achievement_reveal_dialog.dart` |
| B-04 | 🟡 Estetikë | Teksti i kartave të tabelave ngjitet me bordurin (padding 0) | Mesatar | `table_card_widget.dart` |
| B-05 | 🟠 UX | Badge "Mbledhësi" — ikona Material `+` (gri, e sheshtë) pa ngjyrë | I ulët | `achievement_definitions.dart` |
| B-06 | 🟠 UX | Klasifikimi Familjar shfaq vetëm profilin aktiv, jo të gjitha profilet | I ulët | `leaderboard_screen.dart` |
| B-07 | 🟠 UX | Fonti i formulës në kartat e tabelave shumë i vogël (~12px) | I ulët | `table_card_widget.dart` |
| B-08 | 🟡 Estetikë | Tabelat Shumëzim: kontrast i dobët tekst i bardhë mbi portokalli të errët | Mesatar | `table_card_widget.dart` |

---

## Detyrat e detajuara

---

### B-01 · Shumëzim & Pjesëtim Invers — logjika e swap-uar
**Prioriteti:** 🔴 Kritik  
**Skedari:** `lib/features/tables/providers/tables_notifier.dart`

**Problemi:**  
Në modalitetin Invers, Shumëzimi tregon `?÷n=a` (logjikë pjesëtimi) dhe Pjesëtimi tregon `?×n=a` (logjikë shumëzimi). Janë të ndërruar mes tyre.

**Sjellja aktuale:**
```
Shumëzim Invers Tabela 4: ?÷1=4(→4), ?÷2=4(→8), ?÷3=4(→12)  ❌
Pjesëtim Invers Tabela 4: ?×1=4(→4), ?×2=4(→2), ?×4=4(→1)   ❌
```

**Sjellja e synuar:**
```
Shumëzim Invers Tabela 4: ?×1=4(→4), ?×2=8(→4), ?×3=12(→4)  ✅
  Kuptimi: "çfarë herë [n] jep [rezultatin e tabelës]?"
  Formula: result = tableNum * multiplier → answer = result / multiplier

Pjesëtim Invers Tabela 4: 4÷?=4(→1), 8÷?=4(→2), 12÷?=4(→3) ✅  
  Kuptimi: "4 pjesëto me çfarë jep [resultin]?"
  Formula: dividend = tableNum * divisor → answer = dividend / tableNum
```

**Zgjidhja:**  
Në `TablesNotifier._buildInverseCards()`, shkëmbe bllokun `case Operation.multiplication` me `case Operation.division`:

```dart
// PARA (e gabuar):
case Operation.multiplication:
  // kishte logjikën e pjesëtimit
case Operation.division:
  // kishte logjikën e shumëzimit

// PAS (e saktë):
case Operation.multiplication:
  // Shumëzim Invers: ?×multiplier = tableNum×multiplier
  // Shfaq: "? × [multiplier] = [result]" → answer = result ÷ multiplier
  for (int multiplier = 1; multiplier <= 10; multiplier++) {
    final result = tableNum * multiplier;
    cards.add(TableQuestion(
      expression: '? × $multiplier = $result',
      answer: tableNum,         // tableNum × multiplier = result → ? = tableNum
      operationSymbol: '×',
      isInverse: true,
    ));
  }

case Operation.division:
  // Pjesëtim Invers: dividend ÷ ? = tableNum
  // Shfaq: "[dividend] ÷ ? = [tableNum]" → answer = divisor
  final divisors = _getDivisorsOf(tableNum); // vetëm ndarësit e saktë
  for (final divisor in divisors) {
    final dividend = tableNum * divisor;
    cards.add(TableQuestion(
      expression: '$dividend ÷ ? = $tableNum',
      answer: divisor,
      operationSymbol: '÷',
      isInverse: true,
    ));
  }
```

**Unit tests të reja:**
```dart
// test/features/tables/tables_inverse_logic_test.dart

test('Shumëzim Invers Tabela 4: answer gjithmonë = tableNum', () {
  final cards = TablesNotifier.buildInverseCards(
    tableNum: 4, operation: Operation.multiplication
  );
  // Çdo kartë: ? × multiplier = result, answer = 4
  expect(cards.every((c) => c.answer == 4), isTrue);
  // Shprehja përdor × jo ÷
  expect(cards.every((c) => c.expression.contains('×')), isTrue);
});

test('Pjesëtim Invers Tabela 4: shprehja përdor ÷', () {
  final cards = TablesNotifier.buildInverseCards(
    tableNum: 4, operation: Operation.division
  );
  expect(cards.every((c) => c.expression.contains('÷')), isTrue);
  // answer = divisor, jo tableNum
  expect(cards.first.answer, isNot(equals(4)));
});
```

---

### B-02 · Mbledhja Invers — toggle pa efekt
**Prioriteti:** 🔴 Kritik  
**Skedari:** `lib/features/tables/providers/tables_notifier.dart`

**Problemi:**  
Mbledhja Invers tregon `a+b=c` si klasikja. Toggle `isInverseMode` nuk ka efekt mbi gjenerimin e kartave për mbledhjen.

**Sjellja aktuale:**
```
Mbledhje Klasik Tabela 4:  4+1=5, 4+2=6, 4+3=7   ✅
Mbledhje Invers Tabela 4:  4+1=5, 4+2=6, 4+3=7   ❌ (identike!)
```

**Sjellja e synuar:**
```
Mbledhje Invers Tabela 4:  ?+1=4(→3), ?+2=4(→2), ?+3=4(→1), ?+4=4(→0)
  Kuptimi: "çfarë plus [n] jep [tableNum]?"
  Formula: answer = tableNum - addend (ku addend ∈ [1, tableNum])
```

**Zgjidhja:**

```dart
case Operation.addition:
  if (isInverse) {
    // Invers: ?+addend = tableNum → answer = tableNum - addend
    for (int addend = 1; addend <= tableNum; addend++) {
      cards.add(TableQuestion(
        expression: '? + $addend = $tableNum',
        answer: tableNum - addend,    // e.g. ?+1=4 → answer=3
        operationSymbol: '+',
        isInverse: true,
      ));
    }
  } else {
    // Klasik: tableNum + multiplier = result (logjika ekzistuese)
    for (int multiplier = 1; multiplier <= 10; multiplier++) {
      cards.add(TableQuestion(
        expression: '$tableNum + $multiplier = ${tableNum + multiplier}',
        answer: tableNum + multiplier,
        operationSymbol: '+',
        isInverse: false,
      ));
    }
  }
```

**Unit tests:**
```dart
test('Mbledhje Invers Tabela 4: expression përdor ?+n=4', () {
  final cards = TablesNotifier.buildInverseCards(
    tableNum: 4, operation: Operation.addition
  );
  expect(cards.every((c) => c.expression.startsWith('?')), isTrue);
  expect(cards.every((c) => c.expression.contains('= 4')), isTrue);
});

test('Mbledhje Invers Tabela 4: answer = tableNum - addend', () {
  final cards = TablesNotifier.buildInverseCards(
    tableNum: 4, operation: Operation.addition
  );
  // ?+1=4 → answer=3, ?+2=4 → answer=2
  expect(cards[0].answer, equals(3)); // ?+1=4
  expect(cards[1].answer, equals(2)); // ?+2=4
  expect(cards[3].answer, equals(0)); // ?+4=4
});
```

---

### B-03 · Badge Reveal — kontrast i dobët tek butoni
**Prioriteti:** 🟡 Mesatar  
**Skedari:** `lib/features/achievements/widgets/achievement_reveal_dialog.dart`

**Problemi:**  
Butoni "Tjetri →" dhe "Vazhdoj! 🎉" ka sfond rozë të çelët (`Colors.pink.shade100` ose ngjashëm) me tekst të bardhë. Raporti i kontrastit është rreth 1.8:1 — shumë nën WCAG AA (4.5:1 minimum).

**Zgjidhja:**  
Zëvendëso sfondo rozë me `CosmicButton` standard ose me variant të errët:

```dart
// PARA (e gabuar):
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.pink.shade100, // ❌ rozë e çelët
    foregroundColor: Colors.white,
  ),
  child: Text('Tjetri →'),
)

// PAS (e saktë) — opsioni 1: CosmicButton standard
CosmicButton(
  label: isLast ? 'Vazhdoj! 🎉' : 'Tjetri →',
  onPressed: onNext,
)

// PAS (e saktë) — opsioni 2: nëse duhet variant më i butë
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFFBC13FE), // magenta neon
    foregroundColor: Colors.white,
    // Kontrast: #BC13FE mbi sfond → ~5.2:1 ✅ WCAG AA
  ),
  child: Text(
    isLast ? 'Vazhdoj! 🎉' : 'Tjetri →',
    style: const TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 16,
    ),
  ),
)
```

**Verifikim:**  
Pas ndryshimit, kontrasto me mjet online (e.g. contrast-ratio.com):  
- `#BC13FE` (magenta) mbi `#1D1E33` (surface) → ≥4.5:1 ✅  
- Teksti i bardhë `#FFFFFF` mbi `#BC13FE` → ≥4.5:1 ✅

---

### B-04 · Kartat e Tabelave — teksti ngjitet me bordurin
**Prioriteti:** 🟡 Mesatar  
**Skedari:** `lib/features/tables/widgets/table_card_widget.dart`

**Problemi:**  
Teksti i formulës (`1+1`, `4×2` etj.) dhe rrethi i rezultatit janë pa padding të brendshëm — ngjiten me bordurin e kartës, veçanërisht në kartat me numra të mëdhenj si `4×10=40` ose `12+12=24`.

**Zgjidhja:**

```dart
// PARA:
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: operationColor),
  ),
  child: Column(
    children: [
      Text(expression),      // ❌ pa padding
      CircleAvatar(child: Text(answer)),
    ],
  ),
)

// PAS:
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: operationColor, width: 1.5),
  ),
  padding: const EdgeInsets.fromLTRB(8, 10, 8, 8), // ✅ padding i shtuar
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(
          expression,
          style: const TextStyle(
            fontSize: 14,   // ✅ ngritur nga ~11px
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.2,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis, // ✅ mbrojtje overflow
        ),
      ),
      Center(
        child: CircleAvatar(
          radius: 22,   // pakësuar pak për të lënë hapësirë
          backgroundColor: operationColor,
          child: Text(
            answer.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ],
  ),
)
```

**Rregull e re:** Padding minimum `8px` horizontal dhe `10px` vertikal në të gjitha kartat e tabelave. `maxLines: 2` + `overflow: ellipsis` parandalon overflow për shprehje të gjata si `12 + 10 = 22`.

---

### B-05 · Badge "Mbledhësi" — ikona pa ngjyrë
**Prioriteti:** 🟠 I ulët  
**Skedari:** `lib/features/achievements/data/achievement_definitions.dart`

**Problemi:**  
Badge "Mbledhësi" përdor ikonën Material `Icons.add` me ngjyrë gri — ndryshe nga të gjitha badge-et e tjera që kanë emoji me ngjyrë.

**Zgjidhja:**  
Zëvendëso ikonën Material me emoji ose imazh SVG:

```dart
// PARA:
Achievement(
  id: 'adder',
  title: 'Mbledhësi',
  description: 'Fillo modulin e mbledhjes.',
  icon: Icons.add,        // ❌ ikona Material gri
  iconColor: Colors.grey,
)

// PAS:
Achievement(
  id: 'adder',
  title: 'Mbledhësi',
  description: 'Fillo modulin e mbledhjes.',
  emoji: '➕',            // ✅ emoji me ngjyrë
  // ALT: emoji: '🔢' ose '🧮'
)
```

Nëse widget-i i reveal përdor `Icon`, zëvendëso me `Text(emoji, style: TextStyle(fontSize: 64))` në mënyrë konsistente me badge-et e tjera.

---

### B-06 · Klasifikimi Familjar — tregon vetëm profilin aktiv
**Prioriteti:** 🟠 I ulët  
**Skedari:** `lib/features/achievements/screens/leaderboard_screen.dart`

**Problemi:**  
`LeaderboardScreen` lexon vetëm profilin aktiv nga `activeFamilyChildProvider` dhe shfaq vetëm atë. Profilet e tjera të familjes nuk shfaqen.

**Zgjidhja:**

```dart
// PARA:
final activeChild = ref.watch(activeFamilyChildProvider);
// shfaq vetëm activeChild ❌

// PAS:
final allChildren = ref.watch(allFamilyChildrenProvider); // ✅ të gjitha profilet
final activeChildId = ref.watch(activeFamilyChildProvider)?.id;

// Rendit sipas pikëve (descending)
final sorted = [...allChildren]
  ..sort((a, b) => b.totalPoints.compareTo(a.totalPoints));

// Shfaq me highlight për profilin aktiv
ListView.builder(
  itemCount: sorted.length,
  itemBuilder: (context, index) {
    final child = sorted[index];
    final isActive = child.id == activeChildId;
    return LeaderboardTile(
      rank: index + 1,
      child: child,
      isHighlighted: isActive,  // cyan border për profilin aktiv
    );
  },
)
```

**Kujdes:** Klasifikimi Familjar shfaq VETËM profilet e kësaj pajisje/familjeje — jo leaderboard global. Kjo është rregull e privatësisë (Sprint 10.5).

---

### B-07 · Fonti i formulës në kartat e tabelave — shumë i vogël
**Prioriteti:** 🟠 I ulët  
**Skedari:** `lib/features/tables/widgets/table_card_widget.dart`

**Problemi:**  
Teksti i formulës (`4×2`, `1+3`) është rreth 11–12px — i palexueshëm për fëmijë 6–10 vjeç.

**Zgjidhja:** (e integruar me B-04 — i njëjti skedar)  
`fontSize: 14` minimum për formula, `fontSize: 16` për shprehje të shkurtra. Shih kodin e B-04 më sipër.

---

### B-08 · Tabelat Shumëzim — kontrast i dobët mbi sfond portokalli
**Prioriteti:** 🟡 Mesatar  
**Skedari:** `lib/features/tables/widgets/table_card_widget.dart`

**Problemi:**  
Teksti i formulës (i bardhë) mbi sfond portokalli të errët (`#7D4000` ose ngjashëm) ka kontrast të pamjaftueshëm. Problemi bie kryesisht mbi tekstin e vogël të formulës.

**Zgjidhja:**  
Shto `shadow` te teksti i formulës për kartat me sfond të ngjyrosur:

```dart
Text(
  expression,
  style: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    shadows: const [
      Shadow(
        color: Colors.black54,    // ✅ hije e zezë e butë
        blurRadius: 4,
        offset: Offset(0, 1),
      ),
    ],
  ),
)
```

Alternativë: ndrysho sfondo e kartës nga portokalli i ngurtë `#7D4000` në `#5C3000` (50% më i errët) → kontrast tekst i bardhë rritet nga ~2.8:1 në ~5.1:1.

---

## Planifikimi javor

| Dita | Detyrat | Kohëzgjatja |
|:-----|:--------|:------------|
| D1 | B-01: Shumëzim/Pjesëtim Invers swap fix + unit tests | 4–5 orë |
| D2 | B-02: Mbledhje Invers logjikë + unit tests | 3–4 orë |
| D3 | B-04 + B-07 + B-08: Kartat e tabelave — padding, font, kontrast | 3–4 orë |
| D4 | B-03: Badge buton kontrast + B-05: Badge ikona | 2–3 orë |
| D5 | B-06: Leaderboard të gjitha profilet + QA e plotë | 3–4 orë |

---

## Kriteret e pranimit

### Logjika Matematikore
- [ ] Shumëzim Invers Tabela N: çdo kartë ka format `?×m=N×m`, answer = N
- [ ] Pjesëtim Invers Tabela N: çdo kartë ka format `N×m ÷ ? = N`, answer = m
- [ ] Mbledhje Invers Tabela N: çdo kartë ka format `?+n=N`, answer = N-n
- [ ] Toggle Klasik/Invers prodhon rezultate të ndryshme vizualisht për të gjitha 4 operacionet
- [ ] `fvm flutter test` kalon të gjitha unit tests të reja (target: +8 teste)

### Estetika & Aksesueshmëria
- [ ] Butoni "Tjetri →" në badge reveal: kontrast ≥4.5:1 (WCAG AA)
- [ ] Teksti i formulës në kartat e tabelave: fontSize ≥14, padding ≥8px
- [ ] Asnjë tekst nuk ngjitet me bordurin e kartës (gap ≥8px)
- [ ] Badge "Mbledhësi" ka emoji me ngjyrë, jo ikonë Material gri
- [ ] Kontrast teksti mbi sfond portokalli shumëzimi: ≥4.5:1

### UX
- [ ] Klasifikimi Familjar tregon TË GJITHA profilet e familjes, të renditura sipas pikëve
- [ ] Profili aktiv highlighted me border/ngjyrë dalluese

### Build
- [ ] `fvm flutter analyze` — 0 warnings
- [ ] `fvm flutter test` kalon ≥ (numri ekzistues + 8 teste të reja)
- [ ] Build release APK pa gabime

---

## ARB strings të reja (nëse nevojiten)

Nuk nevojiten string-e të reja — ndryshimet janë vizuale dhe logjike.

---

## Checklist QA manual pas implementimit

```
LOGJIKA E TABELAVE — verifikimi visual

Mbledhje Klasik Tabela 5:
✅ Duhet: 5+1=6, 5+2=7, 5+3=8 ...

Mbledhje Invers Tabela 5:
✅ Duhet: ?+1=5(→4), ?+2=5(→3), ?+3=5(→2), ?+4=5(→1), ?+5=5(→0)
❌ NUK duhet: 5+1=6, 5+2=7 (si klasiku)

Shumëzim Klasik Tabela 5:
✅ Duhet: 5×1=5, 5×2=10, 5×3=15 ...

Shumëzim Invers Tabela 5:
✅ Duhet: ?×1=5(→5), ?×2=10(→5), ?×3=15(→5) ...
   Kuptimi: sa herë [n] hyn në [n×5]? Përgjigja gjithmonë 5.
❌ NUK duhet: ?÷n=5 (logjikë pjesëtimi)

Pjesëtim Klasik Tabela 5:
✅ Duhet: 5÷1=5, 10÷5=2, 15÷5=3 ... (ndarësit e saktë)

Pjesëtim Invers Tabela 5:
✅ Duhet: 5÷?=5(→1), 10÷?=5(→2), 15÷?=5(→3) ...
   Kuptimi: [dividend] pjesëto me sa jep 5?
❌ NUK duhet: ?×n=5 (logjikë shumëzimi)

ESTETIKA — verifikimi visual
[ ] Badge "Tjetri" buton: teksti i dukshëm qartë mbi sfond
[ ] Karta tabele: teksti nuk prek kufirin
[ ] Badge "Mbledhësi": emoji me ngjyrë i dukshëm

LEADERBOARD
[ ] Hapni Klasifikimin Familjar me 2+ profile — të gjitha shfaqen
[ ] Profili aktiv ka dallim vizual nga të tjerët
```

---

## Changelog entry (draft për v1.7.1)

```markdown
## [1.7.1] - 2026-05-xx

### Fixed
- Shumëzim Invers: format i korrigjuar nga `?÷n=a` në `?×n=result` 
  (answer = tableNum për çdo kartë).
- Pjesëtim Invers: format i korrigjuar nga `?×n=a` në `dividend÷?=tableNum`
  (swap i logjikës me Shumëzimin).
- Mbledhje Invers: tani gjeneron `?+n=tableNum` (answer=tableNum-n) 
  në vend të `tableNum+n=result` (identike me Klasikun).
- Badge reveal dialog: butoni "Tjetri →" tani përdor `CosmicButton` 
  standard — kontrast ngrihet nga ~1.8:1 në ≥4.5:1 (WCAG AA).
- Kartat e tabelave: shtuar `padding: EdgeInsets.fromLTRB(8,10,8,8)` 
  dhe `fontSize: 14` për tekstin e formulës — eliminon ngjitjen me bordurin.
- Teksti i formulës mbi sfond portokalli (shumëzim): shtuar `Shadow` 
  për kontrast të mjaftueshëm.
- Badge "Mbledhësi": ikona Material `Icons.add` zëvendësuar me emoji `➕`.
- Klasifikimi Familjar: tregon të gjitha profilet e familjes (jo vetëm 
  profilin aktiv), të renditura sipas pikëve.

### Validated
- fvm flutter test — [N]/[N] ✅ (+8 teste të reja)
- fvm flutter analyze — 0 issues ✅
```

---

*Sprint 11.5 — Dokumenti i Korrigjimeve dhe Polish*  
*Data: 19 Maj 2026 · Versioni target: v1.7.1*
