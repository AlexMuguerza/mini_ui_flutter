import 'package:flutter/widgets.dart';

class MinMotion {
  const MinMotion({
    this.fast = const Duration(milliseconds: 100),
    this.normal = const Duration(milliseconds: 200),
    this.slow = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });

  static const MinMotion defaults = MinMotion();

  final Duration fast;
  final Duration normal;
  final Duration slow;
  Duration get low => slow;
  final Curve curve;

  MinMotion copyWith({
    Duration? fast,
    Duration? normal,
    Duration? slow,
    Curve? curve,
  }) {
    return MinMotion(
      fast: fast ?? this.fast,
      normal: normal ?? this.normal,
      slow: slow ?? this.slow,
      curve: curve ?? this.curve,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MinMotion &&
            other.fast == fast &&
            other.normal == normal &&
            other.slow == slow &&
            other.curve == curve;
  }

  @override
  int get hashCode => Object.hash(fast, normal, slow, curve);
}

typedef MinMotionDefaults = MinMotion;
