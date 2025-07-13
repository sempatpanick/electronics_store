import 'dart:async' as async;
import 'package:flutter/foundation.dart';

class Debouncer {
  final Duration delay;
  async.Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 500)});

  void call(VoidCallback action) {
    _timer?.cancel();
    _timer = async.Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
