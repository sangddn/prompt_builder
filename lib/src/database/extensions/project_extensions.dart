import 'package:drift/drift.dart';
import '../database.dart';

enum ProjectSortBy {
  title,
  createdAt,
  updatedAt,
}

extension ProjectsExtension on Database {
  Future<int> createProject({
    String? title,
    String? notes,
    String? emoji,
    int? color,
  }) async {
    final now = DateTime.now();

    return into(projects).insert(
      ProjectsCompanion(
        title: Value(title ?? ''),
        notes: Value(notes ?? ''),
        emoji: emoji != null ? Value(emoji) : const Value.absent(),
        color: color != null ? Value(color) : const Value.absent(),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }

  Future<Project> getProject(int id) {
    return (select(projects)..where((p) => p.id.equals(id))).getSingle();
  }

  Future<List<Project>> queryProjects({
    ProjectSortBy sortBy = ProjectSortBy.createdAt,
    bool ascending = true,
    int limit = 50,
    int offset = 0,
    String searchQuery = '',
  }) async {
    final q = select(projects)..limit(limit, offset: offset);

    if (searchQuery.isNotEmpty) {
      final searchTerm = '%${searchQuery.toLowerCase()}%';
      q.where((p) {
        final titleMatch = p.title.lower().like(searchTerm);
        final notesMatch = p.notes.lower().like(searchTerm);
        return titleMatch | notesMatch;
      });
    }

    switch (sortBy) {
      case ProjectSortBy.title:
        q.orderBy([
          (p) => ascending
              ? OrderingTerm.asc(p.title)
              : OrderingTerm.desc(p.title),
        ]);
      case ProjectSortBy.createdAt:
        q.orderBy([
          (p) => ascending
              ? OrderingTerm.asc(p.createdAt)
              : OrderingTerm.desc(p.createdAt),
        ]);
      case ProjectSortBy.updatedAt:
        q.orderBy([
          (p) => ascending
              ? OrderingTerm.asc(p.updatedAt)
              : OrderingTerm.desc(p.updatedAt),
        ]);
    }

    return q.get();
  }

  Future<void> updateProject(
    int id, {
    String? title,
    String? notes,
    String? emoji,
    int? color,
  }) async {
    final now = DateTime.now();
    await (update(projects)..where((p) => p.id.equals(id))).write(
      ProjectsCompanion(
        title: title != null ? Value(title) : const Value.absent(),
        notes: notes != null ? Value(notes) : const Value.absent(),
        emoji: emoji != null ? Value(emoji) : const Value.absent(),
        color: color != null ? Value(color) : const Value.absent(),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> deleteProject(int id) async {
    // Update prompts and snippets to remove project reference
    await (update(prompts)..where((p) => p.projectId.equals(id)))
        .write(const PromptsCompanion(projectId: Value(null)));
    await (update(snippets)..where((s) => s.projectId.equals(id)))
        .write(const SnippetsCompanion(projectId: Value(null)));

    // Delete the project
    await (delete(projects)..where((p) => p.id.equals(id))).go();
  }

  Future<void> addPromptToProject(int projectId, int promptId) async {
    await (update(prompts)..where((p) => p.id.equals(promptId)))
        .write(PromptsCompanion(projectId: Value(projectId)));
    return;
  }

  Future<void> removePromptFromProject(int promptId) async {
    await (update(prompts)..where((p) => p.id.equals(promptId)))
        .write(const PromptsCompanion(projectId: Value(null)));
    return;
  }

  Future<void> addSnippetToProject(int projectId, int snippetId) async {
    await (update(snippets)..where((s) => s.id.equals(snippetId)))
        .write(SnippetsCompanion(projectId: Value(projectId)));
    return;
  }

  Future<void> removeSnippetFromProject(int snippetId) async {
    await (update(snippets)..where((s) => s.id.equals(snippetId)))
        .write(const SnippetsCompanion(projectId: Value(null)));
    return;
  }
}
