import 'package:flutter/widgets.dart';

import 'min_anchor.dart';

/// Default values for all Min floating components.
/// Override at the app level via [MinFloatingConfig].
@immutable
class MinFloatingDefaults {
  const MinFloatingDefaults({
    this.duration = const Duration(milliseconds: 140),
    this.reverseDuration,
    this.curve = Curves.easeOut,
    this.reverseCurve = Curves.easeIn,
    this.closeOnTapOutside = true,
    this.closeOnEscape = true,
    this.closeOnScroll = false,
    this.side = const MinUiAnchorSide.below(),
    this.barrierColor = const Color(0x00000000),
    this.useDimmedBarrier = false,
  });

  /// Animation duration when opening.
  final Duration duration;

  /// Animation duration when closing (defaults to [duration] if null).
  final Duration? reverseDuration;

  final Curve curve;
  final Curve reverseCurve;

  /// Close when user taps outside the floating element.
  final bool closeOnTapOutside;

  /// Close when user presses Escape.
  final bool closeOnEscape;

  /// Close when the nearest scroll view scrolls.
  final bool closeOnScroll;

  /// Default placement of floating elements relative to their trigger.
  final MinUiAnchorSide side;

  /// Barrier color behind the floating element (transparent by default).
  final Color barrierColor;

  /// Use a dimmed (semi-opaque) barrier, like a modal dialog.
  final bool useDimmedBarrier;

  Duration get effectiveReverseDuration => reverseDuration ?? duration;

  MinFloatingDefaults copyWith({
    Duration? duration,
    Duration? reverseDuration,
    Curve? curve,
    Curve? reverseCurve,
    bool? closeOnTapOutside,
    bool? closeOnEscape,
    bool? closeOnScroll,
    MinUiAnchorSide? side,
    Color? barrierColor,
    bool? useDimmedBarrier,
  }) => MinFloatingDefaults(
    duration: duration ?? this.duration,
    reverseDuration: reverseDuration ?? this.reverseDuration,
    curve: curve ?? this.curve,
    reverseCurve: reverseCurve ?? this.reverseCurve,
    closeOnTapOutside: closeOnTapOutside ?? this.closeOnTapOutside,
    closeOnEscape: closeOnEscape ?? this.closeOnEscape,
    closeOnScroll: closeOnScroll ?? this.closeOnScroll,
    side: side ?? this.side,
    barrierColor: barrierColor ?? this.barrierColor,
    useDimmedBarrier: useDimmedBarrier ?? this.useDimmedBarrier,
  );
}

/// InheritedWidget that provides [MinFloatingDefaults] to the entire subtree.
///
/// Place near the root of your app to configure all floating components:
///
/// ```dart
/// MiniFloatingConfig(
///   defaults: MiniFloatingDefaults(
///     duration: Duration(milliseconds: 200),
///     closeOnScroll: true,
///   ),
///   child: MaterialApp(...),
/// )
/// ```
class MinFloatingConfig extends InheritedWidget {
  const MinFloatingConfig({
    super.key,
    required this.defaults,
    required super.child,
  });

  final MinFloatingDefaults defaults;

  /// Returns the nearest [MinFloatingDefaults] in the tree.
  /// Falls back to [MiniFloatingDefaults()] if none is found.
  static MinFloatingDefaults of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<MinFloatingConfig>()
            ?.defaults ??
        const MinFloatingDefaults();
  }

  @override
  bool updateShouldNotify(MinFloatingConfig oldWidget) =>
      defaults != oldWidget.defaults;
}
