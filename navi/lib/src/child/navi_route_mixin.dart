import 'package:flutter/widgets.dart';

import '../main.dart';

mixin NaviRouteMixin<T extends StatefulWidget> on State<T> {
  UnprocessedRouteNotifier? _unprocessedRouteNotifier;

  @override
  @protected
  @mustCallSuper
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_unprocessedRouteNotifier != context.navi.unprocessedRouteNotifier) {
      _unprocessedRouteNotifier = context.navi.unprocessedRouteNotifier;

      onNewRoute(_unprocessedRouteNotifier!.route);

      _unprocessedRouteNotifier!.addListener(() {
        if (context.navi.rootRouteNotifier.hasNewRootRoute) {
          // force to rebuild widget even state isn't change to propagate new route to nested stacks
          setState(() {
            onNewRoute(_unprocessedRouteNotifier!.route);
          });
        } else {
          onNewRoute(_unprocessedRouteNotifier!.route);
        }
      });
    }
  }

  @protected
  void onNewRoute(NaviRoute unprocessedRoute) {}
}
