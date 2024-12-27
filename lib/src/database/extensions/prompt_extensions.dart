import 'package:drift/drift.dart';
import '../database.dart';

/// Defines sorting options for prompts
enum PromptSortBy {
  /// Sort by prompt title alphabetically
  title,

  /// Sort by last update timestamp
  updatedAt,

  /// Sort by last opened timestamp
  lastOpened,

  /// Sort by creation timestamp
  createdAt,
}

/// Extension methods for prompt-related database operations
extension PromptsExtension on Database {
  /// Creates a new prompt in the database.
  ///
  /// Returns the ID of the newly created prompt.
  ///
  /// Parameters:
  /// - [title] Optional title for the prompt
  /// - [folderPath] Optional file system path for associated folder
  /// - [ignorePatterns] Optional patterns to ignore when scanning folder
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
    // We always create a TextBlock for the prompt
    await createBlock(
      promptId: id,
      blockType: BlockType.text,
      sortOrder: 100.0,
    );
    return id;
  }

  /// Retrieves a single prompt by its ID.
  ///
  /// Throws [StateError] if no prompt exists with the given ID.
  Future<Prompt> getPrompt(int id) async {
    return (select(prompts)..where((t) => t.id.equals(id))).getSingle();
  }

  /// Queries prompts with flexible sorting and filtering options.
  ///
  /// Parameters:
  /// - [sortBy] Field to sort results by (default: createdAt)
  /// - [ascending] Sort direction (default: false/descending)
  /// - [limit] Maximum number of results to return (default: 50)
  /// - [offset] Number of results to skip for pagination (default: 0)
  /// - [tags] Optional list of tags to filter by
  /// - [searchQuery] Optional search query to filter by
  ///
  /// If [searchQuery] is not empty, it will be used to filter prompts
  /// case-insensitively in:
  /// - Prompt titles
  /// - Notes
  /// - Tags
  ///
  /// Returns a list of prompts matching the query parameters.
  Future<List<Prompt>> queryPrompts({
    PromptSortBy sortBy = PromptSortBy.createdAt,
    bool ascending = false,
    int limit = 50,
    int offset = 0,
    List<String> tags = const [],
    String searchQuery = '',
  }) async {
    final q = select(prompts)..limit(limit, offset: offset);

    if (tags.isNotEmpty) {
      Expression<bool> tagFilter = prompts.tags.like('%${tags[0]}%');
      for (var i = 1; i < tags.length; i++) {
        tagFilter = tagFilter | prompts.tags.like('%${tags[i]}%');
      }
      q.where((t) => tagFilter);
    }

    if (searchQuery.isNotEmpty) {
      final searchTerm = '%${searchQuery.toLowerCase()}%';
      q.where((t) {
        final titleMatch = t.title.lower().like(searchTerm);
        final notesMatch = t.notes.lower().like(searchTerm);
        final tagsMatch = t.tags.lower().like(searchTerm);
        return titleMatch | notesMatch | tagsMatch;
      });
    }

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

  /// Updates an existing prompt's properties.
  ///
  /// Only provided non-null parameters will be updated.
  ///
  /// Parameters:
  /// - [promptId] ID of the prompt to update
  /// - [title] Optional new title
  /// - [folderPath] Optional new folder path
  /// - [ignorePatterns] Optional new ignore patterns
  /// - [isLibrary] Optional library status flag
  /// - [tags] Optional list of tags to replace existing tags
  Future<void> updatePrompt(
    int promptId, {
    String? title,
    String? notes,
    String? folderPath,
    String? ignorePatterns,
    bool? isLibrary,
    List<String>? tags,
  }) async {
    final now = DateTime.now();
    await (update(prompts)..where((tbl) => tbl.id.equals(promptId))).write(
      PromptsCompanion(
        title: title != null ? Value(title) : const Value.absent(),
        notes: notes != null ? Value(notes) : const Value.absent(),
        folderPath:
            folderPath != null ? Value(folderPath) : const Value.absent(),
        ignorePatterns: ignorePatterns != null
            ? Value(ignorePatterns)
            : const Value.absent(),
        tags: tags != null
            ? Value(PromptTagsExtension.tagsToString(tags))
            : const Value.absent(),
        updatedAt: Value(now),
      ),
    );
  }

  /// Deletes a prompt and all its associated blocks.
  ///
  /// This operation cascades the deletion to all related blocks
  /// to maintain database integrity.
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

/// Extension methods for handling prompt tags
extension PromptTagsExtension on Prompt {
  /// Separator used between tags in the stored string
  static const _tagSeparator = '|';

  /// Converts the stored tags string to a list of individual tags.
  ///
  /// Returns an empty list if no tags are stored.
  List<String> get tagsList => tags.isEmpty
      ? []
      : tags
          .split(_tagSeparator)
          .where((t) => t.isNotEmpty)
          .map((t) => t.trim())
          .toList();

  /// Converts a list of tags into a storage-ready string.
  ///
  /// Filters out empty tags and tags containing the separator character.
  static String tagsToString(List<String> tagsList) {
    return tagsList
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty && !t.contains(_tagSeparator))
        .toList()
        .join(_tagSeparator);
  }

  /// Validates if a single tag string is valid for storage.
  ///
  /// A valid tag:
  /// - Is not empty after trimming
  /// - Does not contain the separator character
  static bool isValidTag(String tag) {
    final trimmed = tag.trim();
    return trimmed.isNotEmpty && !trimmed.contains(_tagSeparator);
  }
}
