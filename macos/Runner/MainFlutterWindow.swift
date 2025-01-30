import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  open var promptFilesAtStartUp: [String]?

  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    let channel = FlutterMethodChannel(name: "myChannel", binaryMessenger: flutterViewController.engine.binaryMessenger)
    channel.setMethodCallHandler({
      (call: FlutterMethodCall, result: FlutterResult) -> Void in
      switch call.method {
        case "getPromptFilesAtStartUp":
          result(self.promptFilesAtStartUp)
          // Clear the files after sending them to prevent reopening on window recreation
          self.promptFilesAtStartUp = nil
        default:
          result(FlutterMethodNotImplemented)
      }
    })

    super.awakeFromNib()
  }
}
