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
  NaviRoute? get currentConfiguration {
    // Because _reportNewRoute will be called right after widget tree is built
    // return null to avoid redundant reporting here
    // _log.info('currentConfiguration ${_unprocessedRouteNotifier.route}');
    // return _unprocessedRouteNotifier.route;
    return null;
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

    // TODO: if new configuration is not normalized (dirty),
    //  an update is still needed even if the normalized route doesn't change.
    //  /books/// should be converted to /books
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

  void _reportNewRoute(BuildContext context, NaviRoute newRoute) {
    _log.finest('_reportNewRoute $newRoute');
    final currentRouteInfo = Router.of(context).routeInformationProvider!.value;
    final currentUri = Uri.parse(currentRouteInfo!.location ?? '');
    final currentRoute = NaviRoute.fromUri(currentUri);

    // update route if there is a new route or the current one is dirty
    if (currentRoute != newRoute ||
        currentUri.toString() != newRoute.uri.toString()) {
      final newRouteInformation =
          RouteInformation(location: newRoute.uri.toString());

      Router.of(context)
          .routeInformationProvider!
          .routerReportsNewRouteInformation(newRouteInformation);

      _log.finest('Navigated from $currentRoute to $newRoute');
    }
  }

  @override
  void dispose() {
    _rootRouteNotifier.dispose();
    _unprocessedRouteNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _log.finest('build: newRoute ${_unprocessedRouteNotifier.route}');

    if (_setNewRouteCount > 0) {
      _notifyNewRoute(context);

      return NotificationListener<RootRouteNotification>(
        onNotification: (notification) {
          final newPathSegments = notification.relative
              ? _unprocessedRouteNotifier.route.path + notification.route.path
              : notification.route.path;
          final newRoute = NaviRoute(
            path:
                Uri(path: '/').resolve(newPathSegments.join('/')).pathSegments,
            queryParams: notification.route.queryParams,
            fragment: notification.route.fragment,
          );

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
}
