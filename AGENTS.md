# AGENTS.md

## Quick Commands

```bash
flutter pub get              # Install dependencies (run first after clone)
flutter analyze              # Lint + static analysis (flutter_lints via analysis_options.yaml)
flutter test                 # Run tests (95 tests across 10 files)
cd example && flutter run    # Run the demo app (depends on parent via path: ..)
```

No separate lint, format, or typecheck commands. `flutter analyze` covers all static checks.

## Project

Single Flutter package. Not a monorepo. No CI, no pre-commit hooks, no task runners, no code generation.

- **SDK**: Flutter >=1.17.0, Dart ^3.11.1
- **Lint**: `flutter_lints ^6.0.0` (rules in `analysis_options.yaml` at root)
- **Tests**: 95 tests across 10 files in `test/`. Run with `flutter test`.

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
│   ├── min_button.dart       # MinButton — variant/size enums, keyboard support, loading state
│   ├── min_select.dart       # MinSelect<T> — typed selection with searchable, sections, leading/trailing
│   ├── min_date_picker.dart  # MinDatePicker — month grid selector, "Hoy" and "Meses" toggle
│   ├── min_popover.dart      # MinPopover, MinPopoverAnchor
│   ├── min_switch.dart       # MinSwitch
│   ├── min_checkbox.dart     # MinCheckbox
│   ├── min_app_bar.dart      # MinAppBar
│   ├── min_input.dart        # MinInput
│   ├── min_card.dart         # MinCard — default padding from theme, margin support
│   ├── min_scaffold.dart     # MinScaffold
│   └── min_drawer.dart       # MinDrawer, MinDrawerController
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

- **MinSelect search bug**: `_searchController` had no listener — typing in search didn't trigger `setState`, so filtered results never updated. Fix: added `_searchController.addListener(_handleSearchChanged)` in `initState`. Test: `searchable filters options as user types`.
- **MinSelect closure bug**: `_buildItems` captured `flatIndex` by reference in closures, causing `RangeError` when selecting options. Fix: `final index = flatIndex;` before closures.
- **MinDatePicker**: Month selector grid removed from header. Added "Meses" button next to "Hoy" at bottom. Toggling between calendar and month grid via `_showMonthSelector` state.
- **MinCard**: Added with default padding from `theme.spacing.s4`, margin support.
- **MinDrawer**: Added `drawerBackgroundColor`/`endDrawerBackgroundColor` params (default: `theme.colors.background`).
- **Example app**: Widgets extracted to `example/lib/presentation/app/widgets/`. AppSection class with TablerIcons. Theme toggle with transparent system UI.
- **AppViewState**: `selectedValue` split into `selectedValue` (simple), `selectedCountry` (searchable), `selectedAction` (leading/trailing) to avoid cross-variant state conflicts.
