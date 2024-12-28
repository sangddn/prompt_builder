import 'package:process_run/shell.dart';

Future<void> launchUrlString(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) {
    throw Exception('Invalid URL: $url');
  }
  final shell = Shell();
  try {
    final escapedUrl = '"$url"';
    await shell.run('open $escapedUrl');
  } catch (e) {
    throw Exception('Could not launch URL: $e');
  }
}
