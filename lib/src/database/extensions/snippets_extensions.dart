import 'package:drift/drift.dart';
import '../database.dart';

enum SnippetSortBy {
  title,
  createdAt,
  updatedAt,
  lastUsedAt,
}

extension SnippetsExtension on AppDatabase {
  /// Create a new text-based prompt
  Future<int> createSnippet({String? title, String? content}) async {
    final snippetId = await into(snippets).insert(
      SnippetsCompanion(
        title: title != null ? Value(title) : const Value.absent(),
        content: content != null ? Value(content) : const Value.absent(),
      ),
    );
    return snippetId;
  }

  Future<Snippet> getSnippet(int id) async {
    return (select(snippets)..where((t) => t.id.equals(id))).getSingle();
  }

  /// Query text prompts
  Future<List<Snippet>> querySnippets({
    int limit = 50,
    int offset = 0,
    SnippetSortBy sortBy = SnippetSortBy.createdAt,
    bool ascending = false,
  }) async {
    final q = select(snippets)..limit(limit, offset: offset);

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
}
