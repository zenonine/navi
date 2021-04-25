import 'package:flutter/widgets.dart';

import '../main.dart';

mixin NaviRouteMixin<T extends StatefulWidget> on State<T> {
  late final log = logger(this);

  IUnprocessedRouteNotifier? _unprocessedRouteNotifier;
  VoidCallback? _unprocessedRouteListener;

  @override
  @protected
  @mustCallSuper
  void didChangeDependencies() {
    super.didChangeDependencies();
    log.finest('didChangeDependencies');

    if (_unprocessedRouteNotifier != context.navi.unprocessedRouteNotifier) {
      _unprocessedRouteNotifier = context.navi.unprocessedRouteNotifier;

      onNewRoute(_unprocessedRouteNotifier!.route);

      _unprocessedRouteListener = () {
        if (context.navi.rootRouteNotifier.hasNewRootRoute) {
          // force to rebuild widget even state isn't change to propagate new route to nested stacks
          setState(() {
            onNewRoute(_unprocessedRouteNotifier!.route);
          });
        } else {
          onNewRoute(_unprocessedRouteNotifier!.route);
        }
      };
      _unprocessedRouteNotifier!.addListener(_unprocessedRouteListener!);
    }
  }

  @override
  void dispose() {
    log.finest('dispose');

    if (_unprocessedRouteListener != null) {
      bool hasListeners = false;
      try {
        hasListeners = _unprocessedRouteNotifier?.hasListeners ?? false;
      } on FlutterError catch (e) {
        log.finest(
          '_unprocessedRouteNotifier is already disposed, nothing to do',
          e,
        );
      }

      if (hasListeners) {
        _unprocessedRouteNotifier?.removeListener(_unprocessedRouteListener!);
      }
    }

    super.dispose();
  }

  @protected
  void onNewRoute(NaviRoute unprocessedRoute) {}
}
