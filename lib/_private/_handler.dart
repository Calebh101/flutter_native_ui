import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_native_ui/_private/_logger.dart';

class VariableHandler {
  final String name;
  final bool enabled;

  VariableHandler({
    required this.name,
    this.enabled = true,
  });

  bool handle(String name, dynamic variable) {
    if (variable != null && enabled) {
      warn("Argument \"$name\" cannot be used with ${this.name} with platform ${kIsWeb ? "web:native" : kIsWasm ? "web:wasm" : Platform.operatingSystem}.");
      return false;
    } else {
      return true;
    }
  }
}