# MathLingo Math Audit Report

Audit scope u ekzekutua pa ndryshuar asnjë file.

Shënim i rëndësishëm: file i kërkuar [lib/features/challenges/domain/math_question_generator.dart](lib/features/challenges/domain/math_question_generator.dart) nuk ekziston në repo; engine aktiv i aritmetikës është [lib/core/providers/challenge_provider.dart](lib/core/providers/challenge_provider.dart).

## 🔴 Critical Mathematical/Runtime Flaws
- Hardcoded approximation për perimetrin e rrethit në generatorin e gjeometrisë: në vend të formulës me $2\pi r$, implementimi përdor $6r$ dhe e deklaron π≈3.
  Evidencë: [geometry_question_generator.dart#L57](lib/features/geometry/domain/geometry_question_generator.dart#L57), [geometry_question_generator.dart#L58](lib/features/geometry/domain/geometry_question_generator.dart#L58).
  Impakt: devijim sistematik matematikor (gabim konceptual i formularit) dhe bllokon shkallëzimin pedagogjik për nivele më të larta.
- Parseri simbolik pranon pjesëtim me emërues 0 pa asnjë guard semantik.
  Evidencë: [gamify_parser.dart#L35](lib/features/gamify/domain/gamify_parser.dart#L35), [gamify_parser.dart#L54](lib/features/gamify/domain/gamify_parser.dart#L54), [gamify_parser.dart#L59](lib/features/gamify/domain/gamify_parser.dart#L59).
  Impakt: nëse kjo dalje përdoret nga evaluator, krijon risk runtime fatal (division-by-zero) ose rezultate të pa-definuara.
- Degjenerim range në generatorin Missing X kur maxNumber është i vogël (API publike pa validim kufijsh).
  Evidencë: [missing_x_generator.dart#L29](lib/features/missing_x/domain/missing_x_generator.dart#L29), [missing_x_generator.dart#L57](lib/features/missing_x/domain/missing_x_generator.dart#L57), [missing_x_generator.dart#L58](lib/features/missing_x/domain/missing_x_generator.dart#L58).
  Impakt: RangeError i menjëhershëm për inpute si maxNumber ≤ 2 në degë të caktuara.

## 🟠 Architectural Shortcuts & Hardcoded Values
- Aspect-ratio disconnect në painter-in e gjeometrisë: vetëm drejtkëndëshi respekton raportin e dimensioneve të pyetjes; forma të tjera vizatohen me përmasa të fiksuara relative ndaj canvas-it, jo ndaj vlerave logjike të pyetjes.
  Evidencë: [geometry_shape_painter.dart#L28](lib/shared/painting/geometry_shape_painter.dart#L28), [geometry_shape_painter.dart#L29](lib/shared/painting/geometry_shape_painter.dart#L29), [geometry_shape_painter.dart#L35](lib/shared/painting/geometry_shape_painter.dart#L35), [geometry_shape_painter.dart#L50](lib/shared/painting/geometry_shape_painter.dart#L50), [geometry_shape_painter.dart#L80](lib/shared/painting/geometry_shape_painter.dart#L80).
  Impakt: pyetje me rreze ose dimensione shumë të ndryshme duken pothuaj njësoj vizualisht.
- Distractors në gjeometri janë gjeneruar me offset statik linear rreth përgjigjes (plus/minus), jo me gabime të tipologjisë pedagogjike sipas formës/formulës.
  Evidencë: [geometry_question_generator.dart#L82](lib/features/geometry/domain/geometry_question_generator.dart#L82), [geometry_question_generator.dart#L84](lib/features/geometry/domain/geometry_question_generator.dart#L84), [geometry_question_generator.dart#L88](lib/features/geometry/domain/geometry_question_generator.dart#L88).
  Impakt: cilësi didaktike e ulët, lehtë e parashikueshme nga nxënësi.
- Legacy module me pyetje të para-pjekura (pre-baked), jo algorithmic generation.
  Evidencë: [simple_tables.dart#L884](lib/simple_tables.dart#L884), [simple_tables.dart#L891](lib/simple_tables.dart#L891).
  Impakt: mbulim i ngushtë i variacioneve matematikore dhe risk memorization bias.
- Formula panel ka literal që e cementon approximation π≈3, duke e bërë shortcut-in pjesë të UX-it.
  Evidencë: [formula_reference_panel.dart#L106](lib/features/geometry/widgets/formula_reference_panel.dart#L106), [formula_reference_panel.dart#L121](lib/features/geometry/widgets/formula_reference_panel.dart#L121).
- Kontrollet ekzistuese të sigurisë matematikore në aritmetikë dhe tabela janë të mira (jo infraction, por verifikim):
  - Subtraction beginner-safe në challenge engine: [challenge_provider.dart#L138](lib/core/providers/challenge_provider.dart#L138).
  - Division exact integer në challenge engine: [challenge_provider.dart#L152](lib/core/providers/challenge_provider.dart#L152), [challenge_provider.dart#L153](lib/core/providers/challenge_provider.dart#L153).
  - Division filter dhe vetëm pastaj integer division në tabela: [simple_tables.dart#L142](lib/simple_tables.dart#L142), [simple_tables.dart#L283](lib/simple_tables.dart#L283).

## 🧪 Missing Test Coverage
- Testet e gjeometrisë aktualisht e konsiderojnë korrekt modelin $6r$ (jo $2\pi r$), pra nuk kapin drift matematikor të π.
  Evidencë: [geometry_question_generator_test.dart#L29](test/geometry/geometry_question_generator_test.dart#L29), [geometry_question_generator_test.dart#L49](test/geometry/geometry_question_generator_test.dart#L49).
- Nuk ka widget/unit tests që verifikojnë fidelity vizuale dimensionale për forma jo-drejtkëndësh (p.sh. rreze të ndryshme të reflektohen proporcionalisht në painter).
  Evidencë: mungesë e plotë e geometry painter tests në test tree.
- Parseri Gamify nuk ka teste për denominator zero, numra negativë, ose inpute me shumë operatorë.
  Evidencë aktuale e testeve minimale: [gamify_parser_test.dart#L37](test/gamify/gamify_parser_test.dart#L37), [gamify_parser_test.dart#L45](test/gamify/gamify_parser_test.dart#L45).
- Missing X nuk teston parametra kufitarë të maxNumber (testet përdorin vetëm default path), kështu degjenerimi i range mbetet i pambuluar.
  Evidencë: [missing_x_generator_test.dart#L17](test/features/missing_x/missing_x_generator_test.dart#L17), [missing_x_generator_test.dart#L30](test/features/missing_x/missing_x_generator_test.dart#L30).
- Testet e tabelave përdorin helper të duplikuar në test file (shadow logic), jo thirrje direkte të logjikës prodhuese; kjo rrit riskun që bug-u të replikohet identikisht në test dhe të mos kapet.
  Evidencë: [tables_inverse_mode_test.dart#L14](test/features/tables/tables_inverse_mode_test.dart#L14), [tables_inverse_mode_test.dart#L16](test/features/tables/tables_inverse_mode_test.dart#L16), [tables_inverse_mode_test.dart#L92](test/features/tables/tables_inverse_mode_test.dart#L92).
