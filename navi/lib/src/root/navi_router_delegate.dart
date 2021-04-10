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

  late final log = logger(this);

  int _setNewRouteCount = 0;
  bool _hasNestedRouteStack = false;
  final RootRouteNotifier _rootRouteNotifier = RootRouteNotifier();
  final UnprocessedRouteNotifier _unprocessedRouteNotifier =
      UnprocessedRouteNotifier();

  @override
  NaviRoute get currentConfiguration {
    log.info('currentConfiguration ${_unprocessedRouteNotifier.route}');
    return _unprocessedRouteNotifier.route;
  }

  @override
  Future<void> setNewRoutePath(NaviRoute configuration) async {
    log.info('setNewRoutePath $configuration');
    if (_setNewRouteCount > 0) {
      // do not consider launching app as new root
      // hasNewRootRoute is true only the when app receives a new root route while running
      _rootRouteNotifier.setHasNewRootRoute(true, updateShouldNotify: false);
    }
    _setNewRouteCount++;
    _unprocessedRouteNotifier.setRoute(configuration);
  }

  @override
  Widget build(BuildContext context) {
    log.finest('build: newRoute ${_unprocessedRouteNotifier.route}');

    // TODO: what to do if _hasNestedRouteStack = false (in case of the most simple app without nested stacks)
    _hasNestedRouteStack = false;

    if (_setNewRouteCount > 0) {
      return NotificationListener<RootRouteNotification>(
        onNotification: (notification) {
          setNewRoutePath(notification.route);
          notifyListeners();
          return true;
        },
        child: NotificationListener<ActiveNestedRoutesNotification>(
          onNotification: (notification) {
            log.fine('new routes ${notification.routes}');

            final mergedRoute = notification.routes.reduce(
                (combinedRoute, route) =>
                    combinedRoute.mergeCombinePath(route));

            if (_unprocessedRouteNotifier.route != mergedRoute) {
              Router.of(context)
                  .routeInformationProvider!
                  .routerReportsNewRouteInformation(RouteInformation(
                      location:
                          Uri.decodeComponent(mergedRoute.uri.toString())));

              _unprocessedRouteNotifier.setRoute(mergedRoute,
                  updateShouldNotify: false);

              log.info('navigated to new route $mergedRoute');
            } else {
              log.fine('ignored! No changes to existing route $mergedRoute');
            }

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
}
