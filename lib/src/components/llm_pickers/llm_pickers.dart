import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../core/core.dart';
import '../../services/services.dart';

part 'llm_tile.dart';
part 'provider_picker.dart';
part 'audio_transcriber_picker.dart';

class LLMPicker extends StatelessWidget {
  const LLMPicker({
    this.initialProvider,
    this.initialModel,
    required this.onChange,
    super.key,
  }) : assert(
         ((initialProvider == null) == (initialModel == null)),
         'initialProvider and initialModel must be both null or both non-null',
       );

  final LLMProvider? initialProvider;
  final String? initialModel;
  final void Function(LLMProvider?, String?) onChange;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ValueProvider<ValueNotifier<(LLMProvider, String)?>>(
          create: (_) {
            final notifier = ValueNotifier(
              initialProvider != null
                  ? (initialProvider!, initialModel!)
                  : null,
            );
            notifier.addListener(() {
              onChange(notifier.value?.$1, notifier.value?.$2);
            });
            return notifier;
          },
        ),
      ],
      child: const SizedBox(
        height: 50.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [_ProviderPicker(), Gap(4.0), _ModelPicker()],
        ),
      ),
    );
  }
}

typedef _ModelNotifier = ValueNotifier<(LLMProvider, String)?>;

extension _ModelNotifierExtension on BuildContext {
  _ModelNotifier get notifier => read();
  LLMProvider? watchProvider() => select((_ModelNotifier n) => n.value?.$1);
  String? watchModel() => select((_ModelNotifier n) => n.value?.$2);
  void setProvider(LLMProvider provider) =>
      notifier.value = (provider, provider.defaultModel);
  void setModel(String model) => notifier.value = (notifier.value!.$1, model);
}

class _ProviderPicker extends StatelessWidget {
  const _ProviderPicker();

  @override
  Widget build(BuildContext context) {
    final provider = context.watchProvider();
    return ProviderPicker.llms(
      initialProvider: provider,
      onChange: (newProvider) {
        if (newProvider != null) {
          context.setProvider(newProvider);
        }
      },
    );
  }
}

class _ModelPicker extends StatefulWidget {
  const _ModelPicker([this.listModelsCallback]);

  /// Called when the model is changed.
  final Future<List<String>>? Function(LLMProvider?)? listModelsCallback;

  @override
  State<_ModelPicker> createState() => _ModelPickerState();
}

class _ModelPickerState extends State<_ModelPicker> {
  LLMProvider? _provider;
  Future<List<String>>? _modelsFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = context.watch<_ModelNotifier>().value?.$1;
    if (provider != _provider) {
      _provider = provider;
      _modelsFuture =
          widget.listModelsCallback?.call(provider) ?? provider?.listModels();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _modelsFuture,
      builder: (context, snapshot) {
        final models = snapshot.data;
        final isEnabled = _provider != null && models != null;
        return ShadSelect<String>(
          placeholder:
              _provider == null
                  ? const Text('Choose a provider first')
                  : !isEnabled
                  ? const Text('Loading models…')
                  : const Text('Select a model'),
          enabled: isEnabled,
          initialValue: isEnabled ? null : context.watchModel(),
          options:
              models?.map((m) => ShadOption(value: m, child: Text(m))) ?? [],
          selectedOptionBuilder: (context, value) => Text(value),
          onChanged: (newModel) {
            if (newModel != null) {
              context.setModel(newModel);
            }
          },
        );
      },
    );
  }
}
