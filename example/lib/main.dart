import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_ui_flutter/miniui.dart';

import 'presentation/app/app_cubit.dart';
import 'presentation/app/app_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AppCubit()),
        BlocProvider(create: (_) => AppViewCubit()),
      ],
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          return WidgetsApp(
            color: Color(0xffffffff),
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            builder: (context, child) {
              return MinTheme(
                data: state.theme,
                child: DefaultTextStyle(
                  style: state.theme.typography.body.copyWith(
                    color: state.theme.colors.foreground,
                  ),
                  child: child ?? const SizedBox.shrink(),
                ),
              );
            },
            routes: {'/': (context) => AppView()},
            pageRouteBuilder: <T>(settings, builder) {
              return PageRouteBuilder<T>(
                settings: settings,
                pageBuilder: (context, animation, secondaryAnimation) =>
                    builder(context),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      // transición simple tipo fade
                      return FadeTransition(opacity: animation, child: child);
                    },
              );
            },
          );
        },
      ),
    );
  }
}
