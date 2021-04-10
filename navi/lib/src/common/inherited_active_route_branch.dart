import 'package:flutter/widgets.dart';

class InheritedActiveRouteBranch extends InheritedWidget {
  const InheritedActiveRouteBranch({
    Key? key,
    required Widget child,
    required this.active,
  }) : super(key: key, child: child);

  final bool active;

  static bool of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedActiveRouteBranch>()!
        .active;
  }

  @override
  bool updateShouldNotify(covariant InheritedActiveRouteBranch oldWidget) {
    return active != oldWidget.active;
  }
}
