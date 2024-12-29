import 'package:logger/logger.dart';

class LoggerWrapper {
  late final Logger logger;

  LoggerWrapper({required String logPath}) {
    logger = Logger(
      filter: null,
      printer: null,
      output: AdvancedFileOutput(
        path: logPath,
      ),
    );
  }

  void trace(String message) {
    logger.t(message);
  }

  void debug(String message) {
    logger.d(message);
  }

  void info(String message) {
    logger.i(message);
  }

  void warning(String message) {
    logger.w(message);
  }

  void error(String message, {Object? error, StackTrace? stackTrace}) {
    logger.e(message);
  }

  void fatal(String message, {Object? error, StackTrace? stackTrace}) {
    logger.f(message);
  }
}
