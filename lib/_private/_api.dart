import 'package:flutter/material.dart';

Brightness getBrightness(BuildContext context) {
  return MediaQuery.platformBrightnessOf(context);
}