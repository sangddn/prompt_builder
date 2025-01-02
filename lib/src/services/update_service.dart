import 'package:auto_updater/auto_updater.dart';

abstract final class UpdateService {
  static const _feedURL =
      'https://sangddn.github.io/prompt_builder/appcast.xml';

  static Future<void> initialize() async {
    await autoUpdater.setFeedURL(_feedURL);
    await autoUpdater.setScheduledCheckInterval(86400);
  }

  static Future<void> checkForUpdates() async {
    await autoUpdater.checkForUpdates(inBackground: true);
  }
}
