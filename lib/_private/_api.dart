import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Brightness getBrightness(BuildContext context) {
  return MediaQuery.platformBrightnessOf(context);
}

String getPlatform() {
  return kIsWeb ? "web:native" : (kIsWasm ? "web:wasm" : Platform.operatingSystem);
}