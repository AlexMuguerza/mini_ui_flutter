import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import '../theme/tokens.dart';

/// Variantes visuales de [MinProgress].
///
/// - `linear`: barra de progreso horizontal.
/// - `circular`: arco de progreso circular.
enum MinProgressVariant { circular, linear }

/// Indicador de progreso con variantes linear y circular.
///
/// Soporta modo **determinable** (valor 0.0–1.0) e **indeterminable** (null).
/// Ambos modos incluyen animaciones de transición suave.
///
/// ### Uso básico
/// ```dart
/// // Linear determinable
/// MinProgress(value: 0.5)
///
/// // Linear indeterminable (sweeping bar)
/// MinProgress()
///
/// // Circular determinable
/// MinProgress(
///   value: 0.3,
///   variant: MinProgressVariant.circular,
/// )
///
/// // Circular indeterminable (spinning arc)
/// MinProgress(variant: MinProgressVariant.circular)
/// ```
///
/// ### Personalización
/// ```dart
/// MinProgress(
///   value: 0.75,
///   size: 8,                    // grosor de la barra / diámetro del círculo
///   color: theme.colors.primary,
///   trackColor: theme.colors.muted,
/// )
/// ```
class MinProgress extends StatelessWidget {
  const MinProgress({
    super.key,
    this.value,
    this.variant = MinProgressVariant.linear,
    this.size,
    this.strokeWidth,
    this.color,
    this.trackColor,
    this.backgroundColor,
  }) : assert(
         value == null || (value >= 0.0 && value <= 1.0),
         'value must be between 0.0 and 1.0, or null for indeterminate',
       );

  final double? value;

  final MinProgressVariant variant;

  final double? size;
  final double? strokeWidth;
  final Color? color;
  final Color? trackColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final progress = switch (variant) {
      MinProgressVariant.linear => _MinLinearProgress(
        value: value,
        size: size ?? theme.spacing.s2,
        color: color ?? theme.colors.primary,
        trackColor: trackColor ?? theme.colors.muted,
        motion: theme.motion,
        radius: theme.radius,
        spacing: theme.spacing,
      ),
      MinProgressVariant.circular => _MinCircularProgress(
        value: value,
        size: size ?? theme.spacing.s10,
        strokeWidth: strokeWidth ?? theme.spacing.s1 + theme.spacing.px,
        color: color ?? theme.colors.primary,
        trackColor: trackColor ?? theme.colors.muted,
        backgroundColor: backgroundColor ?? theme.colors.background,
        motion: theme.motion,
      ),
    };

    final label = value != null
        ? '${(value! * 100).toInt()}%'
        : 'Indeterminate progress';

    return Semantics(
      value: label,
      label: 'Progress indicator',
      child: progress,
    );
  }
}

class _MinLinearProgress extends StatelessWidget {
  const _MinLinearProgress({
    required this.value,
    required this.size,
    required this.color,
    required this.trackColor,
    required this.motion,
    required this.radius,
    required this.spacing,
  });

  final double? value;
  final double size;
  final Color color;
  final Color trackColor;
  final MinMotion motion;
  final MinRadiusScale radius;
  final MinSpacing spacing;

  @override
  Widget build(BuildContext context) {
    final radiusValue = BorderRadius.circular(radius.full);

    return ClipRRect(
      borderRadius: radiusValue,
      child: SizedBox(
        width: double.infinity,
        height: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: trackColor,
            borderRadius: radiusValue,
          ),
          child: _indeterminate
              ? _IndeterminateLinearFill(
                  color: color,
                  motion: motion,
                  radius: radiusValue,
                )
              : Align(
                  alignment: Alignment.centerLeft,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: value!.clamp(0.0, 1.0)),
                    duration: motion.slow * 2,
                    curve: motion.curve,
                    builder: (context, v, _) {
                      return FractionallySizedBox(
                        // heightFactor was missing: with no child intrinsic
                        // size and Align loosening the height constraint,
                        // the fill collapsed to height 0 and was invisible.
                        widthFactor: v,
                        heightFactor: 1,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: radiusValue,
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }

  bool get _indeterminate => value == null;
}

class _IndeterminateLinearFill extends StatefulWidget {
  const _IndeterminateLinearFill({
    required this.color,
    required this.motion,
    required this.radius,
  });

  final Color color;
  final MinMotion motion;
  final BorderRadius radius;

  @override
  State<_IndeterminateLinearFill> createState() =>
      _IndeterminateLinearFillState();
}

class _IndeterminateLinearFillState extends State<_IndeterminateLinearFill>
    with SingleTickerProviderStateMixin {
  // Fraction of the track width the moving bar occupies.
  static const double _barWidthFactor = 0.32;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.motion.slow * 4,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;

        // The bar slides from fully off-screen left to fully off-screen
        // right in a straight line. The +-2.0 range (rather than +-1.0)
        // means it exits the clipped track before the cycle wraps, so the
        // instantaneous reset happens while nothing is visible -- no jump.
        final x = -2.0 + 4.0 * t;

        return Align(
          alignment: Alignment(x, 0),
          child: FractionallySizedBox(
            widthFactor: _barWidthFactor,
            heightFactor: 1, // same fix as the determinate fill above
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: widget.radius,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MinCircularProgress extends StatefulWidget {
  const _MinCircularProgress({
    required this.value,
    required this.size,
    required this.strokeWidth,
    required this.color,
    required this.trackColor,
    required this.backgroundColor,
    required this.motion,
  });

  final double? value;
  final double size;
  final double strokeWidth;
  final Color color;
  final Color trackColor;
  final Color backgroundColor;
  final MinMotion motion;

  @override
  State<_MinCircularProgress> createState() => _MinCircularProgressState();
}

class _MinCircularProgressState extends State<_MinCircularProgress> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: widget.value != null
          ? _DeterminateCircular(
              value: widget.value!,
              strokeWidth: widget.strokeWidth,
              color: widget.color,
              trackColor: widget.trackColor,
              motion: widget.motion,
            )
          : _IndeterminateCircular(
              strokeWidth: widget.strokeWidth,
              color: widget.color,
              trackColor: widget.trackColor,
              motion: widget.motion,
            ),
    );
  }
}

class _DeterminateCircular extends StatelessWidget {
  const _DeterminateCircular({
    required this.value,
    required this.strokeWidth,
    required this.color,
    required this.trackColor,
    required this.motion,
  });

  final double value;
  final double strokeWidth;
  final Color color;
  final Color trackColor;
  final MinMotion motion;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.clamp(0.0, 1.0)),
      duration: motion.slow * 2,
      curve: motion.curve,
      builder: (context, v, _) {
        return CustomPaint(
          painter: _CircularProgressPainter(
            progress: v,
            strokeWidth: strokeWidth,
            color: color,
            trackColor: trackColor,
          ),
        );
      },
    );
  }
}

class _IndeterminateCircular extends StatefulWidget {
  const _IndeterminateCircular({
    required this.strokeWidth,
    required this.color,
    required this.trackColor,
    required this.motion,
  });

  final double strokeWidth;
  final Color color;
  final Color trackColor;
  final MinMotion motion;

  @override
  State<_IndeterminateCircular> createState() => _IndeterminateCircularState();
}

class _IndeterminateCircularState extends State<_IndeterminateCircular>
    with SingleTickerProviderStateMixin {
  // Sweep oscillates between these two fractions of a full turn.
  static const double _minSweep = 0.06;
  static const double _maxSweep = 0.75;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.motion.slow * 4,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;

        // Continuous rotation: one full turn per cycle. Since a full turn
        // is visually identical to no turn (2*pi == 0), this wraps with no
        // visible jump.
        final rotation = 2 * math.pi * t;

        // Smooth (cosine) growth/shrink of the arc length, sharing the same
        // period as the rotation, so head and tail stay in sync instead of
        // the previous mismatched-frequency sawtooth that snapped from a
        // full circle back to nothing.
        final eased = (1 - math.cos(2 * math.pi * t)) / 2;
        final sweep = _minSweep + eased * (_maxSweep - _minSweep);

        return CustomPaint(
          painter: _CircularProgressPainter(
            progress: sweep,
            rotation: rotation,
            strokeWidth: widget.strokeWidth,
            color: widget.color,
            trackColor: widget.trackColor,
          ),
        );
      },
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  _CircularProgressPainter({
    required this.progress,
    this.rotation = 0,
    required this.strokeWidth,
    required this.color,
    required this.trackColor,
  });

  final double progress;
  final double rotation;
  final double strokeWidth;
  final Color color;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    final sweepAngle = progress * math.pi * 2;
    if (sweepAngle > 0) {
      final fillPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        rect,
        -math.pi / 2 + rotation,
        sweepAngle,
        false,
        fillPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter old) {
    return old.progress != progress ||
        old.rotation != rotation ||
        old.color != color ||
        old.trackColor != trackColor ||
        old.strokeWidth != strokeWidth;
  }
}
