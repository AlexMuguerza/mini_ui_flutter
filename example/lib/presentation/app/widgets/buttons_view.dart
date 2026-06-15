import 'package:flutter/widgets.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:mini_ui_flutter/miniui.dart';

import 'section_title.dart';

class ButtonsView extends StatelessWidget {
  const ButtonsView({super.key});

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
            for (final variant in MinButtonVariant.values)
              MinButton(
                variant: variant,
                onPressed: () {},
                child: Text(variant.name),
              ),
          ],
        ),
        SizedBox(height: theme.spacing.s6),
        const SectionTitle('Tamaños'),
        SizedBox(height: theme.spacing.s2),
        Wrap(
          spacing: theme.spacing.s2,
          runSpacing: theme.spacing.s2,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final size in MinButtonSize.values)
              MinButton(size: size, onPressed: () {}, child: Text(size.name)),
          ],
        ),
        SizedBox(height: theme.spacing.s6),
        const SectionTitle('Con leading / trailing'),
        SizedBox(height: theme.spacing.s2),
        Wrap(
          spacing: theme.spacing.s2,
          runSpacing: theme.spacing.s2,
          children: [
            MinButton(
              onPressed: () {},
              leading: const Icon(TablerIcons.plus),
              child: const Text('Crear'),
            ),
            MinButton(
              onPressed: () {},
              trailing: const Icon(TablerIcons.arrow_right),
              child: const Text('Siguiente'),
            ),
            MinButton(
              onPressed: () {},
              leading: const Icon(TablerIcons.download),
              trailing: const Icon(TablerIcons.chevron_down),
              child: const Text('Descargar'),
            ),
          ],
        ),
        SizedBox(height: theme.spacing.s6),
        const SectionTitle('Estados'),
        SizedBox(height: theme.spacing.s2),
        Wrap(
          spacing: theme.spacing.s2,
          runSpacing: theme.spacing.s2,
          children: [
            const MinButton(onPressed: null, child: Text('Disabled')),
            MinButton(
              onPressed: () {},
              loading: true,
              child: const Text('Loading'),
            ),
          ],
        ),
      ],
    );
  }
}
