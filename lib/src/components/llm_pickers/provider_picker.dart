part of 'llm_pickers.dart';

class ProviderPicker<T extends ProviderWithApiKey> extends StatelessWidget {
  const ProviderPicker({
    this.initialProvider,
    required this.providers,
    required this.onChange,
    super.key,
  });

  ProviderPicker.llms({
    this.initialProvider,
    required this.onChange,
    super.key,
  }) : providers = kAllLLMProviders.cast<T>();

  ProviderPicker.search({
    this.initialProvider,
    required this.onChange,
    super.key,
  }) : providers = kAllSearchProviders.cast<T>();

  final T? initialProvider;

  final List<T> providers;

  /// Called when the provider is changed.
  final void Function(T?) onChange;

  @override
  Widget build(BuildContext context) {
    return ShadSelect<ProviderWithApiKey>(
      placeholder: const Text('Select a provider'),
      initialValue: initialProvider,
      options: providers.map((provider) => _ProviderOption(provider)),
      selectedOptionBuilder: (context, value) => Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: ProviderTile(provider: value),
      ),
      onChanged: (value) => onChange(value as T?),
    );
  }
}

class _ProviderOption<T extends ProviderWithApiKey> extends StatefulWidget {
  const _ProviderOption(this.provider);

  final T provider;

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
            child: ShadOption<ProviderWithApiKey>(
              value: widget.provider,
              child: ProviderTile(
                provider: widget.provider,
                isEnabled: isEnabled,
                expandSpaceBetween: true,
                subtitle: isEnabled ? null : const Text('API key not set.'),
              ),
            ),
          );
        },
      );
}
