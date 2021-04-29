import 'package:flutter/widgets.dart';

class MockRouteInformationProvider extends RouteInformationProvider
    with ChangeNotifier {
  MockRouteInformationProvider([
    RouteInformation initialRouteInfo = const RouteInformation(location: '/'),
  ]) : _value = initialRouteInfo;

  RouteInformation _value;

  @override
  RouteInformation get value => _value;

  set value(RouteInformation newValue) {
    _value = newValue;
    notifyListeners();
  }

  @override
  void routerReportsNewRouteInformation(RouteInformation routeInformation) {
    _value = routeInformation;
  }
}
