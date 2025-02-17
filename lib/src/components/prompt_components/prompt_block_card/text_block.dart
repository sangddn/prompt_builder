part of 'prompt_block_card.dart';

class _TextBlock extends StatelessWidget {
  const _TextBlock();

  @override
  Widget build(BuildContext context) {
    return ValueProvider<TextEditingController>(
      create:
          (context) => TextEditingController(text: context.block.textContent),
      onNotified:
          (context, controller) async => context.db.updateBlock(
            context.block.id,
            textContent: controller?.text,
          ),
      child: ValueProvider<_VariableNotifier>(
        create: (context) {
          final controller = context.controller;
          final notifier = _VariableNotifier(
            IMap(SnippetExtension.parseVariables(controller.text)),
          );
          controller.addListener(() {
            final variables = SnippetExtension.parseVariables(controller.text);
            notifier.value = IMap(variables);
          });
          return notifier;
        },
        onNotified: (context, notifier) {
          if (notifier == null) return;
          final controller = context.controller;
          final newText = SnippetExtension.replaceVariableValues(
            controller.text,
            notifier.value.unlockView,
          );
          if (newText != controller.text) {
            controller.text = newText;
          }
        },
        child: const Column(children: [_TextField(), _Variables()]),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField();

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.p;
    final isExpanded = context.isExpanded();
    if (!isExpanded) {
      return GestureDetector(
        onTap: () => context.toggleExpansion(),
        child: Text(context.block.textContent ?? '', style: style, maxLines: 3),
      );
    }
    final controller = context.controller;
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Aa',
        hintStyle: style.copyWith(color: PColors.textGray.resolveFrom(context)),
        border: InputBorder.none,
      ),
      minLines: 2,
      maxLines: isExpanded ? null : 3,
      scrollPhysics: const NeverScrollableScrollPhysics(),
      style: style,
    );
  }
}

class _Variables extends AnimatedStatelessWidget {
  const _Variables();

  @override
  Widget buildChild(BuildContext context) {
    if (!context.isExpanded()) return const SizedBox.shrink();
    final notifier = context.watch<_VariableNotifier>();
    final variables = notifier.value;
    if (variables.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(12.0),
        Text('Variables', style: context.textTheme.muted),
        const Gap(8.0),
        ...variables.entries.indexedExpand(
          (i, e) => [
            Row(
              children: [
                Expanded(child: Text(e.key)),
                Expanded(flex: 2, child: _VariableTextField(e.key, e.value)),
              ],
            ),
            if (i < variables.length - 1) const Gap(4.0),
          ],
        ),
      ],
    );
  }
}

class _VariableTextField extends StatelessWidget {
  const _VariableTextField(this.variableName, this.value);

  final String variableName;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ValueProvider<TextEditingController>(
      create: (context) => TextEditingController(text: value),
      onNotified: (context, controller) {
        final text = controller?.text ?? '';
        // Notify the main text field
        final notifier = context.read<_VariableNotifier>();
        final variables = notifier.value.update(variableName, (_) => text);
        notifier.value = variables;

        // Update backend
        context.db.updateBlock(
          context.block.id,
          textContent: SnippetExtension.replaceVariableValue(
            context.block.textContent ?? '',
            variableName,
            text,
          ),
        );
      },
      builder: (context, _) {
        final controller = context.controller;
        // Sync value with text field
        if (controller.text != value) {
          scheduleMicrotask(() => controller.text = value);
        }
        final style = context.textTheme.list;
        return TextField(
          controller: controller,
          style: style,
          inputFormatters: const [_NoTemplateFormatter()],
          decoration: InputDecoration(
            hintText: 'Value',
            hintStyle: style.copyWith(
              color: PColors.textGray.resolveFrom(context),
            ),
            contentPadding: k8APadding,
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                width: .5,
                color: PColors.darkGray.resolveFrom(context),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NoTemplateFormatter extends TextInputFormatter {
  const _NoTemplateFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.contains('{{') || newValue.text.contains('}')) {
      return oldValue;
    }
    return newValue;
  }
}

// -----------------------------------------------------------------------------
// Typedefs & Extensions
// -----------------------------------------------------------------------------

class _VariableNotifier extends ValueNotifier<IMap<String, String>> {
  _VariableNotifier(super.value);
}

extension _TextBlockExtension on BuildContext {
  TextEditingController get controller => read();
}
