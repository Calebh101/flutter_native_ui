import 'package:flutter/material.dart';
import 'package:flutter_native_ui/public/widgets/images.dart';

/// Used for building navigation bar items. These are used anywhere from QuickNavBar (from my other package, quick_navbar) to MacosSidebar (from macos_ui).
class NativeNavItem {
  /// Name
  String? label;
  
  /// Icon
  NativeIcon icon;

  /// Icon shown when selected
  NativeIcon? selectedIcon;

  /// Corresponding page
  Widget? widget;

  /// Function to be ran when the nav item is pressed
  Function? onPressed;

  /// NativeNavItem builder
  NativeNavItem({
    required this.label,
    required this.icon,
    this.selectedIcon,
    this.widget,
    this.onPressed,
  });
}
