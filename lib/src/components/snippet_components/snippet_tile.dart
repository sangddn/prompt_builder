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
    this.onExpanded,
    required this.snippet,
    super.key,
  });

  final VoidCallback? onDelete;
  final VoidCallback? onExpanded;
  final Snippet snippet;

  @override
  Widget build(BuildContext context) {
    return StateProvider<IMap<String, String>>(
      createInitialValue: (_) => IMap(snippet.variables),
      child: MultiProvider(
        providers: [
          Provider<Snippet>.value(value: snippet),
          Provider<VoidCallback?>.value(value: onExpanded),
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
                await context.db.deleteSnippet(snippet.id);
                onDelete?.call();
              },
              trailing: const ShadImage.square(LucideIcons.trash, size: 16),
              child: const Text('Delete'),
            ),
          ],
          child: const _Content(),
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
              _ExpansionButton(),
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
    return ValueProvider<TextEditingController>(
      create: (_) => TextEditingController(text: context.snippet.title),
      onNotified: (context, controller) {
        context.db.updateSnippet(
          context.snippet.id,
          title: controller?.text ?? '',
        );
      },
      builder: (context, _) {
        final controller = context.read<TextEditingController>();
        if (context.snippet.title != controller.text) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.text = context.snippet.title;
          });
        }
        return TextField(
          controller: controller,
          decoration: InputDecoration.collapsed(
            hintText: 'Title',
            hintStyle: context.textTheme.muted,
          ),
          style: context.textTheme.muted,
        );
      },
    );
  }
}

class _ExpansionButton extends StatelessWidget {
  const _ExpansionButton();

  @override
  Widget build(BuildContext context) {
    return CButton(
      tooltip: 'Open',
      onTap: context.watch<VoidCallback?>(),
      padding: k8APadding,
      child: const ShadImage.square(LucideIcons.bookOpenText, size: 16.0),
    );
  }
}

class _ContentField extends StatelessWidget {
  const _ContentField();

  @override
  Widget build(BuildContext context) {
    final isFocused = context.isFocused();
    final controller = context.read<TextEditingController>();
    if (context.snippet.content != controller.text) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.text = context.snippet.content;
      });
    }
    return TextField(
      controller: controller,
      focusNode: context.read(),
      decoration: InputDecoration.collapsed(
        hintText: 'Content',
        hintStyle: context.textTheme.muted,
      ),
      style: context.textTheme.p,
      minLines: 2,
      maxLines: isFocused ? null : 3,
    );
  }
}

class _Variables extends AnimatedStatelessWidget {
  const _Variables();

  @override
  Widget buildChild(BuildContext context) {
    final variables = context.watch<IMap<String, String>>();
    final hasFocus = context.watch<FocusNode>().hasFocus;
    if (variables.isEmpty && !hasFocus) return const SizedBox.shrink();
    return SnippetVariables(variables: variables);
  }
}

extension _TileStateExtension on BuildContext {
  Database get db => read();
  Snippet get snippet => read();
  ValueNotifier<IMap<String, String>> get variablesNotifier => read();
  bool isFocused() => watch<FocusNode>().hasFocus;
}
