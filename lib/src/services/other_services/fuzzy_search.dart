import 'package:flutter/foundation.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart' as fuzzy;

List<String> _fuzzySearch((List<String>, String) args) {
  final (strings, query) = args;
  return strings
    ..sort((a, b) {
      final scoreA =
          fuzzy.tokenSortPartialRatio(a.toLowerCase(), query.toLowerCase());
      final scoreB =
          fuzzy.tokenSortPartialRatio(b.toLowerCase(), query.toLowerCase());
      return scoreB.compareTo(scoreA); // Sort in descending order
    });
}

List<String> fuzzySearch(List<String> strings, String query) =>
    _fuzzySearch((strings, query));

Future<List<String>> fuzzySearchAsync(List<String> strings, String query) =>
    compute(_fuzzySearch, (strings, query));
