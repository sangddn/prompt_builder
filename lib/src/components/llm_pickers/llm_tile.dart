part of 'llm_pickers.dart';

class ProviderLogo<T extends ProviderWithApiKey> extends StatelessWidget {
  const ProviderLogo({this.size = 20.0, required this.provider, super.key});

  final double size;
  final T provider;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Image.asset(
      theme.resolveBrightness(provider.logoPath, provider.darkLogoPath),
      height: size,
      width: size,
    );
  }
}

class ProviderTile<T extends ProviderWithApiKey> extends StatelessWidget {
  const ProviderTile({
    this.subtitle,
    this.isEnabled = true,
    this.expandSpaceBetween = false,
    required this.provider,
    super.key,
  });

  final bool isEnabled;
  final Widget? subtitle;
  final bool expandSpaceBetween;
  final T provider;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultTextStyle(
              style: context.textTheme.list,
              child: Text(provider.name),
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
        if (expandSpaceBetween) const Spacer(),
        const Gap(8.0),
        ProviderLogo(provider: provider, size: 16.0),
      ],
    );
  }
}
