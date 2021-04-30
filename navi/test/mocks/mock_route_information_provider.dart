import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:navi/src/main.dart';

class MockRouteInformationProvider extends RouteInformationProvider
    with ChangeNotifier, Diagnosticable {
  MockRouteInformationProvider([
    RouteInformation initialRouteInfo = const RouteInformation(location: '/'),
  ]) : _value = initialRouteInfo {
    routerReportsNewRouteInformation(_value);
  }

  late final log = logger(this);

  RouteInformation _value;

  @override
  RouteInformation get value => _value;

  set value(RouteInformation newValue) {
    _value = newValue;
    routerReportsNewRouteInformation(_value);
    notifyListeners();
  }

  List<RouteInformation> historicalRouterReports = [];

  @override
  void routerReportsNewRouteInformation(RouteInformation routeInformation) {
    log.info('routerReportsNewRouteInformation ${routeInformation.location}');
    _value = routeInformation;
    historicalRouterReports += [routeInformation];
  }
}
