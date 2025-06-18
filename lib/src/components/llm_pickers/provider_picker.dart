part of 'llm_pickers.dart';

class ProviderPicker<T extends ProviderWithApiKey> extends StatelessWidget {
  const ProviderPicker({
    this.decoration,
    this.initialProvider,
    required this.providers,
    required this.onChange,
    this.builder,
    super.key,
  });

  ProviderPicker.llms({
    this.initialProvider,
    required this.onChange,
    this.builder,
    this.decoration,
    super.key,
  }) : providers = kAllLLMProviders.cast<T>();

  ProviderPicker.search({
    this.initialProvider,
    required this.onChange,
    this.builder,
    this.decoration,
    super.key,
  }) : providers = kAllSearchProviders.cast<T>();

  factory ProviderPicker.searchWithDefaultUpdate({
    T? initialProvider,
    Widget Function(BuildContext, T)? builder,
    Key? key,
    ShadDecoration? decoration,
  }) => ProviderPicker(
    key: key,
    initialProvider: initialProvider,
    builder: builder,
    providers: kAllSearchProviders.cast<T>(),
    decoration: decoration,
    onChange: (provider) {
      if (provider != null) {
        SearchProviderPreference.setProvider(provider as SearchProvider);
      }
    },
  );

  final T? initialProvider;

  final List<T> providers;

  /// Called when the provider is changed.
  final void Function(T?) onChange;

  final Widget Function(BuildContext, T)? builder;

  final ShadDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return ShadSelect<ProviderWithApiKey>(
      placeholder: const Text('Select a provider'),
      initialValue: initialProvider,
      options: providers.map((provider) => _ProviderOption(provider)),
      selectedOptionBuilder:
          (context, value) =>
              builder?.call(context, value as T) ??
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ProviderTile(provider: value),
              ),
      minWidth: 16.0,
      onChanged: (value) => onChange(value as T?),
      decoration: decoration,
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
