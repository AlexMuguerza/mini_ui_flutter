import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../theme/tokens.dart';

/// Tamaños disponibles para [MinCheckbox].
enum MinCheckboxSize { sm, md, lg }

/// Checkbox con toggle, soporte de teclado y personalización de icono.
///
/// Se usa para selección de una o más opciones de un conjunto.
/// Soporta navegación por teclado (espacio/enter) y personalización
/// completa del icono de verificación.
///
/// ### Uso básico
/// ```dart
/// MinCheckbox(
///   value: _isSelected,
///   onChanged: (value) => setState(() => _isSelected = value),
/// )
/// ```
///
/// ### Con icono personalizado
/// ```dart
/// MinCheckbox(
///   value: _isSelected,
///   onChanged: (value) => setState(() => _isSelected = value),
///   checkIcon: Icon(Icons.check, size: 14),
/// )
/// ```
class MinCheckbox extends StatefulWidget {
  const MinCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.size = MinCheckboxSize.md,
    this.disabled = false,
    this.focusNode,
    this.autofocus = false,
    this.side,
    this.checkColor,
    this.checkIcon,
    this.checkPainter,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final MinCheckboxSize size;
  final bool disabled;
  final FocusNode? focusNode;
  final bool autofocus;
  final Color? side;
  final Color? checkColor;
  final Widget? checkIcon;
  final CustomPainter? checkPainter;

  @override
  State<MinCheckbox> createState() => _MinCheckboxState();
}

class _MinCheckboxState extends State<MinCheckbox> {
  late final FocusNode _focusNode;
  bool _hovered = false;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

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
    final style = _CheckboxStyle.resolve(
      theme: theme,
      size: widget.size,
      hovered: _hovered,
      focused: _focused,
      enabled: _enabled,
      checked: widget.value,
      side: widget.side,
      checkColor: widget.checkColor,
    );

    return Semantics(
      checked: widget.value,
      enabled: _enabled,
      child: Focus(
        focusNode: _focusNode,
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
              width: style.size,
              height: style.size,
              decoration: BoxDecoration(
                color: style.backgroundColor,
                borderRadius: BorderRadius.circular(style.radius),
                border: Border.all(
                  color: style.borderColor,
                  width: style.borderWidth,
                ),
                boxShadow: style.shadows,
              ),
              child: Center(
                child: AnimatedCrossFade(
                  duration: theme.motion.fast,
                  crossFadeState: widget.value
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: widget.checkIcon != null
                      ? IconTheme(
                          data: IconThemeData(
                            color: style.checkColor,
                            size: style.iconSize,
                          ),
                          child: widget.checkIcon!,
                        )
                      : CustomPaint(
                          painter:
                              widget.checkPainter ??
                              _DefaultCheckmarkPainter(color: style.checkColor),
                          size: Size(style.iconSize, style.iconSize),
                        ),
                  secondChild: Container(
                    width: style.iconSize * .8,
                    height: style.iconSize * .2,
                    decoration: BoxDecoration(
                      color: style.borderColor,
                      borderRadius: BorderRadius.circular(style.radius / 2),
                    ),
                    child: SizedBox.shrink(),
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

class _CheckboxStyle {
  const _CheckboxStyle({
    required this.size,
    required this.radius,
    required this.iconSize,
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
    required this.checkColor,
    required this.shadows,
  });

  final double size;
  final double radius;
  final double iconSize;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final Color checkColor;
  final List<BoxShadow> shadows;

  static _CheckboxStyle resolve({
    required MinThemeData theme,
    required MinCheckboxSize size,
    required bool hovered,
    required bool focused,
    required bool enabled,
    required bool checked,
    Color? side,
    Color? checkColor,
  }) {
    final sizeStyle = _CheckboxSizeStyle.resolve(theme, size);

    Color backgroundColor;
    Color borderColor;
    Color resolvedCheckColor;
    List<BoxShadow> shadows = const [];

    if (!enabled) {
      backgroundColor = checked ? theme.colors.muted : theme.colors.muted;
      borderColor = side ?? theme.colors.input;
      resolvedCheckColor = theme.colors.mutedForeground;
    } else if (checked) {
      backgroundColor = theme.colors.primary;
      borderColor = theme.colors.primary;
      resolvedCheckColor = checkColor ?? theme.colors.primaryForeground;
    } else if (hovered) {
      backgroundColor = theme.colors.muted;
      borderColor = side ?? theme.colors.ring;
      resolvedCheckColor = theme.colors.foreground;
    } else {
      backgroundColor = const Color(0x00000000);
      borderColor = side ?? theme.colors.border;
      resolvedCheckColor = theme.colors.foreground;
    }

    if (focused && enabled) {
      shadows = [
        BoxShadow(
          blurRadius: theme.spacing.s2,
          color: theme.colors.ring.withAlpha(70),
        ),
      ];
    }

    return _CheckboxStyle(
      size: sizeStyle.size,
      radius: sizeStyle.radius,
      iconSize: sizeStyle.iconSize,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderWidth: sizeStyle.borderWidth,
      checkColor: resolvedCheckColor,
      shadows: shadows,
    );
  }
}

class _CheckboxSizeStyle {
  const _CheckboxSizeStyle({
    required this.size,
    required this.radius,
    required this.iconSize,
    required this.borderWidth,
  });

  final double size;
  final double radius;
  final double iconSize;
  final double borderWidth;

  static _CheckboxSizeStyle resolve(MinThemeData theme, MinCheckboxSize size) {
    switch (size) {
      case MinCheckboxSize.sm:
        return const _CheckboxSizeStyle(
          size: 18,
          radius: 3,
          iconSize: 14,
          borderWidth: 1.5,
        );
      case MinCheckboxSize.md:
        return const _CheckboxSizeStyle(
          size: 22,
          radius: 4,
          iconSize: 18,
          borderWidth: 2,
        );
      case MinCheckboxSize.lg:
        return const _CheckboxSizeStyle(
          size: 26,
          radius: 5,
          iconSize: 20,
          borderWidth: 3,
        );
    }
  }
}

/// CustomPainter que dibuja un checkmark por defecto
class _DefaultCheckmarkPainter extends CustomPainter {
  _DefaultCheckmarkPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Dibuja un checkmark (✓)
    // Punto inicial (esquina inferior izquierda)
    path.moveTo(size.width * 0.25, size.height * 0.55);
    // Línea diagonal hacia el centro
    path.lineTo(size.width * 0.45, size.height * 0.75);
    // Línea diagonal hacia la esquina superior derecha
    path.lineTo(size.width * 0.8, size.height * 0.25);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _DefaultCheckmarkPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
