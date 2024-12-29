import 'package:flutter/foundation.dart';

/*
 * These debugPrint calls should be ok.
 */

class Profiler {
  DateTime? start;

  Profiler() {
    debugPrint('Starting Profiler');
    start = DateTime.now();
  }

  void startProfiling(String message) {
    debugPrint('Started Profiler: $message');
    start = DateTime.now();
  }

  Duration getDifferenceStartNow(String message) {
    if (start != null) {
      final end = DateTime.now();
      final duration = end.difference(start!);
      debugPrint('$message: Duration: $duration');
      return duration;
    } else {
      throw Exception('Profiler not started.');
    }
  }
}
