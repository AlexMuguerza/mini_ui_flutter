import 'package:flutter/widgets.dart';
import 'package:mini_ui_flutter/miniui.dart';

import 'section_title.dart';

class TooltipView extends StatelessWidget {
  const TooltipView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return SingleChildScrollView(
      padding: EdgeInsets.all(theme.spacing.s6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Basic Tooltip'),
          SizedBox(height: theme.spacing.s4),
          const MinTooltip(
            message: 'This is a basic tooltip',
            child: Text('Hover me'),
          ),
          SizedBox(height: theme.spacing.s6),
          const SectionTitle('Tooltip on a Button'),
          SizedBox(height: theme.spacing.s4),
          const MinTooltip(
            message: 'Click to perform an action',
            child: MinButton(
              onPressed: null,
              child: Text('Hover over this button'),
            ),
          ),
          SizedBox(height: theme.spacing.s6),
          const SectionTitle('Custom Delay'),
          SizedBox(height: theme.spacing.s4),
          const MinTooltip(
            message: 'This appears instantly',
            delay: Duration.zero,
            child: MinButton(
              onPressed: null,
              variant: MinButtonVariant.outline,
              child: Text('Instant tooltip'),
            ),
          ),
          SizedBox(height: theme.spacing.s12),
          const SectionTitle('Custom Placement'),
          SizedBox(height: theme.spacing.s4),
          Wrap(
            spacing: theme.spacing.s4,
            runSpacing: theme.spacing.s4,
            children: [
              const MinTooltip(
                message: 'Tooltip above',
                side: MinUiAnchorSide.above(),
                child: Text('Above'),
              ),
              const MinTooltip(
                message: 'Tooltip below',
                side: MinUiAnchorSide.below(),
                child: Text('Below'),
              ),
              const MinTooltip(
                message: 'Tooltip on the left',
                side: MinUiAnchorSide.left(),
                child: Text('Left'),
              ),
              const MinTooltip(
                message: 'Tooltip on the right',
                side: MinUiAnchorSide.right(),
                child: Text('Right'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
