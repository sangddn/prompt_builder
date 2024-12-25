import 'package:drift/drift.dart';
import '../database.dart';

enum PromptSortBy {
  title,
  updatedAt,
  lastOpened,
  createdAt,
}

extension PromptsExtension on AppDatabase {
  /// Create a new prompt, returns the id
  Future<int> createPrompt({
    String? title,
    String? folderPath,
    String? ignorePatterns,
  }) async {
    final now = DateTime.now();
    final id = await into(prompts).insert(
      PromptsCompanion.insert(
        title: Value(title ?? ''),
        folderPath: Value(folderPath),
        ignorePatterns: Value(ignorePatterns ?? ''),
        createdAt: Value(now),
      ),
    );
    return id;
  }

  Future<Prompt> getPrompt(int id) async {
    return (select(prompts)..where((t) => t.id.equals(id))).getSingle();
  }

  /// Query prompts with optional sorting
  Future<List<Prompt>> queryPrompts({
    PromptSortBy sortBy = PromptSortBy.createdAt,
    bool ascending = false,
    int limit = 50,
    int offset = 0,
  }) async {
    final q = select(prompts)..limit(limit, offset: offset);

    switch (sortBy) {
      case PromptSortBy.title:
        q.orderBy([
          (t) => ascending
              ? OrderingTerm.asc(t.title)
              : OrderingTerm.desc(t.title),
        ]);
      case PromptSortBy.updatedAt:
        q.orderBy([
          (t) => ascending
              ? OrderingTerm.asc(t.updatedAt)
              : OrderingTerm.desc(t.updatedAt),
        ]);
      case PromptSortBy.lastOpened:
        q.orderBy([
          (t) => ascending
              ? OrderingTerm.asc(t.lastOpenedAt)
              : OrderingTerm.desc(t.lastOpenedAt),
        ]);
      case PromptSortBy.createdAt:
        q.orderBy([
          (t) => ascending
              ? OrderingTerm.asc(t.createdAt)
              : OrderingTerm.desc(t.createdAt),
        ]);
    }

    return q.get();
  }

  /// Update an existing prompt
  Future<void> updatePrompt(
    int promptId, {
    String? title,
    String? folderPath,
    String? ignorePatterns,
    bool? isLibrary,
  }) async {
    final now = DateTime.now();
    await (update(prompts)..where((tbl) => tbl.id.equals(promptId))).write(
      PromptsCompanion(
        title: title != null ? Value(title) : const Value.absent(),
        folderPath:
            folderPath != null ? Value(folderPath) : const Value.absent(),
        ignorePatterns: ignorePatterns != null
            ? Value(ignorePatterns)
            : const Value.absent(),
        updatedAt: Value(now),
      ),
    );
  }

  /// Delete a prompt and all its blocks.
  Future<void> deletePrompt(int promptId) async {
    // Query all blocks of the prompt
    final blocks = await getBlocksByPrompt(promptId);
    // Delete all blocks
    for (final block in blocks) {
      await deleteBlock(block.id);
    }
    // Delete the prompt:
    await (delete(prompts)..where((tbl) => tbl.id.equals(promptId))).go();
  }
}
