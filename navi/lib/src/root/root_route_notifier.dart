import 'package:flutter/widgets.dart';

abstract class IRootRouteNotifier {
  bool get hasNewRootRoute;
}

class RootRouteNotifier extends ChangeNotifier implements IRootRouteNotifier {
  RootRouteNotifier();

  bool _hasNewRootRoute = false;

  @override
  bool get hasNewRootRoute => _hasNewRootRoute;

  void setHasNewRootRoute(bool hasNewRootRoute,
      {bool updateShouldNotify = true}) {
    if (_hasNewRootRoute != hasNewRootRoute) {
      _hasNewRootRoute = hasNewRootRoute;
      if (updateShouldNotify) {
        notifyListeners();
      }
    }
  }

  @override
  String toString() {
    return 'RootRouteNotifier{hasNewRootRoute: $hasNewRootRoute}';
  }
}

class InheritedRootRouteNotifier extends InheritedWidget {
  const InheritedRootRouteNotifier({
    Key? key,
    required this.notifier,
    required Widget child,
  }) : super(key: key, child: child);

  final RootRouteNotifier notifier;

  static RootRouteNotifier of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedRootRouteNotifier>()!
        .notifier;
  }

  @override
  bool updateShouldNotify(covariant InheritedRootRouteNotifier oldWidget) {
    return oldWidget.notifier != notifier;
  }
}
