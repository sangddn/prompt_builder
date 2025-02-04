part of 'prompt_block_card.dart';

enum BlockWidgetState {
  collapsed,
  expanded,
}

enum _BlockHoverState {
  none,
  hover,
}

extension _BaseBlockExtension on BuildContext {
  PromptBlock get block => read();
  T selectBlock<T>(T Function(PromptBlock block) fn) => select(fn);

  bool isLocalFile() => selectBlock((b) => b.filePath != null);

  ValueNotifier<_BlockHoverState> get hoverNotifier => read();
  bool isHovered() =>
      watch<ValueNotifier<_BlockHoverState>>().value == _BlockHoverState.hover;

  ValueNotifier<BlockWidgetState> get expansionNotifier => read();
  bool isExpanded() =>
      watch<ValueNotifier<BlockWidgetState>>().value ==
      BlockWidgetState.expanded;
  void toggleExpansion() => expansionNotifier.value =
      expansionNotifier.value == BlockWidgetState.expanded
          ? BlockWidgetState.collapsed
          : BlockWidgetState.expanded;
}

extension BlockInfomation on PromptBlock {
  String? getRelativePath(String? dir) =>
      filePath != null ? path.relative(filePath!, from: dir) : null;

  String getDefaultDisplayName(Prompt? prompt) => switch (type) {
        BlockType.text => 'Instructions',
        BlockType.image ||
        BlockType.video ||
        BlockType.audio ||
        BlockType.localFile =>
          getRelativePath(prompt?.folderPath) ?? 'Local File',
        BlockType.youtube => 'YouTube ${url!}',
        BlockType.webUrl => 'Webpage ${url!}',
        BlockType.unsupported =>
          getRelativePath(prompt?.folderPath) ?? 'Unsupported',
      };
}

extension LLMUseCaseInfo on LLMUseCase {
  IconData get icon => switch (this) {
        SummarizeContentUseCase() => HugeIcons.strokeRoundedSummation01,
        DescribeImagesUseCase() => HugeIcons.strokeRoundedAiImage,
        GeneratePromptUseCase() => HugeIcons.strokeRoundedMagicWand01,
        TranscribeAudioUseCase() => HugeIcons.strokeRoundedAiVideo,
      };

  String get actionLabel => switch (this) {
        SummarizeContentUseCase() => 'Summarize',
        DescribeImagesUseCase() => 'Describe',
        GeneratePromptUseCase() => 'Generate Prompt',
        TranscribeAudioUseCase() => 'Transcribe',
      };
}

// -----------------------------------------------------------------------------
// File saving utils
// -----------------------------------------------------------------------------

String _figureOutFileName(String type, String displayName, String? filePath) =>
    displayName.let((n) => n.isEmpty ? null : '$n-transcript') ??
    filePath
        ?.let(path.basenameWithoutExtension)
        .let((n) => n.isEmpty ? null : '$n-$type') ??
    type;

Future<void> _saveTranscriptAsMarkdown(
  BuildContext context,
  PromptBlock block,
) async {
  final toaster = context.toaster;
  final transcript = block.transcript;
  if (transcript == null) return;
  final filePath = block.filePath;
  final dir =
      filePath?.let(path.dirname) ?? context.read<Prompt?>()?.folderPath;
  if (dir == null) return;
  final name = _figureOutFileName('transcript', block.displayName, filePath);
  await saveTextToFile(dir, name, transcript);
  final fullPath = '$dir/$name.md';
  return toaster.show(
    ShadToast(
      title: const Text('Saved transcript.'),
      description: Text(fullPath),
      action: ShadButton.ghost(
        onPressed: () => revealInFinder(fullPath),
        child: const Text('Open'),
      ),
    ),
  );
}

Future<void> _saveSummaryAsMarkdown(
  BuildContext context,
  PromptBlock block,
) async {
  final toaster = context.toaster;
  final summary = block.summary;
  if (summary == null) return;
  final filePath = block.filePath;
  final dir =
      filePath?.let(path.dirname) ?? context.read<Prompt?>()?.folderPath;
  if (dir == null) return;
  final name = _figureOutFileName('summary', block.displayName, filePath);
  debugPrint('Saving summary to $name');
  await saveTextToFile(dir, name, summary);
  final fullPath = '$dir/$name.md';
  return toaster.show(
    ShadToast(
      title: const Text('Saved summary.'),
      description: Text(fullPath),
      action: ShadButton.ghost(
        onPressed: () => revealInFinder(fullPath),
        child: const Text('Open'),
      ),
    ),
  );
}

Future<void> _saveDescriptionAsMarkdown(
  BuildContext context,
  PromptBlock block,
) async {
  final toaster = context.toaster;
  final description = block.caption;
  if (description == null) return;
  final filePath = block.filePath;
  final dir =
      filePath?.let(path.dirname) ?? context.read<Prompt?>()?.folderPath;
  if (dir == null) return;
  final name = _figureOutFileName('description', block.displayName, filePath);
  await saveTextToFile(dir, name, description);
  final fullPath = '$dir/$name.md';
  return toaster.show(
    ShadToast(
      title: const Text('Saved description.'),
      description: Text(fullPath),
      action: ShadButton.ghost(
        onPressed: () => revealInFinder(fullPath),
        child: const Text('Open'),
      ),
    ),
  );
}
