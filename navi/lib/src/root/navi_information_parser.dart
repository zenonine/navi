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
  RouteInformation restoreRouteInformation(RouteInfo configuration) {
    final location = Uri.decodeComponent(configuration.uri.toString());
    return RouteInformation(location: location);
  }
}
