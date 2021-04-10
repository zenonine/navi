import 'package:flutter/widgets.dart';

import '../main.dart';

class InheritedRootRoute extends InheritedWidget {
  const InheritedRootRoute({
    Key? key,
    required Widget child,
    required this.rootRoute,
  }) : super(key: key, child: child);

  final NaviRoute rootRoute;

  static NaviRoute of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedRootRoute>()!
        .rootRoute;
  }

  @override
  bool updateShouldNotify(covariant InheritedRootRoute oldWidget) {
    return rootRoute != oldWidget.rootRoute;
  }
}
