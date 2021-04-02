import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import 'index.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RouteStack<RootStackId>(
      marker: RootStackMarker(),
      pages: (context, state) {
        switch (state) {
          case RootStackId.authors:
            return [
              MaterialPage<dynamic>(
                key: const ValueKey('Authors'),
                child: AuthorsStack(),
              )
            ];
          case RootStackId.books:
          default:
            return [
              MaterialPage<dynamic>(
                key: const ValueKey('Books'),
                child: BooksStack(),
              )
            ];
        }
      },
      updateStateOnNewRoute: (routeInfo) {
        if (routeInfo.isPrefixed(['authors'])) {
          return RootStackId.authors;
        }

        return RootStackId.books;
      },
      updateRouteOnNewState: (state) {
        switch (state) {
          case RootStackId.authors:
            return const RouteInfo(pathSegments: ['authors']);
          case RootStackId.books:
          default:
            return const RouteInfo(pathSegments: ['books']);
        }
      },
    );
  }
}

enum RootStackId { books, authors }

class RootStackMarker extends StackMarker<RootStackId> {}
