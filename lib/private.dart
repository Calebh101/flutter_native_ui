library;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_ui/flutter_native_ui.dart';

export 'private/main.dart';
export 'private/handler.dart';
export 'private/logger.dart';

/// Private API to get the current Brightness (light or dark).
/// It uses a method that is Cupertino-compliant.
Brightness getBrightness(BuildContext context) {
  return MediaQuery.platformBrightnessOf(context);
}

/// Private API to get the platform, while having safety for web platforms.
String getPlatform() {
  return kIsWasm ? "web:wasm" : (kIsWeb ? "web:native" : Platform.operatingSystem);
}

/// Private API to get the current Design's font.
String getFont() {
  if (Design.isMaterial()) {
    return 'Roboto';
  } else if (Design.isCupertino() || Design.isMacOS()) {
    return 'SFPro';
  } else if (Design.isFluent()) {
    return 'SegoeUI';
  } else if (Design.isYaru()) {
    return 'Ubuntu';
  } else {
    throw Exception('Unknown platform: ${getPlatform()}');
  }
}