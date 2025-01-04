import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:super_clipboard/super_clipboard.dart';

abstract final class ClipboardService {
  static final _clipboard = SystemClipboard.instance;

  static Future<void> write(dynamic data) async {
    if (data is String) {
      Clipboard.setData(ClipboardData(text: data));
    } else if (data is DataWriterItem) {
      _clipboard?.write([data]);
    } else {
      throw UnsupportedError('Unsupported data type');
    }
  }

  static Future<DataReader?> read() =>
      _clipboard?.read() ?? SynchronousFuture(null);
}
