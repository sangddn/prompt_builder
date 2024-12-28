import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/tomorrow-night.dart';
import 'package:flutter_highlight/themes/tomorrow.dart';
import 'package:flutter_markdown/flutter_markdown.dart' as fm;
import 'package:highlight/highlight.dart';

import '../../core/core.dart';
import '../../services/services.dart';

part 'syntax_highlighter.dart';

class Markdown extends StatelessWidget {
  const Markdown({
    required this.data,
    super.key,
  });

  final String data;

  @override
  Widget build(BuildContext context) {
    return fm.MarkdownBody(
      data: data,
      selectable: true,
      onTapLink: (text, url, title) {
        if (url != null) {
          launchUrlString(url);
        }
      },
      syntaxHighlighter: DefaultSyntaxHighlighter.fromContext(context),
    );
  }
}
