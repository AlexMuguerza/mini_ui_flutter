import 'package:flutter/widgets.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:mini_ui_flutter/miniui.dart';

import 'section_title.dart';

class AccordionView extends StatefulWidget {
  const AccordionView({super.key});

  @override
  State<AccordionView> createState() => _AccordionViewState();
}

class _AccordionViewState extends State<AccordionView> {
  Set<String> _singleValue = {};
  Set<String> _multipleValue = {'1'};

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return ListView(
      padding: EdgeInsets.all(theme.spacing.s4),
      children: [
        SectionTitle('Single (default)'),
        SizedBox(height: theme.spacing.s2),
        MinAccordion<String>(
          value: _singleValue,
          onChanged: (v) => setState(() => _singleValue = v),
          options: const [
            MinAccordionOption(
              value: '1',
              header: Text('¿Qué es MiniUI?'),
              body: Text(
                'MiniUI es una librería de componentes Flutter inspirada en shadcn/ui.',
              ),
            ),
            MinAccordionOption(
              value: '2',
              header: Text('¿Cómo se usa?'),
              body: Text(
                'Solo envuelve tu app en MinTheme y usa los componentes.',
              ),
            ),
            MinAccordionOption(
              value: '3',
              header: Text('Deshabilitado'),
              body: Text('Este item no se puede abrir.'),
              disabled: true,
            ),
          ],
        ),
        SizedBox(height: theme.spacing.s6),
        SectionTitle('Multiple'),
        SizedBox(height: theme.spacing.s2),
        MinAccordion<String>(
          multiple: true,
          value: _multipleValue,
          onChanged: (v) => setState(() => _multipleValue = v),
          options: const [
            MinAccordionOption(
              value: '1',
              header: Text('Item 1'),
              body: Text('Contenido del primer item.'),
            ),
            MinAccordionOption(
              value: '2',
              header: Text('Item 2'),
              body: Text('Contenido del segundo item.'),
            ),
          ],
        ),
        SizedBox(height: theme.spacing.s6),
        SectionTitle('Sizes'),
        SizedBox(height: theme.spacing.s2),
        for (final size in MinAccordionSize.values)
          Padding(
            padding: EdgeInsets.only(bottom: theme.spacing.s2),
            child: MinAccordion<String>(
              size: size,
              value: {'1'},
              options: [
                MinAccordionOption(
                  value: '1',
                  header: Text('Size ${size.name.toUpperCase()}'),
                  body: const Text('Body del acordeón.'),
                ),
              ],
            ),
          ),

        SectionTitle('En un card'),
        SizedBox(height: theme.spacing.s2),
        MinCard(
          child: MinAccordion<String>(
            value: _singleValue,
            onChanged: (value) {
              setState(() => _singleValue = value);
            },
            options: const [
              MinAccordionOption(
                value: '1',
                header: Text('Item 1'),
                body: Text('Contenido del primer item.'),
              ),
              MinAccordionOption(
                value: '2',
                header: Text('Item 2'),
                body: Text('Contenido del segundo item.'),
              ),
            ],
          ),
        ),
        SizedBox(height: theme.spacing.s6),
        SectionTitle('Custom chevron'),
        SizedBox(height: theme.spacing.s2),
        MinAccordion<String>(
          value: {'1'},
          options: const [
            MinAccordionOption(
              value: '1',
              header: Text('Item con icono'),
              body: Text('Chevron reemplazado por un icono.'),
            ),
          ],
          icon: Icon(TablerIcons.activity, size: 18),
        ),
      ],
    );
  }
}
