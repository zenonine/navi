import 'package:flutter/widgets.dart';

import 'mocks.dart';

enum NavigationMethod { addressBar, naviTo, naviRelativeTo }

void naviByAddressBar(
    MockRouteInformationProvider routeInformationProvider, String location) {
  routeInformationProvider.value = RouteInformation(location: location);
}
