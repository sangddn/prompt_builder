// ignore_for_file: avoid_dynamic_calls

part of 'search_providers.dart';

@immutable
final class SearchResult {
  const SearchResult({
    required this.title,
    required this.url,
    this.faviconUrl,
    this.publishedDate,
    this.author,
    required this.text,
    this.highlights = const [],
    this.summary,
  });

  factory SearchResult.fromExa(Map<String, dynamic> json) {
    return SearchResult(
      title: json['title'] as String,
      url: json['url'] as String,
      faviconUrl: json['favicon'] as String?,
      publishedDate: (json['publishedDate'] as String?)?.let(DateTime.tryParse),
      author: json['author'] as String?,
      text: json['text'] as String,
      highlights:
          (json['highlights'] as List<dynamic>?)?.cast<String>() ?? const [],
      summary: json['summary'] as String?,
    );
  }

  factory SearchResult.fromBrave(Map<String, dynamic> json) {
    return SearchResult(
      title: json['title'] as String,
      url: json['url'] as String,
      faviconUrl: (json['thumbnail']?['original'] ?? json['thumbnail']?['src'])
          as String?,
      text: json['description'] as String?,
      highlights: (json['extra_snippets'] as List?)?.cast<String>() ?? const [],
      publishedDate: (json['page_fetched'] as String?)?.let(DateTime.tryParse),
      author: json['profile']?['name'] as String?,
    );
  }

  final String title;
  final String url;
  final String? faviconUrl;
  final DateTime? publishedDate;
  final String? author;
  final String? text;
  final List<String> highlights;
  final String? summary;

  @override
  String toString() {
    return 'SearchResult(title: $title, url: $url, faviconUrl: $faviconUrl, publishedDate: $publishedDate, author: $author, text: $text, highlights: $highlights, summary: $summary)';
  }

  @override
  bool operator ==(Object other) =>
      other is SearchResult &&
      other.title == title &&
      other.url == url &&
      other.faviconUrl == faviconUrl &&
      other.publishedDate == publishedDate &&
      other.author == author &&
      other.text == text &&
      other.highlights == highlights &&
      other.summary == summary;

  @override
  int get hashCode => Object.hash(
        title,
        url,
        faviconUrl,
        publishedDate,
        author,
        text,
        highlights,
        summary,
      );
}
