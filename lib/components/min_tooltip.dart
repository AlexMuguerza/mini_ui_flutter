import 'dart:async';
import 'package:flutter/widgets.dart';
import '../resources/min_floating/min_anchor.dart';
import '../resources/min_floating/min_floating_base.dart';
import '../resources/min_floating/min_floating_controller.dart';
import '../theme/tokens.dart';

/// Tooltip flotante que aparece al hacer hover (desktop/web)
/// o al mantener presionado (mobile).
///
/// Usa el sistema de floating ([MinFloatingBase]) para posicionarse
/// automáticamente respecto al [child] y renderizarse en un [Overlay].
///
/// ### Uso básico
/// ```dart
/// MinTooltip(
///   message: 'Esto es un tooltip',
///   child: Text('Hover o long-press aquí'),
/// )
/// ```
///
/// ### Delay personalizado
/// ```dart
/// MinTooltip(
///   message: 'Aparece instantáneamente',
///   delay: Duration.zero,
///   child: Text('Target'),
/// )
/// ```
///
/// ### Posición personalizada
/// ```dart
/// MinTooltip(
///   message: 'Tooltip arriba',
///   side: MinUiAnchorSide.above(),
///   child: Text('Target'),
/// )
/// ```

class MinTooltip extends StatefulWidget {
  const MinTooltip({
    super.key,
    required this.child,
    required this.message,
    this.delay = const Duration(milliseconds: 500),
    this.side,
    this.duration,
    this.reverseDuration,
    this.curve,
    this.animation,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.textStyle,
  }) : assert(message != '', 'message must not be empty');

  final Widget child;
  final String message;

  final Duration delay;

  final MinUiAnchorSide? side;
  final Duration? duration;
  final Duration? reverseDuration;
  final Curve? curve;
  final MinFloatingAnimation? animation;

  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  @override
  State<MinTooltip> createState() => _MinTooltipState();
}

class _MinTooltipState extends State<MinTooltip> {
  Timer? _timer;
  final _controller = MinFloatingController(isOpen: false);

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _showAfterDelay() {
    _timer?.cancel();
    _timer = Timer(widget.delay, () => _controller.show());
  }

  void _hideNow() {
    _timer?.cancel();
    _controller.hide();
  }

  void _handleEnter(_) => _showAfterDelay();

  void _handleExit(_) => _hideNow();

  void _handleLongPressStart(_) => _showAfterDelay();

  void _handleLongPressEnd(_) => _hideNow();

  void _handleLongPressCancel() => _hideNow();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return MouseRegion(
      onEnter: _handleEnter,
      onExit: _handleExit,
      child: GestureDetector(
        onLongPressStart: _handleLongPressStart,
        onLongPressEnd: _handleLongPressEnd,
        onLongPressCancel: _handleLongPressCancel,
        child: _TooltipFloating(
        controller: _controller,
        side: widget.side,
        duration: widget.duration,
        reverseDuration: widget.reverseDuration,
        curve: widget.curve,
        animation: widget.animation ?? MinFloatingAnimation.fade,
        closeOnTapOutside: false,
        closeOnEscape: true,
        closeOnScroll: true,
        openOnTap: false,
        enabled: true,
        constrainToViewport: true,
        viewportPadding: const EdgeInsets.all(8),
        child: widget.child,
        contentBuilder: (context) {
          return _TooltipContent(
            message: widget.message,
            padding: widget.padding,
            borderRadius: widget.borderRadius,
            backgroundColor: widget.backgroundColor,
            textStyle: widget.textStyle,
            theme: theme,
          );
        },
      ),
      ),
    );
  }
}

class _TooltipFloating extends MinFloatingBase {
  const _TooltipFloating({
    required super.child,
    required super.controller,
    super.side,
    super.duration,
    super.reverseDuration,
    super.curve,
    super.animation,
    super.closeOnTapOutside,
    super.closeOnEscape,
    super.closeOnScroll,
    super.openOnTap,
    super.enabled,
    super.constrainToViewport,
    super.viewportPadding,
    required this.contentBuilder,
  });

  final WidgetBuilder contentBuilder;

  @override
  Widget wrapOverlay(BuildContext anchorContext, Widget overlayChild) {
    final theme = MinTheme.maybeOf(anchorContext);
    if (theme == null) return overlayChild;
    return MinTheme(data: theme, child: overlayChild);
  }

  @override
  Widget buildContent(BuildContext context, MinFloatingController controller) {
    return contentBuilder(context);
  }
}

class _TooltipContent extends StatelessWidget {
  const _TooltipContent({
    required this.message,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.textStyle,
    required this.theme,
  });

  final String message;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final MinThemeData theme;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(theme.radius.sm);
    final bgColor = backgroundColor ?? theme.colors.foreground.withAlpha(230);
    final textColor = theme.colors.background;

    return Semantics(
      label: message,
      container: true,
      child: ClipRRect(
      borderRadius: radius,
      child: DecoratedBox(
        decoration: BoxDecoration(color: bgColor),
        child: Padding(
          padding: padding ??
              EdgeInsets.symmetric(
                horizontal: theme.spacing.s3,
                vertical: theme.spacing.s2,
              ),
          child: DefaultTextStyle(
            style: textStyle ??
                theme.typography.small.copyWith(color: textColor),
            child: Text(message),
          ),
        ),
      ),
      ),
    );
  }
}
