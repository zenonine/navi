import 'package:flutter/widgets.dart';

import '../main.dart';

abstract class IUnprocessedRouteNotifier extends Listenable {
  NaviRoute get route;

  bool get hasListeners;
}

class UnprocessedRouteNotifier extends ChangeNotifier
    implements IUnprocessedRouteNotifier {
  UnprocessedRouteNotifier({NaviRoute initialRoute = const NaviRoute()})
      : _route = initialRoute;

  NaviRoute _route;

  @override
  NaviRoute get route => _route;

  /// Return `false` if new route equals old route.
  /// Otherwise, return `true`.
  bool setRoute(NaviRoute route, {bool updateShouldNotify = true}) {
    if (_route != route) {
      _route = route;
      if (updateShouldNotify) {
        notifyListeners();
      }
      return true;
    }
    return false;
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
