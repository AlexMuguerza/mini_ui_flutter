import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:miniui/miniui.dart';

import '../app_cubit.dart';
import 'section_title.dart';

class SelectView extends StatelessWidget {
  const SelectView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final cubit = context.read<AppViewCubit>();

    return ListView(
      padding: EdgeInsets.all(theme.spacing.s4),
      children: [
        const SectionTitle('Select simple'),
        SizedBox(height: theme.spacing.s2),
        MinSelect<String>(
          value: context.watch<AppViewCubit>().state.selectedValue,
          options: const [
            MinSelectOption(value: 'option1', label: 'Opción 1'),
            MinSelectOption(value: 'option2', label: 'Opción 2'),
            MinSelectOption(value: 'option3', label: 'Opción 3'),
            MinSelectOption(value: 'option4', label: 'Opción 4'),
          ],
          onChanged: (v) => cubit.setSelectedValue(v),
        ),
        SizedBox(height: theme.spacing.s6),
        const SectionTitle('Select con búsqueda'),
        SizedBox(height: theme.spacing.s2),
        MinSelect<String>(
          value: context.watch<AppViewCubit>().state.selectedCountry,
          searchable: true,
          searchPlaceholder: 'Buscar país...',
          options: const [
            MinSelectSection(label: 'América'),
            MinSelectOption(value: 'mx', label: 'México'),
            MinSelectOption(value: 'ar', label: 'Argentina'),
            MinSelectOption(value: 'co', label: 'Colombia'),
            MinSelectOption(value: 'cl', label: 'Chile'),
            MinSelectSection(label: 'Europa'),
            MinSelectOption(value: 'es', label: 'España'),
            MinSelectOption(value: 'fr', label: 'Francia'),
            MinSelectOption(value: 'de', label: 'Alemania'),
            MinSelectOption(value: 'it', label: 'Italia'),
          ],
          onChanged: (v) => cubit.setSelectedCountry(v),
        ),
        SizedBox(height: theme.spacing.s6),
        const SectionTitle('Select con leading/trailing'),
        SizedBox(height: theme.spacing.s2),
        MinSelect<String>(
          value: context.watch<AppViewCubit>().state.selectedAction,
          options: [
            MinSelectOption(
              value: 'edit',
              label: 'Editar',
              leading: const Icon(TablerIcons.pencil),
            ),
            MinSelectOption(
              value: 'copy',
              label: 'Copiar',
              leading: const Icon(TablerIcons.copy),
            ),
            MinSelectOption(
              value: 'delete',
              label: 'Eliminar',
              leading: const Icon(TablerIcons.trash),
              trailing: Text(
                '3',
                style: theme.typography.small.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
            ),
          ],
          onChanged: (v) => cubit.setSelectedAction(v),
        ),
      ],
    );
  }
}
