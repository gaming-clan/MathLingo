# MathLingo — Play Store Listing (v2.0.0)

## Emri i Aplikacionit
**MathLingo**

---

## Përshkrimi i Shkurtër (≤80 karaktere)
> Kopjo këtë direkt në Play Console → "Short description"

```
Mëso matematikën me lojëra! Tabela, sfida & arritje për fëmijë.
```
*64 karaktere ✅*

---

## Përshkrimi i Gjatë (≤4000 karaktere)
> Kopjo këtë direkt në Play Console → "Full description"

```
MathLingo është aplikacioni matematik plotësisht në shqip për fëmijë të moshës 6–12 vjeç. Me sfida interaktive, tabelat e shumëzimit dhe sistemin e arritjeve, fëmijët mësohen matematikën duke u argëtuar.

✨ ÇFARË OFRON MATHLINGO?

📊 Sfida Matematike Adaptive
Sfidat përshtaten automatikisht me nivelin e fëmijës — fillestar, i mesëm ose i avancuar. DifficultyEngine i veçantë ndjek progresin dhe rregullon vështirësinë pas çdo sesioni.

🔢 Tabelat e Shumëzimit & Mbledhjes
Tabela interaktive me modalitet klasik dhe invers. Fëmija mëson si shumëzimin ashtu edhe logjikën e kundërt (? × 4 = 20).

📐 Gjeometri Vizuale
5 forma gjeometrike me llogaritje sipërfaqeje dhe perimetri, vizualizim i animuar dhe udhëzime hap-pas-hapi.

🔍 Gjej X-in (Algjebrë Bazë)
Sfida "Gjej X-in" i mëson fëmijët mendimin invers dhe bazat e algjebrës në mënyrë vizuale.

🍕 Fraksionet Vizuale
Mëso thyesat me grafikë pie dhe bar — ½, ⅓, ¼, ¾ dhe shumë të tjera.

📷 OCR & Matematika Fotografike (Gamify)
Nxirr çdo ekuacion nga një foto! Motori ML Kit lexon tekstin e shtypur dhe e zgjidh automatikisht.

🏆 Sistemi i Arritjeve
Mbi 20 badge unike — nga "Fillestar Energjik" deri te "Mjeshtri i Gjeometrisë". Njoftim me animacion kur shkyçet badge i ri.

👨‍👩‍👧 Profila Familjare
Krijo profila të shumëfishta fëmijësh me avatar emoji dhe kaloni mes tyre me PIN prindi. Secili fëmijë ka progresin e vet të pavarur.

📈 Raportet e Prindërve
Shiko grafikët e javës — pikët dhe saktësinë — për çdo fëmijë. Auto-sinkronizim me cloud pas çdo sesioni të përfunduar.

☁️ Cloud Sync Optional
Ruaj progresin në cloud me Firebase. Opt-in — privatësia jote, zgjedhja jote. GDPR Art. 17 i zbatuar.

🔒 Privatësia & Siguria
• PIN mbrojtje për prindërit
• Pa reklama, pa blerje brenda aplikacionit
• Fshirje e plotë e të dhënave me një klik
• Politika e privatësisë e plotë brenda aplikacionit
• Zbatim i GDPR për fëmijë

🎵 Audio & Haptik
Reagim i menjëhershëm zanor dhe haptik — i konfigurueshëm nga cilësimet.

---

MathLingo u ndërtua me dashuri për fëmijët shqipfolës. Çdo ekran, çdo string dhe çdo sfidë është hartuar posaçërisht në gjuhën shqipe.
```
*~2 100 karaktere ✅*

---

## Kategoria
**Education** → Subcategory: **Learning**

## Grupi i Moshës (Target Audience)
- Fëmijë: 6–12 vjeç (kryesor)
- Prindër & mësues (dytësor)

## Tags / Keywords
`matematika`, `lojëra edukative`, `tabelat`, `shqip`, `fëmijë`, `sfida matematike`, `mbledhje zbritje`, `shumëzim`, `algjebrë bazë`, `fraksione`

---

## Content Rating Questionnaire (IARC)
| Pyetja | Përgjigja |
|---|---|
| Dhunë? | Jo |
| Seks/Nudizëm? | Jo |
| Gjuhë e papërshtatshme? | Jo |
| Blerje brenda aplikacionit? | Jo |
| Ndarje e të dhënave personale? | Po — Firebase Auth (email prindi) + Firestore (progres anonimizuar per fëmijë) |
| Ndërveprim me strangers? | Jo — platformë vetëm familjare |

**Rating i pritur: Të gjitha moshat (E) / PEGI 3**

---

## Data Safety Form (Google Play)

### Të dhënat e mbledhura:
| Lloji | Specifika | Arsyeja |
|---|---|---|
| Llogaria | Email adresë prindi | Firebase Auth — opt-in cloud sync |
| Aktiviteti i aplikacionit | Pikët, saktësia, sesionet | Raportet prindërore — opt-in |

### Praktikat e sigurisë:
- ✅ Të dhënat kriptohen gjatë transmetimit (HTTPS/TLS)
- ✅ Të dhënat mund të fshihen nga përdoruesi (`DeleteAllDataScreen`)
- ✅ Nuk shiten të dhëna tek palë të treta
- ✅ Nuk ka të dhëna sensitive për fëmijë — vetëm progres anonimizuar (pikë/saktësi)

---

## Imazhet e Nevojshme

### App Icon
- **Madhësia:** 512×512 px
- **Formati:** PNG, pa transparencë (sfond plotësisht ngjyrë)
- **Stili:** Cosmic Dark — ngjyrë sfond `#0D0D2B`, emoji `🔢` ose logoja MathLingo qendrore
- **Rreth i jashtëm:** Pa shtresë (flat icon, jo adaptive — Play Console do e shfaqë vetë adaptive)

### Feature Graphic
- **Madhësia:** 1024×500 px
- **Formati:** PNG ose JPEG
- **Elementet:** 
  - Sfond `#0D0D2B` (Cosmic Dark) me yje/grimca
  - Tekst kryesor: **"MathLingo"** (fonti aplikacionit, cosmic white)
  - Nëntitull: "Mëso matematikën me lojëra! 🚀"
  - Disa sfida/badge si dekoracion

### Screenshots (min. 4, optimal 8)
| Nr. | Ekrani | Përshkrimi |
|---|---|---|
| 1 | Dashboard | Kartat e të gjitha moduleve, tema Cosmic Dark |
| 2 | ChallengeScreen | Sfidë aritmetike aktive me DistractorEngine |
| 3 | SimpleTables | Tabelë shumëzimi invers (? × 4 = 20) |
| 4 | GeometryChallenge | Sfidë gjeometrike me vizualizim |
| 5 | BadgeDisplayScreen | Grid badge-sh me arritje të shkyçura |
| 6 | ParentReportScreen | Grafiku javor me BarChart + LineChart |
| 7 | FamilySwitcherScreen | Profila familjare me avatar emoji |
| 8 | FractionChallenge | Fraksione vizuale pie/bar |

**Madhësia screenshot:** Min. 320px anash, rekomandohet 1080×1920 px (portrait)

---

## Checklist Final Para Dorëzimit

### Track A — Assets Store
- [ ] A-01: Screenshots Android minimum 4 (telefon) — preferohet 8
- [ ] A-02: Feature Graphic 1024×500 px
- [ ] A-03: App Icon 512×512 px pa transparencë
- [ ] A-04: Tekstet e listimit ✅ (ky skedar)

### Track B — Konfigurimi Teknik
- [x] B-01: `pubspec.yaml` version: `2.0.0+1` ✅
- [ ] B-02: `fvm flutter build appbundle --release` — verifiko AAB
- [ ] B-03: Content Rating Questionnaire në Play Console
- [ ] B-04: Data Safety Form në Play Console
- [ ] B-05: Target Audience — "Children and Families" me PIN-verifikimi prindi

### Track C — QA Final
- [ ] C-01: Smoke test mbi pajisje fizike Android — onboarding → sfidë → arritje → cloud sync
- [ ] C-02: Flows Firebase Auth: regjistrim, hyrje, dalje, fshirje llogarie
- [ ] C-03: Verifikimi `PrivacyPolicyScreen` dhe `ConsentFlowScreen` — tekstet shqip korrekte
- [ ] C-04: `fvm flutter test` 141/141 ✅ — zero regresione

---

*Skedar i krijuar automatikisht gjatë Sprint 13 — v2.0.0+1 — 19 Maj 2026*
