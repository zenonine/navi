import 'package:flutter/widgets.dart';

class InheritedNewRouteCount extends InheritedWidget {
  const InheritedNewRouteCount({
    Key? key,
    required Widget child,
    required this.count,
  }) : super(key: key, child: child);

  final int count;

  static int of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedNewRouteCount>()!
        .count;
  }

  @override
  bool updateShouldNotify(covariant InheritedNewRouteCount oldWidget) {
    return count != oldWidget.count;
  }
}
