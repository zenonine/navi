import 'package:flutter/widgets.dart';

import '../main.dart';

class InheritedStack extends InheritedWidget {
  const InheritedStack({
    Key? key,
    required Widget child,
    required this.state,
  }) : super(key: key, child: child);

  final StackState state;

  static StackState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedStack>()!.state;
  }

  @override
  bool updateShouldNotify(covariant InheritedStack oldWidget) {
    return state != oldWidget.state;
  }
}
