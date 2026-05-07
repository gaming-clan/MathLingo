# 🎨 Specifikimet e Temës: Cosmic Dark

## 1. Filozofia e Dizajnit
MathLingo përdor stilin **Cosmic Dark** me elemente **Glassmorphism**. Synimi është krijimi i një mjedisi futuristik, miqësor dhe me kontrast të lartë që inkurajon fokusin te matematika.

## 2. Paleta e Ngjyrave (Hex)
| Kategoria | Ngjyra | Kodi | Roli |
| :--- | :--- | :--- | :--- |
| **Background** | Deep Space | `#101126` | Sfondi global i aplikacionit |
| **Surface** | Nebula Blue | `#1D1E33` | Kartat kryesore dhe panelet |
| **Primary** | Magenta Neon | `#BC13FE` | Butonat kryesorë (CTA), Akcentet |
| **Secondary** | Cyan Neon | `#00EEFC` | Akcentet sekondare, Sfida e ditës |
| **Tertiary** | Deep Magenta | `#D700C1` | Gradientet e butonave |
| **Text High** | Pure White | `#FFFFFF` | Teksti kryesor |
| **Text Low** | Soft Lavender| `#EEEBFF` | Teksti dytësor / përshkrues |
| **Error** | Coral Red | `#FFB4AB` | Feedback për gabimet |

## 3. Tipografia
- **Fonti:** System Default (Shtresa Material 3).
- **Headlines:** `W800` për titujt kryesorë, `W700` për titujt e seksioneve.
- **Body:** `W400` për tekste shpjeguese.
- **Scaling:** Përdor `AdaptiveLayout.scaleFontSize` (1.1x për Tablet, 1.2x për Large Tablet).

## 4. Komponentët Shared (Specifikat)
### A. GlassPanel
- **Blur:** 10-15 (BackdropFilter).
- **Border:** 1px solid, opacitet 12% i bardhë.
- **Gradient:** Linear (8% white -> 68% surface -> 2% white).
- **Radius:** 32px.

### B. CosmicButton
- **Gradient:** Linear (`primaryContainer` -> `tertiaryContainer`).
- **Shape:** StadiumBorder (Ovale).
- **Elevation:** 0 (përdor BoxShadow neon 12-38% opacitet).

### C. Mascot (Stitch)
- **Madhësia:** Adaptive (170px deri 280px).
- **Gjendjet:** Idle, Joy (Celebration), Thinking.