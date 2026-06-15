import 'package:flutter/widgets.dart';
import 'package:miniui/miniui.dart';

import 'section_title.dart';

class CardsView extends StatelessWidget {
  const CardsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return ListView(
      padding: EdgeInsets.all(theme.spacing.s4),
      children: [
        const SectionTitle('Básica'),
        SizedBox(height: theme.spacing.s2),
        const MinCard(child: Text('Contenido de tarjeta simple')),
        SizedBox(height: theme.spacing.s6),
        const SectionTitle('Con margin'),
        SizedBox(height: theme.spacing.s2),
        const MinCard(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Esta tarjeta tiene margin horizontal'),
        ),
        SizedBox(height: theme.spacing.s6),
        const SectionTitle('Sin padding'),
        SizedBox(height: theme.spacing.s2),
        const MinCard(
          padding: EdgeInsets.zero,
          child: SizedBox(
            height: 120,
            child: Center(child: Text('Padding zero')),
          ),
        ),
        SizedBox(height: theme.spacing.s6),
        const SectionTitle('Custom colors'),
        SizedBox(height: theme.spacing.s2),
        MinCard(
          backgroundColor: theme.colors.primary,
          borderColor: theme.colors.primary,
          child: Text(
            'Color personalizado',
            style: TextStyle(color: theme.colors.primaryForeground),
          ),
        ),
        SizedBox(height: theme.spacing.s6),
        const SectionTitle('Custom radius'),
        SizedBox(height: theme.spacing.s2),
        MinCard(
          borderRadius: BorderRadius.circular(theme.radius.xl2),
          child: const Text('Border radius grande'),
        ),
      ],
    );
  }
}
