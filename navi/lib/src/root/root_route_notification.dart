import 'package:flutter/widgets.dart';
import 'package:navi/src/common/navi_route.dart';

// TODO: merge routes strategies: https://angular.io/api/router/UrlCreationOptions#queryParamsHandling

class RootRouteNotification extends Notification {
  const RootRouteNotification({required this.route, this.relative = false});

  final NaviRoute route;
  final bool relative;

  @override
  String toString() {
    return 'RootRouteNotification{route: $route, relative: $relative}';
  }
}
