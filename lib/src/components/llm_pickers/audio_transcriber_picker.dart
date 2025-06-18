part of 'llm_pickers.dart';

class AudioTranscriberPicker extends StatelessWidget {
  const AudioTranscriberPicker({
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
      child: SizedBox(
        height: 50.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _AudioTranscriberProviderPicker(),
            const Gap(4.0),
            _ModelPicker((provider) {
              switch (provider) {
                case OpenAI():
                  return SynchronousFuture(['whisper-1']);
                case Gemini():
                  return Gemini().listModels();
                case _:
                  return SynchronousFuture([]);
              }
            }),
          ],
        ),
      ),
    );
  }
}

class _AudioTranscriberProviderPicker extends StatelessWidget {
  const _AudioTranscriberProviderPicker();

  @override
  Widget build(BuildContext context) {
    final provider = context.watchProvider();
    return ProviderPicker(
      initialProvider: provider,
      providers: const TranscribeAudioUseCase().providers,
      onChange: (newProvider) {
        if (newProvider != null) {
          context.setProvider(newProvider);
        }
      },
    );
  }
}
