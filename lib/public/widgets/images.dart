import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_ui/private.dart';
import 'package:flutter_native_ui/flutter_native_ui.dart';
import 'package:macos_ui/macos_ui.dart';

/// Returns an icon Widget depending on the platform:
/// 
/// macOS: MacosIcon
/// Everything else: a normal Icon
/// 
/// Note: it is recommended to only use NativeIconData with NativeIcon. Because of the way the macos_ui library is built, NativeIconData returns a Material Icon for the macOS style. NativeIcon uses the MacosIcon Widget with the Material Icon it receives, thus making it a macOS-styled icon.
class NativeIcon extends NativeStatelessWidget {
  final bool disableWarnings;
  final NativeIconData icon;
  final double? size;
  final double? fill;
  final double? weight;
  final double? grade;
  final double? opticalSize;
  final Color? color;
  final List<Shadow>? shadows;
  final String? semanticLabel;
  final TextDirection? textDirection;
  final bool? applyTextScaling;
  final BlendMode? blendMode;

  const NativeIcon(
    this.icon, {
    super.key,
    super.type = Icon,
    this.disableWarnings = kDebugMode,
    this.size,
    this.fill,
    this.weight,
    this.grade,
    this.opticalSize,
    this.color,
    this.shadows,
    this.semanticLabel,
    this.textDirection,
    this.applyTextScaling,
    this.blendMode,
  });

  @override
  Widget build(BuildContext context) {
    NativeHandler handler = NativeHandler(name: 'NativeIcon', enabled: !disableWarnings);
    if (Design.isMacOS()) {
      handler.handle('fill', fill);
      handler.handle('weight', weight);
      handler.handle('grade', grade);
      handler.handle('opticalSize', opticalSize);
      handler.handle('shadows', shadows);
      handler.handle('applyTextScaling', applyTextScaling);
      handler.handle('blendMode', blendMode);
      return MacosIcon(icon.build(), key: key, size: size, color: color, semanticLabel: semanticLabel, textDirection: textDirection);
    }
    return Icon(icon.build(), 
      size: size,
      color: color,
      shadows: shadows,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
      applyTextScaling: applyTextScaling,
      blendMode: blendMode,
    );
  }

  @override
  Widget transform(BuildContext context, Widget input) {
    throw Exception("Type ${super.type} cannot be transformed (from type ${input.runtimeType})");
  }
}

/// For generating IconData to be used with NativeIcon. This is recommended to only be used with NativeIcon, and if used with anything else (this only applies to macOS), then it will not look correct.
///
/// macosIcon is not strictly required due to the fact that the macos_ui library uses a specialized Widget that relies on the regular Material Icons library to generate a macOS icon. Because of this, you can omit the macosIcon argument, as it will just use the icon parameter.
class NativeIconData {
  final IconData? icon;
  final IconData? cupertinoIcon;
  final IconData? macosIcon;
  final IconData? fluentIcon;
  final IconData? yaruIcon;
  final bool disableWarnings;
  final IconData fallback;

  const NativeIconData({
    this.disableWarnings = kDebugMode,
    this.icon,
    this.cupertinoIcon,
    this.fluentIcon,
    this.yaruIcon,

    /// macosIcon is not strictly required due to the fact that the macos_ui library uses a specialized Widget that relies on the regular Material Icons library to generate a macOS icon. Because of this, you can omit the macosIcon argument, as it will just use the icon parameter.
    this.macosIcon,

    /// If you see a random warning symbol in your code, then that means that you didn't supply an icon for the platform the app is currently running on. That's why it's recommended to fill out It is recommended to fill out icon, cupertinoIcon, fluentIcon, and yaruIcon. (see macosIcon docs for details of why macosIcon isn't required)
    this.fallback = Icons.warning_amber,
  });

  IconData build() {
    if ([icon, cupertinoIcon, macosIcon, fluentIcon, yaruIcon].every((element) => element == null)) {
      throw Exception("At least one icon should be specified for NativeIconData. It is recommended to fill out icon, cupertinoIcon, fluentIcon, and yaruIcon.");
    }
    if ([icon, cupertinoIcon, macosIcon, fluentIcon, yaruIcon].any((element) => element == null) && disableWarnings == false) {
      warn("It is recommended to fill out icon, cupertinoIcon, fluentIcon, and yaruIcon into NativeIconData.");
    }
    if (Design.isMaterial()) {
      return icon ?? fallback;
    }
    if (Design.isCupertino()) {
      return cupertinoIcon ?? fallback;
    }
    if (Design.isMacOS()) {
      return macosIcon ?? (icon ?? fallback);
    }
    if (Design.isFluent()) {
      return fluentIcon ?? fallback;
    }
    if (Design.isYaru()) {
      return yaruIcon ?? fallback;
    }
    throw Exception("Unrecognized platform: ${getPlatform()}");
  }
}