import 'package:drift/drift.dart';
import '../database.dart';

extension PromptBlocksExtension on AppDatabase {
  /// Create new block in the prompt
  Future<int> createBlock({
    required int promptId,
    required BlockType blockType,
    String? displayName,
    int sortOrder = 0,
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
    int? sortOrder,
    String? textContent,
    String? filePath,
    String? mimeType,
    int? fileSize,
    String? url,
    String? transcript,
    String? caption,
    String? summary,
    int? tokenCount,
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
        tokenCount:
            tokenCount != null ? Value(tokenCount) : const Value.absent(),
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

  /// Delete a block (and related variables)
  Future<void> deleteBlock(int blockId) async {
    // Delete variables first
    await (delete(blockVariables)..where((tbl) => tbl.blockId.equals(blockId)))
        .go();
    // Delete block
    await (delete(promptBlocks)..where((tbl) => tbl.id.equals(blockId))).go();
  }
}

extension PromptBlockExtension on PromptBlock {
  BlockType get type => BlockType.values.firstWhere((t) => t.name == blockType);
}
