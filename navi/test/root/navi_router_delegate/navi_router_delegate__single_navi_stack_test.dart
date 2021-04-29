import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navi/navi.dart';

import 'mock_app.dart';
import 'mock_route_information_provider.dart';

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
  testWidgets('URL SHOULD be controlled by the nested stack', (tester) async {
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
    var currentLocation =
        Router.of(context).routeInformationProvider!.value!.location;
    expect(currentLocation, '/home');

    routeInformationProvider.value = const RouteInformation(location: '/child');
    await tester.pumpAndSettle();

    expect(find.text('child'), findsOneWidget);
    context = _navigatorKey.currentContext!;
    currentLocation =
        Router.of(context).routeInformationProvider!.value!.location;
    expect(currentLocation, '/child');

    routeInformationProvider.value =
        const RouteInformation(location: '/not-exist');
    await tester.pumpAndSettle();

    expect(find.text('home'), findsOneWidget);
    context = _navigatorKey.currentContext!;
    currentLocation =
        Router.of(context).routeInformationProvider!.value!.location;
    expect(currentLocation, '/home');
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
      final context = _navigatorKey.currentContext!;
      final currentLocation =
          Router.of(context).routeInformationProvider!.value!.location;
      expect(currentLocation, '/child');
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
      final context = _navigatorKey.currentContext!;
      final currentLocation =
          Router.of(context).routeInformationProvider!.value!.location;
      expect(currentLocation, '/home');
    });
  });
}
