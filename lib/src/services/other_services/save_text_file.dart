import 'dart:io';
import 'package:path/path.dart' as path;

Future<void> saveTextToFile(String dir, String fileName, String text) async {
  final filePath = path.join(dir, '$fileName.md');
  final file = File(filePath);
  await file.writeAsString(text);
}
