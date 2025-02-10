import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_ui/flutter_native_ui.dart';
import 'package:flutter_native_ui/private.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:fluent_ui/fluent_ui.dart';

class NativeCircularProgressIndicator extends NativeStatelessWidget {
  final double? value;
  final double radius;
  final Color? color;
  final Color? backgroundColor;
  final Color? borderColor;
  final Animation<Color?>? valueColor;
  final double strokeWidth;
  final double strokeAlign;
  final String? semanticsLabel;
  final String? semanticsValue;
  final StrokeCap? strokeCap;

  NativeCircularProgressIndicator({
    super.key,
    super.type = CircularProgressIndicator,
    this.value,
    this.radius = 10,
    this.backgroundColor,
    this.borderColor,
    this.color,
    this.valueColor,
    this.strokeWidth = 4.0,
    this.strokeAlign = 0.0,
    this.semanticsLabel,
    this.semanticsValue,
    this.strokeCap,
  });

  @override
  Widget build(BuildContext context) {
    NativeHandler handler = NativeHandler(name: 'NativeCircularProgressIndicator');
    if (Design.isMaterialYaru()) {
      handler.handle('borderColor', borderColor);
      handler.handle('radius', radius);

      return CircularProgressIndicator(
        value: value,
        backgroundColor: backgroundColor,
        color: color,
        valueColor: valueColor,
        strokeWidth: strokeWidth,
        strokeAlign: strokeAlign,
        strokeCap: strokeCap,
        semanticsLabel: semanticsLabel,
        semanticsValue: semanticsValue,
      );
    } else if (Design.isCupertino()) {
      handler.handle('value', value);
      handler.handle('backgroundColor', backgroundColor);
      handler.handle('borderColor', borderColor);
      handler.handle('valueColor', valueColor);
      handler.handle('strokeAlign', strokeAlign);
      handler.handle('strokeWidth', strokeWidth);
      handler.handle('strokeCap', strokeCap);
      handler.handle('semanticsLabel', semanticsLabel);
      handler.handle('semanticsValue', semanticsValue);

      return CupertinoActivityIndicator(
        color: color,
        radius: radius,
        animating: true,
      );
    } else if (Design.isMacOS()) {
      handler.handle('valueColor', valueColor);
      handler.handle('strokeAlign', strokeAlign);
      handler.handle('strokeCap', strokeCap);
      handler.handle('semanticsValue', semanticsValue);
      handler.handle('strokeWidth', strokeWidth);

      return ProgressCircle(
        value: value,
        innerColor: color,
        borderColor: borderColor,
        radius: radius,
        semanticLabel: semanticsLabel,
      );
    } else if (Design.isFluent()) {
      handler.handle('valueColor', valueColor);
      handler.handle('strokeAlign', strokeAlign);
      handler.handle('strokeCap', strokeCap);
      handler.handle('semanticsValue', semanticsValue);

      return ProgressRing(
        value: value,
        backgroundColor: backgroundColor,
        activeColor: color,
        strokeWidth: strokeWidth,
        semanticLabel: semanticsLabel,
      );
    } else {
      return handler.overflow();
    }
  }
}