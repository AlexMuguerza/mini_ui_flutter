import 'package:flutter/widgets.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:miniui/miniui.dart';

import 'section_title.dart';

class AppBarView extends StatelessWidget {
  const AppBarView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return ListView(
      padding: EdgeInsets.all(theme.spacing.s4),
      children: [
        const SectionTitle('Tamaños'),
        SizedBox(height: theme.spacing.s2),
        for (final size in MinAppBarSize.values) ...[
          MinAppBar(
            title: Text('AppBar ${size.name.toUpperCase()}'),
            size: size,
            leading: const Icon(TablerIcons.menu_2),
            trailing: const Icon(TablerIcons.settings),
          ),
          SizedBox(height: theme.spacing.s3),
        ],
        SizedBox(height: theme.spacing.s6),
        const SectionTitle('Center title'),
        SizedBox(height: theme.spacing.s2),
        const MinAppBar(title: Text('Centrado'), centerTitle: true),
        SizedBox(height: theme.spacing.s6),
        const SectionTitle('Con elevación'),
        SizedBox(height: theme.spacing.s2),
        const MinAppBar(title: Text('Elevada'), elevation: true),
      ],
    );
  }
}
