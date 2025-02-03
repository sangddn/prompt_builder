import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../core/core.dart';
import '../components.dart';

class SnippetVariables extends AnimatedStatelessWidget {
  const SnippetVariables({required this.variables, super.key});

  final IMap<String, String> variables;

  @override
  Widget buildChild(BuildContext context) {
    if (variables.isEmpty) {
      return Text(
        'Use {{X=Y}} to insert variable `X` with default value `Y`.',
        style: context.textTheme.muted,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Variables', style: context.textTheme.muted),
        const Gap(8.0),
        ...variables.entries.indexedExpand(
          (i, e) => [
            Row(
              children: [
                Text(e.key),
                const Spacer(),
                Text(
                  e.value.isEmpty ? 'n/a' : e.value,
                  style: context.textTheme.muted,
                ),
              ],
            ),
            if (i < variables.length - 1) const Gap(4.0),
          ],
        ),
      ],
    );
  }
}
