import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navi/navi.dart';

import '../mocks/mocks.dart';

void main() {
  for (final navigationMethod in NavigationMethod.values) {
    group('$navigationMethod', () {
      testWidgets('URL SHOULD always be "/"', (tester) async {
        final routeInformationProvider = MockRouteInformationProvider(
          const RouteInformation(location: '/not-exist-1'),
        );
        final _navigatorKey = GlobalKey<NavigatorState>();

        await tester.pumpWidget(MockApp(
          navigatorKey: _navigatorKey,
          routeInformationProvider: routeInformationProvider,
          child: const Text('Home'),
        ));
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsOneWidget);
        var context = _navigatorKey.currentContext!;
        var currentLocation =
            Router.of(context).routeInformationProvider!.value!.location;
        expect(currentLocation, '/');
        expect(
          routeInformationProvider.historicalRouterReports
              .map((e) => e.location),
          orderedEquals(<String>['/not-exist-1', '/']),
        );

        switch (navigationMethod) {
          case NavigationMethod.addressBar:
            naviByAddressBar(routeInformationProvider, '/not-exist-2');
            break;
          case NavigationMethod.naviTo:
            context.navi.to(['/not-exist-3']);
            break;
          case NavigationMethod.naviRelativeTo:
            context.navi.relativeTo(['/not-exist-4']);
            break;
        }
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsOneWidget);
        context = _navigatorKey.currentContext!;
        currentLocation =
            Router.of(context).routeInformationProvider!.value!.location;
        expect(currentLocation, '/');
        expect(
          routeInformationProvider.historicalRouterReports
              .map((e) => e.location),
          orderedEquals(navigationMethod == NavigationMethod.addressBar
              ? <String>['/not-exist-1', '/', '/not-exist-2', '/']
              : <String>['/not-exist-1', '/']),
        );
      });
    });
  }
}