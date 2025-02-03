import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../core/core.dart';
import '../../services/services.dart';

class EstimatedTokenCounter extends StatelessWidget {
  const EstimatedTokenCounter({
    this.countTokens,
    this.watchContent,
    super.key,
  }) : assert(countTokens != null || watchContent != null);

  final int Function(BuildContext context)? countTokens;
  final String Function(BuildContext context)? watchContent;

  @override
  Widget build(BuildContext context) {
    final tokenCount = countTokens?.call(context) ??
        OpenAI().estimateTokens(watchContent!.call(context)).$1;
    return Row(
      children: [
        Expanded(child: Text('Estimated Tokens', style: context.textTheme.p)),
        _TokenEstimation(tokenCount, true),
      ],
    );
  }
}

class _TokenEstimation extends StatelessWidget {
  const _TokenEstimation(this.count, this.isFullContent);

  final int count;
  final bool isFullContent;

  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (_) => ShadPopoverController(),
      builder: (context, child) {
        final controller = context.read<ShadPopoverController>();
        return ShadPopover(
          controller: controller,
          popover: (context) {
            final textTheme = context.textTheme;
            return IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    count.toString(),
                    style: textTheme.large,
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    'Estimated ${isFullContent ? 'Full Content' : 'Summary'} Tokens',
                    style: textTheme.muted,
                  ),
                ],
              ),
            );
          },
          child: MouseRegion(
            onHover: (_) => controller.show(),
            onExit: (_) => controller.hide(),
            child: child,
          ),
        );
      },
      child: Text(
        formatTokenCount(count),
        style: context.textTheme.small.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
