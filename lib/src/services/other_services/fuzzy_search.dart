import 'package:flutter/foundation.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart' as fuzzy;

List<String> _fuzzySearch((List<String>, String, int) args) {
  final (strings, query, threshold) = args;
  final effectiveQuery = query.toLowerCase();
  return (List.of(strings, growable: false)
          .map(
            (s) => (
              s,
              fuzzy.tokenSortPartialRatio(s.toLowerCase(), effectiveQuery),
            ),
          )
          .where((s) => s.$2 >= threshold)
          .toList()
        ..sort((a, b) {
          final scoreA = a.$2;
          final scoreB = b.$2;
          return scoreB.compareTo(scoreA); // Sort in descending order
        }))
      .map((s) => s.$1)
      .toList();
}

List<String> fuzzySearch(
  List<String> strings,
  String query, [
  int threshold = 0,
]) => _fuzzySearch((strings, query, threshold));

Future<List<String>> fuzzySearchAsync(
  List<String> strings,
  String query, [
  int threshold = 0,
]) => compute(_fuzzySearch, (strings, query, threshold));
