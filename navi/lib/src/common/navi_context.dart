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
    )).dispatch(context);
  }

  void relativeTo(
    List<String> path, {
    Map<String, List<String>> queryParams = const {},
    String fragment = '',
  }) {
    // TODO: implementation?
  }

  List<NaviRoute> get routes => InheritedRoutes.of(context);

  RootRouteNotifier get rootRouteNotifier =>
      InheritedRootRouteNotifier.of(context);

  UnprocessedRouteNotifier get unprocessedRouteNotifier =>
      InheritedUnprocessedRouteNotifier.of(context);

  List<StackMarker> get markers => InheritedStackMarkers.of(context);
}

class InternalNavi extends Navi {
  InternalNavi(BuildContext context) : super(context);

  bool get isActiveRouteBranch => InheritedActiveRouteBranch.of(context);
}

extension NaviContext on BuildContext {
  Navi get navi => Navi(this);
}

extension InternalNaviContext on BuildContext {
  InternalNavi get internalNavi => InternalNavi(this);
}
