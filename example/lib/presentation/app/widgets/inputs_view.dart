import 'package:flutter/widgets.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:mini_ui_flutter/miniui.dart';

import 'section_title.dart';

class InputsView extends StatelessWidget {
  const InputsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return ListView(
      padding: EdgeInsets.all(theme.spacing.s4),
      children: [
        const SectionTitle('Tipos'),
        SizedBox(height: theme.spacing.s2),
        const MinInput(placeholder: 'Texto general', type: MinInputType.text),
        SizedBox(height: theme.spacing.s3),
        const MinInput(
          placeholder: 'Correo electrónico',
          type: MinInputType.email,
        ),
        SizedBox(height: theme.spacing.s3),
        const MinInput(placeholder: 'Contraseña', type: MinInputType.password),
        SizedBox(height: theme.spacing.s3),
        const MinInput(placeholder: 'Número', type: MinInputType.number),
        SizedBox(height: theme.spacing.s3),
        const MinInput(placeholder: 'Teléfono', type: MinInputType.phone),
        SizedBox(height: theme.spacing.s3),
        const MinInput(placeholder: 'URL', type: MinInputType.url),
        SizedBox(height: theme.spacing.s6),
        const SectionTitle('Con leading / trailing'),
        SizedBox(height: theme.spacing.s2),
        const MinInput(
          placeholder: 'Buscar...',
          leading: Icon(TablerIcons.search),
        ),
        SizedBox(height: theme.spacing.s3),
        MinInput(
          placeholder: 'Contraseña',
          type: MinInputType.password,
          trailing: GestureDetector(
            onTap: () {},
            child: const Icon(TablerIcons.eye),
          ),
        ),
        SizedBox(height: theme.spacing.s6),
        const SectionTitle('Estado de error'),
        SizedBox(height: theme.spacing.s2),
        const MinInput(
          placeholder: 'Campo con error',
          errorText: 'Este campo es obligatorio',
        ),
        SizedBox(height: theme.spacing.s6),
        const SectionTitle('Deshabilitado / ReadOnly'),
        SizedBox(height: theme.spacing.s2),
        const MinInput(placeholder: 'Deshabilitado', enabled: false),
        SizedBox(height: theme.spacing.s3),
        const MinInput(placeholder: 'Solo lectura', readOnly: true),
        SizedBox(height: theme.spacing.s6),
        const SectionTitle('Multilínea'),
        SizedBox(height: theme.spacing.s2),
        const MinInput(
          placeholder: 'Escribe un mensaje...',
          type: MinInputType.multiline,
          minLines: 3,
          maxLines: 5,
          maxLength: 150,
          showCounter: true,
        ),
      ],
    );
  }
}
