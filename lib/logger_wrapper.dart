import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class WallsDevelopmentFilter extends DevelopmentFilter {
  @override
  bool shouldLog(LogEvent event) {
    return event.level.index <= Level.trace.index;
  }
}

class WallsProductionFilter extends ProductionFilter {
  @override
  bool shouldLog(LogEvent event) {
    return event.level.index <= Level.warning.index;
  }
}

LogFilter getLogFilter() {
  if (kReleaseMode) {
    return WallsProductionFilter();
  }
  return WallsDevelopmentFilter();
}

class LoggerWrapper {
  late final Logger logger;

  LoggerWrapper({required String logPath}) {
    logger = Logger(
      filter: getLogFilter(),
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
