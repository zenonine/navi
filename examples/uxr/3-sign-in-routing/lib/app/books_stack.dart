import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import 'index.dart';

class BooksStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RouteStack<bool>(
      marker: BookStackMarker(),
      pages: (context, state) => [
        MaterialPage<dynamic>(
          key: const ValueKey('Home'),
          child: HomePage(),
        ),
        if (state)
          MaterialPage<dynamic>(
            key: const ValueKey('Books'),
            child: BooksPage(),
          ),
      ],
      updateStateOnNewRoute: (routeInfo) => routeInfo.isPrefixed(['books']),
      updateRouteOnNewState: (state) =>
          RouteInfo(pathSegments: state ? ['books'] : []),
      updateStateBeforePop: (context, route, dynamic result, state) => false,
    );
  }
}

class BookStackMarker extends StackMarker<bool> {}
