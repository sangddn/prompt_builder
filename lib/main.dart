import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/app.dart';
import 'src/database/database.dart';
import 'src/pages/library_page/library_observer.dart';
import 'src/services/services.dart';

const kMethodChannel = MethodChannel('myChannel');

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  // Disable debugPrint if not in debug mode
  debugPrint = (String? message, {int? wrapWidth}) {
    if (kDebugMode) {
      debugPrintThrottled(message, wrapWidth: wrapWidth);
    }
  };

  // Initialize Sparkle
  if (kReleaseMode) {
    await UpdateService.initialize();
    await UpdateService.checkForUpdates();
  }

  // Initialize the local database
  await Database().initialize();

  final startFiles = await _getStartFiles(args);
  runApp(
    App(
      builder: (context, child) => LibraryObserver(
        startFiles: startFiles,
        child: child!,
      ),
    ),
  );
}

Future<List<String>> _getStartFiles(List<String> args) async {
  if (args.isNotEmpty) return args;
  if (Platform.isMacOS) {
    final files = await kMethodChannel.invokeMethod('getPromptFilesAtStartUp')
        as List<dynamic>?;
    if (files != null) return files.cast<String>();
  }
  return [];
}
