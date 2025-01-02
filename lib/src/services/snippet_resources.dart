import 'dart:convert';
import 'dart:io';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

/// Service responsible for fetching snippet resources from remote storage
abstract final class SnippetResourceService {
  static const _resourceUrl =
      'https://raw.githubusercontent.com/sangddn/prompt_builder/refs/heads/main/assets/snippet_resources.json';

  /// Fetches snippet resources from remote storage. Falls back to local asset
  /// file `assets/snippet_resources.json` if the request fails.
  ///
  /// Throws [HttpException] if the request fails
  /// Throws [FormatException] if the response cannot be parsed
  static Future<SnippetResources> fetchSnippetResources() async {
    final response = await http
        .get(Uri.parse(_resourceUrl))
        .timeout(const Duration(seconds: 10));
    final data = jsonDecode(
      response.statusCode == 200
          ? response.body
          : await rootBundle.loadString('assets/snippet_resources.json'),
    ) as Map<String, dynamic>;
    final snippetsJson = data['snippets'] as List<dynamic>;
    return snippetsJson
        .cast<Map<String, dynamic>>()
        .map(SnippetResource.fromJson)
        .toIList();
  }
}

typedef SnippetResources = IList<SnippetResource>;

/// Represents a single snippet resource with metadata
@immutable
class SnippetResource {
  const SnippetResource({
    required this.title,
    required this.content,
    required this.dateCreated,
    required this.author,
    required this.authorUrl,
    required this.tags,
  });

  factory SnippetResource.fromJson(Map<String, dynamic> json) {
    return SnippetResource(
      title: json['title'] as String,
      content: json['content'] as String,
      dateCreated: json['date_created'] as String,
      author: json['author'] as String? ?? 'Anonymous',
      authorUrl: json['author_url'] as String?,
      tags: IList((json['tags'] as List<dynamic>?)?.cast<String>()),
    );
  }
  final String title;
  final String content;
  final String dateCreated;
  final String author;
  final String? authorUrl;
  final IList<String> tags;

  /// Converts the resource to a JSON map
  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'date_created': dateCreated,
        'author': author,
        'author_url': authorUrl,
        'tags': tags.toList(),
      };

  @override
  String toString() {
    return 'SnippetResource(title: $title, content: $content, dateCreated: $dateCreated, author: $author, authorUrl: $authorUrl, tags: $tags)';
  }

  @override
  bool operator ==(Object other) =>
      other is SnippetResource &&
      other.title == title &&
      other.content == content &&
      other.dateCreated == dateCreated &&
      other.author == author &&
      other.authorUrl == authorUrl &&
      other.tags == tags;

  @override
  int get hashCode =>
      title.hashCode ^
      content.hashCode ^
      dateCreated.hashCode ^
      author.hashCode ^
      authorUrl.hashCode ^
      tags.hashCode;
}
