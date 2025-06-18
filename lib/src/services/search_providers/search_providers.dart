import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../core/core.dart';
import '../../database/database.dart';
import '../services.dart';

part 'search_result.dart';

part 'brave.dart';
part 'exa.dart';
part 'serper.dart';

final kAllSearchProviders = [Exa(), Brave()];

sealed class SearchProvider with ProviderWithApiKey {
  const SearchProvider();

  /// Searches for results based on the given query.
  ///
  /// This method attempts to search for results using the provider's search
  /// capabilities. It handles exceptions such as missing API keys and network
  /// errors.
  Future<List<SearchResult>> search(String query) {
    try {
      return _search(query);
    } on ApiKeyNotSetException {
      debugPrint('Missing API key for $runtimeType.');
      rethrow;
    } on FormatException {
      throw SearchException(
        'Invalid response format from $runtimeType API.',
        provider: this,
      );
    } on http.ClientException catch (e) {
      throw SearchException(
        'Network error while searching $runtimeType: ${e.message}.',
        provider: this,
      );
    } catch (e) {
      throw SearchException(
        'Unexpected error while searching $runtimeType: $e.',
        provider: this,
      );
    }
  }

  /// Internal search method that handles exceptions.
  Future<List<SearchResult>> _search(String query);

  /// Fetches a webpage based on the given URL.
  Future<String> fetchWebpage(String url) {
    try {
      return _fetchWebpage(url);
    } on ApiKeyNotSetException {
      debugPrint('Missing API key for $runtimeType.');
      rethrow;
    } on FormatException {
      throw SearchException(
        'Invalid response format from $runtimeType API.',
        provider: this,
      );
    } on UnsupportedError {
      debugPrint(
        '$runtimeType does not support fetching webpages. Falling back to `WebService.fetchMarkdown`.',
      );
      return WebService.fetchMarkdown(url);
    } catch (e) {
      throw SearchException(
        'Unexpected error while fetching webpage from $runtimeType: $e.',
        provider: this,
      );
    }
  }

  /// Internal fetchWebpage method.
  Future<String> _fetchWebpage(String url);

  Map<String, String> get _info => _infoMap[this]!;

  @override
  String get name => _info['name']!;

  @override
  String get logoPath => _info['logo']!;

  @override
  String get darkLogoPath => _info['logo']!;

  @override
  String get docsUrl => _info['docs']!;

  @override
  String get consoleUrl => _info['console']!;

  @override
  String? get description => _info['description'];
}

// -----------------------------------------------------------------------------
// Exceptions
// -----------------------------------------------------------------------------

class SearchException implements Exception {
  const SearchException(this.message, {required this.provider});

  final String message;
  final SearchProvider provider;

  @override
  String toString() => '${provider.runtimeType} error: $message.';
}

// -----------------------------------------------------------------------------
// Search Settings
// -----------------------------------------------------------------------------

abstract final class SearchProviderPreference {
  static String get _preferenceKey => 'search_provider';

  static SearchProvider? _parseProvider(String? string) => string?.let(
    (s) => kAllSearchProviders.firstWhere((provider) => provider.name == s),
  );

  /// Returns the provider that has been chosen by the user and that has been
  /// set up. If no provider satisfies these 2 conditions, returns `null`.
  static SearchProvider? getValidProvider() {
    final provider = Database().stringRef
        .get(_preferenceKey)
        .let(_parseProvider);
    if (provider?.hasSetUp() ?? false) return provider;
    return provider;
  }

  /// Returns a stream that prioritizes the provider that has been chosen by user
  /// user and that has been set up. If no such provider satisfies both conditions,
  /// it tries to yield a valid provider (Exa then Brave). If no valid provider is
  /// found, it yields `null`.
  static Stream<SearchProvider?> streamValidProviderWithFallback() {
    final stream1 = Database().stringRef
        .watch(key: _preferenceKey)
        .map((e) => e.value as String?)
        .map(_parseProvider)
        .startsWith(getValidProvider());
    final braveStream = Brave().isSetUp().map((e) => e ? Brave() : null);
    final exaStream = Exa().isSetUp().map((e) => e ? Exa() : null);
    return CombineAnyLatestStream.combine3(stream1, braveStream, exaStream, (
      chosenByUser,
      brave,
      exa,
    ) {
      if (chosenByUser != null && chosenByUser.hasSetUp()) {
        return chosenByUser;
      }
      return exa ?? brave;
    });
  }

  /// Returns the provider that has been chosen by the user and that has been
  /// set up. If no provider satisfies these 2 conditions, tries to return a
  /// valid provider (Exa then Brave). If no valid provider is found, returns
  /// `null`.
  static SearchProvider? getValidProviderWithFallback() {
    final setProvider = getValidProvider();
    if (setProvider != null && setProvider.hasSetUp()) return setProvider;
    if (Exa().hasSetUp()) return Exa();
    if (Brave().hasSetUp()) return Brave();
    return null;
  }

  /// Sets a provider as chosen by the user. This does not guarantee that the
  /// provider has been set up (an API key may be missing).
  static void setProvider(SearchProvider provider) {
    Database().stringRef.put(_preferenceKey, provider.name);
  }
}

final _infoMap = {
  Exa(): {
    'name': 'Exa Search',
    'logo': 'assets/images/exa.jpeg',
    'docs': 'https://docs.exa.ai',
    'console': 'https://dashboard.exa.ai/api-keys',
    'description': 'Exa supports web search and fetching webpages.',
  },
  Brave(): {
    'name': 'Brave Search',
    'logo': 'assets/images/brave.svg',
    'docs': 'https://api.search.brave.com/app/docs/',
    'console': 'https://api.search.brave.com/app/keys',
    'description':
        'Brave does not support fetching webpages. Additionally, your account must be subscribed to a "Data for AI" plan.',
  },
};
