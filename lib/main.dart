import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/database/database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Disable debugPrint if not in debug mode
  debugPrint = (String? message, {int? wrapWidth}) {
    if (kDebugMode) {
      debugPrintThrottled(message, wrapWidth: wrapWidth);
    }
  };

  // Initialize the local database
  await Database.instance.init();

  runApp(const App());
}
