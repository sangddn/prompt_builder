import 'package:flutter/material.dart';

extension StringUtils on String {
  String splitCamelCase() {
    return replaceAllMapped(
      RegExp(r'([A-Z])'),
      (Match match) => ' ${match.group(0)}',
    ).trim();
  }

  String capitalize() {
    if (isEmpty) {
      return this;
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String capitalizeEachWord() {
    return split(' ').map((e) => e.capitalize()).join(' ');
  }

  String onlyLetters({bool withSpaces = true, bool withCommonSymbols = true}) {
    final commonSymbols =
        withCommonSymbols ? r'!@#%^&*()_+-=[]{}|;:,.<>?/' : '';
    final space = withSpaces ? r'\s' : '';
    return replaceAll(RegExp('[^a-zA-Z$commonSymbols$space]'), '');
  }

  String onlyDigits({bool withSpaces = true, bool withCommonSymbols = true}) {
    final commonSymbols =
        withCommonSymbols ? r'!@#%^&*()_+-=[]{}|;:,.<>?/' : '';
    final space = withSpaces ? r'\s' : '';
    return replaceAll(RegExp('[^0-9$commonSymbols$space]'), '');
  }

  String onlyAlphaNumeric({
    bool withSpaces = true,
    bool withCommonSymbols = true,
  }) {
    final commonSymbols =
        withCommonSymbols ? r'!@#%^&*()_+-=[]{}|;:,.<>?/' : '';
    final space = withSpaces ? r'\s' : '';
    return replaceAll(RegExp('[^a-zA-Z0-9$commonSymbols$space]'), '');
  }

  int get characterCount => characters.length;

  bool get hasOnlyDigits =>
      onlyDigits(withSpaces: false, withCommonSymbols: false) == this;
  bool get hasOnlyLetters =>
      onlyLetters(withSpaces: false, withCommonSymbols: false) == this;
  bool get hasOnlyAlphaNumeric =>
      onlyAlphaNumeric(withSpaces: false, withCommonSymbols: false) == this;
}
