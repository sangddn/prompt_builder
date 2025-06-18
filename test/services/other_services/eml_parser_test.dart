// test/eml_parser_test.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:prompt_builder/src/services/other_services/eml_parser.dart';

void main() {
  group('parseEml', () {
    test('parses minimal plain-text email', () async {
      const rawEml = '''
From: John Doe <john@example.com>
To: Jane <jane@example.org>
Subject: A simple email

Hello world, this is plain text.
''';

      final message = parseEml(rawEml);

      expect(message.subject, 'A simple email');
      expect(message.from.first.email, 'john@example.com');
      expect(message.to.first.email, 'jane@example.org');
      expect(message.textBody, contains('Hello world'));
      expect(message.htmlBody.isEmpty, isTrue);
      expect(message.attachments, isEmpty);
      expect(message.headers['Subject']!.first, 'A simple email');
    });

    test('parses email with HTML body', () async {
      const rawEml = '''
From: "Alice" <alice@example.com>
To: bob@example.org
Subject: HTML Test
Content-Type: text/html

<html><body><h1>Big Title</h1><p>Some HTML content.</p></body></html>
''';

      final message = parseEml(rawEml);
      expect(message.textBody.isEmpty, isTrue);
      expect(message.htmlBody, contains('Big Title'));
      expect(message.htmlBody, contains('Some HTML content.'));
    });

    test('parses MIME-encoded subject', () async {
      const rawEml = '''
From: "=?UTF-8?B?QWxpY2U=?=" <alice@example.com>
To: bob@example.org
Subject: =?utf-8?Q?Hello_=C2=A1_World!?=
Content-Type: text/plain

Just checking in
''';

      final message = parseEml(rawEml);
      // "Hello ¡ World!"
      expect(message.subject, contains('Hello ¡ World!'));
      expect(message.from.first.name, 'Alice');
    });

    test('parses multipart with plain text and HTML', () async {
      const rawEml = '''
From: test@example.com
To: you@example.com
Subject: Test
Content-Type: multipart/alternative; boundary="ABC123"

--ABC123
Content-Type: text/plain

Hello from plain text.

--ABC123
Content-Type: text/html

<html><body><p>Hello from <b>HTML</b></p></body></html>

--ABC123--
''';

      final message = parseEml(rawEml);
      expect(message.textBody, contains('Hello from plain text.'));
      expect(message.htmlBody, contains('<b>HTML</b>'));
    });

    test('parses attachments', () async {
      final rawBytes = base64.encode(utf8.encode('SampleAttachmentData'));
      final rawEml = '''
From: test@example.com
To: you@example.com
Subject: Attachment
Content-Type: multipart/mixed; boundary="BOUNDARY"

--BOUNDARY
Content-Type: text/plain

This email has an attachment

--BOUNDARY
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="myfile.bin"
Content-Transfer-Encoding: base64

$rawBytes

--BOUNDARY--
''';

      final message = parseEml(rawEml);
      expect(message.attachments.length, 1);
      final attachment = message.attachments.first;
      expect(attachment.fileName, 'myfile.bin');
      expect(attachment.contentType, contains('application/octet-stream'));
      expect(utf8.decode(attachment.data), 'SampleAttachmentData');
    });

    test('throws on empty input', () async {
      expect(() async => parseEml(''), throwsA(isA<EmlParserException>()));
    });
  });

  group('EML Parser Tests', () {
    test('Parses Aeon newsletter example', () async {
      final exampleEml =
          await File('test/test_data/aeon_email_example.eml').readAsString();

      final message = parseEml(exampleEml);

      // We expect non-empty text body
      expect(
        message.textBody.isNotEmpty,
        isTrue,
        reason: 'Should have plain-text body',
      );
      // We expect non-empty HTML body
      expect(
        message.htmlBody.isNotEmpty,
        isTrue,
        reason: 'Should have HTML body',
      );
      // Possibly check for certain known strings
      expect(message.textBody, contains('This week in'));
      expect(message.htmlBody, contains('<!DOCTYPE html>'));
    });
  });
}
