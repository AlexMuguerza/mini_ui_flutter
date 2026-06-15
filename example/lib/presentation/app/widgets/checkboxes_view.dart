import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniui/miniui.dart';

import '../app_cubit.dart';
import 'section_title.dart';

class CheckboxesView extends StatelessWidget {
  const CheckboxesView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final cubit = context.read<AppViewCubit>();
    final state = context.watch<AppViewCubit>().state;

    return ListView(
      padding: EdgeInsets.all(theme.spacing.s4),
      children: [
        const SectionTitle('Tamaños'),
        SizedBox(height: theme.spacing.s2),
        for (final size in MinCheckboxSize.values)
          Padding(
            padding: EdgeInsets.only(bottom: theme.spacing.s3),
            child: Row(
              children: [
                MinCheckbox(
                  value: state.checkboxValue,
                  size: size,
                  onChanged: (_) => cubit.toggleCheckboxValue(),
                ),
                SizedBox(width: theme.spacing.s3),
                Text(size.name.toUpperCase()),
              ],
            ),
          ),
        SizedBox(height: theme.spacing.s6),
        const SectionTitle('Estados'),
        SizedBox(height: theme.spacing.s2),
        Row(
          children: [
            const MinCheckbox(value: false, onChanged: null),
            SizedBox(width: theme.spacing.s3),
            const Text('Unchecked + Disabled'),
          ],
        ),
        SizedBox(height: theme.spacing.s3),
        Row(
          children: [
            const MinCheckbox(value: true, onChanged: null),
            SizedBox(width: theme.spacing.s3),
            const Text('Checked + Disabled'),
          ],
        ),
      ],
    );
  }
}
