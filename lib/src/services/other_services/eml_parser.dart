import 'dart:convert';

import 'package:flutter/foundation.dart' show Uint8List, compute, immutable;
import 'package:html/parser.dart';
import 'package:shadcn_ui/shadcn_ui.dart' show DateFormat;

import '../../core/core.dart';
import 'html_to_markdown.dart';

/// Converts the contents of an `.eml` file to a best-effort plain text.
/// - Prefers the `.text` part if present.
/// - If missing, extracts text from the `.html` part.
/// - Otherwise returns an empty string.
Future<(String title, String text)> convertEmlToPlainText(
  String emlContents,
) async {
  final parsed = await parseEmlAsync(emlContents);

  // If a plaintext body is available, return that.
  if (parsed.textBody.isNotEmpty) {
    return (parsed.title, parsed.textBody.trim());
  }

  // If there's no text part but HTML is available, parse HTML and extract just the text
  if (parsed.htmlBody.isNotEmpty) {
    final doc = parse(parsed.htmlBody);
    return (parsed.title, doc.body?.text.trim() ?? '');
  }

  // Otherwise, no textual content.
  return (parsed.title, '');
}

/// Converts the contents of an `.eml` file to a best-effort Markdown representation.
/// - If `.html` is present, convert that to Markdown.
/// - Else if `.text` is present, just return the plain text (or add simple Markdown formatting).
/// - Otherwise returns empty string.
Future<(String title, String text)> convertEmlToMarkdown(
  String emlContents,
) async {
  final parsed = await parseEmlAsync(emlContents);

  // If there's an HTML part, convert to Markdown
  if (parsed.htmlBody.isNotEmpty) {
    return (parsed.title, htmlToMarkdown(parsed.htmlBody));
  }

  // Otherwise, fallback to text if available
  if (parsed.textBody.isNotEmpty) {
    return (parsed.title, parsed.textBody.trim());
  }

  // No content
  return (parsed.title, '');
}

/// Represents the result of parsing an EML file.
@immutable
class EmlMessage {
  const EmlMessage({
    required this.headers,
    required this.subject,
    required this.from,
    required this.to,
    required this.cc,
    required this.date,
    required this.textBody,
    required this.htmlBody,
    required this.attachments,
  });

  /// All raw headers, stored in a map (headerName -> List of values).
  final Map<String, List<String>> headers;

  /// The main subject of the email (decoded if applicable).
  final String subject;

  /// The email’s “From” line, as a single string or multiple addresses.
  final List<EmlAddress> from;

  /// The email’s “To” recipients, possibly multiple addresses.
  final List<EmlAddress> to;

  /// The email’s “CC” recipients, possibly multiple addresses.
  final List<EmlAddress> cc;

  /// The email’s date/time if parsed successfully, otherwise null.
  final DateTime? date;

  /// The plain text body, if present. May be empty if not found.
  final String textBody;

  /// The HTML body, if present. May be empty if not found.
  final String htmlBody;

  /// Zero or more attachments included in the email.
  final List<EmlAttachment> attachments;

  String get title =>
      '${from.firstOrNull?.name.let((n) => 'From $n: ') ?? ''}$subject';

  @override
  String toString() {
    return '''
EmlMessage(
  subject: "$subject",
  from: $from,
  to: $to,
  cc: $cc,
  date: $date,
  textBody: ${textBody.isNotEmpty},
  htmlBody: ${htmlBody.isNotEmpty},
  attachments: $attachments,
  headers: $headers
)
''';
  }
}

/// Basic representation of an email address.
class EmlAddress {
  EmlAddress({required this.name, required this.email});
  final String name;
  final String email;

  @override
  String toString() => name.isEmpty ? email : '$name <$email>';
}

/// Represents an email attachment.
@immutable
class EmlAttachment {
  const EmlAttachment({
    required this.id,
    required this.fileName,
    required this.contentType,
    required this.inline,
    required this.data,
    this.dataBase64,
  });

  /// Usually set from the Content-ID or name or a fallback.
  final String id;

  /// The file name, if known.
  final String fileName;

  /// The MIME type, e.g. "image/png", "text/plain", etc.
  final String contentType;

  /// Indicates if it’s an inline attachment vs standard.
  final bool inline;

  /// The raw bytes of the attachment.
  final Uint8List data;

  /// Base64-encoded data if needed.
  final String? dataBase64;

  @override
  String toString() {
    return 'EmlAttachment(id: $id, name: $fileName, type: $contentType, size: ${data.length})';
  }
}

/// Async version of [parseEml].
/// {@macro services.other_services.eml_parser}
Future<EmlMessage> parseEmlAsync(String rawEml) => compute(parseEml, rawEml);

/// {@template services.other_services.eml_parser}
/// Parses a raw EML string into [EmlMessage].
///
/// Throws [EmlParserException] if there's a critical parsing error.
/// On partial or malformed data, tries to keep going (best-effort).
/// {@endtemplate}
EmlMessage parseEml(String rawEml) {
  if (rawEml.trim().isEmpty) {
    throw const EmlParserException('EML content is empty.');
  }

  final lines = rawEml.split(RegExp(r'\r?\n'));

  // 1. Parse top-level headers
  final headerMap = _parseHeaders(lines);
  final contentType = _getHeaderFirst(headerMap, 'Content-Type');
  final lowercasedContentType = contentType?.toLowerCase() ?? '';
  final transferEnc =
      _getHeaderFirst(headerMap, 'Content-Transfer-Encoding')?.toLowerCase();
  final date = _parseDate(_getHeaderFirst(headerMap, 'Date'));
  final subject = _decodeMimeSentence(
    _getHeaderFirst(headerMap, 'Subject') ?? '',
  );
  final from = _parseAddressHeader(headerMap, 'From');
  final to = _parseAddressHeader(headerMap, 'To');
  final cc = _parseAddressHeader(headerMap, 'Cc');

  // 2. Identify the start of the body (first blank line after headers)
  final bodyStartIndex = _findBodyStart(lines);
  final bodyLines =
      bodyStartIndex == -1 ? <String>[] : lines.sublist(bodyStartIndex);

  // 3. If multipart, parse subparts; otherwise parse as single-part
  final textBuffer = StringBuffer();
  final htmlBuffer = StringBuffer();
  final attachments = <EmlAttachment>[];

  final boundary = contentType?.let(_getBoundary) ?? '';

  if (lowercasedContentType.startsWith('multipart/') && boundary.isNotEmpty) {
    _parseMultipartBody(
      bodyLines,
      boundary,
      textBuffer,
      htmlBuffer,
      attachments,
    );
  } else {
    // Single-part message
    final singlePartContent = _decodeBodyLines(
      bodyLines,
      contentType,
      transferEnc,
    );
    _maybeAssignSinglePart(
      lowercasedContentType,
      singlePartContent,
      textBuffer,
      htmlBuffer,
    );
  }

  return EmlMessage(
    headers: headerMap,
    subject: subject,
    from: from,
    to: to,
    cc: cc,
    date: date,
    textBody: textBuffer.toString(),
    htmlBody: htmlBuffer.toString(),
    attachments: attachments,
  );
}

// ---------------------------------------------------------------------------
// HEADERS
// ---------------------------------------------------------------------------

Map<String, List<String>> _parseHeaders(List<String> lines) {
  final result = <String, List<String>>{};
  final headerRegex = RegExp(r'^([\w-]+):\s*(.*)$', caseSensitive: false);

  var lastHeaderName = '';
  for (int i = 0; i < lines.length; i++) {
    final line = lines[i];

    if (line.isEmpty) {
      // blank line => end of headers
      break;
    }
    // Is it a new header or a continuation?
    final match = headerRegex.firstMatch(line);
    if (match != null) {
      // New header
      lastHeaderName = match.group(1) ?? '';
      final value = match.group(2) ?? '';
      result.putIfAbsent(lastHeaderName, () => []).add(value);
    } else {
      // Probably a folded line => continuation of last header
      if (lastHeaderName.isNotEmpty) {
        final currentList = result[lastHeaderName]!;
        final updatedValue = '${currentList.last} ${line.trim()}';
        currentList[currentList.length - 1] = updatedValue;
      }
    }
  }
  return result;
}

String? _getHeaderFirst(Map<String, List<String>> headers, String name) {
  // Case-insensitive
  final key = headers.keys.firstWhere(
    (k) => k.toLowerCase() == name.toLowerCase(),
    orElse: () => '',
  );
  if (key.isEmpty) return null;
  return (headers[key]?.isNotEmpty ?? false)
      ? headers[key]!.first.trim()
      : null;
}

int _findBodyStart(List<String> lines) {
  for (int i = 0; i < lines.length; i++) {
    if (lines[i].isEmpty) {
      return i + 1;
    }
  }
  return -1; // no blank line => no body
}

// ---------------------------------------------------------------------------
// DATE
// ---------------------------------------------------------------------------

DateTime? _parseDate(String? raw) {
  if (raw == null || raw.isEmpty) return null;

  try {
    // Try native parse first
    final parsed = DateTime.tryParse(raw);
    if (parsed != null) return parsed;

    // Otherwise try a known RFC2822 pattern
    final rfc2822 = DateFormat('EEE, dd MMM yyyy HH:mm:ss Z', 'en_US');
    return rfc2822.parse(raw);
  } catch (_) {
    return null;
  }
}

// ---------------------------------------------------------------------------
// ADDRESS HEADERS
// ---------------------------------------------------------------------------

List<EmlAddress> _parseAddressHeader(
  Map<String, List<String>> headerMap,
  String headerName,
) {
  final rawValues =
      headerMap.entries
          .where((e) => e.key.toLowerCase() == headerName.toLowerCase())
          .expand((e) => e.value)
          .toList();
  if (rawValues.isEmpty) return [];

  // Join them if multiple lines
  final combined = rawValues.join(', ');
  final addresses = <EmlAddress>[];

  for (final part in combined.split(',')) {
    final trimmed = part.trim();
    if (trimmed.isEmpty) continue;

    // Attempt "Name <email>"
    final match = RegExp(r'^(.*)?<(.*)>$').firstMatch(trimmed);
    if (match != null) {
      final name = match.group(1)?.trim().replaceAll('"', '') ?? '';
      final email = match.group(2)?.trim() ?? '';
      addresses.add(EmlAddress(name: name, email: email));
    } else {
      // Just an email
      addresses.add(EmlAddress(name: '', email: trimmed));
    }
  }
  return addresses;
}

// ---------------------------------------------------------------------------
// MULTIPART HANDLING
// ---------------------------------------------------------------------------

/// Called if we’re single-part but we do a best guess: plain or HTML?
void _maybeAssignSinglePart(
  String? contentType,
  String content,
  StringBuffer textBuffer,
  StringBuffer htmlBuffer,
) {
  if ((contentType ?? '').contains('text/html')) {
    htmlBuffer.write(content);
  } else {
    textBuffer.write(content);
  }
}

/// Parse a multipart body, recursing for nested multiparts, collecting
/// text/plain, text/html, and attachments.
void _parseMultipartBody(
  List<String> lines,
  String boundary,
  StringBuffer textBuffer,
  StringBuffer htmlBuffer,
  List<EmlAttachment> attachments,
) {
  final parts = <_MultipartPart>[];
  var currentPart = <String>[];
  var inPart = false;

  for (final line in lines) {
    // e.g. --_----------=_MCPart_20394923
    if (line.startsWith('--$boundary')) {
      // If we were capturing lines of a part, finalize that part
      if (inPart) {
        if (currentPart.isNotEmpty) {
          parts.add(_MultipartPart(lines: currentPart));
          currentPart = <String>[];
        }
        inPart = false;
        continue;
      }
      inPart = true;
    }

    if (inPart) {
      currentPart.add(line);
    }
  }

  // If there are leftover lines
  if (inPart && currentPart.isNotEmpty) {
    parts.add(_MultipartPart(lines: currentPart));
  }

  // Now parse each part
  for (final part in parts) {
    _processMultipartPart(part, textBuffer, htmlBuffer, attachments);
  }
}

class _MultipartPart {
  _MultipartPart({required this.lines});
  final List<String> lines;
}

/// Parse a single part inside a multipart boundary
void _processMultipartPart(
  _MultipartPart part,
  StringBuffer textBuffer,
  StringBuffer htmlBuffer,
  List<EmlAttachment> attachments,
) {
  final headers = _parseHeaders(part.lines);
  final bodyStartIndex = _findBodyStart(part.lines);
  final bodyLines =
      bodyStartIndex == -1 ? <String>[] : part.lines.sublist(bodyStartIndex);

  final contentType = _getHeaderFirst(headers, 'Content-Type') ?? '';
  final lowercasedContentType = contentType.toLowerCase();
  final transferEnc =
      _getHeaderFirst(headers, 'Content-Transfer-Encoding')?.toLowerCase() ??
      '';
  final disposition =
      _getHeaderFirst(headers, 'Content-Disposition')?.toLowerCase() ?? '';

  // If sub-multipart, parse recursively
  if (lowercasedContentType.startsWith('multipart/')) {
    final boundary = _getBoundary(contentType);
    if (boundary != null && boundary.isNotEmpty) {
      _parseMultipartBody(
        bodyLines,
        boundary,
        textBuffer,
        htmlBuffer,
        attachments,
      );
      return;
    }
  }

  // Else decode the single part
  final decodedContent = _decodeBodyLines(bodyLines, contentType, transferEnc);

  // text/plain, text/html, or an attachment
  if (lowercasedContentType.contains('text/plain')) {
    textBuffer.write(decodedContent);
  } else if (lowercasedContentType.contains('text/html')) {
    htmlBuffer.write(decodedContent);
  } else {
    // Probably an attachment
    final contentId = _getHeaderFirst(headers, 'Content-ID') ?? '';
    final fileName = _extractFileNameFromHeaders(headers);

    final bytes = Uint8List.fromList(decodedContent.codeUnits);
    attachments.add(
      EmlAttachment(
        id:
            contentId.isNotEmpty
                ? contentId
                : (fileName.isNotEmpty ? fileName : 'attachment'),
        fileName: fileName.isNotEmpty ? fileName : 'unknown.dat',
        contentType: lowercasedContentType,
        inline: disposition.contains('inline'),
        data: bytes,
        dataBase64: base64.encode(bytes),
      ),
    );
  }
}

String _extractFileNameFromHeaders(Map<String, List<String>> headers) {
  // e.g. Content-Disposition: attachment; filename="xxx.pdf"
  // or Content-Type: name="xxx.pdf"
  final disp = _getHeaderFirst(headers, 'Content-Disposition') ?? '';
  final ctype = _getHeaderFirst(headers, 'Content-Type') ?? '';

  final nameRegex = RegExp(r'filename\*?="?([^";]+)"?', caseSensitive: false);
  final cdMatch = nameRegex.firstMatch(disp);
  if (cdMatch != null) {
    return cdMatch.group(1)?.trim() ?? '';
  }

  final ctMatch = RegExp(
    r'name\*?="?([^";]+)"?',
    caseSensitive: false,
  ).firstMatch(ctype);
  if (ctMatch != null) {
    return ctMatch.group(1)?.trim() ?? '';
  }
  return '';
}

String? _getBoundary(String contentType) {
  // multipart/alternative; boundary="_----------=_MCPart_20394923"
  final match = RegExp(
    r'boundary\s*=\s*("?)([^";]+)\1',
    caseSensitive: false,
  ).firstMatch(contentType);
  return match?.group(2);
}

// ---------------------------------------------------------------------------
// DECODING
// ---------------------------------------------------------------------------

String _decodeBodyLines(
  List<String> lines,
  String? contentType,
  String? transferEnc,
) {
  // Combine lines
  final joined = lines.join('\n');

  if (transferEnc == 'base64') {
    try {
      final bytes = base64.decode(
        joined.replaceAll('\r', '').replaceAll('\n', ''),
      );
      // If text, decode to string
      if ((contentType ?? '').toLowerCase().contains('text/')) {
        return utf8.decode(bytes, allowMalformed: true);
      }
      // otherwise treat as binary
      return String.fromCharCodes(bytes);
    } catch (_) {
      // fallback to raw if base64 decode fails
      return joined;
    }
  } else if (transferEnc == 'quoted-printable') {
    return _decodeQuotedPrintable(joined);
  } else {
    // 7bit, 8bit, or none => return as-is
    return joined;
  }
}

/// Minimal quoted-printable decode logic
String _decodeQuotedPrintable(String input) {
  // Remove soft line breaks: `=\r\n` => nothing
  var text = input.replaceAll(RegExp(r'=\r?\n'), '');

  // Convert =XX hex codes
  final qpRegex = RegExp(r'=[0-9A-Fa-f]{2}');
  text = text.replaceAllMapped(qpRegex, (m) {
    final hex = m.group(0)!.substring(1);
    final val = int.parse(hex, radix: 16);
    return String.fromCharCode(val);
  });
  return text;
}

// ---------------------------------------------------------------------------
// MIME-ENCODED WORDS (Subjects, etc.)
// ---------------------------------------------------------------------------

final _encodedWordPattern = RegExp(
  r'=\?([^?]+)\?([bqBQ])\?([^?]+)\?=',
  caseSensitive: false,
);

String _decodeMimeSentence(String raw) {
  if (raw.isEmpty) return '';

  var decoded = raw;
  for (final match in _encodedWordPattern.allMatches(raw)) {
    final full = match.group(0)!;
    final charset = (match.group(1) ?? 'utf-8').toLowerCase();
    final encoding = (match.group(2) ?? 'B').toUpperCase();
    final encodedText = match.group(3) ?? '';

    String decodedSegment;
    if (encoding == 'B') {
      // Base64
      try {
        final bytes = base64.decode(encodedText);
        decodedSegment = _decodeBytes(bytes, charset) ?? utf8.decode(bytes);
      } catch (_) {
        decodedSegment = encodedText;
      }
    } else {
      // Quoted-Printable form of MIME-encoding
      decodedSegment = _decodeQEncoding(encodedText, charset) ?? encodedText;
    }

    decoded = decoded.replaceFirst(full, decodedSegment);
  }
  return decoded.trim();
}

String? _decodeBytes(List<int> bytes, String charset) {
  // For simplicity, only do UTF-8 fallback here
  if (charset.contains('utf-8')) {
    return utf8.decode(bytes, allowMalformed: true);
  }
  // If you need more charsets, consider a library like `charset_converter`.
  return null;
}

String? _decodeQEncoding(String text, String charset) {
  final replaced = text.replaceAll('_', ' ').replaceAllMapped(
    RegExp(r'=[0-9A-Fa-f]{2}'),
    (m) {
      final hex = m.group(0)!.substring(1);
      final val = int.parse(hex, radix: 16);
      return String.fromCharCode(val);
    },
  );
  return _decodeBytes(utf8.encode(replaced), charset);
}

// -----------------------------------------------------------------------------
// Exceptions
// -----------------------------------------------------------------------------

/// Custom exception for EML parsing
class EmlParserException implements Exception {
  const EmlParserException(this.message);
  final String message;
  @override
  String toString() => 'EmlParserException: $message';
}
