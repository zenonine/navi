import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navi/navi.dart';

import '../../mocks/mocks.dart';

class Book {
  const Book({required this.id, required this.title, required this.author});

  final int id;
  final String title;
  final String author;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Book && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Book{title: $title, author: $author}';
  }
}

const List<Book> books = [
  Book(
    id: 0,
    title: 'Stranger in a Strange Land',
    author: 'Robert A. Heinlein',
  ),
  Book(
    id: 1,
    title: 'Foundation',
    author: 'Isaac Asimov',
  ),
  Book(
    id: 2,
    title: 'Fahrenheit 451',
    author: 'Ray Bradbury',
  ),
];

typedef OnSelectBook = void Function(BuildContext context, Book book);

class BooksStack extends StatefulWidget {
  const BooksStack({Key? key, this.onSelectBook}) : super(key: key);

  final OnSelectBook? onSelectBook;

  @override
  _BooksStackState createState() => _BooksStackState();
}

class _BooksStackState extends State<BooksStack>
    with NaviRouteMixin<BooksStack> {
  Book? _selectedBook;

  @override
  void onNewRoute(NaviRoute unprocessedRoute) {
    _selectedBook = null;
    if (unprocessedRoute.hasPrefixes(['books'])) {
      final bookId = int.tryParse(unprocessedRoute.pathSegmentAt(1) ?? '');
      if (bookId != null) {
        _selectedBook = books.firstWhereOrNull((book) => book.id == bookId);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return NaviStack(
      pages: (context) => [
        NaviPage.material(
          key: const ValueKey('Books'),
          route: const NaviRoute(path: ['books']),
          child: BooksPagelet(
            onSelectBook: widget.onSelectBook ??
                (context, book) {
                  setState(() {
                    _selectedBook = book;
                  });
                },
          ),
        ),
        if (_selectedBook != null)
          NaviPage.material(
            key: ValueKey(_selectedBook),
            route: NaviRoute(path: ['books', '${_selectedBook!.id}']),
            child: Text('Book ${_selectedBook!.id}'),
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
  const BooksPagelet({Key? key, this.onSelectBook}) : super(key: key);

  final OnSelectBook? onSelectBook;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
      ),
      body: ListView(
        children: books
            .map((book) => ListTile(
                  key: ValueKey('Book ${book.id}'),
                  title: Text(book.title),
                  subtitle: Text(book.author),
                  onTap: () => onSelectBook?.call(context, book),
                ))
            .toList(),
      ),
    );
  }
}

void main() {
  const booksInitialRoutes = <String>[
    '/',
    '/books',
    '/not-exist',
    '/books///',
    '/books/3',
    '/books/a',
  ];
  for (final initialRoute in booksInitialRoutes) {
    group('GIVEN initial route $initialRoute', () {
      testWidgets('SHOULD shows books pagelet at /books', (tester) async {
        final routeInformationProvider = MockRouteInformationProvider(
          RouteInformation(location: initialRoute),
        );
        final _navigatorKey = GlobalKey<NavigatorState>();

        await tester.pumpWidget(MockApp(
          navigatorKey: _navigatorKey,
          routeInformationProvider: routeInformationProvider,
          child: const BooksStack(),
        ));
        await tester.pumpAndSettle();

        expect(find.text('Books'), findsOneWidget);
        expect(find.byKey(const ValueKey('Book 0')), findsOneWidget);
        expect(find.byKey(const ValueKey('Book 1')), findsOneWidget);
        expect(find.byKey(const ValueKey('Book 2')), findsOneWidget);
        expect(find.byKey(const ValueKey('Book 3')), findsNothing);
        final context = _navigatorKey.currentContext!;
        final currentLocation =
            Router.of(context).routeInformationProvider!.value!.location;
        expect(currentLocation, '/books');
        expect(
          routeInformationProvider.historicalRouterReports
              .map((e) => e.location),
          orderedEquals(<String>[initialRoute, '/books'].toSet()),
        );
      });
    });
  }

  const validSelectedBookIds = <int>[0, 1, 2];
  for (final bookId in validSelectedBookIds) {
    group('GIVEN initial route /books/$bookId', () {
      testWidgets('SHOULD shows book pagelet at /books/$bookId',
          (tester) async {
        final initialRoute = '/books/$bookId';
        final routeInformationProvider = MockRouteInformationProvider(
          RouteInformation(location: initialRoute),
        );
        final _navigatorKey = GlobalKey<NavigatorState>();

        await tester.pumpWidget(MockApp(
          navigatorKey: _navigatorKey,
          routeInformationProvider: routeInformationProvider,
          child: const BooksStack(),
        ));
        await tester.pumpAndSettle();

        expect(find.text('Books'), findsNothing);
        expect(find.text('Book $bookId'), findsOneWidget);
        final context = _navigatorKey.currentContext!;
        final currentLocation =
            Router.of(context).routeInformationProvider!.value!.location;
        expect(currentLocation, initialRoute);
        expect(
          routeInformationProvider.historicalRouterReports
              .map((e) => e.location),
          orderedEquals(<String>[initialRoute]),
        );
      });
    });
  }

  final onSelectBookActions = <String, OnSelectBook?>{
    'declarative': null,
    'imperative context.navi.to': (context, book) =>
        context.navi.to(['books', '${book.id}']),
    'imperative context.navi.relativeTo': (context, book) =>
        context.navi.relativeTo(['${book.id}']),
  };
  for (final onSelectBookActionEntry in onSelectBookActions.entries) {
    testWidgets(
        'tap a book 1 SHOULD navigate (${onSelectBookActionEntry.key})'
        ' to book pagelet at /books/1', (tester) async {
      final routeInformationProvider = MockRouteInformationProvider();
      final _navigatorKey = GlobalKey<NavigatorState>();

      await tester.pumpWidget(MockApp(
        navigatorKey: _navigatorKey,
        routeInformationProvider: routeInformationProvider,
        child: BooksStack(
          onSelectBook: onSelectBookActionEntry.value,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Books'), findsOneWidget);
      expect(find.byKey(const ValueKey('Book 0')), findsOneWidget);
      expect(find.byKey(const ValueKey('Book 1')), findsOneWidget);
      expect(find.byKey(const ValueKey('Book 2')), findsOneWidget);
      expect(find.byKey(const ValueKey('Book 3')), findsNothing);
      var context = _navigatorKey.currentContext!;
      var currentLocation =
          Router.of(context).routeInformationProvider!.value!.location;
      expect(currentLocation, '/books');
      expect(
        routeInformationProvider.historicalRouterReports.map((e) => e.location),
        orderedEquals(<String>['/', '/books']),
      );

      await tester.tap(find.byKey(const ValueKey('Book 1')));
      await tester.pumpAndSettle();

      expect(find.text('Books'), findsNothing);
      expect(find.text('Book 1'), findsOneWidget);
      context = _navigatorKey.currentContext!;
      currentLocation =
          Router.of(context).routeInformationProvider!.value!.location;
      expect(currentLocation, '/books/1');
      expect(
        routeInformationProvider.historicalRouterReports.map((e) => e.location),
        orderedEquals(<String>['/', '/books', '/books/1']),
      );
    });
  }
}
