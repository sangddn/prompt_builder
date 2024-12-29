part of 'prompt_block_card.dart';

class _SummaryExplanation extends StatefulWidget {
  const _SummaryExplanation();
  @override
  State<_SummaryExplanation> createState() => _SummaryExplanationState();
}

class _SummaryExplanationState extends State<_SummaryExplanation> {
  final _controller = ShadPopoverController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShadPopover(
      controller: _controller,
      popover: (context) {
        final textTheme = context.textTheme;
        return SizedBox(
          width: 288,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Summary',
                style: textTheme.muted,
              ),
              const Gap(4.0),
              Text(
                'Some content such as web pages, text files, and audio transcripts can be summarized '
                'before being injected into the prompt. This can save tokens and improve performance.',
                style: textTheme.p,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        );
      },
      child: MouseRegion(
        onHover: (_) => _controller.show(),
        onExit: (_) => _controller.hide(),
        child: const ShadButton.ghost(
          padding: k8H4VPadding,
          size: ShadButtonSize.sm,
          child: ShadImage.square(
            CupertinoIcons.question_circle,
            size: 16.0,
          ),
        ),
      ),
    );
  }
}
