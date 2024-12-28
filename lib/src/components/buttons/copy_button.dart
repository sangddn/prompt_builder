import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import '../../core/core.dart';
import '../components.dart';

class CopyButton extends StatelessWidget {
  const CopyButton({
    this.foregroundColor,
    this.backgroundColor,
    this.cornerRadius,
    required this.data,
    this.label = 'Copy',
    super.key,
  });

  final Color? foregroundColor;
  final Color? backgroundColor;
  final double? cornerRadius;
  final String Function() data;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final foregroundColor =
        this.foregroundColor ?? theme.colorScheme.accentForeground;

    return FeedbackButton<bool>(
      feedbackBuilder: (_, hide, isSuccess) {
        if (isSuccess == null) {
          return const Icon(HugeIcons.strokeRoundedCopy01);
        }
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSuccess
                  ? HugeIcons.strokeRoundedCheckmarkBadge01
                  : HugeIcons.strokeRoundedAlert01,
            ),
            const Gap(8.0),
            if (isSuccess)
              const Text('Copied!')
            else
              const Text('Copy failed.'),
          ],
        );
      },
      builder: (_, show) => CButton(
        tooltip: 'Copy',
        padding: k16H8VPadding,
        cornerRadius: cornerRadius ?? 8.0,
        color: backgroundColor ?? theme.colorScheme.accent,
        onTap: () {
          try {
            Clipboard.setData(
              ClipboardData(
                text: data(),
              ),
            );
            show(true);
          } catch (_) {
            show(false);
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              HugeIcons.strokeRoundedCopy01,
              size: 16.0,
              color: foregroundColor,
            ),
            if (label != null) ...[
              const Gap(8.0),
              Flexible(
                child: Text(
                  label!,
                  style: theme.textTheme.p.copyWith(color: foregroundColor),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
