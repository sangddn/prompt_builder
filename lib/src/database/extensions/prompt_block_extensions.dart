import 'dart:io';

import 'package:drift/drift.dart';
import 'package:mime/mime.dart';
import '../../services/other_services/mime_utils.dart';
import '../database.dart';

extension PromptBlocksExtension on Database {
  /// Create new block in the prompt
  Future<int> createBlock({
    required int promptId,
    required BlockType blockType,
    String? displayName,
    required double sortOrder,
    String? textContent,
    String? filePath,
    String? mimeType,
    int? fileSize,
    String? url,
    String? transcript,
    String? caption,
    String? summary,
  }) async {
    final now = DateTime.now();
    return into(promptBlocks).insert(
      PromptBlocksCompanion.insert(
        promptId: promptId,
        blockType: blockType.name,
        displayName: Value(displayName ?? ''),
        sortOrder: Value(sortOrder),
        textContent: Value(textContent),
        filePath: Value(filePath),
        mimeType: Value(mimeType),
        fileSize: Value(fileSize),
        url: Value(url),
        transcript: Value(transcript),
        caption: Value(caption),
        summary: Value(summary),
        createdAt: Value(now),
      ),
    );
  }

  Future<PromptBlock> getBlock(int id) async {
    return (select(promptBlocks)..where((t) => t.id.equals(id))).getSingle();
  }

  /// Update an existing block
  Future<void> updateBlock(
    int blockId, {
    BlockType? blockType,
    String? displayName,
    double? sortOrder,
    String? textContent,
    String? filePath,
    String? mimeType,
    int? fileSize,
    String? url,
    String? transcript,
    String? caption,
    String? summary,
    int? textContentTokenCount,
    int? summaryTokenCount,
    int? transcriptTokenCount,
    int? captionTokenCount,
  }) async {
    final now = DateTime.now();
    await (update(promptBlocks)..where((tbl) => tbl.id.equals(blockId))).write(
      PromptBlocksCompanion(
        blockType:
            blockType != null ? Value(blockType.name) : const Value.absent(),
        displayName:
            displayName != null ? Value(displayName) : const Value.absent(),
        sortOrder: sortOrder != null ? Value(sortOrder) : const Value.absent(),
        textContent:
            textContent != null ? Value(textContent) : const Value.absent(),
        filePath: filePath != null ? Value(filePath) : const Value.absent(),
        mimeType: mimeType != null ? Value(mimeType) : const Value.absent(),
        fileSize: fileSize != null ? Value(fileSize) : const Value.absent(),
        url: url != null ? Value(url) : const Value.absent(),
        transcript:
            transcript != null ? Value(transcript) : const Value.absent(),
        caption: caption != null ? Value(caption) : const Value.absent(),
        summary: summary != null ? Value(summary) : const Value.absent(),
        textContentTokenCount: textContentTokenCount != null
            ? Value(textContentTokenCount)
            : const Value.absent(),
        summaryTokenCount: summaryTokenCount != null
            ? Value(summaryTokenCount)
            : const Value.absent(),
        transcriptTokenCount: transcriptTokenCount != null
            ? Value(transcriptTokenCount)
            : const Value.absent(),
        captionTokenCount: captionTokenCount != null
            ? Value(captionTokenCount)
            : const Value.absent(),
        updatedAt: Value(now),
      ),
    );
  }

  /// Get all blocks of a prompt (ordered)
  Future<List<PromptBlock>> getBlocksByPrompt(int promptId) async {
    return (select(promptBlocks)
          ..where((tbl) => tbl.promptId.equals(promptId))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.sortOrder)]))
        .get();
  }

  /// Stream all blocks of a prompt (ordered)
  Stream<List<PromptBlock>> streamBlocksByPrompt(int promptId) {
    return (select(promptBlocks)
          ..where((tbl) => tbl.promptId.equals(promptId))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.sortOrder)]))
        .watch();
  }

  /// Delete a block (and related variables)
  Future<void> deleteBlock(int blockId) async {
    // Delete variables first
    await (delete(blockVariables)..where((tbl) => tbl.blockId.equals(blockId)))
        .go();
    // Delete block
    await (delete(promptBlocks)..where((tbl) => tbl.id.equals(blockId))).go();
  }

  /// Delete many blocks
  Future<void> deleteBlocks(List<int> blockIds) async {
    // Delete variables first
    await (delete(blockVariables)..where((tbl) => tbl.blockId.isIn(blockIds)))
        .go();
    // Delete blocks
    await (delete(promptBlocks)..where((tbl) => tbl.id.isIn(blockIds))).go();
  }
}

extension PromptBlockReorderExtension on Database {
  /// Reorders a block within the same prompt from position [oldIndex] to [newIndex].
  /// Uses a "gap-based" approach for sortOrder. If blocks end up too close,
  /// we'll do a quick reindex pass.
  Future<void> reorderBlock({
    required int promptId,
    required int blockId,
    required int newIndex,
  }) async {
    // 1. Load all blocks for this prompt, sorted by ascending sortOrder
    final blocks = await (select(promptBlocks)
          ..where((tbl) => tbl.promptId.equals(promptId))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.sortOrder)]))
        .get();

    // Safety check: if we don’t have enough blocks or block not found, bail out.
    if (blocks.isEmpty) return;
    final currentIndex = blocks.indexWhere((b) => b.id == blockId);
    if (currentIndex == -1) {
      // The block doesn't exist in this prompt
      return;
    }

    // 2. Remove the block from the old position
    final block = blocks.removeAt(currentIndex);

    // 3. Insert it back at the new position (clamping if out of range)
    final clampedIndex = newIndex.clamp(0, blocks.length);
    blocks.insert(clampedIndex, block);

    // 4. Figure out neighbors
    PromptBlock? prev;
    PromptBlock? next;

    if (clampedIndex > 0) {
      prev = blocks[clampedIndex - 1];
    }
    if (clampedIndex < blocks.length - 1) {
      next = blocks[clampedIndex + 1];
    }

    // 5. Compute a new sortOrder based on neighbors
    double newSortOrder;
    if (prev == null && next == null) {
      // Only one block in the entire list
      newSortOrder = 100.0;
    } else if (prev == null) {
      // Moved to the very front
      final nextOrder = next!.sortOrder;
      // pick something less than next, e.g. nextOrder - 100
      newSortOrder = nextOrder / 2;
      // or something like nextOrder - 100 if you prefer
    } else if (next == null) {
      // Moved to the very end
      final prevOrder = prev.sortOrder;
      newSortOrder = prevOrder + 100.0;
    } else {
      // Normal case: between two blocks
      final prevOrder = prev.sortOrder;
      final nextOrder = next.sortOrder;
      newSortOrder = (prevOrder + nextOrder) / 2.0;
    }

    // 6. Update the block with the new sortOrder
    await (update(promptBlocks)..where((t) => t.id.equals(block.id))).write(
      PromptBlocksCompanion(
        sortOrder: Value(newSortOrder),
        updatedAt: Value(DateTime.now()),
      ),
    );

    // 7. Optional: if our newSortOrder didn't actually move it or if there's
    //    any risk we "ran out of gaps," we do a quick reindex pass.
    //    Usually you'd check collisions or if newSortOrder == prev.sortOrder, etc.
    //
    //    For simplicity, let's detect if (newSortOrder <= prevOrder) or
    //    (newSortOrder >= nextOrder). That indicates we might have collision:
    if (prev != null && next != null) {
      if (newSortOrder <= prev.sortOrder || newSortOrder >= next.sortOrder) {
        await _reindexPromptBlocks(promptId);
      }
    }
  }

  /// Reindex pass: realign all blocks in increments of 100
  /// so future reorder operations have room to slot between them.
  Future<void> _reindexPromptBlocks(int promptId) async {
    final blocks = await (select(promptBlocks)
          ..where((tbl) => tbl.promptId.equals(promptId))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.sortOrder)]))
        .get();

    var sortValue = 100.0;
    for (final block in blocks) {
      await (update(promptBlocks)..where((t) => t.id.equals(block.id))).write(
        PromptBlocksCompanion(
          sortOrder: Value(sortValue),
          updatedAt: Value(DateTime.now()),
        ),
      );
      sortValue += 100.0;
    }
  }
}

extension PromptBlockExtension on PromptBlock {
  BlockType get type => BlockType.values.firstWhere((t) => t.name == blockType);

  bool get canBeCopied =>
      textContent != null ||
      summary != null ||
      transcript != null ||
      caption != null;

  /// Returns a string representation of this block in a format suitable for prompts.
  ///
  /// The returned string is formatted as an XML-like tag with the block's content.
  /// The tag type and attributes depend on the block type and content:
  ///
  /// - Text blocks use `<instructions>` with a label attribute
  /// - File blocks use `<file>` or `<file-summary>` with a path attribute
  /// - Web content uses `<webpage-content>` or `<webpage-summary>` with a url attribute
  /// - YouTube videos use `<youtube-video-transcript>` or `<youtube-video-summary>` with a url attribute
  /// - Audio uses `<audio-transcript>` or `<audio-summary>` with a path attribute
  /// - Video uses `<video-transcript>` or `<video-summary>` with a path attribute
  /// - Images use `<image-description>` with the caption as content
  ///
  /// If [preferSummary] is true and a summary exists, the summary version of the block will be used
  /// instead of the full content version.
  ///
  /// Returns null if the block cannot be copied (no content) or is an unsupported type.
  String? copyToPrompt({bool preferSummary = false}) {
    final type = this.type;
    if (type == BlockType.unsupported || !canBeCopied) {
      return null;
    }
    preferSummary = summary != null && preferSummary;
    final (tag, info) = switch ((type, preferSummary)) {
      (BlockType.text, _) => ('instructions', 'label="$displayName"'),
      (BlockType.localFile, false) => ('file', 'path="$filePath"'),
      (BlockType.localFile, true) => ('file-summary', 'path="$filePath"'),
      (BlockType.webUrl, false) => ('webpage-content', 'url="$url"'),
      (BlockType.webUrl, true) => ('webpage-summary', 'url="$url"'),
      (BlockType.youtube, false) => ('youtube-video-transcript', 'url="$url"'),
      (BlockType.youtube, true) => ('youtube-video-summary', 'url="$url"'),
      (BlockType.audio, false) => ('audio-transcript', 'path="$filePath"'),
      (BlockType.audio, true) => ('audio-summary', 'path="$filePath"'),
      (BlockType.video, false) => ('video-transcript', 'path="$filePath"'),
      (BlockType.video, true) => ('video-summary', 'path="$filePath"'),
      (BlockType.image, _) => ('image-description', 'path="$filePath"'),
      (BlockType.unsupported, _) =>
        throw Exception('Block is not supported to be copied to prompt.'),
    };
    final content = switch ((type, preferSummary)) {
      (BlockType.text, _) ||
      (BlockType.localFile || BlockType.webUrl, false) =>
        textContent,
      (BlockType.youtube || BlockType.audio || BlockType.video, false) =>
        transcript,
      (
        BlockType.youtube ||
            BlockType.audio ||
            BlockType.video ||
            BlockType.localFile ||
            BlockType.webUrl,
        true
      ) =>
        summary,
      (BlockType.image, _) => caption,
      (BlockType.unsupported, _) => throw Exception(),
    };
    if (content == null) {
      return null;
    }
    return '''
<$tag $info>
$content
</$tag>
''';
  }
}

extension PromptBlockCreation on Database {
  static bool isFileSupported(String filePath) =>
      canBeRepresentedAsText(filePath) ||
      isImageFile(filePath) ||
      isAudioFile(filePath) ||
      isVideoFile(filePath);

  Future<int> createBlockFromFile(
    String filePath, {
    required int promptId,
    required double sortOrder,
  }) async {
    final mimeType = lookupMimeType(filePath);

    if (canBeRepresentedAsText(filePath)) {
      final text = await File(filePath).readAsString();
      return createBlock(
        promptId: promptId,
        blockType: BlockType.localFile,
        filePath: filePath,
        textContent: text,
        mimeType: mimeType,
        sortOrder: sortOrder,
      );
    }

    return createBlock(
      promptId: promptId,
      blockType: isImageFile(filePath)
          ? BlockType.image
          : isAudioFile(filePath)
              ? BlockType.audio
              : isVideoFile(filePath)
                  ? BlockType.video
                  : BlockType.unsupported,
      filePath: filePath,
      mimeType: mimeType,
      sortOrder: sortOrder,
    );
  }
}
