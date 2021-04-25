import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

import '../main.dart';

class InheritedRoutes extends InheritedWidget {
  const InheritedRoutes({
    Key? key,
    required Widget child,
    required this.routes,
  }) : super(key: key, child: child);

  final List<NaviRoute> routes;

  static List<NaviRoute> of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedRoutes>()!.routes;
  }

  @override
  bool updateShouldNotify(covariant InheritedRoutes oldWidget) {
    return !(const ListEquality<NaviRoute>().equals(routes, oldWidget.routes));
  }
}
