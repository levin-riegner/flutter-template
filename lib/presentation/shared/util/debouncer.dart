import 'dart:async';

import 'package:flutter/foundation.dart';

// https://web.archive.org/web/20220117092326/http://demo.nimius.net/debounce_throttle/
class Debouncer {
  final int gapMs;

  Timer? _timer;

  Debouncer({
    required this.gapMs,
  });

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: gapMs), action);
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
