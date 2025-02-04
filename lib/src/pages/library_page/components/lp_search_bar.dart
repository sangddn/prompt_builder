part of '../library_page.dart';

class _LPSearchBar extends StatelessWidget {
  const _LPSearchBar();

  @override
  Widget build(BuildContext context) {
    final controller = context.read<PromptSearchQueryNotifier>();
    final hasText =
        context.select((PromptSearchQueryNotifier n) => n.text.isNotEmpty);
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 54.0,
        child: ShadInput(
          controller: controller,
          placeholder: const Text('Search'),
          prefix: const Padding(
            padding: k4APadding,
            child:
                ShadImage.square(HugeIcons.strokeRoundedSearch01, size: 16.0),
          ),
          suffix: TranslationSwitcher.top(
            duration: Effects.veryShortDuration,
            child: hasText
                ? CButton(
                    tooltip: 'Clear',
                    padding: k4APadding,
                    color: PColors.lightGray.resolveFrom(context),
                    onTap: () {
                      controller.clear();
                    },
                    child: const Icon(CupertinoIcons.clear, size: 16),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
