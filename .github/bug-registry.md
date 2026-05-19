# 🐞 Regjistri i Bug-eve

## Fixed

| ID | Përshkrimi | Severiteti | Statusi | Sektori |
| :--- | :--- | :--- | :--- | :--- |
| B001 | Tabelat e zbritjes shfaqnin rezultate negative (p.sh 2-9=-7) | **Kritik** | Fixed | `simple_tables.dart` |
| B002 | Tabelat e pjesëtimit përdornin `~/` (p.sh 12/5=2) | **Kritik** | Fixed | `simple_tables.dart` |
| B003 | SnackBar mbivendoste BottomNavigationBar | **Mesatar** | Fixed | UI Global |
| B004 | SDK Mismatch (Local 3.32 vs Project 3.41) | **Bllokues** | Fixed | Environment |
| B005 | AAPT2 / toolchain mismatch në build release | **Bllokues** | Fixed | Build System |
| B008 | Dashboard body nuk renderohej për shkak të sizing-ut të BottomNavigation | **Kritik** | Fixed | Dashboard UI |
| B006 | Tekstet ishin hardcoded në ekranet finale të Sprint 3 | **Mesatar** | Fixed | Localization |
| B007 | OCR `_processImage()` ishte placeholder; tani implementuar me fallback pipeline + preprocessing. Handwriting (blocks=0) mbetet kufizim i njohur i ML Kit. | **Lartë** | Fixed / Monitor | `gamify_exercise.dart` |
| B008 | Dashboard body nuk renderohej për shkak të sizing-ut të BottomNavigation | **Kritik** | Fixed | Dashboard UI |
| B009 | `_ActionTile` quick-actions shkaktonte `RenderFlex overflowed by 6.1px` në viewport të ngushtë | **Mesatar** | Fixed | `dashboard_screen.dart` |
| B010 | `replaceAll` me capture groups Dart nuk interpolonte `$1` — konvertimi `a2→a^2` ishte i gabuar | **Lartë** | Fixed | `gamify_exercise.dart` |
| B012 | `hintText` i fushave PIN kishte opacitet shumë të lartë — dukej si tekst i plotë, jo si ndihmë | **Mesatar** | Fixed | `parent_pin_dialog.dart` |
| B013 | `FractionChallengeScreen` shfaqte vlerën numerike `numerator/denominator` poshtë vizualizimit — zbulonte përgjigjen para se fëmija ta zgjidhte | **Kritik** | Fixed | `fraction_challenge_screen.dart` |
| B014 | `BadgeDisplayScreen` GridView kishte `childAspectRatio: 0.85` dhe emoji `fontSize: 34` — kartat ishin tepër të mëdha dhe shthurosur në mobile | **Mesatar** | Fixed | `badge_display_screen.dart` |
| B-01 (S11.5) | Shumëzim Invers: `equationText` shfaqte `?÷n=tableNum` (gabim), `badgeSymbol` ishte `÷`, rrethi tregonte product jo `selectedTable` | **Kritik** | Fixed | `simple_tables.dart` |
| B-02 (S11.5) | Pjesëtim Invers: `equationText` shfaqte `?×n=tableNum` (gabim), entries gjenerohin si shumëfisha ekzaktë jo si 10 hyrje, rrethi tregonte `result` jo divisorin | **Kritik** | Fixed | `simple_tables.dart` |
| B-03 (S11.5) | Mbledhja tab kalonte `isInverseMode: false` hardcoded — toggle nuk kishte efekt tek mbledhja | **Kritik** | Fixed | `simple_tables.dart` |
| B-04 (S11.5) | `BadgeNotificationOverlay` — `FilledButton` me sfond `#F3D6FF` kontrast ~1.36:1 (nën WCAG AA 4.5:1) | **Mesatar** | Fixed | `badge_notification_overlay.dart` |
| B-05 (S11.5) | Kartat e tabelave — `padding: 0` brenda Container; teksti ngjitej me bordurin e kartës | **Mesatar** | Fixed | `simple_tables.dart` |

## Open / Monitor

| ID | Përshkrimi | Severiteti | Statusi | Sektori |
| :--- | :--- | :--- | :--- | :--- |
| B011 | OCR nuk njeh shkrimin dore (ML Kit `blocks=0`) — kufizim i recognizer-it, jo infrastrukturës | **Mesatar** | Monitor | `gamify_exercise.dart` |
| B015 | Firebase Auth (`Email/Password`) duhet aktivizuar manualisht në Firebase Console para se `AuthService.signUp/signIn` të funksionojë në runtime | **Mesatar** | Fixed | Firebase Console |
| B016 | `ios/Runner/GoogleService-Info.plist` mungon nga repo — iOS build nuk inicializon Firebase | **Mesatar** | Deferred | iOS Build |

---
**Legjenda:**
- **Fixed:** E adresuar dhe e verifikuar në degën aktuale të zhvillimit.
- **Monitor:** Kërkon verifikim në mjedise ose platforma specifike.
- **Bllokues:** Build dështon plotësisht.
- **Kritik:** Logjika matematikore/pedagogjike është e gabuar.
- **Mesatar:** Probleme vizuale ose borxh teknik.