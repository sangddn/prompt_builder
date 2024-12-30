import 'dart:io';

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
part 'audio_video_block.dart';
part 'local_file_block.dart';
part 'web_block.dart';
part 'unsupported_block.dart';

part 'summary_explanation.dart';
part 'block_utils.dart';

class PromptBlockCard extends StatelessWidget {
  const PromptBlockCard({
    this.padding = EdgeInsets.zero,
    this.prompt,
    this.onMovedUp,
    this.onMovedDown,
    required this.database,
    required this.block,
    super.key,
  });

  final EdgeInsetsGeometry padding;
  final Prompt? prompt;
  final VoidCallback? onMovedUp;
  final VoidCallback? onMovedDown;
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
        Provider<(VoidCallback?, VoidCallback?)>.value(
          value: (onMovedUp, onMovedDown),
        ),
      ],
      builder: (context, _) => _BlockContextMenu(
        child: MouseRegion(
          onEnter: (_) => context.hoverNotifier.value = _BlockHoverState.hover,
          onExit: (_) => context.hoverNotifier.value = _BlockHoverState.none,
          child: Padding(
            padding: padding,
            child: const AnimatedSize(
              duration: Effects.shortDuration,
              curve: Effects.snappyOutCurve,
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: _BlockDisplayName()),
                      Gap(8.0),
                      _BlockInfoBar(),
                    ],
                  ),
                  Gap(8.0),
                  _BlockContentRouter(),
                  Row(
                    children: [
                      _TokenCount(),
                      Spacer(),
                      _BlockToolBar(),
                    ],
                  ),
                ],
              ),
            ),
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

/// Info bar with most common block actions:
/// - Remove
/// - Expand / Collapse
class _BlockInfoBar extends StatelessWidget {
  const _BlockInfoBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _BlockMovingActions(),
        const Gap(8.0),
        _ToolBarAction(
          LucideIcons.minus,
          null,
          () async {
            final block = context.block;
            final db = context.db;
            // Only show warning if block has generated content
            final isConfirmed = block.summary == null &&
                    block.transcript == null &&
                    block.caption == null
                ? true
                : await showRemoveBlockWarning(context);
            if (isConfirmed ?? false) {
              await db.deleteBlock(block.id);
            }
          },
          'Remove',
        ),
      ],
    );
  }
}

/// Tool bar with LLM Use Case actions
class _BlockToolBar extends StatelessWidget {
  const _BlockToolBar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _UseSummary(),
          for (final useCase in kAllLLMUseCases) _LLMAction(useCase),
        ],
      ),
    );
  }
}

class _LLMAction extends StatefulWidget {
  const _LLMAction(this.useCase);

  final LLMUseCase useCase;

  @override
  State<_LLMAction> createState() => _LLMActionState();
}

class _LLMActionState extends AnimatedState<_LLMAction> {
  LLMUseCase get useCase => widget.useCase;
  var _loading = false;

  @override
  Widget buildAnimation(BuildContext context, Widget child) =>
      StateAnimations.fade(child);

  @override
  Widget buildChild(BuildContext context) {
    final isHovered = context.isHovered();
    if (!isHovered && !_loading) return const SizedBox.shrink();
    return context.selectBlock((b) => useCase.supports(b))
        ? Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: _ToolBarAction(
              useCase.icon,
              useCase.actionLabel,
              () async {
                final toaster = context.toaster;
                try {
                  setState(() => _loading = true);
                  await useCase.apply(context.db, context.block);
                } catch (e) {
                  debugPrint('Error using LLM: $e');
                  toaster.show(
                    ShadToast.destructive(
                      title: const Text('Error using LLM.'),
                      description: Text('$e'),
                    ),
                  );
                } finally {
                  maybeSetState(() => _loading = false);
                }
              },
              useCase.name,
              _loading,
            ),
          )
        : const SizedBox.shrink();
  }
}

class _BlockMovingActions extends AnimatedStatelessWidget {
  const _BlockMovingActions();

  @override
  Widget buildAnimation(BuildContext context, Widget child) =>
      StateAnimations.fade(child);

  @override
  Widget buildChild(BuildContext context) {
    if (!context.isHovered()) return const SizedBox.shrink();
    final callbacks = context.watch<(VoidCallback?, VoidCallback?)>();
    return Row(
      children: [
        _ToolBarAction(LucideIcons.arrowUp, null, callbacks.$1, 'Move up'),
        const Gap(8.0),
        _ToolBarAction(LucideIcons.arrowDown, null, callbacks.$2, 'Move down'),
        const Gap(8.0),
        Builder(
          builder: (context) {
            final isExpanded = context.isExpanded();
            return _ToolBarAction(
              isExpanded
                  ? LucideIcons.chevronsDownUp
                  : LucideIcons.chevronsUpDown,
              null,
              context.toggleExpansion,
              isExpanded ? 'Collapse' : 'Expand',
            );
          },
        ),
        const Gap(8.0),
      ],
    );
  }
}

class _BlockContextMenu extends StatelessWidget {
  const _BlockContextMenu({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isLocalFile = context.isLocalFile();
    final isSupported =
        context.selectBlock((b) => b.type) != BlockType.unsupported;
    return ShadContextMenuRegion(
      items: [
        if (isLocalFile) ...[
          _ContextMenuAction(
            HugeIcons.strokeRoundedAppleFinder,
            'Reveal in Finder',
            () => revealInFinder(context.block.filePath!),
          ),
          if (isSupported)
            _ContextMenuAction(
              HugeIcons.strokeRoundedEye,
              'Peek',
              () => peekFile(context, context.block.filePath!),
            ),
          const Divider(height: 8),
          CopyButton.builder(
            data: context.block.copyData,
            builder: (_, __, copy) => _ContextMenuAction(
              HugeIcons.strokeRoundedFileAttachment,
              'Copy Raw Data',
              copy,
            ),
          ),
        ],
        Builder(
          builder: (context) {
            if (context.selectBlock((b) => b.copyToPrompt() == null)) {
              return const SizedBox.shrink();
            }
            return CopyButton.builder(
              data: () => context.block.copyToPrompt(),
              builder: (_, __, copy) => _ContextMenuAction(
                HugeIcons.strokeRoundedCopy01,
                'Copy Text',
                copy,
              ),
            );
          },
        ),
        Builder(
          builder: (context) {
            if (context.selectBlock((b) => b.transcript == null)) {
              return const SizedBox.shrink();
            }
            return Column(
              children: [
                const Divider(height: 8),
                CopyButton.builder(
                  data: () => context.block.transcript!,
                  builder: (_, __, copy) => _ContextMenuAction(
                    LucideIcons.fileAudio2,
                    'Copy Transcript',
                    copy,
                  ),
                ),
                _ContextMenuAction(
                  LucideIcons.save,
                  'Save Transcript as File',
                  () => _saveTranscriptAsMarkdown(context, context.block),
                ),
                _ContextMenuAction(
                  LucideIcons.delete,
                  'Remove Transcript',
                  () => context.db
                      .removeFields(context.block.id, transcript: true),
                ),
              ],
            );
          },
        ),
        Builder(
          builder: (context) {
            if (context.selectBlock((b) => b.caption == null)) {
              return const SizedBox.shrink();
            }
            return Column(
              children: [
                const Divider(height: 8),
                CopyButton.builder(
                  data: () => context.block.caption!,
                  builder: (_, __, copy) => _ContextMenuAction(
                    LucideIcons.fileImage,
                    'Copy Description',
                    copy,
                  ),
                ),
                _ContextMenuAction(
                  LucideIcons.save,
                  'Save Description as File',
                  () => _saveDescriptionAsMarkdown(context, context.block),
                ),
                _ContextMenuAction(
                  LucideIcons.delete,
                  'Remove Description',
                  () =>
                      context.db.removeFields(context.block.id, caption: true),
                ),
              ],
            );
          },
        ),
        Builder(
          builder: (context) {
            if (context.selectBlock((b) => b.summary == null)) {
              return const SizedBox.shrink();
            }
            return Column(
              children: [
                const Divider(height: 8),
                CopyButton.builder(
                  data: () => context.block.summary!,
                  builder: (_, __, copy) => _ContextMenuAction(
                    LucideIcons.fileText,
                    'Copy Summary',
                    copy,
                  ),
                ),
                _ContextMenuAction(
                  LucideIcons.save,
                  'Save Summary as File',
                  () => _saveSummaryAsMarkdown(context, context.block),
                ),
                _ContextMenuAction(
                  LucideIcons.delete,
                  'Remove Summary',
                  () => context.db.removeFields(
                    context.block.id,
                    summary: true,
                    summaryTokenCount: true,
                    summaryTokenCountMethod: true,
                  ),
                ),
              ],
            );
          },
        ),
        if (context.selectBlock(
          (b) => b.fullContentTokenCount != null || b.summaryTokenCount != null,
        )) ...[
          const Divider(height: 8),
          _ContextMenuAction(
            LucideIcons.refreshCcw,
            'Re-estimate Token Count',
            () => context.db.removeFields(
              context.block.id,
              fullContentTokenCount: true,
              summaryTokenCount: true,
              fullContentTokenCountMethod: true,
              summaryTokenCountMethod: true,
            ),
          ),
        ],
      ],
      child: child,
    );
  }
}

class _UseSummary extends StatelessWidget {
  const _UseSummary();

  @override
  Widget build(BuildContext context) {
    final hasSummary = context.selectBlock((b) => b.summary != null);
    if (!hasSummary) return const SizedBox.shrink();
    final preferSummary = context.selectBlock((b) => b.preferSummary);
    return ShadCheckbox(
      value: preferSummary,
      onChanged: (value) {
        context.db.updateBlock(context.block.id, preferSummary: value);
      },
      label: const Text('Use summary'),
    );
  }
}

class _TokenCount extends StatefulWidget {
  const _TokenCount();

  @override
  State<_TokenCount> createState() => _TokenCountState();
}

class _TokenCountState extends State<_TokenCount> {
  final _controller = ShadPopoverController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final useSummary = context.selectBlock((b) => b.preferSummary);
    final tokenCount = useSummary
        ? context.selectBlock((b) => b.summaryTokenCountAndMethod)
        : context.selectBlock((b) => b.fullContentTokenCountAndMethod);
    if (tokenCount == null) return const SizedBox.shrink();
    return ShadPopover(
      controller: _controller,
      popover: (context) {
        final textTheme = context.textTheme;
        return IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tokenCount.$1.toString(),
                style: textTheme.large,
                textAlign: TextAlign.start,
              ),
              Text(
                'Estimated ${useSummary ? 'Summary' : 'Full Content'} Tokens',
                style: textTheme.muted,
              ),
              Text(
                tokenCount.$2,
                style: textTheme.muted,
              ),
            ],
          ),
        );
      },
      child: MouseRegion(
        onEnter: (_) => _controller.show(),
        onExit: (_) => _controller.hide(),
        child: Text(
          '~${_formatNumber(tokenCount.$1)} tokens',
          style: context.textTheme.muted,
        ),
      ),
    );
  }
}

class _ToolBarAction extends StatelessWidget {
  const _ToolBarAction(
    this.icon,
    this.label,
    this.onTap, [
    this.tooltip,
    this.shimmer = false,
  ]);

  final IconData icon;
  final String? label;
  final VoidCallback? onTap;
  final String? tooltip;
  final bool shimmer;

  @override
  Widget build(BuildContext context) {
    return CButton(
      tooltip: tooltip,
      onTap: onTap,
      padding: k6APadding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.0),
          if (label != null) ...[
            const Gap(4.0),
            GrayShimmer(
              enableShimmer: shimmer,
              child: Text(label!, style: context.textTheme.muted),
            ),
          ],
        ],
      ),
    );
  }
}

class _ContextMenuAction extends StatelessWidget {
  const _ContextMenuAction(this.icon, this.label, this.onTap);

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => ShadContextMenuItem(
        onPressed: onTap,
        trailing: Icon(icon, size: 16.0),
        child: Text(label),
      );
}
