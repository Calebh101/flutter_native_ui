import 'package:flutter/material.dart';

class NativeNavItem {
  String? label;
  IconData icon;
  IconData? selectedIcon;
  Widget widget;
  Function? onPressed;

  NativeNavItem({
    required this.label,
    required this.icon,
    this.selectedIcon,
    required this.widget,
    this.onPressed,
  });
}
