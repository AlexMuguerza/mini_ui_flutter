import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:mini_ui_flutter/miniui.dart';

import 'app_cubit.dart';
import 'widgets/app_bar_view.dart';
import 'widgets/buttons_view.dart';
import 'widgets/cards_view.dart';
import 'widgets/checkboxes_view.dart';
import 'widgets/date_picker_view.dart';
import 'widgets/inputs_view.dart';
import 'widgets/select_view.dart';
import 'widgets/switches_view.dart';
import 'widgets/button_group_view.dart';

class AppView extends StatelessWidget {
  AppView({super.key});

  final _drawerController = MinDrawerController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppViewCubit, AppViewState>(
      builder: (context, state) {
        final isDark =
            context.watch<AppCubit>().state.mode == MinThemeMode.dark;
        return MinScaffold(
          drawerController: _drawerController,
          drawer: _DrawerMenu(
            controller: _drawerController,
            selected: state.selectedSection,
            onSelect: (section) {
              context.read<AppViewCubit>().setSection(section);
            },
          ),
          appBar: MinAppBar(
            title: Text(state.selectedSection.label),
            leading: MinButton(
              variant: MinButtonVariant.ghost,
              child: const Icon(TablerIcons.menu_3),
              onPressed: () => _drawerController.openDrawer(),
            ),
            trailing: MinButton(
              variant: MinButtonVariant.ghost,
              child: Icon(isDark ? TablerIcons.sun : TablerIcons.moon),
              onPressed: () => context.read<AppCubit>().toggleTheme(),
            ),
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, AppViewState state) {
    final section = state.selectedSection;
    if (section == AppSection.buttons) return const ButtonsView();
    if (section == AppSection.cards) return const CardsView();
    if (section == AppSection.inputs) return const InputsView();
    if (section == AppSection.switches) return const SwitchesView();
    if (section == AppSection.checkboxes) return const CheckboxesView();
    if (section == AppSection.appBar) return const AppBarView();
    if (section == AppSection.datePicker) return const DatePickerView();
    if (section == AppSection.buttonGroup) return const ButtonGroupView();
    return const SelectView();
  }
}

// ---------------------------------------------------------------------------
// Drawer menu
// ---------------------------------------------------------------------------

class _DrawerMenu extends StatelessWidget {
  const _DrawerMenu({
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
              padding: EdgeInsets.only(
                bottom: theme.spacing.s4,
                top: theme.spacing.s2,
              ),
              child: Text(
                'MiniUI',
                style: theme.typography.h2.copyWith(
                  color: theme.colors.foreground,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: AppSection.values.map((section) {
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
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
