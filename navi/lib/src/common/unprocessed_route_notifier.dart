import 'package:flutter/widgets.dart';

import '../main.dart';

class UnprocessedRouteNotifier extends ChangeNotifier {
  UnprocessedRouteNotifier({NaviRoute initialRoute = const NaviRoute()})
      : _route = initialRoute;

  NaviRoute _route;

  NaviRoute get route => _route;

  void setRoute(NaviRoute route, {bool updateShouldNotify = true}) {
    if (_route != route) {
      _route = route;
      if (updateShouldNotify) {
        notifyListeners();
      }
    }
  }

  @override
  String toString() {
    return 'UnprocessedRouteNotifier{route: $route}';
  }
}

class InheritedUnprocessedRouteNotifier extends InheritedWidget {
  const InheritedUnprocessedRouteNotifier({
    Key? key,
    required this.notifier,
    required Widget child,
  }) : super(key: key, child: child);

  final UnprocessedRouteNotifier notifier;

  static UnprocessedRouteNotifier of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<
            InheritedUnprocessedRouteNotifier>()!
        .notifier;
  }

  @override
  bool updateShouldNotify(
      covariant InheritedUnprocessedRouteNotifier oldWidget) {
    return oldWidget.notifier != notifier;
  }
}
