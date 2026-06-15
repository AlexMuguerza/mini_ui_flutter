import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../resources/min_floating/min_anchor.dart';
import '../resources/min_floating/min_floating_base.dart';
import '../resources/min_floating/min_floating_controller.dart';
import '../theme/tokens.dart';
import 'min_card.dart';
import 'min_input.dart';

enum MinSelectSize { sm, md, lg }

/// Mark an item in [MinSelect.options] as either a concrete [MinSelectOption]
/// or a section header [MinSelectSection].
sealed class MinSelectItem<T> {
  const MinSelectItem();
}

/// A concrete option inside a [MinSelect] dropdown.
class MinSelectOption<T> extends MinSelectItem<T> {
  const MinSelectOption({
    required this.value,
    required this.label,
    this.enabled = true,
    this.leading,
    this.trailing,
  });

  final T value;
  final String label;
  final bool enabled;
  final Widget? leading;
  final Widget? trailing;
}

/// A non-selectable section header rendered inside the dropdown.
///
/// When the dropdown is searchable, sections are hidden while the user types.
class MinSelectSection<T> extends MinSelectItem<T> {
  const MinSelectSection({required this.label});

  final String label;
}

class MinSelect<T> extends StatefulWidget {
  const MinSelect({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.placeholder,
    this.size = MinSelectSize.md,
    this.disabled = false,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
    this.side,
    this.maxMenuHeight,
    this.menuWidth,
    this.icon,
    this.searchable = false,
    this.searchPlaceholder,
  });

  final List<MinSelectItem<T>> options;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String? placeholder;
  final MinSelectSize size;
  final bool disabled;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? semanticLabel;
  final MinUiAnchorSide? side;
  final double? maxMenuHeight;
  final double? menuWidth;
  final Widget? icon;

  /// When `true`, the dropdown shows a search input that filters options
  /// by their [MinSelectOption.label].
  final bool searchable;
  final String? searchPlaceholder;

  @override
  State<MinSelect<T>> createState() => _MinSelectState<T>();
}

class _MinSelectState<T> extends State<MinSelect<T>> {
  final MinFloatingController _controller = MinFloatingController();
  final GlobalKey _triggerKey = GlobalKey();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;
  int? _activeIndex;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleControllerChanged);
    _searchController.addListener(_handleSearchChanged);
  }

  bool get _enabled => !widget.disabled;

  List<MinSelectOption<T>> get _flatOptions =>
      widget.options.whereType<MinSelectOption<T>>().toList();

  MinSelectOption<T>? get _selectedOption {
    final value = widget.value;
    if (value == null) return null;
    for (final item in widget.options) {
      if (item is MinSelectOption<T> && item.value == value) {
        return item;
      }
    }
    return null;
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    _searchController.removeListener(_handleSearchChanged);
    _controller.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _handleControllerChanged() {
    if (!mounted) return;

    setState(() {
      if (!_controller.isOpen) {
        _activeIndex = null;
        _searchController.clear();
      }
    });

    if (_controller.isOpen && widget.searchable) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _searchFocusNode.requestFocus();
      });
    }
  }

  void _handleSearchChanged() {
    if (!mounted) return;
    setState(() {});
  }

  int? _selectedEnabledIndex() {
    final selected = _selectedOption;
    if (selected == null) return null;
    final flat = _flatOptions;
    for (var i = 0; i < flat.length; i++) {
      if (flat[i].enabled && flat[i].value == selected.value) return i;
    }
    return null;
  }

  int? _firstEnabledIndex(List<MinSelectOption<T>> list) {
    for (var i = 0; i < list.length; i++) {
      if (list[i].enabled) return i;
    }
    return null;
  }

  int? _nextEnabledIndex(int start, int delta, List<MinSelectOption<T>> list) {
    if (list.isEmpty) return null;
    final count = list.length;
    var idx = start;
    for (var i = 0; i < count; i++) {
      idx = (idx + delta) % count;
      if (idx < 0) idx += count;
      if (list[idx].enabled) return idx;
    }
    return null;
  }

  void _open() {
    if (!_enabled) return;
    final initial = _selectedEnabledIndex() ?? _firstEnabledIndex(_flatOptions);
    setState(() => _activeIndex = initial);
    _controller.show();
  }

  void _close() {
    setState(() => _activeIndex = null);
    _controller.hide();
  }

  void _toggle() {
    if (_controller.isOpen) {
      _close();
    } else {
      _open();
    }
  }

  void _selectOption(MinSelectOption<T> option) {
    if (!option.enabled || !_enabled) return;
    widget.onChanged(option.value);
    _close();
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (!_enabled) return KeyEventResult.ignored;
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.escape && _controller.isOpen) {
      _close();
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      if (_controller.isOpen && _activeIndex != null) {
        final flat = _flatOptions;
        if (_activeIndex! < flat.length) {
          _selectOption(flat[_activeIndex!]);
        }
      } else {
        _open();
      }
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (!_controller.isOpen) {
        _open();
      } else {
        final flat = _filteredOptions;
        final base = _activeIndex ?? _selectedEnabledIndex() ?? -1;
        final next = _nextEnabledIndex(base, 1, flat);
        if (next != null) setState(() => _activeIndex = next);
      }
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (!_controller.isOpen) {
        _open();
      } else {
        final flat = _filteredOptions;
        final base = _activeIndex ?? _selectedEnabledIndex() ?? 0;
        final next = _nextEnabledIndex(base, -1, flat);
        if (next != null) setState(() => _activeIndex = next);
      }
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  double? _triggerWidth() {
    final context = _triggerKey.currentContext;
    final render = context?.findRenderObject();
    if (render is RenderBox && render.hasSize) {
      return render.size.width;
    }
    return null;
  }

  List<MinSelectOption<T>> get _filteredOptions {
    if (!widget.searchable || _searchController.text.isEmpty) {
      return _flatOptions;
    }
    final query = _searchController.text.toLowerCase();
    return _flatOptions
        .where((o) => o.label.toLowerCase().contains(query))
        .toList();
  }

  List<MinSelectItem<T>> get _visibleItems {
    if (!widget.searchable || _searchController.text.isEmpty) {
      return widget.options;
    }
    return _filteredOptions;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final style = _MinSelectStyle.resolve(
      theme: theme,
      size: widget.size,
      enabled: _enabled,
      hovered: _hovered,
      pressed: _pressed,
      focused: _focused,
    );
    final selected = _selectedOption;
    final placeholder = widget.placeholder ?? 'Select...';

    final trigger = Semantics(
      button: true,
      enabled: _enabled,
      label: widget.semanticLabel,
      child: Focus(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        onFocusChange: (value) => setState(() => _focused = value),
        onKeyEvent: _onKeyEvent,
        child: MouseRegion(
          cursor:
              _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() {
            _hovered = false;
            _pressed = false;
          }),
          child: GestureDetector(
            key: _triggerKey,
            behavior: HitTestBehavior.opaque,
            onTap: _enabled ? _toggle : null,
            onTapDown: _enabled ? (_) => setState(() => _pressed = true) : null,
            onTapUp: _enabled ? (_) => setState(() => _pressed = false) : null,
            onTapCancel:
                _enabled ? () => setState(() => _pressed = false) : null,
            child: AnimatedContainer(
              duration: theme.motion.normal,
              curve: theme.motion.curve,
              height: style.height,
              padding: EdgeInsets.symmetric(horizontal: style.horizontalPadding),
              decoration: BoxDecoration(
                color: style.background,
                borderRadius: BorderRadius.circular(style.radius),
                border: Border.all(
                  color: style.border,
                  width: theme.spacing.px,
                ),
                boxShadow: style.shadows,
              ),
              child: Row(
                children: [
                  if (selected?.leading != null) ...[
                    selected!.leading!,
                    SizedBox(width: theme.spacing.s2),
                  ],
                  Expanded(
                    child: DefaultTextStyle(
                      style: selected == null
                          ? style.textStyle.copyWith(
                              color: theme.colors.mutedForeground,
                            )
                          : style.textStyle.copyWith(color: style.foreground),
                      overflow: TextOverflow.ellipsis,
                      child: Text(
                        selected?.label ?? placeholder,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  SizedBox(width: theme.spacing.s2),
                  AnimatedRotation(
                    duration: theme.motion.normal,
                    curve: theme.motion.curve,
                    turns: _controller.isOpen ? 0.5 : 0,
                    child: IconTheme(
                      data: IconThemeData(size: style.iconSize, color: style.foreground),
                      child: SizedBox(
                        width: style.iconSize,
                        height: style.iconSize,
                        child: widget.icon ??
                            CustomPaint(
                              painter: _ChevronPainter(color: style.foreground),
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return _MinSelectFloating<T>(
      controller: _controller,
      side: widget.side ?? const MinUiAnchorSide.below(),
      width: widget.menuWidth ?? _triggerWidth(),
      maxHeight: widget.maxMenuHeight,
      items: widget.options,
      filteredItems: _visibleItems,
      selectedValue: widget.value,
      activeIndex: _activeIndex,
      onActiveIndexChanged: (index) => setState(() => _activeIndex = index),
      onSelected: (flatIndex) {
        final option = _filteredOptions[flatIndex];
        _selectOption(option);
      },
      searchable: widget.searchable,
      searchController: _searchController,
      searchFocusNode: _searchFocusNode,
      searchPlaceholder: widget.searchPlaceholder,
      child: trigger,
    );
  }
}

// ---------------------------------------------------------------------------
// Floating panel
// ---------------------------------------------------------------------------

class _MinSelectFloating<T> extends MinFloatingBase {
  const _MinSelectFloating({
    required super.child,
    required super.controller,
    required this.items,
    required this.filteredItems,
    required this.selectedValue,
    required this.activeIndex,
    required this.onActiveIndexChanged,
    required this.onSelected,
    required this.searchable,
    required this.searchController,
    required this.searchFocusNode,
    required MinUiAnchorSide side,
    this.width,
    this.maxHeight,
    this.searchPlaceholder,
  }) : super(
         side: side,
         openOnTap: false,
         closeOnTapOutside: true,
         closeOnEscape: true,
         animation: MinFloatingAnimation.slideAndFade,
       );

  final List<MinSelectItem<T>> items;
  final List<MinSelectItem<T>> filteredItems;
  final T? selectedValue;
  final int? activeIndex;
  final ValueChanged<int?> onActiveIndexChanged;
  final ValueChanged<int> onSelected;
  final double? width;
  final double? maxHeight;
  final bool searchable;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final String? searchPlaceholder;

  @override
  Widget wrapOverlay(BuildContext anchorContext, Widget overlayChild) {
    final theme = MinTheme.maybeOf(anchorContext);
    if (theme == null) return overlayChild;
    return MinTheme(data: theme, child: overlayChild);
  }

  @override
  Widget buildContent(BuildContext context, MinFloatingController controller) {
    final theme = context.theme;
    final flatFiltered = filteredItems.whereType<MinSelectOption<T>>().toList();

    Widget panel = MinCard(
      padding: EdgeInsets.all(theme.spacing.px),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (searchable) ...[
            MinInput(
              controller: searchController,
              focusNode: searchFocusNode,
              placeholder: searchPlaceholder ?? 'Buscar...',
              leading: Icon(
                // Using a simple text icon to avoid importing tabler_icons
                // in the package. The consumer can override with a custom icon.
                // ignore: deprecated_member_use
                const IconData(0xe800, fontFamily: 'MaterialIcons'),
                size: 16,
              ),
              style: MinInputStyle.ghost(theme),
            ),
            SizedBox(height: theme.spacing.px),
          ],
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: maxHeight ?? theme.spacing.s12 * 4,
            ),
            child: SingleChildScrollView(
              primary: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _buildItems(context, flatFiltered),
              ),
            ),
          ),
        ],
      ),
    );

    if (width != null) {
      panel = SizedBox(width: width, child: panel);
    }

    return panel;
  }

  List<Widget> _buildItems(
    BuildContext context,
    List<MinSelectOption<T>> flatFiltered,
  ) {
    final theme = context.theme;
    final widgets = <Widget>[];
    var flatIndex = 0;

    for (final item in filteredItems) {
      if (item is MinSelectSection<T>) {
        if (widgets.isNotEmpty) {
          widgets.add(
            Container(
              height: 1,
              margin: EdgeInsets.symmetric(horizontal: theme.spacing.s2),
              color: theme.colors.border,
            ),
          );
        }
        widgets.add(
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: theme.spacing.s3,
              vertical: theme.spacing.s2,
            ),
            child: Text(
              item.label,
              style: theme.typography.small.copyWith(
                color: theme.colors.mutedForeground,
              ),
            ),
          ),
        );
      } else if (item is MinSelectOption<T>) {
        final index = flatIndex;
        final isSelected = item.value == selectedValue;
        final isActive = activeIndex == index;
        widgets.add(
          _MinSelectOptionTile<T>(
            option: item,
            isSelected: isSelected,
            isActive: isActive,
            onHover: () => onActiveIndexChanged(index),
            onTap: () => onSelected(index),
          ),
        );
        flatIndex++;
      }
    }

    return widgets;
  }
}

// ---------------------------------------------------------------------------
// Option tile
// ---------------------------------------------------------------------------

class _MinSelectOptionTile<T> extends StatefulWidget {
  const _MinSelectOptionTile({
    required this.option,
    required this.isSelected,
    required this.isActive,
    required this.onHover,
    required this.onTap,
  });

  final MinSelectOption<T> option;
  final bool isSelected;
  final bool isActive;
  final VoidCallback onHover;
  final VoidCallback onTap;

  @override
  State<_MinSelectOptionTile<T>> createState() =>
      _MinSelectOptionTileState<T>();
}

class _MinSelectOptionTileState<T> extends State<_MinSelectOptionTile<T>> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final enabled = widget.option.enabled;
    final highlighted = widget.isActive || _hovered;

    final background =
        highlighted ? theme.colors.accent : theme.colors.popover;
    final foreground =
        enabled ? theme.colors.popoverForeground : theme.colors.mutedForeground;

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) {
        setState(() => _hovered = true);
        if (enabled) widget.onHover();
      },
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? widget.onTap : null,
        child: AnimatedContainer(
          duration: theme.motion.fast,
          curve: theme.motion.curve,
          padding: EdgeInsets.symmetric(
            horizontal: theme.spacing.s3,
            vertical: theme.spacing.s2,
          ),
          color: background,
          child: Row(
            children: [
              if (widget.option.leading != null) ...[
                widget.option.leading!,
                SizedBox(width: theme.spacing.s2),
              ],
              Expanded(
                child: Text(
                  widget.option.label,
                  style: theme.typography.body.copyWith(color: foreground),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.option.trailing != null) ...[
                SizedBox(width: theme.spacing.s2),
                widget.option.trailing!,
              ],
              if (widget.isSelected) ...[
                SizedBox(width: theme.spacing.s2),
                Text(
                  '✓',
                  style: theme.typography.body.copyWith(
                    color: theme.colors.primary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Trigger style
// ---------------------------------------------------------------------------

class _MinSelectStyle {
  const _MinSelectStyle({
    required this.background,
    required this.foreground,
    required this.border,
    required this.textStyle,
    required this.shadows,
    required this.height,
    required this.horizontalPadding,
    required this.iconSize,
    required this.radius,
  });

  final Color background;
  final Color foreground;
  final Color border;
  final TextStyle textStyle;
  final List<BoxShadow> shadows;
  final double height;
  final double horizontalPadding;
  final double iconSize;
  final double radius;

  static _MinSelectStyle resolve({
    required MinThemeData theme,
    required MinSelectSize size,
    required bool enabled,
    required bool hovered,
    required bool pressed,
    required bool focused,
  }) {
    final background = !enabled
        ? theme.colors.muted
        : pressed
        ? theme.colors.accent
        : theme.colors.background;

    final foreground =
        enabled ? theme.colors.foreground : theme.colors.mutedForeground;
    final border = focused ? theme.colors.ring : theme.colors.border;
    final shadows = focused ? theme.shadows.sm : const <BoxShadow>[];

    switch (size) {
      case MinSelectSize.sm:
        return _MinSelectStyle(
          background: background,
          foreground: foreground,
          border: border,
          textStyle: theme.typography.small,
          shadows: shadows,
          height: theme.spacing.s10 - theme.spacing.s1,
          horizontalPadding: theme.spacing.s3,
          iconSize: theme.spacing.s4 - theme.spacing.px,
          radius: theme.radius.sm,
        );
      case MinSelectSize.md:
        return _MinSelectStyle(
          background: background,
          foreground: foreground,
          border: border,
          textStyle: theme.typography.body,
          shadows: shadows,
          height: theme.spacing.s10,
          horizontalPadding: theme.spacing.s4,
          iconSize: theme.spacing.s4,
          radius: theme.radius.md,
        );
      case MinSelectSize.lg:
        return _MinSelectStyle(
          background: background,
          foreground: foreground,
          border: border,
          textStyle: theme.typography.h3,
          shadows: shadows,
          height: theme.spacing.s10 + theme.spacing.s2,
          horizontalPadding: theme.spacing.s5,
          iconSize: theme.spacing.s4 + theme.spacing.px,
          radius: theme.radius.lg,
        );
    }
  }
}

// ---------------------------------------------------------------------------
// Chevron painter
// ---------------------------------------------------------------------------

class _ChevronPainter extends CustomPainter {
  const _ChevronPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.35)
      ..lineTo(size.width * 0.5, size.height * 0.65)
      ..lineTo(size.width * 0.8, size.height * 0.35);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ChevronPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
