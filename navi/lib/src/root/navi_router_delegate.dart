import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../main.dart';

class NaviRouterDelegate extends RouterDelegate<RouteInfo>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteInfo> {
  NaviRouterDelegate({
    GlobalKey<NavigatorState>? navigatorKey,
    required this.rootPage,
    this.onPopPage,
    Page? uninitializedPage,
  })  : navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>(),
        _uninitializedPage =
            uninitializedPage ?? MaterialPage<dynamic>(child: Container()) {
    _routerListener = () {
      notifyListeners();
    };
    _routerState.addListener(_routerListener);
  }

  NaviRouterDelegate.material({
    GlobalKey<NavigatorState>? navigatorKey,
    required Widget rootPage,
    NaviPopPageCallback? onPopPage,
    Page? uninitializedPage,
  }) : this(
          navigatorKey: navigatorKey,
          onPopPage: onPopPage,
          rootPage: (context) => MaterialPage<dynamic>(
            key: const ValueKey('Root'),
            child: rootPage,
          ),
          uninitializedPage: uninitializedPage,
        );

  NaviRouterDelegate.cupertino({
    GlobalKey<NavigatorState>? navigatorKey,
    required Widget rootPage,
    NaviPopPageCallback? onPopPage,
    Page? uninitializedPage,
  }) : this(
          navigatorKey: navigatorKey,
          onPopPage: onPopPage,
          rootPage: (context) => CupertinoPage<dynamic>(
            key: const ValueKey('Root'),
            child: rootPage,
          ),
          uninitializedPage:
              uninitializedPage ?? CupertinoPage<dynamic>(child: Container()),
        );

  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final VoidPageBuilder rootPage;
  final Page _uninitializedPage;
  final NaviPopPageCallback? onPopPage;

  final StackState _rootStackState = StackState<void>(
    initialState: null,
    routeInfoBuilder: (state) => const RouteInfo(),
  );

  int _newRouteCount = 0;

  final RouterState _routerState = RouterState();
  late final VoidCallback _routerListener;

  @override
  RouteInfo get currentConfiguration {
    final stackState = _routerState.state;
    final parentRouteInfos = stackState?.parentRouteInfos ?? [];
    final currentRouteInfo = stackState?.routeInfo ?? const RouteInfo();

    return (parentRouteInfos + [currentRouteInfo])
        .reduce((value, element) => value + element);
  }

  @override
  Future<void> setNewRoutePath(RouteInfo configuration) async {
    _newRouteCount++;
    _rootStackState.childRouteInfo = configuration;
  }

  @override
  Widget build(BuildContext context) {
    if (_newRouteCount > 0) {
      return InheritedNewRouteCount(
        count: _newRouteCount,
        child: InheritedStackMarker(
          states: [_rootStackState],
          child: InheritedStack(
            state: _rootStackState,
            child: Navigator(
              key: navigatorKey,
              pages: [rootPage(context)],
              onPopPage: (route, dynamic result) =>
                  onPopPage?.call(context, route, result) ??
                  route.didPop(result),
            ),
          ),
        ),
      );
    }

    return Navigator(
      key: navigatorKey,
      pages: [_uninitializedPage],
      onPopPage: (route, dynamic result) =>
          onPopPage?.call(context, route, result) ?? route.didPop(result),
    );
  }

  @override
  void dispose() {
    _routerState.removeListener(_routerListener);
    super.dispose();
  }
}
