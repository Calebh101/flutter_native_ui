import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_native_ui/private/logger.dart';

/// Private API for warning users if they're using variables unsupported by that platform's library.
class VariableHandler {
  final String name;
  final bool enabled;

  VariableHandler({
    required this.name,
    this.enabled = kDebugMode,
  });

  bool handle(String name, dynamic variable) {
    if (variable != null && enabled) {
      warn("Argument \"$name\" cannot be used with ${this.name} on platform ${kIsWeb ? "web:native" : kIsWasm ? "web:wasm" : Platform.operatingSystem}.");
      return false;
    } else {
      return true;
    }
  }
}