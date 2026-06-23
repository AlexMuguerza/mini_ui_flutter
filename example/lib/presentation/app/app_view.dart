import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:mini_ui_flutter/miniui.dart';

import 'app_cubit.dart';
import 'widgets/widgets.dart';

class AppView extends StatelessWidget {
  AppView({super.key});

  final _drawerController = MinDrawerController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppViewCubit, AppViewState>(
      builder: (context, state) {
        final isDark =
            context.watch<AppCubit>().state.mode == MinThemeMode.dark;
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 959),
            child: MinScaffold(
              drawerController: _drawerController,
              drawer: DrawerMenu(
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
              body: SafeArea(top: false, child: _buildBody(context, state)),
            ),
          ),
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
    if (section == AppSection.progress) return const ProgressView();
    if (section == AppSection.tooltip) return const TooltipView();
    if (section == AppSection.toast) return const ToastView();
    if (section == AppSection.settings) return const SettingsView();
    return const SelectView();
  }
}
