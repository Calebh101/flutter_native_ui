library base;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_native_ui/_private/_logger.dart';

enum DesignType {material, cupertino, macos, fluent, yaru}
enum Environment {android, ios, macos, windows, linux, web, fuchsia}
DesignType _designType = DesignType.material;

class FlutterNativeUI {
  Environment? platform;
  FlutterNativeUI({
    this.platform,
  });

  Future<void> init() async {
    if (platform == null) {
      if (kIsWeb || kIsWasm) {
        platform = Environment.web;
      } else if (Platform.isIOS) {
        platform = Environment.ios;
      } else if (Platform.isAndroid) {
        platform = Environment.android;
      } else if (Platform.isWindows) {
        platform = Environment.windows;
      } else if (Platform.isLinux) {
        platform = Environment.linux;
      } else if (Platform.isMacOS) {
        platform = Environment.macos;
      } else if (Platform.isFuchsia) {
        platform = Environment.fuchsia;
      } else {
        throw Exception(("Unknown platform: ${Platform.operatingSystem}"));
      }
    }

    if (platform == Environment.web || platform == Environment.android || platform == Environment.fuchsia) {
      _designType = DesignType.material;
    } else if (platform == Environment.ios) {
      _designType = DesignType.cupertino;
    } else if (platform == Environment.macos) {
      _designType = DesignType.macos;
    } else if (platform == Environment.windows) {
      _designType = DesignType.fluent;
    } else if (platform == Environment.linux) {
      _designType = DesignType.yaru;
    } else {
      throw Exception("Invalid platform: $platform");
    }
  }  
}

class WindowHandler {
  final bool hideWarnings;
  WindowHandler({
    this.hideWarnings = false,
  });

  void init(Environment platform) {
    if (platform == Environment.linux || platform == Environment.windows) {
      // linux/windows
    } else if (platform == Environment.macos) {
      // MacosWindow
    } else {
      if (!hideWarnings) {
        warn("WindowHandler is not supported on platform ${Platform.operatingSystem}");
      }
    }
  }
}

class Design {
  static bool isMaterial() {
    return _designType == DesignType.material;
  }

  static bool isCupertino() {
    return _designType == DesignType.cupertino;
  }

  static bool isMacOS() {
    return _designType == DesignType.macos;
  }

  static bool isFluent() {
    return _designType == DesignType.fluent;
  }

  static bool isYaru() {
    return _designType == DesignType.yaru;
  }
}

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
    throw Exception('Unknown platform: ${Platform.operatingSystem}');
  }
}