import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../core/core.dart';
import '../../../database/database.dart';
import '../../../services/services.dart';
import '../../components.dart';

part 'block_router_widget.dart';
part 'text_block.dart';
part 'image_block.dart';
part 'audio_block.dart';
part 'video_block.dart';
part 'local_file_block.dart';
part 'youtube_block.dart';
part 'web_block.dart';
part 'unsupported_block.dart';

part 'summary_explanation.dart';
part 'block_utils.dart';

class PromptBlockCard extends StatelessWidget {
  const PromptBlockCard({
    this.padding = EdgeInsets.zero,
    this.prompt,
    required this.database,
    required this.block,
    super.key,
  });

  final EdgeInsetsGeometry padding;
  final Prompt? prompt;
  final Database database;
  final PromptBlock block;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Prompt?>.value(value: prompt),
        Provider<Database>.value(value: database),
        Provider<PromptBlock>.value(value: block),
        ValueProvider<ValueNotifier<BlockWidgetState>>(
          create: (_) => ValueNotifier(BlockWidgetState.collapsed),
        ),
        ValueProvider<ValueNotifier<_BlockHoverState>>(
          create: (_) => ValueNotifier(_BlockHoverState.none),
        ),
      ],
      builder: (context, _) => MouseRegion(
        onEnter: (_) => context.hoverNotifier.value = _BlockHoverState.hover,
        onExit: (_) => context.hoverNotifier.value = _BlockHoverState.none,
        child: Padding(
          padding: padding,
          child: const Column(
            children: [
              Row(
                children: [
                  Expanded(child: _BlockDisplayName()),
                  Gap(8.0),
                  _BlockInfoBar(),
                ],
              ),
              _BlockContentRouter(),
              _BlockToolBar(),
            ],
          ),
        ),
      ),
    );
  }
}

class _BlockDisplayName extends StatelessWidget {
  const _BlockDisplayName();

  @override
  Widget build(BuildContext context) {
    final initialName = context.selectBlock((b) => b.displayName);
    final prompt = context.watch<Prompt?>();
    final displayName = context.selectBlock(
      (b) => b.getDefaultDisplayName(prompt),
    );
    return TextFormField(
      initialValue: initialName,
      style: context.textTheme.muted,
      decoration: InputDecoration.collapsed(
        hintText: displayName,
        hintStyle: context.textTheme.muted
            .copyWith(color: PColors.textGray.resolveFrom(context)),
      ),
      onChanged: (value) =>
          context.db.updateBlock(context.block.id, displayName: value),
    );
  }
}

class _BlockInfoBar extends StatelessWidget {
  const _BlockInfoBar();

  @override
  Widget build(BuildContext context) {
    final isLocalFile = context.selectBlock((b) => b.filePath != null);
    return Row(
      children: [
        if (isLocalFile) ...[
          CButton(
            tooltip: 'Reveal in Finder',
            onTap: () => revealInFinder(context.block.filePath!),
            padding: k4APadding,
            child: const Icon(HugeIcons.strokeRoundedAppleFinder, size: 16.0),
          ),
          const Gap(8.0),
          if (context.selectBlock((b) => b.type != BlockType.unsupported)) ...[
            CButton(
              tooltip: 'Peek',
              onTap: () => peekFile(context, context.block.filePath!),
              padding: k4APadding,
              child: const Icon(HugeIcons.strokeRoundedEye, size: 16.0),
            ),
            const Gap(8.0),
          ],
        ],
        CButton(
          tooltip: 'Remove',
          onTap: () async {
            final block = context.block;
            final db = context.db;
            final isConfirmed = await showRemoveBlockWarning(context);
            if (isConfirmed ?? false) {
              await db.deleteBlock(block.id);
            }
          },
          padding: k4APadding,
          child: const Icon(HugeIcons.strokeRoundedMinusSign, size: 16.0),
        ),
      ],
    );
  }
}

/// Tool bar with basic block actions:
/// - Add Below
/// - Expand / Collapse
/// - Move Up
/// - Move Down
/// - Delete
/// - LLM Use Cases
class _BlockToolBar extends AnimatedStatelessWidget {
  const _BlockToolBar();

  @override
  Widget buildChild(BuildContext context) {
    final isHovered = context.isHovered();
    if (!isHovered) return const SizedBox.shrink();
    return const Text('Tool Bar');
  }
}
