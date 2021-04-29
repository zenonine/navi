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

        navigationMethod == NavigationMethod.routeInformationProvider
            ? routeInformationProvider.value =
                const RouteInformation(location: '/not-exist-2')
            : context.navi.to(['/not-exist-2']);
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsOneWidget);
        context = _navigatorKey.currentContext!;
        currentLocation =
            Router.of(context).routeInformationProvider!.value!.location;
        expect(currentLocation, '/');
      });
    });
  }
}
