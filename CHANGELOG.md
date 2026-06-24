## 1.2.0

### Components
- `MinToast` — sistema de notificaciones toast con overlay global, auto-close, timer bar, pausa al hover, swipe para descartar, colas por posición, máx. visibles por grupo
- `MinDrawer` — componente extraído de `MinScaffold` como widget independiente con `MinDrawerController`

### Refactor
- Componentes grandes divididos en subdirectorios con `part`/`part of` para mejorar mantenibilidad
- `MinToastVariant` simplificado: solo `floating` (se eliminó `fixed`)

### Fixes
- `MinToast` — timer bar se reiniciaba al aparecer un segundo toast porque el árbol de widgets cambiaba de `AnimatedOpacity` a `AbsorbPointer`. Solución: `AbsorbPointer(absorbing: index > 0)` incondicional
- `MinToast` — fórmula `remainingDuration` estaba invertida (devolvía elapsed en lugar de remaining)
- `MinSelect` — búsqueda no filtraba porque faltaba listener en `_searchController`
- `MinSelect` — `RangeError` al seleccionar opciones por captura incorrecta de `flatIndex` en closures

### Tests
- `min_toast_test.dart` — 11 tests
- Total: 128 tests (+6)

## 1.1.0

### Components
- `MinButton` — altura fija cambiada a altura mínima (`BoxConstraints(minHeight:)`) para soportar contenido multilínea
- `MinProgress` — indicador de progreso con variantes `linear` y `circular`, ambos soportan modo determinable (valor 0.0–1.0) e indeterminable (null), animaciones, colores personalizables
- `MinTooltip` — tooltip flotante que aparece al hacer hover, usa sistema de floating (overlay + posicionamiento automático), delay configurable, hereda el tema

### Fixes
- `MinTooltip` — web hover no funcionaba por `AbsorbPointer` en el overlay barrier. Cambiado `closeOnTapOutside: false` para evitar que el barrier absorba el hit test y dispare `onExit` del `MouseRegion`
- Dartdocs agregados a `MinProgressVariant`, `MinProgress` y `MinTooltip`

### Example app
- `theme_palettes.dart`: paletas personalizadas con `MinColors` (`SlatePalette` y `VioletPalette`)
- `AppCubit` ahora maneja `ThemeVariant` enum con `setThemeVariant()`
- `SettingsView`, `ProgressView`, `TooltipView` — nuevas vistas demo
- Ancho máximo de la app limitado a 1024px centrado para web

### CI/CD
- `.github/workflows/deploy.yml` — build web del example + deploy a GitHub Pages

### README
- Badge de demo online agregado

### Tests
- `min_progress_test.dart` — 8 tests
- `min_tooltip_test.dart` — 5 tests
- Total: 122 tests (+13)

## 1.0.0

Initial release.

### Theme system
- `MinTheme` InheritedWidget with `MinThemeData`
- Color tokens based on shadcn/ui (zinc, zincDark, slate, slateDark palettes)
- Typography, spacing, radius, shadows, and motion scales
- `context.theme` extension for easy access

### Components
- `MinButton` — primary/secondary/outline/ghost variants, sm/md/lg sizes, loading state, borderRadius
- `MinButtonGroup<T>` — generic controlled group with arrow key navigation, Enter/Space activation
- `MinCard` — theme-aware card with padding, margin, background, border, shadow
- `MinSelect<T>` — typed selection with searchable, sections, leading/trailing, keyboard navigation
- `MinDatePicker` — month grid calendar, "Hoy" and "Meses" toggle, full Semantics
- `MinInput` — text/email/password/number/phone/url/multiline types, outline/filled/ghost/underline styles, leading/trailing, showCounter, error state
- `MinSwitch` — toggle with sm/md/lg sizes, semanticLabel
- `MinCheckbox` — check with sm/md/lg sizes, custom icon/painter, semanticLabel
- `MinAppBar` — app bar with sm/md/lg sizes, leading/title/trailing
- `MinScaffold` — page layout with appBar, body, FAB, bottomBar, drawers, resizeToAvoidBottomInset
- `MinDrawer` — start/end drawers with gestures, overlay, persistent mode, Escape to close, drawerLabel/endDrawerLabel
- `MinPopover` — floating anchored container with close on tap outside, Escape, scroll

### Localization
- `MinLocalizations` InheritedWidget with `MinLocale`
- Built-in `MinLocale.es` (Spanish) and `MinLocale.en` (English)
- `context.minLocale` extension for easy access
- Partial overrides via `overrides:` parameter
- All user-facing strings in `MinDatePicker`, `MinSelect`, and `MinDrawer` use locale

### Accessibility
- Semantics on all interactive components
- Full keyboard navigation (Tab, Enter, Space, Escape, Arrow keys)
- MouseRegion with cursor changes on web/desktop
- Focus management with visible focus rings
- `semanticLabel` parameters on `MinButton`, `MinSwitch`, `MinCheckbox`, `MinInput`
- `drawerLabel`/`endDrawerLabel` on `MinDrawer`
