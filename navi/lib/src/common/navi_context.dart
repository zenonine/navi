import 'package:flutter/widgets.dart';

import '../main.dart';

class Navi {
  Navi(this.context);

  final BuildContext context;

  void to(
    List<String> path, {
    Map<String, List<String>> queryParams = const {},
    String fragment = '',
  }) {
    RootRouteNotification(
      route: NaviRoute(
        path: path,
        queryParams: queryParams,
        fragment: fragment,
      ),
    ).dispatch(context);
  }

  void relativeTo(
    List<String> path, {
    Map<String, List<String>> queryParams = const {},
    String fragment = '',
  }) {
    RootRouteNotification(
      relative: true,
      route: NaviRoute(
        path: path,
        queryParams: queryParams,
        fragment: fragment,
      ),
    ).dispatch(context);
  }

  /// shortcut of `Navigator.of(context).canPop()`
  bool canPop() {
    return Navigator.of(context).canPop();
  }

  /// shortcut of `Navigator.of(context).maybePop()`
  Future<bool> maybePop<T extends Object?>([T? result]) {
    return Navigator.of(context).maybePop(result);
  }

  /// shortcut of `Navigator.of(context).pop()`
  void pop<T extends Object?>([T? result]) {
    Navigator.of(context).pop(result);
  }

  IRootRouteNotifier get rootRouteNotifier =>
      InheritedRootRouteNotifier.of(context);

  IUnprocessedRouteNotifier get unprocessedRouteNotifier =>
      InheritedUnprocessedRouteNotifier.of(context);
}

class InternalNavi extends Navi {
  InternalNavi(BuildContext context) : super(context);

  bool get isActiveRouteBranch => InheritedActiveRouteBranch.of(context);

  List<NaviRoute> get routes => InheritedRoutes.of(context);

  List<IStackMarker> get markers => InheritedStackMarkers.of(context);
}

extension NaviContext on BuildContext {
  Navi get navi => Navi(this);
}

extension InternalNaviContext on BuildContext {
  InternalNavi get internalNavi => InternalNavi(this);
}
