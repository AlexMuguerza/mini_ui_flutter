# miniui
`miniui` es un paquete Flutter en fase inicial.

## V1 (estado actual implementado)
La v1 actualmente implementada incluye:
- Estructura base del paquete Flutter y export central en `lib/miniui.dart`.
- Sistema de tema/tokens en `lib/theme/tokens.dart` con tokens de shadcn/ui.
- Componentes UI en `lib/components`.
- Infraestructura de elementos flotantes en `lib/resources/miniui_floating`.

## Alcance funcional real de la v1 hoy
- API pública exportada:
  - **Theme**: `MinTheme`, `MinThemeData`, `MinColors`, `MinTypography`, `MinRadiusScale`, `MinSpacing`, `MinShadows`, `MinMotion`.
  - **Components**: `MinButton`, `MinCard`, `MinSelect`, `MinDatePicker`, `MinPopover`, `MinInput`, `MinSwitch`, `MinCheckbox`, `MinAppBar`, `MinScaffold`, `MinDrawer`.
  - **Resources**: `MinPortal`.
- Tokens de color (shadcn/ui naming):
  - `background` / `foreground` — fondo principal y texto.
  - `card` / `cardForeground` — superficies de tarjetas.
  - `popover` / `popoverForeground` — paneles flotantes (dropdowns, popovers).
  - `primary` / `primaryForeground` — acento principal.
  - `secondary` / `secondaryForeground` — variante secundaria.
  - `muted` / `mutedForeground` — fondos atenuados y texto secundario.
  - `accent` / `accentForeground` — estados hover y selección.
  - `destructive` / `destructiveForeground` — errores y acciones destructivas.
  - `border`, `input`, `ring` — bordes, inputs y rings de foco.
- Variantes de estilo para `MinInput`: `outline`, `filled`, `ghost`, `underline`.
- Componentes implementados:
  - `MinButton`: variantes (`primary`, `secondary`, `outline`, `ghost`), tamaños (`sm`, `md`, `lg`), estados hover/pressed/focus, loading, disabled y soporte de teclado.
  - `MinCard`: tarjeta reutilizable con tokens `card`/`cardForeground`, usada en `MinPopover`, `MinSelect` y `MinDatePicker`.
  - `MinSelect<T>`: selección tipada con opciones habilitadas/deshabilitadas, navegación por teclado, menú flotante (usa tokens `popover`/`accent`).
  - `MinDatePicker`: selector de fecha con límites (`firstDate`/`lastDate`), navegación por mes/año, selección de día y cierre automático del panel (usa tokens `card`/`accent`).
  - `MinPopover`: contenedor flotante anclado con contenido custom, usa tokens `popover`/`popoverForeground`.
  - `MinInput`: campo de texto con tipos semánticos (`text`, `email`, `password`, `number`, `phone`, `url`, `multiline`), variantes de estilo intercambiables, leading/trailing widgets, mensajes de error, y estados disabled/readOnly.
  - `MinSwitch`: interruptor toggle con soporte de teclado, tamaños (`sm`, `md`, `lg`), loading state.
  - `MinCheckbox`: checkbox con toggle, tamaños (`sm`, `md`, `lg`), icono personalizable.
  - `MinAppBar`: barra de aplicación con `leading`, `title`, `trailing`, tamaños (`sm`, `md`, `lg`), elevación y centerTitle.
  - `MinScaffold`: andamiaje de página con `appBar`, `floatingActionButton`, `bottomNavigationBar` y soporte de drawers.
  - `MinDrawer`: layout con drawer start/end, gestos de borde, overlay, modo persistent en pantallas anchas, y `MinDrawerController`.
- Recursos/infraestructura implementados:
  - Sistema de anclaje y posicionamiento (`MinUiAnchorSide`, `MinAnchorTarget`, `MinAnchorFollower`, `MinSizeObserver`).
  - Base compartida para flotantes (`MinFloatingBase`, `MinFloatingAnimation`).
  - Configuración global de flotantes (`MinFloatingDefaults`, `MinFloatingConfig`).
  - Controlador de visibilidad (`MinFloatingController`).
  - Barrera de overlay (`MinOverlayBarrier`).
  - Portal hacia `Overlay` (`MinPortal`).

## Uso rápido

```dart
import 'package:miniui/miniui.dart';

// Envolver la app con MinTheme
MinTheme(
  data: MinThemeData.light(), // o MinThemeData.dark()
  child: MyApp(),
)

// Usar tokens de color en componentes
final colors = context.theme.colors;
Container(color: colors.card) // fondo de tarjeta
Text('Hola', style: TextStyle(color: colors.cardForeground))
```

## Estado
La v1 ya cuenta con un núcleo funcional de tema, componentes base y primitives de overlay/floating listas para uso y extensión.
