# miniui

Un paquete de componentes UI para Flutter con sistema de temas basado en [shadcn/ui](https://ui.shadcn.com/).

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Instalación

```yaml
dependencies:
  miniui:
    git:
      url: https://github.com/AlexMuguerza/mini_ui_flutter.git
```

## Uso rápido

```dart
import 'package:miniui/miniui.dart';

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

## Componentes

| Componente | Descripción |
|---|---|
| `MinButton` | Botón con variantes (primary, secondary, outline, ghost), tamaños, loading, disabled |
| `MinCard` | Tarjeta con fondo, borde y sombra del tema |
| `MinSelect<T>` | Selección tipada con searchable, secciones, leading/trailing |
| `MinDatePicker` | Selector de fecha con calendario mensual y selector de meses |
| `MinInput` | Campo de texto con tipos semánticos, variantes, leading/trailing |
| `MinSwitch` | Interruptor toggle con tamaños y loading state |
| `MinCheckbox` | Checkbox con tamaños e icono personalizable |
| `MinAppBar` | Barra de aplicación con leading, title, trailing |
| `MinScaffold` | Andamiaje de página con appBar, FAB, drawers |
| `MinDrawer` | Drawer start/end con gestos, overlay, modo persistent |
| `MinPopover` | Contenedor flotante anclado con contenido custom |

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
flutter test                 # Ejecutar tests (95 tests)
cd example && flutter run    # Ejecutar app de demo
```

## Tests

```bash
flutter test                 # Todos los tests
flutter test test/min_select_test.dart  # Tests de un componente
```

## Licencia

MIT License - ver [LICENSE](LICENSE) para más detalles.
