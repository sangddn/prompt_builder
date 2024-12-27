import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../database/database.dart';
import '../../components.dart';

class PromptTile extends StatelessWidget {
  const PromptTile({
    this.onTap,
    required this.prompt,
    super.key,
  });

  final VoidCallback? onTap;
  final Prompt prompt;

  @override
  Widget build(BuildContext context) {
    return ListenableProvider<FocusNode>(
      create: (_) => FocusNode(),
      builder: (context, child) {
        final focusNode = context.read<FocusNode>();
        final hasFocus = context.watch<FocusNode>().hasFocus;
        return FocusableActionDetector(
          focusNode: focusNode,
          actions: {
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) {
                onTap?.call();
                return null;
              },
            ),
          },
          child: DisambiguatedHoverTapBuilder(
            onTap: onTap,
            builder: (context, isHovering, isPressing) {
              return AnimatedContainer(
                duration: Effects.shortDuration,
                curve: Curves.ease,
                decoration: ShapeDecoration(
                  shape: Superellipse(
                    cornerRadius: 16.0,
                    side: hasFocus
                        ? BorderSide(
                            color:
                                CupertinoColors.activeBlue.resolveFrom(context),
                          )
                        : BorderSide.none,
                  ),
                  color: isPressing
                      ? PColors.darkGray.resolveFrom(context)
                      : isHovering
                          ? PColors.lightGray.resolveFrom(context)
                          : null,
                ),
                padding: k16H12VPadding,
                child: _PromptTileContent(prompt),
              );
            },
          ),
        );
      },
    );
  }
}

class _PromptTileContent extends StatelessWidget {
  const _PromptTileContent(this.prompt);

  final Prompt prompt;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final isUntitled = prompt.title.let((t) => t.isEmpty);
    final hasNoDescription = prompt.notes.let((d) => d.isEmpty);
    final textGray = PColors.textGray.resolveFrom(context);
    final darkGray = PColors.darkGray.resolveFrom(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isUntitled ? 'Untitled' : prompt.title,
                style: textTheme.large
                    .copyWith(color: isUntitled ? textGray : null),
              ),
              Text(
                hasNoDescription ? 'No description' : prompt.notes,
                style: textTheme.p
                    .copyWith(color: hasNoDescription ? darkGray : null),
              ),
            ],
          ),
        ),
        const CupertinoListTileChevron(),
      ],
    );
  }
}
