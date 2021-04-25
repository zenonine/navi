import 'package:flutter/widgets.dart';

import '../main.dart';

class NaviInformationParser extends RouteInformationParser<NaviRoute> {
  @override
  Future<NaviRoute> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location ?? '');
    return NaviRoute.fromUri(uri);
  }

  @override
  RouteInformation restoreRouteInformation(NaviRoute configuration) {
    final location = Uri.decodeComponent(configuration.uri.toString());
    return RouteInformation(location: location);
  }
}
