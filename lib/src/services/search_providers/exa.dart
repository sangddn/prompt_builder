// ignore_for_file: avoid_dynamic_calls

part of 'search_providers.dart';

final class Exa extends SearchProvider {
  factory Exa([String? apiKey]) => apiKey == null ? _instance : Exa._(apiKey);
  const Exa._([this.apiKey]);

  static const Exa _instance = Exa._();

  @override
  final String? apiKey;

  @override
  String get apiKeyKey => 'exa_api_key';

  @override
  List<SearchFunction> get functions =>
      [SearchFunction.webSearch, SearchFunction.fetchWebpage];

  @override
  Future<List<SearchResult>> _search(String query) async {
    final apiKey = getApiKey();
    final response = await http.post(
      Uri.parse('https://api.exa.ai/search'),
      headers: {
        'x-api-key': apiKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'query': query,
        'useAutoprompt': true,
        'type': 'auto',
        'numResults': 10,
        'contents': {
          'text': {'includeHtmlTags': false},
          'highlights': {'numSentences': 3, 'highlightsPerUrl': 1},
        },
      }),
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw SearchException(
        'Exa search failed: ${error['message'] ?? response.reasonPhrase ?? 'Unknown error'}',
        provider: this,
      );
    }

    final data = jsonDecode(response.body);
    return (data['results'] as List)
        .cast<Map<String, dynamic>>()
        .map(SearchResult.fromExa)
        .toList();
  }

  @override
  Future<String> _fetchWebpage(String url) async {
    final apiKey = getApiKey();
    final response = await http.post(
      Uri.parse('https://api.exa.ai/contents'),
      headers: {
        'x-api-key': apiKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'ids': [url]}),
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw SearchException(
        'Exa search failed: ${error['message'] ?? response.reasonPhrase ?? 'Unknown error'}',
        provider: this,
      );
    }

    final data = jsonDecode(response.body);
    final result = ((data['results'] as List).firstOrNull as Map<String, dynamic>?)
        ?.let(SearchResult.fromExa);
    final text = result?.let((result) => '${result.text}\n\nHighlights:\n${result.highlights.join('\n')}');
    if (text == null) {
      throw SearchException('No text found in Exa response.', provider: this);
    }
    return text;
  }
}
