import 'package:flutter/widgets.dart';

class MinTypography {
  const MinTypography({
    required this.h1,
    required this.h2,
    required this.h3,
    required this.body,
    required this.small,
    required this.muted,
  });

  static MinTypography get defaults => MinTypography.defaultSans();

  final TextStyle h1;
  final TextStyle h2;
  final TextStyle h3;
  final TextStyle body;
  final TextStyle small;
  final TextStyle muted;

  factory MinTypography.defaultSans({String? fontFamily, Color? mutedColor}) {
    return MinTypography(
      h1: TextStyle(
        fontSize: 30,
        height: 1.2,
        fontWeight: FontWeight.bold,
        fontFamily: fontFamily,
      ),
      h2: TextStyle(
        fontSize: 24,
        height: 1.25,
        fontWeight: FontWeight.bold,
        fontFamily: fontFamily,
      ),
      h3: TextStyle(
        fontSize: 20,
        height: 1.3,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamily,
      ),
      body: TextStyle(
        fontSize: 16,
        height: 1.5,
        fontWeight: FontWeight.normal,
        fontFamily: fontFamily,
      ),
      small: TextStyle(
        fontSize: 14,
        height: 1.4,
        fontWeight: FontWeight.normal,
        fontFamily: fontFamily,
      ),
      muted: TextStyle(
        fontSize: 14,
        height: 1.4,
        color: mutedColor,
        fontFamily: fontFamily,
      ),
    );
  }

  MinTypography copyWith({
    TextStyle? h1,
    TextStyle? h2,
    TextStyle? h3,
    TextStyle? body,
    TextStyle? small,
    TextStyle? muted,
  }) {
    return MinTypography(
      h1: h1 ?? this.h1,
      h2: h2 ?? this.h2,
      h3: h3 ?? this.h3,
      body: body ?? this.body,
      small: small ?? this.small,
      muted: muted ?? this.muted,
    );
  }

  MinTypography apply({Color? color, Color? mutedColor, String? fontFamily}) {
    TextStyle style(TextStyle value) {
      return value.copyWith(color: color, fontFamily: fontFamily);
    }

    return copyWith(
      h1: style(h1),
      h2: style(h2),
      h3: style(h3),
      body: style(body),
      small: style(small),
      muted: muted.copyWith(
        color: mutedColor ?? muted.color ?? color,
        fontFamily: fontFamily,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MinTypography &&
            other.h1 == h1 &&
            other.h2 == h2 &&
            other.h3 == h3 &&
            other.body == body &&
            other.small == small &&
            other.muted == muted;
  }

  @override
  int get hashCode => Object.hash(h1, h2, h3, body, small, muted);
}

typedef MinTypographyDefaults = MinTypography;
