import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:navi/navi.dart';

import '../../mocks/mocks.dart';

class RootStack extends StatefulWidget {
  const RootStack();

  @override
  _RootStackState createState() => _RootStackState();
}

class _RootStackState extends State<RootStack> with NaviRouteMixin<RootStack> {
  final _authService = get<AuthService>();
  late final VoidCallback _authListener;

  @override
  void initState() {
    super.initState();
    _authListener = () => setState(() {});
    _authService.addListener(_authListener);
  }

  @override
  void dispose() {
    _authService.removeListener(_authListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NaviStack(
      pages: (context) => [
        if (_authService.authenticated)
          NaviPage.material(
            key: const ValueKey('Protected'),
            route: const NaviRoute(path: ['protected']),
            child: const ProtectedStack(),
          )
        else
          NaviPage.material(
            key: const ValueKey('Auth'),
            route: const NaviRoute(path: ['auth']),
            child: ElevatedButton(
              onPressed: () => _authService.login(),
              child: const Text('Login'),
            ),
          ),
      ],
    );
  }
}

class ProtectedStack extends StatefulWidget {
  const ProtectedStack();

  @override
  _ProtectedStackState createState() => _ProtectedStackState();
}

class _ProtectedStackState extends State<ProtectedStack>
    with NaviRouteMixin<ProtectedStack> {
  bool _showNews = false;

  @override
  void onNewRoute(NaviRoute unprocessedRoute) {
    _showNews = unprocessedRoute.pathSegmentAt(0) == 'news';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return NaviStack(
      pages: (context) => [
        NaviPage.material(
          key: const ValueKey('home'),
          route: const NaviRoute(path: ['home']),
          child: const Text('Protected Home'),
        ),
        if (_showNews)
          NaviPage.material(
            key: const ValueKey('news'),
            route: const NaviRoute(path: ['news']),
            child: const Text('Protected News'),
          ),
      ],
    );
  }
}

void main() {
  setUpAll(() {
    setupLogger();
  });

  setUp(() {
    get.registerLazySingleton(() => AuthService());
  });

  tearDown(() async {
    reset(mockLogger);
    await get.reset();
  });

  testWidgets(
      'Open /protected/home without authenticated SHOULD redirect to /auth.'
      ' Then click Login SHOULD redirect to /protected/home', (tester) async {
    final routeInformationProvider = MockRouteInformationProvider(
      const RouteInformation(location: '/protected/home'),
    );
    final _navigatorKey = GlobalKey<NavigatorState>();

    await tester.pumpWidget(MockApp(
      navigatorKey: _navigatorKey,
      routeInformationProvider: routeInformationProvider,
      child: const RootStack(),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Protected Home'), findsNothing);
    expect(find.text('Protected News'), findsNothing);
    expect(find.text('Login'), findsOneWidget);
    expectHistoricalRouterReports(
      _navigatorKey.currentContext!,
      ['/protected/home', '/auth'],
    );

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    expect(find.text('Protected Home'), findsOneWidget);
    expect(find.text('Protected News'), findsNothing);
    expect(find.text('Login'), findsNothing);
    expectHistoricalRouterReports(
      _navigatorKey.currentContext!,
      ['/protected/home', '/auth', '/protected/home'],
    );
  });

  testWidgets(
    'Open /protected/news without authenticated SHOULD redirect to /auth.'
    ' Then click Login SHOULD redirect to /protected/news',
    (tester) async {
      final routeInformationProvider = MockRouteInformationProvider(
        const RouteInformation(location: '/protected/news'),
      );
      final _navigatorKey = GlobalKey<NavigatorState>();

      await tester.pumpWidget(MockApp(
        navigatorKey: _navigatorKey,
        routeInformationProvider: routeInformationProvider,
        child: const RootStack(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Protected Home'), findsNothing);
      expect(find.text('Protected News'), findsNothing);
      expect(find.text('Login'), findsOneWidget);
      expectHistoricalRouterReports(
        _navigatorKey.currentContext!,
        ['/protected/news', '/auth'],
      );

      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.text('Protected Home'), findsNothing);
      expect(find.text('Protected News'), findsOneWidget);
      expect(find.text('Login'), findsNothing);
      expectHistoricalRouterReports(
        _navigatorKey.currentContext!,
        ['/protected/news', '/auth', '/protected/news'],
      );
    },
    skip: true, // TODO: implement and call context.navi.back() after login!
  );
}
