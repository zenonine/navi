import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../main.dart';

class ChildRouterDelegate extends RouterDelegate<dynamic>
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<dynamic>,
        Diagnosticable {
  ChildRouterDelegate({
    GlobalKey<NavigatorState>? navigatorKey,
    this.marker,
    required this.naviPagesBuilder,
    required this.onBuiltNaviPages,
    this.onPopPage,
  }) : navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>();

  late final log = logger(this, marker == null ? [] : [marker!]);

  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final StackMarker? marker;
  final NaviPagesBuilder naviPagesBuilder;
  final OnBuiltNaviPages onBuiltNaviPages;
  final NaviPopPageCallback? onPopPage;

  late bool _isActiveRouteBranch;
  Map<LocalKey, UnprocessedRouteNotifier> _unprocessedRouteNotifiers = const {};
  LocalKey? _currentActivePageKey;

  @override
  Future<void> setNewRoutePath(dynamic configuration) async {
    assert(false, 'ChildRouterDelegate should not call setNewRoutePath');
  }

  @override
  void dispose() {
    super.dispose();
    log.finest('dispose');

    _unprocessedRouteNotifiers.forEach((key, notifier) {
      notifier.dispose();
    });

    _unprocessedRouteNotifiers = const {};
    _currentActivePageKey = null;
  }

  List<Page> _buildPages(BuildContext context, List<NaviPage> naviPages) {
    _resetActivePageKey(naviPages);

    _rebuildUnprocessedRouteNotifiers(context, naviPages);

    return [
      ...naviPages.mapIndexed(
        (index, naviPage) {
          final currentRoutes = [
            ...context.internalNavi.routes,
            naviPage.route
          ];
          final currentMergedRoute = currentRoutes.reduce(
              (mergedRoute, route) => mergedRoute.mergeCombinePath(route));

          log.finest('build page for $currentMergedRoute');

          final isActivePage = _currentActivePageKey == naviPage.key;

          assert(
            _unprocessedRouteNotifiers[naviPage.key] != null,
            "page ${naviPage.key} doesn't have an UnprocessedRouteNotifier",
          );

          // TODO: lazy initialize inactive pages

          return naviPage.pageBuilder(
            naviPage.key,
            InheritedRoutes(
              routes: currentRoutes,
              child: NotificationListener<ActiveNestedRoutesNotification>(
                onNotification: (notification) {
                  if (isActivePage) {
                    final mergedRoute = notification.routes.reduce(
                        (combinedRoute, route) =>
                            combinedRoute.mergeCombinePath(route));

                    _unprocessedRouteNotifiers[naviPage.key]!
                        .setRoute(mergedRoute, updateShouldNotify: false);
                    log.finest(
                        'active page ${naviPage.key} has nested routes: ${notification.routes}');
                    log.finest(
                        'active page ${naviPage.key} has nested merged route $mergedRoute');

                    ActiveNestedRoutesNotification(
                            routes: [naviPage.route, ...notification.routes])
                        .dispatch(context);
                  }

                  return true;
                },
                child: InheritedUnprocessedRouteNotifier(
                  notifier: _unprocessedRouteNotifiers[naviPage.key]!,
                  child: InheritedActiveRouteBranch(
                    active: isActivePage,
                    child: naviPage.child,
                  ),
                ),
              ),
            ),
          );
        },
      )
    ];
  }

  void _resetActivePageKey(List<NaviPage> naviPages) {
    // only activate the last page on an active route branch
    if (_isActiveRouteBranch) {
      _currentActivePageKey = naviPages.last.key;
    } else {
      _currentActivePageKey = null;
    }
  }

  void _rebuildUnprocessedRouteNotifiers(
    BuildContext context,
    List<NaviPage> naviPages,
  ) {
    final newNotifiers = <LocalKey, UnprocessedRouteNotifier>{};

    // reuse exist notifiers
    // remove and dispose notifiers for removed pages
    _unprocessedRouteNotifiers.forEach((key, notifier) {
      final naviPage =
          naviPages.firstWhereOrNull((naviPage) => naviPage.key == key);
      if (naviPage == null) {
        // page is removed
        notifier.dispose();
      } else {
        newNotifiers.putIfAbsent(key, () => notifier);
      }
    });

    for (final naviPage in naviPages) {
      final isActivePage = _currentActivePageKey == naviPage.key;

      // reuse existing notifier, otherwise create a new one
      final notifier = newNotifiers[naviPage.key] ?? UnprocessedRouteNotifier();

      if (isActivePage) {
        if (context.internalNavi.rootRouteNotifier.hasNewRootRoute) {
          // this active page already exists
          // on new root route, reset and notify new change
          notifier.setRoute(
              context.internalNavi.unprocessedRouteNotifier.route
                  .mergeSubtractPath(naviPage.route),
              updateShouldNotify: true);
        } else if (newNotifiers[naviPage.key] == null) {
          // update for the active route branch on the first time
          notifier.setRoute(
              context.internalNavi.unprocessedRouteNotifier.route
                  .mergeSubtractPath(naviPage.route),
              updateShouldNotify: false);
        }
      }

      log.finest('page ${naviPage.key} has nested route ${notifier.route}');

      newNotifiers.putIfAbsent(naviPage.key, () => notifier);
    }

    log.finest('old _unprocessedRouteNotifiers $_unprocessedRouteNotifiers');
    _unprocessedRouteNotifiers = Map.unmodifiable(newNotifiers);
    log.finest('new _unprocessedRouteNotifiers $_unprocessedRouteNotifiers');
  }

  void _disposeUnprocessedRouteNotifier(LocalKey pageKey) {
    final newNotifiers = <LocalKey, UnprocessedRouteNotifier>{};

    _unprocessedRouteNotifiers.forEach((key, notifier) {
      if (key == pageKey) {
        notifier.dispose();
      } else {
        newNotifiers.putIfAbsent(key, () => notifier);
      }
    });

    _unprocessedRouteNotifiers = Map.unmodifiable(newNotifiers);
  }

  bool _onPopPage(BuildContext context, Route<dynamic> route, dynamic result) {
    if (!route.didPop(result)) {
      return false;
    }

    onPopPage?.call(context, route, result);

    if (_currentActivePageKey != null) {
      _disposeUnprocessedRouteNotifier(_currentActivePageKey!);
    }

    return true;
  }

  void _assertUniquePageKey(List<NaviPage> naviPages) {
    naviPages.groupListsBy((naviPage) => naviPage.key).entries.forEach((entry) {
      assert(
        entry.value.length == 1,
        'Found same ${entry.key} in ${entry.value.length} pages.'
        ' Make sure key is unique between given pages.',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    log.finest('build');

    _isActiveRouteBranch = context.internalNavi.isActiveRouteBranch;

    final naviPages = naviPagesBuilder(context);

    assert(
      naviPages.isNotEmpty,
      '$context naviPagesBuilder must always return at least one page.',
    );

    _assertUniquePageKey(naviPages);

    onBuiltNaviPages(context, naviPages);

    final pages = _buildPages(context, naviPages);

    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, dynamic result) => _onPopPage(context, route, result),
    );
  }
}
