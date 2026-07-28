# AGENTS.md

## Quick Commands

```bash
flutter pub get              # Install dependencies (run first after clone)
flutter analyze              # Lint + static analysis (flutter_lints via analysis_options.yaml)
flutter test                 # Run tests (184 tests across 22 files)
cd example && flutter run    # Run the demo app (depends on parent via path: ..)
```

No separate lint, format, or typecheck commands. `flutter analyze` covers all static checks.

## Project

Single Flutter package. Not a monorepo. No CI, no pre-commit hooks, no task runners, no code generation.

- **SDK**: Flutter >=1.17.0, Dart ^3.11.1
- **Lint**: `flutter_lints ^6.0.0` (rules in `analysis_options.yaml` at root)
- **Tests**: 184 tests across 22 files in `test/`. Run with `flutter test`.

## Structure

```
lib/
├── miniui.dart               # Single public export barrel — all API goes through here
├── theme/
│   ├── tokens.dart           # Re-exports all theme modules
│   ├── theme.dart            # MinTheme (InheritedWidget), MinThemeData, context.theme extension
│   ├── colors.dart           # MinColors (zinc, zincDark, slate, slateDark palettes)
│   ├── typography.dart       # MinTypography
│   ├── spacing.dart          # MinSpacing
│   ├── radius.dart           # MinRadiusScale
│   ├── shadows.dart          # MinShadows
│   └── motion.dart           # MinMotion
├── components/               # UI widgets (all read theme from BuildContext)
│   ├── min_button/           # MinButton — variant/size enums, keyboard, loading
│   ├── min_button_group/     # MinButtonGroup<T> — selection group, arrow-key nav
│   ├── min_card.dart         # MinCard — default padding from theme, margin support
│   ├── min_accordion.dart    # MinAccordion<T> — single/multiple modes
│   ├── min_badge.dart        # MinBadge, MinBadgeWrapper, MinBadgePosition
│   ├── min_checkbox/         # MinCheckbox — sm/md/lg, custom icon
│   ├── min_date_picker/      # MinDatePicker — month grid, "Hoy" + "Meses" toggle
│   ├── min_drawer/           # MinDrawer, MinDrawerController
│   ├── min_input/            # MinInput — types, variants, outline/filled/ghost; MinFormInput FormField wrapper
│   ├── min_popover.dart      # MinPopover, MinPopoverAnchor
│   ├── min_progress/         # MinProgress — linear & circular, determinate/indeterminate
│   ├── min_scaffold.dart     # MinScaffold
│   ├── min_select/           # MinSelect<T> — searchable, sections, leading/trailing
│   ├── min_switch.dart       # MinSwitch
│   ├── min_app_bar.dart      # MinAppBar
│   ├── min_tabs/             # MinTabs<T> — underline & pill variants
│   ├── min_toast/            # MinToast — overlay notifications, queue, timer
│   └── min_tooltip.dart      # MinTooltip — hover/long-press floating
└── resources/min_floating/   # Floating/overlay primitives (internal)
    ├── min_portal.dart       # MinPortal (only resource exported publicly)
    ├── min_floating_base.dart
    ├── min_floating_controller.dart
    ├── min_floating_config.dart
    ├── min_anchor.dart
    └── min_overlay_barrier.dart
example/                      # Demo Flutter app
```

## Key Conventions

- **Theme access**: Components use `context.theme` (extension on `BuildContext`) which calls `MinTheme.of(context)`. MinTheme is an `InheritedWidget`.
- **Style resolution**: Components use private `_*Style.resolve()` pattern to compute visual properties from theme + interaction state.
- **Naming**: All public types prefixed with `Min`. Private implementation types prefixed with `_Min` or `_`.
- **Exports**: Every new public type must be added to `lib/miniui.dart` with an explicit `show` clause. `lib/theme/tokens.dart` re-exports all theme modules.
- **Color palettes**: `MinColors` has 4 built-in palettes (zinc, zincDark, slate, slateDark). Light defaults to zinc, dark to zincDark.
- **Example app**: Uses `flutter_bloc`, `go_router`, `flutter_tabler_icons`. Depends on the parent package via `path: ..` in `example/pubspec.yaml`.
- **Language**: README and some comments are in Spanish. Follow the existing language style when editing prose in those files.

## Recent Changes

- **MinFormInput**: `FormField<String>` wrapper around `MinInput` with controller, initialValue, validator, autovalidateMode, forceErrorText, onChanged, onSubmitted, onSaved, reset, enabled, leading/trailing, multiline, maxLength, inputFormatters, focusNode, and 37 tests.
- **New components**: MinTabs, MinBadge/MinBadgeWrapper, MinAccordion added to the public API and registered in the demo app (Badges, Tabs, Accordion views).
- **MinToast**: global overlay manager with swipe-to-dismiss, hover-pause timer, per-position maxVisible. Variant simplified to floating only.
- **MinProgress / MinTooltip**: linear/circular progress indicators and hover/long-press tooltip with floating infrastructure.
- **Localization**: MinLocalizations InheritedWidget with built-in es/en and partial overrides via `MinLocale`.
- **MinSelect search bug**: fixed missing listener on `_searchController`.
- **MinSelect closure bug**: `_buildItems` captured `flatIndex` by reference; resolved with `final index = flatIndex;` before closures.
- **Demo app**: extracted into `example/lib/presentation/app/widgets/`, transparent system UI (edgeToEdge), theme variants Zinc/Slate/Violet toggled from Settings.
