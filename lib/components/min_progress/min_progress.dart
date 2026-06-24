import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import '../../theme/tokens.dart';

part 'min_progress_linear.dart';
part 'min_progress_circular.dart';

enum MinProgressVariant { circular, linear }

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
