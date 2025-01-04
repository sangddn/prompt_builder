// ignore_for_file: avoid_dynamic_calls

part of 'search_providers.dart';

final class Brave extends SearchProvider {
  factory Brave([String? apiKey]) =>
      apiKey == null ? _instance : Brave._(apiKey);
  const Brave._([this.apiKey]);

  static const Brave _instance = Brave._();

  @override
  final String? apiKey;

  @override
  String get apiKeyKey => 'brave_api_key';

  @override
  Future<List<SearchResult>> _search(String query) async {
    final apiKey = getApiKey();
    final response = await http.get(
      Uri.parse('https://api.search.brave.com/res/v1/web/search').replace(
        queryParameters: {
          'q': query,
          'count': '10',
          'text_decorations': '0',
          'safesearch': 'off',
        },
      ),
      headers: {
        'Accept': 'application/json',
        'X-Subscription-Token': apiKey,
      },
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw SearchException(
        'Brave search failed: ${error['message'] ?? response.reasonPhrase ?? 'Unknown error'}',
        provider: this,
      );
    }

    final data = jsonDecode(response.body);
    return (data['web']['results'] as List)
        .cast<Map<String, dynamic>>()
        .map(SearchResult.fromBrave)
        .toList();
  }

  @override
  Future<String> _fetchWebpage(String url) =>
      throw UnsupportedError('Brave does not support fetching webpages.');
}
