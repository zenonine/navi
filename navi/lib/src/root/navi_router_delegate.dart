import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:navi/src/root/root_route_notification.dart';

import '../main.dart';

class NaviRouterDelegate extends RouterDelegate<NaviRoute>
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<NaviRoute>,
        Diagnosticable {
  NaviRouterDelegate({
    GlobalKey<NavigatorState>? navigatorKey,
    required this.rootPage,
    this.onPopPage,
    required Page uninitializedPage,
  })   : navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>(),
        _uninitializedPage = uninitializedPage;

  NaviRouterDelegate.material({
    GlobalKey<NavigatorState>? navigatorKey,
    required Widget child,
    NaviRootPopPageCallback? onPopPage,
    Widget? uninitializedPage,
  }) : this(
          navigatorKey: navigatorKey,
          onPopPage: onPopPage,
          rootPage: (context) => MaterialPage<dynamic>(
            key: const ValueKey('Root'),
            child: child,
          ),
          uninitializedPage:
              MaterialPage<dynamic>(child: uninitializedPage ?? Container()),
        );

  NaviRouterDelegate.cupertino({
    GlobalKey<NavigatorState>? navigatorKey,
    required Widget child,
    NaviRootPopPageCallback? onPopPage,
    Widget? uninitializedPage,
  }) : this(
          navigatorKey: navigatorKey,
          onPopPage: onPopPage,
          rootPage: (context) => CupertinoPage<dynamic>(
            key: const ValueKey('Root'),
            child: child,
          ),
          uninitializedPage:
              CupertinoPage<dynamic>(child: uninitializedPage ?? Container()),
        );

  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final VoidPageBuilder rootPage;
  final Page _uninitializedPage;
  final NaviRootPopPageCallback? onPopPage;

  late final _log = logger(this);

  int _setNewRouteCount = 0;
  bool _hasNestedRouteStack = false;
  final RootRouteNotifier _rootRouteNotifier = RootRouteNotifier();
  final UnprocessedRouteNotifier _unprocessedRouteNotifier =
      UnprocessedRouteNotifier();

  @override
  NaviRoute get currentConfiguration {
    _log.info('currentConfiguration ${_unprocessedRouteNotifier.route}');
    return _unprocessedRouteNotifier.route;
  }

  @override
  Future<void> setNewRoutePath(NaviRoute configuration) async {
    _log.info('setNewRoutePath $configuration');
    if (_setNewRouteCount > 0) {
      // do not consider launching app as new root
      // hasNewRootRoute is true only the when app receives a new root route while running
      _rootRouteNotifier.setHasNewRootRoute(true, updateShouldNotify: false);
    }
    _setNewRouteCount++;
    _unprocessedRouteNotifier.setRoute(configuration);
  }

  void _notifyNewRoute(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (!_hasNestedRouteStack) {
        // reset route if there's no nested stack
        const newRoute = NaviRoute();

        _reportNewRoute(context, newRoute);

        _unprocessedRouteNotifier.setRoute(
          newRoute,
          updateShouldNotify: false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _log.finest('build: newRoute ${_unprocessedRouteNotifier.route}');

    if (_setNewRouteCount > 0) {
      _notifyNewRoute(context);

      return NotificationListener<RootRouteNotification>(
        onNotification: (notification) {
          final newRoute = notification.relative
              ? NaviRoute(
                  path: _unprocessedRouteNotifier.route.path +
                      notification.route.path,
                  queryParams: notification.route.queryParams,
                  fragment: notification.route.fragment,
                )
              : notification.route;

          setNewRoutePath(newRoute).then((_) {
            notifyListeners();
          });

          return true;
        },
        child: NotificationListener<ActiveNestedRoutesNotification>(
          onNotification: (notification) {
            _log.fine('new routes ${notification.routes}');

            final mergedRoute = notification.routes.reduce(
                (combinedRoute, route) =>
                    combinedRoute.mergeCombinePath(route));

            _reportNewRoute(context, mergedRoute);
            _log.info('navigated to new route $mergedRoute');

            _unprocessedRouteNotifier.setRoute(
              mergedRoute,
              updateShouldNotify: false,
            );

            _rootRouteNotifier.setHasNewRootRoute(false,
                updateShouldNotify: false);

            return true;
          },
          child: NotificationListener<NewStackNotification>(
            onNotification: (notification) {
              _hasNestedRouteStack = true;
              return true;
            },
            child: InheritedRootRouteNotifier(
              notifier: _rootRouteNotifier,
              child: InheritedStackMarkers(
                markers: const [],
                child: InheritedRoutes(
                  routes: const [NaviRoute()],
                  child: InheritedUnprocessedRouteNotifier(
                    notifier: _unprocessedRouteNotifier,
                    child: InheritedActiveRouteBranch(
                      active: true,
                      child: Navigator(
                        key: navigatorKey,
                        pages: [rootPage(context)],
                        onPopPage: (route, dynamic result) {
                          if (!route.didPop(result)) {
                            return false;
                          }

                          onPopPage?.call(context, route, result, true);

                          return true;
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Navigator(
      key: navigatorKey,
      pages: [_uninitializedPage],
      onPopPage: (route, dynamic result) {
        if (!route.didPop(result)) {
          return false;
        }

        onPopPage?.call(context, route, result, false);

        return true;
      },
    );
  }

  void _reportNewRoute(BuildContext context, NaviRoute newRoute) {
    Router.of(context)
        .routeInformationProvider!
        .routerReportsNewRouteInformation(
          RouteInformation(
            location: Uri.decodeComponent(newRoute.uri.toString()),
          ),
        );
  }
}
