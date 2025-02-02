import 'package:flutter/cupertino.dart';

import '../../core/core.dart';

TextSpan keyboardShortcutSpan(
  BuildContext context,
  bool command,
  bool shift,
  String key, [
  Color? color,
]) =>
    TextSpan(
      children: [
        if (command)
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: const EdgeInsets.only(right: 2.0),
              child: Icon(
                HugeIcons.strokeRoundedCommand,
                color: color ?? context.textTheme.muted.color,
                size: 14.0,
              ),
            ),
          ),
        if (shift)
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: const EdgeInsets.only(right: 2.0),
              child: Icon(
                CupertinoIcons.shift,
                color: color ?? context.textTheme.muted.color,
                size: 14.0,
              ),
            ),
          ),
        TextSpan(
          text: key,
          style: context.textTheme.muted.copyWith(color: color),
        ),
      ],
    );
