import 'package:html/dom.dart';
import 'package:html/parser.dart';

/// Converts an HTML string [htmlContent] into a Markdown string.
///
/// This converter handles a variety of common HTML structures, including:
/// - Headings <h1>-<h6>
/// - Paragraphs <p>
/// - Bold <b>, <strong>, italics <i>, <em>
/// - Links <a>
/// - Images <img>
/// - Lists <ul>, <ol>
/// - List items <li>
/// - Code blocks <pre>, inline code <code>
/// - Line breaks <br>
/// - Horizontal rules <hr>
/// - Blockquotes <blockquote>
String htmlToMarkdown(String htmlContent) {
  final doc = parse(htmlContent);
  final markdownBuffer = StringBuffer();

  // We only care about what's in <body>. If missing, parse the entire doc.
  final body = doc.body ?? doc.documentElement;

  if (body == null) {
    return '';
  }

  _convertNode(body, markdownBuffer, 0);

  // Cleanup multiple newlines and spaces:
  final markdown = markdownBuffer
      .toString()
      .replaceAll(RegExp(r'\n{3,}'), '\n\n') // Collapse 3+ newlines into two
      .trim();

  return markdown;
}

/// Recursively traverses the DOM tree, writing Markdown text
/// to [markdownBuffer].
///
/// [depth] is used for list item indentation and heading levels if needed.
void _convertNode(Node node, StringBuffer markdownBuffer, int depth) {
  if (node is Text) {
    // Make sure to trim leading/trailing spaces
    final text = node.text.replaceAll('\n', ' ').trim();
    if (text.isNotEmpty) {
      markdownBuffer.write(text);
    }
    return;
  }

  if (node is Element) {
    switch (node.localName) {
      case 'h1':
      case 'h2':
      case 'h3':
      case 'h4':
      case 'h5':
      case 'h6':
        _convertHeading(node, markdownBuffer);
      case 'p':
        _convertParagraph(node, markdownBuffer);
      case 'strong':
      case 'b':
        _convertBold(node, markdownBuffer, depth);
      case 'em':
      case 'i':
        _convertItalics(node, markdownBuffer, depth);
      case 'a':
        _convertLink(node, markdownBuffer, depth);
      case 'img':
        _convertImage(node, markdownBuffer);
      case 'ul':
      case 'ol':
        _convertList(node, markdownBuffer, depth);
      case 'li':
        _convertListItem(node, markdownBuffer, depth);
      case 'pre':
        _convertPreformatted(node, markdownBuffer);
      case 'code':
        _convertCode(node, markdownBuffer);
      case 'blockquote':
        _convertBlockquote(node, markdownBuffer, depth);
      case 'br':
        markdownBuffer.writeln();
      case 'hr':
        markdownBuffer.writeln('\n---\n');
      default:
        // Recursively process child nodes for any unhandled tags
        for (final child in node.nodes) {
          _convertNode(child, markdownBuffer, depth);
        }
    }

    // If a node naturally requires a newline after it, handle that here
    if ([
      'h1', 'h2', 'h3', 'h4', 'h5', 'h6', //
      'p', 'ul', 'ol', 'blockquote', 'pre', //
    ].contains(node.localName)) {
      markdownBuffer.writeln();
    }
  }
}

/// Handle headings like <h1>, <h2>, etc.
void _convertHeading(Element node, StringBuffer buffer) {
  final level = int.parse(node.localName!.substring(1)); // h1 -> 1
  final headingPrefix = '#' * level; // "##" for <h2>, etc.
  buffer.write('\n$headingPrefix ');
  for (final child in node.nodes) {
    _convertNode(child, buffer, 0);
  }
  buffer.writeln();
}

/// Handle paragraphs <p>
void _convertParagraph(Element node, StringBuffer buffer) {
  buffer.write('\n');
  for (final child in node.nodes) {
    _convertNode(child, buffer, 0);
  }
  buffer.write('\n');
}

/// Handle bold text <strong>, <b>
void _convertBold(Element node, StringBuffer buffer, int depth) {
  buffer.write('**');
  for (final child in node.nodes) {
    _convertNode(child, buffer, depth);
  }
  buffer.write('**');
}

/// Handle italics <em>, <i>
void _convertItalics(Element node, StringBuffer buffer, int depth) {
  buffer.write('_');
  for (final child in node.nodes) {
    _convertNode(child, buffer, depth);
  }
  buffer.write('_');
}

/// Handle links <a>
void _convertLink(Element node, StringBuffer buffer, int depth) {
  final href = node.attributes['href'] ?? '';
  buffer.write('[');
  for (final child in node.nodes) {
    _convertNode(child, buffer, depth);
  }
  buffer.write(']($href)');
}

/// Handle images <img>
void _convertImage(Element node, StringBuffer buffer) {
  final src = node.attributes['src'] ?? '';
  final alt = node.attributes['alt'] ?? '';
  buffer.write('![$alt]($src)');
}

/// Handle unordered/ordered lists <ul>, <ol>
void _convertList(Element node, StringBuffer buffer, int depth) {
  for (final child in node.nodes) {
    _convertNode(child, buffer, depth + 1);
  }
}

/// Handle list items <li>
void _convertListItem(Element node, StringBuffer buffer, int depth) {
  // For an ordered list, you'd track whether the parent is <ol> and use "1." instead
  // For simplicity, we’ll do bullet points for both (commonly you'd differentiate)
  buffer.write('\n${'  ' * (depth * 2)}- ');
  for (final child in node.nodes) {
    _convertNode(child, buffer, depth);
  }
}

/// Handle preformatted blocks <pre>
void _convertPreformatted(Element node, StringBuffer buffer) {
  buffer.write('\n```\n');
  // Convert text content inside <pre> verbatim
  final textContent = node.text;
  buffer.write(textContent.trim());
  buffer.write('\n```\n');
}

/// Handle inline code <code>
void _convertCode(Element node, StringBuffer buffer) {
  buffer.write('`');
  buffer.write(node.text.trim());
  buffer.write('`');
}

/// Handle blockquotes <blockquote>
void _convertBlockquote(Element node, StringBuffer buffer, int depth) {
  // Indent each line with >
  buffer.write('\n');
  final childBuffer = StringBuffer();
  for (final child in node.nodes) {
    _convertNode(child, childBuffer, depth);
  }

  final lines = childBuffer.toString().split('\n');
  for (var line in lines) {
    line = line.trim();
    if (line.isNotEmpty) {
      buffer.write('> $line\n');
    }
  }
  buffer.write('\n');
}
