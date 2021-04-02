import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import '../index.dart';

class BooksStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RouteStack<Book?>(
      marker: BooksStackMarker(),
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
        final bookId = int.tryParse(routeInfo.pathSegmentAt(0) ?? '');
        return books.firstWhereOrNull((book) => book.id == bookId);
      },
      updateRouteOnNewState: (state) {
        return RouteInfo(pathSegments: state == null ? [] : ['${state.id}']);
      },
      updateStateBeforePop: (context, route, dynamic result, state) => null,
    );
  }
}

class BooksStackMarker extends StackMarker<Book?> {}
