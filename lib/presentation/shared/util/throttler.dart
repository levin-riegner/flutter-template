import 'package:flutter/foundation.dart';

// https://web.archive.org/web/20220117092326/http://demo.nimius.net/debounce_throttle/
class Throttler {
  final int throttleGapMs;

  Throttler({
    required this.throttleGapMs,
  });

  int? lastActionTime;

  void run(VoidCallback action) {
    if (lastActionTime == null) {
      lastActionTime = DateTime.now().millisecondsSinceEpoch;
      action();
    } else {
      if (DateTime.now().millisecondsSinceEpoch - lastActionTime! >
          throttleGapMs) {
        lastActionTime = DateTime.now().millisecondsSinceEpoch;
        action();
      } else {
        // Ignore (throttle)
      }
    }
  }
}
