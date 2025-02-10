import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_native_ui/private/logger.dart';
import 'package:flutter_native_ui/public/main/main.dart';

/// Private API for handling NativeWidgets.
class NativeHandler {
  final String name;
  final bool enabled;

  NativeHandler({
    required this.name,
    this.enabled = kDebugMode,
  });

  bool handle(String name, dynamic variable) {
    bool showWarnings = false;
    if (variable != null && enabled && showWarnings) {
      warn("Argument \"$name\" cannot be used with ${this.name} on platform ${kIsWeb ? "web:native" : kIsWasm ? "web:wasm" : Platform.operatingSystem}.");
      return false;
    } else {
      return true;
    }
  }

  dynamic overflow() {
    throw DesignOverflowError(widget: name, message: "Invalid design type: ${Design.get()}");
  }
}

class DesignOverflowError implements Exception {
  final String widget;
  final String message;

  DesignOverflowError({
    this.widget = "NativeWidget",
    this.message = "Invalid Design type",
  });

  @override
  String toString() => "DesignOverflowError for Widget $widget: $message";
}