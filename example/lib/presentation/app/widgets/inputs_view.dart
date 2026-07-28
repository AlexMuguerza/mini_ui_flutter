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
        SizedBox(height: theme.spacing.s6),
        const SectionTitle('Form fields (MinFormInput)'),
        SizedBox(height: theme.spacing.s2),
        const _FormFieldsDemo(),
      ],
    );
  }
}

class _FormFieldsDemo extends StatefulWidget {
  const _FormFieldsDemo();

  @override
  State<_FormFieldsDemo> createState() => _FormFieldsDemoState();
}

class _FormFieldsDemoState extends State<_FormFieldsDemo> {
  final _formKey = GlobalKey<FormState>();
  String _savedSummary = '';

  String? _emailValidator(String? v) =>
      (v == null || !v.contains('@')) ? 'Email inválido' : null;

  String? _requiredMin6(String? v) =>
      (v == null || v.length < 6) ? 'Mínimo 6 caracteres' : null;

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
    }
  }

  void _reset() {
    _formKey.currentState!.reset();
    setState(() => _savedSummary = '');
  }

  void _updateSummary(String field, String? value) {
    final entry = '$field=$value';
    setState(() {
      _savedSummary = _savedSummary.isEmpty ? entry : '$_savedSummary, $entry';
    });
  }

  void _clearSummary() {
    if (_savedSummary.isNotEmpty) {
      setState(() => _savedSummary = '');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MinFormInput(
            placeholder: 'Nombre',
            initialValue: 'Ada Lovelace',
            leading: const Icon(TablerIcons.user, size: 16),
            onSaved: (v) => _updateSummary('nombre', v),
            onChanged: (_) => _clearSummary(),
          ),
          SizedBox(height: theme.spacing.s3),
          MinFormInput(
            placeholder: 'tu@correo.com',
            type: MinInputType.email,
            keyboardType: TextInputType.emailAddress,
            leading: const Icon(TablerIcons.mail, size: 16),
            validator: _emailValidator,
            onSaved: (v) => _updateSummary('email', v),
            onChanged: (_) => _clearSummary(),
          ),
          SizedBox(height: theme.spacing.s3),
          MinFormInput(
            placeholder: 'Contraseña',
            type: MinInputType.password,
            obscureText: true,
            leading: const Icon(TablerIcons.lock, size: 16),
            validator: _requiredMin6,
            onSaved: (v) => _updateSummary('pass', v),
            onChanged: (_) => _clearSummary(),
          ),
          SizedBox(height: theme.spacing.s3),
          MinFormInput(
            placeholder: 'Bio',
            type: MinInputType.multiline,
            minLines: 2,
            maxLines: 4,
            onSaved: (v) => _updateSummary('bio', v),
            onChanged: (_) => _clearSummary(),
          ),
          SizedBox(height: theme.spacing.s3),
          MinFormInput(
            placeholder: 'Disabled',
            initialValue: 'Disablesd value',
            leading: const Icon(TablerIcons.info_circle, size: 16),
            onSaved: (v) => _updateSummary('disabled', v),
            onChanged: (_) => _clearSummary(),
            enabled: false,
          ),
          SizedBox(height: theme.spacing.s4),
          Wrap(
            spacing: theme.spacing.s2,
            children: [
              MinButton(
                variant: MinButtonVariant.primary,
                onPressed: _save,
                child: const Text('Guardar'),
              ),
              MinButton(
                variant: MinButtonVariant.outline,
                onPressed: _reset,
                child: const Text('Reset'),
              ),
            ],
          ),
          if (_savedSummary.isNotEmpty) ...[
            SizedBox(height: theme.spacing.s3),
            Text(
              'Guardado: $_savedSummary',
              style: theme.typography.small.copyWith(
                color: theme.colors.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
