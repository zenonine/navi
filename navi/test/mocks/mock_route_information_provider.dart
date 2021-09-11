import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:navi/src/main.dart';
import 'package:test/test.dart';

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
  void routerReportsNewRouteInformation(
    RouteInformation routeInformation, {
    bool isNavigation = true,
  }) {
    log.info('routerReportsNewRouteInformation ${routeInformation.location}');
    _value = routeInformation;
    historicalRouterReports += [routeInformation];
  }
}

void expectHistoricalRouterReports(
  BuildContext context,
  Iterable<String> historicalLocations,
) {
  final routeInformationProvider = Router.of(context).routeInformationProvider
      as MockRouteInformationProvider;
  final currentLocation = routeInformationProvider.value.location;
  expect(currentLocation, historicalLocations.last);
  expect(
    routeInformationProvider.historicalRouterReports.map((ri) => ri.location),
    orderedEquals(historicalLocations),
  );
}
