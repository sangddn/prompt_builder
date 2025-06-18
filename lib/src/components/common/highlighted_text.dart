import 'dart:math' show min;

import 'package:flutter/material.dart';

import '../../core/core.dart';

/// A widget that highlights specified terms within a text string.
///
/// This widget is a modified version of the DynamicTextHighlighting package
/// (https://pub.dev/packages/dynamic_text_highlighting).
///
/// The widget wraps matched terms with a highlighted background color while
/// maintaining the original text styling. It supports both case-sensitive and
/// case-insensitive matching.
///
/// Example usage:
/// ```dart
/// HighlightedText(
///   text: 'Hello World',
///   highlights: ['hello'],
///   color: Colors.yellow,
///   caseSensitive: false,
/// )
/// ```
class HighlightedText extends StatelessWidget {
  const HighlightedText({
    required this.text,
    required this.highlights,
    this.leadingSpans = const [],
    this.trailingSpans = const [],
    this.color,
    this.style,
    this.caseSensitive = true,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaler,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textHeightBehavior,
    super.key,
  });

  /// The text to be displayed and searched for highlights
  final String text;

  /// List of terms to highlight within the text
  final List<String> highlights;

  /// Background color used for highlighted terms
  final Color? color;

  /// Base text style applied to the entire text
  final TextStyle? style;

  /// Whether the highlight matching should be case-sensitive
  final bool caseSensitive;

  /// Optional spans to insert before the main text
  final List<InlineSpan> leadingSpans;

  /// Optional spans to insert after the main text
  final List<InlineSpan> trailingSpans;

  final TextAlign textAlign;
  final TextDirection? textDirection;
  final bool softWrap;
  final TextOverflow overflow;
  final TextScaler? textScaler;
  final int? maxLines;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;

  @override
  Widget build(BuildContext context) {
    final style = this.style ?? DefaultTextStyle.of(context).style;
    final spans = <InlineSpan>[...leadingSpans];

    if (text.isEmpty) {
      spans.add(_normalSpan(text, style));
    } else if (highlights.isEmpty) {
      spans.add(_normalSpan(text, style));
    } else {
      int start = 0;

      //For "No Case Sensitive" option
      final String lowerCaseText = text.toLowerCase();
      final List<String> lowerCaseHighlights = [];

      for (final element in highlights) {
        lowerCaseHighlights.add(element.toLowerCase());
      }

      while (true) {
        final highlightsMap = <int, String>{};
        if (caseSensitive) {
          for (int i = 0; i < highlights.length; i++) {
            assert(highlights[i].isNotEmpty);
            final int index = text.indexOf(highlights[i], start);
            if (index >= 0) {
              highlightsMap.putIfAbsent(index, () => highlights[i]);
            }
          }
        } else {
          for (int i = 0; i < highlights.length; i++) {
            final int index = lowerCaseText.indexOf(
              lowerCaseHighlights[i],
              start,
            );
            if (index >= 0) {
              highlightsMap.putIfAbsent(index, () => highlights[i]);
            }
          }
        }
        if (highlightsMap.isNotEmpty) {
          final List<int> indexes = [];
          highlightsMap.forEach((key, value) => indexes.add(key));

          final int currentIndex = indexes.reduce(min);
          final String currentHighlight = text.substring(
            currentIndex,
            currentIndex + (highlightsMap[currentIndex]?.length ?? 0),
          );

          if (currentIndex == start) {
            spans.add(_highlightSpan(context, currentHighlight, style));
            start += currentHighlight.length;
          } else {
            spans.add(_normalSpan(text.substring(start, currentIndex), style));
            spans.add(_highlightSpan(context, currentHighlight, style));
            start = currentIndex + currentHighlight.length;
          }
        } else {
          spans.add(_normalSpan(text.substring(start, text.length), style));
          break;
        }
      }
    }

    spans.addAll(trailingSpans);

    return _richText(context, TextSpan(children: spans));
  }

  /// Creates a TextSpan for highlighted text portions
  TextSpan _highlightSpan(BuildContext context, String value, TextStyle style) {
    return TextSpan(
      text: value,
      style: style.copyWith(
        backgroundColor: context.theme.colorScheme.selection,
      ),
    );
  }

  /// Creates a TextSpan for non-highlighted text portions
  TextSpan _normalSpan(String value, TextStyle style) {
    if (style.color == null) {
      return TextSpan(text: value, style: style.copyWith(color: Colors.black));
    } else {
      return TextSpan(text: value, style: style);
    }
  }

  /// Wraps the final TextSpan in a RichText widget with all configured properties
  RichText _richText(BuildContext context, TextSpan text) {
    return RichText(
      key: key,
      text: text,
      textAlign: textAlign,
      textDirection: textDirection,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler ?? MediaQuery.textScalerOf(context),
      maxLines: maxLines,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis ?? TextWidthBasis.parent,
      textHeightBehavior: textHeightBehavior,
    );
  }
}
