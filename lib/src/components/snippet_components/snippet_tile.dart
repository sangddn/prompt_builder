import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../core/core.dart';
import '../../database/database.dart';
import '../components.dart';

class SnippetTile extends StatelessWidget {
  const SnippetTile({
    this.onDelete,
    required this.database,
    required this.snippet,
    super.key,
  });

  final VoidCallback? onDelete;
  final Database database;
  final Snippet snippet;

  @override
  Widget build(BuildContext context) {
    return StateProvider<_TileState>(
      createInitialValue: (_) => _TileState.collapsed,
      child: StateProvider<IMap<String, String>>(
        createInitialValue: (_) => IMap(snippet.variables),
        child: MultiProvider(
          providers: [
            Provider<Database>.value(value: database),
            Provider<Snippet>.value(value: snippet),
            ValueProvider<TextEditingController>(
              create: (_) => TextEditingController(text: snippet.content),
              onNotified: (context, controller) {
                context.db.updateSnippet(
                  context.snippet.id,
                  content: controller?.text ?? '',
                );
                context.variablesNotifier.value = IMap(
                  SnippetExtension.parseVariables(controller?.text ?? ''),
                );
              },
            ),
            ListenableProvider(create: (_) => FocusNode()),
          ],
          child: ShadContextMenuRegion(
            items: [
              ShadContextMenuItem(
                onPressed: () async {
                  await database.deleteSnippet(snippet.id);
                  onDelete?.call();
                },
                trailing: const ShadImage.square(LucideIcons.trash, size: 16),
                child: const Text('Delete'),
              ),
            ],
            child: const _Content(),
          ),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: k24H12VPadding,
      decoration: ShapeDecoration(
        shape: Superellipse.border12,
        color: PColors.lightGray.resolveFrom(context),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _TitleField()),
              Gap(8.0),
              _ExpansionToggler(),
            ],
          ),
          Gap(6.0),
          _ContentField(),
          Gap(12.0),
          _Variables(),
          Gap(8.0),
        ],
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: context.snippet.title,
      decoration: InputDecoration.collapsed(
        hintText: 'Title',
        hintStyle: context.textTheme.muted,
      ),
      style: context.textTheme.muted,
      onChanged: (value) => context.db.updateSnippet(
        context.snippet.id,
        title: value,
      ),
    );
  }
}

class _ExpansionToggler extends StatelessWidget {
  const _ExpansionToggler();

  @override
  Widget build(BuildContext context) {
    final isExpanded = context.isExpanded();
    return CButton(
      tooltip: isExpanded ? 'Collapse' : 'Expand',
      onTap: () => context.toggleExpanded(),
      padding: k8APadding,
      child: ShadImage.square(
        isExpanded ? LucideIcons.chevronsDownUp : LucideIcons.chevronsUpDown,
        size: 16.0,
      ),
    );
  }
}

class _ContentField extends StatelessWidget {
  const _ContentField();

  @override
  Widget build(BuildContext context) {
    final isExpanded = context.isExpanded();
    return TextField(
      controller: context.read(),
      focusNode: context.read(),
      decoration: InputDecoration.collapsed(
        hintText: 'Content',
        hintStyle: context.textTheme.muted,
      ),
      style: context.textTheme.p,
      minLines: 2,
      maxLines: isExpanded ? null : 3,
    );
  }
}

class _Variables extends AnimatedStatelessWidget {
  const _Variables();

  @override
  Widget buildChild(BuildContext context) {
    final variables = context.watch<IMap<String, String>>();
    if (variables.isEmpty) {
      final hasFocus = context.watch<FocusNode>().hasFocus;
      if (!hasFocus) return const SizedBox.shrink();
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
                Text(e.value, style: context.textTheme.muted),
              ],
            ),
            if (i < variables.length - 1) const Gap(4.0),
          ],
        ),
      ],
    );
  }
}

enum _TileState {
  collapsed,
  expanded,
  ;

  bool get isExpanded => this == _TileState.expanded;
}

extension _TileStateExtension on BuildContext {
  Database get db => read();
  Snippet get snippet => read();
  ValueNotifier<IMap<String, String>> get variablesNotifier => read();
  bool isExpanded() => watch<_TileState>().isExpanded;
  void toggleExpanded() {
    final notifier = read<ValueNotifier<_TileState>>();
    notifier.value =
        notifier.value.isExpanded ? _TileState.collapsed : _TileState.expanded;
  }
}
