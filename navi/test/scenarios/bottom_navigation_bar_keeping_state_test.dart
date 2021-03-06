import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navi/navi.dart';

import '../mocks/mocks.dart';

enum AppTab { home, school }

class RootStack extends StatefulWidget {
  const RootStack();

  @override
  _RootStackState createState() => _RootStackState();
}

class _RootStackState extends State<RootStack> with NaviRouteMixin<RootStack> {
  int _currentIndex = AppTab.home.index;

  @override
  void onNewRoute(NaviRoute unprocessedRoute) {
    _currentIndex = unprocessedRoute.hasExactPath(['school'])
        ? AppTab.school.index
        : AppTab.home.index;
    setState(() {});
  }

  Widget _buildBody() {
    return IndexedStack(
      index: _currentIndex,
      children: [
        ...AppTab.values.mapIndexed(
          (tabIndex, tab) => NaviStack(
            active: _currentIndex == tabIndex,
            key: ValueKey(tabIndex),
            pages: (context) => [
              NaviPage.material(
                key: ValueKey(tabIndex),
                route: NaviRoute(path: [
                  if (tabIndex == AppTab.home.index) 'home' else 'school'
                ]),
                child: TextField(key: ValueKey('AppTab $tabIndex')),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'AppTab Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'AppTab School',
        ),
      ],
      onTap: (newIndex) {
        setState(() {
          _currentIndex = newIndex;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}

void _expectTabHome() {
  expect(find.text('AppTab Home'), findsOneWidget);
  expect(find.text('AppTab School'), findsOneWidget);
  expect(find.byKey(const ValueKey('AppTab 0')), findsOneWidget);
}

void _expectTabSchool() {
  expect(find.text('AppTab Home'), findsOneWidget);
  expect(find.text('AppTab School'), findsOneWidget);
  expect(find.byKey(const ValueKey('AppTab 1')), findsOneWidget);
}

void main() {
  testWidgets('initial route / SHOULD show tab home', (tester) async {
    final routeInformationProvider = MockRouteInformationProvider();
    final _navigatorKey = GlobalKey<NavigatorState>();

    await tester.pumpWidget(MockApp(
      navigatorKey: _navigatorKey,
      routeInformationProvider: routeInformationProvider,
      child: const RootStack(),
    ));
    await tester.pumpAndSettle();

    _expectTabHome();
    expectHistoricalRouterReports(
        _navigatorKey.currentContext!, ['/', '/home']);
  });

  testWidgets('initial route /home SHOULD show tab home', (tester) async {
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

    _expectTabHome();
    expectHistoricalRouterReports(_navigatorKey.currentContext!, ['/home']);
  });

  testWidgets('initial route /school SHOULD show tab school', (tester) async {
    final routeInformationProvider = MockRouteInformationProvider(
      const RouteInformation(location: '/school'),
    );
    final _navigatorKey = GlobalKey<NavigatorState>();

    await tester.pumpWidget(MockApp(
      navigatorKey: _navigatorKey,
      routeInformationProvider: routeInformationProvider,
      child: const RootStack(),
    ));
    await tester.pumpAndSettle();

    _expectTabSchool();
    expectHistoricalRouterReports(_navigatorKey.currentContext!, ['/school']);
  });

  testWidgets(
      'initial route /school SHOULD show tab school.'
      ' Then enter text "Text 1".'
      ' Then tap Home tab SHOULD show tab Home.'
      ' Then enter text "Text 0".'
      ' Then tap School tab SHOULD show tab school with the text "Text 1".'
      ' Then tap Home tab SHOULD show tab home with the text "Text 0".',
      (tester) async {
    final routeInformationProvider = MockRouteInformationProvider(
      const RouteInformation(location: '/school'),
    );
    final _navigatorKey = GlobalKey<NavigatorState>();

    await tester.pumpWidget(MockApp(
      navigatorKey: _navigatorKey,
      routeInformationProvider: routeInformationProvider,
      child: const RootStack(),
    ));
    await tester.pumpAndSettle();
    _expectTabSchool();
    expect(find.widgetWithText(TextField, ''), findsNWidgets(2));
    expect(find.widgetWithText(TextField, 'Text 0'), findsNothing);
    expect(find.widgetWithText(TextField, 'Text 1'), findsNothing);
    expectHistoricalRouterReports(_navigatorKey.currentContext!, ['/school']);

    await tester.enterText(find.byKey(const ValueKey('AppTab 1')), 'Text 1');
    await tester.pumpAndSettle();
    _expectTabSchool();
    expect(find.widgetWithText(TextField, ''), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Text 0'), findsNothing);
    expect(find.widgetWithText(TextField, 'Text 1'), findsOneWidget);

    await tester.tap(find.text('AppTab Home'));
    await tester.pumpAndSettle();
    _expectTabHome();
    expect(find.widgetWithText(TextField, ''), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Text 0'), findsNothing);
    expect(find.widgetWithText(TextField, 'Text 1'), findsOneWidget);
    expectHistoricalRouterReports(
      _navigatorKey.currentContext!,
      ['/school', '/home'],
    );

    await tester.enterText(find.byKey(const ValueKey('AppTab 0')), 'Text 0');
    await tester.pumpAndSettle();
    _expectTabHome();
    expect(find.widgetWithText(TextField, ''), findsNothing);
    expect(find.widgetWithText(TextField, 'Text 0'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Text 1'), findsOneWidget);

    await tester.tap(find.text('AppTab School'));
    await tester.pumpAndSettle();
    _expectTabSchool();
    expect(find.widgetWithText(TextField, ''), findsNothing);
    expect(find.widgetWithText(TextField, 'Text 0'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Text 1'), findsOneWidget);
    expectHistoricalRouterReports(
      _navigatorKey.currentContext!,
      ['/school', '/home', '/school'],
    );

    await tester.tap(find.text('AppTab Home'));
    await tester.pumpAndSettle();
    _expectTabHome();
    expect(find.widgetWithText(TextField, ''), findsNothing);
    expect(find.widgetWithText(TextField, 'Text 0'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Text 1'), findsOneWidget);
    expectHistoricalRouterReports(
      _navigatorKey.currentContext!,
      ['/school', '/home', '/school', '/home'],
    );
  });
}
