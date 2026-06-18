# mini_ui_flutter

Un paquete de componentes UI para Flutter con sistema de temas basado en [shadcn/ui](https://ui.shadcn.com/).

[![pub package](https://img.shields.io/pub/v/mini_ui_flutter.svg)](https://pub.dev/packages/mini_ui_flutter)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Demo 
[![demo](https://img.shields.io/badge/demo-online-blue)](https://alexmuguerza.github.io/mini_ui_flutter)

## Instalación via pub.dev

```yaml
dependencies:
  mini_ui_flutter: ^1.1.0
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
| `MinDrawer` | Drawer start/end con gestos, overlay, modo persistente, Escape para cerrar |
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
│   ├── min_button.dart
│   ├── min_button_group.dart
│   ├── min_card.dart
│   ├── min_select.dart
│   ├── min_date_picker.dart
│   ├── min_input.dart
│   ├── min_switch.dart
│   ├── min_checkbox.dart
│   ├── min_app_bar.dart
│   ├── min_scaffold.dart
│   ├── min_drawer.dart
│   └── min_popover.dart
└── resources/min_floating/      # Primitivas de overlay (interno)
```

## Desarrollo

```bash
flutter pub get              # Instalar dependencias
flutter analyze              # Lint + análisis estático
flutter test                 # Ejecutar tests (122 tests)
cd example && flutter run    # Ejecutar app de demo
```

## Licencia

MIT License - ver [LICENSE](LICENSE) para más detalles.
