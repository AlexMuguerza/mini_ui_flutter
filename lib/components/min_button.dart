import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../theme/tokens.dart';

/// Variantes visuales de [MinButton].
///
/// - `primary`: fondo sólido con el color primary del tema.
/// - `secondary`: fondo atenuado con el color secondary.
/// - `outline`: solo borde, sin fondo.
/// - `ghost`: sin fondo ni borde, solo texto.
enum MinButtonVariant { primary, secondary, outline, ghost }

/// Tamaños disponibles para [MinButton].
enum MinButtonSize { sm, md, lg }

/// Botón con variantes, tamaños, estados de loading y soporte de teclado.
///
/// Soporta.leading/trailing widgets, animaciones de hover/press,
/// y navegación por teclado (espacio/enter).
///
/// ### Uso básico
/// ```dart
/// MinButton(
///   onPressed: () => print('Tap'),
///   child: Text('Click me'),
/// )
/// ```
///
/// ### Variante secundaria con leading
/// ```dart
/// MinButton(
///   variant: MinButtonVariant.secondary,
///   leading: Icon(TablerIcons.plus),
///   onPressed: () {},
///   child: Text('Crear'),
/// )
/// ```
///
/// ### Estado de loading
/// ```dart
/// MinButton(
///   onPressed: _handleSubmit,
///   loading: _isLoading,
///   child: Text('Enviar'),
/// )
/// ```
class MinButton extends StatefulWidget {
  const MinButton({
    super.key,
    required this.child,
    this.onPressed,
    this.variant = MinButtonVariant.primary,
    this.size = MinButtonSize.md,
    this.leading,
    this.trailing,
    this.loading = false,
    this.disabled = false,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final MinButtonVariant variant;
  final MinButtonSize size;
  final Widget? leading;
  final Widget? trailing;
  final bool loading;
  final bool disabled;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? semanticLabel;

  @override
  State<MinButton> createState() => _MinButtonState();
}

class _MinButtonState extends State<MinButton> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _enabled =>
      !widget.disabled && !widget.loading && widget.onPressed != null;

  void _activate() {
    if (_enabled) {
      widget.onPressed?.call();
    }
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (!_enabled) {
      return KeyEventResult.ignored;
    }

    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      if (event is KeyDownEvent) {
        if (!_pressed) {
          setState(() => _pressed = true);
        }
        return KeyEventResult.handled;
      }
      if (event is KeyUpEvent) {
        setState(() => _pressed = false);
        _activate();
        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final style = _MinButtonStyle.resolve(
      theme: theme,
      variant: widget.variant,
      size: widget.size,
      hovered: _hovered,
      pressed: _pressed,
      focused: _focused,
      enabled: _enabled,
    );

    final horizontalGap = SizedBox(width: theme.spacing.s2);

    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.semanticLabel,
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
          onExit: (_) => setState(() {
            _hovered = false;
            _pressed = false;
          }),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _enabled ? _activate : null,
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
                borderRadius: BorderRadius.circular(style.radius),
                border: Border.all(
                  color: style.border,
                  width: theme.spacing.px,
                ),
                boxShadow: style.shadows,
              ),
              child: DefaultTextStyle(
                style: style.textStyle.copyWith(color: style.foreground),
                child: IconTheme(
                  data: IconThemeData(
                    size: style.iconSize,
                    color: style.foreground,
                  ),
                  child: AnimatedOpacity(
                    duration: theme.motion.fast,
                    opacity: _enabled ? 1 : 0.5,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.loading)
                          _MinButtonSpinner(
                            size: style.iconSize,
                            strokeWidth: math.max(theme.spacing.px, 1.0),
                            color: style.foreground,
                            duration: theme.motion.slow,
                          )
                        else if (widget.leading != null)
                          widget.leading!,
                        if (widget.loading || widget.leading != null)
                          horizontalGap,
                        widget.child,
                        if (widget.trailing != null) ...[
                          horizontalGap,
                          widget.trailing!,
                        ],
                      ],
                    ),
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

class _MinButtonStyle {
  const _MinButtonStyle({
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

  static _MinButtonStyle resolve({
    required MinThemeData theme,
    required MinButtonVariant variant,
    required MinButtonSize size,
    required bool hovered,
    required bool pressed,
    required bool focused,
    required bool enabled,
  }) {
    final transparent = theme.colors.background.withAlpha(0);
    final bool interactive = enabled;

    Color background;
    Color foreground;
    Color border;
    List<BoxShadow> shadows = const [];

    switch (variant) {
      case MinButtonVariant.primary:
        background = !interactive
            ? theme.colors.primary.withAlpha(50)
            : pressed
            ? theme.colors.primary.withAlpha(200)
            : hovered
            ? theme.colors.primary.withAlpha(230)
            : theme.colors.primary;
        foreground = theme.colors.primaryForeground;
        border = background;
        shadows = hovered || focused ? theme.shadows.sm : const [];
      case MinButtonVariant.secondary:
        background = !interactive
            ? theme.colors.muted
            : pressed
            ? theme.colors.accent
            : hovered
            ? theme.colors.accent
            : theme.colors.secondary;
        foreground = theme.colors.secondaryForeground;
        border = theme.colors.border;
      case MinButtonVariant.outline:
        background = !interactive
            ? transparent
            : pressed
            ? theme.colors.muted
            : hovered
            ? theme.colors.secondary
            : transparent;
        foreground = theme.colors.foreground;
        border = !interactive
            ? theme.colors.muted
            : theme.colors.border;
      case MinButtonVariant.ghost:
        background = !interactive
            ? transparent
            : pressed
            ? theme.colors.accent
            : hovered
            ? theme.colors.accent
            : transparent;
        foreground = !interactive
            ? theme.colors.mutedForeground
            : theme.colors.foreground;
        border = transparent;
    }

    if (focused && interactive) {
      shadows = <BoxShadow>[
        ...shadows,
        BoxShadow(
          blurRadius: theme.spacing.s2,
          color: theme.colors.ring.withAlpha(90),
        ),
      ];
    }

    final sizeStyle = _ButtonSizeStyle.resolve(theme, size);

    return _MinButtonStyle(
      background: background,
      foreground: foreground,
      border: border,
      textStyle: sizeStyle.textStyle,
      shadows: shadows,
      height: sizeStyle.height,
      horizontalPadding: sizeStyle.horizontalPadding,
      iconSize: sizeStyle.iconSize,
      radius: sizeStyle.radius,
    );
  }
}

class _ButtonSizeStyle {
  const _ButtonSizeStyle({
    required this.height,
    required this.horizontalPadding,
    required this.iconSize,
    required this.textStyle,
    required this.radius,
  });

  final double height;
  final double horizontalPadding;
  final double iconSize;
  final TextStyle textStyle;
  final double radius;

  static _ButtonSizeStyle resolve(MinThemeData theme, MinButtonSize size) {
    switch (size) {
      case MinButtonSize.sm:
        return _ButtonSizeStyle(
          height: theme.spacing.s10 - theme.spacing.s1,
          horizontalPadding: theme.spacing.s3,
          iconSize: theme.spacing.s4 - theme.spacing.px,
          textStyle: theme.typography.small,
          radius: theme.radius.sm,
        );
      case MinButtonSize.md:
        return _ButtonSizeStyle(
          height: theme.spacing.s10,
          horizontalPadding: theme.spacing.s4,
          iconSize: theme.spacing.s4,
          textStyle: theme.typography.body,
          radius: theme.radius.md,
        );
      case MinButtonSize.lg:
        return _ButtonSizeStyle(
          height: theme.spacing.s10 + theme.spacing.s2,
          horizontalPadding: theme.spacing.s5,
          iconSize: theme.spacing.s4 + theme.spacing.px,
          textStyle: theme.typography.h3,
          radius: theme.radius.lg,
        );
    }
  }
}

class _MinButtonSpinner extends StatefulWidget {
  const _MinButtonSpinner({
    required this.size,
    required this.strokeWidth,
    required this.color,
    required this.duration,
  });

  final double size;
  final double strokeWidth;
  final Color color;
  final Duration duration;

  @override
  State<_MinButtonSpinner> createState() => _MinButtonSpinnerState();
}

class _MinButtonSpinnerState extends State<_MinButtonSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration * 4,
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant _MinButtonSpinner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration * 4;
      if (!_controller.isAnimating) {
        _controller.repeat();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * math.pi * 2,
            child: CustomPaint(
              painter: _SpinnerPainter(
                color: widget.color,
                strokeWidth: widget.strokeWidth,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  const _SpinnerPainter({required this.color, required this.strokeWidth});

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final shortest = size.shortestSide;
    final radius = (shortest / 2) - strokeWidth;
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, -math.pi / 2, math.pi * 1.35, false, paint);
  }

  @override
  bool shouldRepaint(covariant _SpinnerPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}
