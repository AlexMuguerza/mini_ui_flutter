import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniui/miniui.dart';

import '../app_cubit.dart';
import 'section_title.dart';

enum AlignmentOption { left, center, right }

class ButtonGroupView extends StatelessWidget {
  const ButtonGroupView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final cubit = context.read<AppViewCubit>();

    return ListView(
      padding: EdgeInsets.all(theme.spacing.s4),
      children: [
        const SectionTitle('Button Group horizontal'),
        SizedBox(height: theme.spacing.s2),
        MinButtonGroup<AlignmentOption>(
          options: const [
            MinButtonGroupOption(value: AlignmentOption.left),
            MinButtonGroupOption(value: AlignmentOption.center),
            MinButtonGroupOption(value: AlignmentOption.right),
          ],
          value: _mapIndexToAlignment(
            context.watch<AppViewCubit>().state.selectedButtonGroupIndex,
          ),
          onChanged: (option) {
            final index = AlignmentOption.values.indexOf(option);
            cubit.setSelectedButtonGroupIndex(index);
          },
          labelBuilder: (option) => Text(_alignmentLabel(option)),
        ),
        SizedBox(height: theme.spacing.s6),
        const SectionTitle('Button Group vertical'),
        SizedBox(height: theme.spacing.s2),
        Row(
          children: [
            MinButtonGroup<String>(
              direction: Axis.vertical,
              options: const [
                MinButtonGroupOption(value: 'option1'),
                MinButtonGroupOption(value: 'option2'),
                MinButtonGroupOption(value: 'option3'),
              ],
              value: null,
              onChanged: (_) {},
              labelBuilder: (v) => Text(v),
            ),
          ],
        ),
        SizedBox(height: theme.spacing.s6),
        const SectionTitle('Button Group con deshabilitados'),
        SizedBox(height: theme.spacing.s2),
        MinButtonGroup<String>(
          options: const [
            MinButtonGroupOption(value: 'active'),
            MinButtonGroupOption(value: 'disabled', enabled: false),
            MinButtonGroupOption(value: 'also_active'),
          ],
          value: 'active',
          onChanged: (_) {},
          labelBuilder: (v) => Text(v),
        ),
        SizedBox(height: theme.spacing.s6),
        const SectionTitle('Button Group sizes'),
        SizedBox(height: theme.spacing.s2),
        MinButtonGroup<String>(
          size: MinButtonSize.sm,
          options: const [
            MinButtonGroupOption(value: 'a'),
            MinButtonGroupOption(value: 'b'),
          ],
          value: 'a',
          onChanged: (_) {},
          labelBuilder: (v) => Text(v),
        ),
        SizedBox(height: theme.spacing.s3),
        MinButtonGroup<String>(
          size: MinButtonSize.md,
          options: const [
            MinButtonGroupOption(value: 'a'),
            MinButtonGroupOption(value: 'b'),
          ],
          value: 'a',
          onChanged: (_) {},
          labelBuilder: (v) => Text(v),
        ),
        SizedBox(height: theme.spacing.s3),
        MinButtonGroup<String>(
          size: MinButtonSize.lg,
          options: const [
            MinButtonGroupOption(value: 'a'),
            MinButtonGroupOption(value: 'b'),
          ],
          value: 'a',
          onChanged: (_) {},
          labelBuilder: (v) => Text(v),
        ),
      ],
    );
  }

  AlignmentOption _mapIndexToAlignment(int index) {
    if (index < 0 || index >= AlignmentOption.values.length) {
      return AlignmentOption.left;
    }
    return AlignmentOption.values[index];
  }

  String _alignmentLabel(AlignmentOption option) {
    switch (option) {
      case AlignmentOption.left:
        return 'Izquierda';
      case AlignmentOption.center:
        return 'Centro';
      case AlignmentOption.right:
        return 'Derecha';
    }
  }
}
