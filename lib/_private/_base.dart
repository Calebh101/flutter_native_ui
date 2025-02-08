import 'package:flutter/material.dart';

/// for custom implementations of StatelessWidget
abstract class NativeStatelessWidget extends StatelessWidget with NativeWidget {
  final Type type;
  const NativeStatelessWidget({super.key, required this.type});
}

/// for custom implementations of StatefulWidget
abstract class NativeStatefulWidget extends StatefulWidget with NativeWidget {
  final Type type;
  const NativeStatefulWidget({super.key, required this.type});
}

/// for custom implementations of Widget
mixin NativeWidget<T extends Widget> {
  /// a transform() function comes with each Widget to transform Material Design Widgets into Native UI Widgets
  @protected
  Widget transform(BuildContext context, Widget input);

  /// if this is undefined, then the passed widget is not a NativeWidget
  bool check() {
    return true; // returns true
  }
}