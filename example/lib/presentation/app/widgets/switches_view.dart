import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniui/miniui.dart';

import '../app_cubit.dart';
import 'section_title.dart';

class SwitchesView extends StatelessWidget {
  const SwitchesView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final cubit = context.read<AppViewCubit>();

    return ListView(
      padding: EdgeInsets.all(theme.spacing.s4),
      children: [
        const SectionTitle('Tamaños'),
        SizedBox(height: theme.spacing.s2),
        for (final size in MinSwitchSize.values) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(size.name.toUpperCase()),
              MinSwitch(
                value: context.watch<AppViewCubit>().state.switchValue,
                size: size,
                onChanged: (_) => cubit.toggleSwitch(),
              ),
            ],
          ),
          SizedBox(height: theme.spacing.s3),
        ],
        SizedBox(height: theme.spacing.s6),
        const SectionTitle('Deshabilitado'),
        SizedBox(height: theme.spacing.s2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('OFF + Disabled'),
            MinSwitch(value: false, disabled: true, onChanged: (_) {}),
          ],
        ),
        SizedBox(height: theme.spacing.s3),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('ON + Disabled'),
            MinSwitch(value: true, disabled: true, onChanged: (_) {}),
          ],
        ),
      ],
    );
  }
}
