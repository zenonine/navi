import 'package:flutter/widgets.dart';
import 'package:navi/src/common/navi_route.dart';

class RootRouteNotification extends Notification {
  const RootRouteNotification({required this.route});

  final NaviRoute route;

  @override
  String toString() {
    return 'RootRouteNotification{route: $route}';
  }
}
