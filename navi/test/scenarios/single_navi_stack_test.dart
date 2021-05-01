import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:navi/navi.dart';

import '../mocks/mocks.dart';

class RootStack extends StatefulWidget {
  const RootStack({
    Key? key,
  }) : super(key: key);

  @override
  _RootStackState createState() => _RootStackState();
}

class _RootStackState extends State<RootStack> with NaviRouteMixin<RootStack> {
  bool _showChildPage = false;

  @override
  void onNewRoute(NaviRoute unprocessedRoute) {
    _showChildPage = false;
    if (unprocessedRoute.pathSegmentAt(0) == 'child') {
      _showChildPage = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return NaviStack(
      pages: (context) => [
        NaviPage.material(
          key: const ValueKey('home'),
          route: const NaviRoute(path: ['home']),
          child: const Text('home'),
        ),
        if (_showChildPage)
          NaviPage.material(
            key: const ValueKey('child'),
            route: const NaviRoute(path: ['child']),
            child: const Text('child'),
          ),
      ],
      onPopPage: (context, route, dynamic result) {},
    );
  }
}

void main() {
  setUpAll(() {
    setupLogger();
  });

  tearDown(() {
    reset(mockLogger);
  });

  for (final navigationMethod in NavigationMethod.values) {
    group('$navigationMethod', () {
      testWidgets('URL SHOULD be controlled by the nested stack',
          (tester) async {
        final routeInformationProvider = MockRouteInformationProvider();
        final _navigatorKey = GlobalKey<NavigatorState>();

        await tester.pumpWidget(MockApp(
          navigatorKey: _navigatorKey,
          routeInformationProvider: routeInformationProvider,
          child: const RootStack(),
        ));
        await tester.pumpAndSettle();

        expect(find.text('home'), findsOneWidget);
        var context = _navigatorKey.currentContext!;
        expectHistoricalRouterReports(context, ['/', '/home']);

        switch (navigationMethod) {
          case NavigationMethod.addressBar:
            naviByAddressBar(routeInformationProvider, '/child');
            break;
          case NavigationMethod.naviTo:
            context.navi.to(['child']);
            break;
          case NavigationMethod.naviRelativeTo:
            context.navi.relativeTo(['../child']);
            break;
        }
        await tester.pumpAndSettle();

        expect(find.text('child'), findsOneWidget);
        context = _navigatorKey.currentContext!;
        expectHistoricalRouterReports(context, ['/', '/home', '/child']);

        switch (navigationMethod) {
          case NavigationMethod.addressBar:
            naviByAddressBar(routeInformationProvider, '/not-exist');
            break;
          case NavigationMethod.naviTo:
            context.navi.to(['not-exist']);
            break;
          case NavigationMethod.naviRelativeTo:
            context.navi.relativeTo(['../not-exist']);
            break;
        }
        await tester.pumpAndSettle();

        expect(find.text('home'), findsOneWidget);
        expectHistoricalRouterReports(
          _navigatorKey.currentContext!,
          navigationMethod == NavigationMethod.addressBar
              ? ['/', '/home', '/child', '/not-exist', '/home']
              : ['/', '/home', '/child', '/home'],
        );
      });
    });
  }

  group('GIVEN initial route /', () {
    testWidgets('URL SHOULD be /home', (tester) async {
      final routeInformationProvider = MockRouteInformationProvider();
      final _navigatorKey = GlobalKey<NavigatorState>();

      await tester.pumpWidget(MockApp(
        navigatorKey: _navigatorKey,
        routeInformationProvider: routeInformationProvider,
        child: const RootStack(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('home'), findsOneWidget);
      expectHistoricalRouterReports(
        _navigatorKey.currentContext!,
        ['/', '/home'],
      );
    });
  });

  group('GIVEN initial route /home', () {
    testWidgets('URL SHOULD be /home', (tester) async {
      final routeInformationProvider = MockRouteInformationProvider(
        const RouteInformation(location: '/home'),
      );
      final _navigatorKey = GlobalKey<NavigatorState>();

      await tester.pumpWidget(MockApp(
        navigatorKey: _navigatorKey,
        routeInformationProvider: routeInformationProvider,
        child: const RootStack(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('home'), findsOneWidget);
      expectHistoricalRouterReports(_navigatorKey.currentContext!, ['/home']);
    });
  });

  group('GIVEN initial route /child', () {
    testWidgets('URL SHOULD be /child', (tester) async {
      final routeInformationProvider = MockRouteInformationProvider(
        const RouteInformation(location: '/child'),
      );
      final _navigatorKey = GlobalKey<NavigatorState>();

      await tester.pumpWidget(MockApp(
        navigatorKey: _navigatorKey,
        routeInformationProvider: routeInformationProvider,
        child: const RootStack(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('child'), findsOneWidget);
      expectHistoricalRouterReports(_navigatorKey.currentContext!, ['/child']);
    });
  });

  group('GIVEN initial route /not-exist', () {
    testWidgets('URL SHOULD be /home', (tester) async {
      final routeInformationProvider = MockRouteInformationProvider(
        const RouteInformation(location: '/not-exist'),
      );
      final _navigatorKey = GlobalKey<NavigatorState>();

      await tester.pumpWidget(MockApp(
        navigatorKey: _navigatorKey,
        routeInformationProvider: routeInformationProvider,
        child: const RootStack(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('home'), findsOneWidget);
      expectHistoricalRouterReports(
        _navigatorKey.currentContext!,
        ['/not-exist', '/home'],
      );
    });
  });
}
