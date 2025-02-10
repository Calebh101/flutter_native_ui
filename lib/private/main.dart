import 'package:flutter/material.dart';

/// for custom implementations of StatelessWidget
abstract class NativeStatelessWidget extends StatelessWidget implements NativeWidget {
  @override
  final Type type;

  /// constructor
  const NativeStatelessWidget({super.key, required this.type});
}

/// for custom implementations of StatefulWidget
abstract class NativeStatefulWidget extends StatefulWidget implements NativeWidget {
  @override
  final Type type;

  /// constructor
  const NativeStatefulWidget({super.key, required this.type});
}

/// for custom implementations of Widget
abstract class NativeWidget<T extends Widget> {
  /// Material equivalent
  final Type type;

  /// constructor
  const NativeWidget(this.type);

  /// a transform() function comes with each Widget to transform Material Design Widgets into Native UI Widgets
  Widget transform(BuildContext context, Widget input);
}
