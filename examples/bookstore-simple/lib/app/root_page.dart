import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import 'index.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RouteStack<RootStackState>(
      marker: RootStackMarker(),
      pages: (context, state) => [
        MaterialPage<dynamic>(
          key: const ValueKey('Books'),
          child: BooksPage(),
        ),
        if (state.book != null)
          MaterialPage<dynamic>(
            key: ValueKey(state.book),
            child: BookPage(
              book: state.book!,
              tab: state.tab,
            ),
          ),
      ],
      updateStateOnNewRoute: (routeInfo) {
        final bookId = int.tryParse(routeInfo.pathSegmentAt(0) ?? '');
        final tab = fromBookTabName(routeInfo.queryParams['tab']?.firstOrNull);

        return RootStackState(
          book: books.firstWhereOrNull((book) => book.id == bookId),
          tab: tab,
        );
      },
      updateRouteOnNewState: (state) {
        final bookId = state.book?.id;
        if (bookId != null) {
          return RouteInfo(
            pathSegments: ['$bookId'],
            queryParams: {
              'tab': [bookTabName(state.tab ?? defaultBookTab)]
            },
          );
        }

        return const RouteInfo();
      },
      updateStateBeforePop: (context, route, dynamic result, state) =>
          const RootStackState(),
    );
  }
}

class RootStackMarker extends StackMarker<RootStackState> {}

class RootStackState {
  const RootStackState({this.book, this.tab});

  final Book? book;
  final BookTab? tab;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RootStackState &&
          runtimeType == other.runtimeType &&
          book == other.book &&
          tab == other.tab;

  @override
  int get hashCode => book.hashCode ^ tab.hashCode;

  @override
  String toString() {
    return 'BookStackState{book: $book, tab: $tab}';
  }
}
