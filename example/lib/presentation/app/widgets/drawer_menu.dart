import 'package:flutter/widgets.dart';
import 'package:mini_ui_flutter/miniui.dart';

import '../app_cubit.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({
    super.key,
    required this.controller,
    required this.selected,
    required this.onSelect,
  });

  final MinDrawerController controller;
  final AppSection selected;
  final ValueChanged<AppSection> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(theme.spacing.s3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: theme.spacing.s4),
              child: Text(
                'MiniUI',
                style: theme.typography.h2.copyWith(
                  color: theme.colors.foreground,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: AppSection.values
                    .where((s) => s != AppSection.settings)
                    .map((section) {
                      final isSelected = section == selected;
                      return MinButton(
                        variant: isSelected
                            ? MinButtonVariant.secondary
                            : MinButtonVariant.ghost,
                        onPressed: () {
                          onSelect(section);
                          controller.closeDrawer();
                        },
                        child: Row(
                          children: [
                            Icon(section.icon, size: 20),
                            SizedBox(width: theme.spacing.s3),
                            Text(section.label),
                          ],
                        ),
                      );
                    })
                    .toList(),
              ),
            ),
            Container(height: 1, color: theme.colors.border),
            MinButton(
              variant: selected == AppSection.settings
                  ? MinButtonVariant.secondary
                  : MinButtonVariant.ghost,
              onPressed: () {
                onSelect(AppSection.settings);
                controller.closeDrawer();
              },
              child: Row(
                children: [
                  Icon(AppSection.settings.icon, size: 20),
                  SizedBox(width: theme.spacing.s3),
                  Text(AppSection.settings.label),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
