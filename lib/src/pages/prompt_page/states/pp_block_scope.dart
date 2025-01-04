part of '../prompt_page.dart';

/// A widget that provides block-related data and functionality for a specific prompt.
///
/// This scope manages:
/// - List of blocks associated with the prompt
/// - Unique keys for each block
/// - Block reordering functionality
/// - Local file and folder selection
class _PPBlockScope extends StatelessWidget {
  const _PPBlockScope({
    required this.promptId,
    required this.child,
  });

  /// The ID of the prompt this scope is associated with
  final int promptId;

  /// The child widget that will have access to this scope's providers
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<_PromptBlockList>(
          initialData: const IList.empty(),
          create: (context) =>
              context.db.streamBlocksByPrompt(promptId).map((e) => IList(e)),
        ),
        ProxyProvider<_PromptBlockList, _BlockReorderCallback>(
          update: (context, blocks, _) =>
              (oldIndex, newIndex) => context.db.reorderBlock(
                    promptId: promptId,
                    blockId: blocks[oldIndex].id,
                    newIndex: newIndex,
                  ),
        ),
      ],
      child: child,
    );
  }
}

// -----------------------------------------------------------------------------
// Providers & Typedefs
// -----------------------------------------------------------------------------

typedef _PromptBlockList = IList<PromptBlock>;
typedef _BlockReorderCallback = void Function(int oldIndex, int newIndex);

// -----------------------------------------------------------------------------
// Extensions
// -----------------------------------------------------------------------------

/// Extension methods for accessing block-related data from the BuildContext
extension _PromptBlockScopeExtension on BuildContext {
  /// Returns the current list of prompt blocks
  _PromptBlockList get promptBlocks => read();

  /// Applies a transformation function to the block list and watches for changes
  T selectBlocks<T>(T Function(_PromptBlockList) fn) => select(fn);

  /// Watches and returns a specific block by its index
  PromptBlock? watchBlock(int index) =>
      selectBlocks((bs) => bs.elementAtOrNull(index));

  /// Creates a new text block for the prompt at the given index and returns its
  /// ID. The new block will occupy the given index in the new list.
  ///
  /// If the index is 0, the new block will be inserted at the beginning of the
  /// list. If the index is the currently last index (n_old - 1), the new block
  /// will be inserted right before the last block.
  Future<int?> createTextBlockAtIndex(
    int index, {
    String? displayName,
    String? textContent,
  }) async {
    final promptId = prompt?.id;
    if (promptId == null) return null;
    if (index < 0) throw StateError('New index must be non-negative.');
    if (index == 0) {
      final prevSortOrder = promptBlocks.firstOrNull?.sortOrder;
      final sortOrder = (prevSortOrder ?? 10e6) / 2;
      return db.createBlock(
        promptId: promptId,
        blockType: BlockType.text,
        displayName: displayName,
        textContent: textContent,
        sortOrder: sortOrder,
      );
    }
    final currentLength = promptBlocks.length;
    if (index >= currentLength) {
      final currentLastSortOrder = promptBlocks.lastOrNull?.sortOrder;
      final sortOrder = (currentLastSortOrder ?? 10e6) * 2;
      return db.createBlock(
        promptId: promptId,
        blockType: BlockType.text,
        displayName: displayName,
        textContent: textContent,
        sortOrder: sortOrder,
      );
    }
    final prevSortOrder = promptBlocks[index - 1].sortOrder;
    final nextSortOrder = promptBlocks[index].sortOrder;
    final sortOrder = (prevSortOrder + nextSortOrder) / 2;
    return db.createBlock(
      promptId: promptId,
      blockType: BlockType.text,
      displayName: displayName,
      textContent: textContent,
      sortOrder: sortOrder,
    );
  }

  /// Create a new block from a web URL.
  Future<int?> createWebBlock(String url) async {
    final promptId = prompt?.id;
    if (promptId == null) return null;
    final toaster = this.toaster;
    final searchProvider =
        SearchProviderPreference.getValidProviderWithFallback();
    try {
      final (id, content) =
          await db.createWebBlock(promptId, url, searchProvider) ??
              (null, null);
      if (content == null) return null;
      toaster.show(
        ShadToast(
          title: Text('Added content from $url.'),
          description: Text('"$content"', maxLines: 10),
        ),
      );
      return id;
    } on HttpException catch (e) {
      debugPrint('Failed to create web block: $e');
      toaster.show(
        const ShadToast.destructive(
          title: Text('Failed to fetch web content.'),
        ),
      );
      return null;
    }
  }

  /// Handle [DataReader]s -- results from drop events or paste events.
  Future<void> handleDataReaders(Iterable<DataReader> readers) async {
    final toaster = this.toaster;
    for (final reader in readers) {
      // Local files with a file path.
      if (reader.canProvide(Formats.fileUri)) {
        reader.getValue(Formats.fileUri, (value) async {
          if (value == null || !mounted) return;
          await _handleNodeSelection(
            this,
            reloadNode: true,
            fullPath: value.toFilePath(),
            isSelected: true,
          );
        });
        return;
      }
      // A special case for .eml files.
      if (reader.canProvide(emlFileFormat)) {
        reader.getFile(
          emlFileFormat,
          (file) async {
            if (!mounted) return;
            final content = await utf8.decodeStream(file.getStream());
            await createTextBlockAtIndex(
              promptBlocks.length,
              displayName: file.fileName ?? 'Email',
              textContent: content,
            );
            toaster.show(
              ShadToast(
                title: const Text('Added email content.'),
                description: Text(
                  '"$content"',
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          },
          onError: (error) {
            debugPrint('Error reading email: $error');
          },
        );
        return;
      }
      // For data without a file path, we can only handle text-based formats.
      final availableFormats = reader.getFormats(kTextBasedFileFormats);
      if (availableFormats.isNotEmpty) {
        reader.getFile(availableFormats.first as SimpleFileFormat,
            (file) async {
          if (!mounted) return;
          final content = await utf8.decodeStream(file.getStream());
          await createTextBlockAtIndex(
            promptBlocks.length,
            displayName:
                file.fileName ?? (await reader.getSuggestedName()) ?? 'File',
            textContent: content,
          );
          toaster.show(
            ShadToast(
              title: const Text('Added file content.'),
              description: Text(
                '"$content"',
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        });
        return;
      }

      // We consider value-based formats last because they are the most general.
      var somethingAdded = false;

      if (reader.canProvide(Formats.htmlText)) {
        reader.getValue(Formats.htmlText, (value) async {
          if (value == null || !mounted || somethingAdded) return;
          await createTextBlockAtIndex(
            promptBlocks.length,
            displayName: await reader.getSuggestedName() ?? 'HTML',
            textContent: htmlToMarkdown(value),
          );
          somethingAdded = true;
        });
      }
      // We consider URIs last because they are the most general format.
      if (reader.canProvide(Formats.uri)) {
        reader.getValue(Formats.uri, (value) async {
          final uri = value?.uri;
          if (uri == null || !mounted || somethingAdded) return;
          if ((uri.scheme == 'http' || uri.scheme == 'https') &&
              uri.host.isNotEmpty) {
            await createWebBlock(uri.toString());
            somethingAdded = true;
          }
        });
      }
      if (reader.canProvide(Formats.plainText)) {
        reader.getValue(Formats.plainText, (value) async {
          if (value == null || !mounted || somethingAdded) return;
          await createTextBlockAtIndex(
            promptBlocks.length,
            displayName: await reader.getSuggestedName() ?? 'Text',
            textContent: value,
          );
          somethingAdded = true;
        });
      }
      return;
    }
  }
}
