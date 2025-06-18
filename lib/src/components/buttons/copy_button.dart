import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../core/core.dart';
import '../../services/clipboard_service.dart';
import '../components.dart';

class CopyButton extends StatelessWidget {
  const CopyButton({
    this.foregroundColor,
    this.backgroundColor,
    this.cornerRadius,
    required this.data,
    this.label = 'Copy',
    super.key,
  }) : builder = null;

  const CopyButton.builder({
    required this.data,
    required this.builder,
    super.key,
  }) : foregroundColor = null,
       backgroundColor = null,
       cornerRadius = null,
       label = null;

  final Color? foregroundColor;
  final Color? backgroundColor;
  final double? cornerRadius;
  final dynamic Function() data;
  final String? label;
  final Widget Function(
    BuildContext context,
    ValueChanged<bool?> showFeedback,
    VoidCallback copy,
  )?
  builder;

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
        return Padding(
          padding: k8H4VPadding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSuccess
                    ? HugeIcons.strokeRoundedCheckmarkBadge04
                    : HugeIcons.strokeRoundedAlert01,
              ),
              const Gap(8.0),
              if (isSuccess)
                const Text('Copied!')
              else
                const Text('Copy failed.'),
            ],
          ),
        );
      },
      builder: (context, show) {
        Future<void> callback() async {
          try {
            final data = await Future.value(this.data());
            await ClipboardService.write(data);
            if (context.mounted) {
              show(true);
            }
          } catch (e) {
            debugPrint('Copy failed: $e');
            if (context.mounted) {
              show(false);
            }
          }
        }

        return builder?.call(context, show, callback) ??
            CButton(
              tooltip: 'Copy',
              padding: k16H8VPadding,
              cornerRadius: cornerRadius ?? 8.0,
              color: backgroundColor ?? theme.colorScheme.accent,
              onTap: callback,
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
                        style: theme.textTheme.p.copyWith(
                          color: foregroundColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ],
              ),
            );
      },
    );
  }
}
