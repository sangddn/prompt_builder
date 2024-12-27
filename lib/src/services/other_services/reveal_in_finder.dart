import 'package:process_run/shell.dart';

Future<void> revealInFinder(String absolutePath) async {
  final shell = Shell();
  try {
    final escapedPath = '"$absolutePath"';
    await shell.run('open -R $escapedPath');
  } catch (e) {
    throw Exception('Could not reveal file: $e');
  }
}
