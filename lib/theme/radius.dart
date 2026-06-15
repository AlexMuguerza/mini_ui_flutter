class MinRadiusScale {
  const MinRadiusScale({
    this.none = 0,
    this.sm = 6,
    this.md = 8,
    this.lg = 10,
    this.xl = 12,
    this.xl2 = 16,
    this.full = 9999,
  });

  static const MinRadiusScale defaults = MinRadiusScale();

  final double none;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xl2;
  final double full;

  MinRadiusScale copyWith({
    double? none,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xl2,
    double? full,
  }) {
    return MinRadiusScale(
      none: none ?? this.none,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xl2: xl2 ?? this.xl2,
      full: full ?? this.full,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MinRadiusScale &&
            other.none == none &&
            other.sm == sm &&
            other.md == md &&
            other.lg == lg &&
            other.xl == xl &&
            other.xl2 == xl2 &&
            other.full == full;
  }

  @override
  int get hashCode => Object.hash(none, sm, md, lg, xl, xl2, full);
}

typedef MinRadiusScaleDefaults = MinRadiusScale;
