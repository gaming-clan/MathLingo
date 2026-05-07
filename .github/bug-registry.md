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
| B007 | `_processImage()` ishte vetëm placeholder, pa OCR real | **Lartë** | Fixed | Gamify Feature |

## Open / Monitor

| ID | Përshkrimi | Severiteti | Statusi | Sektori |
| :--- | :--- | :--- | :--- | :--- |
| - | - | - | - | - |

---
**Legjenda:**
- **Fixed:** E adresuar dhe e verifikuar në degën aktuale të zhvillimit.
- **Monitor:** Kërkon verifikim në mjedise ose platforma specifike.
- **Bllokues:** Build dështon plotësisht.
- **Kritik:** Logjika matematikore/pedagogjike është e gabuar.
- **Mesatar:** Probleme vizuale ose borxh teknik.