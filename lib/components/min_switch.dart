import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../theme/tokens.dart';

/// Tamaños disponibles para [MinSwitch].
enum MinSwitchSize { sm, md, lg }

/// Interruptor toggle con soporte de teclado y animación.
///
/// Se usa para alternar entre dos estados (activado/desactivado).
/// Soporta navegación por teclado (espacio/enter) y tiene animación
/// suave en la transición del thumb.
///
/// ### Uso básico
/// ```dart
/// MinSwitch(
///   value: _isEnabled,
///   onChanged: (value) => setState(() => _isEnabled = value),
/// )
/// ```
///
/// ### Con tamaño personalizado
/// ```dart
/// MinSwitch(
///   value: _isEnabled,
///   size: MinSwitchSize.lg,
///   onChanged: (value) => setState(() => _isEnabled = value),
/// )
/// ```
class MinSwitch extends StatefulWidget {
  const MinSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.size = MinSwitchSize.md,
    this.disabled = false,
    this.focusNode,
    this.autofocus = false,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final MinSwitchSize size;
  final bool disabled;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  State<MinSwitch> createState() => _MinSwitchState();
}

class _MinSwitchState extends State<MinSwitch> {
  bool _hovered = false;
  bool _focused = false;

  bool get _enabled => !widget.disabled && widget.onChanged != null;

  void _toggle() {
    if (_enabled) {
      widget.onChanged?.call(!widget.value);
    }
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (!_enabled) {
      return KeyEventResult.ignored;
    }

    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      if (event is KeyDownEvent) {
        return KeyEventResult.handled;
      }
      if (event is KeyUpEvent) {
        _toggle();
        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final style = _SwitchStyle.resolve(
      theme: theme,
      size: widget.size,
      hovered: _hovered,
      enabled: _enabled,
      value: widget.value,
    );

    return Semantics(
      toggled: widget.value,
      enabled: _enabled,
      child: Focus(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        onFocusChange: (value) => setState(() => _focused = value),
        onKeyEvent: _onKeyEvent,
        child: MouseRegion(
          cursor: _enabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _toggle,
            child: AnimatedContainer(
              duration: theme.motion.fast,
              curve: theme.motion.curve,
              width: style.width,
              height: style.height,
              decoration: BoxDecoration(
                color: style.background,
                borderRadius: BorderRadius.circular(style.radius),
                border: _focused && _enabled
                    ? Border.all(
                        color: theme.colors.ring,
                        width: theme.spacing.px * 2,
                      )
                    : null,
              ),
              child: AnimatedAlign(
                duration: theme.motion.fast,
                curve: theme.motion.curve,
                alignment: widget.value
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: AnimatedContainer(
                  duration: theme.motion.fast,
                  curve: theme.motion.curve,
                  width: style.thumbSize,
                  height: style.thumbSize,
                  margin: style.thumbMargin,
                  decoration: BoxDecoration(
                    color: style.thumbColor,
                    shape: BoxShape.circle,
                    boxShadow: style.thumbShadow,
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

class _SwitchStyle {
  const _SwitchStyle({
    required this.width,
    required this.height,
    required this.radius,
    required this.thumbSize,
    required this.thumbMargin,
    required this.background,
    required this.thumbColor,
    required this.thumbShadow,
  });

  final double width;
  final double height;
  final double radius;
  final double thumbSize;
  final EdgeInsets thumbMargin;
  final Color background;
  final Color thumbColor;
  final List<BoxShadow>? thumbShadow;

  static _SwitchStyle resolve({
    required MinThemeData theme,
    required MinSwitchSize size,
    required bool hovered,
    required bool enabled,
    required bool value,
  }) {
    final sizeStyle = _SwitchSizeStyle.resolve(theme, size);

    Color background;
    Color thumbColor;

    if (!enabled) {
      background = theme.colors.muted;
      thumbColor = theme.colors.mutedForeground.withAlpha(128);
    } else if (value) {
      background = theme.colors.primary;
      thumbColor = theme.colors.primaryForeground;
    } else {
      background = hovered ? theme.colors.border : theme.colors.input;
      thumbColor = theme.colors.mutedForeground;
    }

    final thumbShadow = enabled && value ? theme.shadows.sm : null;

    return _SwitchStyle(
      width: sizeStyle.width,
      height: sizeStyle.height,
      radius: sizeStyle.radius,
      thumbSize: sizeStyle.thumbSize,
      thumbMargin: sizeStyle.thumbMargin,
      background: background,
      thumbColor: thumbColor,
      thumbShadow: thumbShadow,
    );
  }
}

class _SwitchSizeStyle {
  const _SwitchSizeStyle({
    required this.width,
    required this.height,
    required this.radius,
    required this.thumbSize,
    required this.thumbMargin,
  });

  final double width;
  final double height;
  final double radius;
  final double thumbSize;
  final EdgeInsets thumbMargin;

  static _SwitchSizeStyle resolve(MinThemeData theme, MinSwitchSize size) {
    switch (size) {
      case MinSwitchSize.sm:
        return _SwitchSizeStyle(
          width: theme.spacing.s8,
          height: theme.spacing.s5,
          radius: theme.spacing.s4,
          thumbSize: theme.spacing.s3,
          thumbMargin: EdgeInsets.all(theme.spacing.px * 2),
        );
      case MinSwitchSize.md:
        return _SwitchSizeStyle(
          width: theme.spacing.s10,
          height: theme.spacing.s6,
          radius: theme.spacing.s5,
          thumbSize: theme.spacing.s4,
          thumbMargin: EdgeInsets.all(theme.spacing.px * 2),
        );
      case MinSwitchSize.lg:
        return _SwitchSizeStyle(
          width: theme.spacing.s12,
          height: theme.spacing.s6 + theme.spacing.s1,
          radius: theme.spacing.s6,
          thumbSize: theme.spacing.s5,
          thumbMargin: EdgeInsets.all(theme.spacing.s1),
        );
    }
  }
}
