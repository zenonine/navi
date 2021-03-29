import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../main.dart';

class NaviRouterDelegate extends RouterDelegate<RouteInfo>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteInfo> {
  NaviRouterDelegate({
    required this.rootStack,
    GlobalKey<NavigatorState>? navigatorKey,
  }) : navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>() {
    _stackListener = () {
      notifyListeners();
    };
    rootStack.addListener(_stackListener);
  }

  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final PageStack rootStack;
  late final VoidCallback _stackListener;
  bool _initialized = false;

  @override
  RouteInfo get currentConfiguration {
    return rootStack is RouteStack
        ? (rootStack as RouteStack).routeInfo
        : const RouteInfo();
  }

  @override
  Future<void> setNewRoutePath(RouteInfo configuration) async {
    if (rootStack is RouteStack) {
      (rootStack as RouteStack).routeInfo = configuration;
    }

    _initialized = true;
  }

  @override
  void dispose() {
    rootStack.removeListener(_stackListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedStack(
      stacks: [rootStack],
      child: Navigator(
        key: navigatorKey,
        pages: _initialized
            ? rootStack.pages(context)
            : [MaterialPage<dynamic>(child: EmptyStackOutlet())],
        onPopPage: (route, dynamic result) =>
            rootStack.onPopPage(context, route, result),
      ),
    );
  }
}
