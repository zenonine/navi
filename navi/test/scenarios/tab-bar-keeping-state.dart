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

class _RootStackState extends State<RootStack>
    with SingleTickerProviderStateMixin, NaviRouteMixin<RootStack> {
  int _currentIndex = AppTab.home.index;

  late final TabController _tabController = TabController(
    length: 2,
    vsync: this,
  );

  @override
  void initState() {
    super.initState();

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void onNewRoute(NaviRoute unprocessedRoute) {
    _currentIndex = unprocessedRoute.hasExactPath(['school'])
        ? AppTab.school.index
        : AppTab.home.index;
    _tabController.animateTo(_currentIndex);
    setState(() {});
  }

  AppBar _buildAppBar() {
    return AppBar(
      bottom: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(
            icon: Icon(Icons.home),
            text: 'AppTab Home',
          ),
          Tab(
            icon: Icon(Icons.school),
            text: 'AppTab School',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return TabBarView(
      controller: _tabController,
      children: [
        // IMPORTANT: only one stack should be activated
        TabStack(
          active: _currentIndex == AppTab.home.index,
          tab: AppTab.home,
        ),
        TabStack(
          active: _currentIndex == AppTab.school.index,
          tab: AppTab.school,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }
}

class TabStack extends StatefulWidget {
  const TabStack({required this.active, required this.tab});

  final bool active;
  final AppTab tab;

  @override
  _TabStackState createState() => _TabStackState();
}

class _TabStackState extends State<TabStack>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NaviStack(
      active: widget.active,
      pages: (context) => [
        NaviPage.material(
          key: ValueKey(widget.tab.index),
          route: NaviRoute(
              path: [if (widget.tab == AppTab.home) 'home' else 'school']),
          child: TextField(key: ValueKey('AppTab ${widget.tab.index}')),
        )
      ],
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
    expect(find.widgetWithText(TextField, ''), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Text 0'), findsNothing);
    expect(find.widgetWithText(TextField, 'Text 1'), findsNothing);
    expectHistoricalRouterReports(_navigatorKey.currentContext!, ['/school']);

    await tester.enterText(find.byKey(const ValueKey('AppTab 1')), 'Text 1');
    await tester.pumpAndSettle();
    _expectTabSchool();
    expect(find.widgetWithText(TextField, ''), findsNothing);
    expect(find.widgetWithText(TextField, 'Text 0'), findsNothing);
    expect(find.widgetWithText(TextField, 'Text 1'), findsOneWidget);

    await tester.tap(find.text('AppTab Home'));
    await tester.pumpAndSettle();
    _expectTabHome();
    expect(find.widgetWithText(TextField, ''), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Text 0'), findsNothing);
    expect(find.widgetWithText(TextField, 'Text 1'), findsNothing);
    expectHistoricalRouterReports(
      _navigatorKey.currentContext!,
      ['/school', '/home'],
    );

    await tester.enterText(find.byKey(const ValueKey('AppTab 0')), 'Text 0');
    await tester.pumpAndSettle();
    _expectTabHome();
    expect(find.widgetWithText(TextField, ''), findsNothing);
    expect(find.widgetWithText(TextField, 'Text 0'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Text 1'), findsNothing);

    await tester.tap(find.text('AppTab School'));
    await tester.pumpAndSettle();
    _expectTabSchool();
    expect(find.widgetWithText(TextField, ''), findsNothing);
    expect(find.widgetWithText(TextField, 'Text 0'), findsNothing);
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
    expect(find.widgetWithText(TextField, 'Text 1'), findsNothing);
    expectHistoricalRouterReports(
      _navigatorKey.currentContext!,
      ['/school', '/home', '/school', '/home'],
    );
  });
}
