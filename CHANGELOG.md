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

### Accessibility
- Semantics on all interactive components
- Full keyboard navigation (Tab, Enter, Space, Escape, Arrow keys)
- MouseRegion with cursor changes on web/desktop
- Focus management with visible focus rings
