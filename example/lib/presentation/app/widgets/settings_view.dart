import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:mini_ui_flutter/miniui.dart';

import '../app_cubit.dart';
import 'section_title.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return SizedBox.expand(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(theme.spacing.s4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle('Theme Variant'),
            SizedBox(height: theme.spacing.s4),
            _ThemeOption(
              label: 'Zinc',
              description: 'Default neutral palette',
              selected:
                  context.watch<AppCubit>().state.variant == ThemeVariant.zinc,
              onTap: () =>
                  context.read<AppCubit>().setThemeVariant(ThemeVariant.zinc),
              previewColors: [theme.colors.background, theme.colors.primary],
            ),
            SizedBox(height: theme.spacing.s2),
            _ThemeOption(
              label: 'Slate',
              description: 'Blue-gray slate palette',
              selected:
                  context.watch<AppCubit>().state.variant == ThemeVariant.slate,
              onTap: () =>
                  context.read<AppCubit>().setThemeVariant(ThemeVariant.slate),
              previewColors: [theme.colors.background, theme.colors.primary],
            ),
            SizedBox(height: theme.spacing.s2),
            _ThemeOption(
              label: 'Violet',
              description: 'Violet purple palette',
              selected:
                  context.watch<AppCubit>().state.variant ==
                  ThemeVariant.custom,
              onTap: () =>
                  context.read<AppCubit>().setThemeVariant(ThemeVariant.custom),
              previewColors: [theme.colors.background, theme.colors.primary],
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.label,
    required this.description,
    required this.selected,
    required this.onTap,
    required this.previewColors,
  });

  final String label;
  final String description;
  final bool selected;
  final VoidCallback onTap;
  final List<Color> previewColors;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return MinButton(
      variant: selected ? MinButtonVariant.secondary : MinButtonVariant.outline,
      onPressed: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.typography.body.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: theme.typography.small.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          if (selected)
            Padding(
              padding: EdgeInsets.only(left: theme.spacing.s3),
              child: Icon(
                TablerIcons.check,
                size: 20,
                color: theme.colors.primary,
              ),
            ),
        ],
      ),
    );
  }
}
