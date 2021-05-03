import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:navi/navi.dart';

import '../../mocks/mocks.dart';

enum RootPageId { books, authors }

class RootStack extends StatefulWidget {
  const RootStack();

  @override
  _RootStackState createState() => _RootStackState();
}

class _RootStackState extends State<RootStack> with NaviRouteMixin<RootStack> {
  RootPageId _pageId = RootPageId.books;

  @override
  void onNewRoute(NaviRoute unprocessedRoute) {
    _pageId = unprocessedRoute.hasPrefixes(['authors'])
        ? RootPageId.authors
        : RootPageId.books;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return NaviStack(
      pages: (context) {
        switch (_pageId) {
          case RootPageId.authors:
            return [
              NaviPage.material(
                key: const ValueKey('Authors'),
                route: const NaviRoute(path: ['authors']),
                child: AuthorsStack(),
              )
            ];
          case RootPageId.books:
          default:
            return [
              NaviPage.material(
                key: const ValueKey('Books'),
                route: const NaviRoute(path: ['books']),
                child: BooksStack(),
              )
            ];
        }
      },
    );
  }
}

class BooksStack extends StatefulWidget {
  @override
  _BooksStackState createState() => _BooksStackState();
}

class _BooksStackState extends State<BooksStack>
    with NaviRouteMixin<BooksStack> {
  final _bookstoreService = get<BookstoreService>();
  Book? _selectedBook;

  @override
  void onNewRoute(NaviRoute unprocessedRoute) {
    final bookId = int.tryParse(unprocessedRoute.pathSegmentAt(0) ?? '');
    _selectedBook = _bookstoreService.getBook(bookId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return NaviStack(
      pages: (context) => [
        NaviPage.material(
          key: const ValueKey('Books'),
          child: BooksPagelet(
            onSelectBook: (book) => setState(() {
              _selectedBook = book;
            }),
          ),
        ),
        if (_selectedBook != null)
          NaviPage.material(
            key: ValueKey(_selectedBook),
            route: NaviRoute(path: ['${_selectedBook!.id}']),
            child: BookPagelet(book: _selectedBook!),
          ),
      ],
      onPopPage: (context, route, dynamic result) {
        if (_selectedBook != null) {
          setState(() {
            _selectedBook = null;
          });
        }
      },
    );
  }
}

class BooksPagelet extends StatelessWidget {
  const BooksPagelet({required this.onSelectBook});

  final ValueChanged<Book> onSelectBook;

  @override
  Widget build(BuildContext context) {
    final bookstoreService = get<BookstoreService>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppBar BooksPagelet'),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () => context.navi.to(['authors']),
              child: const Text('Go to AuthorsPagelet')),
          Expanded(
            child: ListView(
              children: [
                ...bookstoreService.getBooks().map(
                      (book) => ListTile(
                        title: Text('Go to Book ${book.id}'),
                        onTap: () => onSelectBook(book),
                      ),
                    )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class BookPagelet extends StatelessWidget {
  const BookPagelet({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppBar BookPagelet'),
      ),
      body: Column(
        children: [
          Text('Book ${book.id}'),
          ElevatedButton(
            onPressed: () => context.navi.to(['authors', '${book.authorId}']),
            child: Text('Go to Author ${book.authorId}'),
          ),
        ],
      ),
    );
  }
}

class AuthorsStack extends StatefulWidget {
  @override
  _AuthorsStackState createState() => _AuthorsStackState();
}

class _AuthorsStackState extends State<AuthorsStack>
    with NaviRouteMixin<AuthorsStack> {
  final _bookstoreService = get<BookstoreService>();
  Author? _selectedAuthor;

  @override
  void onNewRoute(NaviRoute unprocessedRoute) {
    final authorId = int.tryParse(unprocessedRoute.pathSegmentAt(0) ?? '');
    _selectedAuthor = _bookstoreService.getAuthor(authorId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return NaviStack(
      pages: (context) => [
        NaviPage.material(
          key: const ValueKey('Authors'),
          child: const AuthorsPagelet(),
        ),
        if (_selectedAuthor != null)
          NaviPage.material(
            key: ValueKey(_selectedAuthor),
            route: NaviRoute(path: ['${_selectedAuthor!.id}']),
            child: AuthorPagelet(author: _selectedAuthor!),
          ),
      ],
      onPopPage: (context, route, dynamic result) {
        if (_selectedAuthor != null) {
          setState(() {
            _selectedAuthor = null;
          });
        }
      },
    );
  }
}

class AuthorsPagelet extends StatelessWidget {
  const AuthorsPagelet();

  @override
  Widget build(BuildContext context) {
    final bookstoreService = get<BookstoreService>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppBar AuthorsPagelet'),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () => context.navi.to(['books']),
              child: const Text('Go to BooksPagelet')),
          Expanded(
            child: ListView(
              children: [
                ...bookstoreService.getAuthors().map(
                      (author) => ListTile(
                        title: Text('Go to Author ${author.id}'),
                        onTap: () => context.navi.relativeTo(['${author.id}']),
                      ),
                    ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AuthorPagelet extends StatelessWidget {
  const AuthorPagelet({required this.author});

  final Author author;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppBar AuthorPagelet'),
      ),
      body: Text('Author ${author.id}'),
    );
  }
}

void _expectBooksPagelet() {
  expect(find.text('AppBar BooksPagelet'), findsOneWidget);
  expect(find.text('Go to AuthorsPagelet'), findsOneWidget);
  expect(find.text('Go to Book 0'), findsOneWidget);
  expect(find.text('Go to Book 1'), findsOneWidget);
  expect(find.text('Go to Book 2'), findsOneWidget);
  expect(find.text('Go to Book 3'), findsNothing);
}

void _expectBookPagelet({required int bookId, required int authorId}) {
  expect(find.text('AppBar BookPagelet'), findsOneWidget);
  expect(find.text('Book $bookId'), findsOneWidget);
  expect(find.text('Go to Author $authorId'), findsOneWidget);
}

void _expectAuthorsPagelet() {
  expect(find.text('AppBar AuthorsPagelet'), findsOneWidget);
  expect(find.text('Go to BooksPagelet'), findsOneWidget);
  expect(find.text('Go to Author 0'), findsOneWidget);
  expect(find.text('Go to Author 1'), findsNothing);
  expect(find.text('Go to Author 2'), findsOneWidget);
  expect(find.text('Go to Author 3'), findsOneWidget);
  expect(find.text('Go to Author 4'), findsNothing);
}

void _expectAuthorPagelet(int authorId) {
  expect(find.text('AppBar AuthorPagelet'), findsOneWidget);
  expect(find.text('Author $authorId'), findsOneWidget);
}

void main() {
  setUpAll(() {
    setupLogger();
  });

  setUp(() {
    get.registerLazySingleton(() => const BookstoreService());
  });

  tearDown(() async {
    reset(mockLogger);
    await get.reset();
  });

  testWidgets('initial route /books SHOULD show BooksPagelet', (tester) async {
    final routeInformationProvider = MockRouteInformationProvider(
      const RouteInformation(location: '/books'),
    );
    final _navigatorKey = GlobalKey<NavigatorState>();

    await tester.pumpWidget(MockApp(
      navigatorKey: _navigatorKey,
      routeInformationProvider: routeInformationProvider,
      child: const RootStack(),
    ));
    await tester.pumpAndSettle();

    _expectBooksPagelet();
    expectHistoricalRouterReports(
      _navigatorKey.currentContext!,
      ['/books'],
    );
  });

  testWidgets('initial route / SHOULD show BooksPagelet', (tester) async {
    final routeInformationProvider = MockRouteInformationProvider();
    final _navigatorKey = GlobalKey<NavigatorState>();

    await tester.pumpWidget(MockApp(
      navigatorKey: _navigatorKey,
      routeInformationProvider: routeInformationProvider,
      child: const RootStack(),
    ));
    await tester.pumpAndSettle();

    _expectBooksPagelet();
    expectHistoricalRouterReports(
      _navigatorKey.currentContext!,
      ['/', '/books'],
    );
  });

  testWidgets('initial route /books/3 SHOULD show BooksPagelet',
      (tester) async {
    final routeInformationProvider = MockRouteInformationProvider(
      const RouteInformation(location: '/books/3'),
    );
    final _navigatorKey = GlobalKey<NavigatorState>();

    await tester.pumpWidget(MockApp(
      navigatorKey: _navigatorKey,
      routeInformationProvider: routeInformationProvider,
      child: const RootStack(),
    ));
    await tester.pumpAndSettle();

    _expectBooksPagelet();
    expectHistoricalRouterReports(
      _navigatorKey.currentContext!,
      ['/books/3', '/books'],
    );
  });

  for (final idMap in <int, int>{0: 0, 1: 2, 2: 3}.entries) {
    final bookId = idMap.key;
    final authorId = idMap.value;
    final initialRoute = '/books/$bookId';
    testWidgets('initial route $initialRoute SHOULD show BookPagelet $bookId',
        (tester) async {
      final routeInformationProvider = MockRouteInformationProvider(
        RouteInformation(location: initialRoute),
      );
      final _navigatorKey = GlobalKey<NavigatorState>();

      await tester.pumpWidget(MockApp(
        navigatorKey: _navigatorKey,
        routeInformationProvider: routeInformationProvider,
        child: const RootStack(),
      ));
      await tester.pumpAndSettle();

      _expectBookPagelet(bookId: bookId, authorId: authorId);
      expectHistoricalRouterReports(
        _navigatorKey.currentContext!,
        [initialRoute],
      );
    });
  }

  testWidgets('initial route /authors SHOULD show AuthorsPagelet',
      (tester) async {
    final routeInformationProvider = MockRouteInformationProvider(
      const RouteInformation(location: '/authors'),
    );
    final _navigatorKey = GlobalKey<NavigatorState>();

    await tester.pumpWidget(MockApp(
      navigatorKey: _navigatorKey,
      routeInformationProvider: routeInformationProvider,
      child: const RootStack(),
    ));
    await tester.pumpAndSettle();

    _expectAuthorsPagelet();
    expectHistoricalRouterReports(
      _navigatorKey.currentContext!,
      ['/authors'],
    );
  });

  for (final authorId in [0, 2, 3]) {
    final initialRoute = '/authors/$authorId';
    testWidgets(
        'initial route $initialRoute SHOULD show AuthorPagelet $authorId',
        (tester) async {
      final routeInformationProvider = MockRouteInformationProvider(
        RouteInformation(location: initialRoute),
      );
      final _navigatorKey = GlobalKey<NavigatorState>();

      await tester.pumpWidget(MockApp(
        navigatorKey: _navigatorKey,
        routeInformationProvider: routeInformationProvider,
        child: const RootStack(),
      ));
      await tester.pumpAndSettle();

      _expectAuthorPagelet(authorId);
      expectHistoricalRouterReports(
        _navigatorKey.currentContext!,
        [initialRoute],
      );
    });
  }

  testWidgets('initial route /authors/1 SHOULD show AuthorsPagelet',
      (tester) async {
    final routeInformationProvider = MockRouteInformationProvider(
      const RouteInformation(location: '/authors/1'),
    );
    final _navigatorKey = GlobalKey<NavigatorState>();

    await tester.pumpWidget(MockApp(
      navigatorKey: _navigatorKey,
      routeInformationProvider: routeInformationProvider,
      child: const RootStack(),
    ));
    await tester.pumpAndSettle();

    _expectAuthorsPagelet();
    expectHistoricalRouterReports(
      _navigatorKey.currentContext!,
      ['/authors/1', '/authors'],
    );
  });

  for (final idMap in <int, int>{0: 0, 1: 2, 2: 3}.entries) {
    final bookId = idMap.key;
    final authorId = idMap.value;
    final initialRoute = '/books/$bookId';

    testWidgets(
      'from $initialRoute,'
      ' tap "Go to Author $authorId" SHOULD show AuthorPagelet $authorId',
      (tester) async {
        final routeInformationProvider = MockRouteInformationProvider(
          RouteInformation(location: initialRoute),
        );
        final _navigatorKey = GlobalKey<NavigatorState>();

        await tester.pumpWidget(MockApp(
          navigatorKey: _navigatorKey,
          routeInformationProvider: routeInformationProvider,
          child: const RootStack(),
        ));
        await tester.pumpAndSettle();

        _expectBookPagelet(bookId: bookId, authorId: authorId);
        expectHistoricalRouterReports(
          _navigatorKey.currentContext!,
          [initialRoute],
        );

        await tester.tap(find.text('Go to Author $authorId'));
        await tester.pumpAndSettle();

        _expectAuthorPagelet(authorId);
        expectHistoricalRouterReports(
          _navigatorKey.currentContext!,
          [initialRoute, '/authors/$authorId'],
        );
      },
    );
  }
}
