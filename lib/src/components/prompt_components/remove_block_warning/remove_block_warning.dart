import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../components.dart';

Future<bool?> showRemoveBlockWarning(BuildContext context) => showPDialog<bool>(
  context: context,
  builder: (context) => const RemoveBlockWarning(),
);

class RemoveBlockWarning extends StatelessWidget {
  const RemoveBlockWarning({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadDialog.alert(
      title: const Text('Are you sure?'),
      description: const Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Text(
          'This will also delete all the generated content for this block, such as transcript and summary. '
          'You can save such content to your computer before deleting the block.',
        ),
      ),
      actions: [
        ShadButton.outline(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        ShadButton(
          child: const Text('Continue'),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}
