import 'package:flutter/widgets.dart';
import 'package:mini_ui_flutter/miniui.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Text(
      text,
      style: theme.typography.h3.copyWith(color: theme.colors.foreground),
    );
  }
}
