import 'package:flutter/material.dart';
import 'dart:async';
class Debouncer {
  int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});



  run(VoidCallback action) {
    if (null != _timer) {
      _timer
      !.cancel(); // when the user is continuosly typing, this cancels the timer
    }
    // then we will start a new timer looking for the user to stop
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}