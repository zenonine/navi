import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:navi/navi.dart';

import '../mocks/mocks.dart';

void main() {
  setUpAll(() {
    setupLogger();
  });

  tearDown(() {
    reset(mockLogger);
  });

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
        final context = _navigatorKey.currentContext!;
        expectHistoricalRouterReports(
          context,
          ['/not-exist-1', '/'],
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
        expectHistoricalRouterReports(
          _navigatorKey.currentContext!,
          navigationMethod == NavigationMethod.addressBar
          // Invalid URL coming from address bar should always appeared in history
          // While invalid URL by navigating programmatically could be removed from history
              ? <String>['/not-exist-1', '/', '/not-exist-2', '/']
              : <String>['/not-exist-1', '/'],
        );
      });
    });
  }
}
