import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class MinShadows {
  const MinShadows({
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xl2,
  });

  static const MinShadows defaults = MinShadows(
    sm: [
      BoxShadow(
        offset: Offset(0, 1),
        blurRadius: 2,
        color: Color(0x0D000000),
      ),
    ],
    md: [
      BoxShadow(
        offset: Offset(0, 4),
        blurRadius: 6,
        color: Color(0x1A000000),
      ),
    ],
    lg: [
      BoxShadow(
        offset: Offset(0, 10),
        blurRadius: 15,
        color: Color(0x1A000000),
      ),
    ],
    xl: [
      BoxShadow(
        offset: Offset(0, 20),
        blurRadius: 25,
        color: Color(0x1A000000),
      ),
    ],
    xl2: [
      BoxShadow(
        offset: Offset(0, 25),
        blurRadius: 50,
        color: Color(0x40000000),
      ),
    ],
  );

  final List<BoxShadow> sm;
  final List<BoxShadow> md;
  final List<BoxShadow> lg;
  final List<BoxShadow> xl;
  final List<BoxShadow> xl2;

  MinShadows copyWith({
    List<BoxShadow>? sm,
    List<BoxShadow>? md,
    List<BoxShadow>? lg,
    List<BoxShadow>? xl,
    List<BoxShadow>? xl2,
  }) {
    return MinShadows(
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xl2: xl2 ?? this.xl2,
    );
  }

  factory MinShadows.defaultShadows() => defaults;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MinShadows &&
            listEquals(other.sm, sm) &&
            listEquals(other.md, md) &&
            listEquals(other.lg, lg) &&
            listEquals(other.xl, xl) &&
            listEquals(other.xl2, xl2);
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(sm),
    Object.hashAll(md),
    Object.hashAll(lg),
    Object.hashAll(xl),
    Object.hashAll(xl2),
  );
}

typedef MinShadowsDefaults = MinShadows;
