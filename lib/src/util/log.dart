import 'package:logger/logger.dart';

/// loggerに関しては公式の使い方を基本的に参照
/// https://pub.dev/packages/logger/example
///
class Log {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(),
  );

  /// エラーを吐くときに使う
  static void error(dynamic error) {
    _logger.e(error);
  }
}
