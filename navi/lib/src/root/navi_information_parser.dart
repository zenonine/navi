import 'package:flutter/widgets.dart';

import '../main.dart';

class NaviInformationParser extends RouteInformationParser<RouteInfo> {
  @override
  Future<RouteInfo> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location ?? '');
    return RouteInfo.fromUri(uri);
  }

  @override
  RouteInformation restoreRouteInformation(RouteInfo routeInfo) {
    final location = Uri.decodeComponent(routeInfo.uri.toString());
    return RouteInformation(location: location);
  }
}
