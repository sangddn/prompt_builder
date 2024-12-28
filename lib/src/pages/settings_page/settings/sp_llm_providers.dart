part of '../settings_page.dart';

class LLMProviderSettings extends StatelessWidget {
  const LLMProviderSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: k32HPadding,
      decoration: ShapeDecoration(
        color: PColors.lightGray.resolveFrom(context).withOpacityFactor(.5),
        shape: Superellipse.border12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Gap(32.0),
          Padding(
            padding: k4HPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('LLM Providers', style: context.textTheme.h4),
                const Gap(4.0),
                Text(
                  'Set up API keys to use LLM providers for summarizing large files, web pages, and YouTube transcripts before using them in prompts. Some providers also support audio transcription (OpenAI Whisper, Gemini), image captioning, and prompt generation. You can use Prompt Builder without configuring these services.',
                  style: context.textTheme.muted,
                ),
              ],
            ),
          ),
          const Gap(16.0),
          ...[OpenAI(), Anthropic(), Gemini()]
              .map((provider) => LLMProviderInfo(provider: provider)),
          const Gap(8.0),
        ].toList(),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// LLM Provider Widgets
// -----------------------------------------------------------------------------

class LLMProviderInfo extends StatelessWidget {
  const LLMProviderInfo({required this.provider, super.key});

  final LLMProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final textTheme = theme.textTheme;
    return Column(
      children: [
        Row(
          children: [
            const Gap(6.0),
            Expanded(child: Text(provider.providerName, style: textTheme.list)),
            ShadButton.ghost(
              onPressed: () => launchUrlString(provider.docsPage),
              size: ShadButtonSize.sm,
              icon: const ShadImage.square(
                HugeIcons.strokeRoundedDoc01,
                size: 16,
              ),
              child: const Text('Docs'),
            ),
            ShadButton.ghost(
              onPressed: () => launchUrlString(provider.apiKeyPage),
              size: ShadButtonSize.sm,
              icon: const ShadImage.square(
                HugeIcons.strokeRoundedCode,
                size: 16,
              ),
              child: const Text('Console'),
            ),
          ],
        ),
        LLMProviderApiKeyField(provider: provider),
        const Gap(24.0),
      ],
    );
  }
}

class LLMProviderApiKeyField extends StatefulWidget {
  const LLMProviderApiKeyField({required this.provider, super.key});
  final LLMProvider provider;
  @override
  State<LLMProviderApiKeyField> createState() => _LLMProviderApiKeyFieldState();
}

class _LLMProviderApiKeyFieldState extends State<LLMProviderApiKeyField> {
  bool _showApiKey = false;
  late final _initialKey = () {
    try {
      return widget.provider.getApiKey();
    } on ApiKeyNotSetException {
      return null;
    }
  }();

  @override
  Widget build(BuildContext context) {
    return ShadInput(
      initialValue: _initialKey,
      prefix: LLMProviderLogo(provider: widget.provider, size: 14.0),
      suffix: CButton(
        tooltip: _showApiKey ? 'Hide' : 'Show',
        padding: k4APadding,
        onTap: () => setState(() => _showApiKey = !_showApiKey),
        child: ShadImage.square(
          _showApiKey ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
          size: 14,
        ),
      ),
      placeholder: const Text('API Key'),
      obscureText: !_showApiKey,
      onChanged: widget.provider.setApiKey,
    );
  }
}
