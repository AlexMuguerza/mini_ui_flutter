import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:mini_ui_flutter/miniui.dart';
import 'section_title.dart';

class ToastView extends StatelessWidget {
  const ToastView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return SingleChildScrollView(
      padding: EdgeInsets.all(theme.spacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionTitle('Types'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              MinButton(
                onPressed: () => _showToast(context, MinToastType.info),
                child: const Text('Info'),
              ),
              MinButton(
                onPressed: () => _showToast(context, MinToastType.success),
                child: const Text('Success'),
              ),
              MinButton(
                onPressed: () => _showToast(context, MinToastType.warning),
                child: const Text('Warning'),
              ),
              MinButton(
                onPressed: () => _showToast(context, MinToastType.error),
                child: const Text('Error'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SectionTitle('Message'),
          const SizedBox(height: 8),
          MinButton(
            onPressed: () => _showToast(
              context,
              math.Random().nextBool()
                  ? MinToastType.info
                  : MinToastType.success,
              message:
                  'Este es un mensaje descriptivo más largo para probar el layout',
            ),
            child: const Text('With Description'),
          ),
          const SizedBox(height: 24),
          SectionTitle('Action'),
          const SizedBox(height: 8),
          MinButton(
            onPressed: () => _showToast(
              context,
              MinToastType.success,
              message: 'Archivo guardado correctamente',
              action: MinToastAction(label: 'Deshacer', onPressed: () {}),
            ),
            child: const Text('With Action Button'),
          ),
          const SizedBox(height: 24),
          SectionTitle('Duration'),
          const SizedBox(height: 8),
          MinButton(
            onPressed: () => _showToast(
              context,
              MinToastType.info,
              duration: const Duration(seconds: 8),
              message: 'Este toast dura 8 segundos',
            ),
            child: const Text('8 Seconds'),
          ),
          const SizedBox(height: 24),
          SectionTitle('Position'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              MinButton(
                onPressed: () => _showToast(
                  context,
                  MinToastType.info,
                  position: MinToastPosition.topRight,
                  message: 'Top Right',
                ),
                child: const Text('Top Right'),
              ),
              MinButton(
                onPressed: () => _showToast(
                  context,
                  MinToastType.info,
                  position: MinToastPosition.topLeft,
                  message: 'Top Left',
                ),
                child: const Text('Top Left'),
              ),
              MinButton(
                onPressed: () => _showToast(
                  context,
                  MinToastType.info,
                  position: MinToastPosition.bottomRight,
                  message: 'Bottom Right',
                ),
                child: const Text('Bottom Right'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SectionTitle('Custom Icon'),
          const SizedBox(height: 8),
          MinButton(
            onPressed: () => _showToast(
              context,
              MinToastType.success,
              icon: const Icon(TablerIcons.star, size: 20),
              message: 'Reemplaza el icono por defecto',
            ),
            child: const Text('Custom Icon'),
          ),
          const SizedBox(height: 24),
          SectionTitle('Multiple Toasts'),
          const SizedBox(height: 8),
          MinButton(
            onPressed: () {
              final ctx = context;
              _showToast(ctx, MinToastType.info, message: 'Toast 1');
              Future.delayed(const Duration(milliseconds: 300), () {
                _showToast(ctx, MinToastType.success, message: 'Toast 2');
              });
              Future.delayed(const Duration(milliseconds: 700), () {
                _showToast(ctx, MinToastType.warning, message: 'Toast 3');
              });
            },
            child: const Text('Show 3 Toasts'),
          ),
        ],
      ),
    );
  }

  void _showToast(
    BuildContext context,
    MinToastType type, {
    String? message,
    MinToastAction? action,
    Duration duration = const Duration(seconds: 4),
    MinToastPosition? position,
    Widget? icon,
  }) {
    final title = switch (type) {
      MinToastType.info => 'Información',
      MinToastType.success => 'Éxito',
      MinToastType.warning => 'Advertencia',
      MinToastType.error => 'Error',
    };

    MinToast.show(
      context: context,
      title: title,
      message: message,
      type: type,
      action: action,
      duration: duration,
      position: position,
      icon: icon,
      //maxVisible: 3,
    );
  }
}
