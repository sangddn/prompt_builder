part of 'llm_pickers.dart';

class ProviderPicker extends StatelessWidget {
  const ProviderPicker({
    this.initialProvider,
    this.allowedProviders,
    required this.onChange,
    super.key,
  });

  final LLMProvider? initialProvider;

  /// If null, all providers are allowed.
  final List<LLMProvider>? allowedProviders;

  /// Called when the provider is changed.
  final void Function(LLMProvider?) onChange;

  @override
  Widget build(BuildContext context) {
    final providers = allowedProviders ?? [OpenAI(), Anthropic(), Gemini()];
    return ShadSelect<LLMProvider>(
      placeholder: const Text('Select a provider'),
      initialValue: initialProvider,
      options: providers.map((provider) => _ProviderOption(provider)),
      selectedOptionBuilder: (context, value) =>
          LLMProviderTile(provider: value),
      onChanged: onChange,
    );
  }
}

class _ProviderOption extends StatefulWidget {
  const _ProviderOption(this.provider);

  final LLMProvider provider;

  @override
  State<_ProviderOption> createState() => _ProviderOptionState();
}

class _ProviderOptionState extends State<_ProviderOption> {
  late final _enabledStream = widget.provider.isSetUp();

  @override
  Widget build(BuildContext context) => StreamBuilder<bool>(
        stream: _enabledStream,
        builder: (context, snapshot) {
          final isEnabled = snapshot.data ?? false;
          return IgnorePointer(
            ignoring: !isEnabled,
            child: ShadOption(
              value: widget.provider,
              child: LLMProviderTile(
                provider: widget.provider,
                isEnabled: isEnabled,
                subtitle: isEnabled ? null : const Text('API key not set.'),
              ),
            ),
          );
        },
      );
}
