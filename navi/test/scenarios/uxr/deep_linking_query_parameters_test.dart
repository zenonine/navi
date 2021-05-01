import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:navi/navi.dart';

import '../../mocks/mocks.dart';

class BooksStack extends StatefulWidget {
  const BooksStack();

  @override
  _BooksStackState createState() => _BooksStackState();
}

class _BooksStackState extends State<BooksStack>
    with NaviRouteMixin<BooksStack> {
  String? filter;

  @override
  void onNewRoute(NaviRoute unprocessedRoute) {
    filter = unprocessedRoute.queryParams['filter']?.firstOrNull?.trim();
  }

  @override
  Widget build(BuildContext context) {
    return NaviStack(
      pages: (context) => [
        NaviPage.material(
          key: const ValueKey('Books'),
          route: NaviRoute(
              queryParams: filter?.isNotEmpty == true
                  ? {
                      'filter': [filter!]
                    }
                  : {}),
          child: BooksPagelet(filter: filter),
        ),
      ],
    );
  }
}

class BooksPagelet extends StatelessWidget {
  BooksPagelet({this.filter});

  final String? filter;
  late final _controller = TextEditingController(text: filter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          onSubmitted: (filter) {
            context.navi.relativeTo([], queryParams: {
              'filter': [filter]
            });
          },
        ),
      ),
      body: ListView(
        children: [
          ...bookstoreService.getBooks(filter).map(
                (book) => ListTile(
                  title: Text('Book ${book.id}'),
                ),
              )
        ],
      ),
    );
  }
}

void _expectBooks(List<int> ids) {
  expect(find.text('Book 0'), ids.contains(0) ? findsOneWidget : findsNothing);
  expect(find.text('Book 1'), ids.contains(1) ? findsOneWidget : findsNothing);
  expect(find.text('Book 2'), ids.contains(2) ? findsOneWidget : findsNothing);
}

void main() {
  setUpAll(() {
    setupLogger();
  });

  tearDown(() {
    reset(mockLogger);
  });

  const initialRoutes = {
    '': {
      'ids': [0, 1, 2],
      'route': ['', '/'],
    },
    '/': {
      'ids': [0, 1, 2],
      'route': ['/'],
    },
    '/?filter=': {
      'ids': [0, 1, 2],
      'route': ['/?filter=', '/'],
    },
    '/?filter=  ': {
      'ids': [0, 1, 2],
      'route': ['/?filter=  ', '/'],
    },
    '/?filter=RA': {
      'ids': [0, 2],
      'route': ['/?filter=RA'],
    },
    '/?filter=land': {
      'ids': [0],
      'route': ['/?filter=land'],
    },
    '/?filter= land ': {
      'ids': [0],
      'route': ['/?filter= land ', '/?filter=land'],
    },
    '/?filter=not-exist': {
      'ids': <int>[],
      'route': ['/?filter=not-exist'],
    },
  };

  for (final initialRoute in initialRoutes.entries) {
    final expectedBookIds = initialRoute.value['ids'] as List<int>;
    final expectedRoutes = initialRoute.value['route'] as List<String>;

    testWidgets('${initialRoute.key} SHOULD show only books $expectedBookIds',
        (tester) async {
      final routeInformationProvider = MockRouteInformationProvider(
        RouteInformation(location: initialRoute.key),
      );
      final navigatorKey = GlobalKey<NavigatorState>();

      await tester.pumpWidget(MockApp(
        navigatorKey: navigatorKey,
        routeInformationProvider: routeInformationProvider,
        child: const BooksStack(),
      ));
      await tester.pumpAndSettle();

      _expectBooks(expectedBookIds);
      expectHistoricalRouterReports(
        navigatorKey.currentContext!,
        expectedRoutes,
      );
    });
  }

  testWidgets(
      'initial route "/" then submit text "heit"'
      ' SHOULD change from books [0, 1, 2] to [2]', (tester) async {
    const initialRoute = '/';
    const expectInitialBookIds = [0, 1, 2];
    const submitText = ' heit ';
    const expectNewBookIds = [2];
    const expectNewRoute = '/?filter=heit';

    final routeInformationProvider = MockRouteInformationProvider(
      const RouteInformation(location: initialRoute),
    );
    final navigatorKey = GlobalKey<NavigatorState>();

    await tester.pumpWidget(MockApp(
      navigatorKey: navigatorKey,
      routeInformationProvider: routeInformationProvider,
      child: const BooksStack(),
    ));
    await tester.pumpAndSettle();

    _expectBooks(expectInitialBookIds);
    expectHistoricalRouterReports(
      navigatorKey.currentContext!,
      [initialRoute],
    );

    await tester.enterText(find.byType(TextField), submitText);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    _expectBooks(expectNewBookIds);
    expectHistoricalRouterReports(
      navigatorKey.currentContext!,
      [initialRoute, expectNewRoute],
    );
  });

  testWidgets(
      'initial route "/?filter=land" then submit text "heit"'
      ' SHOULD change from books [0] to [2]', (tester) async {
    const initialRoute = '/?filter=land';
    const expectInitialBookIds = [0];
    const submitText = ' heit ';
    const expectNewBookIds = [2];
    const expectNewRoute = '/?filter=heit';

    final routeInformationProvider = MockRouteInformationProvider(
      const RouteInformation(location: initialRoute),
    );
    final navigatorKey = GlobalKey<NavigatorState>();

    await tester.pumpWidget(MockApp(
      navigatorKey: navigatorKey,
      routeInformationProvider: routeInformationProvider,
      child: const BooksStack(),
    ));
    await tester.pumpAndSettle();

    _expectBooks(expectInitialBookIds);
    expectHistoricalRouterReports(
      navigatorKey.currentContext!,
      [initialRoute],
    );

    await tester.enterText(find.byType(TextField), submitText);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    _expectBooks(expectNewBookIds);
    expectHistoricalRouterReports(
      navigatorKey.currentContext!,
      [initialRoute, expectNewRoute],
    );
  });
}
