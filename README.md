# mini_ui_flutter

Un paquete de componentes UI para Flutter con sistema de temas basado en [shadcn/ui](https://ui.shadcn.com/).

[![pub package](https://img.shields.io/pub/v/mini_ui_flutter.svg)](https://pub.dev/packages/mini_ui_flutter)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Demo 
[![demo](https://img.shields.io/badge/demo-online-blue)](https://alexmuguerza.github.io/mini_ui_flutter)

### Vistazos
<img width="337" height="737" alt="image" src="https://github.com/user-attachments/assets/1551a064-9953-4af7-a01e-815f87300bc7" />
<img width="336" height="737" alt="image" src="https://github.com/user-attachments/assets/6332c930-c07e-4017-8bb8-8199cb088d81" />
<img width="336" height="737" alt="WhatsApp Image 2026-06-23 at 7 41 30 PM" src="https://github.com/user-attachments/assets/75e32f89-91a8-40c4-af31-62627da4f8c8" />


## Instalación via pub.dev

```yaml
dependencies:
  mini_ui_flutter: ^1.2.0
```

```bash
flutter pub get
```

## Instalación via github

```yaml
dependencies:
  mini_ui_flutter: 
    git:
      url: https://github.com/AlexMuguerza/mini_ui_flutter.git
```

```bash
flutter pub get
```

## Uso rápido

```dart
import 'package:mini_ui_flutter/miniui.dart';

// Envolver la app con MinTheme
MinTheme(
  data: MinThemeData.light(), // o MinThemeData.dark()
  child: MyApp(),
)

// Usar tokens de color
final colors = context.theme.colors;
Container(color: colors.card)
Text('Hola', style: TextStyle(color: colors.cardForeground))
```

## Localización

```dart
import 'package:mini_ui_flutter/miniui.dart';

// Envolver la app con MinLocalizations
MinLocalizations(
  locale: const Locale('es'), // o Locale('en')
  child: MinTheme(
    data: MinThemeData.light(),
    child: MyApp(),
  ),
)

// Usar en componentes
final locale = context.minLocale;
locale.selectPlaceholder;       // "Seleccionar..." (es) / "Select..." (en)
locale.datePlaceholder;         // "Seleccionar fecha" (es) / "Select date" (en)
locale.closeDrawerLabel;        // "Cerrar menú" (es) / "Close menu" (en)
locale.months;                  // ["Enero", ...] / ["January", ...]
locale.dayHeaders;              // ["L", "M", ...] / ["M", "T", ...]

// Sobrescribir strings parcialmente
MinLocalizations(
  locale: const Locale('es'),
  overrides: MinLocale.es.copyWith(
    selectPlaceholder: 'Elige una opción',
  ),
  child: MyApp(),
)
```

## Componentes

| Componente | Descripción |
|---|---|
| `MinButton` | Botón con variantes (primary, secondary, outline, ghost), tamaños, loading, disabled, borderRadius |
| `MinButtonGroup<T>` | Grupo de botones con selección completa, navegable por teclado (flechas/enter/espacio) |
| `MinCard` | Tarjeta con fondo, borde, sombra y padding del tema |
| `MinSelect<T>` | Selección tipada con searchable, secciones, leading/trailing |
| `MinDatePicker` | Selector de fecha con calendario mensual y selector de meses |
| `MinInput` | Campo de texto con tipos semánticos, variantes, leading/trailing, showCounter |
| `MinSwitch` | Interruptor toggle con tamaños, semanticLabel |
| `MinCheckbox` | Checkbox con tamaños, icono personalizable, semanticLabel |
| `MinAppBar` | Barra de aplicación con leading, title, trailing |
| `MinScaffold` | Andamiaje de página con appBar, FAB, drawers, resizeToAvoidBottomInset |
| `MinToast` | Sistema de notificaciones toast animadas con auto-close, timer bar, colas por posición |
| `MinDrawer` | Drawer start/end con `MinDrawerController`, gestos, overlay, modo persistente, Escape |
| `MinPopover` | Contenedor flotante anclado con contenido custom |
| `MinProgress` | Indicador de progreso linear y circular, determinable e indeterminable |
| `MinTooltip` | Tooltip flotante con hover, delay configurable, posicionamiento automático |

## Accesibilidad

Todos los componentes interactivos incluyen:

- **Semantics**: Labels descriptivos para lectores de pantalla
- **Focus**: Navegación completa por teclado (Tab, Enter, Espacio, Flechas)
- **MouseRegion**: Cursor interactivo en web/desktop
- **Keyboard shortcuts**: Enter/Espacio para activar, Escape para cerrar, Flechas para navegar

## Tema

### Tokens de color (shadcn/ui)

| Token | Uso |
|---|---|
| `background` / `foreground` | Fondo principal y texto |
| `card` / `cardForeground` | Superficies de tarjetas |
| `popover` / `popoverForeground` | Paneles flotantes |
| `primary` / `primaryForeground` | Acento principal |
| `secondary` / `secondaryForeground` | Variante secundaria |
| `muted` / `mutedForeground` | Fondos atenuados |
| `accent` / `accentForeground` | Estados hover/selección |
| `destructive` / `destructiveForeground` | Errores/acciones destructivas |
| `border`, `input`, `ring` | Bordes, inputs, rings de foco |

### Acceso al tema

```dart
final theme = context.theme;
final colors = theme.colors;
final typography = theme.typography;
final spacing = theme.spacing;
final radius = theme.radius;
```

## Estructura

```
lib/
├── miniui.dart                  # Barrel export
├── locals/                      # Localización
│   ├── min_locale.dart          # MinLocale con strings es/en
│   └── min_localizations.dart   # MinLocalizations InheritedWidget
├── theme/                       # Sistema de temas
│   ├── colors.dart              # Paletas zinc/zincDark/slate/slateDark
│   ├── typography.dart          # Escala tipográfica
│   ├── spacing.dart             # Escala de espaciado
│   ├── radius.dart              # Escala de bordes
│   ├── shadows.dart             # Sombras sm/md/lg/xl/xl2
│   ├── motion.dart              # Animaciones
│   └── theme.dart               # MinTheme, MinThemeData
├── components/                  # Widgets UI
│   ├── min_app_bar.dart
│   ├── min_button/              # MinButton, MinButtonStyle, MinButtonSpinner
│   ├── min_button_group/        # MinButtonGroup, MinButtonGroupButton
│   ├── min_card.dart
│   ├── min_checkbox/            # MinCheckbox, MinCheckboxStyle, MinCheckboxPainter
│   ├── min_date_picker/         # MinDatePicker, panel, trigger, cells, months, years
│   ├── min_drawer/              # MinDrawer, MinDrawerController
│   ├── min_input/               # MinInput, MinInputStyle
│   ├── min_popover.dart
│   ├── min_progress/            # MinProgress, Linear, Circular
│   ├── min_scaffold.dart
│   ├── min_select/              # MinSelect, Floating, OptionTile, Chevron
│   ├── min_switch.dart
│   ├── min_toast/               # MinToast, Type, Action, Position, Item, Entry
│   └── min_tooltip.dart
└── resources/min_floating/      # Primitivas de overlay (interno)
```

## Desarrollo

```bash
flutter pub get              # Instalar dependencias
flutter analyze              # Lint + análisis estático
flutter test                 # Ejecutar tests (128 tests)
cd example && flutter run    # Ejecutar app de demo
```

## Licencia

MIT License - ver [LICENSE](LICENSE) para más detalles.
