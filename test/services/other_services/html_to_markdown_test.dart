import 'package:flutter_test/flutter_test.dart';
import 'package:prompt_builder/src/services/other_services/html_to_markdown.dart';

void main() {
  group('htmlToMarkdown', () {
    test('converts headings correctly', () {
      const html = '''
      <h1>Heading One</h1>
      <h2>Heading Two</h2>
      ''';
      final md = htmlToMarkdown(html).trim();

      expect(md, contains('# Heading One'));
      expect(md, contains('## Heading Two'));
    });

    test('converts paragraphs correctly', () {
      const html = '<p>Hello World</p>';
      final md = htmlToMarkdown(html).trim();

      expect(md, contains('Hello World'));
      // Expect a newline around paragraphs
      expect(md, startsWith('Hello World'));
    });

    test('converts bold and italics', () {
      const html =
          '<b>Bold</b> <strong>Also Bold</strong> <i>Italic</i> <em>Emph</em>';
      final md = htmlToMarkdown(html);

      expect(md, contains('**Bold**'));
      expect(md, contains('**Also Bold**'));
      expect(md, contains('_Italic_'));
      expect(md, contains('_Emph_'));
    });

    test('converts links', () {
      const html = '<a href="https://example.com">Example Link</a>';
      final md = htmlToMarkdown(html);

      expect(md, contains('[Example Link](https://example.com)'));
    });

    test('converts images', () {
      const html = '<img src="image.png" alt="desc" />';
      final md = htmlToMarkdown(html);

      expect(md, contains('![desc](image.png)'));
    });

    test('converts lists', () {
      const html = '''
        <ul>
          <li>Item 1</li>
          <li>Item 2</li>
        </ul>
      ''';
      final md = htmlToMarkdown(html);

      expect(md, contains('- Item 1'));
      expect(md, contains('- Item 2'));
    });

    test('converts code blocks', () {
      const html = '''
      <pre>
      void main() {
        print("Hello");
      }
      </pre>
      ''';
      final md = htmlToMarkdown(html);

      expect(md, contains('```\nvoid main()'));
      expect(md, contains('print("Hello");'));
      expect(md, contains('```\n'));
    });

    test('converts inline code', () {
      const html = '<p>Some code: <code>int x = 0;</code></p>';
      final md = htmlToMarkdown(html);

      expect(md, contains('`int x = 0;`'));
    });

    test('converts blockquote', () {
      const html = '<blockquote><p>Quote me</p></blockquote>';
      final md = htmlToMarkdown(html);

      expect(md, contains('> Quote me'));
    });

    test('handles multiple newlines gracefully', () {
      const html = '''
      <h1>Title</h1>
      <p>Some text</p>
      <p>More text</p>
      ''';
      final md = htmlToMarkdown(html);

      // Shouldn't have large gaps
      expect(md.contains('\n\n\n'), isFalse);
    });
  });
}
