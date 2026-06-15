import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_ui_flutter/miniui.dart';

import '../app_cubit.dart';
import 'section_title.dart';

class DatePickerView extends StatelessWidget {
  const DatePickerView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final cubit = context.read<AppViewCubit>();

    return ListView(
      padding: EdgeInsets.all(theme.spacing.s4),
      children: [
        const SectionTitle('Selector de fecha'),
        SizedBox(height: theme.spacing.s2),
        MinDatePicker(
          value: context.watch<AppViewCubit>().state.selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          onChanged: (date) => cubit.setSelectedDate(date),
        ),
      ],
    );
  }
}
