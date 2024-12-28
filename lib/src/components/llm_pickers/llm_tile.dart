part of 'llm_pickers.dart';

class LLMProviderLogo extends StatelessWidget {
  const LLMProviderLogo({this.size = 20.0, required this.provider, super.key});

  final double size;
  final LLMProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return ShadImage.square(
      theme.resolveBrightness(
        provider.lightLogoPath,
        provider.darkLogoPath,
      ),
      size: size,
    );
  }
}

class LLMProviderTile extends StatelessWidget {
  const LLMProviderTile({
    this.subtitle,
    this.isEnabled = true,
    required this.provider,
    super.key,
  });

  final bool isEnabled;
  final Widget? subtitle;
  final LLMProvider provider;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        LLMProviderLogo(provider: provider, size: 16.0),
        const Gap(16.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultTextStyle(
              style: context.textTheme.list,
              child: Text(provider.providerName),
            ),
            if (subtitle != null) ...[
              const Gap(2.0),
              DefaultTextStyle(
                style: context.textTheme.muted,
                child: subtitle!,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// LLM Provider Info
// -----------------------------------------------------------------------------

extension LLMProviderInfoExtension on LLMProvider {
  Map<String, String> get _providerInfo => _llmProviderInfo[this]!;
  String get providerName => _providerInfo['name']!;
  String get docsPage => _providerInfo['docs_page']!;
  String get apiKeyPage => _providerInfo['api_key_page']!;
  String get lightLogoPath => _providerInfo['light_logo_path']!;
  String get darkLogoPath => _providerInfo['dark_logo_path']!;
}

Map<LLMProvider, Map<String, String>> _llmProviderInfo = {
  OpenAI(): {
    'name': 'OpenAI',
    'docs_page': 'https://platform.openai.com/docs/introduction',
    'api_key_page': 'https://platform.openai.com/api-keys',
    'light_logo_path': 'assets/images/openai_light.svg',
    'dark_logo_path': 'assets/images/openai_dark.svg',
  },
  Anthropic(): {
    'name': 'Anthropic',
    'docs_page': 'https://docs.anthropic.com/en/home',
    'api_key_page': 'https://console.anthropic.com/settings/keys',
    'light_logo_path': 'assets/images/anthropic_light.svg',
    'dark_logo_path': 'assets/images/anthropic_dark.png',
  },
  Gemini(): {
    'name': 'Gemini',
    'docs_page': 'https://ai.google.dev/gemini-api/docs',
    'api_key_page': 'https://aistudio.google.com/apikey',
    'light_logo_path': 'assets/images/google.svg',
    'dark_logo_path': 'assets/images/google.svg',
  },
};
