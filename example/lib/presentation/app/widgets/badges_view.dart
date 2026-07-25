import 'package:flutter/widgets.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:mini_ui_flutter/miniui.dart';

import 'section_title.dart';

class BadgesView extends StatelessWidget {
  const BadgesView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return ListView(
      padding: EdgeInsets.all(theme.spacing.s4),
      children: [
        const SectionTitle('Variantes'),
        SizedBox(height: theme.spacing.s2),
        Wrap(
          spacing: theme.spacing.s2,
          runSpacing: theme.spacing.s2,
          children: [
            for (final variant in MinBadgeVariant.values)
              MinBadge(label: Text(variant.name), variant: variant),
          ],
        ),
        SizedBox(height: theme.spacing.s6),
        const SectionTitle('Con icono'),
        SizedBox(height: theme.spacing.s2),
        Wrap(
          spacing: theme.spacing.s2,
          runSpacing: theme.spacing.s2,
          children: [
            const MinBadge(
              label: Text('Primary'),
              variant: MinBadgeVariant.primary,
              icon: Icon(TablerIcons.star, size: 12),
            ),
            const MinBadge(
              label: Text('Secondary'),
              variant: MinBadgeVariant.secondary,
              icon: Icon(TablerIcons.bell, size: 12),
            ),
            const MinBadge(
              label: Text('Outline'),
              variant: MinBadgeVariant.outline,
              icon: Icon(TablerIcons.circle, size: 12),
            ),
            const MinBadge(
              label: Text('Destructive'),
              variant: MinBadgeVariant.destructive,
              icon: Icon(TablerIcons.alert_circle, size: 12),
            ),
          ],
        ),
        SizedBox(height: theme.spacing.s6),

        const SectionTitle('Wrapper sobre botones'),
        SizedBox(height: theme.spacing.s2),
        Wrap(
          spacing: theme.spacing.s8,
          runSpacing: theme.spacing.s4,
          children: [
            MinButton(
              variant: MinButtonVariant.ghost,
              child: MinBadgeWrapper(
                label: const Text('3', style: TextStyle(fontSize: 10)),
                variant: MinBadgeVariant.destructive,
                child: const Icon(TablerIcons.bell, size: 28),
              ),
              onPressed: () {},
            ),
            MinBadgeWrapper(
              label: const Text('99+', style: TextStyle(fontSize: 10)),
              variant: MinBadgeVariant.primary,
              position: MinBadgePosition.topRight,
              child: MinButton(
                variant: MinButtonVariant.ghost,
                child: const Icon(TablerIcons.message, size: 28),
                onPressed: () {},
              ),
            ),
            MinBadgeWrapper(
              label: const Icon(TablerIcons.circle, size: 15),
              variant: MinBadgeVariant.destructive,
              position: MinBadgePosition.bottomRight,
              child: MinButton(
                variant: MinButtonVariant.ghost,
                child: const Icon(TablerIcons.user, size: 30),
                onPressed: () {},
              ),
            ),
            MinBadgeWrapper(
              label: const Text('!'),
              variant: MinBadgeVariant.outline,
              position: MinBadgePosition.bottomLeft,
              child: MinButton(
                variant: MinButtonVariant.ghost,
                child: const Icon(TablerIcons.settings, size: 30),
                onPressed: () {},
              ),
            ),
          ],
        ),
        SizedBox(height: theme.spacing.s6),
        const SectionTitle('Wrapper con Badge Customizado'),
        SizedBox(height: theme.spacing.s4),
        Align(
          alignment: Alignment.centerLeft,
          child: MinBadgeWrapper(
            label: const Text('Custom'),
            variant: MinBadgeVariant.primary,
            badgeDecoration: BoxDecoration(
              color: Color.fromARGB(255, 239, 228, 71),
              borderRadius: BorderRadius.circular(theme.radius.sm),
              border: Border.all(color: Color.fromARGB(255, 38, 183, 52)),
            ),
            offset: Offset(15, 15),
            child: MinButton(
              variant: MinButtonVariant.secondary,
              child: const Text('Badge Customizado'),
              onPressed: () {},
            ),
          ),
        ),
        SizedBox(height: theme.spacing.s6),
        const SectionTitle('Wrapper posición custom'),
        SizedBox(height: theme.spacing.s4),
        Align(
          alignment: Alignment.centerLeft,
          child: MinBadgeWrapper(
            label: const Text('Custom'),
            variant: MinBadgeVariant.destructive,
            position: MinBadgePosition.topRight,
            offset: const Offset(-15, 15),
            child: MinButton(
              variant: MinButtonVariant.primary,
              child: const Text('offset(-15,15)'),
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }
}
