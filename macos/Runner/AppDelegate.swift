import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  var channel: FlutterMethodChannel?
  var initialUrls: [URL]?

  override func applicationDidFinishLaunching(_ notification: Notification) {
    if let controller = mainFlutterWindow?.contentViewController as? FlutterViewController {
      channel = FlutterMethodChannel(name: "myChannel", binaryMessenger: controller.engine.binaryMessenger)
      
      // If we have initial URLs from application:open:urls, handle them now
      if let urls = initialUrls {
        handleUrls(urls)
        initialUrls = nil
      }
    }
  }

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

  override func application(_ application: NSApplication, open urls: [URL]) {
    // If the app is not fully launched yet, store URLs for later
    guard let window = mainFlutterWindow else {
      initialUrls = urls
      return
    }
    handleUrls(urls)
  }
  
  private func handleUrls(_ urls: [URL]) {
    if (!urls.isEmpty) {
      let filePaths = urls.map { $0.path }
      (mainFlutterWindow as! MainFlutterWindow).promptFilesAtStartUp = filePaths
      
      // If channel exists, app is running, so send files directly
      if let channel = channel {
        channel.invokeMethod("handleOpenFiles", arguments: filePaths)
      }
    }
  }
}
