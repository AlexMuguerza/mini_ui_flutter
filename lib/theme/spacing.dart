class MinSpacing {
  const MinSpacing({
    this.px = 1,
    this.s1 = 4,
    this.s2 = 8,
    this.s3 = 12,
    this.s4 = 16,
    this.s5 = 20,
    this.s6 = 24,
    this.s8 = 32,
    this.s10 = 40,
    this.s12 = 48,
  });

  static const MinSpacing defaults = MinSpacing();

  final double px;
  final double s1;
  final double s2;
  final double s3;
  final double s4;
  final double s5;
  final double s6;
  final double s8;
  final double s10;
  final double s12;

  MinSpacing copyWith({
    double? px,
    double? s1,
    double? s2,
    double? s3,
    double? s4,
    double? s5,
    double? s6,
    double? s8,
    double? s10,
    double? s12,
  }) {
    return MinSpacing(
      px: px ?? this.px,
      s1: s1 ?? this.s1,
      s2: s2 ?? this.s2,
      s3: s3 ?? this.s3,
      s4: s4 ?? this.s4,
      s5: s5 ?? this.s5,
      s6: s6 ?? this.s6,
      s8: s8 ?? this.s8,
      s10: s10 ?? this.s10,
      s12: s12 ?? this.s12,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MinSpacing &&
            other.px == px &&
            other.s1 == s1 &&
            other.s2 == s2 &&
            other.s3 == s3 &&
            other.s4 == s4 &&
            other.s5 == s5 &&
            other.s6 == s6 &&
            other.s8 == s8 &&
            other.s10 == s10 &&
            other.s12 == s12;
  }

  @override
  int get hashCode => Object.hash(px, s1, s2, s3, s4, s5, s6, s8, s10, s12);
}

typedef MinSpacingDefaults = MinSpacing;
