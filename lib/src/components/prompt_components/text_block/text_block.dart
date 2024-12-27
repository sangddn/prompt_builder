import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../database/database.dart';
import '../../components.dart';

class TextBlock extends BaseBlock {
  const TextBlock({
    required super.database,
    required super.block,
    super.key,
  });

  @override
  Widget buildBlock(BuildContext context) {
    final style = context.textTheme.p;
    return MultiProvider(
      providers: [
        Provider.value(value: block),
      ],
      builder: (context, _) => Column(
        children: [
          TextFormField(
            initialValue: block.displayName,
            style: context.textTheme.muted,
            decoration: InputDecoration.collapsed(
              hintText: 'Instructions',
              hintStyle: context.textTheme.muted
                  .copyWith(color: PColors.textGray.resolveFrom(context)),
            ),
            onChanged: (value) =>
                database.updateBlock(block.id, displayName: value),
          ),
          TextFormField(
            initialValue: block.textContent,
            decoration: InputDecoration(
              hintText: 'You are a helpful assistant',
              hintStyle:
                  style.copyWith(color: PColors.textGray.resolveFrom(context)),
              border: InputBorder.none,
            ),
            minLines: 3,
            maxLines: null,
            style: style,
            onChanged: (value) =>
                database.updateBlock(block.id, textContent: value),
          ),
        ],
      ),
    );
  }
}
