import 'package:drift/drift.dart';
import '../../core/core.dart';
import '../database.dart';

enum SnippetSortBy {
  title,
  createdAt,
  updatedAt,
  lastUsedAt,
}

extension SnippetsExtension on Database {
  /// Create a new text-based prompt
  Future<int> createSnippet({
    String? title,
    String? content,
    String? summary,
  }) async {
    final snippetId = await into(snippets).insert(
      SnippetsCompanion(
        title: title != null ? Value(title) : const Value.absent(),
        content: content != null ? Value(content) : const Value.absent(),
        summary: summary != null ? Value(summary) : const Value.absent(),
      ),
    );
    return snippetId;
  }

  Future<Snippet> getSnippet(int id) async {
    return (select(snippets)..where((t) => t.id.equals(id))).getSingle();
  }

  /// Query snippets with flexible sorting and filtering options.
  ///
  /// Parameters:
  /// - [sortBy] Field to sort results by (default: createdAt)
  /// - [ascending] Sort direction (default: false/descending)
  /// - [limit] Maximum number of results to return (default: 50)
  /// - [offset] Number of results to skip for pagination (default: 0)
  /// - [tags] List of tags to filter by
  /// - [searchQuery] Optional search query to filter by
  ///
  /// If [searchQuery] is not empty, it will be used to filter snippets
  /// case-insensitively in:
  /// - Snippet titles
  /// - Snippet content
  /// - Snippet summary
  /// - Snippet tags
  /// - Snippet notes
  ///
  /// Returns a list of snippets matching the query parameters.
  Future<List<Snippet>> querySnippets({
    SnippetSortBy sortBy = SnippetSortBy.createdAt,
    bool ascending = false,
    int limit = 50,
    int offset = 0,
    List<String> tags = const [],
    String searchQuery = '',
  }) async {
    final q = select(snippets)..limit(limit, offset: offset);

    if (tags.isNotEmpty) {
      Expression<bool> tagFilter = snippets.tags.like('%${tags[0]}%');
      for (var i = 1; i < tags.length; i++) {
        tagFilter = tagFilter | snippets.tags.like('%${tags[i]}%');
      }
      q.where((t) => tagFilter);
    }

    if (searchQuery.isNotEmpty) {
      final searchTerm = '%${searchQuery.toLowerCase()}%';
      q.where((t) {
        final titleMatch = t.title.lower().like(searchTerm);
        final contentMatch = t.content.lower().like(searchTerm);
        final summaryMatch = t.summary.lower().like(searchTerm);
        final tagsMatch = t.tags.lower().like(searchTerm);
        final notesMatch = t.notes.lower().like(searchTerm);
        return titleMatch |
            contentMatch |
            summaryMatch |
            tagsMatch |
            notesMatch;
      });
    }

    switch (sortBy) {
      case SnippetSortBy.title:
        q.orderBy([
          (t) => ascending
              ? OrderingTerm.asc(t.title)
              : OrderingTerm.desc(t.title),
        ]);
      case SnippetSortBy.createdAt:
        q.orderBy([
          (t) => ascending
              ? OrderingTerm.asc(t.createdAt)
              : OrderingTerm.desc(t.createdAt),
        ]);
      case SnippetSortBy.updatedAt:
        q.orderBy([
          (t) => ascending
              ? OrderingTerm.asc(t.updatedAt)
              : OrderingTerm.desc(t.updatedAt),
        ]);
      case SnippetSortBy.lastUsedAt:
        q.orderBy([
          (t) => ascending
              ? OrderingTerm.asc(t.lastUsedAt)
              : OrderingTerm.desc(t.lastUsedAt),
        ]);
    }
    return q.get();
  }

  /// Delete a snippet by its ID.
  Future<void> deleteSnippet(int id) async {
    await (delete(snippets)..where((t) => t.id.equals(id))).go();
  }

  /// Update a snippet by its ID.
  Future<void> updateSnippet(
    int id, {
    String? title,
    String? content,
    String? summary,
    List<String>? tags,
    String? notes,
  }) async {
    await (update(snippets)..where((t) => t.id.equals(id))).write(
      SnippetsCompanion(
        title: title != null ? Value(title) : const Value.absent(),
        content: content != null ? Value(content) : const Value.absent(),
        summary: summary != null ? Value(summary) : const Value.absent(),
        tags: tags != null
            ? Value(PromptTagsExtension.tagsToString(tags))
            : const Value.absent(),
        notes: notes != null ? Value(notes) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Record the last time the snippet was used.
  Future<void> recordLastUsed(int id) async {
    await (update(snippets)..where((t) => t.id.equals(id))).write(
      SnippetsCompanion(lastUsedAt: Value(DateTime.now())),
    );
  }
}

extension SnippetExtension on Snippet {
  /// The tags of the snippet as a list of strings.
  List<String> get tagsList =>
      tags?.let(PromptTagsExtension.tagStringToList) ?? [];

  /// Parse the variables from the given content.
  ///
  /// Variables can be formatted as:
  /// - `{{variableName=value}}` - variable with default value
  /// - `{{variableName}}` - variable without default value (equivalent to empty default)
  ///
  /// Returns a map of variable names to their default values.
  static Map<String, String> parseVariables(String content) {
    final variables = <String, String>{};

    // Match {{name=value}} format
    final matchesWithValue =
        RegExp(r'\{\{(\w+)=([^}]*)\}\}').allMatches(content);
    for (final match in matchesWithValue) {
      variables[match.group(1)!] = match.group(2)!;
    }

    // Match {{name}} format
    final matchesWithoutValue = RegExp(r'\{\{(\w+)\}\}').allMatches(content);
    for (final match in matchesWithoutValue) {
      final name = match.group(1)!;
      // Only add if not already added by previous regex
      if (!variables.containsKey(name)) {
        variables[name] = '';
      }
    }

    return variables;
  }

  /// Replace the value of a variable in the given content.
  ///
  /// Handles both `{{variableName=value}}` and `{{variableName}}` formats.
  /// Returns the new content with the variable value updated.
  static String replaceVariableValue(
    String content,
    String variableName,
    String newValue,
  ) {
    var updatedContent = content;

    // Replace {{name=value}} format
    updatedContent = updatedContent.replaceAllMapped(
      RegExp(r'\{\{(\w+)=([^}]*)\}\}'),
      (match) => match.group(1) == variableName
          ? '{{$variableName=$newValue}}'
          : match.group(0)!,
    );

    // Replace {{name}} format
    updatedContent = updatedContent.replaceAllMapped(
      RegExp(r'\{\{(\w+)\}\}'),
      (match) => match.group(1) == variableName
          ? '{{$variableName=$newValue}}'
          : match.group(0)!,
    );

    return updatedContent;
  }

  /// Replace the values of multiple variables in the snippet content.
  static String replaceVariableValues(
    String content,
    Map<String, String> variables,
  ) {
    var updatedContent = content;
    for (final variable in variables.entries) {
      updatedContent = replaceVariableValue(
        updatedContent,
        variable.key,
        variable.value,
      );
    }
    return updatedContent;
  }

  /// Collapses the variables in the snippet content to their values.
  /// For example, `{{name=value}}` becomes `value`.
  static String collapseVariables(String content) {
    return content.replaceAllMapped(
      RegExp(r'\{\{(\w+)(?:=([^}]*))?\}\}'),
      (match) => match.group(2) ?? '',
    );
  }

  /// Get the variables from the snippet content, mapped to their default values.
  Map<String, String> get variables => parseVariables(content);
}
