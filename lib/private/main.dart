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

  @override
  dynamic build(BuildContext context) {
    return null;
  }

  /// constructor
  const NativeStatefulWidget({super.key, required this.type});

  @override
  NativeState createState();
}

/// The corresponding State class that implements the `build` method
abstract class NativeState<T extends NativeStatefulWidget> extends State<T> {
  @override
  Widget build(BuildContext context);
}

/// for custom implementations of Widget
abstract class NativeWidget extends Native {
  /// constructor
  const NativeWidget({super.type = Widget});
}

/// base class for all Native uses
abstract class Native {
  /// Material equivalent
  final Type type;

  /// constructor
  const Native({this.type = Object});

  /// builder
  dynamic build(BuildContext context);
}