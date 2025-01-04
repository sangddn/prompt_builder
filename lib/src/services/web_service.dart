import 'package:any_link_preview/any_link_preview.dart';
import 'package:http/http.dart' as http;

import 'other_services/html_to_markdown.dart';

/// Service for fetching web content and metadata
abstract final class WebService {
  /// {@template services.other_services.web_service.fetchContent}
  /// Fetches raw HTML content from a URL.
  /// 
  /// Takes a [url] string parameter and returns the HTML content as a [String].
  /// 
  /// Throws an [Exception] if the request fails or returns a non-200 status code.
  /// 
  /// Example:
  /// ```dart
  /// final content = await WebService.fetchContent('https://example.com');
  /// ```
  /// {@endtemplate}
  static Future<String> fetchContent(String url) async {
    final resp = await http.get(Uri.parse(url));
    if (resp.statusCode == 200) {
      return resp.body;
    } else {
      throw Exception(
        'Failed to fetch content from $url, status: ${resp.statusCode}',
      );
    }
  }

  /// Fetches the HTML content of a URL and parses it into Markdown.
  /// 
  /// Example:
  /// ```dart
  /// final markdown = await WebService.fetchMarkdown('https://example.com');
  /// ```
  /// 
  /// See also:
  /// - [fetchContent]
  static Future<String> fetchMarkdown(String url) async {
    final html = await fetchContent(url);
    return htmlToMarkdown(html);
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
