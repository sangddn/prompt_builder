import 'package:any_link_preview/any_link_preview.dart';
import 'package:http/http.dart' as http;

/// Service for fetching web content and metadata
abstract final class WebService {
  /// Fetches the Markdown content of a URL using the Jina API.
  ///
  /// Example:
  /// ```dart
  /// final markdown = await WebService.fetchMarkdown('https://example.com');
  /// ```
  static Future<String> fetchMarkdown(String url) async {
    final resp = await http.get(Uri.parse('https://r.jina.ai/$url'));
    if (resp.statusCode == 200) {
      return resp.body;
    } else {
      throw Exception(
        'Failed to fetch markdown from $url, status: ${resp.statusCode}',
      );
    }
  }

  /// Fetches preview metadata for a URL.
  ///
  /// Takes a [url] string parameter and returns a [Metadata] object containing
  /// preview information like title, description, images etc.
  /// Returns null if metadata cannot be extracted.
  ///
  /// Example:
  /// ```dart
  /// final metadata = await WebService.fetchPreview('https://example.com');
  /// print(metadata?.title);
  /// ```
  static Future<Metadata?> fetchPreview(String url) async =>
      AnyLinkPreview.getMetadata(link: url);
}
