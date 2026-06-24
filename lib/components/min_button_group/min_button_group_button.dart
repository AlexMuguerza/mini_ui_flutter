part of 'min_button_group.dart';

// ---------------------------------------------------------------------------
// Botón interno del grupo
// ---------------------------------------------------------------------------

class _GroupButton<T> extends StatefulWidget {
  const _GroupButton({
    required this.option,
    required this.isSelected,
    required this.size,
    required this.variant,
    required this.borderRadius,
    required this.labelBuilder,
    required this.onChanged,
    required this.focusNode,
    required this.onArrowKey,
    required this.index,
    required this.direction,
  });

  final MinButtonGroupOption<T> option;
  final bool isSelected;
  final MinButtonSize size;
  final MinButtonVariant variant;
  final BorderRadius borderRadius;
  final Widget Function(T value) labelBuilder;
  final ValueChanged<T> onChanged;
  final FocusNode focusNode;
  final void Function(int index, bool isNext) onArrowKey;
  final int index;
  final Axis direction;

  @override
  State<_GroupButton<T>> createState() => _GroupButtonState<T>();
}

class _GroupButtonState<T> extends State<_GroupButton<T>> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _enabled => widget.option.enabled;

  void _handleTap() {
    if (_enabled) {
      widget.onChanged(widget.option.value);
    }
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (!_enabled) return KeyEventResult.ignored;
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    final isHorizontal = widget.direction == Axis.horizontal;
    final isNextKey = isHorizontal
        ? event.logicalKey == LogicalKeyboardKey.arrowRight
        : event.logicalKey == LogicalKeyboardKey.arrowDown;
    final isPrevKey = isHorizontal
        ? event.logicalKey == LogicalKeyboardKey.arrowLeft
        : event.logicalKey == LogicalKeyboardKey.arrowUp;

    if (isNextKey) {
      widget.onArrowKey(widget.index, true);
      return KeyEventResult.handled;
    }
    if (isPrevKey) {
      widget.onArrowKey(widget.index, false);
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      if (event is KeyDownEvent) {
        setState(() => _pressed = true);
        return KeyEventResult.handled;
      }
      if (event is KeyUpEvent) {
        setState(() => _pressed = false);
        _handleTap();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final style = _GroupButtonStyle.resolve(
      theme: theme,
      size: widget.size,
      isSelected: widget.isSelected,
      enabled: _enabled,
      hovered: _hovered,
      pressed: _pressed,
      focused: _focused,
    );

    return Semantics(
      button: true,
      enabled: _enabled,
      selected: widget.isSelected,
      child: Focus(
        focusNode: widget.focusNode,
        autofocus: false,
        onFocusChange: (v) => setState(() => _focused = v),
        onKeyEvent: _onKeyEvent,
        child: MouseRegion(
          cursor: _enabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() {
            _hovered = false;
            _pressed = false;
          }),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _enabled ? _handleTap : null,
            onTapDown: _enabled ? (_) => setState(() => _pressed = true) : null,
            onTapUp: _enabled ? (_) => setState(() => _pressed = false) : null,
            onTapCancel: _enabled
                ? () => setState(() => _pressed = false)
                : null,
            child: AnimatedContainer(
              duration: theme.motion.normal,
              curve: theme.motion.curve,
              height: style.height,
              padding: EdgeInsets.symmetric(
                horizontal: style.horizontalPadding,
              ),
              decoration: BoxDecoration(
                color: style.background,
                borderRadius: widget.borderRadius,
                border: Border.all(
                  color: style.border,
                  width: theme.spacing.px,
                ),
                boxShadow: style.shadows,
              ),
              child: DefaultTextStyle(
                style: style.textStyle.copyWith(color: style.foreground),
                child: AnimatedOpacity(
                  duration: theme.motion.fast,
                  opacity: _enabled ? 1 : 0.5,
                  child: Center(
                    child: widget.labelBuilder(widget.option.value),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Estilo del botón del grupo
// ---------------------------------------------------------------------------

class _GroupButtonStyle {
  const _GroupButtonStyle({
    required this.background,
    required this.foreground,
    required this.border,
    required this.textStyle,
    required this.shadows,
    required this.height,
    required this.horizontalPadding,
  });

  final Color background;
  final Color foreground;
  final Color border;
  final TextStyle textStyle;
  final List<BoxShadow> shadows;
  final double height;
  final double horizontalPadding;

  static _GroupButtonStyle resolve({
    required MinThemeData theme,
    required MinButtonSize size,
    required bool isSelected,
    required bool enabled,
    required bool hovered,
    required bool pressed,
    required bool focused,
  }) {
    // Background
    Color background;
    if (!enabled) {
      background = theme.colors.muted;
    } else if (isSelected) {
      background = theme.colors.primary;
    } else if (pressed) {
      background = theme.colors.accent;
    } else if (hovered) {
      background = theme.colors.accent;
    } else {
      background = theme.colors.background;
    }

    // Foreground
    Color foreground;
    if (!enabled) {
      foreground = theme.colors.mutedForeground;
    } else if (isSelected) {
      foreground = theme.colors.primaryForeground;
    } else {
      foreground = theme.colors.foreground;
    }

    // Border
    Color border;
    if (!enabled) {
      border = theme.colors.border;
    } else if (focused) {
      border = theme.colors.ring;
    } else if (isSelected) {
      border = theme.colors.primary;
    } else {
      border = theme.colors.border;
    }

    // Shadows
    List<BoxShadow> shadows;
    if (focused) {
      shadows = [
        BoxShadow(
          blurRadius: theme.spacing.s2,
          color: theme.colors.ring.withAlpha(90),
        ),
      ];
    } else {
      shadows = const [];
    }

    // Size
    switch (size) {
      case MinButtonSize.sm:
        return _GroupButtonStyle(
          background: background,
          foreground: foreground,
          border: border,
          textStyle: theme.typography.small,
          shadows: shadows,
          height: theme.spacing.s10 - theme.spacing.s1,
          horizontalPadding: theme.spacing.s3,
        );
      case MinButtonSize.md:
        return _GroupButtonStyle(
          background: background,
          foreground: foreground,
          border: border,
          textStyle: theme.typography.body,
          shadows: shadows,
          height: theme.spacing.s10,
          horizontalPadding: theme.spacing.s4,
        );
      case MinButtonSize.lg:
        return _GroupButtonStyle(
          background: background,
          foreground: foreground,
          border: border,
          textStyle: theme.typography.h3,
          shadows: shadows,
          height: theme.spacing.s10 + theme.spacing.s2,
          horizontalPadding: theme.spacing.s5,
        );
    }
  }
}
