import 'package:flutter/widgets.dart';
import 'package:mini_ui_flutter/miniui.dart';

import 'section_title.dart';

class ProgressView extends StatefulWidget {
  const ProgressView({super.key});

  @override
  State<ProgressView> createState() => _ProgressViewState();
}

class _ProgressViewState extends State<ProgressView> {
  double _linearValue = 0.4;
  double _circularValue = 0.4;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return SingleChildScrollView(
      padding: EdgeInsets.all(theme.spacing.s6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Linear Progress'),
          SizedBox(height: theme.spacing.s4),
          MinProgress(value: _linearValue),
          SizedBox(height: theme.spacing.s4),
          Text(
            'Value: ${(_linearValue * 100).toInt()}%',
            style: theme.typography.small.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          SizedBox(height: theme.spacing.s2),
          Row(
            children: [
              MinButton(
                onPressed: () {
                  setState(() {
                    _linearValue = (_linearValue + 0.1).clamp(0.0, 1.0);
                  });
                },
                child: const Text('Increase'),
              ),
              SizedBox(width: theme.spacing.s2),
              MinButton(
                onPressed: () {
                  setState(() {
                    _linearValue = (_linearValue - 0.1).clamp(0.0, 1.0);
                  });
                },
                child: const Text('Decrease'),
              ),
            ],
          ),
          SizedBox(height: theme.spacing.s8),
          const SectionTitle('Linear Indeterminate'),
          SizedBox(height: theme.spacing.s4),
          const MinProgress(),
          SizedBox(height: theme.spacing.s8),
          const SectionTitle('Circular Progress'),
          SizedBox(height: theme.spacing.s4),
          Center(
            child: MinProgress(
              value: _circularValue,
              variant: MinProgressVariant.circular,
              size: 50,
            ),
          ),
          SizedBox(height: theme.spacing.s4),
          Center(
            child: Text(
              'Value: ${(_circularValue * 100).toInt()}%',
              style: theme.typography.small.copyWith(
                color: theme.colors.mutedForeground,
              ),
            ),
          ),
          SizedBox(height: theme.spacing.s2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MinButton(
                onPressed: () {
                  setState(() {
                    _circularValue = (_circularValue + 0.1).clamp(0.0, 1.0);
                  });
                },
                child: const Text('Increase'),
              ),
              SizedBox(width: theme.spacing.s2),
              MinButton(
                onPressed: () {
                  setState(() {
                    _circularValue = (_circularValue - 0.1).clamp(0.0, 1.0);
                  });
                },
                child: const Text('Decrease'),
              ),
            ],
          ),
          SizedBox(height: theme.spacing.s8),
          const SectionTitle('Circular Indeterminate'),
          SizedBox(height: theme.spacing.s4),
          const Center(
            child: MinProgress(variant: MinProgressVariant.circular, size: 50),
          ),
        ],
      ),
    );
  }
}
