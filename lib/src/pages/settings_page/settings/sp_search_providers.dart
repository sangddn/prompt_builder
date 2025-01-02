part of '../settings_page.dart';

class SearchProviderSettings extends StatelessWidget {
  const SearchProviderSettings({super.key});

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
                Text('Search Providers', style: context.textTheme.h4),
                const Gap(4.0),
                Text(
                  'Configure search providers to search the web and add content to your prompts. '
                  'For example, you can search for Tailwind CSS documentation to add to your coding prompt.',
                  style: context.textTheme.muted,
                ),
              ],
            ),
          ),
          const Gap(16.0),
          const _SearchProviderPreference(),
          const Gap(16.0),
          ...kAllSearchProviders
              .map((provider) => ProviderInfo(provider: provider)),
          const Gap(8.0),
        ].toList(),
      ),
    );
  }
}

class _SearchProviderPreference extends StatelessWidget {
  const _SearchProviderPreference();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(4.0),
        Padding(
          padding: k4HPadding,
          child: Text(
            'Default Search Provider',
            style: context.textTheme.p,
          ),
        ),
        const Gap(4.0),
        Provider<SearchProvider?>(
          create: (_) =>
              SearchProviderPreference.getValidProviderWithFallback(),
          builder: (context, _) =>
              ProviderPicker<SearchProvider>.searchWithDefaultUpdate(
            initialProvider: context.read(),
          ),
        ),
      ],
    );
  }
}
