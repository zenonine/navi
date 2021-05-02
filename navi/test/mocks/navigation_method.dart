import 'package:flutter/widgets.dart';

import 'mocks.dart';

enum NavigationMethod {
  addressBar,
  naviTo,
  naviRelativeTo,
  naviToRoute,
  naviRelativeToRoute,
}

void naviByAddressBar(
    MockRouteInformationProvider routeInformationProvider, String location) {
  routeInformationProvider.value = RouteInformation(location: location);
}
