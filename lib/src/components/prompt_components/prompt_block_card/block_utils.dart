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
  Database get db => read();
  T selectBlock<T>(T Function(PromptBlock block) fn) => select(fn);

  ValueNotifier<_BlockHoverState> get hoverNotifier => read();
  bool isHovered() =>
      watch<ValueNotifier<_BlockHoverState>>().value == _BlockHoverState.hover;
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
