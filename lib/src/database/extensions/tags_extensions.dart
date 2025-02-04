import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import '../database.dart';

enum TagType {
  prompt,
  snippet,
  ;

  String get tableName => switch (this) {
        prompt => 'prompts',
        snippet => 'snippets',
      };
}

/// Extension methods for tag-related database operations
extension TagsExtension on Database {
  Selectable<TagCount> _createTagsQuery({
    required int limit,
    required int offset,
    required String searchQuery,
    required int minCount,
    required TagType type,
    Value<int?> projectId = const Value.absent(),
  }) {
    var projectFilter = '';
    if (projectId case Value(:final value)) {
      projectFilter =
          value == null ? 'AND project_id IS NULL' : 'AND project_id = ?';
    }

    return customSelect(
      '''
      WITH RECURSIVE
      split_tags(tag) AS (
        SELECT trim(value)
        FROM ${type.tableName}, json_each('["' || replace(tags, '|', '","') || '"]')
        WHERE value != ''
        $projectFilter
      )
      SELECT 
        tag,
        COUNT(*) as count
      FROM split_tags
      WHERE tag != ''
      ${searchQuery.isNotEmpty ? "AND lower(tag) LIKE ?" : ""}
      GROUP BY tag
      HAVING count >= ?
      ORDER BY count DESC, lower(tag) ASC
      LIMIT ? OFFSET ?
      ''',
      variables: [
        if (projectId case Value(:final value))
          if (value != null) Variable.withInt(value),
        if (searchQuery.isNotEmpty)
          Variable.withString('%${searchQuery.toLowerCase()}%'),
        Variable.withInt(minCount),
        Variable.withInt(limit),
        Variable.withInt(offset),
      ],
      readsFrom: {if (type == TagType.prompt) prompts else snippets},
    ).map(
      (row) => TagCount(
        tag: row.read<String>('tag'),
        count: row.read<int>('count'),
      ),
    );
  }

  /// Streams tags ordered by their frequency of use.
  ///
  /// Parameters:
  /// - [limit] Maximum number of tags to return (default: 50)
  /// - [offset] Number of tags to skip for pagination (default: 0)
  /// - [searchQuery] Optional search query to filter tags (case-insensitive)
  /// - [minCount] Minimum number of times a tag must be used to be included
  ///
  /// Returns a list of [TagCount] objects containing the tag and its usage count.
  Stream<List<TagCount>> streamTagsByFrequency({
    int limit = 50,
    int offset = 0,
    String searchQuery = '',
    int minCount = 1,
    required TagType type,
    Value<int?> projectId = const Value.absent(),
  }) {
    return _createTagsQuery(
      limit: limit,
      offset: offset,
      searchQuery: searchQuery,
      minCount: minCount,
      type: type,
      projectId: projectId,
    ).watch();
  }

  /// Returns the total count of unique tags in the database.
  ///
  /// Parameters:
  /// - [searchQuery] Optional search query to filter tags (case-insensitive)
  /// - [minCount] Minimum number of times a tag must be used to be included
  Future<int> getTagsCount({
    String searchQuery = '',
    int minCount = 1,
    required TagType type,
    Value<int?> projectId = const Value.absent(),
  }) async {
    var projectFilter = '';
    if (projectId case Value(:final value)) {
      projectFilter =
          value == null ? 'AND project_id IS NULL' : 'AND project_id = ?';
    }

    final query = customSelect(
      '''
      WITH RECURSIVE
      split_tags(tag) AS (
        SELECT trim(value)
        FROM ${type.tableName}, json_each('["' || replace(tags, '|', '","') || '"]')
        WHERE value != ''
        $projectFilter
      )
      SELECT COUNT(*) as total
      FROM (
        SELECT tag, COUNT(*) as count
        FROM split_tags
        WHERE tag != ''
        ${searchQuery.isNotEmpty ? "AND lower(tag) LIKE ?" : ""}
        GROUP BY tag
        HAVING count >= ?
      )
      ''',
      variables: [
        if (projectId case Value(:final value))
          if (value != null) Variable.withInt(value),
        if (searchQuery.isNotEmpty)
          Variable.withString('%${searchQuery.toLowerCase()}%'),
        Variable.withInt(minCount),
      ],
      readsFrom: {if (type == TagType.prompt) prompts else snippets},
    );

    final row = await query.getSingle();
    return row.read<int>('total');
  }

  /// Returns all prompts that have the specified tag.
  Future<List<dynamic>> getItemsByTag(
    String tag, {
    int limit = 50,
    int offset = 0,
    required TagType type,
    Value<int?> projectId = const Value.absent(),
  }) async {
    if (type == TagType.prompt) {
      final query = select(prompts)..where((p) => p.tags.like('%|$tag|%'));

      if (projectId case Value(:final value)) {
        query.where(
          (p) =>
              value == null ? p.projectId.isNull() : p.projectId.equals(value),
        );
      }

      query.limit(limit, offset: offset);
      return query.get();
    } else {
      final query = select(snippets)..where((s) => s.tags.like('%|$tag|%'));

      if (projectId case Value(:final value)) {
        query.where(
          (s) =>
              value == null ? s.projectId.isNull() : s.projectId.equals(value),
        );
      }

      query.limit(limit, offset: offset);
      return query.get();
    }
  }

  Future<List<TagCount>> getTagsByFrequency({
    int limit = 50,
    int offset = 0,
    String searchQuery = '',
    int minCount = 1,
    required TagType type,
    Value<int?> projectId = const Value.absent(),
  }) {
    return _createTagsQuery(
      limit: limit,
      offset: offset,
      searchQuery: searchQuery,
      minCount: minCount,
      type: type,
      projectId: projectId,
    ).get();
  }
}

/// Represents a tag and its usage count in the database
@immutable
class TagCount {
  const TagCount({
    required this.tag,
    required this.count,
  });

  final String tag;
  final int count;

  @override
  String toString() => '$tag ($count)';

  @override
  bool operator ==(Object other) =>
      other is TagCount && other.tag == tag && other.count == count;

  @override
  int get hashCode => Object.hash(tag, count);
}
