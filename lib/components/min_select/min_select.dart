import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../locals/min_localizations.dart';
import '../../resources/min_floating/min_anchor.dart';
import '../../resources/min_floating/min_floating_base.dart';
import '../../resources/min_floating/min_floating_controller.dart';
import '../../theme/tokens.dart';
import '../min_card.dart';
import '../min_input/min_input.dart';

part 'min_select_floating.dart';
part 'min_option_tile.dart';
part 'min_select_chevron.dart';

enum MinSelectSize { sm, md, lg }

sealed class MinSelectItem<T> {
  const MinSelectItem();
}

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
    final placeholder = widget.placeholder ?? context.minLocale.selectPlaceholder;

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
