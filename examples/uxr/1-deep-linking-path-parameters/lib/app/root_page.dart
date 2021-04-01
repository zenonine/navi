import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import 'index.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RouteStack<Book?>(
      marker: BookStackMarker(),
      pages: (context, state) => [
        const MaterialPage<dynamic>(
          key: ValueKey('Books'),
          child: BooksPage(),
        ),
        if (state != null)
          MaterialPage<dynamic>(
            key: ValueKey(state),
            child: BookPage(book: state),
          ),
      ],
      updateStateOnNewRoute: (routeInfo) {
        if (routeInfo.isPrefixed(['books'])) {
          final bookId = int.tryParse(routeInfo.pathSegmentAt(1) ?? '');
          if (bookId != null) {
            return books.firstWhereOrNull((book) => book.id == bookId);
          }
        }
      },
      updateRouteOnNewState: (state) => RouteInfo(
        pathSegments: state != null ? ['books', '${state.id}'] : ['books'],
      ),
      updateStateBeforePop: (context, route, dynamic result, state) => null,
    );
  }
}

class BookStackMarker extends StackMarker<Book?> {}
