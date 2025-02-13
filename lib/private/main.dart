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
abstract class NativeWidget extends Native {
  /// constructor
  const NativeWidget(super.type);
}

/// base class for all Native uses
abstract class Native {
  /// Material equivalent
  final Type type;

  /// constructor
  const Native(this.type);
}