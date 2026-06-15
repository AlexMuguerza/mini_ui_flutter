import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:miniui/miniui.dart';

enum MinThemeMode { light, dark }

class AppState {
  const AppState({required this.mode, required this.theme});

  final MinThemeMode mode;
  final MinThemeData theme;

  AppState copyWith({MinThemeMode? mode, MinThemeData? theme}) {
    return AppState(mode: mode ?? this.mode, theme: theme ?? this.theme);
  }
}

class AppSection {
  const AppSection._(this.label, this.icon);

  final String label;
  final IconData icon;

  static const buttons = AppSection._('Buttons', TablerIcons.circle_plus);
  static const cards = AppSection._('Cards', TablerIcons.layout_cards);
  static const inputs = AppSection._('Inputs', TablerIcons.pencil);
  static const switches = AppSection._('Switches', TablerIcons.toggle_right);
  static const checkboxes = AppSection._('Checkboxes', TablerIcons.checkbox);
  static const appBar = AppSection._('App Bar', TablerIcons.layout_navbar);
  static const datePicker = AppSection._('Date Picker', TablerIcons.calendar);
  static const select = AppSection._('Select', TablerIcons.list);

  static const values = [
    buttons,
    cards,
    inputs,
    switches,
    checkboxes,
    appBar,
    datePicker,
    select,
  ];
}

class AppCubit extends Cubit<AppState> {
  AppCubit()
    : super(AppState(mode: MinThemeMode.light, theme: MinThemeData.light()));

  void setThemeMode(MinThemeMode mode) {
    emit(state.copyWith(mode: mode, theme: _resolveTheme(mode)));
  }

  void toggleTheme() {
    final next = state.mode == MinThemeMode.light
        ? MinThemeMode.dark
        : MinThemeMode.light;

    setThemeMode(next);
  }

  MinThemeData _resolveTheme(MinThemeMode mode) {
    switch (mode) {
      case MinThemeMode.dark:
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Color(0x00000000),
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Color(0x00000000),
            systemNavigationBarDividerColor: Color(0x00000000),
            systemNavigationBarIconBrightness: Brightness.light,
          ),
        );
        return MinThemeData.dark();
      case MinThemeMode.light:
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Color(0x00000000),
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Color(0x00000000),
            systemNavigationBarDividerColor: Color(0x00000000),
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
        );
        return MinThemeData.light();
    }
  }
}

class AppViewState {
  const AppViewState({
    this.isLoading = false,
    this.selectedValue = 'option1',
    this.selectedCountry,
    this.selectedAction,
    this.selectedDate,
    this.switchValue = false,
    this.textFieldValue,
    this.obscureTextValue = false,
    this.selectedSection = AppSection.buttons,
    this.checkboxValue = true,
  });

  final bool isLoading;
  final String selectedValue;
  final String? selectedCountry;
  final String? selectedAction;
  final DateTime? selectedDate;
  final bool switchValue;
  final String? textFieldValue;
  final bool obscureTextValue;
  final AppSection selectedSection;
  final bool checkboxValue;
  AppViewState copyWith({
    bool? isLoading,
    String? selectedValue,
    String? selectedCountry,
    String? selectedAction,
    DateTime? selectedDate,
    bool? switchValue,
    String? textFieldValue,
    bool? obscureTextValue,
    AppSection? selectedSection,
    bool? checkboxValue,
  }) {
    return AppViewState(
      isLoading: isLoading ?? this.isLoading,
      selectedValue: selectedValue ?? this.selectedValue,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedAction: selectedAction ?? this.selectedAction,
      selectedDate: selectedDate ?? this.selectedDate,
      switchValue: switchValue ?? this.switchValue,
      textFieldValue: textFieldValue ?? this.textFieldValue,
      obscureTextValue: obscureTextValue ?? this.obscureTextValue,
      selectedSection: selectedSection ?? this.selectedSection,
      checkboxValue: checkboxValue ?? this.checkboxValue,
    );
  }
}

class AppViewCubit extends Cubit<AppViewState> {
  AppViewCubit() : super(const AppViewState());

  void setLoading(bool value) => emit(state.copyWith(isLoading: value));

  Future<void> simulateLoading() async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(seconds: 2));
    emit(state.copyWith(isLoading: false));
  }

  void setSelectedValue(String? value) {
    emit(state.copyWith(selectedValue: value ?? state.selectedValue));
  }

  void setSelectedCountry(String? value) {
    emit(state.copyWith(selectedCountry: value));
  }

  void setSelectedAction(String? value) {
    emit(state.copyWith(selectedAction: value));
  }

  void setSelectedDate(DateTime? date) {
    emit(state.copyWith(selectedDate: date));
  }

  void toggleSwitch() {
    emit(state.copyWith(switchValue: !state.switchValue));
  }

  void setSwitchValue(bool value) {
    emit(state.copyWith(switchValue: value));
  }

  void setObscureTextValue(bool value) {
    emit(state.copyWith(obscureTextValue: value));
  }

  void setSection(AppSection section) {
    emit(state.copyWith(selectedSection: section));
  }

  void toggleCheckboxValue() {
    emit(state.copyWith(checkboxValue: !state.checkboxValue));
  }
}
