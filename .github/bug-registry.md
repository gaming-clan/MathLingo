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

## Open / Monitor

| ID | Përshkrimi | Severiteti | Statusi | Sektori |
| :--- | :--- | :--- | :--- | :--- |
| B011 | OCR nuk njeh shkrimin dore (ML Kit `blocks=0`) — kufizim i recognizer-it, jo infrastrukturës | **Mesatar** | Monitor | `gamify_exercise.dart` |

---
**Legjenda:**
- **Fixed:** E adresuar dhe e verifikuar në degën aktuale të zhvillimit.
- **Monitor:** Kërkon verifikim në mjedise ose platforma specifike.
- **Bllokues:** Build dështon plotësisht.
- **Kritik:** Logjika matematikore/pedagogjike është e gabuar.
- **Mesatar:** Probleme vizuale ose borxh teknik.