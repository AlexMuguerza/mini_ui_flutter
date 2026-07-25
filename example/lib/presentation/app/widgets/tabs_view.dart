import 'package:flutter/widgets.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:mini_ui_flutter/miniui.dart';

import 'section_title.dart';

class TabsView extends StatefulWidget {
  const TabsView({super.key});

  @override
  State<TabsView> createState() => _TabsViewState();
}

class _TabsViewState extends State<TabsView> {
  String _underlineValue = 'tab1';
  String? _iconTabValue;
  String? _scrollableValue;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    final tabs = [
      MinTabsOption(value: 'tab1', label: const Text('Tab 1')),
      MinTabsOption(value: 'tab2', label: const Text('Tab 2')),
      MinTabsOption(value: 'tab3', label: const Text('Tab 3')),
    ];

    return ListView(
      padding: EdgeInsets.all(theme.spacing.s4),
      children: [
        const SectionTitle('Underline'),
        SizedBox(height: theme.spacing.s2),
        Align(
          alignment: AlignmentGeometry.centerLeft,
          child: MinTabs<String>(
            options: tabs,
            value: _underlineValue,
            onChanged: (v) => setState(() => _underlineValue = v),
          ),
        ),
        SizedBox(height: theme.spacing.s6),
        const SectionTitle('Pill'),
        SizedBox(height: theme.spacing.s2),
        Align(
          alignment: AlignmentGeometry.centerLeft,
          child: MinTabs<String>(
            options: tabs,
            value: _underlineValue,
            variant: MinTabsVariant.pill,
            onChanged: (v) => setState(() => _underlineValue = v),
          ),
        ),
        SizedBox(height: theme.spacing.s6),
        const SectionTitle('Con iconos'),
        SizedBox(height: theme.spacing.s2),
        MinTabs<String>(
          options: const [
            MinTabsOption(
              value: 'chat',
              label: Text('Chat'),
              icon: Icon(TablerIcons.message),
            ),
            MinTabsOption(
              value: 'calls',
              label: Text('Calls'),
              icon: Icon(TablerIcons.phone),
            ),
            MinTabsOption(
              value: 'settings',
              label: Text('Settings'),
              icon: Icon(TablerIcons.settings),
            ),
          ],
          value: _iconTabValue,
          variant: MinTabsVariant.underline,
          onChanged: (v) => setState(() => _iconTabValue = v),
        ),
        SizedBox(height: theme.spacing.s6),
        const SectionTitle('Deshabilitado'),
        SizedBox(height: theme.spacing.s2),
        MinTabs<String>(
          options: const [
            MinTabsOption(value: 'a', label: Text('Activo')),
            MinTabsOption(value: 'b', label: Text('Inactivo'), disabled: true),
            MinTabsOption(value: 'c', label: Text('Activo')),
          ],
          value: 'a',
          onChanged: (_) {},
        ),
        SizedBox(height: theme.spacing.s6),
        const SectionTitle('Scroll horizontal'),
        SizedBox(height: theme.spacing.s2),
        MinTabs<String>(
          scrollable: true,
          options: const [
            MinTabsOption(value: 'lorem', label: Text('Lorem')),
            MinTabsOption(value: 'ipsum', label: Text('Ipsum')),
            MinTabsOption(value: 'dolor', label: Text('Dolor')),
            MinTabsOption(value: 'sit', label: Text('Sit amet')),
            MinTabsOption(value: 'consectetur', label: Text('Consectetur')),
            MinTabsOption(value: 'adipiscing', label: Text('Adipiscing')),
          ],
          value: _scrollableValue,
          onChanged: (v) => setState(() => _scrollableValue = v),
        ),
        SizedBox(height: theme.spacing.s3),
        MinTabs<String>(
          scrollable: true,
          variant: MinTabsVariant.pill,
          options: const [
            MinTabsOption(value: 'lorem', label: Text('Lorem')),
            MinTabsOption(value: 'ipsum', label: Text('Ipsum')),
            MinTabsOption(value: 'dolor', label: Text('Dolor')),
            MinTabsOption(value: 'sit', label: Text('Sit amet')),
            MinTabsOption(value: 'consectetur', label: Text('Consectetur')),
            MinTabsOption(value: 'adipiscing', label: Text('Adipiscing')),
          ],
          value: _scrollableValue,
          onChanged: (v) => setState(() => _scrollableValue = v),
        ),
        SizedBox(height: theme.spacing.s6),
        const SectionTitle('Tamaños'),
        SizedBox(height: theme.spacing.s2),
        for (final size in MinTabsSize.values) ...[
          MinTabs<String>(
            options: tabs,
            value: 'tab1',
            size: size,
            onChanged: (_) {},
          ),
          SizedBox(height: theme.spacing.s3),
        ],
      ],
    );
  }
}
